import SwiftUI

/// C06/04 review-mode
/// - 左：file card + 5 行 transcript 预览 + speaker chips
/// - 右：AI 总结 4 折叠段（关键瞬间 / 决定 / 待办 / 遗留问题）
/// - 底部 2x2 按钮簇
struct ReviewModeView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        @Bindable var state = state

        VStack(spacing: 0) {
            HStack(spacing: 0) {
                leftColumn
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                Divider().background(Tokens.Color.hairline)
                rightSummary
                    .frame(width: 380)
            }
            Divider().background(Tokens.Color.hairline)
            bottomActions
        }
        .background(.regularMaterial)
    }

    // MARK: - 左：file card + transcript + chips

    private var leftColumn: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.lg) {
            if let meeting = state.lastMeeting {
                fileCard(meeting: meeting)
            }

            Text("转录预览")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)

            transcriptList

            speakerChips

            Spacer()
        }
        .padding(Tokens.Spacing.xl)
    }

    private func fileCard(meeting: MeetingRecord) -> some View {
        HStack(spacing: Tokens.Spacing.md) {
            // 紫色 Y file icon（48x48）
            ZStack {
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    .fill(Tokens.Color.purpleVivid.opacity(0.18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10, style: .continuous)
                            .stroke(Tokens.Color.purpleVivid.opacity(0.4), lineWidth: 1)
                    )
                Text("Y")
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .foregroundStyle(Tokens.Color.purpleVivid)
            }
            .frame(width: 48, height: 48)

            VStack(alignment: .leading, spacing: 2) {
                Text(meeting.title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(meeting.subtitle)
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }

            Spacer()

            // Open pill
            SecondaryButton(title: "Open", symbol: "arrow.up.right", height: 28) {
                // 打开 Finder
            }
            .frame(width: 90)
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
    }

    private var transcriptList: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.xs) {
            ForEach(Array(state.transcriptLines.prefix(5).enumerated()), id: \.element.id) { _, line in
                HStack(alignment: .top, spacing: Tokens.Spacing.sm) {
                    Text(line.timecode)
                        .font(.system(size: 11, weight: .medium, design: .monospaced))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                        .frame(width: 40, alignment: .leading)
                    Text(line.speakerName)
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundStyle(Tokens.Color.purpleVivid)
                        .frame(width: 50, alignment: .leading)
                    Text(line.text)
                        .font(.system(size: 12))
                        .foregroundStyle(Tokens.Color.warmWhite.opacity(0.85))
                        .lineLimit(1)
                }
            }
        }
    }

    private var speakerChips: some View {
        HStack(spacing: Tokens.Spacing.sm) {
            ForEach(state.speakers) { speaker in
                HStack(spacing: 6) {
                    Circle()
                        .fill(speaker.color.color)
                        .frame(width: 8, height: 8)
                    Text("\(speaker.name) 62%")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(Tokens.Color.warmWhite)
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(.regularMaterial, in: Capsule())
                .overlay(Capsule().stroke(Tokens.Color.hairline, lineWidth: 1))
            }
            Spacer()
            GhostButton(title: "完成", symbol: "checkmark") {}
        }
    }

    // MARK: - 右：AI 总结

    private var rightSummary: some View {
        @Bindable var state = state

        return VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
            HStack(alignment: .firstTextBaseline) {
                Text("AI 总结")
                    .font(.system(size: 14, weight: .semibold))
                    .tracking(1)
                    .foregroundStyle(Tokens.Color.warmWhite)
                Spacer()
                GhostButton(title: "重新生成", symbol: "arrow.clockwise") {}
            }
            .padding(.top, Tokens.Spacing.lg)
            .padding(.horizontal, Tokens.Spacing.lg)

            ScrollView {
                VStack(spacing: Tokens.Spacing.sm) {
                    CollapsibleSectionCard(icon: "sparkles",
                                            title: "关键瞬间",
                                            count: state.summary.keyMoments.count) {
                        ForEach(Array(state.summary.keyMoments.enumerated()), id: \.offset) { idx, text in
                            BulletItem(text: text, index: idx)
                        }
                    }
                    CollapsibleSectionCard(icon: "checkmark.circle.fill",
                                            title: "达成的决定",
                                            count: state.summary.decisions.count) {
                        ForEach(Array(state.summary.decisions.enumerated()), id: \.offset) { idx, text in
                            BulletItem(text: text, index: idx)
                        }
                    }
                    CollapsibleSectionCard(icon: "list.bullet.rectangle",
                                            title: "待办",
                                            count: state.summary.actionItems.count) {
                        ForEach(Array(state.summary.actionItems.enumerated()), id: \.offset) { idx, text in
                            BulletItem(text: text, index: idx)
                        }
                    }
                    CollapsibleSectionCard(icon: "questionmark.circle",
                                            title: "遗留问题",
                                            count: state.summary.openQuestions.count) {
                        ForEach(Array(state.summary.openQuestions.enumerated()), id: \.offset) { idx, text in
                            BulletItem(text: text, index: idx)
                        }
                    }
                }
                .padding(.horizontal, Tokens.Spacing.lg)
                .padding(.bottom, Tokens.Spacing.lg)
            }
        }
    }

    // MARK: - 底部 2x2 按钮

    private var bottomActions: some View {
        let columns = [GridItem(.flexible(), spacing: Tokens.Spacing.md),
                       GridItem(.flexible(), spacing: Tokens.Spacing.md)]
        return LazyVGrid(columns: columns, spacing: Tokens.Spacing.md) {
            SecondaryButton(title: "复制总结", symbol: "doc.on.doc") {}
            SecondaryButton(title: "导出 PDF", symbol: "arrow.down.doc") {}
            PrimaryButton(title: "分享", symbol: "square.and.arrow.up") {}
            GhostButton(title: "完成", symbol: "checkmark") {}
                .frame(maxWidth: .infinity, alignment: .center)
        }
        .padding(Tokens.Spacing.lg)
        .background(.regularMaterial)
    }
}

#Preview("ReviewMode") {
    ReviewModeView()
        .environment(AppState())
        .frame(width: 1200, height: 800)
        .background(Tokens.Color.nearBlack)
}
