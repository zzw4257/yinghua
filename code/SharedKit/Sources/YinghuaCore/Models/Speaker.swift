import Foundation

#if canImport(SwiftUI)
import SwiftUI
#endif

/// 说话人身份
/// - `id` 稳定不变，跨场景颜色保持一致
/// - `color` 在 AppState 启动时按 speakerId 从 UserDefaults 读取，缺失则分配并持久化
public struct Speaker: Identifiable, Hashable, Codable, Sendable {
    public let id: String
    public let name: String
    public let color: SpeakerColor
    public let isLocal: Bool

    public init(id: String, name: String, color: SpeakerColor, isLocal: Bool = false) {
        self.id = id
        self.name = name
        self.color = color
        self.isLocal = isLocal
    }
}

/// 4 种允许的 speaker 头像底色（与 D1 §2.1 / §4.3 一致）
public enum SpeakerColor: String, CaseIterable, Codable, Sendable {
    case purple     // #8A5BFF
    case teal       // #2DD4BF
    case pink       // #FF6FA9
    case warmWhite  // #F4F1EC

    #if canImport(SwiftUI)
    public var color: Color {
        switch self {
        case .purple:    return Color(red: 0.541, green: 0.357, blue: 1.0)
        case .teal:      return Color(red: 0.176, green: 0.831, blue: 0.749)
        case .pink:      return Color(red: 1.0,   green: 0.435, blue: 0.663)
        case .warmWhite: return Color(red: 0.957, green: 0.945, blue: 0.925)
        }
    }
    #endif

    /// 是否为浅色（决定首字母字色）
    public var isBright: Bool {
        self == .warmWhite
    }

    /// 给定一个 stable id 分配颜色，保证同 id 跨 session 颜色稳定
    public static func assign(for id: String) -> SpeakerColor {
        let palette: [SpeakerColor] = [.purple, .teal, .pink, .warmWhite]
        // 简单 hash → index；同 id 永远映射到同颜色
        let hash = abs(id.hashValue)
        return palette[hash % palette.count]
    }
}
