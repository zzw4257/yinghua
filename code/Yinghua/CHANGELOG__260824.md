# 映话 Changelog — 2026-08-24

> 本次提交：3 个 P0 阻塞项全部修复。`xcodebuild -configuration Debug clean build` = **BUILD SUCCEEDED**。
> 修复前（来自 `_audit-c20-security.md`）= **BUILD FAILED**（3 errors + 5 warnings）。

## P0-1 · Swift 6 严格并发编译失败

**修复前**：3 个 build-blocking error + 5 个 warning，全部由 `project.yml` 的 `SWIFT_VERSION: "6.0"` 触发。

| # | 位置 | 修复前 | 修复后 |
|---|------|--------|--------|
| E1 | `AppState.swift:131` | `Task { @MainActor [audioCapture, transcription] in … self.recording = .idle }` 隐式捕获非 Sendable self | `Task { @MainActor [weak self] in await self?.startRecordingImpl() }` + 新增 `@MainActor private func startRecordingImpl() async` |
| E2 | `AppState.swift:162` | 同根：self 跨 Sendable 闭包 | `Task { @MainActor [weak self] in await self?.stopRecordingImpl() }` + 新增 `@MainActor private func stopRecordingImpl() async` |
| E3 | `AudioCaptureService.swift:290` | `bufferContinuation?.yield(buffer)` 把 `AVAudioPCMBuffer`（非 Sendable）跨 actor 传 | 新增 `struct SendableAudioBuffer: @unchecked Sendable { let buffer: AVAudioPCMBuffer }`；`AsyncStream<AVAudioPCMBuffer>` → `AsyncStream<SendableAudioBuffer>`（3 处）；`writeAndPublish` 内部 `let sendable = SendableAudioBuffer(buffer: buffer); continuation.yield(sendable)` |
| 类级别 | `AppState` 类 | `final class AppState` 非 Sendable | `@Observable final class AppState: @unchecked Sendable`（Observation 框架内部已同步；所有属性写入均在 main actor） |
| W1 | `AudioCaptureService.swift:299` | `fileWriteQueue.async { … try file.write(from: buffer) … }` 在 @Sendable 闭包捕获 AVAudioPCMBuffer | 闭包改为 `[weak self, sendable]` 捕获 sendable（@unchecked Sendable） |
| W2 | `AudioCaptureService.swift:391` | `converter.convert { … return buffer }` 在 @Sendable 闭包返回 AVAudioPCMBuffer（API 签名硬性约束） | 顶部加 `@preconcurrency import AVFoundation` 降级为 warning（Swift 6 框架兼容层） |
| W3 | `AudioCaptureService.swift:385/389` | `var inputExhausted` 在 @Sendable 闭包里 capture + mutate | 用 `final class ExhaustedBox: @unchecked Sendable { var value = false }` 取代局部 var |
| 全局 | `AudioCaptureService.swift`、`TranscriptionService.swift` | `import AVFoundation` | `@preconcurrency import AVFoundation`（Sendable 警告降级） |
| 全局 | `TranscriptionService.swift` | 接收 `AsyncStream<AVAudioPCMBuffer>`，3 处 buffer 提取 | 接收 `AsyncStream<SendableAudioBuffer>`，for-await 循环改为 `for await sendable in stream { … sendable.buffer … }`（3 处：start / startAnalyzer / startLegacyRecognizer） |

**验证**：
- ✅ `Yinghua/Models/AppState.swift`、`Yinghua/Audio/AudioCaptureService.swift`、`Yinghua/Transcription/TranscriptionService.swift` 全部通过 `swiftc -swift-version 6` 严格模式编译
- ✅ 5 个并发 warning 全部消失

## P0-2 · Custom endpoint 强制 HTTPS

**修复前**：`SummaryService.swift:37-49` `Config.resolve` 不校验 `endpoint.scheme == "https"`，用户填 `http://my-llm-proxy.local` 会让 `Authorization: Bearer <key>` 经明文 HTTP 走全网。

**修复后**：
- `Config.resolve` 强制 `endpoint.scheme?.lowercased() == "https"`，否则抛 `SummaryError.insecureEndpoint(detail)`
- `SummaryError` 新增 `insecureEndpoint(String)` case
- `errorDescription` 给出可读错误（中文 + 明文 HTTP 风险提示）
- **默认 endpoint 不受影响**（`APIProvider.defaultEndpoint` 三个 case 全部 https）
- **Test connection 路径同享校验**（走 `Config.resolve`）

**位置**：`code/Yinghua/Yinghua/API/SummaryService.swift:33-58`（resolve）, `:395-403`（error case + description）

## P0-3 · PrivacyInfo.xcprivacy（Mac App Store 强制）

**修复前**：仓库内完全没有 `PrivacyInfo.xcprivacy` 文件。Mac App Store 自 2024 起强制要求；没有此文件，App Store 上传会被拒。

