import Foundation
import Speech
@preconcurrency import AVFoundation
import Combine

/// 实时转录服务
///
/// - macOS 26+：用 `SpeechAnalyzer` + `SpeechTranscriber`（推荐）· 中文 + 英文自动检测
/// - fallback：macOS 13+ `SFSpeechRecognizer`（`SFSpeechAudioBufferRecognitionRequest`）
///
/// 实时产出 `TranscriptLine` 流（id / speakerId / speakerName / timestamp / text）
/// 说话人目前用一个简化策略：连续文本按时间窗口切分，标 `[远端]` / `[本地]`
@MainActor
final class TranscriptionService: NSObject, ObservableObject {
    // MARK: - Published

    /// 累积的转录行（按 timestamp 升序）
    @Published private(set) var liveLines: [TranscriptLine] = []

    /// 当前是否在转录中
    @Published private(set) var isTranscribing: Bool = false

    /// 错误信息
    @Published var lastError: TranscriptionError?

    /// 当前用的语言
    @Published private(set) var locale: Locale = .current

    // MARK: - 内部

    /// 是否使用 SpeechAnalyzer（macOS 26+）。否则用 SFSpeechRecognizer。
    private static let useSpeechAnalyzer: Bool = {
        if #available(macOS 26.0, *) {
            return true
        }
        return false
    }()

    private var analyzer: Any?  // SpeechAnalyzer
    private var transcriber: Any?  // SpeechTranscriber
    private var analysisTask: Task<Void, Never>?

    // SFSpeechRecognizer fallback
    private let recognizer = SFSpeechRecognizer(locale: Locale(identifier: "zh-CN"))
    private var bufferRequest: SFSpeechAudioBufferRecognitionRequest?
    private var bufferTask: SFSpeechRecognitionTask?

    // 输入：给 transcription 的 buffer stream（由 AudioCaptureService 提供）
    private var inputStreamTask: Task<Void, Never>?

    // 简化说话人：mic → "我"（local），system audio → "远端"
    private var currentSpeakerId: String = "remote"
    private var currentSpeakerName: String = "远端"

    // MARK: - 公共 API

    /// 启动转录
    /// - Parameter bufferStream: 由 `AudioCaptureService` 提供的实时音频流
    ///   （元素为 `SendableAudioBuffer` 包装，AVAudioPCMBuffer 非 Sendable，需 wrapper 跨 actor 传递）
    /// - Parameter localUserName: 本地说话人显示名（默认 "我"）
    /// - Parameter preferEnglish: 偏好英文识别（默认 `false`，中文优先）
    func start(
        bufferStream: AsyncStream<SendableAudioBuffer>,
        localUserName: String = "我",
        preferEnglish: Bool = false
    ) async throws {
        guard !isTranscribing else { return }

        // 请求 speech recognition 权限
        try await requestSpeechPermission()

        // 选定 locale
        if preferEnglish {
            locale = Locale(identifier: "en-US")
        } else {
            // 默认用当前 locale；如果 recognizer 不支持则 fallback 到 zh-CN
            locale = recognizer?.locale ?? Locale(identifier: "zh-CN")
        }

        if Self.useSpeechAnalyzer {
            try await startAnalyzer(bufferStream: bufferStream, localUserName: localUserName)
        } else {
            try await startLegacyRecognizer(bufferStream: bufferStream, localUserName: localUserName)
        }

        isTranscribing = true
    }

    /// 停止转录
    func stop() async {
        guard isTranscribing else { return }
        isTranscribing = false

        // 停止输入流消费
        inputStreamTask?.cancel()
        inputStreamTask = nil

        if Self.useSpeechAnalyzer {
            await stopAnalyzer()
        } else {
            stopLegacyRecognizer()
        }
    }

    /// 清空累积的转录
    func reset() {
        liveLines = []
    }

    // MARK: - SpeechAnalyzer (macOS 26+)

    @available(macOS 26.0, *)
    private func startAnalyzer(
        bufferStream: AsyncStream<SendableAudioBuffer>,
        localUserName: String
    ) async throws {
        // 选 transcriber（中英都支持）
        // 优先 progressiveTranscription（流式 + 快速 final）
        let transcriber = SpeechTranscriber(
            locale: locale,
            preset: .progressiveTranscription
        )

        // 确认资产已就绪（首次使用某 locale 会触发模型下载）
        try await ensureModuleReady(transcriber: transcriber)

        let analyzer = SpeechAnalyzer(modules: [transcriber])
        let bestFormat = await SpeechAnalyzer.bestAvailableAudioFormat(
            compatibleWith: [transcriber]
        ) ?? AVAudioFormat(
            commonFormat: .pcmFormatFloat32,
            sampleRate: 16_000,
            channels: 1,
            interleaved: false
        )!
        try await analyzer.prepareToAnalyze(in: bestFormat)

        // 启动消费 stream → 把 buffer 喂给 analyzer
        let (inputStream, inputContinuation) = AsyncStream<AnalyzerInput>.makeStream()
        let analysisTask = Task { [weak self] in
            do {
                try await analyzer.start(inputSequence: inputStream)
                for try await result in transcriber.results {
                    await self?.handleAnalyzerResult(result, localUserName: localUserName)
                }
            } catch {
                let errorValue = error
                self?.reportError(.analyzerFailed(errorValue))
            }
        }
        self.analysisTask = analysisTask
        self.transcriber = transcriber
        self.analyzer = analyzer

        // 把 AudioCaptureService 的 buffer 转发到 AnalyzerInput stream
        inputStreamTask = Task {
            for await sendable in bufferStream {
                if Task.isCancelled { break }
                inputContinuation.yield(AnalyzerInput(buffer: sendable.buffer, bufferStartTime: nil))
            }
            inputContinuation.finish()
        }
    }

    @available(macOS 26.0, *)
    private func stopAnalyzer() async {
        analysisTask?.cancel()
        analysisTask = nil
        if let analyzer = analyzer as? SpeechAnalyzer {
            await analyzer.cancelAndFinishNow()
        }
        analyzer = nil
        transcriber = nil
    }

    @available(macOS 26.0, *)
    private func handleAnalyzerResult(
        _ result: SpeechTranscriber.Result,
        localUserName: String
    ) async {
        // result.text 是 AttributedString → String
        let text = String(result.text.characters)
        guard !text.trimmingCharacters(in: .whitespaces).isEmpty else { return }

        let timestamp = CMTimeGetSeconds(result.range.start)
        let line = TranscriptLine(
            speakerId: currentSpeakerId,
            speakerName: currentSpeakerName,
            timestamp: timestamp,
            text: text
        )
        liveLines.append(line)
    }

    @available(macOS 26.0, *)
    private func ensureModuleReady(transcriber: SpeechTranscriber) async throws {
        let status = await AssetInventory.status(forModules: [transcriber])
        switch status {
        case .installed:
            return
        case .supported, .unsupported, .downloading:
            // 触发资产下载
            if let request = try await AssetInventory.assetInstallationRequest(supporting: [transcriber]) {
                try await request.downloadAndInstall()
            }
        @unknown default:
            return
        }
    }

    // MARK: - SFSpeechRecognizer (fallback)

    private func startLegacyRecognizer(
        bufferStream: AsyncStream<SendableAudioBuffer>,
        localUserName: String
    ) async throws {
        guard let recognizer = recognizer, recognizer.isAvailable else {
            throw TranscriptionError.recognizerUnavailable
        }
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.shouldReportPartialResults = true
        request.taskHint = .dictation
        if #available(macOS 13.0, *) {
            request.addsPunctuation = true
        }
        bufferRequest = request

        // 启动 task
        bufferTask = recognizer.recognitionTask(with: request) { [weak self] result, error in
            guard let self = self else { return }
            Task { @MainActor in
                if let result = result {
                    let text = result.bestTranscription.formattedString
                    if result.isFinal, !text.isEmpty {
                        let line = TranscriptLine(
                            speakerId: self.currentSpeakerId,
                            speakerName: self.currentSpeakerName,
                            timestamp: 0,
                            text: text
                        )
                        self.liveLines.append(line)
                    } else if !text.isEmpty {
                        // 实时更新最后一行（不累积新行）
                        if let last = self.liveLines.last {
                            let updated = TranscriptLine(
                                id: last.id,
                                speakerId: last.speakerId,
                                speakerName: last.speakerName,
                                timestamp: last.timestamp,
                                text: text
                            )
                            self.liveLines[self.liveLines.count - 1] = updated
                        } else {
                            // 首次出现文本
                            let line = TranscriptLine(
                                speakerId: self.currentSpeakerId,
                                speakerName: self.currentSpeakerName,
                                timestamp: 0,
                                text: text
                            )
                            self.liveLines.append(line)
                        }
                    }
                }
                if let error = error {
                    self.reportError(.recognizerFailed(error))
                }
            }
        }

        // 把 buffer 喂给 request
        inputStreamTask = Task {
            for await sendable in bufferStream {
                if Task.isCancelled { break }
                self.bufferRequest?.append(sendable.buffer)
            }
        }
    }

    private func stopLegacyRecognizer() {
        bufferTask?.cancel()
        bufferTask = nil
        bufferRequest?.endAudio()
        bufferRequest = nil
    }

    // MARK: - 工具

    private func requestSpeechPermission() async throws {
        let status = SFSpeechRecognizer.authorizationStatus()
        switch status {
        case .authorized:
            return
        case .notDetermined:
            let granted: Bool = await withCheckedContinuation { cont in
                SFSpeechRecognizer.requestAuthorization { auth in
                    cont.resume(returning: auth == .authorized)
                }
            }
            if !granted {
                throw TranscriptionError.speechPermissionDenied
            }
        case .denied, .restricted:
            throw TranscriptionError.speechPermissionDenied
        @unknown default:
            throw TranscriptionError.speechPermissionDenied
        }
    }

    private func reportError(_ error: TranscriptionError) {
        lastError = error
    }
}

// MARK: - 错误

enum TranscriptionError: LocalizedError {
    case speechPermissionDenied
    case recognizerUnavailable
    case analyzerFailed(Error)
    case recognizerFailed(Error)

    var errorDescription: String? {
        switch self {
        case .speechPermissionDenied:
            return "语音识别权限被拒绝。请到 系统设置 → 隐私与安全性 → 语音识别 启用映话。"
        case .recognizerUnavailable:
            return "当前 locale 的语音识别器不可用"
        case .analyzerFailed(let err):
            return "SpeechAnalyzer 失败：\(err.localizedDescription)"
        case .recognizerFailed(let err):
            return "语音识别失败：\(err.localizedDescription)"
        }
    }
}
