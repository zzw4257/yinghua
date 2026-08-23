# 映话权限详解

> 4 个权限 · 用途 / 不授权后果 / 数据流 三个维度说清楚
> 来源：映话 onboarding 屏 2 + C29 `/support/permissions` 页面母本。

## 哲学：最小权限原则

映话每个权限都是 **录制或转录所必需**。我们不申请通讯录、定位、相机、蓝牙—— 这些跟会议场景无关，列出来都是噪音。

4 个权限的**依赖关系**：

```
麦克风 + 屏幕录制 → 录音（AudioCaptureService）
                    ↓
              语音识别 → 转录（TranscriptionService · macOS 26 SpeechAnalyzer）
                    ↓
               通知 → 录完提醒（可选）
```

**通知是 optional**——前 3 个是录制流程的硬依赖。

---

## 权限 1/4：麦克风

| 维度 | 内容 |
|------|------|
| **系统名** | `NSMicrophoneUsageDescription` + `com.apple.security.device.microphone` entitlement |
| **映话用途** | 录制你说话的声音（mic 通道） |
| **不授权会怎样** | 控制面板的 🎙️ mic toggle **强制关闭**，录到的只是 system audio（对方），你自己说话永远不会被录 |
| **数据流** | Mac 麦克风硬件 → `AVAudioEngine.inputNode` tap → `AVAudioConverter`（任意格式 → 16kHz mono float32）→ `AVAudioFile` 写本地 + `AsyncStream<AVAudioPCMBuffer>` 给转录 |
| **音频去哪儿** | 仅 `~/Library/Application Support/Yinghua/recordings/rec-<ts>.caf`。**不上传**。 |
| **可以拒绝吗** | 可以，映话不会崩溃，但功能上等于只录对方（线下会议不推荐） |
| **怎么撤销** | 系统设置 → 隐私与安全性 → 麦克风 → 映话 toggle 关。映话会立刻在控制面板显示「麦克风权限被回收」⚠️ |

> **代码引用**：`code/Yinghua/.../Audio/AudioCaptureService.swift:174-205`（`enableMicrophone`）+ `code/Yinghua/.../Permissions/PermissionService.swift:99-125`
>
> **提示文案**（Info.plist 英文，中文 UI 翻译由系统处理）：「映话 needs microphone access to record your voice during meetings.」

---

## 权限 2/4：屏幕录制

| 维度 | 内容 |
|------|------|
| **系统名** | `NSScreenCaptureUsageDescription`（无 entitlement——是 TCC 授权） |
| **映话用途** | 捕获系统音频流（会议 app、浏览器、视频播放器里**别人**的声音） |
| **不授权会怎样** | 控制面板 🔊 system audio toggle 关闭，只能录到 mic（你自己）。**大多数会议场景完全失效**——只录自己没意义 |
| **数据流** | macOS TCC → `CGPreflightScreenCaptureAccess` → `SCShareableContent.current` → `SCStream`（`SCStreamOutputTypeAudio`）→ CMSampleBuffer → AVAudioPCMBuffer（16kHz mono float32）→ 写到 audio file |
| **关键配置** | `config.excludesCurrentProcessAudio = true`——**映话自己的 app 音频不会被录**（防自录造成的回声） |
| **可以拒绝吗** | 可以，但映话基本废了。等同于只录自己一个人的语音备忘录 app |
| **怎么撤销** | 系统设置 → 隐私与安全性 → 屏幕录制 → 映话 toggle 关。**撤销后必须 ⌘Q 重启映话才完全生效**（macOS 限制，不是映话 bug） |
| **特殊提示** | macOS 一次授权后**不再弹窗**——如果第一次点过「拒绝」，要去系统设置里手动开 |

> **代码引用**：`code/Yinghua/.../Audio/AudioCaptureService.swift:224-284`（`enableSystemAudio`） + `code/Yinghua/.../Permissions/PermissionService.swift:127-144`
>
> **提示文案**：「映话 needs screen recording access to capture system audio from meetings.」
>
> **安全审计**：映话不录视频流（`config.capturesVideo` 默认 false），只取 audio。但 macOS 不允许「只给 audio 权限」，所以你看到的是「屏幕录制」toggle——技术上是「可捕获的 stream 里有 audio」。

---

## 权限 3/4：语音识别

