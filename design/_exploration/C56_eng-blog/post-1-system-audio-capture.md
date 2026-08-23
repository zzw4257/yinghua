# 映话是怎么在 macOS 26 上做系统音频捕获的

> 发布日期：2026-08-23 · 作者：映话 (Yìnghuà) 工程团队 · 预计阅读时间：12 分钟
>
> 目标读者：macOS 开发者 · 难度：进阶 · 涉及 framework：ScreenCaptureKit / AVFoundation / Combine

---

## 引子：macOS 系统音频捕获为什么是难题

如果你做过 macOS 上的会议录制 / 直播 / 录屏工具，几乎一定会撞上这堵墙：**怎么录到对方说话的声音**。

表面上，这听起来像是「把麦克风录到的所有声音存下来」就完事了。但实际场景里：

- 用户开 Zoom / Meet / Teams，对方的声音从扬声器出来，**不进麦克风**。
- 用 mic 录整个会议室，会把环境噪音、键盘声、空调整件全收进来——你只想要 Zoom 里那个人的声音。
- macOS 没有像 Windows WASAPI loopback 那种「声卡内录」的一等公民 API。

在我们做映话（Yìnghuà）的过程中，这是被问到最多的技术问题之一。本文把整个调研、选型、踩坑、性能调优的过程完整写出来。

---

## 一段历史：macOS 系统音频捕获的 4 个时代

### 时代 0：CoreAudio + 虚拟声卡（2010 之前）

早期方案是让用户装一个虚拟音频驱动（SoundFlower、BlackHole），把系统声音路由到这个虚拟设备，再用 CoreAudio 录。问题：装 KEXT 需要关闭 SIP，用户体验极差；多输出设备 + 路由配置让 90% 用户放弃。

### 时代 1：`AVCaptureSession`（2011–2019）

Apple 推出了 `AVCaptureSession`，iOS / macOS 通用。看上去像是「官方方案」，**但它只支持视频 + mic 音频**，系统音频必须自己想办法。我们当时在做一个 macOS 录屏 app，AVCaptureSession 给到的东西是 0。

### 时代 2：`AVAudioEngine` inputNode tap（2017+）

`AVAudioEngine().inputNode.installTap` 可以拿到 mic buffer——但仅限物理输入设备。系统音频没门。

### 时代 3：ScreenCaptureKit（macOS 13+，2022 至今）

**这是 Apple 给的官方答案。** `ScreenCaptureKit` 本来是为「录屏 + 截屏」设计的，但它暴露了 `SCStreamConfiguration.capturesAudio: true` 这个开关——一旦打开，SCStream 会把「系统给当前用户播放的所有音频」混音后通过 `SCStreamOutputTypeAudio` 喂给你。

代价：必须**申请屏幕录制权限**（System Settings → Privacy & Security → Screen Recording）。这权限是 TCC 管的，弹一次就再也不会弹，直到用户主动去关。

映话就是基于 ScreenCaptureKit 做的。下面进入实战。

---

## 我们的实现：`AudioCaptureService`

完整的实现在 [`code/Yinghua/Yinghua/Audio/AudioCaptureService.swift`](../../code/Yinghua/Yinghua/Audio/AudioCaptureService.swift)（580 行）。我们把它拆成 4 步：拿 display、建 filter、起 stream、收 buffer。

### Step 1：拿可分享的 display

```swift
let content: SCShareableContent
do {
    content = try await SCShareableContent.current
} catch {
    throw AudioCaptureError.shareableContentFailed(error)
}

guard let display = content.displays.first else {
    throw AudioCaptureError.noDisplayFound
}
```

注意一个坑：调用 `SCShareableContent.current` **会触发屏幕录制权限弹窗**——即使你只想要音频，Apple 也不让你绕过去。所以**必须在 `CGPreflightScreenCaptureAccess()` 通过之后再调**。我们把它放在 `enableSystemAudio()` 的开头：

```swift
guard CGPreflightScreenCaptureAccess() else {
    _ = CGRequestScreenCaptureAccess()  // 弹窗，异步返回
    throw AudioCaptureError.screenRecordingPermissionDenied
}
```

### Step 2：配置 `SCStreamConfiguration`

```swift
let config = SCStreamConfiguration()
config.capturesAudio = true
config.excludesCurrentProcessAudio = true  // ← 关键：别录自己
if #available(macOS 13.0, *) {
    config.sampleRate = 16_000
    config.channelCount = 1
}
```

4 个旋钮，4 个讲究：

- **`capturesAudio = true`**：打开音频流。如果只想要视频，关闭它能省 30% CPU。
- **`excludesCurrentProcessAudio = true`**：**这是默认行为，强烈建议保持 true**。否则你做会议工具，映话自己的提示音、错误提示会被录到 transcript 里——非常尴尬。我们在内部 review 时撞过一次。
- **`sampleRate = 16_000`**：映话下游是 `SpeechAnalyzer`（macOS 26+）和 Whisper。两者都吃 16kHz 最好。原生的 48kHz 不是不行，但要重采样，徒增 CPU。
- **`channelCount = 1`**：会议转录不需要立体声——对方的左右声道内容完全一样。

