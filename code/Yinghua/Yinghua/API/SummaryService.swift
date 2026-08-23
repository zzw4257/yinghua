import Foundation

/// AI 总结服务（Anthropic / OpenAI / OpenAI 兼容 custom）
///
/// - 3 个 provider 走不同 endpoint / 不同鉴权 / 不同 body 格式
/// - system prompt 强制要求返回 **4 段 JSON**（keyMoments / decisions / actionItems / openQuestions）
/// - 错误：401 → Invalid key / 429 → Rate limited / 5xx → Server error / 离线 → Offline
@MainActor
final class SummaryService: ObservableObject {
    // MARK: - Published

    @Published private(set) var isGenerating: Bool = false
    @Published var lastError: SummaryError?
    @Published private(set) var lastSummary: MeetingSummary?

    // MARK: - 配置

    struct Config {
        let provider: APIProvider
        let apiKey: String
        /// base endpoint（不含路径），如 `https://api.openai.com`
        let endpoint: URL
        /// 模型名称。空 → 用 provider default
        let model: String
        /// 用于 self-debug / 标识
        let requestTimeout: TimeInterval

        static func resolve(
            provider: APIProvider,
            apiKey: String,
            storedEndpoint: URL?,
            storedModel: String?
        ) throws -> Config {
            guard !apiKey.isEmpty else {
                throw SummaryError.invalidKey
            }
            let endpoint = storedEndpoint ?? provider.defaultEndpoint
            guard let endpoint = endpoint else {
                throw SummaryError.invalidEndpoint
            }
            // **安全 P0-2 修复**：强制 HTTPS。custom endpoint 也不允许 http://
            // —— 一旦走明文 HTTP，Authorization header 里的 API key 会被中间人抓走。
            // 默认 endpoint 已经是 https，但用户填的自定义 endpoint 必须校验。
            guard endpoint.scheme?.lowercased() == "https" else {
                throw SummaryError.insecureEndpoint(
                    "API endpoint must use HTTPS, got \(endpoint.scheme ?? "nil")://\(endpoint.host ?? "")"
                )
            }
            let model = (storedModel?.isEmpty == false ? storedModel : nil) ?? provider.defaultModel
            return Config(
                provider: provider,
                apiKey: apiKey,
                endpoint: endpoint,
                model: model,
                requestTimeout: 60
            )
        }
    }

    // MARK: - 公共

    /// 生成总结
    /// - Parameters:
    ///   - transcript: 转录行
    ///   - provider: API provider
    ///   - apiKey: 来自 Keychain
    ///   - endpoint: 自定义 endpoint（可为 nil → 用 default）
    ///   - model: 自定义 model（可为 nil → 用 default）
    func generateSummary(
        transcript: [TranscriptLine],
        provider: APIProvider,
        apiKey: String,
        endpoint: URL? = nil,
        model: String? = nil
    ) async throws -> MeetingSummary {
        let config = try Config.resolve(
            provider: provider,
            apiKey: apiKey,
            storedEndpoint: endpoint,
            storedModel: model
        )
        return try await generateSummary(transcript: transcript, config: config)
    }

    /// 内部：接收 Config 的重载（方便 Settings "Test connection" 测活）
    func generateSummary(
        transcript: [TranscriptLine],
        config: Config
    ) async throws -> MeetingSummary {
        guard !isGenerating else {
            throw SummaryError.alreadyGenerating
        }
        isGenerating = true
        lastError = nil
        defer { isGenerating = false }

        let transcriptText = formatTranscript(transcript)
        let prompt = Self.userPrompt(transcriptText: transcriptText)

        do {
            let raw = try await callLLM(prompt: prompt, config: config)
            let summary = try parseSummary(raw)
            lastSummary = summary
            return summary
        } catch let error as SummaryError {
            lastError = error
            // **非致命错误上报**（C50）—— 仅在用户 opt-in 时才会上传；opt-out 仍写本地 os.log
            CrashReporter.shared.logNonFatal(error, context: [
                "function": "generateSummary",
                "provider": config.provider.rawValue,
                "model": config.model,
            ])
            throw error
        } catch {
            let wrapped = SummaryError.unknown(error)
            lastError = wrapped
            CrashReporter.shared.logNonFatal(wrapped, context: [
                "function": "generateSummary",
                "provider": config.provider.rawValue,
                "model": config.model,
            ])
            throw wrapped
        }
    }

    /// 测活：仅发一个 minimal request，确认 key + endpoint 通
    func testConnection(config: Config) async throws {
        _ = try await callLLM(
            prompt: "ping",
            config: config,
            isTest: true
        )
    }

