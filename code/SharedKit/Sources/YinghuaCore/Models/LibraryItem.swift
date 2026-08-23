import Foundation

/// Library 单条记录（macOS HomeView / iOS HomeView 列表通用）
public struct LibraryItem: Identifiable, Hashable, Codable, Sendable {
    public let id: UUID
    public let title: String
    public let recordedAt: Date
    public let durationSeconds: TimeInterval
    public let speakers: [Speaker]
    public let summary: MeetingSummary

    public init(
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
    public var durationLabel: String {
        let total = Int(durationSeconds)
        let h = total / 3600
        let m = (total % 3600) / 60
        if h > 0 {
            return "\(h)h \(m)m"
        }
        return "\(m) min"
    }

    /// 人类可读日期（iOS 18 `Date.formatted` / macOS 26 `Date.formatted`）
    public var dateLabel: String {
        recordedAt.formatted(date: .abbreviated, time: .shortened)
    }
}
