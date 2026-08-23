import Foundation

/// 转录单行（与 D1 §4.5 Transcript Row 对应）
/// 与 macOS 端 TranscriptLine 完全一致（C37 DTO 一份拷贝）
struct TranscriptLine: Identifiable, Hashable, Codable {
    let id: UUID
    let speakerId: String
    let speakerName: String
    /// 录制内相对时间（秒）
    let timestamp: TimeInterval
    let text: String

    init(
        id: UUID = UUID(),
        speakerId: String,
        speakerName: String,
        timestamp: TimeInterval,
        text: String
    ) {
        self.id = id
        self.speakerId = speakerId
        self.speakerName = speakerName
        self.timestamp = timestamp
        self.text = text
    }

    /// 格式化为 `MM:SS`（iOS transcript row 用）
    var timecode: String {
        let total = Int(timestamp)
        let m = total / 60
        let s = total % 60
        return String(format: "%02d:%02d", m, s)
    }
}
