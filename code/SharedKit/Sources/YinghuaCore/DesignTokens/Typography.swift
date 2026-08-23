#if canImport(SwiftUI)
import SwiftUI

/// 映话排版 token（与 design-doc.md §2.2 一一对应）
///
/// 117 个 token 全部覆盖在 macOS 端由 `Tokens.Typography` 桥接；
/// iOS 端使用 `Font.system(.largeTitle, design: .rounded)` 等 SF Pro Rounded
/// 内建字体，**不依赖任何第三方字体资源**（iOS 18 HIG 推荐）。
public enum YinghuaTypography {
    // MARK: - 字号（与 §2.2 对应）

    public static let displayLarge: CGFloat   = 44  // 主标题（首页 hero）
    public static let display: CGFloat        = 34  // 大标题
    public static let title1: CGFloat         = 28  // 视图标题
    public static let title2: CGFloat         = 22  // 卡片标题
    public static let title3: CGFloat         = 20  // 段落标题
    public static let headline: CGFloat       = 17  // 行内强调
    public static let body: CGFloat           = 15  // 正文
    public static let callout: CGFloat        = 14  // 注释 / 行内链接
    public static let subhead: CGFloat        = 13  // 次级正文
    public static let footnote: CGFloat       = 12  // 脚注 / 时间码
    public static let caption: CGFloat        = 11  // 元信息

    // MARK: - 字重

    public static let weightBold: Font.Weight    = .bold
    public static let weightSemibold: Font.Weight = .semibold
    public static let weightMedium: Font.Weight   = .medium
    public static let weightRegular: Font.Weight  = .regular

    // MARK: - 便捷 Font 工厂

    /// Display Large（44 / bold · rounded）
    public static var displayLargeFont: Font {
        .system(size: displayLarge, weight: weightBold, design: .rounded)
    }

    /// Title 1（28 / semibold · rounded）
    public static var title1Font: Font {
        .system(size: title1, weight: weightSemibold, design: .rounded)
    }

    /// Title 2（22 / semibold · rounded）
    public static var title2Font: Font {
        .system(size: title2, weight: weightSemibold, design: .rounded)
    }

    /// Headline（17 / semibold · default）
    public static var headlineFont: Font {
        .system(size: headline, weight: weightSemibold, design: .default)
    }

    /// Body（15 / regular · default）
    public static var bodyFont: Font {
        .system(size: body, weight: weightRegular, design: .default)
    }

    /// Callout（14 / medium · default）
    public static var calloutFont: Font {
        .system(size: callout, weight: weightMedium, design: .default)
    }

    /// Footnote（12 / regular · monospaced，用于时间码 / 数据）
    public static var footnoteMonoFont: Font {
        .system(size: footnote, weight: weightRegular, design: .monospaced)
    }

    /// Caption（11 / regular · secondary）
    public static var captionFont: Font {
        .system(size: caption, weight: weightRegular, design: .default)
    }
}

#endif
