import Foundation
@preconcurrency import AVFoundation
import ScreenCaptureKit
import CoreMedia
import Combine

/// 跨 actor 传递 AVAudioPCMBuffer 的 Sendable 包装（@unchecked）。
///
/// **为什么需要这个 wrapper？**
/// `AVAudioPCMBuffer` 是 CoreAudio 的引用类型，本质是 ARC 管理的 C 对象。
/// Apple 尚未把它标成 `Sendable`，所以 Swift 6 严格并发下跨 actor 传递
/// (`AsyncStream<AVAudioPCMBuffer>.Continuation.yield` / `AsyncStream` element)
/// 会直接编译失败。
///
/// 我们保证 buffer 的所有权在同一时刻只属于一个 actor（写入方立即移交，接收方独占使用），
/// 行为是安全的；所以用 `@unchecked Sendable` 自证。`TranscriptionService` 也复用本类型。
struct SendableAudioBuffer: @unchecked Sendable {
    let buffer: AVAudioPCMBuffer
}

/// 系统级音频 + 麦克风 录制服务
///
/// - 麦克风：`AVAudioEngine.inputNode` tap → 写到 AVAudioFile
/// - 系统音频：macOS 13+ `ScreenCaptureKit` `SCStream`（`SCStreamOutputTypeAudio`）
///   CMSampleBuffer → 转换 AVAudioPCMBuffer → 写到同一文件
/// - 输出目标格式 16kHz / mono / float32（Whisper / SpeechAnalyzer 友好）
/// - 暴露 `AsyncStream<AVAudioPCMBuffer>` 给 `TranscriptionService` 实时消费
///
/// **权限**
/// - 麦克风：`NSMicrophoneUsageDescription` + `com.apple.security.device.microphone` entitlement
/// - 屏幕录制：`NSScreenCaptureUsageDescription`（系统弹窗）。授权一次后 macOS 不再弹，
///   `CGPreflightScreenCaptureAccess()` 返回 true。
///
/// **线程模型**
/// - 不强制 @MainActor：内部有锁 / 串行队列保护状态
/// - `@Published` 属性的更新会被 SwiftUI 派发到主线程
final class AudioCaptureService: NSObject, ObservableObject, @unchecked Sendable {
    // MARK: - Published state

    @Published private(set) var isRecording: Bool = false
    @Published private(set) var elapsed: TimeInterval = 0
    @Published private(set) var level: Float = 0  // 0...1 RMS for VU meter

    /// 错误信息（最近一次失败）
    @Published private(set) var lastError: AudioCaptureError?

    /// 是否启用了系统音频（需要 ScreenCaptureKit + 屏幕录制权限）
    @Published private(set) var systemAudioEnabled: Bool = false

    /// 是否启用了麦克风
    @Published private(set) var microphoneEnabled: Bool = false

    // MARK: - 内部

    private let engine = AVAudioEngine()
    private let mixerNode = AVAudioMixerNode()
    private var scStream: SCStream?
    private var scStreamDelegate: SCStreamOutputHandler?

    private var startTime: Date?
    private var elapsedTimer: Timer?
    private var levelTimer: Timer?
    private var currentRecordingURL: URL?

    // 串行队列：序列化 AVAudioFile 写 + buffer 发布（避免音频线程 + SCStream 线程 race）
    private let fileWriteQueue = DispatchQueue(label: "com.yinghua.audio.write", qos: .userInteractive)
    private let stateLock = NSLock()

    // 最近的 mic buffer（电平计用）—— 受 lock 保护
    private var lastMicBuffer: AVAudioPCMBuffer?

    // 当前正在写的 audio file —— 受 lock 保护
    private var audioFile: AVAudioFile?

