import Foundation
import CryptoKit

/// 通用 Webhook 集成：把会议总结 POST 到用户配置的 JSON 端点
///
/// **Body 格式**：
/// ```json
/// {
///   "event": "yinghua.summary.created",
///   "fileName": "张三-前端-终面",
///   "recordedAt": "2026-08-23T14:30:00Z",
///   "summary": {
///     "keyMoments": [...],
///     "decisions": [...],
///     "actionItems": [...],
///     "openQuestions": [...]
///   }
/// }
/// ```
///
/// **签名（防伪造 / 防回放）**：
/// - Header: `X-Yinghua-Signature: sha256=<hex(hmac_sha256(secret, body))>`
/// - Header: `X-Yinghua-Timestamp: <unix_millis>`
/// - Header: `X-Yinghua-Event: yinghua.summary.created`
/// - Secret 走 `KeychainService`（用户可在 Settings 留空 → 不签名，**不推荐**）
///
/// **接收端验证示例**（Node.js / Cloudflare Workers）：
/// ```js
/// const sig = req.headers.get('X-Yinghua-Signature').replace('sha256=', '');
/// const ok = crypto.timingSafeEqual(
///   sig,
///   crypto.createHmac('sha256', SECRET).update(rawBody).digest('hex')
/// );
/// ```
///
/// **凭据**：
/// - `integration.webhook.url`    — HTTPS endpoint
/// - `integration.webhook.secret` — HMAC shared secret（可空）
@MainActor
final class WebhookIntegration {
    /// 是否已配置好 endpoint URL
    var isConfigured: Bool {
        guard let url = readURL() else { return false }
        return url.scheme?.lowercased() == "https"
    }

    // MARK: - Push

    /// 推送会议总结到自定义 endpoint
    /// - Throws: `IntegrationError.notConfigured` / `IntegrationError.httpError` / `IntegrationError.insecureEndpoint`
    func push(
        _ summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) async throws {
        guard let url = readURL() else {
            throw IntegrationError.notConfigured(
                provider: .webhook,
                missing: "Webhook URL（Settings → Integrations → Custom Webhook）"
            )
        }

        // **安全**：强制 HTTPS
        // —— 否则 HMAC 签名 + URL 都会经明文传输，攻击者可重放。
        guard url.scheme?.lowercased() == "https" else {
            throw IntegrationError.insecureEndpoint(
                "Webhook URL 必须使用 HTTPS，当前是 \(url.scheme ?? "nil")://\(url.host ?? "")"
            )
        }

        let secret = readSecret() ?? ""

        // 1. 序列化 body（**先**拿到 bytes，HMAC 签的是这些 bytes）
        let body: [String: Any] = buildBody(
            summary: summary,
            fileName: fileName,
            recordedAt: recordedAt
        )
        let bodyData = try JSONSerialization.data(
            withJSONObject: body,
            options: [.sortedKeys]  // 排序 key 让签名稳定
        )

        // 2. 构造 request
        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("yinghua-summary/1.0", forHTTPHeaderField: "User-Agent")
        request.setValue("yinghua.summary.created", forHTTPHeaderField: "X-Yinghua-Event")
        request.setValue("\(Int64(recordedAt.timeIntervalSince1970 * 1000))",
                         forHTTPHeaderField: "X-Yinghua-Timestamp")

        // 3. HMAC 签名（可选）
        if !secret.isEmpty {
            let signature = Self.sign(body: bodyData, secret: secret)
            request.setValue("sha256=\(signature)", forHTTPHeaderField: "X-Yinghua-Signature")
        }

        request.httpBody = bodyData

        let (data, response) = try await URLSession.shared.data(for: request)
        try NotionIntegration.validate(
            provider: .webhook,
            data: data,
            response: response,
            fallback: "Webhook 调用失败"
        )
    }

    // MARK: - Body 构造

    private func buildBody(
        summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) -> [String: Any] {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime]

        // summary 字典（避免依赖 MeetingSummary JSON 编码顺序）
        return [
            "event": "yinghua.summary.created",
            "fileName": fileName,
            "recordedAt": isoFormatter.string(from: recordedAt),
            "summary": [
                "keyMoments": summary.keyMoments,
                "decisions": summary.decisions,
                "actionItems": summary.actionItems,
                "openQuestions": summary.openQuestions
            ] as [String: Any]
        ]
    }

    // MARK: - HMAC-SHA256 签名

    /// 对 body bytes 做 HMAC-SHA256，返回小写 hex
    static func sign(body: Data, secret: String) -> String {
        let key = SymmetricKey(data: Data(secret.utf8))
        let mac = HMAC<SHA256>.authenticationCode(for: body, using: key)
        return mac.map { String(format: "%02x", $0) }.joined()
    }

    // MARK: - Keychain

    private func readURL() -> URL? {
        do {
            guard let raw = try KeychainService.loadString(account: "integration.webhook.url"),
                  !raw.isEmpty else {
                return nil
            }
            return URL(string: raw)
        } catch {
            return nil
        }
    }

    private func readSecret() -> String? {
        do {
            guard let raw = try KeychainService.loadString(account: "integration.webhook.secret"),
                  !raw.isEmpty else {
                return nil
            }
            return raw
        } catch {
            return nil
        }
    }
}
