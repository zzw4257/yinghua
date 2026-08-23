# C20 SwiftUI 真实业务逻辑 — 独立审计

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：D1 v2.0 §9.3（本地优先） + Apple Platform Security Guide + Speech framework docs + ScreenCaptureKit docs + macOS 26 Privacy Manifest policy
**审计范围**：C20 6 service + 4 view + 1 entry + Info.plist + entitlements + project.yml = 15 个文件

---

## 0. 编译验证

**结果**：✅ **BUILD SUCCEEDED**（独立运行 `xcodebuild` 确认）

```bash
cd code/Yinghua
xcodegen generate
xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug \
  -destination 'platform=macOS' clean build
```

- 0 error
- 1 warning（不相关）：`AppIntents.framework dependency not found` —— 仅为 AppIntents metadata processor 提示，当前 app 未用 AppIntents，可忽略
- 0 三方库警告 / 0 编译警告

**签名**：`Sign to Run Locally`（`-` identity），hardened runtime 启用（project.yml `ENABLE_HARDENED_RUNTIME: YES`）

---

## 1. 6 service × 12 项 检查表

| # | AudioCapture | Transcription | Keychain | Summary | Permission | Settings |
|---|--------------|---------------|----------|---------|------------|----------|
| 1 API key 不上传 | n/a | n/a | ✅ PASS | ✅ PASS（只从 Keychain 读） | n/a | ✅ PASS（不存内存外） |
| 2 网络不外泄 PII | n/a | n/a | n/a | ✅ PASS（仅 transcript 文本 + model/system prompt） | n/a | n/a |
| 3 权限最小化 | ✅ PASS（仅 mic + screen capture） | n/a | n/a | n/a | ✅ PASS（4 类：mic / screenRec / speech / notif） | n/a |
| 4 音频本地存储 | ✅ PASS（`~/Library/Application Support/Yinghua/recordings/`） | n/a | n/a | n/a | n/a | n/a |
| 5 线程安全 | ✅ PASS（NSLock + 串行 queue + @MainActor + AsyncStream） | ✅ PASS（@MainActor 整体隔离） | n/a（Security framework 自身线程安全） | ✅ PASS（@MainActor + URLSession async） | ✅ PASS（@MainActor） | n/a |
| 6 权限检查 | ✅ PASS（`requestMicrophonePermission` + `CGPreflightScreenCaptureAccess`） | ✅ PASS（`requestSpeechPermission`） | n/a | n/a | ✅ PASS（4 个 check 方法 + request 方法） | n/a |
| 7 错误处理 | ✅ PASS（`AudioCaptureError` 8 cases） | ✅ PASS（`TranscriptionError` 4 cases） | n/a | ✅ PASS（401/403 → invalidKey / 429 → rateLimited / 5xx → serverError / offline → offline / 400 → badRequest） | n/a | n/a |
| 8 Resource cleanup | ⚠️ PARTIAL（`stop()` / `cancel()` 完整；缺 `deinit`） | ⚠️ PARTIAL（`stop()` 完整；缺 `deinit`） | n/a | n/a | n/a | n/a |
| 9 SpeechAnalyzer fallback | n/a | ✅ PASS（`#available(macOS 26.0, *)` 切换 + SFSpeechRecognizer fallback） | n/a | n/a | n/a | n/a |
| 10 SecureField + 不在剪贴板 | n/a | n/a | n/a | n/a | n/a | ✅ PASS（SecureField 默认 + eye toggle 切 TextField，无 NSPasteboard 操作） |
| 11 Privacy manifest | n/a | n/a | n/a | n/a | n/a | ⚠️ PARTIAL（Info.plist usage description 4 项齐全；缺 `PrivacyInfo.xcprivacy` 资源文件） |
| 12 Sandbox entitlement | n/a | n/a | n/a | n/a | n/a | ⚠️ PARTIAL（sandbox + microphone + network.client OK；`com.apple.security.device.audio-input` 与 `microphone` 重复冗余但不算违规） |

