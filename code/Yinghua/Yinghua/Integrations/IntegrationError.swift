import Foundation

/// 集成推送过程中的可恢复错误
///
/// 抛出后会被 `IntegrationsManager.pushSummary` 收集到 errors 列表，
/// 然后在 UI 上提示「Notion: 网络断开」「Slack: HTTP 401」等。
enum IntegrationError: LocalizedError {
    case notConfigured(provider: IntegrationProvider, missing: String)
    case httpError(provider: IntegrationProvider, status: Int, message: String)
    case decoding(message: String)
    case insecureEndpoint(String)

    var errorDescription: String? {
        switch self {
        case .notConfigured(let provider, let missing):
            return "\(provider.displayName) 未配置：缺少 \(missing)。请在 Settings → Integrations 配置。"
        case .httpError(let provider, let status, let message):
            let trimmed = message.count > 200 ? String(message.prefix(200)) + "…" : message
            return "\(provider.displayName) HTTP \(status)：\(trimmed)"
        case .decoding(let message):
            return "响应解析失败：\(message)"
        case .insecureEndpoint(let detail):
            return "Endpoint 必须使用 HTTPS（防止 secret / API key 泄露）。\(detail)"
        }
    }
}
