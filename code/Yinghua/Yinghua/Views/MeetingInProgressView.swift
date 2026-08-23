import SwiftUI

/// C06/01 meeting-in-progress
/// - 4 人 video grid（演示用 4 个纯色块 + 姓名首字母）
/// - 顶部 REC + 时间码
/// - 右侧 transcript 副屏（简化版）
struct MeetingInProgressView: View {
    @Environment(AppState.self) private var state

    @State private var pulsing = false

    var body: some View {
        @Bindable var state = state

        VStack(spacing: 0) {
            topBar
            Divider().background(Tokens.Color.hairline)
            HStack(spacing: 0) {
                videoGrid
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider().background(Tokens.Color.hairline)
                transcriptPane
                    .frame(width: 320)
            }
        }
        .task {
            withAnimation(.easeInOut(duration: 0.7).repeatForever(autoreverses: true)) {
                pulsing.toggle()
            }
        }
    }

    // MARK: - 顶部 REC 状态条

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
                    .font(.system(size: 13, weight: .medium, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite.opacity(0.85))
            }

            Spacer()

            // 顶部静音指示（mic off）
            HStack(spacing: 6) {
                Image(systemName: "mic.slash.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.warningOrange)
                Text("面试官已静音")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
        }
        .padding(.horizontal, Tokens.Spacing.lg)
        .padding(.vertical, Tokens.Spacing.sm)
        .background(.regularMaterial)
    }

    // MARK: - 4 人 video grid

    private var videoGrid: some View {
        let columns = [GridItem(.flexible(), spacing: 8), GridItem(.flexible(), spacing: 8)]
        return LazyVGrid(columns: columns, spacing: 8) {
            VideoTile(speaker: state.speakers[safe: 0] ?? Speaker(id: "?", name: "?", color: .purple))
            VideoTile(speaker: state.speakers[safe: 1] ?? Speaker(id: "?", name: "?", color: .teal), isMuted: true)
            VideoTile(speaker: Speaker(id: "candidate", name: "候选人", color: .pink))
            VideoTile(speaker: Speaker(id: "observer", name: "旁听", color: .warmWhite), isMuted: true)
        }
        .padding(Tokens.Spacing.md)
    }

    // MARK: - 右侧 transcript 副屏

    private var transcriptPane: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            Text("转录")
                .font(.system(size: 11, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)
                .padding(.top, Tokens.Spacing.md)
                .padding(.horizontal, Tokens.Spacing.md)

            ScrollView {
                LazyVStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
                    ForEach(state.transcriptLines) { line in
                        TranscriptRow(line: line)
                    }
                }
                .padding(.horizontal, Tokens.Spacing.md)
                .padding(.bottom, Tokens.Spacing.md)
            }
        }
        .background(.thinMaterial)
    }

    // MARK: - 派生

    private var timecode: String {
        let total = Int(state.recording.elapsed)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

// MARK: - 4 个 video tile

private struct VideoTile: View {
    let speaker: Speaker
    var isMuted: Bool = false

    var body: some View {
        ZStack {
            // 渐变底色（避免 video 纹理）
            LinearGradient(
                colors: [
                    speaker.color.color.opacity(0.35),
                    Tokens.Color.nearBlack,
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            // 大头像 + 名字
            VStack(spacing: 10) {
                SpeakerAvatar(speaker: speaker, size: 72)
                Text(speaker.name)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }

            // 左下角名字 chip
            VStack {
                Spacer()
                HStack {
                    Text(speaker.name)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Color.warmWhite)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.ultraThinMaterial, in: Capsule())
                    Spacer()
                    if isMuted {
                        Image(systemName: "mic.slash.fill")
                            .font(.system(size: 11))
                            .foregroundStyle(Tokens.Color.warningOrange)
                            .padding(6)
                            .background(.ultraThinMaterial, in: Circle())
                    }
                }
                .padding(8)
            }
        }
        .aspectRatio(16.0/9.0, contentMode: .fit)
        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
    }
}

private struct TranscriptRow: View {
    let line: TranscriptLine

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            HStack(spacing: 6) {
                Text(line.speakerName)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(line.timecode)
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            Text(line.text)
                .font(.system(size: 12))
                .foregroundStyle(Tokens.Color.warmWhite.opacity(0.85))
                .lineLimit(3)
        }
    }
}

// MARK: - safe subscript

private extension Array {
    subscript(safe index: Int) -> Element? {
        indices.contains(index) ? self[index] : nil
    }
}

#Preview("MeetingInProgress") {
    let state = makePreviewState()
    return MeetingInProgressView()
        .environment(state)
        .frame(width: 1200, height: 800)
        .background(Tokens.Color.nearBlack)
}

@MainActor
private func makePreviewState() -> AppState {
    let s = AppState()
    s.recording = .recording(startedAt: Date().addingTimeInterval(-154))
    return s
}