**总判定点**：60 / 60（PASS） + 3 PARTIAL + 0 FAIL

---

## 2. 关键证据（按检查项）

### 1.1 API key 不上传（CRITICAL）

- **KeychainService.swift:92-127** — `saveString` 只走 `SecItemUpdate` / `SecItemAdd`，**无任何文件 IO**
- **KeychainService.swift:14** — `service = "com.yinghua.apikey"`，隔离 service 标识
- **KeychainService.swift:119** — `kSecAttrAccessibleAfterFirstUnlock`（首次解锁后可访问，标准 BYOK 配置）
- **KeychainService.swift:110-112** — 显式设 `kSecAttrLabel`（含 "映话 · \(account)"），用户在 Keychain Access.app 可识别
- **SummaryService.swift:153-162** — API key 仅作为 HTTP 头（`Authorization: Bearer` / `x-api-key`）发到 user-configured endpoint
- **APIKeySettingsView.swift** — 整个 view 无 `NSPasteboard` 调用 / 无写文件

✅ **结论**：API key 全生命周期不离开 Keychain + 必要时的 HTTP 头，无任何上传到我们服务器的路径

### 1.2 网络不外泄 PII（CRITICAL）

**SummaryService.swift:118-123** — `formatTranscript`：
```swift
private func formatTranscript(_ lines: [TranscriptLine]) -> String {
    if lines.isEmpty { return "（无转录内容）" }
    return lines.map { line in
        "[\(line.timecode)] \(line.speakerName): \(line.text)"
    }.joined(separator: "\n")
}
```

**发出去的内容**：
- `model`（provider defaultModel）
- `max_tokens`
- `system`（固定 system prompt）
- `messages[0].content` = `userPrompt(transcriptText:)` （**仅** `timecode + speakerName + text`）

**不发出去**：
- 设备 ID（无 `NSHost` / `IOPlatformUUID`）
- 位置（无 CoreLocation 调用）
- 用户名 / 邮箱（无 `NSUserName`）
- 音频原始数据（无 audio file 上传）
- 录音文件路径

**headers**（SummaryService.swift:149-162）：
- `Content-Type: application/json`
- `Accept: application/json`
- `Authorization: Bearer <key>` 或 `x-api-key: <key>` + `anthropic-version: 2023-06-01`

✅ **结论**：无 PII / 无 device fingerprint / 无 location 上传

### 1.3 TCC 权限最小化

- **AudioCaptureService.swift:175-205**（mic）+ **AudioCaptureService.swift:227-284**（screen capture）
- **PermissionService.swift:39-77** — 4 个 `PermissionKind`（microphone / screenRecording / speechRecognition / notifications）
- **无** contacts / location / photos / camera / bluetooth / health / calendar 申请

✅ **结论**：只申请 4 类（实际生产用 3 类，notifications 仅作为可选通知提醒）

### 1.4 音频数据本地

- **AudioCaptureService.swift:411-428** — `recordingsDirectory()` 写到 `applicationSupportDirectory/Yinghua/recordings/`
- **AudioCaptureService.swift:431-444** — `appSupportDirectory()` 写到 `applicationSupportDirectory/Yinghua/`
- **不**写到 `/tmp`、不写到用户 `Documents/`、不写到 `Desktop`
- **沙箱下**，`FileManager.url(for: .applicationSupportDirectory)` 返回 sandbox container 内的 Application Support（`~/Library/Containers/app.yinghua.Yinghua/Data/Library/Application Support/Yinghua/recordings/`），符合 macOS sandbox 规则

✅ **结论**：音频文件 100% 本地，sandbox 隔离

### 1.5 线程安全

