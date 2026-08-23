# B6 · 资产-代码绑定策略

> 用途：定义映话 (Yìnghuà) 的设计资产（图片 / 视频 / 字体 / 颜色 / 文案）怎么在代码里被引用——哪些是 build-time 资源，哪些是 runtime 资源。

## 资产分类

| 类别 | 例子 | 引用时机 | 引用方式 |
|---|---|---|---|
| **build-time 图标** | App icon / menu bar icon / dock icon / DMG background | 编译时 | Xcode Assets.xcassets（PNG） |
| **build-time 字体** | Inter / Noto Serif SC / JetBrains Mono | 编译时 | .otf / .ttf 加到 bundle，Info.plist `ATSApplicationFontsPath` |
| **build-time 颜色** | AccentColor / BrandColor | 编译时 | Assets.xcassets 的 .colorset（hex + light/dark variants） |
| **build-time 静态图** | onboarding 插画 / marketing 内嵌图 | 编译时 | Assets.xcassets 1x/2x/3x |
| **build-time 视频** | 启动视频 / 引导视频 | 编译时 | .mp4 / .mov 加到 bundle |
| **build-time 文案** | 全部 UI 字符串 | 编译时 | `Localizable.strings` (en/ja/ko/zh-CN) + Swift `String(localized:)` |
| **runtime 资产** | 用户上传的知识库文档 / 用户录制的会议音频 | 运行时 | Application Support 目录 / 用户指定位置 |
| **runtime 远端资产** | 远端 LLM 响应 / 远端 STT 流 | 运行时 | WebSocket / SSE |
| **design-time 资产** | Figma source / 原始 PSD | 设计时 | Figma 链接 / 本地 archive，**不进 bundle** |

## SwiftUI / AppKit 引用模式

### 颜色（从 design token JSON 自动生成）

```swift
// Source: design-tokens.json
extension Color {
    static let ink0 = Color(lightHex: 0xF5F2FA, darkHex: 0xF5F2FA)
    static let accent1 = Color(lightHex: 0x7B3FE4, darkHex: 0x7B3FE4)
    static let auroraCyan = Color(lightHex: 0x2EE6E0, darkHex: 0x2EE6E0)
}
```

- 颜色 hex 一律从 `design-tokens.json` 读，**不要硬编码在 .swift 里**
- 实施时用 Swift script 把 `design-tokens.json` → `Colors.swift`

### 字体

```swift
// Info.plist: ATSApplicationFontsPath = "Fonts"
extension Font {
    static let displayBold = Font.custom("InterDisplay-Bold", size: 40)
    static let body = Font.custom("Inter-Regular", size: 14)
    static let mono = Font.monospaced(.body, design: .monospaced)
}
```

- 字体文件一律放 `Resources/Fonts/`
- 实施时用 Swift script 把 `design-tokens.json` 的 font 段 → `Fonts.swift`

### 图标

- App icon：直接拖到 Assets.xcassets 的 `AppIcon.appiconset`
- SF Symbol 优先；自定义图标用 SVG → 描画到 PDF → 加到 Assets.xcassets
- 菜单栏 icon：18x18 PNG 模板（template=true）放 `Assets.xcassets/MenuBar/`

### 文案

```swift
// Localizable.strings (zh-CN, en, ja, ko)
"onboarding.welcome.title" = "你好，我是映话";
"onboarding.welcome.subtitle" = "为 macOS 26 而生的面试 / 会议实时助手。";

// Swift 调用
Text("onboarding.welcome.title")
```

- 所有 UI 文案走 `Localizable.strings`
- 实施时用 script 同步 `voice/` 目录下的最终文案 → 各语言 `.strings`
- 4 个语种必有：zh-CN / en / ja / ko
- 主语种 zh-CN 在 `_exploration/C13_voice/` 收敛后定

### 视频

- 启动视频：放 `Resources/Videos/launch.mp4`，SwiftUI `VideoPlayer(player: AVPlayer(url:))`
- 营销视频：放官网 / Notion，不进 bundle

## Runtime 资源路径

```
~/Library/Application Support/Yinghua/
  KnowledgeBase/                # NLEmbedding 索引
    index.json
  Recordings/                   # 用户会议音频
    2026-08-22_14-30-00/
      system.caf
      mic.caf
      transcript.json
      summary.md
  Cache/                        # 临时缓存
    thumbnails/
  Logs/                         # 崩溃日志
```

- 所有 runtime 资源都进 Application Support（不污染 Documents）
- 用户可在 Settings 里改**部分路径**（如导出目录）——但 Application Support 内部路径不能改

## Bundle 大小估算

| 资产 | 大小 |
|---|---|
| App icon (全套) | ~5 MB |
| 字体（3 套） | ~10 MB |
| 启动视频（8s 1080p） | ~15 MB |
| onboarding 插画（4 张） | ~2 MB |
| 营销内嵌图 | ~3 MB |
| **小计 build-time** | **~35 MB** |
| WhisperKit 模型（用户下载） | ~150 MB（不进 bundle） |
| FluidAudio 模型（用户下载） | ~13 MB（不进 bundle） |

> 映话 v0.1 不在 bundle 里放模型 = 让用户**首次启动时下载**（参考 Parrot 的处理）

## 工具链（实施时用）

- `tools/tokens-to-swift.py`：`design-tokens.json` → `Colors.swift` + `Fonts.swift`
- `tools/strings-sync.py`：`voice/*.md` → `Localizable.strings`（4 个语种）
- `tools/icon-validate.py`：检查 Assets.xcassets 的所有 icon 有 1x/2x/3x

## 不在本规范内

- 多模态生图（见 B1）
- 视频（见 B2）
- 资产版本管理（见 B4）
- 评估（见 B5）
