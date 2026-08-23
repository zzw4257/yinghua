# C20 SwiftUI 真实业务逻辑 — 安全审计 v2（独立 verifier）

**审计人**：verifier（独立 · 二次审计）
**日期**：2026-08-23
**审计依据**：D1 v2.0 §9 + Apple Platform Security Guide + WCAG 2.1 AA + NIST SP 800-53
**审计范围**：C20 6 service + 4 view + 1 entry + Info.plist + entitlements + project.yml = 15 个文件

> **关键差异 vs 上一份 audit**：
> 上一份报告 (`_audit-c20-business-logic.md`) 声称 ✅ **BUILD SUCCEEDED**。
> **本审计独立复跑 xcodebuild，结果 = ❌ BUILD FAILED（3 Swift 6 严格并发错误）**。
> 上一份报告对 Swift 6 严格并发的覆盖存在明显遗漏，本审计在第 3 节展开。

---

## 0. 编译验证（独立复跑）

```bash
cd code/Yinghua
xcodegen generate
xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug \
  -destination 'platform=macOS' \
  CODE_SIGN_IDENTITY="-" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO \
  clean build
```

**结果**：❌ **BUILD FAILED**

```
Yinghua/Models/AppState.swift:131:32: error: sending 'self' risks causing data races
                self.recording = .idle
Yinghua/Models/AppState.swift:162:35: error: sending 'self' risks causing data races
            self.lastRecordingURL = url
Yinghua/Audio/AudioCaptureService.swift:290:29: error: sending 'buffer' risks causing data races
        bufferContinuation?.yield(buffer)
```

外加 5 个并发 warning（`AVAudioPCMBuffer` 不 Sendable、`inputExhausted` 闭包逃逸等）：

```
Audio/AudioCaptureService.swift:299:38: warning: capture of 'buffer' with non-Sendable type 'AVAudioPCMBuffer'
Audio/AudioCaptureService.swift:2:1:   warning: add '@preconcurrency' to treat 'Sendable'-related errors from module 'AVFAudio' as warnings
Audio/AudioCaptureService.swift:391:20: warning: capture of 'buffer' with non-Sendable type 'AVAudioPCMBuffer' in a '@Sendable' closure
Audio/AudioCaptureService.swift:385:16: warning: reference to captured var 'inputExhausted' in concurrently-executing code
Audio/AudioCaptureService.swift:389:13: warning: mutation of captured var 'inputExhausted' in concurrently-executing code
```

> 这些是 Swift 6 严格并发（`-swift-version 6`，见 `project.yml:13`）下的硬错误，不是「可通过调整编译器选项绕过」的 warning。代码语义与 Swift 6 不兼容。

---

## 1. 8 大类检查表

| 大类 | PASS | PARTIAL | FAIL |
|------|------|---------|------|
| A API Key 安全 | 12 | 0 | 0 |
| B 网络请求 | 8 | 1 | 2 |
| C TCC 权限 | 9 | 1 | 0 |
| D 数据存储 | 6 | 2 | 2 |
| E 线程/性能 | 6 | 3 | 2 |
| F 错误处理 | 8 | 3 | 0 |
| G 隐私/GDPR | 5 | 2 | 2 |
| H 代码质量 | 5 | 3 | 1 |
| **合计** | **59** | **15** | **9** |

> 详细判定见第 2 节。**FAIL** = 9 项；其中 3 项是 build-blocking 编译错误，其余 6 项是安全 / 隐私 CRITICAL 缺失（**HTTPS 校验缺失、PrivacyInfo.xcprivacy 缺失、30 天清理未实现、AVAudioPCMBuffer 跨 actor 传递**等）。

---

## 2. 逐项判定（A–H × ~100）