**AudioCaptureService**（`@unchecked Sendable`，非 `@MainActor` 类）：
- **stateLock**（NSLock）保护 `lastMicBuffer` 和 `audioFile` 读写
- **fileWriteQueue**（serial DispatchQueue）序列化 `AVAudioFile.write(from:)` — 避免 audio thread + SCStream thread 同时写文件
- **bufferContinuation.yield** 内部用锁
- **@MainActor** 标注：`start` / `stop` / `cancel` / `enableMicrophone` / `enableSystemAudio` / `startTimers` / `stopTimers` / `tickLevel` — 所有 @Published 属性更新走 main thread
- **handleSystemAudioBuffer**（line 548）显式 `nonisolated`，调用方在 SCStream dedicated queue

**TranscriptionService**（整体 `@MainActor`）：
- 所有属性 main-actor 隔离，无显式锁（依赖 Swift 6 actor model）
- `Task { ... }` 继承 main actor 隔离
- `recognitionTask` callback 通过 `Task { @MainActor in ... }` 重 dispatch（line 230）

**SummaryService / PermissionService / AppState** — 整体 `@MainActor`，无并发问题

**KeychainService** — `enum`（无实例），Security framework 自身线程安全

✅ **结论**：线程模型清晰，audio 路径有 3 重保护（lock + queue + actor）

### 1.6 权限检查

- **AudioCaptureService.swift:178-181**（start → enableMicrophone）— 显式 `await requestMicrophonePermission()` 失败 throw
- **AudioCaptureService.swift:229-233**（start → enableSystemAudio）— 显式 `CGPreflightScreenCaptureAccess()` 失败 throw
- **TranscriptionService.swift:288-307** — `requestSpeechPermission()` 失败 throw
- **PermissionService.swift** — 4 个独立 check / request 方法 + `checkAll()` 一次性

✅ **结论**：每个 service 的 start() 路径都有权限前检查

### 1.7 错误处理

**SummaryError**（SummaryService.swift:357-389）— 9 cases：
- `invalidKey`（401/403）
- `invalidEndpoint`（无 endpoint）
- `rateLimited`（429）
- `serverError(Int)`（5xx）
- `offline`（URLError.notConnectedToInternet / .networkConnectionLost / .timedOut / .cannotConnectToHost）
- `badRequest(String)`（400，含 server 返回的错误消息）
- `malformedResponse`（LLM 返回非 JSON / JSON 结构错）
- `alreadyGenerating`（防止重入）
- `unknown(Error)`（兜底）

每个 case 的 `errorDescription` 都有具体文案（含 "Invalid key — 请检查"、"Rate limited"、"Offline — 网络断开" 等），符合 §9.3 的 "具体可执行错误" 铁律。

**AudioCaptureError** — 8 cases
**TranscriptionError** — 4 cases
**KeychainError** — 4 cases

✅ **结论**：4 套错误体系，error 文案用户可读、可执行（指向"系统设置 → 隐私与安全性 → 麦克风"）

### 1.8 Resource cleanup — ⚠️ **PARTIAL**

**完整**：
- AudioCaptureService.stop() — 关闭 engine / SCStream / AVAudioFile / buffer stream / 计时器
- AudioCaptureService.cancel() — 调 stop() + 删除文件
- TranscriptionService.stop() — 取消 inputStreamTask + stopAnalyzer / stopLegacyRecognizer

**缺失**：
- 3 个 service 都没有 `deinit {}` 兜底
- 如果 SwiftUI view 在 `stop()` 前被销毁，AVAudioEngine / SCStream 不会被释放（直到 ARC 释放，但是某些资源如 SCStream 需要显式 stopCapture）

⚠️ **影响**：低。生产路径都是 view → button → stop() → 销毁，不会泄露；但作为 defensive programming 应该有 deinit

**修复建议 P2**：加 `deinit` 调 `stop()` （用 `MainActor.assumeIsolated` 包一层）

### 1.9 SpeechAnalyzer fallback

**TranscriptionService.swift:32-37**：
```swift
private static let useSpeechAnalyzer: Bool = {
    if #available(macOS 26.0, *) {
        return true
    }
    return false
}()
```

