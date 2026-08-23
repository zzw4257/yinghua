# 映话 (Yinghua) — SwiftUI 项目骨架

> macOS 26+ native SwiftUI + AppKit 混合 · 本地优先 · BYOK · 编译通过的最小可运行骨架

---

## 目标

- **平台**：macOS 26+（Tahoe）· SwiftUI 6 + AppKit 互操作
- **形态**：单桌面 app（无 companion / web）
- **状态**：本目录是 **C13 — SwiftUI 项目骨架** 收口。5 个 surface 都有**真实布局 + 中文 placeholder 数据**，但**不包含业务逻辑**（录制 / 转录 / AI 总结只是 stub）。

## 编译验证

✅ **BUILD SUCCEEDED** · Xcode 26.6 · Swift 6.3.3 · arm64-apple-macos26.5
✅ 启动测试通过：二进制能正常拉起进程（带 sandbox + microphone entitlement）
✅ Round 4 业务逻辑集成：0 warning / 0 error，clean build 通过

```bash
cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/code/Yinghua
xcodebuild -project Yinghua.xcodeproj \
           -scheme Yinghua \
           -configuration Debug \
           -destination 'platform=macOS' \
           build
```

## 打开项目

需要 **Xcode 26+**（macOS 26 SDK）。直接双击 `Yinghua.xcodeproj`，或：

```bash
open Yinghua.xcodeproj
```