### A. API Key 安全（12 / 12 PASS）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| A1 | KeychainService 不写文件 | `KeychainService.swift:92-127` — 只用 `SecItemUpdate` / `SecItemAdd` | ✅ PASS |
| A2 | KeychainService 不上传 | 全 API 目录 `grep -E "write\|removeItem\|contentsOf\|atomic\|encode"` = 0 命中 | ✅ PASS |
| A3 | Key 不在 console.log | `APIKeySettingsView.swift` 全文无 `print` / `NSLog` / `dump` | ✅ PASS |
| A4 | Key 不在 UserDefaults | 全工程 `UserDefaults\.standard\|@AppStorage` = 0 命中（`Speaker.swift:5` 是 stale comment） | ✅ PASS |
| A5 | Key 不在 process arguments | 无 `CommandLine.arguments` / `ProcessInfo.processInfo.arguments` 读取 | ✅ PASS |
| A6 | Key 不在 network requests body | `SummaryService.swift:202-238` — body 只有 `model` / `max_tokens` / `system` / `messages`，key 仅在 header | ✅ PASS |
| A7 | Key 不在 analytics | 无 analytics SDK（`grep "crashlytics\|sentry\|amplitude\|mixpanel"` = 0 命中） | ✅ PASS |
| A8 | keychain access control = `kSecAttrAccessibleAfterFirstUnlock` | `KeychainService.swift:119` | ✅ PASS |
| A9 | BYOK UI 用 SecureField | `APIKeySettingsView.swift:148-156` — 默认 `SecureField`，eye toggle 切 `TextField` | ✅ PASS |
| A10 | 测试连接走 Authorization header | `SummaryService.swift:153-162` | ✅ PASS |
| A11 | Key 显示/隐藏 toggle 不在剪贴板 | 全工程 `NSPasteboard\|UIPasteboard\|setString` = 0 命中 | ✅ PASS |
| A12 | Key 撤销有 UI 入口 | `APIKeySettingsView.swift:113-119` — "删除" 按钮 → `KeychainService.deleteAll` | ✅ PASS |

**A 小结**：12 / 12 全 PASS。API key 全生命周期安全。

### B. 网络请求（8 / 11 PASS · 1 PARTIAL · 2 FAIL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| B1 | SummaryService 只用 HTTPS（无 http://） | 全工程 `grep "http://"` = 0 命中；3 个 provider default endpoint 全 https | ✅ PASS |
| B2 | 只发 transcript 文本 | `SummaryService.swift:118-123` `formatTranscript` 仅 `[timecode] speakerName: text` | ✅ PASS |
| B3 | 不发音频原文 / PII / 设备 ID / location | 无 CoreLocation / `IOPlatformUUID` / `NSHost`；body 仅模型+提示+转录 | ✅ PASS |
| B4 | 有 timeout | `SummaryService.swift:146` `URLRequest(... timeoutInterval: 60)` | ✅ PASS |
| B5 | 有 retry 但不无限重试 | ⚠️ **无 retry 逻辑**（`SummaryService.swift:165-176` 直接 throw） | ⚠️ PARTIAL |
| B6 | 错误处理不暴露内部细节给 UI | `SummaryError` cases 都抽象为用户语义；`badRequest(msg)` 例外会回传 server 错误（可接受） | ✅ PASS |
| B7 | 不发送 Authorization header 到错误 host | ⚠️ `Config.resolve` 不校验 endpoint scheme（见 B10） | ⚠️ PARTIAL |
| B8 | 不缓存网络响应到不安全位置 | `URLSession.shared` 默认无 cache；无 `URLCache.shared` 显式配置 | ✅ PASS |
| B9 | DNS 走系统默认 | `URLSession.shared`（未自定义 session）走系统 DNS | ✅ PASS |
| B10 | 强制 HTTPS（用户填 endpoint 校验） | ❌ **FAIL**：`SummaryService.swift:37-49` `Config.resolve` 不检查 `endpoint.scheme == "https"`。custom provider 用户填 `http://attacker.com` 也会照发，**API key 在明文 HTTP 下泄露** | ❌ **FAIL** |
| B11 | Custom provider URL 强制 https | ❌ **FAIL**：同 B10，custom endpoint URL 可被填 `http://` | ❌ **FAIL** |
| B12 | 关闭请求有 cancel | 整体 async 任务会随父 Task 取消；无显式 `URLSessionTask.cancel()` 但调用方都 await，超时也 work | ✅ PASS |

**B 小结**：8 PASS / 2 PARTIAL / **2 FAIL（B10 / B11 = CRITICAL HTTP downgrade）**