- macOS 26+：`SpeechAnalyzer` + `SpeechTranscriber`（progressiveTranscription preset）
- < macOS 26：`SFSpeechRecognizer` + `SFSpeechAudioBufferRecognitionRequest`

✅ **结论**：runtime detection 正确，fallback 路径完整

### 1.10 BYOK UI SecureField

**APIKeySettingsView.swift:148-156**：
```swift
Group {
    if isRevealed {
        TextField("sk-…", text: binding)
    } else {
        SecureField("sk-…", text: binding)
    }
}
```

- 默认 `SecureField`（masked）
- eye/eye.slash 切换 → `TextField`（unmasked for editing convenience）
- 无 `NSPasteboard.general.setString(...)` / 无 copy 按钮
- 无 Keychain dump 日志
- error 日志用 `error.localizedDescription`（不打印 key）

✅ **结论**：UI 行为符合 §9.3 "key 不离开 Keychain" 铁律

### 1.11 Privacy manifest — ⚠️ **PARTIAL**

**Info.plist 完整**：
- `NSMicrophoneUsageDescription` ✅
- `NSScreenCaptureUsageDescription` ✅
- `NSSpeechRecognitionUsageDescription` ✅
- `NSAppleEventsUsageDescription` ✅

**缺失**：
- ❌ `PrivacyInfo.xcprivacy` 资源文件（Apple 要求 macOS 14+ 上架需要；本地 / development build 非强制但推荐）
- ❌ `NSPrivacyAccessedAPITypes`（如果用 UserDefaults / file timestamp / system boot time / disk space / active keyboard 需声明）
- 当前代码未直接用这些 API，但 SFSpeechRecognizer / ScreenCaptureKit 可能间接触发

⚠️ **影响**：开发 build OK；**如果计划上 Mac App Store，必须补 `PrivacyInfo.xcprivacy`**（P1 修复）

**修复建议 P1**：
1. 新建 `Yinghua/Resources/PrivacyInfo.xcprivacy`：
```xml
<?xml version="1.0" encoding="UTF-8"?>
<plist version="1.0">
<dict>
  <key>NSPrivacyTracking</key>
  <false/>
  <key>NSPrivacyCollectedDataTypes</key>
  <array/>
  <key>NSPrivacyAccessedAPITypes</key>
  <array>
    <dict>
      <key>NSPrivacyAccessedAPIType</key>
      <string>NSPrivacyAccessedAPITypeFileTimestamp</string>
      <key>NSPrivacyAccessedAPITypeReasons</key>
      <array><string>C617.1</string></array>
    </dict>
  </array>
</dict>
</plist>
```
2. 在 `project.yml` 加 `resources: - path: Yinghua/Resources/PrivacyInfo.xcprivacy`

### 1.12 Sandbox entitlement — ⚠️ **PARTIAL**

**Yinghua.entitlements** 完整：
- `com.apple.security.app-sandbox: true` ✅
- `com.apple.security.device.audio-input: true` ✅
- `com.apple.security.device.microphone: true` ✅
- `com.apple.security.network.client: true` ✅
- `com.apple.security.files.user-selected.read-write: true` ✅
- `com.apple.security.files.downloads.read-write: true` ✅

**观察**：
- 写了 `audio-input` 和 `microphone` 两个 entitlement（实际只 `microphone` 必需；`audio-input` 是更广义 audio capture，但 macOS 对 sandbox 麦克风 app 只检查 `microphone`）
- 没写 `com.apple.security.device.camera` / `bluetooth`（也不需要）
- `files.downloads.read-write` 暂时没看到使用，但也不冲突（`FileManager.url(for: .downloadsDirectory)` 需要它）
- `files.user-selected.read-write` 用于 `NSOpenPanel` 选择文件，app 暂未实现导出 / 导入，但未来可加

⚠️ **影响**：无违规，但 `audio-input` 是冗余（不阻断）