> 本项目用 [xcodegen](https://github.com/yonaskolb/XcodeGen) 维护。
> 改 `project.yml` 后跑 `xcodegen generate` 重新生成 `.xcodeproj`。
> 手改 `project.pbxproj` 会被下次 xcodegen 覆盖。

## 文件结构

```
code/Yinghua/
├── project.yml                      ← xcodegen 配置（唯一真相源）
├── Yinghua.xcodeproj/               ← xcodegen 生成（不要手改）
│   ├── project.pbxproj
│   └── xcshareddata/xcschemes/Yinghua.xcscheme
├── README.md                        ← 本文件
└── Yinghua/                         ← 主 target 源
    ├── YinghuaApp.swift             ← @main · WindowGroup + Window + Settings + Commands
    ├── Info.plist                   ← xcodegen 生成（含麦克风 / 屏幕录制 / 语音识别 usage description）
    ├── Yinghua.entitlements         ← xcodegen 生成（app-sandbox + audio-input + network）
    ├── Models/
    │   ├── AppState.swift           ← @Observable 全局状态 · 5 surface 切换 · 录制状态机 + 服务持有
    │   ├── Speaker.swift            ← Speaker + SpeakerColor（4 色，按 id hash 稳定）
    │   ├── TranscriptLine.swift     ← 单行转录 · timecode 格式化为 MM:SS
    │   ├── MeetingSummary.swift     ← AI 总结 4 段（关键瞬间 / 决定 / 待办 / 遗留问题）
    │   └── DesignTokens.swift       ← 颜色 / 圆角 / 间距 集中收敛
    ├── Audio/
    │   └── AudioCaptureService.swift  ← AVAudioEngine mic + SCStream 系统音频 + 16kHz mono
    ├── Transcription/
    │   └── TranscriptionService.swift ← macOS 26 SpeechAnalyzer + SFSpeechRecognizer fallback
    ├── API/
    │   ├── APIProvider.swift        ← openai / anthropic / custom 枚举
    │   ├── KeychainService.swift    ← BYOK 凭据 kSecClassGenericPassword 存储
    │   └── SummaryService.swift     ← Anthropic Messages / OpenAI Chat Completions 客户端
    ├── Permissions/
    │   └── PermissionService.swift  ← mic / screen recording / 语音识别 / 通知状态 + 跳系统设置
    ├── Components/
    │   ├── SpeakerAvatar.swift      ← STYLE 1：纯色圆 + 首字母
    │   ├── PrimaryButton.swift      ← 紫青渐变 + 12px 圆角
    │   ├── SecondaryButton.swift    ← 玻璃 + 1px hairline
    │   ├── GhostButton.swift        ← 透明 + hover 下划线
    │   ├── CollapsibleSectionCard.swift ← 自绘折叠段（紫/青/粉 bullet 循环）
    │   └── ControlPanel.swift       ← NSPanel（.floating + .nonactivatingPanel）+ 4 段式
    ├── Views/
    │   ├── MainWindow.swift         ← NavigationSplitView 外壳 + 极光 wash + Y mark
    │   ├── EmptyStateView.swift     ← C06/02：4 nav + 2x2 大方块 + 最近录音
    │   ├── MeetingInProgressView.swift ← C06/01：4 人 video grid + transcript 副屏
    │   ├── TranscriptFocusView.swift ← C06/03：7 段说话人轮次 + REC 时间码
    │   ├── ReviewModeView.swift     ← C06/04：file card + 总结 4 折叠段 + 2x2 按钮
    │   ├── OnboardingView.swift     ← C06/05：极简居中 + 单一 CTA + 3-dot progress
    │   └── Settings/
    │       ├── SettingsView.swift       ← 3 tab 容器（Segmented Picker）
    │       ├── APIKeySettingsView.swift  ← 3 provider 的 key / endpoint / model + 保存 / 测试 / 删除
    │       ├── PermissionsSettingsView.swift ← 4 权限的状态 pill + 申请 / 跳系统设置
    │       └── AboutView.swift         ← 版本号 / 致谢
    └── Resources/
        ├── Assets.xcassets/
        │   ├── AppIcon.appiconset/  ← 10 个 PNG 占位图标（黑底白 Y，对应 C07 01 MINIMAL）
        │   └── AccentColor.colorset/← 紫 vivid #B57BFF
        └── README.md
```

## 与 D1 design doc 的对应

| D1 § | 实现位置 |
|------|---------|
| §1 身份 | `YinghuaApp.swift` · Info.plist `CFBundleDisplayName=映话` |
| §2.1 配色 | `Models/DesignTokens.swift`（Tokens.Color.*） |
| §2.2 字体 | 各 view 显式 `font(.system(size:weight:))` · 中文优先 |
| §2.3 圆角 | `Tokens.Radius.*`（12 / 14 / 16）|
| §2.4 间距 | `Tokens.Spacing.*`（8pt grid）|
| §2.5 玻璃 + wash | `MainWindow.body` · `.regularMaterial` + 极光渐变 `.plusLighter` |
| §3.1 01 MINIMAL icon | `YinghuaMark` SwiftUI + `AppIcon.appiconset` 10 个 PNG |
| §4.1 5 种按钮 | `PrimaryButton` / `SecondaryButton` / `GhostButton`（icon / toggle 后续补）|
| §4.2 控制面板 | `ControlPanel` + `ControlPanelWindowController`（NSPanel .floating）|
| §4.3 Speaker Avatar | `SpeakerAvatar`（STYLE 1）|
| §4.5 Transcript Row | `TranscriptFocusView` 里的 `TranscriptBlock` |
| §4.6 Collapsible Card | `CollapsibleSectionCard` + `BulletItem` |
| §5 5 surface | `EmptyStateView` / `MeetingInProgressView` / `TranscriptFocusView` / `ReviewModeView` / `OnboardingView` |
| §6.3 traffic light | 用 `WindowGroup` 默认（系统自带）|
| §9.1 性能预算 | 预留（业务逻辑未实现）|
| §9.2 本地优先 | 默认数据存 `~/Library/Application Support/Yinghua/`（AppState 注释里） |

## 5 个 surface 与 C06 v3 的对应

| C06 子目录 | 视图 | 状态 |
|------------|------|------|
| `01-meeting-in-progress/` | `MeetingInProgressView` | ✅ 4 人 video grid + REC + transcript 副屏 + 静音指示 |
| `02-empty-state/` | `EmptyStateView` | ✅ 4 圆形 nav（首项 magenta active dot）+ 2x2 大方块 + 右侧 3 行最近 |
| `03-transcript-focus/` | `TranscriptFocusView` | ✅ 7 段说话人轮次 + 顶部 REC + 说话人 chip |
| `04-review-mode/` | `ReviewModeView` | ✅ 左 file card + 5 行 preview + speaker chips + 右 4 折叠段 + 2x2 按钮 |
| `05-onboarding/` | `OnboardingView` | ✅ 极简居中 + Y mark + 3 bullet + 单一 CTA + 3-dot progress |

**占位数据**：所有 surface 都用真实中文 placeholder（"面试官"、"今天录制 · 48 分钟"、"关键瞬间" 等），不用 Lorem Ipsum。

## 重要设计决策

1. **`@Observable` 优先**（macOS 14+ Observation framework）· 而不是 `ObservableObject` + `@Published`。
2. **`@Bindable var state = state`** 模式：在 `body` 内重声明为 bindable 来做双向绑定。
3. **`NSPanel` for control panel**：因为 SwiftUI `Window` 不支持 `.floating + .nonactivatingPanel`。
4. **xcodegen 而非手写 pbxproj**：可读、可 diff、YAML 即可改项目结构。
5. **App Sandbox + hardened runtime**：默认开（macOS 26 默认）· 关闭了 macOS 14+ 的 "User Selected File" 等不必要权限。

## 下一步工作（按优先级）

### 必做

- [x] **业务逻辑接线**（Round 4 完成）：
  - [x] `startRecording()` 真正接 `AVAudioEngine` tap + `SCStream` 系统音频
  - [x] `transcriptLines` 接 `SpeechAnalyzer`（macOS 26）+ `SFSpeechRecognizer` fallback
  - [x] `summary` 接 BYOK API（OpenAI / Anthropic / Custom），key 存 Keychain
  - [x] Permission service + 设置窗口（API keys / 权限 / 关于）
- [ ] **Speaker diarization**：把转录结果按声纹分说话人，颜色稳定映射
- [ ] **持久化**：用 SwiftData 或 GRDB 存 `MeetingRecord` 到 `~/Library/Application Support/Yinghua/`
- [ ] **转录独立成屏**（§5.1）：目前 `transcriptFocus` 还是主窗口的 tab，需要切到独立 `Window` Scene

### 体验完善

- [ ] onboarding 3 屏流（C07 b 方向）
- [ ] 浅色模式 token 补全（`colorScheme` adaptive 颜色）
- [ ] 真实 Apple SF Pro 字体（避免 web font 模拟）
- [ ] 控制面板 dock bounce 动效（§2.6）
- [ ] `prefers-reduced-motion` 全局尊重

### 工程化

- [ ] CI：xcodebuild 跑 GitHub Actions
- [ ] 单测：5 surface 的 snapshot test
- [ ] 文档化：每个 component 加 `///` 注释
- [ ] 替换 `AppIcon.appiconset` 占位 PNG 为 Figma 精修版（C07 01 MINIMAL）

## 已知 trade-off

- **AppIcon 占位**：10 个 PNG 是用 CoreGraphics 程序生成的（黑底 + Y letterform），不是设计稿。等 C07 Figma 精修后替换。
- **不写 `Package.swift`**：因为依赖 NSPanel + AppKit，必须是 macOS app target。SPM 形式会让 audio capture entitlement 配置非常别扭。
- **Preview 宏警告**：xcodebuild `-quiet` 不会报 `var state` was never mutated 的 macro 内部 warning，但 Xcode IDE 里看 Preview 时可能会看到。已用 `makePreviewState()` 函数规避。
- **没有 XCTest target**：骨架阶段先不写测试，加 surface 时再补。

## Round 4 业务逻辑集成

> 状态：✅ 编译通过（0 warning / 0 error）· 真测试需要实际 macOS 26 设备 + 麦克风 + 屏幕录制权限

C13 只搭了 5 surface + 6 component + NSPanel 浮窗的骨架，本轮接上真实业务逻辑：录音、转录、API、权限、设置窗口。

### 新增的 7 个 service / 4 个 view

| 文件 | 角色 | 关键技术点 |
|------|------|-----------|
| `Audio/AudioCaptureService.swift` | 系统音频 + 麦克风录制 | `AVAudioEngine.inputNode` tap + `ScreenCaptureKit.SCStream`（`SCStreamOutputTypeAudio`）· 16kHz mono float32 输出 · `AsyncStream<AVAudioPCMBuffer>` 实时给转录消费 · 文件写 `~/Library/Application Support/Yinghua/recordings/rec-<ts>.caf` |
| `Transcription/TranscriptionService.swift` | 实时转录 | macOS 26 `SpeechAnalyzer` + `SpeechTranscriber(.progressiveTranscription)`，自动 model 下载；fallback 到 `SFSpeechRecognizer` + `SFSpeechAudioBufferRecognitionRequest`；逐行 `TranscriptLine` |
| `API/APIProvider.swift` | provider 枚举 | `openai` / `anthropic` / `custom` 三选一 · default model + default endpoint + auth scheme |
| `API/KeychainService.swift` | BYOK 凭据 | `kSecClassGenericPassword` + service `com.yinghua.apikey` + account `<provider>.{key,endpoint,model}` · 永远不写文件 / 永远不上传 |
| `API/SummaryService.swift` | AI 总结 | Anthropic Messages API（`x-api-key` + `anthropic-version`）/ OpenAI Chat Completions（`Authorization: Bearer`）/ Custom OpenAI 兼容 endpoint；4 段 JSON schema 强制输出；401 / 429 / 5xx / offline 错误分别处理 |
| `Permissions/PermissionService.swift` | 权限检查 + 申请 | `AVCaptureDevice` (mic) / `CGPreflightScreenCaptureAccess` (screen) / `SFSpeechRecognizer.authorizationStatus` (speech) / `UNUserNotificationCenter` (notifications) · 4 类 `PermissionState` · `openSystemSettings(for:)` 跳对应设置页 |
| `Views/Settings/SettingsView.swift` + 3 tab | 设置窗口 | 独立 `Window` scene（`id: "settings"`）· Segmented Picker 切换 3 tab |
| `Views/Settings/APIKeySettingsView.swift` | API key UI | 3 provider card · 显示/隐藏 key · Custom 多 endpoint 字段 · 保存 / 测试连接 / 删除 |
| `Views/Settings/PermissionsSettingsView.swift` | 权限 UI | 4 行权限 · 状态 pill（绿/红/橙/灰）· 申请按钮 / 跳系统设置 |
| `Views/Settings/AboutView.swift` | 关于页 | 版本号 / build / 致谢（Apple / Anthropic / OpenAI）|

### 集成方式

`AppState` 现在持有 4 个 service：

```swift
@Observable
final class AppState {
    // 5 surface 切换 / 录制状态机（不变）
    var currentSurface: AppSurface = .emptyState
    var recording: RecordingState = .idle
    var transcriptLines: [TranscriptLine] = TranscriptLine.demo
    var summary: MeetingSummary = .preview
    var selectedProvider: APIProvider = .anthropic

    // 服务持有
    let audioCapture: AudioCaptureService
    let transcription: TranscriptionService
    let summaryService: SummaryService
    let permissions: PermissionService
}
```

`startRecording()` 现在真的接 `audioCapture.start(...)` + `transcription.start(bufferStream:)`；`stopRecording()` 同步回 `transcriptLines`；`generateSummary()` 走 `summaryService.generateSummary(transcript:provider:apiKey:...)`。

### 关键技术决策

1. **AVAudioFile 写文件 + AsyncStream 实时分发双轨**：文件用 `fileWriteQueue` 串行化（避免 mic tap + SCStream 双线程 race），stream 用 `AsyncStream.Continuation` 内置的 lock 保护
2. **SCStream 固定 16kHz mono float32 输出**：在 `SCStreamConfiguration` 里设 `sampleRate=16000, channelCount=1`，与 `targetFormat` 一致 → `SCStreamOutputHandler` 收到 CMSampleBuffer 后直接 `memcpy` 到 AVAudioPCMBuffer，无格式转换
3. **SpeechAnalyzer 优先，SFSpeechRecognizer 兜底**：macOS 26 检测用 `@available(macOS 26.0, *)`；fallback 走 `SFSpeechAudioBufferRecognitionRequest` + 实时更新最后一行
4. **BYOK key 三段（key / endpoint / model）**：Custom provider 必填 endpoint，其他 provider 可选填自定义 model
5. **错误分类 1:1 映射 UI**：401 → "Invalid key"，429 → "Rate limited"，5xx → "Server error"，网络断开 → "Offline"，模型返回非 JSON → "Malformed response"

### 待补（C21+ 真测试需要）

- [ ] **真设备测试**：
  - [ ] macOS 26 实际设备 + Apple Silicon
  - [ ] 授权麦克风 + 屏幕录制（macOS 系统弹窗）
  - [ ] 屏幕录制授权后需**重启 app** 才能完全生效（macOS 限制）
  - [ ] 测 `excludesCurrentProcessAudio` 在录 Zoom / Meet 时是否正确
- [ ] **Speaker diarization**：目前简化用 mic = "我"、system audio = "远端"；真实场景需声纹分说话人
- [ ] **中英混合识别**：SpeechAnalyzer 默认 locale 单一；多 locale 需要 `DictationTranscriber` 切换
- [ ] **流式 UI 更新**：`transcription.liveLines` 已暴露 @Published；需要在 `MeetingInProgressView` / `TranscriptFocusView` 用 `onReceive` / `.onChange` 订阅并追加（目前仍用 demo placeholder）
- [ ] **总结 UI 触发**：`generateSummary()` 已接好；需要 `ReviewModeView` 顶部 "重新生成" 按钮调它
- [ ] **持久化**：`MeetingRecord` 存 SwiftData / GRDB（30 天自动清理转录音频原文，按 D1 §9.2）
- [ ] **错误 UX**：`lastError` 已暴露 @Published；需要 error toast / inline display
- [ ] **网络重试 + 超时**：当前 60s timeout，没指数退避
- [ ] **端到端测**：需要至少一次完整录音 → 转录 → 总结的脚本化测试

### 设计约束（继续遵守）

- ✅ 真实 Apple API：AVFoundation / ScreenCaptureKit / Speech / Security / UserNotifications
- ✅ 0 第三方依赖
- ✅ BYOK key 永远 Keychain
- ✅ 唯一网络出口：用户主动触发"AI 总结"，且只传 transcript 文本
- ✅ 数据存 `~/Library/Application Support/Yinghua/`
- ✅ 不破坏 C13 5 surface + 6 component 结构和命名
- ✅ 不改 D1 / D2

## 参考

- 设计母版：`../../design/design-doc.md`（D1 master）
- 5 张产品图：`../../design/_exploration/C06_product-v3/`
- 3 个 icon 变体：`../../design/_exploration/C07_app-icon-v3/`
- 5 张设计 token 视觉：`../../design/_exploration/C05_design-tokens-visual/`
- xcodegen：<https://github.com/yonaskolb/XcodeGen>