    // MARK: - Transcript 格式化

    private func formatTranscript(_ lines: [TranscriptLine]) -> String {
        if lines.isEmpty { return "（无转录内容）" }
        return lines.map { line in
            "[\(line.timecode)] \(line.speakerName): \(line.text)"
        }.joined(separator: "\n")
    }

    // MARK: - LLM 调用

    private func callLLM(
        prompt: String,
        config: Config,
        isTest: Bool = false
    ) async throws -> String {
        // 构造 URL
        let url = config.endpoint
            .appendingPathComponent(isTest ? config.provider.pingPath : config.provider.summaryPath)

        // 构造 body
        let body: Data
        switch config.provider {
        case .anthropic:
            body = try buildAnthropicBody(prompt: prompt, config: config, isTest: isTest)
        case .openai, .custom:
            body = try buildOpenAIBody(prompt: prompt, config: config, isTest: isTest)
        }

        // 构造 request
        var request = URLRequest(url: url, timeoutInterval: config.requestTimeout)
        request.httpMethod = "POST"
        request.httpBody = body
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        // 鉴权
        switch config.provider.authScheme {
        case .bearer:
            request.setValue("Bearer \(config.apiKey)", forHTTPHeaderField: "Authorization")
        case .xAPIKey:
            request.setValue(config.apiKey, forHTTPHeaderField: "x-api-key")
            if config.provider == .anthropic {
                // Anthropic 还要求 anthropic-version header
                request.setValue("2023-06-01", forHTTPHeaderField: "anthropic-version")
            }
        }

        // 发送
        let data: Data
        let response: URLResponse
        do {
            (data, response) = try await URLSession.shared.data(for: request)
        } catch let err as URLError {
            switch err.code {
            case .notConnectedToInternet, .networkConnectionLost, .timedOut, .cannotConnectToHost:
                throw SummaryError.offline
            default:
                throw SummaryError.unknown(err)
            }
        }

        guard let http = response as? HTTPURLResponse else {
            throw SummaryError.unknown(NSError(domain: "Yinghua", code: -1))
        }

        switch http.statusCode {
        case 200...299:
            // 解析响应
            return try parseLLMResponse(data: data, provider: config.provider, isTest: isTest)
        case 401, 403:
            throw SummaryError.invalidKey
        case 429:
            throw SummaryError.rateLimited
        case 500...599:
            throw SummaryError.serverError(http.statusCode)
        case 400:
            // 提取错误信息
            let msg = Self.extractErrorMessage(data: data) ?? "Bad request"
            throw SummaryError.badRequest(msg)
        default:
            let msg = Self.extractErrorMessage(data: data) ?? "HTTP \(http.statusCode)"
            throw SummaryError.unknown(NSError(domain: "Yinghua", code: http.statusCode, userInfo: [NSLocalizedDescriptionKey: msg]))
        }
    }

    private func buildAnthropicBody(
        prompt: String,
        config: Config,
        isTest: Bool
    ) throws -> Data {
        // Anthropic Messages API
        // https://docs.anthropic.com/en/api/messages
        let body: [String: Any] = [
            "model": config.model,
            "max_tokens": isTest ? 32 : 2048,
            "system": Self.systemPrompt,
            "messages": [
                ["role": "user", "content": prompt],
            ],
        ]
        return try JSONSerialization.data(withJSONObject: body, options: [])
    }

    private func buildOpenAIBody(
        prompt: String,
        config: Config,
        isTest: Bool
    ) throws -> Data {
        // OpenAI Chat Completions（custom 也走这个）
        // https://platform.openai.com/docs/api-reference/chat
        let body: [String: Any] = [
            "model": config.model,
            "max_tokens": isTest ? 8 : 2048,
            "messages": [
                ["role": "system", "content": Self.systemPrompt],
                ["role": "user", "content": prompt],
            ],
            // OpenAI 支持 response_format；custom 可能不支持
            // 为了兼容性，**不**强制 json mode，而是在 prompt 里要求 JSON 输出
        ]
        return try JSONSerialization.data(withJSONObject: body, options: [])
    }

    // MARK: - 响应解析

