import SwiftUI
import AppKit

/// 录制中的浮窗控制面板（§4.2）
/// - NSPanel（`.floating` + `.nonactivatingPanel`）包装 SwiftUI
/// - 4 段式：status / transport / secondary
/// - 严格不画 waveform / EKG / audio visualizer
struct ControlPanel: View {
    @Bindable var state: AppState
    var onClose: () -> Void

    @State private var pulsing = false

    var body: some View {
        VStack(spacing: 0) {
            // 段 1: status
            statusSection
            Divider().background(Tokens.Color.hairline)
            // 段 2: transport
            transportSection
            Divider().background(Tokens.Color.hairline)
            // 段 3: secondary
            secondarySection
        }
        .frame(width: 220)
        .background(.regularMaterial)
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.window, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.window, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
        .task {
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                pulsing.toggle()
            }
        }
    }

    // MARK: - 段 1: status

    private var statusSection: some View {
        HStack(spacing: Tokens.Spacing.sm) {
            Circle()
                .fill(Tokens.Color.recRed)
                .frame(width: 8, height: 8)
                .scaleEffect(pulsing ? 1.15 : 1.0)
            Text("REC")
                .font(.system(size: 11, weight: .heavy))
                .tracking(1)
                .foregroundStyle(Tokens.Color.warmWhite)
            Spacer()
            Text(timecode)
                .font(.system(size: 14, weight: .medium, design: .monospaced))
                .foregroundStyle(Tokens.Color.warmWhite)
        }
        .padding(.horizontal, Tokens.Spacing.md)
        .padding(.vertical, Tokens.Spacing.sm)
    }

    // MARK: - 段 2: transport

    private var transportSection: some View {
        HStack(spacing: 0) {
            transportButton(symbol: state.recording.isActive ? "pause.fill" : "play.fill") {
                if state.recording.isActive {
                    state.pauseRecording()
                } else if case .paused = state.recording {
                    state.resumeRecording()
                }
            }
            Divider().background(Tokens.Color.hairline).frame(height: 24)
            transportButton(symbol: "stop.fill") {
                state.stopRecording()
            }
            .foregroundStyle(Tokens.Color.recRed)
        }
        .frame(height: 40)
    }

    // MARK: - 段 3: secondary

    private var secondarySection: some View {
        HStack(spacing: 0) {
            transportButton(symbol: "gearshape") {
                // ⌘,
                NSApp.sendAction(NSSelectorFromString("showSettingsWindow:"), to: nil, from: nil)
            }
            Divider().background(Tokens.Color.hairline).frame(height: 24)
            transportButton(symbol: "square.and.arrow.up") {
                // 触发分享 / 导出
            }
            Divider().background(Tokens.Color.hairline).frame(height: 24)
            transportButton(symbol: "xmark") {
                onClose()
            }
        }
        .frame(height: 40)
    }

    // MARK: - 子组件

    private func transportButton(symbol: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: symbol)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Tokens.Color.warmWhite)
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - 派生

    private var timecode: String {
        let total = Int(state.recording.elapsed)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

// MARK: - NSPanel 桥接

/// 浮窗（用 NSPanel 而非 WindowGroup，因为它要 floating + nonactivating）
final class ControlPanelWindowController: NSWindowController {
    convenience init(state: AppState) {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 160),
            styleMask: [.borderless, .nonactivatingPanel, .resizable, .utilityWindow, .hudWindow],
            backing: .buffered,
            defer: false
        )
        panel.isFloatingPanel = true
        panel.level = .floating
        panel.hidesOnDeactivate = false
        panel.becomesKeyOnlyIfNeeded = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.titleVisibility = .hidden
        panel.titlebarAppearsTransparent = true
        panel.isMovableByWindowBackground = true
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.hasShadow = true
        panel.isReleasedWhenClosed = false

        let host = NSHostingView(
            rootView: ControlPanel(state: state) {
                panel.orderOut(nil)
            }
        )
        host.frame = NSRect(x: 0, y: 0, width: 220, height: 160)
        host.autoresizingMask = [.width, .height]
        panel.contentView = host
        panel.setContentSize(NSSize(width: 220, height: 160))

        // 默认放在主窗口右下角
        if let screen = NSScreen.main {
            let screenFrame = screen.visibleFrame
            let origin = NSPoint(
                x: screenFrame.maxX - 220 - 24,
                y: screenFrame.minY + 24
            )
            panel.setFrameOrigin(origin)
        }

        self.init(window: panel)
    }
}
