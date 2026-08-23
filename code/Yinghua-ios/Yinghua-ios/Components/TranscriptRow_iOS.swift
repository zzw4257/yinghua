import SwiftUI

/// iOS 风格 transcript 单行（与 macOS transcript row 对齐）
/// - 左侧：speaker avatar
/// - 中部：speaker name + 转录文字
/// - 右侧：时间码
struct TranscriptRow_iOS: View {
    let line: TranscriptLine
    let speaker: Speaker?

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.sm) {
            if let speaker {
                SpeakerAvatar_iOS(speaker: speaker, size: 32)
            } else {
                Circle()
                    .fill(Tokens.Color.hairline)
                    .frame(width: 32, height: 32)
            }
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: Tokens.Spacing.xs) {
                    Text(line.speakerName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Tokens.Color.warmWhite)
                    Text(line.timecode)
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
                Text(line.text)
                    .font(.body)
                    .foregroundStyle(Tokens.Color.secondaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
            Spacer(minLength: 0)
        }
        .padding(.vertical, Tokens.Spacing.xs)
    }
}

#Preview {
    VStack(spacing: 0) {
        ForEach(TranscriptLine.demo) { line in
            TranscriptRow_iOS(
                line: line,
                speaker: Speaker.speaker(forId: line.speakerId)
            )
            Divider().background(Tokens.Color.hairline)
        }
    }
    .padding()
    .background(Tokens.Color.nearBlack)
    .preferredColorScheme(.dark)
}