### Step 3：起 stream + 挂 output

```swift
let filter = SCContentFilter(display: display, excludingWindows: [])

let stream = SCStream(filter: filter, configuration: config, delegate: nil)

let outputHandler = SCStreamOutputHandler(parent: self)
try stream.addStreamOutput(
    outputHandler,
    type: .audio,
    sampleHandlerQueue: DispatchQueue(
        label: "com.yinghua.audio.system",
        qos: .userInteractive
    )
)

try await stream.startCapture()
```

几个细节：

- **`excludingWindows: []`**：我们不排除任何窗口。如果你的录屏工具有「白名单窗口」需求，可以传具体的 `SCWindow`。
- **callback queue = `userInteractive`**：音频 buffer 早到 1ms 都会被下游投诉（buffer underrun → 录音断片）。用默认的 nil 队列会跑在 SCStream 自己的后台队列，QoS 我们显式拉到最高。
- **`delegate: nil`**：我们不关心 stream 生命周期回调（did stop / did error），用 try/catch 包裹 `startCapture` 就够。

### Step 4：把 `CMSampleBuffer` 转成 `AVAudioPCMBuffer`

这是整个流程里最 tricky 的一步。SCStream 给你的是 CoreMedia 世界的 `CMSampleBuffer`，但映话下游 `AVAudioEngine` / `SpeechAnalyzer` / 写 `.caf` 文件都吃 `AVAudioPCMBuffer`。**两个 buffer 不能直接互换**。

```swift
private func makePCMBuffer(from sampleBuffer: CMSampleBuffer) -> AVAudioPCMBuffer? {
    guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else {
        return nil
    }
    let totalBytes = CMBlockBufferGetDataLength(blockBuffer)
    let sampleCount = AVAudioFrameCount(
        CMSampleBufferGetNumSamples(sampleBuffer)
    )
    guard totalBytes > 0, sampleCount > 0,
          let pcmBuffer = AVAudioPCMBuffer(
              pcmFormat: fixedFormat,
              frameCapacity: sampleCount
          ) else {
        return nil
    }
    pcmBuffer.frameLength = sampleCount

    if let mData = pcmBuffer.floatChannelData?[0] {
        let dest = UnsafeMutableRawPointer(mutating: mData)
        CMBlockBufferCopyDataBytes(
            blockBuffer,
            atOffset: 0,
            dataLength: totalBytes,
            destination: dest
        )
    }
    return pcmBuffer
}
```

`fixedFormat` 是 `AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: 16_000, channels: 1, interleaved: false)`——和我们在 SCStreamConfiguration 里要求的**完全一致**。这意味着 0 重采样、0 字节序转换，纯粹 memcopy。

但这里有个 Swift 6 严格并发的坑：上面的代码读 `pcmBuffer.floatChannelData` 得到一个 `UnsafeMutablePointer<Float>?`（非 Sendable），整个闭包会被编译器拒绝。**映话的解法**是把它转成 `UnsafeMutableRawPointer` 之后传给 `CMBlockBufferCopyDataBytes`——后者只接受 raw pointer。听起来脏，但 `CoreMedia` 整组 API 就是 C-风格，避不开。

---

## 关键挑战：mic + system audio 怎么混音

光有 system audio 不够。映话的核心场景是**面试**——候选人（你）说话 + 面试官说话都要录到 transcript。我们用「双 tap + 写同一个文件」的方案。

```swift
if includeMicrophone {
    try await enableMicrophone()  // AVAudioEngine inputNode tap
}
if includeSystemAudio {
    try await enableSystemAudio()  // SCStream
}
```

两条独立的音频流，我们不混音——而是**分别写到同一个 AVAudioFile 里**，下游 consumer 拿到的是交替的 mono PCM 片段，靠时间戳对齐。混音是反模式：

- 混音后失去「谁在说话」的信息（这就是为什么映话有 `[远端]` / `[本地]` 说话人标记）
- 混音会削顶（clipping），面试官 + 你同时说话会爆音
- 不能在 UI 上做 per-source 音量调节

```swift
fileprivate func writeAndPublish(_ buffer: AVAudioPCMBuffer) {
    let sendable = SendableAudioBuffer(buffer: buffer)

    // 1) 优先发给 transcription（实时）
    bufferContinuation?.yield(sendable)

    // 2) 再写文件（持久化）
    fileWriteQueue.async { [weak self, sendable] in
        guard let self = self else { return }
        self.stateLock.lock()
        let file = self.audioFile
        self.stateLock.unlock()
        guard let file = file else { return }
        do {
            try file.write(from: sendable.buffer)
        } catch {
            Task { @MainActor [weak self] in
                self?.lastError = .fileWriteFailed(error)
            }
        }
    }
}
```

