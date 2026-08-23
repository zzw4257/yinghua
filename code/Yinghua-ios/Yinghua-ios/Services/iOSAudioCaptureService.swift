import AVFoundation
import Foundation
import Observation
import YinghuaCore

/// iOS 端音频采集服务（C44）
///
/// **与 macOS 端的差异**
/// - iOS 没有 ScreenCaptureKit，无法捕获系统音频（Zoom / Meet 等其他 app 的声音）
/// - iOS 端只录**麦克风** + 给 `iOSTranscriptionService` 实时推流
/// - 输出格式：16kHz / mono / AAC（m4a 容器）落盘到 app sandbox Documents/
///
/// **双通道**
/// 1. `AVAudioRecorder` 写文件（m4a · 16kHz mono · AAC）— 给后续转写 / 归档用
/// 2. `AVAudioEngine.inputNode` tap → `AsyncStream<SendableAudioBuffer>` — 给 `iOSTranscriptionService` 实时消费
///
/// **权限**
/// - `NSMicrophoneUsageDescription`（Info.plist）
/// - `com.apple.security.device.microphone`（entitlements）
/// - `com.apple.security.device.audio-input`（entitlements）
@MainActor
@Observable
final class iOSAudioCaptureService {
    // MARK: - Published state

    /// 是否正在录制
    private(set) var isRecording: Bool = false

    /// 录制时长（秒）
    private(set) var elapsed: TimeInterval = 0

    /// 最近一次错误
    private(set) var lastError: AudioCaptureError?

    /// 麦克风音量（RMS 0...1，给 VU meter）
    private(set) var level: Float = 0

    /// 当前录制输出文件 URL（仅在 isRecording == true 时非空）
    private(set) var currentFileURL: URL?

    // MARK: - 内部

    private let session = AVAudioSession.sharedInstance()
    private let engine = AVAudioEngine()
    private var recorder: AVAudioRecorder?
    private var streamContinuation: AsyncStream<SendableAudioBuffer>.Continuation?
    private var startTime: Date?
    private var elapsedTimer: Timer?
    private var levelTimer: Timer?

