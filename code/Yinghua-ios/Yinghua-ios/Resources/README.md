# Resources

## Assets.xcassets

- **AppIcon** — C24 iOS icon set (3 appearances: default / dark / tinted)
  - Source: `design/_exploration/C24_ios-icon-set/AppIcon.appiconset/`
  - Tinted appearance supports iOS 18 Tinted Icon API
- **AccentColor** — 紫青品牌色 #8A5BFF (light) / #B57BFF (dark)

## 字体

iOS 18 system font stack (no custom fonts in v0.1):
- Display: SF Pro Display (`.system(.largeTitle)`)
- Text: SF Pro Text (`.system(.body)`)
- Mono: SF Mono (`.monospacedDigit()` for timecode)
- Rounded: SF Pro Rounded (`.system(design: .rounded)` for timecode)