    private let targetFormat: AVAudioFormat = {
        // 16kHz mono float32 — Whisper / SpeechAnalyzer 共同友好格式
        AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 16_000,
            channels: 1,
            interleaved: false
        )!
    }()

    // 转换器：把任意输入格式 → targetFormat
    private var micConverter: AVAudioConverter?
    private var systemConverter: AVAudioConverter?

    // 给 transcription 实时订阅的 buffer stream
    // 元素类型用 Sendable wrapper（AVAudioPCMBuffer 非 Sendable，跨 actor 传递需包装）
    private var bufferContinuation: AsyncStream<SendableAudioBuffer>.Continuation?
    private(set) var bufferStream: AsyncStream<SendableAudioBuffer>?

    // MARK: - 公共 API

    /// 启动录制（先确保权限）
    /// - Parameter includeSystemAudio: 是否录制系统音频（默认 true）
    /// - Parameter includeMicrophone: 是否录制麦克风（默认 true）
    @MainActor
    func start(includeSystemAudio: Bool = true, includeMicrophone: Bool = true) async throws {
        guard !isRecording else { return }

        // 1) 准备 Application Support 目录
        let recordingsDir = try Self.recordingsDirectory()
        let fileURL = recordingsDir.appendingPathComponent("rec-\(Int(Date().timeIntervalSince1970)).caf")
        currentRecordingURL = fileURL

        // 2) 创建 AVAudioFile
        let file = try AVAudioFile(
            forWriting: fileURL,
            settings: targetFormat.settings,
            commonFormat: targetFormat.commonFormat,
            interleaved: targetFormat.isInterleaved
        )
        // audioFile 只在 main actor 写入；后台线程读时用 lock 保护
        audioFile = file

        // 3) 启动 buffer stream（元素为 Sendable wrapper，跨 actor 安全）
        let (stream, continuation) = AsyncStream<SendableAudioBuffer>.makeStream()
        bufferStream = stream
        bufferContinuation = continuation

        // 4) 启动 engine
        engine.attach(mixerNode)
        engine.connect(mixerNode, to: engine.mainMixerNode, format: targetFormat)

        if includeMicrophone {
            try await enableMicrophone()
        }
        if includeSystemAudio {
            try await enableSystemAudio()
        }

        try engine.start()
        isRecording = true
        startTime = Date()
        startTimers()
    }

    /// 停止录制（保留文件路径）
    @discardableResult
    @MainActor
    func stop() -> URL? {
        guard isRecording else { return nil }
        isRecording = false
        stopTimers()

        // 关闭 engine
        engine.stop()
        engine.reset()

        // 关闭 SCStream
        let stream = scStream
        scStream = nil
        scStreamDelegate = nil
        Task {
            try? await stream?.stopCapture()
        }

        // 关闭 AVAudioFile（main actor 写，不需要 lock；后台线程读时用 lock 保护）
        audioFile = nil

        // 关闭 buffer stream
        bufferContinuation?.finish()
        bufferContinuation = nil
        bufferStream = nil

        let url = currentRecordingURL
        currentRecordingURL = nil
        startTime = nil
        elapsed = 0
        level = 0
        microphoneEnabled = false
        systemAudioEnabled = false

        return url
    }

    /// 取消录制（删除文件）
    @MainActor
    func cancel() {
        let url = stop()
        if let url = url {
            try? FileManager.default.removeItem(at: url)
        }
    }

    // MARK: - 麦克风

    @MainActor
    private func enableMicrophone() async throws {
        // 请求权限
        let granted = await requestMicrophonePermission()
        guard granted else {
            throw AudioCaptureError.microphonePermissionDenied
        }

        let inputNode = engine.inputNode
        let inputFormat = inputNode.inputFormat(forBus: 0)
        guard inputFormat.sampleRate > 0 else {
            throw AudioCaptureError.audioSessionFailure("无法获取麦克风输入格式")
        }

        // 准备 mic → target 转换器
        micConverter = AVAudioConverter(from: inputFormat, to: targetFormat)

        // 安装 tap
        // 重要：bufferSize 要小以保证实时性
        let converter = micConverter
        inputNode.installTap(
            onBus: 0,
            bufferSize: 4096,
            format: inputFormat
        ) { [weak self] buffer, _ in
            guard let self = self else { return }
            self.handleMicBuffer(buffer, sourceFormat: inputFormat, converter: converter)
        }

        microphoneEnabled = true
    }

    /// 来自 mic tap 的后台线程
    private func handleMicBuffer(
        _ buffer: AVAudioPCMBuffer,
        sourceFormat: AVAudioFormat,
        converter: AVAudioConverter?
    ) {
        // 电平计
        stateLock.lock()
        lastMicBuffer = buffer
        stateLock.unlock()

        // 转换（如果是原生 16kHz mono float32 设备，converter 也只是个 passthrough）
        let converted = convertBuffer(buffer, with: converter, sourceFormat: sourceFormat)
        guard let converted = converted else { return }
        writeAndPublish(converted)
    }

    // MARK: - 系统音频（SCStream）

    @MainActor
    private func enableSystemAudio() async throws {
        // 检查屏幕录制权限
        guard CGPreflightScreenCaptureAccess() else {
            // 弹窗请求（用户授权是异步的）
            _ = CGRequestScreenCaptureAccess()
            throw AudioCaptureError.screenRecordingPermissionDenied
        }

        // 获取可分享内容
        let content: SCShareableContent
        do {
            content = try await SCShareableContent.current
        } catch {
            throw AudioCaptureError.shareableContentFailed(error)
        }

        guard let display = content.displays.first else {
            throw AudioCaptureError.noDisplayFound
        }

        // 创建一个 content filter（捕获整个 display，不捕获视频流本身）
        let filter = SCContentFilter(display: display, excludingWindows: [])

        // 配置
        let config = SCStreamConfiguration()
        config.capturesAudio = true
        config.excludesCurrentProcessAudio = true  // 不录自己 app 的音频
        if #available(macOS 13.0, *) {
            config.sampleRate = 16_000
            config.channelCount = 1
        }

        // 创建 stream
        let stream = SCStream(filter: filter, configuration: config, delegate: nil)

        // 创建 output handler
        let outputHandler = SCStreamOutputHandler(parent: self)
        do {
            try stream.addStreamOutput(
                outputHandler,
                type: .audio,
                sampleHandlerQueue: DispatchQueue(label: "com.yinghua.audio.system", qos: .userInteractive)
            )
        } catch {
            throw AudioCaptureError.streamAddOutputFailed(error)
        }

        // 启动
        do {
            try await stream.startCapture()
        } catch {
            throw AudioCaptureError.streamAddOutputFailed(error)
        }

        scStream = stream
        scStreamDelegate = outputHandler
        systemAudioEnabled = true
    }

    // MARK: - 文件写入 + stream 发布（线程安全）

    fileprivate func writeAndPublish(_ buffer: AVAudioPCMBuffer) {
        // 1) 包装成 Sendable（AVAudioPCMBuffer 非 Sendable，跨 actor 传递必须包装）
        let sendable = SendableAudioBuffer(buffer: buffer)
        // 2) 发给 transcription（实时优先）—— AsyncStream continuation 内部有锁
        bufferContinuation?.yield(sendable)
        // 3) 写文件（串行化）—— 保护 audioFile 受 lock
        //    捕获 sendable（@unchecked Sendable）而非 buffer（AVAudioPCMBuffer 非 Sendable），
        //    避免在 @Sendable 闭包里捕获非 Sendable 类型。
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

    // MARK: - 计时器

    @MainActor
    private func startTimers() {
        elapsedTimer?.invalidate()
        levelTimer?.invalidate()

        elapsedTimer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, let start = self.startTime else { return }
                self.elapsed = Date().timeIntervalSince(start)
            }
        }

        levelTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.tickLevel()
            }
        }
    }

    @MainActor
    private func stopTimers() {
        elapsedTimer?.invalidate(); elapsedTimer = nil
        levelTimer?.invalidate(); levelTimer = nil
    }

    /// 用最近一个 mic buffer 的 RMS 估计电平
    @MainActor
    private func tickLevel() {
        stateLock.lock()
        let buffer = lastMicBuffer
        stateLock.unlock()
        guard let buffer = buffer,
              let channelData = buffer.floatChannelData?[0] else {
            return
        }
        let frameLength = Int(buffer.frameLength)
        guard frameLength > 0 else { return }
        var sum: Float = 0
        for i in 0..<frameLength {
            let s = channelData[i]
            sum += s * s
        }
        let rms = sqrt(sum / Float(frameLength))
        // 转 dBFS 然后映射到 0...1
        let db = 20 * log10(max(rms, 0.000_01))
        // -60dB ~ 0, 0dB ~ 1
        let normalized = max(0, min(1, (db + 60) / 60))
        self.level = normalized
    }

    // MARK: - 工具

    private func convertBuffer(
        _ buffer: AVAudioPCMBuffer,
        with converter: AVAudioConverter?,
        sourceFormat: AVAudioFormat
    ) -> AVAudioPCMBuffer? {
        // 格式一致直接返回
        if buffer.format == targetFormat {
            return buffer
        }
        guard let converter = converter else { return nil }

        // 计算输出 frame 数
        let ratio = targetFormat.sampleRate / sourceFormat.sampleRate
        let outputFrames = AVAudioFrameCount(Double(buffer.frameLength) * ratio)
        guard outputFrames > 0,
              let outBuffer = AVAudioPCMBuffer(pcmFormat: targetFormat, frameCapacity: outputFrames) else {
            return nil
        }
        outBuffer.frameLength = 0

        var error: NSError?
        // 用 class box 持有 `exhausted` 状态，避开了 `var` 局部变量在 @Sendable 闭包中
        // 捕获/修改的 Swift 6 并发错误。@unchecked Sendable 表明我们保证：convert 只会在
        // 单个 dispatch 队列中串行调用闭包（AVAudioConverter 内部保证）。
        final class ExhaustedBox: @unchecked Sendable {
            var value: Bool = false
        }
        let exhaustedBox = ExhaustedBox()
        let status = converter.convert(to: outBuffer, error: &error) { _, status in
            if exhaustedBox.value {
                status.pointee = .endOfStream
                return nil
            }
            exhaustedBox.value = true
            status.pointee = .haveData
            return buffer
        }
        if status == .error || error != nil {
            return nil
        }
        return outBuffer
    }

    private func requestMicrophonePermission() async -> Bool {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        switch status {
        case .authorized: return true
        case .notDetermined:
            return await AVCaptureDevice.requestAccess(for: .audio)
        case .denied, .restricted: return false
        @unknown default: return false
        }
    }

    /// Application Support / Yinghua / recordings
    static func recordingsDirectory() throws -> URL {
        let fm = FileManager.default
        let appSupport = try fm.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let yinghuaDir = appSupport.appendingPathComponent("Yinghua", isDirectory: true)
        let recordingsDir = yinghuaDir.appendingPathComponent("recordings", isDirectory: true)
        if !fm.fileExists(atPath: yinghuaDir.path) {
            try fm.createDirectory(at: yinghuaDir, withIntermediateDirectories: true)
        }
        if !fm.fileExists(atPath: recordingsDir.path) {
            try fm.createDirectory(at: recordingsDir, withIntermediateDirectories: true)
        }
        return recordingsDir
    }

    /// Application Support / Yinghua（根目录）
    static func appSupportDirectory() throws -> URL {
        let fm = FileManager.default
        let appSupport = try fm.url(
            for: .applicationSupportDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let yinghuaDir = appSupport.appendingPathComponent("Yinghua", isDirectory: true)
        if !fm.fileExists(atPath: yinghuaDir.path) {
            try fm.createDirectory(at: yinghuaDir, withIntermediateDirectories: true)
        }
        return yinghuaDir
    }
}