### C. TCC 权限（9 / 10 PASS · 1 PARTIAL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| C1 | 麦克风：仅录音时申请 | `AudioCaptureService.swift:175-205` — `enableMicrophone` 在 `start()` 路径中 | ✅ PASS |
| C2 | 屏幕录制：仅系统音频启用时申请 | `AudioCaptureService.swift:227-284` — `enableSystemAudio` 在 `start()` 路径中 | ✅ PASS |
| C3 | 语音识别：仅转录时申请 | `TranscriptionService.swift:288-307` — `requestSpeechPermission` 在 `start()` 路径中 | ✅ PASS |
| C4 | 通知：仅用户启用时申请 | `PermissionsSettingsView.swift:144-161` — UI 显式 "启用" 按钮触发 | ✅ PASS |
| C5 | 不申请不必要的权限 | 无 contacts / location / photos / camera / bluetooth 调用 | ✅ PASS |
| C6 | Info.plist 含所有必要 usage description | `Info.plist` 含 `NSMicrophoneUsageDescription` / `NSScreenCaptureUsageDescription` / `NSSpeechRecognitionUsageDescription` / `NSAppleEventsUsageDescription` | ✅ PASS |
| C7 | 权限申请有说明 | 4 个 usage description 都有具体场景文案（不是 generic "we need this"） | ✅ PASS |
| C8 | 权限被拒有 fallback UI | `AudioCaptureError.microphonePermissionDenied` / `screenRecordingPermissionDenied` 错误文案引导到"系统设置 → 隐私与安全性 → 麦克风" | ✅ PASS |
| C9 | 不在用户拒绝后反复申请 | `AVCaptureDevice.requestAccess` 系统只在 `notDetermined` 时弹一次；之后状态 = denied，需要去系统设置 | ✅ PASS |
| C10 | openSystemSettings 跳正确页 | `PermissionService.swift:220-235` — 4 个 kind 全部走 `x-apple.systempreferences:com.apple.preference.security?Privacy_*` | ✅ PASS |
| C11 | notifications permission 入口文案 | ⚠️ `NSUserNotificationUsageDescription` 在 `project.yml:59` 出现，但独立 `Info.plist` 文件里**没有**这个 key（`Info.plist` 只有 4 项 usage description）—— Info.plist 是被 `processInfoPlist` 合并的，需要确认实际产物 | ⚠️ PARTIAL |

**C 小结**：9 PASS / 1 PARTIAL。TCC 路径干净。

### D. 数据存储（6 / 10 PASS · 2 PARTIAL · 2 FAIL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| D1 | 录音存 `~/Library/Application Support/Yinghua/` | `AudioCaptureService.swift:411-428` `recordingsDirectory()` | ✅ PASS |
| D2 | 录音文件名不包含 PII | `AudioCaptureService.swift:90` `rec-\(Int(Date().timeIntervalSince1970)).caf` — Unix timestamp，无 PII | ✅ PASS |
| D3 | 不存到 /tmp 或 Documents | 只用 Application Support，无 `/tmp` 写入 | ✅ PASS |
| D4 | 30 天清理逻辑实现 | ❌ **FAIL**：全工程 `grep "30 day\|cleanup\|prune\|olderThan\|expire"` = 0 命中。无清理代码 | ❌ **FAIL** |
| D5 | 卸载清理逻辑实现 | ⚠️ 无显式清理代码。卸载时 sandbox container 会被系统删除（自动），但**需要 PrivacyInfo.xcprivacy `NSPrivacyAccessedAPITypes` 配合**（见 D11） | ⚠️ PARTIAL |
| D6 | 不上传用户数据到映话服务器 | 无 server 端集成代码；唯一外发是 SummaryService → user-configured LLM endpoint | ✅ PASS |
| D7 | Keychain 不跨 app 共享 | `KeychainService.service = "com.yinghua.apikey"`（`KeychainService.swift:14`） | ✅ PASS |
| D8 | 文件权限正确（600） | ⚠️ 未显式 `chmod 600`；macOS Application Support 默认 user-only，但 Apple 官方不保证 | ⚠️ PARTIAL |
| D9 | 日志不写入敏感信息 | 全工程 `print` 出现 4 次（`AppState.swift:135, 176, 192` 等），全部 `#if DEBUG` 包，且只 print 错误对象 | ✅ PASS |
| D10 | Crash log 不含 PII | 项目不嵌 crash SDK；macOS 系统 crash report 走 `~/Library/Logs/DiagnosticReports/` 含 stack trace 但**不含**录音内容；key 不会出现在 crash log 因为没存到 UserDefaults | ✅ PASS |
| D11 | PrivacyInfo.xcprivacy 文件存在 | ❌ **FAIL**：`find . -name "*.xcprivacy"` = 0 命中。无 `NSPrivacyAccessedAPITypes` 声明。Mac App Store 拒绝 | ❌ **FAIL** |