| 维度 | 内容 |
|------|------|
| **系统名** | `NSSpeechRecognitionUsageDescription`（macOS 10.15+） |
| **映话用途** | 启用 macOS 26 `SpeechAnalyzer` on-device 转录引擎。**音频不出 Mac**——模型在本机跑，识别结果只回给映话 |
| **不授权会怎样** | 转录面板会一直空。其他功能（录音、文件管理、AI 总结）**全部正常**——只是 transcript 永远是空字符串 |
| **数据流** | `AudioCaptureService` 的 `AsyncStream<AVAudioPCMBuffer>` → `TranscriptionService.startAnalyzer` → `SpeechTranscriber`（macOS 26 on-device）→ `TranscriptLine` 流 → SwiftUI 显示 |
| **模型下载** | 首次用某 locale 触发 `AssetInventory.assetInstallationRequest`，约 **500MB**（Simplified Chinese），存到 `~/Library/AssetsV2/`（系统管，用户别动） |
| **可以拒绝吗** | 可以。映话变成「纯录音 + AI 总结」app，需要你自己手抄文字——基本废了 |
| **怎么撤销** | 系统设置 → 隐私与安全性 → 语音识别 → 映话 toggle 关。下次启动会重新弹授权 |
| **说话人识别** | macOS 26 `SpeechAnalyzer` 自带 speaker diarization，无需额外权限（系统内部能力） |

> **代码引用**：`code/Yinghua/.../Transcription/TranscriptionService.swift:109-208`（SpeechAnalyzer + 模块下载）
>
> **提示文案**：「映话 uses on-device speech recognition to transcribe your meetings in real time.」
>
> **隐私关键**：因为是 on-device，所以「语音识别权限」≠「音频上传」。授权了也**不会**让任何音频离开 Mac。

---

## 权限 4/4：通知

| 维度 | 内容 |
|------|------|
| **系统名** | `NSUserNotificationUsageDescription` + `UNUserNotificationCenter.requestAuthorization` |
| **映话用途** | 录制结束时弹通知：「会议结束，AI 总结已生成 → 点击打开」 |
| **不授权会怎样** | 录完会议你**不会收到系统通知**。但控制面板、菜单栏、Review 模式照常工作，AI 总结依然生成——只是需要你**主动回来看** |
| **数据流** | `UNUserNotificationCenter` 触发本地通知（不走 Apple Push Notification Service / APNs），点击通知 deep link 到映话 Review 模式 |
| **可以拒绝吗** | 可以，**完全 optional**。映话 onboarding 把它放在最后一步，问完就跳过——`PermissionState.optional` |
| **怎么撤销** | 系统设置 → 通知 → 映话 → 关闭「允许通知」。映话不感知，下次录完依然会尝试发通知（系统静默丢弃） |
| **本地通知 vs 远程** | 映话只用本地通知。**不接 APNs**，**不申请推送 token**。所以你不会收到任何营销 push、版本更新 push——只有录完会议的提醒 |

> **代码引用**：`code/Yinghua/.../Permissions/PermissionService.swift:178-211`（通知权限流）
>
> **提示文案**：「映话 can notify you when a meeting ends and your AI summary is ready.」

---

## 权限总览表

| 权限 | 必需？ | 不授权影响 | 撤销方式 | 数据流终点 |
|------|--------|-----------|----------|-----------|
| 🎙️ 麦克风 | **必需**（会议对话） | 只能录对方 | 系统设置 → 麦克风 | 本地 AVAudioFile |
| 🔊 屏幕录制 | **必需**（录对方） | 只能录自己 | 系统设置 → 屏幕录制（**需重启 app**） | 本地 AVAudioFile |
| 📝 语音识别 | **必需**（要文字） | transcript 为空 | 系统设置 → 语音识别 | 本地 SpeechAnalyzer |
| 🔔 通知 | 可选 | 录完没提醒 | 系统设置 → 通知 | 本地 UNUserNotificationCenter |

---

## 设计约束

映话申请的 4 个权限**完全等于** `design/design-doc.md` v2.0 §9.1「SwiftUI code pattern」表格里列的 entitlement（`com.apple.security.device.microphone` + 屏幕录制 / 语音识别 / 通知 4 个 usage description）。

**没有**任何额外权限：没有通讯录、定位、相机、蓝牙、磁盘完全访问。沙箱 + hardened runtime 强制隔离，映话访问 `~/Library/Application Support/Yinghua/` 之外的任何文件都会被 macOS 拒绝。

> 详细策略见 `design/design-doc.md` v2.0 §9.3「本地优先」+ C31 legal 隐私政策。

---

*更详细的权限诊断步骤：见 [troubleshooting.md](./troubleshooting.md) §01 §02 §05 §07 · 引用 code/Yinghua/ 实际代码*
