import Foundation

extension Speaker {
    /// 给定 id 找 speaker（iOS 端简化版：仅查 demoSpeakers）
    static func speaker(forId id: String) -> Speaker? {
        Self.demoSpeakers.first { $0.id == id }
    }

    /// iOS 端演示用 2 个说话人
    static let demoSpeakers: [Speaker] = [
        Speaker(id: "interviewer", name: "面试官", color: .purple, isLocal: false),
        Speaker(id: "me",         name: "我",     color: .teal,   isLocal: true),
    ]
}