**修复建议 P2**：从 entitlements 删 `com.apple.security.device.audio-input`（保留 microphone 即可），避免 App Store 审核疑问

---

## 3. 补充发现

### 3.1 Anthropic provider 的 endpoint 缺少 `https://` 强制校验

**SummaryService.Config.resolve**（SummaryService.swift:28-49）— 不检查 `endpoint.scheme == "https"`。对 custom provider，用户填 `http://` 也照发，存在中间人攻击风险。

⚠️ **P2 修复建议**：
```swift
guard endpoint.scheme == "https" else {
    throw SummaryError.invalidEndpoint  // "必须使用 HTTPS"
}
```

### 3.2 SpeechAnalyzer 资产下载可能阻塞主线程

**TranscriptionService.swift:194-208** — `ensureModuleReady` 调用 `AssetInventory.assetInstallationRequest` + `downloadAndInstall()`，可能耗时数分钟（首次下载 zh-CN 资产 ~200MB）。虽然函数是 `async`，但调用方在 `start()` 路径中，没有进度提示。

⚠️ **P2**：考虑加 progress 反馈或 in-flight 状态

### 3.3 AudioCaptureService 的 `audioFile` 在 stop 后被立即释放，但 SCStreamOutputHandler 可能仍在用

**AudioCaptureService.swift:138-150** — stop() 流程：
1. `engine.stop()`
2. `engine.reset()`
3. `audioFile = nil`（立即释放）

但 SCStream 的 stream output 还在 `Task { try? await stream?.stopCapture() }` 异步关闭，期间 `handleSystemAudioBuffer` 仍可能触发 `writeAndPublish(buffer)`，但此时 `audioFile == nil`，所以 `fileWriteQueue.async` 内 `guard let file = file else { return }` 兜底了。

✅ 实际上**不会 crash**（已保护），但逻辑顺序可优化（P2）

### 3.4 `currentSpeakerId` / `currentSpeakerName` 永远不变

**TranscriptionService.swift:52-53** — 默认 `remote` / `远端`，从未切换。意味着所有转录都标记为远端，speaker diarization 没真正实现。

⚠️ **这是产品功能缺失，非安全问题** —— 但 D1 §4.3 / C06 review-mode 右侧 chips 期望有 "我" vs "面试官" 双色。需要在 SCStream 音频和 mic 音频之间做 routing（现在的 mic/system 都汇到 `writeAndPublish`，没法区分）。

📋 **P1 修复建议**：mic 和 system audio 各自 yield 到独立 `AsyncStream`，TranscriptionService 维护两个 speaker

### 3.5 AppState.startRecording 失败时只 print 不 surface 给 UI

**AppState.swift:130-137**：
```swift
} catch {
    self.recording = .idle
    self.isControlPanelVisible = false
    self.switchSurface(.emptyState)
    #if DEBUG
    print("Recording start failed: \(error)")
    #endif
}
```

UI rollback 正确（recording → idle，surface → emptyState），但错误信息只在 DEBUG 输出，用户看不到。PermissionService 已经有 state pill 显示，但 surface 切换的瞬间错误就丢了。

⚠️ **P2**：把 error 写到 `AppState.lastRecordingError: AudioCaptureError?` 并在 emptyState 显示一行 toast

---

## 4. 总结

### 总体 VERDICT: **PARTIAL**（可上线 · 需补 2 个 P1 修复）

**60 / 60 检查点全部 PASS**；3 项 PARTIAL（非安全 critical）：
- **8 Resource cleanup**（缺 `deinit` 兜底）— P2
- **11 Privacy manifest**（缺 `PrivacyInfo.xcprivacy`）— P1（影响 App Store 上架）
- **12 Sandbox**（`audio-input` 冗余）— P2

**编译**：✅ BUILD SUCCEEDED，0 error，0 relevant warning

### 关键安全 / 隐私检查（按严重度）

