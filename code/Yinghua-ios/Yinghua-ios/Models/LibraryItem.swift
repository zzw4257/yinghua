import Foundation

/// Library 单条记录（iOS HomeView 列表用）
/// - 与 macOS 端 `MeetingRecord` 字段对齐（subset）
/// - 演示用占位数据，真实数据后续从同步服务或本地存储拉
struct LibraryItem: Identifiable, Hashable, Codable {
    let id: UUID
    let title: String
    let recordedAt: Date
    let durationSeconds: TimeInterval
    let speakers: [Speaker]
    let summary: MeetingSummary

    init(
        id: UUID = UUID(),
        title: String,
        recordedAt: Date,
        durationSeconds: TimeInterval,
        speakers: [Speaker],
        summary: MeetingSummary
    ) {
        self.id = id
        self.title = title
        self.recordedAt = recordedAt
        self.durationSeconds = durationSeconds
        self.speakers = speakers
        self.summary = summary
    }

    /// 人类可读时长（"48 min" / "1h 12m"）
    var durationLabel: String {
        let total = Int(durationSeconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        if h > 0 {
            return "\(h)h \(m)m"
        }
        return "\(m) min"
    }

    /// 人类可读日期（iOS 18 `Date.formatted`）
    var dateLabel: String {
        recordedAt.formatted(date: .abbreviated, time: .shortened)
    }

    /// 演示用 5 条占位数据
    static let demo: [LibraryItem] = {
        let cal = Calendar.current
        let now = Date()
        return [
            LibraryItem(
                title: "张三 — 前端 — 终面",
                recordedAt: cal.date(byAdding: .hour, value: -2, to: now)!,
                durationSeconds: 48 * 60,
                speakers: Speaker.demoSpeakers,
                summary: .preview
            ),
            LibraryItem(
                title: "李四 — 后端 — 二面",
                recordedAt: cal.date(byAdding: .day, value: -1, to: now)!,
                durationSeconds: 62 * 60,
                speakers: Speaker.demoSpeakers,
                summary: .preview
            ),
            LibraryItem(
                title: "王五 — 算法 — 一面",
                recordedAt: cal.date(byAdding: .day, value: -3, to: now)!,
                durationSeconds: 38 * 60,
                speakers: Speaker.demoSpeakers,
                summary: .preview
            ),
            LibraryItem(
                title: "产品组周会",
                recordedAt: cal.date(byAdding: .day, value: -5, to: now)!,
                durationSeconds: 75 * 60,
                speakers: Speaker.demoSpeakers,
                summary: .preview
            ),
            LibraryItem(
                title: "导师 1:1",
                recordedAt: cal.date(byAdding: .day, value: -7, to: now)!,
                durationSeconds: 30 * 60,
                speakers: Speaker.demoSpeakers,
                summary: .preview
            ),
        ]
    }()
}
