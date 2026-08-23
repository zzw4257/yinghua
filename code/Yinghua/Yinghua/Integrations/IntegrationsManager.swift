import Foundation
import Combine

/// 集成管理器：会议总结生成完成后，自动推送到所有启用的第三方集成
///
/// **职责**
/// - 维护 `enabledProviders`（持久化到 `UserDefaults`，key: `yinghua.integrations.enabled`）
/// - 并发 fan-out：所有启用的 provider 同时推送（不阻塞总结展示）
/// - 错误聚合：每个 provider 失败独立捕获，不影响其他 provider
///
/// **线程**
/// - `@MainActor` 上做 UI 状态变更
/// - HTTP 请求在 main actor 上 await（与 `SummaryService` 一致；push 是低频事件，可接受）
@MainActor
final class IntegrationsManager: ObservableObject {
    // MARK: - Published

    /// 用户启用的 provider 集合（Settings toggle 写入）
    @Published private(set) var enabledProviders: Set<IntegrationProvider> = []

    /// 最近一次推送的结果（用于 Settings 卡片状态展示）
    @Published private(set) var lastResult: PushResult = .idle

    /// 启用状态持久化 key
    static let enabledDefaultsKey = "yinghua.integrations.enabled"

    // MARK: - 依赖

    private let notionService = NotionIntegration()
    private let slackService = SlackIntegration()
    private let webhookService = WebhookIntegration()

    init() {
        loadEnabled()
    }

    // MARK: - 启用状态

    /// 从 `UserDefaults` 加载启用集合
    func loadEnabled() {
        let raw = UserDefaults.standard.string(forKey: Self.enabledDefaultsKey) ?? ""
        let parsed: Set<IntegrationProvider> = Set(
            raw.split(separator: ",")
                .compactMap { IntegrationProvider(rawValue: String($0)) }
        )
        enabledProviders = parsed
    }

    /// 设置某个 provider 是否启用（UI toggle 触发）
    func setEnabled(_ provider: IntegrationProvider, enabled: Bool) {
        if enabled {
            enabledProviders.insert(provider)
        } else {
            enabledProviders.remove(provider)
        }
        persistEnabled()
    }

    /// 是否至少有一个 provider 已配置好凭据（用于在 Settings 显示整体状态）
    var anyConfigured: Bool {
        notionService.isConfigured
            || slackService.isConfigured
            || webhookService.isConfigured
    }

    /// 列出"启用了但还没配置"的 provider（用于 UI 提示）
    var enabledButUnconfigured: [IntegrationProvider] {
        IntegrationProvider.allCases.filter { provider in
            guard enabledProviders.contains(provider) else { return false }
            return !isConfigured(provider)
        }
    }

    /// 是否某个 provider 已配置好凭据
    func isConfigured(_ provider: IntegrationProvider) -> Bool {
        switch provider {
        case .notion:  return notionService.isConfigured
        case .slack:   return slackService.isConfigured
        case .webhook: return webhookService.isConfigured
        }
    }

    // MARK: - Push（核心）

    /// 把会议总结推送到所有启用的 provider
    ///
    /// - 不抛错：所有错误聚合到 `lastResult`，方便上层 toast
    /// - 失败一个 provider 不会阻断其他
    /// - 没有启用任何 provider 时 no-op
    ///
    /// - Parameters:
    ///   - summary: AI 生成的总结
    ///   - fileName: 该会议的展示名（推到 Notion 时作为页面 title / 推到 Slack 时作为 header）
    ///   - recordedAt: 录制时间（推到 webhook 时作为 `recordedAt` ISO8601 字段）
    func pushSummary(
        _ summary: MeetingSummary,
        fileName: String,
        recordedAt: Date = .now
    ) async {
        guard !enabledProviders.isEmpty else {
            // 没启用任何集成 → 静默 no-op（避免污染 UI）
            return
        }

        let snapshot = enabledProviders  // 防止 await 期间被 toggle 改掉
        var errors: [String] = []
        var pushed: [IntegrationProvider] = []

        // 并发推送：所有启用的 provider 一起跑
        await withTaskGroup(of: (IntegrationProvider, Result<Void, Error>).self) { group in
            for provider in snapshot {
                group.addTask { [self] in
                    do {
                        try await self.pushOne(
                            provider: provider,
                            summary: summary,
                            fileName: fileName,
                            recordedAt: recordedAt
                        )
                        return (provider, .success(()))
                    } catch {
                        return (provider, .failure(error))
                    }
                }
            }

            for await (provider, result) in group {
                switch result {
                case .success:
                    pushed.append(provider)
                case .failure(let err):
                    errors.append("\(provider.displayName): \(err.localizedDescription)")
                }
            }
        }

        // 写回 lastResult（主线程）
        if errors.isEmpty {
            let names = pushed.map(\.displayName).joined(separator: " · ")
            lastResult = .success(pushed: pushed, message: "已推送到 \(names)")
        } else if pushed.isEmpty {
            lastResult = .failure(errors: errors)
        } else {
            // 部分成功
            let names = pushed.map(\.displayName).joined(separator: " · ")
            lastResult = .partial(
                pushed: pushed,
                errors: errors,
                message: "已推 \(names)；失败：\(errors.joined(separator: " / "))"
            )
        }
    }

    // MARK: - 内部

    private func pushOne(
        provider: IntegrationProvider,
        summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) async throws {
        switch provider {
        case .notion:
            try await notionService.push(summary, fileName: fileName, recordedAt: recordedAt)
        case .slack:
            try await slackService.push(summary, fileName: fileName, recordedAt: recordedAt)
        case .webhook:
            try await webhookService.push(summary, fileName: fileName, recordedAt: recordedAt)
        }
    }

    private func persistEnabled() {
        let raw = enabledProviders
            .map(\.rawValue)
            .sorted()
            .joined(separator: ",")
        UserDefaults.standard.set(raw, forKey: Self.enabledDefaultsKey)
    }

    // MARK: - 测活（Settings "Test push" 按钮用）

    /// 推送一个最小测试 payload 到指定 provider，验证凭据 + 端点
    /// - Returns: 成功 → nil；失败 → error message
    @discardableResult
    func testPush(provider: IntegrationProvider) async -> String? {
        let probe = MeetingSummary(
            keyMoments: ["[映话 Test Push] 配置正常 — 这是测试条目"],
            decisions: [],
            actionItems: [],
            openQuestions: []
        )
        do {
            try await pushOne(
                provider: provider,
                summary: probe,
                fileName: "映话 · Test Push",
                recordedAt: .now
            )
            return nil
        } catch {
            return error.localizedDescription
        }
    }
}

// MARK: - 推送结果

extension IntegrationsManager {
    enum PushResult: Equatable {
        case idle
        case success(pushed: [IntegrationProvider], message: String)
        case partial(pushed: [IntegrationProvider], errors: [String], message: String)
        case failure(errors: [String])

        var message: String? {
            switch self {
            case .idle: return nil
            case .success(_, let m), .partial(_, _, let m): return m
            case .failure(let errs): return errs.joined(separator: " / ")
            }
        }

        var isError: Bool {
            switch self {
            case .failure: return true
            default: return false
            }
        }
    }
}
