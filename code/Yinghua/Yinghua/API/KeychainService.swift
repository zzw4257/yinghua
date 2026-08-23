import Foundation
import Security

/// BYOK 凭据存储
///
/// - **绝不**写文件 / **绝不**上传
/// - 用 `kSecClassGenericPassword` + service 隔离不同 app
/// - 每个 provider 存两个 key：
///   - `account = "<provider>.key"`     — API key
///   - `account = "<provider>.endpoint"` — endpoint URL（custom 用，其他可选）
///   - `account = "<provider>.model"`   — model 名称（可选，默认走 defaultModel）
enum KeychainService {
    /// 隔离 service 标识
    static let service = "com.yinghua.apikey"

    enum KeychainError: LocalizedError {
        case unhandled(OSStatus)
        case encoding
        case decoding
        case missing

        var errorDescription: String? {
            switch self {
            case .unhandled(let status):
                return "Keychain 错误（OSStatus \(status)）"
            case .encoding:
                return "Keychain 编码失败"
            case .decoding:
                return "Keychain 解码失败"
            case .missing:
                return "未找到凭据"
            }
        }
    }

    // MARK: - API Key

    /// 保存 API key
    static func saveAPIKey(_ key: String, for provider: APIProvider) throws {
        try saveString(key, account: "\(provider.rawValue).key")
    }

    /// 读取 API key
    static func loadAPIKey(for provider: APIProvider) -> String? {
        try? loadString(account: "\(provider.rawValue).key")
    }

    /// 删除 API key
    static func deleteAPIKey(for provider: APIProvider) {
        deleteItem(account: "\(provider.rawValue).key")
    }

    // MARK: - Endpoint URL（custom 用）

    static func saveEndpoint(_ url: URL?, for provider: APIProvider) throws {
        try saveString(url?.absoluteString, account: "\(provider.rawValue).endpoint")
    }

    static func loadEndpoint(for provider: APIProvider) -> URL? {
        guard let str = try? loadString(account: "\(provider.rawValue).endpoint"),
              !str.isEmpty else { return nil }
        return URL(string: str)
    }

    // MARK: - Model 名称

    static func saveModel(_ model: String?, for provider: APIProvider) throws {
        try saveString(model, account: "\(provider.rawValue).model")
    }

    static func loadModel(for provider: APIProvider) -> String? {
        try? loadString(account: "\(provider.rawValue).model")
    }

    // MARK: - 整体（key + endpoint + model）

    /// 删除该 provider 的所有信息
    static func deleteAll(for provider: APIProvider) {
        deleteItem(account: "\(provider.rawValue).key")
        deleteItem(account: "\(provider.rawValue).endpoint")
        deleteItem(account: "\(provider.rawValue).model")
    }

    /// 是否已配置
    static func hasKey(for provider: APIProvider) -> Bool {
        guard let key = loadAPIKey(for: provider) else { return false }
        return !key.isEmpty
    }

    // MARK: - 底层

    /// 通用 keychain 写：内部实现。
    ///
    /// **C49 集成扩展**：将可见性从 `private` 提升到 `internal`，
    /// 让 `Yinghua/Integrations/` 下的 Notion / Slack / Webhook 集成可直接读写
    /// 各自的 `integration.<provider>.*` 账户。
    /// 上层 API 仍推荐用 `saveAPIKey/loadAPIKey/saveEndpoint/...` 这些有类型保护的封装。
    static func saveString(_ value: String?, account: String) throws {
        guard let value = value, !value.isEmpty else {
            // 空值 → 删除
            deleteItem(account: account)
            return
        }
        guard let data = value.data(using: .utf8) else {
            throw KeychainError.encoding
        }

        // 先尝试 update
        let queryFind: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        let attrs: [String: Any] = [
            kSecValueData as String: data,
            // 当 Keychain 是 iCloud 同步时，文档建议显式更新 label
            kSecAttrLabel as String: "映话 · \(account)",
        ]
        let updateStatus = SecItemUpdate(queryFind as CFDictionary, attrs as CFDictionary)
        if updateStatus == errSecSuccess { return }
        if updateStatus == errSecItemNotFound {
            var addQuery = queryFind
            addQuery[kSecValueData as String] = data
            addQuery[kSecAttrLabel as String] = "映话 · \(account)"
            addQuery[kSecAttrAccessible as String] = kSecAttrAccessibleAfterFirstUnlock
            let addStatus = SecItemAdd(addQuery as CFDictionary, nil)
            if addStatus != errSecSuccess {
                throw KeychainError.unhandled(addStatus)
            }
            return
        }
        throw KeychainError.unhandled(updateStatus)
    }

    /// 通用 keychain 读：内部实现（见 `saveString` 注释，C49 提升为 internal）
    static func loadString(account: String) throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
            kSecReturnData as String: true,
            kSecMatchLimit as String: kSecMatchLimitOne,
        ]
        var result: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &result)
        switch status {
        case errSecSuccess:
            guard let data = result as? Data else { throw KeychainError.decoding }
            guard let str = String(data: data, encoding: .utf8) else { throw KeychainError.decoding }
            return str
        case errSecItemNotFound:
            return nil
        default:
            throw KeychainError.unhandled(status)
        }
    }

    /// 通用 keychain 删：内部实现（见 `saveString` 注释，C49 提升为 internal）
    static func deleteItem(account: String) {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrService as String: service,
            kSecAttrAccount as String: account,
        ]
        SecItemDelete(query as CFDictionary)
    }
}
