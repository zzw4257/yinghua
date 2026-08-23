import SwiftUI

/// C06/03 transcript-focus
/// - 单窗口 7 段说话人轮次（与 TranscriptLine.demo 对应）
/// - 顶部 REC + 时间码
/// - 主区按 speaker 分组的可滚动 transcript
struct TranscriptFocusView: View {
    @Environment(AppState.self) private var state

    @State private var pulsing = false

    var body: some View {
        @Bindable var state = state

        VStack(spacing: 0) {
            topBar
            Divider().background(Tokens.Color.hairline)
            ScrollView {
                LazyVStack(alignment: .leading, spacing: Tokens.Spacing.lg) {
                    ForEach(state.transcriptLines) { line in
                        TranscriptBlock(line: line)
                    }
                    // 末尾占位（说明仍在录制）
                    HStack(spacing: 6) {
                        Circle()
                            .fill(Tokens.Color.recRed)
                            .frame(width: 6, height: 6)
                            .opacity(pulsing ? 1.0 : 0.3)
                        Text("正在聆听…")
                            .font(.system(size: 12))
                            .foregroundStyle(Tokens.Color.tertiaryText)
                    }
                    .padding(.top, Tokens.Spacing.sm)
                }
                .padding(Tokens.Spacing.xl)
            }
        }
        .background(.regularMaterial)
        .task {
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                pulsing.toggle()
            }
        }
    }

    // MARK: - 顶部

    private var topBar: some View {
        HStack(spacing: Tokens.Spacing.md) {
            HStack(spacing: 8) {
                Circle()
                    .fill(Tokens.Color.recRed)
                    .frame(width: 8, height: 8)
                    .scaleEffect(pulsing ? 1.15 : 1.0)
                Text("录制中")
                    .font(.system(size: 12, weight: .heavy))
                    .tracking(1)
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(timecode)
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }

            Spacer()

            // 说话人 chip
            ForEach(state.speakers) { speaker in
                HStack(spacing: 6) {
                    SpeakerAvatar(speaker: speaker, size: 20)
                    Text(speaker.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Color.warmWhite)
                }
            }
        }
        .padding(.horizontal, Tokens.Spacing.lg)
        .padding(.vertical, Tokens.Spacing.sm)
        .background(.regularMaterial)
    }

    private var timecode: String {
        let total = Int(state.recording.elapsed)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

// MARK: - 单个 transcript block（§4.5 Transcript Row）

private struct TranscriptBlock: View {
    let line: TranscriptLine

    private var speaker: Speaker {
        Speaker.speaker(forId: line.speakerId) ?? Speaker(id: line.speakerId, name: line.speakerName, color: SpeakerColor.assign(for: line.speakerId))
    }

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.md) {
            SpeakerAvatar(speaker: speaker, size: 36)
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(line.speakerName)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Tokens.Color.warmWhite)
                    Text(line.timecode)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
                Text(line.text)
                    .font(.system(size: 14))
                    .foregroundStyle(Tokens.Color.warmWhite.opacity(0.92))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

#Preview("TranscriptFocus") {
    let state = makePreviewState()
    return TranscriptFocusView()
        .environment(state)
        .frame(width: 1200, height: 800)
        .background(Tokens.Color.nearBlack)
}

@MainActor
private func makePreviewState() -> AppState {
    let s = AppState()
    s.recording = .recording(startedAt: Date().addingTimeInterval(-230))
    return s
}