**D 小结**：6 PASS / 2 PARTIAL / **2 FAIL（D4 = 30天清理未实现 / D11 = PrivacyInfo 缺失）**

### E. 线程 / 性能（6 / 11 PASS · 3 PARTIAL · 2 FAIL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| E1 | @MainActor 正确使用 | `SummaryService` / `TranscriptionService` / `PermissionService` 整体 @MainActor；`AudioCaptureService` 用 `@unchecked Sendable` + 定向 @MainActor 方法 | ✅ PASS |
| E2 | Audio buffer 无 data race | ❌ **FAIL**：`AudioCaptureService.swift:288-306` `writeAndPublish` 把 `AVAudioPCMBuffer` 同时发到 `bufferContinuation.yield`（async）和 `fileWriteQueue.async`，但 buffer 不是 Sendable，Swift 6 编译失败 | ❌ **FAIL** |
| E3 | 文件 I/O 不在主线程 | `AudioCaptureService` 文件写在 `fileWriteQueue`（userInteractive QoS serial queue） | ✅ PASS |
| E4 | Transcription 不阻塞主线程 | `SpeechAnalyzer.results` 是 async 迭代 | ✅ PASS |
| E5 | AVAssetExportSession 异步 | N/A（未用） | n/a |
| E6 | 大量 transcript 行用 lazy loading | ⚠️ `transcriptLines: [TranscriptLine]` 直接 append，无 `LazyVStack` / 分页 | ⚠️ PARTIAL |
| E7 | Settings 切换无 ANR | SettingsView 三个 tab 都是简单 Group + ScrollView | ✅ PASS |
| E8 | 启动时间 < 2s | 未实测（需要 Instruments / Time Profiler） | ⏸️ 未验证 |
| E9 | 内存 < 200MB（60 分钟） | 未实测 | ⏸️ 未验证 |
| E10 | CPU idle < 10% / recording < 30% | 未实测 | ⏸️ 未验证 |
| E11 | 电池影响 < 5%/小时 | 未实测 | ⏸️ 未验证 |
| E12 | 文件 I/O 有 lock 保护 | `AudioCaptureService.stateLock`（NSLock）保护 `audioFile` 引用 | ✅ PASS |
| E13 | AppState 并发安全 | ❌ **FAIL**：`AppState.swift:120-138` 和 `159-165` 的 `Task { @MainActor [audioCapture, transcription] in ... self.x = ... }` 在 Swift 6 严格并发下报 "sending self risks causing data races" | ❌ **FAIL** |
| E14 | `convertBuffer` 闭包并发安全 | ⚠️ `inputExhausted` 在 `@Sendable` closure 内被捕获和修改（`AudioCaptureService.swift:385-389`），Swift 6 warning | ⚠️ PARTIAL |
| E15 | `deinit` 兜底资源释放 | ⚠️ 4 个 service 都没有 `deinit`；`stop()` / `cancel()` 完整但**没有最后防线** | ⚠️ PARTIAL |

**E 小结**：6 PASS / 3 PARTIAL / **2 FAIL（E2 / E13 = build-blocker）**

