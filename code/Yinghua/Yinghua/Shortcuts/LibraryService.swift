import Foundation

/// Library 里的一个会议记录（Shortcuts / App Intents 用）
///
/// **当前状态**：C48 阶段还没有真正写入 manifest 的链路——`AudioCaptureService` 写 `.caf`
/// 但还没有 "title / summary" 的 metadata 文件。这里定义一个最小可用结构：
///
/// - `fileName`: 录音文件名（rec-<timestamp>.caf）
/// - `createdAt`: 创建时间（取文件创建时间）
/// - `fileSizeBytes`: 文件大小
/// - `summary`: 嵌套的 4 段式 AI 总结（可能为 nil——还没生成）
///
/// 后续 C49/C50 如果落地 manifest 文件（如 `<name>.json` sidecar），只需补一个
/// `Codable` 解析分支即可。**Shortcuts 入口对** `summary == nil` **做了显式降级**。
struct LibraryItem: Codable, Hashable, Sendable {
    let fileName: String
    let createdAt: Date
    let fileSizeBytes: Int64
    let summary: MeetingSummary?
}

/// Library 服务：扫 `~/Library/Application Support/Yinghua/recordings/` 找最新录音
///
/// **设计原则**（与 C48 任务边界对齐）：
/// - 不强行构造假数据：summary 在没有 sidecar JSON 时就是 nil，调用方负责降级文案
/// - `@MainActor`：和 AudioCaptureService 一致，避免 Swift 6 并发问题
/// - `latestItem()` 走文件系统 IO，所以是同步 API；调用方在 AppIntent 里包 `Task`
@MainActor
final class LibraryService {
    /// recordings 目录（与 AudioCaptureService.recordingsDirectory 一致）
    private let recordingsURL: URL?

    init() {
        self.recordingsURL = try? AudioCaptureService.recordingsDirectory()
    }

    /// 最近一次会议（按文件 mtime 倒序）
    /// - Returns: 找不到录音返回 nil
    func latestItem() -> LibraryItem? {
        guard let dir = recordingsURL else { return nil }
        let fm = FileManager.default
        guard let entries = try? fm.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey, .creationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return nil }

        let audioFiles = entries.filter { url in
            let ext = url.pathExtension.lowercased()
            return ext == "caf" || ext == "wav" || ext == "m4a"
        }

        // 排序：按 mtime 倒序
        let sorted = audioFiles.sorted { a, b in
            let amtime = (try? a.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            let bmtime = (try? b.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
            return amtime > bmtime
        }

        guard let latest = sorted.first else { return nil }

        let mtime = (try? latest.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
        let ctime = (try? latest.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? mtime
        let size = (try? latest.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0

        return LibraryItem(
            fileName: latest.lastPathComponent,
            createdAt: ctime,
            fileSizeBytes: Int64(size),
            // C48 阶段：还没有 manifest sidecar。如果未来加了 JSON，跟在 .caf 旁边，
            // 用 `<basename>.json` 解析到这里。
            summary: nil
        )
    }

    /// 所有录音（按 mtime 倒序）。当前没有 UI 调用，先放这。
    func allItems() -> [LibraryItem] {
        guard let dir = recordingsURL else { return [] }
        let fm = FileManager.default
        guard let entries = try? fm.contentsOfDirectory(
            at: dir,
            includingPropertiesForKeys: [.contentModificationDateKey, .fileSizeKey, .creationDateKey],
            options: [.skipsHiddenFiles]
        ) else { return [] }

        return entries
            .filter { url in
                let ext = url.pathExtension.lowercased()
                return ext == "caf" || ext == "wav" || ext == "m4a"
            }
            .sorted { a, b in
                let amtime = (try? a.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
                let bmtime = (try? b.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? .distantPast
                return amtime > bmtime
            }
            .map { url in
                let mtime = (try? url.resourceValues(forKeys: [.contentModificationDateKey]).contentModificationDate) ?? Date()
                let ctime = (try? url.resourceValues(forKeys: [.creationDateKey]).creationDate) ?? mtime
                let size = (try? url.resourceValues(forKeys: [.fileSizeKey]).fileSize) ?? 0
                return LibraryItem(
                    fileName: url.lastPathComponent,
                    createdAt: ctime,
                    fileSizeBytes: Int64(size),
                    summary: nil
                )
            }
    }
}