// MARK: - 错误

enum AudioCaptureError: LocalizedError {
    case microphonePermissionDenied
    case screenRecordingPermissionDenied
    case audioSessionFailure(String)
    case shareableContentFailed(Error)
    case noDisplayFound
    case streamAddOutputFailed(Error)
    case streamStartFailed(Error)
    case fileWriteFailed(Error)

    var errorDescription: String? {
        switch self {
        case .microphonePermissionDenied:
            return "麦克风权限被拒绝。请到 系统设置 → 隐私与安全性 → 麦克风 启用映话。"
        case .screenRecordingPermissionDenied:
            return "屏幕录制权限被拒绝。请到 系统设置 → 隐私与安全性 → 屏幕录制 启用映话。"
        case .audioSessionFailure(let msg):
            return "音频会话失败：\(msg)"
        case .shareableContentFailed(let err):
            return "无法获取可分享屏幕内容：\(err.localizedDescription)"
        case .noDisplayFound:
            return "找不到可用的显示器"
        case .streamAddOutputFailed(let err):
            return "添加音频输出失败：\(err.localizedDescription)"
        case .streamStartFailed(let err):
            return "启动屏幕音频流失败：\(err.localizedDescription)"
        case .fileWriteFailed(let err):
            return "写入音频文件失败：\(err.localizedDescription)"
        }
    }
}

