import SwiftUI

/// iOS 屏 2 · Recording active
/// - 大标题 "Recording" + 取消按钮
/// - 中央：4 人 avatar 圆形（STYLE 1）
/// - 时间码 `00:14:32` 大字（SF Pro Display 48pt）
/// - 下方 transcript 实时滚动
/// - 底部：3 按钮（Pause / Stop / Continue）+ Share 紫青 CTA
struct RecordingView: View {
    @Environment(iOSAppState.self) private var appState
    @State private var now: Date = .init()

    /// 每秒 tick（仅在 recording 状态推进 elapsed）
    private let tick = Timer.publish(every: 1, on: .main, in: .common).autoconnect()

    var body: some View {
        NavigationStack {
            ZStack {
                Tokens.Color.nearBlack.ignoresSafeArea()

                VStack(spacing: 0) {
                    avatarRing
                        .padding(.top, Tokens.Spacing.lg)

                    timecodeLabel
                        .padding(.top, Tokens.Spacing.lg)

                    transcriptList
                        .padding(.top, Tokens.Spacing.md)

                    controlBar
                        .padding(.horizontal, Tokens.Spacing.md)
                        .padding(.vertical, Tokens.Spacing.lg)
                }
            }
            .navigationTitle("Recording")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Cancel") {
                        appState.stopRecording()
                    }
                    .foregroundStyle(Tokens.Color.tertiaryText)
                }
            }
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onReceive(tick) { _ in
                if appState.recording.isActive {
                    now = Date()
                }
            }
        }
    }

    // MARK: - 4 人 avatar 圆形

    private var avatarRing: some View {
        ZStack {
            ForEach(Array(appState.speakers.prefix(4).enumerated()), id: \.element.id) { idx, speaker in
                SpeakerAvatar_iOS(speaker: speaker, size: 56)
                    .offset(avatarOffset(for: idx))
                    .overlay(
                        Circle()
                            .stroke(Tokens.Color.nearBlack, lineWidth: 3)
                    )
            }
        }
        .frame(height: 120)
    }

    private func avatarOffset(for index: Int) -> CGSize {
        // 4 个 avatar 排成正方形
        let radius: CGFloat = 40
        switch index {
        case 0: return CGSize(width: -radius, height: -radius)
        case 1: return CGSize(width:  radius, height: -radius)
        case 2: return CGSize(width: -radius, height:  radius)
        case 3: return CGSize(width:  radius, height:  radius)
        default: return .zero
        }
    }

    // MARK: - 时间码大字

    private var timecodeLabel: some View {
        Text(elapsedFormatted)
            .font(.system(size: 48, weight: .semibold, design: .rounded))
            .monospacedDigit()
            .foregroundStyle(Tokens.Color.warmWhite)
            .accessibilityLabel("Elapsed time \(elapsedFormatted)")
    }

    private var elapsedFormatted: String {
        let total = Int(appState.recording.isActive
                         ? Date().timeIntervalSince(startedAt)
                         : appState.recording.elapsed)
        let h = total / 3600
        let m = (total % 3600) / 60
        let s = total % 60
        return String(format: "%02d:%02d:%02d", h, m, s)
    }

    private var startedAt: Date {
        if case .recording(let startedAt) = appState.recording {
            return startedAt
        }
        return Date()
    }

    // MARK: - transcript list

    private var transcriptList: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 0) {
                    ForEach(appState.transcriptLines) { line in
                        TranscriptRow_iOS(
                            line: line,
                            speaker: Speaker.speaker(forId: line.speakerId)
                        )
                        .id(line.id)
                        .padding(.horizontal, Tokens.Spacing.md)
                        Divider()
                            .background(Tokens.Color.hairline)
                            .padding(.horizontal, Tokens.Spacing.md)
                    }
                }
            }
            .onChange(of: appState.transcriptLines.count) { _, _ in
                if let last = appState.transcriptLines.last {
                    withAnimation(.easeOut(duration: 0.25)) {
                        proxy.scrollTo(last.id, anchor: .bottom)
                    }
                }
            }
        }
    }

    // MARK: - 底部控制条

    private var controlBar: some View {
        VStack(spacing: Tokens.Spacing.md) {
            HStack(spacing: Tokens.Spacing.md) {
                controlButton(
                    systemName: appState.recording.isActive ? "pause.fill" : "play.fill",
                    title: appState.recording.isActive ? "Pause" : "Resume",
                    action: {
                        if appState.recording.isActive {
                            appState.pauseRecording()
                        } else {
                            appState.resumeRecording()
                        }
                    }
                )
                controlButton(
                    systemName: "stop.fill",
                    title: "Stop",
                    tint: Tokens.Color.recRed,
                    action: { appState.stopRecording() }
                )
                controlButton(
                    systemName: "checkmark",
                    title: "Done",
                    action: { appState.stopRecording() }
                )
            }

            shareButton
        }
    }

    private func controlButton(
        systemName: String,
        title: String,
        tint: Color = Tokens.Color.warmWhite,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.title2)
                Text(title)
                    .font(.caption2.weight(.medium))
            }
            .foregroundStyle(tint)
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(
                RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous)
                    .fill(Tokens.Color.graphite)
            )
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous)
                    .stroke(Tokens.Color.hairline, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    private var shareButton: some View {
        Button {
            // v0.1: no-op
        } label: {
            HStack(spacing: Tokens.Spacing.sm) {
                Image(systemName: "square.and.arrow.up")
                Text("Share Recording")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 50)
            .background(
                RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous)
                    .fill(Tokens.Color.primaryGradient)
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    RecordingView()
        .environment(iOSAppState())
        .preferredColorScheme(.dark)
}
