import SwiftUI

/// 映话设计 token（与 design-doc.md §2 一一对应）
/// 与 macOS 端 DesignTokens 保持一致（iOS 端额外补 iOS 18 玻璃 / HIG 圆角 / 间距）
enum Tokens {
    // MARK: - 颜色（与 §2.1 对应）

    enum Color {
        // 主色
        static let purpleVivid = SwiftUI.Color(red: 0.71, green: 0.482, blue: 1.0)   // #B57BFF
        static let purpleMid   = SwiftUI.Color(red: 0.541, green: 0.357, blue: 1.0) // #8A5BFF
        static let purpleDeep  = SwiftUI.Color(red: 0.165, green: 0.071, blue: 0.251) // #2A1240
        static let tealVivid   = SwiftUI.Color(red: 0.176, green: 0.831, blue: 0.749) // #2DD4BF
        static let tealDeep    = SwiftUI.Color(red: 0.055, green: 0.165, blue: 0.165) // #0E2A2A

        // 功能色
        static let recRed      = SwiftUI.Color(red: 1.0,   green: 0.231, blue: 0.188) // #FF3B30
        static let warningOrange = SwiftUI.Color(red: 1.0, green: 0.624, blue: 0.039) // #FF9F0A
        static let successGreen = SwiftUI.Color(red: 0.204, green: 0.78, blue: 0.349)  // #34C759
        static let pink        = SwiftUI.Color(red: 1.0,   green: 0.435, blue: 0.663) // #FF6FA9

        // 中性
        static let nearBlack   = SwiftUI.Color(red: 0.039, green: 0.039, blue: 0.059) // #0A0A0F
        static let graphite    = SwiftUI.Color(red: 0.106, green: 0.114, blue: 0.133) // #1B1D22
        static let warmWhite   = SwiftUI.Color(red: 0.957, green: 0.945, blue: 0.925) // #F4F1EC
        static let secondaryText = warmWhite.opacity(0.8)
        static let tertiaryText  = warmWhite.opacity(0.6)
        static let hairline     = warmWhite.opacity(0.08)

        // Primary 渐变（与 §4.1 Primary 一致：紫青对角线）
        static let primaryGradient = LinearGradient(
            colors: [purpleVivid, tealVivid],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }

    // MARK: - 圆角（§2.3，iOS HIG：iOS 比 macOS 大 4-8px）

    enum Radius {
        static let card: CGFloat = 16
        static let cardLarge: CGFloat = 20
        static let button: CGFloat = 14
        static let chip: CGFloat = 12
        static let input: CGFloat = 10
        static let avatar: CGFloat = 999  // 完全圆
    }

    // MARK: - 间距（§2.4 8pt grid）

    enum Spacing {
        static let xxs: CGFloat = 4
        static let xs:  CGFloat = 8
        static let sm:  CGFloat = 12
        static let md:  CGFloat = 16
        static let lg:  CGFloat = 20
        static let xl:  CGFloat = 24
        static let xxl: CGFloat = 32
        static let xxxl: CGFloat = 48
    }

    // MARK: - iOS 18 HIG 玻璃材质

    enum Material {
        /// 主背景玻璃（iOS 18 ultraThinMaterial 落暖白 8% tint）
        static let chrome = SwiftUI.Material.ultraThinMaterial
    }
}