### F. 错误处理（8 / 11 PASS · 3 PARTIAL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| F1 | 401 → "Invalid API key" | `SummaryService.swift:186-187` → `SummaryError.invalidKey` → "Invalid key — 请检查 API key 是否正确" | ✅ PASS |
| F2 | 429 → "Rate limited" | `SummaryService.swift:188-189` → `SummaryError.rateLimited` | ✅ PASS |
| F3 | 5xx → "Server error" | `SummaryService.swift:190-191` → `SummaryError.serverError(code)` | ✅ PASS |
| F4 | network timeout → "Offline" | `SummaryService.swift:169-175` URLError → `offline` | ✅ PASS |
| F5 | malformed JSON → "AI returned bad response" | `SummaryService.swift:289-309` `parseSummary` 失败 → `malformedResponse` → "模型返回的格式无法解析" | ✅ PASS |
| F6 | 录音设备断开 → "Device disconnected" | ⚠️ `AudioCaptureError.fileWriteFailed` 在写文件失败时上报，但**没有专门**的 "device disconnected" 路径（`AVAudioEngine.inputNode` tap 不会自动停止，需 `AVAudioSession` interruption notification） | ⚠️ PARTIAL |
| F7 | 磁盘满 → "Storage full" | ⚠️ `fileWriteFailed` 会捕到，但错误文案是 "写入音频文件失败：\(err.localizedDescription)"，用户看不出"磁盘满" | ⚠️ PARTIAL |
| F8 | permission 撤销 → "Permission revoked" | `AudioCaptureService.microphonePermissionDenied` / `screenRecordingPermissionDenied` 文案明确"权限被拒绝" | ✅ PASS |
| F9 | 错误日志不暴露 stack trace | `#if DEBUG` 包 + 4 个 print 只 print 错误对象 | ✅ PASS |
| F10 | 用户可重试所有错误 | "AI 总结"按钮可再次点击；录制失败有 UI 提示 | ✅ PASS |
| F11 | 错误冒泡到 UI（不只在 DEBUG print） | ⚠️ `AppState.swift:130-137` startRecording 失败时**只在 DEBUG print**，UI 切换到 emptyState 但**没有 toast / banner 显示错误**——用户无感知 | ⚠️ PARTIAL |

**F 小结**：8 PASS / 3 PARTIAL / 0 FAIL。错误处理结构完整，但 UI 冒泡不全。

### G. 隐私 / GDPR（5 / 9 PASS · 2 PARTIAL · 2 FAIL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| G1 | 不收集使用数据 | 无 analytics / 埋点 | ✅ PASS |
| G2 | 不嵌入 analytics SDK | `grep "analytics\|crashlytics\|sentry\|bugsnag\|amplitude\|mixpanel"` = 0 | ✅ PASS |
| G3 | 不向第三方发 crash report | 无 crash SDK；macOS 系统 crash report 由用户 opt-in | ✅ PASS |
| G4 | Privacy manifest 含所有数据使用声明 | ❌ **FAIL**：无 `PrivacyInfo.xcprivacy` 资源（`find` = 0 命中） | ❌ **FAIL** |
| G5 | 用户可导出所有数据 | ⚠️ UI 无 "导出转录 / 录音" 入口（仅可去 `~/Library/Application Support/Yinghua/recordings/` 手动取） | ⚠️ PARTIAL |
| G6 | 用户可删除所有数据（一键） | ⚠️ `APIKeySettingsView` 有"删除"按钮（keychain），但**无"清空所有录音"按钮**——只能用户手动去文件夹删 | ⚠️ PARTIAL |
| G7 | 卸载完全清除数据 | Sandbox 卸载自动清，但无显式 uninstall hook | ✅ PASS（sandbox 保障） |
| G8 | 14 岁以下不收集 | 服务条款 / 隐私政策未在代码中体现 | ⏸️ 需查外部文档 |
| G9 | 跨境传输声明 | N/A — 数据不出设备（仅 user-configured LLM endpoint） | ✅ PASS |
| G10 | 0 day CVE patch 政策 | 不在代码范围 | ⏸️ 需查项目维护文档 |
| G11 | AVAudioPCMBuffer 跨 actor 传递时安全 | ❌ **FAIL**：`AudioCaptureService.writeAndPublish` 把非 Sendable buffer 同时发到 continuation 和 fileWriteQueue，编译失败 | ❌ **FAIL** |

**G 小结**：5 PASS / 2 PARTIAL / **2 FAIL（G4 = PrivacyInfo 缺失；G11 = 同 E2 build-blocker）**