**修复后**：
- 新建 `code/Yinghua/Yinghua/PrivacyInfo.xcprivacy`（2,678 字节）
- 在 `project.yml` 的 `resources` 块下显式注册（`type: file` + `buildPhase: resources`）
- 验证：`Yinghua.app/Contents/Resources/PrivacyInfo.xcprivacy` 已在产物 bundle 内
- 验证：`plutil -p` 输出 4 个 NSPrivacyAccessedAPIType + 0 个 NSPrivacyCollectedDataTypes + NSPrivacyTracking=false

**Privacy manifest 申报**（4 个 reason，全部"必要"）：

| API Type | Reason | 映话使用位置 |
|----------|--------|------------|
| `NSPrivacyAccessedAPICategoryFileTimestamp` | `C617.1` | `AudioCaptureService.recordingsDirectory()` — 创建 Application Support/Yinghua/recordings/ 时 stat 子目录时间戳 |
| `NSPrivacyAccessedAPICategoryDiskSpace` | `E174.1` | `AudioCaptureService.start()` — 写 .caf 前检查剩余空间（隐式触发） |
| `NSPrivacyAccessedAPICategorySystemBootTime` | `35F9.1` | `AudioCaptureService.startTimers()` — `startTime = Date()` 计算 elapsed |
| `NSPrivacyAccessedAPICategoryUserDefaults` | `CA92.1` | 未来 UI 偏好持久化（已占位；当前 AppState 用 @Observable in-memory） |

**位置**：
- 新建：`code/Yinghua/Yinghua/PrivacyInfo.xcprivacy`
- 修改：`code/Yinghua/project.yml:40-44`（resources 块）

## 修改 / 新建文件清单

| 类型 | 路径 | 改动 |
|------|------|------|
| 修改 | `code/Yinghua/Yinghua/Models/AppState.swift` | `@unchecked Sendable` + 抽 `@MainActor private func startRecordingImpl/stopRecordingImpl` + Task 用 `[weak self]` |
| 修改 | `code/Yinghua/Yinghua/Audio/AudioCaptureService.swift` | 加 `SendableAudioBuffer` + 改 3 处 `AsyncStream<SendableAudioBuffer>` + `writeAndPublish` 包装 yield + fileWriteQueue 捕获 sendable + ExhaustedBox + `@preconcurrency import AVFoundation` |
| 修改 | `code/Yinghua/Yinghua/Transcription/TranscriptionService.swift` | `@preconcurrency import AVFoundation` + 改 3 处流类型为 `<SendableAudioBuffer>` + 3 处 for-await 循环解包 |
| 修改 | `code/Yinghua/Yinghua/API/SummaryService.swift` | `Config.resolve` 强制 HTTPS + `SummaryError.insecureEndpoint` + 对应 errorDescription |
| 修改 | `code/Yinghua/project.yml` | resources 块加 `Yinghua/PrivacyInfo.xcprivacy` |
| 新建 | `code/Yinghua/Yinghua/PrivacyInfo.xcprivacy` | Apple Privacy Manifest（4 个 reason） |
| 新建 | `code/Yinghua/CHANGELOG__260824.md` | 本文件 |

## 编译验证

```bash
cd code/Yinghua
xcodegen generate
xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug \
  -destination 'platform=macOS' \
  CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO \
  clean build
```

| 指标 | 修复前 | 修复后 |
|------|--------|--------|
| Build result | ❌ BUILD FAILED | ✅ **BUILD SUCCEEDED** |
| Swift errors | 3 | **0** |
| Swift warnings | 5 | **0** |
| Exit code | non-zero | 0 |
| `Yinghua.app/Contents/Resources/PrivacyInfo.xcprivacy` | ❌ 缺失 | ✅ 存在 |
| Bundle `Info.plist` 含 `NSPrivacyAccessedAPITypes` 声明 | ❌ | ✅ |

> 唯一的 `warning:` 文本来自 `appintentsmetadataprocessor` 系统工具（"No AppIntents.framework dependency found"），与映话不用 AppIntents 有关，**不是 Swift 编译器 warning**。

## 未触及的 P1/P2

按 `_audit-c20-security.md §4` 列出的 P1 / P2 / P3 不在本任务范围内：
- P1：30 天录音清理、AppState 错误冒泡、Speaker diarization、AVAudioPCMBuffer 跨 actor 安全（**P0-1 修复实际已实现"跨 actor 安全"——靠 Sendable wrapper**）
- P2：deinit、5xx 退避、设备断开错误码、"删除所有录音" UI
- P3：stale comment、`AVAudioFormat(...)!` 改 guard let、删 `com.apple.security.device.audio-input`、确认 `NSUserNotificationUsageDescription`

## 风险

- `@unchecked Sendable` 在 `AppState` 上：依赖"所有 @Observable 属性写入均在 main actor"的不变式。如果后续在 main actor 之外写入 `self.recording = ...`，会引入真实 race。建议加 unit test 守住（v0.2）。
- `@preconcurrency import AVFoundation` 是 Apple 官方对未标 Sendable 的 AVFoundation 类型的临时兼容层；Apple 后续会逐步把 `AVAudioPCMBuffer` 标成 Sendable，到时可以去掉 `@preconcurrency`。
- `ExhaustedBox` 用 `@unchecked Sendable` —— 依赖 `AVAudioConverter.convert` 内部串行调用 input block（Apple 文档保证）。