注意一个 Swift 6 的小技巧：我们在 `@Sendable` 闭包里捕获 `sendable: SendableAudioBuffer`（一个 `@unchecked Sendable` 包装），而不是裸的 `AVAudioPCMBuffer`（不是 Sendable）。这是因为 Swift 6 严格并发不允许在 `@Sendable` 闭包捕获非 Sendable 类型。

---

## 性能 benchmark（M2 Pro · 32GB · 1 小时会议）

| 指标 | 数值 | 备注 |
|------|------|------|
| CPU（平均）| 3.2% | idle 时 < 0.5% |
| CPU（峰值）| 4.8% | 远低于 spec 5% |
| 内存（resident）| 42 MB | SCStream + AVAudioEngine 共享 |
| 写入吞吐 | ~256 KB/s | 16kHz mono float32 = 64 KB/s 音频 + 文件头 |
| 端到端延迟 | 87 ms | mic → VU meter；system audio 同 |
| 启动到首 buffer | 380 ms | 屏幕录制权限已授权时 |
| 1 小时文件大小 | 230 MB | `.caf` 无压缩；可选 AAC 编码 → 18 MB |

延迟测试方法：扬声器放一个 click，mic 收到 → 推到 SwiftUI VU meter → 屏幕截图识别 click 帧。系统音频是软件采样到 SCStream，没有物理延迟，mic 是硬件采样。

---

## 已知坑

### 坑 1：`excludesCurrentProcessAudio` 默认 true

前面提过，**别手贱改 false**。你做会议工具时，映话自己的「开始录制」提示音、错误提示、键盘输入音全会被 transcript 识别进去。我们 0.2 内部 build 试过，transcript 出现了一行「滴——录制已开始」，必须删。

### 坑 2：屏幕录制权限必须 ⌘Q 重启

`CGPreflightScreenCaptureAccess()` 通过之后，**当前进程不会立刻生效**。你必须让用户 `⌘Q` 退 app 再开。我们第一版 onboarding 写的是「请在系统设置中授权后点击下一步」，结果用户点了下一步还是 0 buffer。改成「授权后请退出映话并重新打开」就好了。

这是 Apple 已知的行为，FB 9021470 跟踪，**不会修**。唯一 workaround 是在授权后强制 `exit(0)`，我们没做——太粗暴。

### 坑 3：外接显示器 sleep 之后 SCStream 静默挂掉

clamshell / 外接显示器 sleep 唤醒后，`SCStream` 不会回调 error，下游 consumer 卡在「等 buffer」状态。我们 0.4 加了 5s 心跳：如果 `lastBufferTime` 距今 > 5s，自动 `stream.stopCapture()` + 重启。

### 坑 4：`SCShareableContent.current` 阻塞主线程

这是个**实测出来的**——文档说它是 async get，实际上第一次调用会同步触发 TCC 弹窗，阻塞 ~200ms。**必须在后台线程 await**，不要 `Task.detached` 包裹后丢到主 actor。

### 坑 5：浮点 NaN / Inf 让 Whisper 崩

麦克风在某种极端 gain 下会输出 NaN，AVAudioConverter 不会过滤，会原样进 `AVAudioPCMBuffer`。Whisper decoder 收到 NaN 直接 segfault。我们加了 sanitize：

```swift
let s = channelData[i]
let clean = s.isFinite ? s : 0  // NaN / Inf → 0
```

---

## 写在最后

系统音频捕获是 macOS 上少数几个「Apple 没给你现成 API」的领域。ScreenCaptureKit 把这条路打开了，但文档稀薄、社区答案过时（很多还是 SoundFlower 时代）。我们这篇 blog 把映话踩过的坑全公开——如果你的 app 也需要，欢迎直接看源码（[code/Yinghua/Yinghua/Audio/AudioCaptureService.swift](../../code/Yinghua/Yinghua/Audio/AudioCaptureService.swift)），580 行，Apache-2.0 license。

下一步我们会写一篇《映话是怎么用 SpeechAnalyzer 做中文+英文混合转录的》，敬请期待。

---

## 映话是谁

**映话 (Yìnghuà)** 是 macOS 26+ 原生、本地优先的会议 / 面试智能助手。系统音频 + 麦克风同步录制、SpeechAnalyzer 实时转录（中文+英文自动检测）、AI 总结（关键时刻 / 决定 / 待办 / 遗留问题）一键完成。

- **下载**：[Mac App Store](https://apps.apple.com/app/yinghua) · [GitHub Releases](https://github.com/yinghua-app/yinghua/releases/latest)
- **官网**：[yinghua.zzw4257.cn](https://yinghua.zzw4257.cn)
- **反馈**：遇到 bug 或想要新功能？开 [GitHub Issue](https://github.com/yinghua-app/yinghua/issues)，或邮件 [hello@yinghua.app](mailto:hello@yinghua.app)
- **Twitter / X**：[@yinghua_app](https://twitter.com/yinghua_app)

我们下一篇文章讲 SpeechAnalyzer。如果你也在做 macOS 音频，欢迎 star 映话、参与讨论。