// MARK: - SCStream 音频 output handler

/// SCStreamOutput 协议的实现，把系统音频 CMSampleBuffer 喂回 AudioCaptureService
///
/// 之所以用单独的类而不直接在 SCStream 上挂 AVAudioEngine tap：SCStream 的
/// CMSampleBuffer 不直接接得进 AVAudioEngine。必须自己拆 CMSampleBuffer → AVAudioPCMBuffer。
private final class SCStreamOutputHandler: NSObject, SCStreamOutput {
    weak var parent: AudioCaptureService?

    /// 我们在 SCStreamConfiguration 里指定的固定 16kHz mono float32 格式
    /// （与 targetFormat 一致，所以**无需**转换器）
    private let fixedFormat: AVAudioFormat = {
        AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 16_000,
            channels: 1,
            interleaved: false
        )!
    }()

    init(parent: AudioCaptureService) {
        self.parent = parent
    }

    func stream(
        _ stream: SCStream,
        didOutputSampleBuffer sampleBuffer: CMSampleBuffer,
        of type: SCStreamOutputType
    ) {
        guard type == .audio else { return }
        guard let parent = parent else { return }
        guard let pcmBuffer = makePCMBuffer(from: sampleBuffer) else { return }
        // 因为我们保证 fixedFormat == targetFormat，所以无需转换
        parent.handleSystemAudioBuffer(pcmBuffer, sourceFormat: fixedFormat)
    }

    private func makePCMBuffer(from sampleBuffer: CMSampleBuffer) -> AVAudioPCMBuffer? {
        // 从 sample buffer 取出 block buffer
        guard let blockBuffer = CMSampleBufferGetDataBuffer(sampleBuffer) else { return nil }

        let totalBytes = CMBlockBufferGetDataLength(blockBuffer)
        let sampleCount = AVAudioFrameCount(CMSampleBufferGetNumSamples(sampleBuffer))
        guard totalBytes > 0, sampleCount > 0,
              let pcmBuffer = AVAudioPCMBuffer(pcmFormat: fixedFormat, frameCapacity: sampleCount) else {
            return nil
        }
        pcmBuffer.frameLength = sampleCount

        // 直接从 block buffer 拷到 PCM buffer 的 channel 0
        // 假设我们的 SCStreamConfiguration 配置成 float32 interleaved/non-interleaved 16kHz mono
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
}

// 父类 private 方法扩展（handleSystemAudioBuffer）
extension AudioCaptureService {
    /// 由 SCStreamOutputHandler 调用
    /// sourceFormat 总是等于我们配置的 fixedFormat（16kHz mono float32）
    fileprivate nonisolated func handleSystemAudioBuffer(
        _ buffer: AVAudioPCMBuffer,
        sourceFormat: AVAudioFormat
    ) {
        // 文件写 + stream 发都是线程安全的（fileWriteQueue 串行化）
        writeAndPublish(buffer)
    }
}
