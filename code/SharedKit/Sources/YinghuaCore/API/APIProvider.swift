import Foundation

/// 3 个 BYOK provider
///
/// - `openai`     — OpenAI 官方 Chat Completions
/// - `anthropic`  — Anthropic Messages API
/// - `custom`     — OpenAI 兼容的第三方 / 自部署 endpoint
public enum APIProvider: String, CaseIterable, Identifiable, Hashable, Codable, Sendable {
    case openai
    case anthropic
    case custom

    public var id: String { rawValue }

    public var displayName: String {
        switch self {
        case .openai:    return "OpenAI"
        case .anthropic: return "Anthropic"
        case .custom:    return "自定义 (OpenAI 兼容)"
        }
    }

    /// 摘要推荐模型
    public var defaultModel: String {
        switch self {
        case .openai:    return "gpt-4o"
        case .anthropic: return "claude-sonnet-4-5"
        case .custom:    return ""
        }
    }

    /// 默认 endpoint（custom 留空让用户填）
    public var defaultEndpoint: URL? {
        switch self {
        case .openai:    return URL(string: "https://api.openai.com")
        case .anthropic: return URL(string: "https://api.anthropic.com")
        case .custom:    return nil
        }
    }

    /// 摘要推荐请求路径
    public var summaryPath: String {
        switch self {
        case .openai:    return "/v1/chat/completions"
        case .anthropic: return "/v1/messages"
        case .custom:    return "/v1/chat/completions"
        }
    }

    /// 测活请求路径（简单 GET）
    public var pingPath: String {
        switch self {
        case .openai:    return "/v1/models"
        case .anthropic: return "/v1/models"
        case .custom:    return "/v1/models"
        }
    }

    /// 鉴权 header scheme
    public var authScheme: AuthScheme {
        switch self {
        case .openai:    return .bearer
        case .anthropic: return .xAPIKey
        case .custom:    return .bearer
        }
    }
}

public enum AuthScheme: Sendable {
    case bearer       // Authorization: Bearer <key>
    case xAPIKey      // x-api-key: <key>
}