### H. 代码质量（5 / 9 PASS · 3 PARTIAL · 1 FAIL）

| # | 检查项 | 证据 | 判定 |
|---|--------|------|------|
| H1 | 无强制 unwrap `!` | ⚠️ 3 处 `AVAudioFormat(...)!`（`AudioCaptureService.swift:68, 498`；`TranscriptionService.swift:134`）。1, 2 是固定 16kHz mono float32 安全；3 是 SpeechAnalyzer bestAvailableAudioFormat 的 fallback，**理论**上 SpeechAnalyzer 总会给一个 valid format 但不应该 force | ⚠️ PARTIAL |
| H2 | 无 force cast `as!` | `grep "as!"` = 0 命中 | ✅ PASS |
| H3 | 无 try! | `grep "try!"` = 0 命中 | ✅ PASS |
| H4 | 错误类型用 typed Error enum | `AudioCaptureError` (8) / `TranscriptionError` (4) / `KeychainError` (4) / `SummaryError` (9) — 全部 LocalizedError | ✅ PASS |
| H5 | 异步操作有 cancel | `Task` 都用 `Task.isCancelled` 检查（`TranscriptionService.swift:157, 273`） | ✅ PASS |
| H6 | 资源用 defer 释放 | `SummaryService.generateSummary` 用 `defer { isGenerating = false }`（`:87`） | ✅ PASS |
| H7 | 无循环引用 | Timer / SCStreamOutputHandler / AVAudioEngine tap 都用 `[weak self]` | ✅ PASS |
| H8 | Swift 6 严格并发兼容 | ❌ **FAIL**：3 个 error 编译失败（`AppState.swift:131, 162`；`AudioCaptureService.swift:290`） | ❌ **FAIL** |
| H9 | 无第三方依赖 | `project.yml` 0 三方包；只 import Apple framework | ✅ PASS |
| H10 | 代码可测试（注入接口） | ⚠️ 4 个 service 全部 `final class` + 内部 AVAudioEngine / SCStream hard-coded，单元测试需要 protocol 抽象 | ⚠️ PARTIAL |
| H11 | Speaker.swift stale comment | ⚠️ `Speaker.swift:5` 注释 "在 AppState 启动时按 speakerId 从 UserDefaults 读取" 与实际不符（实际是 hash 分配），误导读者 | ⚠️ PARTIAL |

**H 小结**：5 PASS / 4 PARTIAL / **1 FAIL（H8 = Swift 6 不兼容）**

---

## 3. 严重度排序

