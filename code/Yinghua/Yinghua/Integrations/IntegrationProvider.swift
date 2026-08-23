import Foundation

/// 映话支持的第三方集成
///
/// 每个 case 对应一个 C49 的推送通道：
/// - `notion`  → Notion Database API（Bearer token + database id）
/// - `slack`   → Slack Incoming Webhook（Block Kit mrkdwn）
/// - `webhook` → 通用 JSON Webhook（HMAC-SHA256 签名）
///
/// **隐私**：每个 provider 的凭据（API key / URL / secret）**只**走 `KeychainService`，
/// 见 `API/KeychainService.swift`。
enum IntegrationProvider: String, CaseIterable, Identifiable, Codable {
    case notion
    case slack
    case webhook

    var id: String { rawValue }

    /// Settings UI 显示名（中文）
    var displayName: String {
        switch self {
        case .notion:  return "Notion"
        case .slack:   return "Slack"
        case .webhook: return "Custom Webhook"
        }
    }

    /// SF Symbol 图标（macOS 26 全套）
    var iconName: String {
        switch self {
        case .notion:  return "doc.text.fill"
        case .slack:   return "message.fill"
        case .webhook: return "arrow.up.forward.app.fill"
        }
    }

    /// 副标题（Settings card 下方一行说明）
    var subtitle: String {
        switch self {
        case .notion:  return "把 AI 总结写入 Notion 数据库"
        case .slack:   return "推送到 Slack 频道（Incoming Webhook）"
        case .webhook: return "通用 JSON 端点（HMAC-SHA256 签名）"
        }
    }

    /// 该 provider 在 Keychain 里的 account 前缀
    /// 实际存：
    ///   - notion  : `integration.notion.api_key` / `integration.notion.database_id`
    ///   - slack   : `integration.slack.webhook_url`
    ///   - webhook : `integration.webhook.url` / `integration.webhook.secret`
    var keychainPrefix: String {
        "integration.\(rawValue)"
    }
}
