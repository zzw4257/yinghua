import Foundation

/// Slack 集成：把会议总结推送到 Slack Incoming Webhook
///
/// **协议**：[Slack Incoming Webhooks](https://api.slack.com/messaging/webhooks)
/// - 端点：`https://hooks.slack.com/services/T.../B.../...`（用户配置）
/// - POST JSON，body 用 [Block Kit](https://api.slack.com/block-kit)
/// - 响应：纯文本 "ok" / 错误时返回错误 message
///
/// **凭据**：通过 `KeychainService` 存
/// - `integration.slack.webhook_url` — 完整 Slack Incoming Webhook URL
///
/// **Block Kit 构造**（按 Slack 限制 50 blocks 上限，我们 4-6 个安全范围内）：
/// 1. `header` — 映话 · {fileName}
/// 2. `context` — 录制时间
/// 3. `section` (mrkdwn) — *关键瞬间* 列表
/// 4. `section` (mrkdwn) — *已决定的* 列表
/// 5. `section` (mrkdwn) — *待办* 列表
/// 6. `section` (mrkdwn) — *遗留问题* 列表
@MainActor
final class SlackIntegration {
    private static let slackHost = "hooks.slack.com"

    /// 是否已配置好 webhook URL
    var isConfigured: Bool {
        guard let url = readWebhookURL() else { return false }
        return isSlackURL(url)
    }

    // MARK: - Push

    /// 推送会议总结到 Slack
    /// - Throws: `IntegrationError.notConfigured` / `IntegrationError.httpError` / `IntegrationError.insecureEndpoint`
    func push(
        _ summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) async throws {
        guard let url = readWebhookURL() else {
            throw IntegrationError.notConfigured(
                provider: .slack,
                missing: "Webhook URL（Settings → Integrations → Slack）"
            )
        }

        // 强制 HTTPS + Slack host（防用户把 webhook URL 填成第三方 endpoint 被劫持）
        guard isSlackURL(url) else {
            throw IntegrationError.insecureEndpoint(
                "Slack Webhook URL 必须指向 \(Self.slackHost)，当前是 \(url.host ?? "nil")"
            )
        }
        guard url.scheme?.lowercased() == "https" else {
            throw IntegrationError.insecureEndpoint(
                "Slack Webhook URL 必须使用 HTTPS"
            )
        }

        let body = buildBody(summary: summary, fileName: fileName, recordedAt: recordedAt)

        var request = URLRequest(url: url, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        try NotionIntegration.validate(
            provider: .slack,
            data: data,
            response: response,
            fallback: "Slack Webhook 调用失败"
        )
    }

    // MARK: - Body 构造

    private func buildBody(
        summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) -> [String: Any] {
        // plain_text fallback（推送通知 / 屏幕阅读器 / 不支持 Block Kit 的客户端）
        let plain = Self.buildPlainText(summary: summary, fileName: fileName)

        var blocks: [[String: Any]] = []

        // 1. header
        blocks.append([
            "type": "header",
            "text": [
                "type": "plain_text",
                "text": "映话 · \(fileName)",
                "emoji": true
            ]
        ])

        // 2. context（录制时间）
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        blocks.append([
            "type": "context",
            "elements": [
                [
                    "type": "mrkdwn",
                    "text": "🕒 \(formatter.string(from: recordedAt))"
                ]
            ]
        ])

        // 3-6. sections
        blocks.append(sectionBlock(heading: "关键瞬间", emoji: "🔑", items: summary.keyMoments))
        blocks.append(sectionBlock(heading: "已决定的", emoji: "✅", items: summary.decisions))
        blocks.append(sectionBlock(heading: "待办", emoji: "📋", items: summary.actionItems))
        blocks.append(sectionBlock(heading: "遗留问题", emoji: "❓", items: summary.openQuestions))

        return [
            "text": plain,  // 通知 fallback
            "blocks": blocks
        ]
    }

    private func sectionBlock(heading: String, emoji: String, items: [String]) -> [String: Any] {
        let body: String
        if items.isEmpty {
            body = "（无）"
        } else {
            // Slack mrkdwn 用 • 当列表符（避免 markdown list 在 mrkdwn 里被破坏）
            body = items.map { "• \($0)" }.joined(separator: "\n")
        }
        return [
            "type": "section",
            "text": [
                "type": "mrkdwn",
                "text": "*\(emoji) \(heading)*\n\(body)"
            ]
        ]
    }

    private static func buildPlainText(
        summary: MeetingSummary,
        fileName: String
    ) -> String {
        var lines: [String] = ["映话 · \(fileName)"]
        if !summary.keyMoments.isEmpty {
            lines.append("关键瞬间：")
            lines.append(contentsOf: summary.keyMoments.map { "  - \($0)" })
        }
        if !summary.actionItems.isEmpty {
            lines.append("待办：")
            lines.append(contentsOf: summary.actionItems.map { "  - \($0)" })
        }
        return lines.joined(separator: "\n")
    }

    // MARK: - URL 校验

    /// 校验 URL 是 Slack 官方 host
    private func isSlackURL(_ url: URL) -> Bool {
        guard let host = url.host?.lowercased() else { return false }
        return host == Self.slackHost || host.hasSuffix(".\(Self.slackHost)")
    }

    // MARK: - Keychain

    private func readWebhookURL() -> URL? {
        let account = "integration.slack.webhook_url"
        do {
            guard let raw = try KeychainService.loadString(account: account),
                  !raw.isEmpty else {
                return nil
            }
            return URL(string: raw)
        } catch {
            return nil
        }
    }
}
