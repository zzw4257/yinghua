import Foundation

extension TranscriptLine {
    /// iOS 端演示用 transcript lines（与 macOS demo 同步）
    static let demo: [TranscriptLine] = [
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 0,
                       text: "我们直接进入系统设计这一轮。假设你负责一个短链服务，你会怎么设计？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 18,
                       text: "好的，我会拆三层：接入层做流量收敛，生成层用发号器生成 7 位 id，存储层用 KV。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 62,
                       text: "那如果发号器单点怎么办？你会怎么保证 id 不冲突？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 78,
                       text: "我会用 Snowflake 那一类方案，引入 worker id + 序列号，必要时用 Redis 兜底防冲突。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 142,
                       text: "听起来合理。那短链的缓存策略呢？所有长链都缓存还是只缓存热 key？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 158,
                       text: "只缓存热 key。我会用 LRU + 写穿策略，命中率大概能在 95% 以上，存储压力可控。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 230,
                       text: "好。这部分我没什么问题了，最后反问你有什么想问我们的？"),
    ]
}