    private func parseLLMResponse(
        data: Data,
        provider: APIProvider,
        isTest: Bool
    ) throws -> String {
        if isTest {
            // 测活只要不抛错就行
            return "ok"
        }
        switch provider {
        case .anthropic:
            // 响应格式: { "content": [{ "type": "text", "text": "..." }] }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let content = json["content"] as? [[String: Any]] else {
                throw SummaryError.malformedResponse
            }
            let text = content
                .compactMap { $0["text"] as? String }
                .joined(separator: "\n")
            return text
        case .openai, .custom:
            // 响应格式: { "choices": [{ "message": { "content": "..." } }] }
            guard let json = try JSONSerialization.jsonObject(with: data) as? [String: Any],
                  let choices = json["choices"] as? [[String: Any]],
                  let first = choices.first,
                  let message = first["message"] as? [String: Any],
                  let text = message["content"] as? String else {
                throw SummaryError.malformedResponse
            }
            return text
        }
    }

    private static func extractErrorMessage(data: Data) -> String? {
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let err = json["error"] as? [String: Any], let msg = err["message"] as? String {
                return msg
            }
            if let msg = json["message"] as? String {
                return msg
            }
        }
        return nil
    }

    // MARK: - 4 段 JSON 解析

    private func parseSummary(_ raw: String) throws -> MeetingSummary {
        // LLM 可能返回 ```json ... ``` 块；先剥掉
        let cleaned = Self.stripCodeFence(raw)
        // 找第一个 { 和最后一个 }（防止 LLM 在前后加了散文）
        guard let start = cleaned.firstIndex(of: "{"),
              let end = cleaned.lastIndex(of: "}") else {
            throw SummaryError.malformedResponse
        }
        let jsonStr = String(cleaned[start...end])

        guard let data = jsonStr.data(using: .utf8) else {
            throw SummaryError.malformedResponse
        }

        let decoder = JSONDecoder()
        do {
            return try decoder.decode(MeetingSummary.self, from: data)
        } catch {
            // 兜底：尝试宽松解析（keyMoments / key_moments 兼容）
            throw SummaryError.malformedResponse
        }
    }

    private static func stripCodeFence(_ text: String) -> String {
        var s = text.trimmingCharacters(in: .whitespacesAndNewlines)
        if s.hasPrefix("```") {
            // 去掉首行 ```json 或 ```
            if let firstNewline = s.firstIndex(of: "\n") {
                s = String(s[firstNewline...])
            }
            if s.hasSuffix("```") {
                s = String(s.dropLast(3))
            }
        }
        return s
    }

    // MARK: - Prompts

    private static let systemPrompt: String = """
你是一名专业的会议 / 面试总结助手。给定一段带有时间和说话人标记的中文或英文转录文本，
请严格按照以下 JSON schema 输出 4 段总结，不要包含任何额外文本、解释、Markdown 包裹、思考过程：

{
  "keyMoments":      [string, ...],  // 关键瞬间：3-6 条最重要的发言 / 决策触发点 / 技术亮点
  "decisions":       [string, ...],  // 达成的决定：明确拍板的事项
  "actionItems":     [string, ...],  // 待办：接下来要做的事（每条格式："<负责人>：<动作> by <时间>"）
  "openQuestions":   [string, ...]   // 遗留问题：没回答的 / 待确认的
}

要求：
1. 严格用 JSON 输出，4 个 key 缺一不可；如果某一类为空，给空数组 [] 而不是省略。
2. 优先保留原文措辞（人名 / 数字 / 术语）。
3. 中文输出，除非原文是英文。
4. 整段输出只包含一个 JSON object，不要有前言或后记。
"""

    private static func userPrompt(transcriptText: String) -> String {
        """
        以下是一段会议转录（带时间码和说话人），请总结：

        \(transcriptText)
        """
    }
}

// MARK: - 错误

enum SummaryError: LocalizedError {
    case invalidKey
    case invalidEndpoint
    /// **P0-2 安全**：endpoint 不是 https，API key 会经明文 HTTP 泄露
    case insecureEndpoint(String)
    case rateLimited
    case serverError(Int)
    case offline
    case badRequest(String)
    case malformedResponse
    case alreadyGenerating
    case unknown(Error)

    var errorDescription: String? {
        switch self {
        case .invalidKey:
            return "Invalid key — 请检查 API key 是否正确"
        case .invalidEndpoint:
            return "Endpoint 不合法"
        case .insecureEndpoint(let detail):
            return "Endpoint 必须使用 HTTPS（防止 API key 经明文 HTTP 泄露）。\(detail)"
        case .rateLimited:
            return "Rate limited — 请求过于频繁，请稍后再试"
        case .serverError(let code):
            return "Server error (\(code)) — 提供方服务器异常"
        case .offline:
            return "Offline — 网络断开，请检查连接"
        case .badRequest(let msg):
            return "请求错误：\(msg)"
        case .malformedResponse:
            return "模型返回的格式无法解析"
        case .alreadyGenerating:
            return "已在生成中"
        case .unknown(let err):
            return "未知错误：\(err.localizedDescription)"
        }
    }
}
