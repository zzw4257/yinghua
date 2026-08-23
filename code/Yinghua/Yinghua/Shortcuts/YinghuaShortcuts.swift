import AppIntents
import Foundation

// MARK: - 共享上下文

/// AppIntents 与 UI 共用的运行时 service 容器
///
/// 为什么不直接复用 `AppState`：
/// - `AudioCaptureService` 是独占资源（AVAudioEngine + SCStream），
///   同一时间只允许一个录制实例（`start()` 里有 `guard !isRecording`）。
/// - 当前 (`@State private var appState = AppState()`) 是 SwiftUI 管理的，
///   外部拿不到单例。`@MainActor` + 沙盒下 `AudioCaptureService()` 多实例不会真的
///   冲突，`start()` 内部有 guard；C49+ 落地 AppState 单例共享时改成复用。
@MainActor
enum YinghuaIntentContext {
    static func makeAudio() -> AudioCaptureService { AudioCaptureService() }
    static func makeLibrary() -> LibraryService { LibraryService() }
}

// MARK: - Start Recording

/// Siri / Shortcuts 入口 1：开始录制当前会议
///
/// 行为：
/// - 后台启动（`openAppWhenRun = false`）：用户不一定要看到映话主窗口
/// - 调用 `AudioCaptureService.start()`——它内部会请求麦克风 + 屏幕录制权限
/// - 失败时返回**可读**的降级文案（不抛 OSError 让 Siri 念）
struct StartRecordingIntent: AppIntent {
    static var title: LocalizedStringResource { "Start Recording" }
    static var description: IntentDescription? {
        IntentDescription("Start recording the current meeting in 映话 (Yinghua). Captures both system audio and your microphone.")
    }
    static var openAppWhenRun: Bool { false }
    static var parameterSummary: some ParameterSummary {
        Summary("Start recording in 映话")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let audio = YinghuaIntentContext.makeAudio()
        do {
            try await audio.start(
                includeSystemAudio: true,
                includeMicrophone: true
            )
            return .result(dialog: IntentDialog(stringLiteral: "Recording started in 映话."))
        } catch let error as AudioCaptureError {
            let message = error.errorDescription
                ?? "需要麦克风和屏幕录制权限，请先到 系统设置 → 隐私与安全性 授权后再试。"
            return .result(dialog: IntentDialog(stringLiteral: message))
        } catch {
            return .result(dialog: IntentDialog(stringLiteral: "启动录制失败：\(error.localizedDescription)"))
        }
    }
}

// MARK: - Stop Recording

/// Siri / Shortcuts 入口 2：停止录制
///
/// 行为：
/// - 调用 `AudioCaptureService.stop()` 返回录音文件 URL
/// - 如果没有在录制，返回 nil——降级文案 "Yinghua is not recording."
struct StopRecordingIntent: AppIntent {
    static var title: LocalizedStringResource { "Stop Recording" }
    static var description: IntentDescription? {
        IntentDescription("Stop the current 映话 recording. The audio file is saved locally.")
    }
    static var openAppWhenRun: Bool { false }
    static var parameterSummary: some ParameterSummary {
        Summary("Stop recording in 映话")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ProvidesDialog {
        let audio = YinghuaIntentContext.makeAudio()
        let url = audio.stop()
        if let url = url {
            return .result(dialog: IntentDialog(stringLiteral: "Recording saved: \(url.lastPathComponent)"))
        } else {
            return .result(dialog: IntentDialog(stringLiteral: "映话 is not currently recording."))
        }
    }
}

// MARK: - Get Latest Summary

/// Siri / Shortcuts 入口 3：拿最近一次会议的 AI 总结
///
/// 行为：
/// - 调 `LibraryService.latestItem()`
/// - 找到录音但还没生成 summary → 降级文案
/// - 还没任何录音 → 降级文案
/// - 有 summary → 返回 4 段式计数（key moments / decisions / action items / open questions）
struct GetLatestSummaryIntent: AppIntent {
    static var title: LocalizedStringResource { "Get Latest Summary" }
    static var description: IntentDescription? {
        IntentDescription("Get the AI summary of the most recent 映话 meeting.")
    }
    static var openAppWhenRun: Bool { false }
    static var parameterSummary: some ParameterSummary {
        Summary("Get latest summary from 映话")
    }

    @MainActor
    func perform() async throws -> some IntentResult & ReturnsValue<String> & ProvidesDialog {
        let library = YinghuaIntentContext.makeLibrary()
        guard let latest = library.latestItem() else {
            return .result(
                value: "No recordings yet.",
                dialog: IntentDialog(stringLiteral: "映话 还没有任何录音记录。先录制一次会议再来问吧。")
            )
        }
        guard let summary = latest.summary else {
            return .result(
                value: "Recording exists but no summary yet.",
                dialog: IntentDialog(stringLiteral: "最近一次录音是 \(latest.fileName)，但还没生成 AI 总结。")
            )
        }
        let body = """
        \(latest.fileName)
        \(summary.keyMoments.count) key moments
        \(summary.decisions.count) decisions
        \(summary.actionItems.count) action items
        \(summary.openQuestions.count) open questions
        """
        return .result(
            value: body,
            dialog: IntentDialog(stringLiteral: "已找到最近总结。")
        )
    }
}

// MARK: - AppShortcutsProvider

/// 系统级入口：把上面 3 个 AppIntent 暴露给 Shortcuts app / Siri / Spotlight
///
/// - macOS 13+ 安装 app 时系统会扫这个 conformance 静态注册到 Shortcuts gallery
/// - 用户也可以在 Shortcuts app 里手动搜索 / 拖出来当 action 用
/// - trigger phrase 里的 `\(applicationName)` 会被替换为 app 的 display name（映话）
struct YinghuaShortcutsProvider: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: StartRecordingIntent(),
            phrases: [
                "Start recording in \(.applicationName)",
                "Record meeting in \(.applicationName)",
                "用 \(.applicationName) 开始录制"
            ],
            shortTitle: "Start Recording",
            systemImageName: "record.circle"
        )
        AppShortcut(
            intent: StopRecordingIntent(),
            phrases: [
                "Stop recording in \(.applicationName)",
                "End meeting in \(.applicationName)",
                "用 \(.applicationName) 停止录制"
            ],
            shortTitle: "Stop Recording",
            systemImageName: "stop.circle"
        )
        AppShortcut(
            intent: GetLatestSummaryIntent(),
            phrases: [
                "Get latest summary from \(.applicationName)",
                "Show last meeting summary in \(.applicationName)",
                "看 \(.applicationName) 最近总结"
            ],
            shortTitle: "Get Latest Summary",
            systemImageName: "doc.text"
        )
    }
}
