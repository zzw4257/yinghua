import Foundation

/// Notion 集成：把会议总结推送到 Notion Database
///
/// **API**：[Notion Pages API](https://developers.notion.com/reference/post-page) — `POST /v1/pages`
/// - Authorization: `Bearer <integration token>`
/// - Notion-Version: `2022-06-28`
///
/// **目标 database schema**（用户在 Notion 端建好后填 database id 即可）：
/// ```
/// Name          : title      （必填，映话写入会议名）
/// Date          : date       （必填，映话写入录制时间）
/// Key Moments   : number     （可选，映话写入关键瞬间条数）
/// Action Items  : number     （可选，映话写入待办条数）
/// ```
/// Key Moments / Action Items 不存在时静默忽略（Notion API 会返回 400 但我们捕获后给出友好错误）
///
/// **凭据**：通过 `KeychainService` 存
/// - `integration.notion.api_key`     — Notion Internal Integration Token（`secret_…`）
/// - `integration.notion.database_id` — 32 位 database id（带不带 dash 都行）
@MainActor
final class NotionIntegration {
    private let apiVersion = "2022-06-28"
    private let baseURL = URL(string: "https://api.notion.com/v1/pages")!

    /// 是否已配置好凭据
    var isConfigured: Bool {
        let key = readKeychain(account: "api_key")
        let db = readKeychain(account: "database_id")
        return !(key?.isEmpty ?? true) && !(db?.isEmpty ?? true)
    }

    // MARK: - Push

    /// 推送会议总结到 Notion database
    /// - Throws: `IntegrationError.notConfigured` / `IntegrationError.httpError`
    func push(
        _ summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) async throws {
        guard let apiKey = readKeychain(account: "api_key"), !apiKey.isEmpty else {
            throw IntegrationError.notConfigured(
                provider: .notion,
                missing: "API key（Settings → Integrations → Notion）"
            )
        }
        guard let databaseId = readKeychain(account: "database_id"), !databaseId.isEmpty else {
            throw IntegrationError.notConfigured(
                provider: .notion,
                missing: "Database ID（Settings → Integrations → Notion）"
            )
        }

        let body = buildBody(
            databaseId: databaseId,
            summary: summary,
            fileName: fileName,
            recordedAt: recordedAt
        )

        var request = URLRequest(url: baseURL, timeoutInterval: 15)
        request.httpMethod = "POST"
        request.setValue("Bearer \(apiKey)", forHTTPHeaderField: "Authorization")
        request.setValue(apiVersion, forHTTPHeaderField: "Notion-Version")
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: body, options: [])

        let (data, response) = try await URLSession.shared.data(for: request)
        try Self.validate(
            provider: .notion,
            data: data,
            response: response,
            fallback: "Notion API 调用失败"
        )
    }

    // MARK: - Body 构造

    private func buildBody(
        databaseId: String,
        summary: MeetingSummary,
        fileName: String,
        recordedAt: Date
    ) -> [String: Any] {
        let isoDate = ISO8601DateFormatter().string(from: recordedAt)
        let children = buildChildren(summary: summary, fileName: fileName)

        return [
            "parent": ["database_id": databaseId],
            "properties": [
                "Name": [
                    "title": [
                        ["type": "text", "text": ["content": fileName]]
                    ]
                ],
                "Date": [
                    "date": ["start": isoDate]
                ],
                "Key Moments": [
                    "number": summary.keyMoments.count
                ],
                "Action Items": [
                    "number": summary.actionItems.count
                ]
            ] as [String: Any],
            "children": children
        ]
    }

    /// 构造 Notion children blocks（heading + bulleted_list_items）
    private func buildChildren(summary: MeetingSummary, fileName: String) -> [[String: Any]] {
        var blocks: [[String: Any]] = []

        // 顶部 header
        blocks.append([
            "object": "block",
            "type": "heading_2",
            "heading_2": [
                "rich_text": [["type": "text", "text": ["content": "映话 · \(fileName)"]]]
            ]
        ])

        // 4 段：每段 = heading_3 + bulleted_list_items
        blocks.append(contentsOf: sectionBlocks(
            heading: "🔑 关键瞬间",
            items: summary.keyMoments
        ))
        blocks.append(contentsOf: sectionBlocks(
            heading: "✅ 已达成的决定",
            items: summary.decisions
        ))
        blocks.append(contentsOf: sectionBlocks(
            heading: "📋 待办",
            items: summary.actionItems
        ))
        blocks.append(contentsOf: sectionBlocks(
            heading: "❓ 遗留问题",
            items: summary.openQuestions
        ))

        return blocks
    }

    /// 一段内容（heading + 列表），空时给一个「（无）」占位
    private func sectionBlocks(heading: String, items: [String]) -> [[String: Any]] {
        var blocks: [[String: Any]] = []
        blocks.append([
            "object": "block",
            "type": "heading_3",
            "heading_3": [
                "rich_text": [["type": "text", "text": ["content": heading]]]
            ]
        ])
        if items.isEmpty {
            blocks.append([
                "object": "block",
                "type": "paragraph",
                "paragraph": [
                    "rich_text": [["type": "text", "text": ["content": "（无）"]]]
                ]
            ])
        } else {
            for item in items {
                blocks.append([
                    "object": "block",
                    "type": "bulleted_list_item",
                    "bulleted_list_item": [
                        "rich_text": [["type": "text", "text": ["content": item]]]
                    ]
                ])
            }
        }
        return blocks
    }

    // MARK: - 响应校验（共享给所有集成）

    static func validate(
        provider: IntegrationProvider,
        data: Data,
        response: URLResponse,
        fallback: String
    ) throws {
        guard let http = response as? HTTPURLResponse else {
            throw IntegrationError.decoding(message: "响应不是合法的 HTTP 响应")
        }

        if (200...299).contains(http.statusCode) {
            return
        }

        // 解析错误信息
        var msg = fallback
        if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
            if let obj = json["message"] as? String {
                msg = obj
            } else if let obj = json["error"] as? [String: Any], let m = obj["message"] as? String {
                msg = m
            }
        }

        throw IntegrationError.httpError(
            provider: provider,
            status: http.statusCode,
            message: msg
        )
    }

    // MARK: - Keychain 包装

    /// 从 Keychain 读 integration 凭据。`try?` + 内部 `String?` 给出 `String??`，
    /// 内部 unwrap 后再判空，避免 "value found but empty" 被当成"已配置"。
    private func readKeychain(account: String) -> String? {
        let fullAccount = "integration.notion.\(account)"
        do {
            guard let raw = try KeychainService.loadString(account: fullAccount) else {
                return nil
            }
            return raw.isEmpty ? nil : raw
        } catch {
            return nil
        }
    }
}
