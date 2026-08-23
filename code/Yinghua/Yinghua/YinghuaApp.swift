import SwiftUI
import AppKit
import AppIntents

@main
struct YinghuaApp: App {
    @State private var appState = AppState()
    @State private var controlPanel: ControlPanelWindowController?

    init() {
        // 注册 crash handlers（uncaught exception + fatal signals）。
        // 默认 opt-out，不会上报；需要用户在 设置 → 诊断 显式开启。
        CrashReporter.shared.setup()
    }

    var body: some Scene {
        // 主窗口：4 个主 surface 之间切换
        WindowGroup("映话", id: "main") {
            MainWindow()
                .environment(appState)
                .frame(minWidth: 1000, minHeight: 700)
                .task {
                    // 启动时把上次未发的 fatal crash 上报（仅在 opt-in 时）
                    await CrashReporter.shared.uploadPending()
                }
                .onChange(of: appState.isControlPanelVisible) { _, isVisible in
                    toggleControlPanel(visible: isVisible)
                }
        }
        .windowResizability(.contentSize)
        .commands {
            // ⌘, 走系统设置（§5.1 单屏铁律）
            CommandGroup(replacing: .appSettings) {
                Button("设置…") {
                    NSApp.sendAction(NSSelectorFromString("showSettingsWindow:"), to: nil, from: nil)
                }
                .keyboardShortcut(",", modifiers: .command)
            }
            // 录制快捷键
            CommandMenu("录制") {
                Button("开始录制") { appState.startRecording() }
                    .keyboardShortcut("r", modifiers: [.command, .shift])
                Button("停止录制") { appState.stopRecording() }
                    .keyboardShortcut("r", modifiers: [.command, .option])
            }
        }

        // 独立 Window：onboarding（§5 单屏铁律：转录独立成屏，onboarding 也独立）
        Window("欢迎使用映话", id: "onboarding") {
            OnboardingView()
                .environment(appState)
                .frame(width: 500, height: 720)
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)

        // 独立 Window：设置（API keys / 权限 / 关于）
        Window("映话 · 设置", id: "settings") {
            SettingsView()
                .environment(appState)
        }
        .windowResizability(.contentSize)
        .defaultPosition(.center)
    }

    // MARK: - 控制面板

    private func toggleControlPanel(visible: Bool) {
        if visible {
            if controlPanel == nil {
                controlPanel = ControlPanelWindowController(state: appState)
            }
            controlPanel?.showWindow(nil)
        } else {
            controlPanel?.close()
        }
    }
}

// MARK: - 暴露给 Shortcuts / App Intents

extension YinghuaApp {
    /// 共享的 AudioCaptureService（C48 阶段：每个 Intent 内 new 一个。
    /// C49+ 落地 `AppState.shared` 时改成 `AppState.shared.audioCapture`，
    /// 让 UI 和 Shortcuts 共用同一个实例，避免双开冲突。）
    @MainActor
    static var sharedAudioService: AudioCaptureService { AudioCaptureService() }

    /// 共享的 LibraryService（给 GetLatestSummaryIntent 用）
    @MainActor
    static var sharedLibraryService: LibraryService { LibraryService() }
}
