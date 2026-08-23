# 映话 · iOS companion app (C38)

iOS 18+ SwiftUI companion app for the macOS 26 映话 recorder. v0.1 skeleton — 5 screens, tab bar, shared DTO.

## Stack

- **iOS 18+** (deploy target), Xcode 26.6+
- **SwiftUI** (NavigationStack, TabView, Form, DisclosureGroup)
- **@Observable** state (iOS 17+ Observation framework)
- **xcodegen** for project generation — `project.yml` is the single source of truth
- **Shared DTO** (Speaker / TranscriptLine / MeetingSummary) — copies from macOS `code/Yinghua/`

## Build

```bash
cd code/Yinghua-ios
xcodegen generate
xcodebuild \
  -project Yinghua-ios.xcodeproj \
  -scheme Yinghua-ios \
  -configuration Debug \
  -destination 'generic/platform=iOS Simulator' \
  clean build
```

## Structure

```
code/Yinghua-ios/
├── project.yml                    # xcodegen source of truth
├── README.md
└── Yinghua-ios/
    ├── Yinghua-iosApp.swift      # @main + 4-tab RootView
    ├── Info.plist                 # NSCameraUsageDescription etc.
    ├── Yinghua-ios.entitlements
    ├── PrivacyInfo.xcprivacy
    ├── Models/                    # DTO + iOS state
    │   ├── Speaker.swift
    │   ├── TranscriptLine.swift
    │   ├── MeetingSummary.swift
    │   ├── DesignTokens.swift
    │   ├── LibraryItem.swift
    │   ├── RecordingState.swift   # iOSAppState + AppTab
    │   ├── Speaker+Helpers.swift
    │   └── TranscriptLine+Helpers.swift
    ├── Components/
    │   ├── SpeakerAvatar_iOS.swift
    │   └── TranscriptRow_iOS.swift
    ├── Views/
    │   ├── HomeView.swift         # 屏 1 · Library
    │   ├── RecordingView.swift    # 屏 2 · Recording active
    │   ├── SummaryView.swift      # 屏 3 · AI Summary
    │   ├── SettingsView.swift     # 屏 4 · Settings
    │   └── AboutView.swift        # 屏 5 · About
    └── Resources/
        ├── Assets.xcassets/       # AppIcon (C24) + AccentColor
        └── README.md
```

## 5 屏

| # | View | Description |
|---|------|-------------|
| 1 | `HomeView` | Library 列表 + 紫青渐变 Start Recording 按钮 |
| 2 | `RecordingView` | 4 人 avatar 环 + 大字时间码 + 实时 transcript + 3 控制按钮 |
| 3 | `SummaryView` | 文件元信息 + 4 折叠 AI 总结 section + 3 操作按钮 |
| 4 | `SettingsView` | Form 风格：AI Provider / API Key / Permissions / About |
| 5 | `AboutView` | App icon + 名字 + 版本 + 致谢 |

## 视觉规范

- **配色**：与 macOS 端共享 `Tokens.Color`（紫青品牌色 + 暖白文字）
- **圆角**：iOS HIG（16-22px，比 macOS 略大）
- **字体**：iOS 18 system font（SF Pro Display / SF Pro Text / Rounded 数字字）
- **暗色模式**：默认 dark（与 macOS 端一致）
- **prefers-reduced-motion**：v0.1 通过 `withAnimation` 默认遵守

## 下一步 (post-v0.1)

- [ ] 接 macOS 端 native messaging（XPC / Mach ports）
- [ ] 实际接 AVAudioRecorder / SFSpeechRecognizer
- [ ] Library 持久化（CoreData / SwiftData）
- [ ] iOS 18 tinted icon 验证
- [ ] Universal Link 跳 macOS 端