    // 输出格式：16kHz / mono / float32（与 macOS 端对齐，Whisper / SFSpeech 都吃这个）
    private static let targetFormat: AVAudioFormat = {
        AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 16_000,
            channels: 1,
            interleaved: false
        )!
    }()

    // 公开的 live audio stream（给 iOSTranscriptionService 消费）
    nonisolated let buffers: AsyncStream<SendableAudioBuffer>

    // MARK: - 初始化

    init() {
        var continuation: AsyncStream<SendableAudioBuffer>.Continuation!
        self.buffers = AsyncStream<SendableAudioBuffer> { c in
            continuation = c
        }
        self.streamContinuation = continuation
    }

    // MARK: - 公共 API

    /// 请求麦克风权限
    func requestPermission() async -> Bool {
        if #available(iOS 17.0, *) {
            return await AVAudioApplication.requestRecordPermission()
        } else {
            return await withCheckedContinuation { cont in
                AVAudioSession.sharedInstance().requestRecordPermission { granted in
                    cont.resume(returning: granted)
                }
            }
        }
    }

    /// 启动录制
    /// - Throws: `AudioCaptureError`（权限 / session 配置 / recorder 初始化失败）
    func start() async throws {
        guard !isRecording else { return }

        // 1. 权限
        let granted = await requestPermission()
        guard granted else {
            throw AudioCaptureError.permissionDenied
        }

        // 2. 配置 AVAudioSession
        do {
            try session.setCategory(
                .playAndRecord,
                mode: .default,
                options: [.defaultToSpeaker, .allowBluetooth]
            )
            try session.setPreferredSampleRate(16_000)
            try session.setPreferredIOBufferDuration(0.02)  // 20ms 帧
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw AudioCaptureError.sessionConfigurationFailed(error)
        }

        // 3. 启动 AVAudioRecorder 落盘（m4a · 16kHz mono · AAC）
        let url = try makeOutputURL()
        let settings: [String: Any] = [
            AVFormatIDKey: kAudioFormatMPEG4AAC,
            AVSampleRateKey: 16_000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue,
        ]
        do {
            let r = try AVAudioRecorder(url: url, settings: settings)
            r.isMeteringEnabled = true
            guard r.record() else {
                throw AudioCaptureError.recorderStartFailed
            }
            self.recorder = r
            self.currentFileURL = url
        } catch let e as AudioCaptureError {
            throw e
        } catch {
            throw AudioCaptureError.recorderStartFailed
        }

        // 4. 启动 AVAudioEngine tap → live stream（给 transcription 消费）
        do {
            try startEngineTap()
        } catch {
            // tap 失败不影响落盘；只记录错误
            self.lastError = .engineTapFailed(error)
        }

        // 5. 启动定时器
        self.startTime = Date()
        self.isRecording = true
        self.elapsed = 0

        self.elapsedTimer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self = self, let start = self.startTime else { return }
                self.elapsed = Date().timeIntervalSince(start)
            }
        }
        self.levelTimer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { [weak self] _ in
            Task { @MainActor in
                self?.refreshLevel()
            }
        }
    }

    /// 停止录制
    /// - Returns: 输出文件 URL
    /// - Throws: `AudioCaptureError`
    @discardableResult
    func stop() throws -> URL {
        guard isRecording, let url = currentFileURL else {
            throw AudioCaptureError.notRecording
        }
        // 顺序：engine → recorder → session → timer
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        recorder?.stop()
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        elapsedTimer?.invalidate(); elapsedTimer = nil
        levelTimer?.invalidate(); levelTimer = nil
        streamContinuation?.finish()
        streamContinuation = nil

        isRecording = false
        startTime = nil
        elapsed = 0
        level = 0
        return url
    }

    /// 取消录制并删除文件
    func cancel() {
        guard let r = recorder else { return }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        r.stop()
        r.deleteRecording()
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
        elapsedTimer?.invalidate(); elapsedTimer = nil
        levelTimer?.invalidate(); levelTimer = nil
        streamContinuation?.finish()
        streamContinuation = nil

        isRecording = false
        startTime = nil
        elapsed = 0
        level = 0
        currentFileURL = nil
    }

    // MARK: - 内部

    private func makeOutputURL() throws -> URL {
        let docs = try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: true
        )
        let recordings = docs.appendingPathComponent("Recordings", isDirectory: true)
        try? FileManager.default.createDirectory(at: recordings, withIntermediateDirectories: true)
        let ts = Int(Date.now.timeIntervalSince1970)
        return recordings.appendingPathComponent("recording-\(ts).m4a")
    }

    private func startEngineTap() throws {
        let input = engine.inputNode
        let inputFormat = input.outputFormat(forBus: 0)
        // iOS 麦克风通常是 44.1kHz / 48kHz；我们需要转成 16kHz mono float32
        guard let converter = AVAudioConverter(from: inputFormat, to: Self.targetFormat) else {
            throw AudioCaptureError.converterUnavailable
        }

        input.installTap(onBus: 0, bufferSize: 4096, format: inputFormat) { [weak self] buffer, _ in
            // 转换采样率 / 通道 / 位深
            guard let outBuf = AVAudioPCMBuffer(
                pcmFormat: Self.targetFormat,
                frameCapacity: AVAudioFrameCount(Self.targetFormat.sampleRate * 0.5)
            ) else { return }
            var error: NSError?
            var supplied = false
            let status = converter.convert(to: outBuf, error: &error) { _, status in
                if supplied {
                    status.pointee = .noDataNow
                    return nil
                }
                supplied = true
                status.pointee = .haveData
                return buffer
            }
            if status == .error || error != nil { return }
            self?.streamContinuation?.yield(SendableAudioBuffer(buffer: outBuf))
        }

        engine.prepare()
        try engine.start()
    }

    private func refreshLevel() {
        guard let r = recorder else { return }
        r.updateMeters()
        // averagePower(forChannel:) 返回 dBFS（-160...0），转 0...1
        let db = r.averagePower(forChannel: 0)
        let clamped = max(-60, min(0, db))  // -60dB 当作静音
        let normalized = Float((clamped + 60) / 60)
        self.level = normalized
    }
}

// MARK: - Error

/// iOS 音频采集错误
enum AudioCaptureError: LocalizedError {
    case permissionDenied
    case sessionConfigurationFailed(Error)
    case recorderStartFailed
    case converterUnavailable
    case engineTapFailed(Error)
    case notRecording

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return "麦克风权限被拒绝。请到 设置 → 映话 → 麦克风 开启。"
        case .sessionConfigurationFailed(let e):
            return "AVAudioSession 配置失败：\(e.localizedDescription)"
        case .recorderStartFailed:
            return "AVAudioRecorder 启动失败。"
        case .converterUnavailable:
            return "无法创建 16kHz/mono 音频转换器。"
        case .engineTapFailed(let e):
            return "实时音频 tap 启动失败：\(e.localizedDescription)"
        case .notRecording:
            return "当前未在录制。"
        }
    }
}