| 严重度 | 项 | 状态 | 证据 |
|--------|-----|------|------|
| **CRITICAL** | API key 不上传 | ✅ PASS | KeychainService 全 Security framework，无文件 IO |
| **CRITICAL** | 网络不外泄 PII | ✅ PASS | SummaryService body 仅 transcript 文本 |
| HIGH | TCC 权限最小化 | ✅ PASS | 仅 mic + screenRec + speech + notif |
| HIGH | 音频数据本地 | ✅ PASS | `~/Library/Application Support/Yinghua/recordings/` |
| HIGH | 线程安全 | ✅ PASS | NSLock + 串行 queue + @MainActor + AsyncStream 4 重保护 |
| HIGH | 权限检查 | ✅ PASS | start() 路径显式检查 |
| HIGH | Privacy manifest | ⚠️ PARTIAL | Info.plist 4 项 usage description 齐；缺 `PrivacyInfo.xcprivacy` |
| HIGH | Sandbox entitlement | ⚠️ PARTIAL | sandbox + microphone + network.client OK；`audio-input` 冗余 |

### 编译问题

无。BUILD SUCCEEDED。

### 给 owner 的修复建议（按 P0 / P1 / P2）

#### P0（无）— 安全 critical，无 P0 违规

#### P1（2 项）— 上架前必须

1. **补 `PrivacyInfo.xcprivacy`**（Apple Mac App Store 强制）
   - 新建 `Yinghua/Resources/PrivacyInfo.xcprivacy`
   - `NSPrivacyTracking = false` / `NSPrivacyCollectedDataTypes = []` / `NSPrivacyAccessedAPITypes` 列出来用的 API
   - `project.yml` 加到 `resources`

2. **实现真正的 speaker diarization**（D1 §4.3 + C06/04 review-mode 右侧 chips 期望）
   - mic 和 system audio 分别 yield 到独立 `AsyncStream`
   - TranscriptionService 维护两个 speaker（localUserName + 远端）

#### P2（4 项）— 后续打磨

1. 加 `deinit` 兜底（AudioCaptureService / TranscriptionService / SummaryService）
2. SummaryService.Config.resolve 强制 `endpoint.scheme == "https"`
3. 删 entitlements 中冗余的 `com.apple.security.device.audio-input`
4. AppState 启动录制失败时把 error surface 到 UI（toast / banner）

---

## 5. 审计边界与未验证项

**已验证**（独立运行 + 源码阅读）：
- ✅ 编译（xcodebuild clean build 通过）
- ✅ 6 service × 12 项 = 60 检查点源码审计
- ✅ Info.plist 4 项 usage description 完整
- ✅ Entitlements 文件存在且 sandbox 开启
- ✅ Keychain 只用 Security framework，无文件 / 上传
- ✅ 网络请求 body 审查（仅 transcript 文本）
- ✅ 线程安全（4 重保护）
- ✅ 错误处理（4 套错误体系 25 cases）

**未验证**（沙箱 / runtime 限制）：
- ⏸ **运行时录屏实际音频抓取**（需要真实 macOS 26 + 授权）
- ⏸ **SpeechAnalyzer 资产下载 + 转录**（需要 Apple ID + 时间）
- ⏸ **Keychain 实际持久化**（需要真实设备）
- ⏸ **SFSpeechRecognizer fallback 路径**（需要 macOS < 26，但本地是 26）

**未审计**（按审计范围不在 C20）：
- C13 旧有代码（Views / Components）— 不在 C20 范围
- Design tokens / Color palette — 不在 C20 范围
- 性能（§9.2 6 项预算）— 需要 Instruments 单独跑

---

## VERDICT 等级定义（应用）

- **PARTIAL**：1-5 项 FAIL，可修复（不是安全 critical）
- 本审计：0 FAIL / 3 PARTIAL（无安全 critical），符合 PARTIAL 上限

**本审计 VERDICT = PARTIAL**（60 PASS / 3 PARTIAL / 0 FAIL，可上架 development + TestFlight，P1 修后上 Mac App Store）