| 严重度 | 项 | 文件:行 | 状态 | 修复路径 |
|--------|-----|---------|------|---------|
| **CRITICAL · P0** | Swift 6 严格并发编译失败 | `AppState.swift:131, 162` `AudioCaptureService.swift:290` | ❌ FAIL | 1) `AppState` 把 `Task` 闭包内 self 操作搬到 `@MainActor private func`；2) `AudioCaptureService.writeAndPublish` 加 `@preconcurrency import AVFoundation` 或 buffer copy |
| **CRITICAL · P0** | custom endpoint 不强制 HTTPS（API key 可经明文 HTTP 泄露） | `SummaryService.swift:37-49` | ❌ FAIL | `guard endpoint.scheme == "https" else { throw SummaryError.invalidEndpoint }` |
| **CRITICAL · P0** | 无 `PrivacyInfo.xcprivacy`（Mac App Store 拒绝 + 合规问题） | 缺文件 | ❌ FAIL | 新建 `Yinghua/Resources/PrivacyInfo.xcprivacy`，`project.yml` 加到 resources |
| **HIGH · P1** | 30 天录音清理未实现 | 缺代码 | ❌ FAIL | 在 `AudioCaptureService.recordingsDirectory()` 加 `cleanupOlderThan(30.days)`，在 `start()` / `stop()` 后扫一次 |
| **HIGH · P1** | AppState.startRecording 错误吞掉（只在 DEBUG print） | `AppState.swift:130-137` | ⚠️ PARTIAL | 把 error 写到 `AppState.lastRecordingError: AudioCaptureError?`，emptyState 显示 toast |
| **HIGH · P1** | Speaker diarization 永远标记"远端" | `TranscriptionService.swift:52-53` | ⚠️ PARTIAL（功能缺陷） | mic 和 system audio 各自独立 `AsyncStream`，分别 mark speaker |
| **HIGH · P1** | AVAudioPCMBuffer 跨 actor 传递不安全 | `AudioCaptureService.swift:288-306` | ❌ FAIL | 改用 `nonisolated(unsafe)` 包装 buffer 引用，或 `@preconcurrency import AVFoundation` |
| **MEDIUM · P2** | 无 `deinit` 兜底 | 4 个 service | ⚠️ PARTIAL | 加 `deinit` 调 `stop()`（用 `MainActor.assumeIsolated`） |
| **MEDIUM · P2** | 无 retry（429 / 5xx 直接 throw） | `SummaryService.swift:165-199` | ⚠️ PARTIAL | 5xx 加 1-2 次指数退避重试 |
| **MEDIUM · P2** | 录音设备断开无专门错误码 | `AudioCaptureError` | ⚠️ PARTIAL | 监听 `AVAudioSession.interruptionNotification` + `AVCaptureDevice` 连接状态 |
| **MEDIUM · P2** | "删除所有录音" UI 缺失 | UI | ⚠️ PARTIAL | emptyState 加 "管理录音" 入口 |
| **LOW · P3** | `Speaker.swift:5` 注释 stale | `Speaker.swift:5` | ⚠️ PARTIAL | 改注释或删 |
| **LOW · P3** | `AVAudioFormat(...)!` 3 处 force unwrap | `AudioCaptureService:68,498` / `TranscriptionService:134` | ⚠️ PARTIAL | 用 `guard let f = ... else { fatalError(...) }` 或 try? |
| **LOW · P3** | `audio-input` entitlement 冗余 | `Yinghua.entitlements:7-8` | ⚠️ PARTIAL | 删 `com.apple.security.device.audio-input`（保留 `microphone`） |
| **LOW · P3** | `NSUserNotificationUsageDescription` 在 project.yml 但 Info.plist 缺 | `Info.plist` | ⚠️ PARTIAL | 确认实际合并产物，或删 `Info.plist` 让 project.yml 注入 |

---

## 4. 给 owner 的修复建议

### P0（3 项 · 上架 / 编译前必须）

1. **修 Swift 6 严格并发**（3 个 error）
   - `AudioCaptureService.swift:290` 改：
     ```swift
     fileprivate func writeAndPublish(_ buffer: AVAudioPCMBuffer) {
         let bufferCopy = buffer  // AVAudioPCMBuffer ARC ref 即可
         bufferContinuation?.yield(bufferCopy)
         fileWriteQueue.async { [weak self] in
             guard let self = self else { return }
             self.stateLock.lock()
             let file = self.audioFile
             self.stateLock.unlock()
             guard let file = file else { return }
             do {
                 try file.write(from: bufferCopy)
             } catch {
                 Task { @MainActor [weak self] in
                     self?.lastError = .fileWriteFailed(error)
                 }
             }
         }
     }
     ```
     或更简单：顶部加 `@preconcurrency import AVFoundation`，把 error 降级为 warning。
   - `AppState.swift:120, 159` 的 `Task { @MainActor [audioCapture, transcription] in ... self.x = ... }` 改成：
     ```swift
     // 删 [audioCapture, transcription] capture，把逻辑搬到 @MainActor private func
     @MainActor private func startRecordingImpl() async {
         do {
             try await audioCapture.start(...)
             ...
         } catch {
             self.recording = .idle
             ...
         }
     }
     func startRecording() {
         ...
         Task { @MainActor in await self.startRecordingImpl() }
     }
     ```

2. **Custom endpoint 强制 HTTPS**
   - `SummaryService.swift:Config.resolve:37-49`：
     ```swift
     let endpoint = storedEndpoint ?? provider.defaultEndpoint
     guard let endpoint = endpoint, endpoint.scheme == "https" else {
         throw SummaryError.invalidEndpoint
     }
     ```

