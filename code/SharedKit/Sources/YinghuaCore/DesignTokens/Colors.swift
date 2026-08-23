#if canImport(SwiftUI)
import SwiftUI

/// 映话设计 token — 颜色（与 design-doc.md §2.1 一一对应）
///
/// macOS + iOS 共享同一份 token 集合。
/// SwiftUI 平台专属 token（macOS 窗口圆角 / iOS 玻璃材质）由调用方在本地
/// `Tokens` 命名空间里覆盖。
public extension Color {
    // MARK: - 主色
    static let yinghuaPurpleVivid = Color(red: 0.71,  green: 0.482, blue: 1.0)    // #B57BFF
    static let yinghuaPurpleMid   = Color(red: 0.541, green: 0.357, blue: 1.0)    // #8A5BFF
    static let yinghuaPurpleDeep  = Color(red: 0.165, green: 0.071, blue: 0.251)  // #2A1240
    static let yinghuaTealVivid   = Color(red: 0.176, green: 0.831, blue: 0.749)  // #2DD4BF
    static let yinghuaTealDeep    = Color(red: 0.055, green: 0.165, blue: 0.165)  // #0E2A2A

    // MARK: - 功能色
    static let yinghuaRecRed        = Color(red: 1.0,   green: 0.231, blue: 0.188) // #FF3B30
    static let yinghuaWarningOrange = Color(red: 1.0,   green: 0.624, blue: 0.039) // #FF9F0A
    static let yinghuaSuccessGreen  = Color(red: 0.204, green: 0.78,  blue: 0.349) // #34C759
    static let yinghuaPink          = Color(red: 1.0,   green: 0.435, blue: 0.663) // #FF6FA9

    // MARK: - 中性
    static let yinghuaNearBlack     = Color(red: 0.039, green: 0.039, blue: 0.059) // #0A0A0F
    static let yinghuaGraphite      = Color(red: 0.106, green: 0.114, blue: 0.133) // #1B1D22
    static let yinghuaWarmWhite     = Color(red: 0.957, green: 0.945, blue: 0.925) // #F4F1EC

    // MARK: - 文本 / 描边（半透明层叠在 warmWhite 上）
    /// 一级文本：100% 暖白
    static var yinghuaPrimaryText: Color   { yinghuaWarmWhite }
    /// 二级文本：80% 暖白
    static var yinghuaSecondaryText: Color { yinghuaWarmWhite.opacity(0.8) }
    /// 三级文本：60% 暖白
    static var yinghuaTertiaryText: Color  { yinghuaWarmWhite.opacity(0.6) }
    /// 1px hairline：8% 暖白
    static var yinghuaHairline: Color      { yinghuaWarmWhite.opacity(0.08) }

    // MARK: - 渐变（§4.1 Primary：紫青对角线）
    /// 紫 → 青对角线渐变
    static let yinghuaPrimaryGradient = LinearGradient(
        colors: [yinghuaPurpleVivid, yinghuaTealVivid],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}

#endif
