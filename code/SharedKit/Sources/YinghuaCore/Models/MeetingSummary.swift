import Foundation

/// AI 总结：4 段式（与 D1 §4.6 + §5 review-mode 对应）
public struct MeetingSummary: Codable, Hashable, Sendable {
    public let keyMoments: [String]
    public let decisions: [String]
    public let actionItems: [String]
    public let openQuestions: [String]

    public init(
        keyMoments: [String],
        decisions: [String],
        actionItems: [String],
        openQuestions: [String]
    ) {
        self.keyMoments = keyMoments
        self.decisions = decisions
        self.actionItems = actionItems
        self.openQuestions = openQuestions
    }

    public static let empty = MeetingSummary(
        keyMoments: [],
        decisions: [],
        actionItems: [],
        openQuestions: []
    )

    /// 给定（假装）AI 总结，演示用占位数据
    public static let preview = MeetingSummary(
        keyMoments: [
            "候选人在系统设计题中提出用 LRU 缓存 + 写穿策略处理热 key。",
            "面试官追问 CAP 三选二，候选人准确说出对一致性场景下选 CP 而非 AP。",
            "候选人 12 分钟内完成 medium 难度编码，反向给面试官讲了一题。",
        ],
        decisions: [
            "通过技术一面，进入二面（系统设计 + 行为面）。",
        ],
        actionItems: [
            "HR 在 24h 内发 follow-up 邮件 + 二面时间。",
            "候选人准备一段 5 分钟的项目 deep-dive。",
        ],
        openQuestions: [
            "候选人 base 城市是否接受杭州？",
            "能否在下季度前到岗？",
        ]
    )
}
