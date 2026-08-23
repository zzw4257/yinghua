import AVFoundation
import Foundation
import Observation
import Speech
import YinghuaCore

/// iOS 端实时转录服务（C44）
///
/// **与 macOS 端的差异**
/// - iOS 没有 `SpeechAnalyzer`（macOS 26+ 专属），只用 `SFSpeechRecognizer`
/// - 输入：`AsyncStream<SendableAudioBuffer>`（由 `iOSAudioCaptureService` 提供）
/// - 输出：累积的 `[TranscriptLine]`（id / speakerId / speakerName / timestamp / text）
///
/// **说话人策略**（iOS 端简化）
/// - iOS 没有 VoiceID（speaker recognition）权限 / 端侧能力
/// - 默认全部归到本地用户 (`me` / `我`)，未来 v0.2 接 macOS app 时可由 macOS 端二判
///
/// **权限**
/// - `NSSpeechRecognitionUsageDescription`（Info.plist）
/// - `SFSpeechRecognizer.requestAuthorization`
@MainActor
@Observable
final class iOSTranscriptionService {
    // MARK: - Published

    /// 累积的转录行（按 timestamp 升序）
    private(set) var liveLines: [TranscriptLine] = []

    /// 是否在转录中
    private(set) var isTranscribing: Bool = false

    /// 最近一次错误
    var lastError: TranscriptionError?

    /// 当前 locale
    private(set) var locale: Locale = .current

    // MARK: - 内部

    private var recognizer: SFSpeechRecognizer?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?

    private var inputTask: Task<Void, Never>?
    private var startedAt: Date?
    private var localSpeakerId: String = "me"
    private var localSpeakerName: String = "我"

    // MARK: - 公共 API

    /// 请求 speech recognition 权限
    func requestPermission() async -> SFSpeechRecognizerAuthorizationStatus {
        await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { status in
                cont.resume(returning: status)
            }
        }
    }

    /// 启动转录
    /// - Parameter bufferStream: 由 `iOSAudioCaptureService.buffers` 提供的实时音频流
    /// - Parameter localUserName: 本地说话人显示名（默认 "我"）
    /// - Parameter preferEnglish: 偏好英文识别（默认 `false`，中文优先）
    func start(
        bufferStream: AsyncStream<SendableAudioBuffer>,
        localUserName: String = "我",
        preferEnglish: Bool = false
    ) async throws {
        guard !isTranscribing else { return }

        // 1. 权限
        let status = await requestPermission()
        guard status == .authorized else {
            throw TranscriptionError.permissionDenied(status)
        }

        // 2. 选定 locale
        if preferEnglish {
            locale = Locale(identifier: "en-US")
        } else {
            locale = Locale(identifier: "zh-CN")
        }
        guard let recognizer = SFSpeechRecognizer(locale: locale), recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }
        self.recognizer = recognizer
        self.localSpeakerName = localUserName

        // 3. 创建 request
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.requiresOnDeviceRecognition = recognizer.supportsOnDeviceRecognition
        // 设置 taskHint
        if #available(iOS 18.0, *) {
            // dictation 是默认；iOS 18 不需要显式 hint
        }
        self.request = request
        self.startedAt = Date()

        // 4. 启动 recognition task
        self.task = recognizer.recognitionTask(with: request) { [weak self] result, error in
            Task { @MainActor in
                guard let self = self else { return }
                if let result = result {
                    self.handleResult(result)
                }
                if let error = error {
                    self.lastError = .recognitionFailed(error)
                    // 不主动 stop —— 上层可能在缓冲一段时间后切回正常
                }
                if result?.isFinal == true {
                    self.isTranscribing = false
                }
            }
        }

        self.isTranscribing = true
        self.liveLines = []

        // 5. 消费 buffer stream
        self.inputTask = Task { [weak self] in
            for await sb in bufferStream {
                guard let self = self else { break }
                guard let req = self.request else { break }
                req.append(sb.buffer)
            }
        }
    }

    /// 停止转录
    func stop() async {
        inputTask?.cancel()
        inputTask = nil
        request?.endAudio()
        // 给 recognizer 一点时间 finalize 最后一段
        try? await Task.sleep(nanoseconds: 200_000_000)  // 200ms
        task?.cancel()
        task = nil
        request = nil
        recognizer = nil
        isTranscribing = false
        startedAt = nil
    }

    /// 清空累积的 lines
    func reset() {
        liveLines = []
    }

    // MARK: - 内部

    private func handleResult(_ result: SFSpeechRecognitionResult) {
        let text = result.bestTranscription.formattedString
        let ts = startedAt.map { Date().timeIntervalSince($0) } ?? 0
        // 用整段 bestTranscription 替换最后一行（partial / final 都更新同一行）
        // 简化策略：每次 result 到达都把现有最后一行替换；final 之后再追加新行
        if let last = liveLines.last, !last.text.isEmpty, result.isFinal {
            // finalize 当前行（替换）
            let finalized = TranscriptLine(
                id: last.id,
                speakerId: localSpeakerId,
                speakerName: localSpeakerName,
                timestamp: last.timestamp,
                text: text
            )
            liveLines[liveLines.count - 1] = finalized
        } else if let last = liveLines.last, !result.isFinal {
            // partial：替换最后一行
            let updated = TranscriptLine(
                id: last.id,
                speakerId: localSpeakerId,
                speakerName: localSpeakerName,
                timestamp: last.timestamp,
                text: text
            )
            liveLines[liveLines.count - 1] = updated
        } else {
            // 第一次 result：追加新行
            let new = TranscriptLine(
                speakerId: localSpeakerId,
                speakerName: localSpeakerName,
                timestamp: ts,
                text: text
            )
            liveLines.append(new)
        }
    }
}

// MARK: - Error

/// iOS 转录错误
enum TranscriptionError: LocalizedError {
    case permissionDenied(SFSpeechRecognizerAuthorizationStatus)
    case recognizerUnavailable
    case recognitionFailed(Error)

    var errorDescription: String? {
        switch self {
        case .permissionDenied(let status):
            return "语音识别权限被拒绝（\(status)）。请到 设置 → 映话 → 语音识别 开启。"
        case .recognizerUnavailable:
            return "当前 locale 的语音识别器不可用。"
        case .recognitionFailed(let e):
            return "识别失败：\(e.localizedDescription)"
        }
    }
}