3. **补 `PrivacyInfo.xcprivacy`**
   - 新建 `Yinghua/Resources/PrivacyInfo.xcprivacy`（Apple 模板：NSPrivacyTracking=false / NSPrivacyCollectedDataTypes=[] / NSPrivacyAccessedAPITypes 列 `FileTimestamp` C617.1 / `DiskSpace` E674.1 / `UserDefaults` CA92.1—— 当前代码用了 `FileManager.url(for: .applicationSupportDirectory)` 触发 file timestamp API）。
   - `project.yml:40-41` 的 `resources` 块加：
     ```yaml
     resources:
       - path: Yinghua/Resources/Assets.xcassets
       - path: Yinghua/Resources/PrivacyInfo.xcprivacy
     ```

### P1（4 项 · 可上架后补）

4. 30 天录音清理
5. AppState 错误冒泡到 UI
6. Speaker diarization 实现
7. AVAudioPCMBuffer 跨 actor 传递安全

### P2（4 项 · 后续打磨）

8. 加 `deinit`
9. 5xx 指数退避
10. 录音设备断开专门错误码
11. "删除所有录音" UI 入口

### P3（4 项 · 卫生）

12. 删 `Speaker.swift:5` stale comment
13. 3 处 `AVAudioFormat(...)!` 改 `guard let`
14. 删 `com.apple.security.device.audio-input` entitlement
15. 确认 `NSUserNotificationUsageDescription` 在最终 Info.plist

---

## 5. 审计边界与未验证项

**已验证**（独立运行 + 源码阅读）：
- ✅ 编译（**xcodebuild clean build 失败**，3 errors + 5 warnings，与上一份审计声称的 "BUILD SUCCEEDED" 不符）
- ✅ 15 个 C20 文件源码审计
- ✅ Info.plist 4 项 usage description
- ✅ Entitlements 文件
- ✅ Keychain 只用 Security framework
- ✅ 网络请求 body 审查
- ✅ 线程模型审查（发现 3 个 Swift 6 严格并发硬错）
- ✅ 错误处理体系
- ✅ 录音文件名 / 路径审查

**未验证**（runtime 限制 / 需要仪器）：
- ⏸ 运行时录屏实际音频抓取
- ⏸ SpeechAnalyzer 资产下载
- ⏸ Keychain 实际持久化
- ⏸ 性能数字（启动时间、内存、CPU、电池）
- ⏸ SFSpeechRecognizer fallback 路径（macOS 26 本机）
- ⏸ 服务条款 / 隐私政策 / 14 岁条款（外部文档）

**未审计**（C20 范围外）：
- C13 旧有代码（Views / Components / Tokens）— 不在 C20 范围
- 性能预算（§9.2 6 项）— 需要 Instruments
- Crash log 内容（需要 DiagnosticReports 实际跑）

---

## 6. 总体 VERDICT

### 总结

- **VERDICT**: ❌ **FAIL**
- **CRITICAL 安全 / 编译问题（按严重度）**：
  1. **Swift 6 严格并发 3 个编译错误**（P0 · 阻塞编译）—— `AppState.swift:131, 162` + `AudioCaptureService.swift:290`
  2. **Custom endpoint 不强制 HTTPS，API key 可经明文 HTTP 泄露**（P0 · 安全 CRITICAL）—— `SummaryService.swift:37-49`
  3. **无 `PrivacyInfo.xcprivacy`**（P0 · Mac App Store 拒绝 + 合规）—— 缺文件

- **编译问题**：
  - **3 errors**（全部 Swift 6 严格并发，build-blocking）
  - **5 warnings**（并发相关）
  - 上一份 audit 声称 "BUILD SUCCEEDED" 与本审计独立复跑结果不符——上一份可能用了不同的 build 选项 / 旧版本 project.yml

- **可上 App Store？** ❌ **不可**
  - 编译失败，App Store 上传会被拒
  - 强制 HTTPS 缺失，Apple 安全审核会问询
  - 无 PrivacyInfo，App Store 拒绝（Mac App Store 2024 起强制）

### VERDICT 等级（应用）

- **PASS**：~100 项全部 PASS，可上 App Store
- **PARTIAL**：1-5 项 FAIL（非 CRITICAL），可修复
- **FAIL**：CRITICAL 安全违规 / 编译失败

本审计：3 CRITICAL FAIL（编译 + 2 安全/合规），符合 FAIL 等级。
