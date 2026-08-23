# YinghuaCore · 映话共享 Kit

macOS + iOS 共享的 Swift Package，承载 DTO / API client / 设计 token 等与 UI / 平台无关的代码。

## 平台

| 平台 | 最低版本 | 原因 |
|------|----------|------|
| macOS | 26.0 | 与 `code/Yinghua/` 主 app 对齐（macOS 26+ SpeechAnalyzer / ScreenCaptureKit） |
| iOS   | 18.0  | 与 `code/Yinghua-ios/` 主 app 对齐（iOS 18 Liquid Glass / Observation） |

## 目录

```
Sources/YinghuaCore/
├── Models/          DTO（Speaker / TranscriptLine / MeetingSummary / LibraryItem）
├── API/             KeychainService + APIProvider 枚举
└── DesignTokens/    Color 扩展 + Typography 枚举
```

## 编译

```bash
# macOS
swift build

# iOS Simulator（不需要具体设备）
swift build --triple arm64-apple-ios18.0-simulator \
  --sdk "$(xcrun --sdk iphonesimulator --show-sdk-path)"

# iOS 设备
swift build --triple arm64-apple-ios18.0 \
  --sdk "$(xcrun --sdk iphoneos --show-sdk-path)"

# 测试
swift test
```

## 集成到 iOS app

`code/Yinghua-ios/project.yml` 已声明依赖：

```yaml
packages:
  YinghuaCore:
    path: ../SharedKit

targets:
  Yinghua-ios:
    dependencies:
      - package: YinghuaCore
        product: YinghuaCore
```

使用：

```swift
import YinghuaCore

// 颜色
Text("你好").foregroundStyle(.yinghuaPurpleVivid)

// 字号
Text("标题").font(YinghuaTypography.title1Font)

// DTO
let speaker = Speaker(id: "me", name: "我", color: .teal, isLocal: true)

// Keychain（macOS + iOS 共享）
try KeychainService.saveAPIKey("sk-...", for: .openai)
let key = KeychainService.loadAPIKey(for: .openai)
```

## 设计原则

- **UI 无关**：不引用 SwiftUI 视图，只暴露 Color 扩展 / Font token
- **零外部依赖**：只用 Foundation / Security / SwiftUI
- **严格并发**：`StrictConcurrency = YES`，所有 public 类型 `Sendable`
- **平台兼容**：用 `#if canImport(SwiftUI)` 隔离 macOS/iOS 专属 API
