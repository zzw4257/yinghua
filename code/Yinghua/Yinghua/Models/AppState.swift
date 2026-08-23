import SwiftUI
import Combine
import AVFoundation

/// 5 个产品 surface
enum AppSurface: String, CaseIterable, Identifiable, Hashable {
    case emptyState        // C06/02
    case meetingInProgress // C06/01
    case transcriptFocus   // C06/03
    case reviewMode        // C06/04
    case onboarding        // C06/05 (单独 Window)

    var id: String { rawValue }

    var title: String {
        switch self {
        case .emptyState:        return "最近"
        case .meetingInProgress: return "录制中"
        case .transcriptFocus:   return "转录"
        case .reviewMode:        return "复盘"
        case .onboarding:        return "欢迎"
        }
    }

    var symbol: String {
        switch self {
        case .emptyState:        return "circle.grid.2x2"
        case .meetingInProgress: return "record.circle"
        case .transcriptFocus:   return "text.alignleft"
        case .reviewMode:        return "doc.text.magnifyingglass"
        case .onboarding:        return "sparkles"
        }
    }
}

/// 录制状态机
enum RecordingState: Equatable {
    case idle
    case recording(startedAt: Date)
    case paused(elapsed: TimeInterval)
    case stopped

    var isActive: Bool {
        if case .recording = self { return true }
        return false
    }

    var elapsed: TimeInterval {
        switch self {
        case .recording(let startedAt):
            return Date().timeIntervalSince(startedAt)
        case .paused(let elapsed):
            return elapsed
        case .idle, .stopped:
            return 0
        }
    }
}

/// 全局 app 状态（用 @Observable，macOS 14+ Observation framework）
///
/// 标记为 `@unchecked Sendable` 以满足 Swift 6 严格并发：
/// - 所有 @Observable 属性的写入都在 main actor（来自 UI 调用）
/// - Observation framework 内部对所有读写做了同步
/// - 不在 main actor 之外启动任何对 self 属性的并发修改
@Observable
final class AppState: @unchecked Sendable {
    /// 当前主窗口展示的 surface
    var currentSurface: AppSurface = .emptyState

    /// 录制状态
    var recording: RecordingState = .idle

    /// 远端说话人（meeting-in-progress + transcript-focus 共用）
    var speakers: [Speaker] = Speaker.demoSpeakers

    /// 最近一次 review 模式使用的 meeting（空 = 没有）
    var lastMeeting: MeetingRecord? = MeetingRecord.demo

    /// 控制面板可见性
    var isControlPanelVisible: Bool = false

    /// 当前转录 buffer
    var transcriptLines: [TranscriptLine] = TranscriptLine.demo

    /// AI 总结（review-mode 用）
    var summary: MeetingSummary = .preview

    /// 当前选中的 provider（用于 "AI 总结"）
    var selectedProvider: APIProvider = .anthropic

    /// 服务持有（不暴露给 UI，但持有引用）
    let audioCapture: AudioCaptureService
    let transcription: TranscriptionService
    let summaryService: SummaryService
    let permissions: PermissionService
    /// C49 第三方集成推送：会议总结生成后 fan-out 到 Notion / Slack / Webhook
    let integrationsManager: IntegrationsManager

    private(set) var lastRecordingURL: URL?

    @MainActor
    init() {
        self.audioCapture = AudioCaptureService()
        self.transcription = TranscriptionService()
        self.summaryService = SummaryService()
        self.permissions = PermissionService()
        self.integrationsManager = IntegrationsManager()
    }

    // MARK: - 表面切换

    func switchSurface(_ surface: AppSurface) {
        currentSurface = surface
    }

    // MARK: - 录制控制

    /// 开始录制（接 AudioCaptureService + TranscriptionService）
    func startRecording() {
        guard !recording.isActive else { return }

        recording = .recording(startedAt: Date())
        isControlPanelVisible = true
        switchSurface(.meetingInProgress)

        // 真实接 audio + transcription
        // Swift 6 严格并发：把整段逻辑下沉到 @MainActor private func，
        // 避免在 `Task { @MainActor [audioCapture, transcription] in ... self.x = ... }`
        // 这种写法里隐式捕获 self（self 非 Sendable，跨闭包会报 "sending 'self' risks causing data races"）。
        // 显式 [weak self] 进一步保证 self 不被隐式捕获。
        Task { @MainActor [weak self] in
            await self?.startRecordingImpl()
        }
    }

    /// 启动录制的实现：始终在 @MainActor 上运行，所有 await 走同一 actor。
    @MainActor
    private func startRecordingImpl() async {
        do {
            try await audioCapture.start(
                includeSystemAudio: true,
                includeMicrophone: true
            )
            if let stream = audioCapture.bufferStream {
                try await transcription.start(bufferStream: stream)
            }
        } catch {
            // 启动失败：回滚 UI 状态
            self.recording = .idle
            self.isControlPanelVisible = false
            self.switchSurface(.emptyState)
            #if DEBUG
            print("Recording start failed: \(error)")
            #endif
        }
    }

    func pauseRecording() {
        if case .recording(let startedAt) = recording {
            recording = .paused(elapsed: Date().timeIntervalSince(startedAt))
        }
    }

    func resumeRecording() {
        if case .paused(let elapsed) = recording {
            recording = .recording(startedAt: Date().addingTimeInterval(-elapsed))
        }
    }

    func stopRecording() {
        recording = .stopped
        isControlPanelVisible = false
        switchSurface(.reviewMode)

        // 停 audio + transcription，把 transcriptLines 同步
        // 同样下沉到 @MainActor private func + 显式 [weak self]，
        // 避免 self 跨 actor 引发 "sending 'self'" 编译错误。
        Task { @MainActor [weak self] in
            await self?.stopRecordingImpl()
        }
    }

    /// 停止录制的实现：始终在 @MainActor 上运行。
    @MainActor
    private func stopRecordingImpl() async {
        await transcription.stop()
        let url = audioCapture.stop()
        self.lastRecordingURL = url
        self.transcriptLines = transcription.liveLines
    }

    // MARK: - AI 总结（接 SummaryService + KeychainService）

    /// 生成当前 transcript 的 AI 总结，结果写到 `self.summary`
    @MainActor
    func generateSummary() async {
        do {
            let provider = selectedProvider
            guard let apiKey = KeychainService.loadAPIKey(for: provider), !apiKey.isEmpty else {
                #if DEBUG
                print("No API key for \(provider)")
                #endif
                return
            }
            let endpoint = KeychainService.loadEndpoint(for: provider)
            let model = KeychainService.loadModel(for: provider)
            let summary = try await summaryService.generateSummary(
                transcript: transcriptLines,
                provider: provider,
                apiKey: apiKey,
                endpoint: endpoint,
                model: model
            )
            self.summary = summary

            // C49：总结生成成功 → 自动 fan-out 到启用的第三方集成
            // 文件名优先用最近一次会议名；缺省用日期占位（demo 场景下永远是 demo 会议名）
            let fileName = lastMeeting?.title ?? defaultFileName()
            await integrationsManager.pushSummary(
                summary,
                fileName: fileName,
                recordedAt: lastMeeting?.recordedAt ?? .now
            )
        } catch {
            #if DEBUG
            print("Summary generation failed: \(error)")
            #endif
        }
    }

    /// 没有 MeetingRecord 时用的占位文件名
    private func defaultFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        formatter.locale = Locale(identifier: "zh_Hans")
        return "映话 · \(formatter.string(from: .now))"
    }
}

// MARK: - 最近会议

struct MeetingRecord: Identifiable, Hashable {
    let id: UUID
    let title: String
    let recordedAt: Date
    let durationSeconds: TimeInterval
    let fileSizeMB: Double
    let speakers: [Speaker]
    let languages: [String]
    let transcriptLines: [TranscriptLine]
    let summary: MeetingSummary

    static let demo = MeetingRecord(
        id: UUID(),
        title: "张三-前端-终面",
        recordedAt: Date(),
        durationSeconds: 48 * 60,
        fileSizeMB: 1.2 * 1024,
        speakers: Speaker.demoSpeakers,
        languages: ["MP4", "中英双语", "2 位发言人"],
        transcriptLines: TranscriptLine.demo,
        summary: .preview
    )
}

// MARK: - 占位数据

extension Speaker {
    /// 演示用 2 个说话人（面试官 + 我），与 C06 review-mode 右侧 chips 对应
    static let demoSpeakers: [Speaker] = [
        Speaker(id: "interviewer", name: "面试官", color: .purple, isLocal: false),
        Speaker(id: "me",         name: "我",     color: .teal,   isLocal: true),
    ]

    static func speaker(forId id: String) -> Speaker? {
        demoSpeakers.first(where: { $0.id == id })
    }
}

extension TranscriptLine {
    static let demo: [TranscriptLine] = [
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 0,
                       text: "我们直接进入系统设计这一轮。假设你负责一个短链服务，你会怎么设计？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 18,
                       text: "好的，我会拆三层：接入层做流量收敛，生成层用发号器生成 7 位 id，存储层用 KV。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 62,
                       text: "那如果发号器单点怎么办？你会怎么保证 id 不冲突？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 78,
                       text: "我会用 Snowflake 那一类方案，引入 worker id + 序列号，必要时用 Redis 兜底防冲突。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 142,
                       text: "听起来合理。那短链的缓存策略呢？所有长链都缓存还是只缓存热 key？"),
        TranscriptLine(speakerId: "me", speakerName: "我", timestamp: 158,
                       text: "只缓存热 key。我会用 LRU + 写穿策略，命中率大概能在 95% 以上，存储压力可控。"),
        TranscriptLine(speakerId: "interviewer", speakerName: "面试官", timestamp: 230,
                       text: "好。这部分我没什么问题了，最后反问你有什么想问我们的？"),
    ]
}
