import SwiftUI

/// iOS 屏 3 · Summary detail
/// - NavigationStack（标题 "AI Summary"）
/// - 文件元信息卡片
/// - 4 折叠 section（默认展开）
/// - 底部 3 按钮
struct SummaryView: View {
    @Environment(iOSAppState.self) private var appState
    @State private var sampleItem: LibraryItem? = nil

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Tokens.Spacing.md) {
                    metaCard
                        .padding(.horizontal, Tokens.Spacing.md)
                        .padding(.top, Tokens.Spacing.sm)

                    summarySection(
                        title: "Key Moments",
                        systemImage: "sparkles",
                        items: appState.summary.keyMoments
                    )
                    summarySection(
                        title: "Decisions",
                        systemImage: "checkmark.seal.fill",
                        items: appState.summary.decisions
                    )
                    summarySection(
                        title: "Action Items",
                        systemImage: "list.bullet.rectangle.fill",
                        items: appState.summary.actionItems
                    )
                    summarySection(
                        title: "Open Questions",
                        systemImage: "questionmark.circle.fill",
                        items: appState.summary.openQuestions
                    )

                    actionButtons
                        .padding(.horizontal, Tokens.Spacing.md)
                        .padding(.top, Tokens.Spacing.sm)
                }
                .padding(.bottom, Tokens.Spacing.xxxl)
            }
            .background(Tokens.Color.nearBlack.ignoresSafeArea())
            .navigationTitle("AI Summary")
            .navigationBarTitleDisplayMode(.large)
            .toolbarColorScheme(.dark, for: .navigationBar)
            .onAppear {
                sampleItem = appState.library.first
            }
        }
    }

    // MARK: - 元信息卡片

    private var metaCard: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            Text(sampleItem?.title ?? "Meeting")
                .font(.title3.weight(.semibold))
                .foregroundStyle(Tokens.Color.warmWhite)

            HStack(spacing: Tokens.Spacing.lg) {
                if let item = sampleItem {
                    metaItem(label: "Duration", value: item.durationLabel)
                    metaItem(label: "Date", value: item.dateLabel)
                }
            }

            HStack(spacing: -6) {
                ForEach(sampleItem?.speakers.prefix(4) ?? []) { speaker in
                    SpeakerAvatar_iOS(speaker: speaker, size: 20)
                        .overlay(
                            Circle().stroke(Tokens.Color.graphite, lineWidth: 1.5)
                        )
                }
            }
            .padding(.top, 4)
        }
        .padding(Tokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .fill(Tokens.Color.graphite)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func metaItem(label: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(label)
                .font(.caption)
                .foregroundStyle(Tokens.Color.tertiaryText)
            Text(value)
                .font(.subheadline.weight(.medium))
                .foregroundStyle(Tokens.Color.warmWhite)
        }
    }

    // MARK: - 折叠 section

    private func summarySection(title: String, systemImage: String, items: [String]) -> some View {
        DisclosureGroup {
            VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
                ForEach(Array(items.enumerated()), id: \.offset) { _, text in
                    HStack(alignment: .top, spacing: Tokens.Spacing.xs) {
                        Image(systemName: "circle.fill")
                            .font(.system(size: 4))
                            .foregroundStyle(Tokens.Color.purpleVivid)
                            .padding(.top, 8)
                        Text(text)
                            .font(.body)
                            .foregroundStyle(Tokens.Color.secondaryText)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
                if items.isEmpty {
                    Text("无内容")
                        .font(.body)
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
            }
            .padding(.top, Tokens.Spacing.xs)
        } label: {
            HStack(spacing: Tokens.Spacing.xs) {
                Image(systemName: systemImage)
                    .foregroundStyle(Tokens.Color.purpleVivid)
                Text(title)
                    .font(.headline)
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
        }
        .padding(Tokens.Spacing.md)
        .background(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .fill(Tokens.Color.graphite)
        )
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
        .padding(.horizontal, Tokens.Spacing.md)
    }

    // MARK: - 底部 3 按钮

    private var actionButtons: some View {
        HStack(spacing: Tokens.Spacing.sm) {
            actionButton(systemName: "doc.on.doc", title: "Copy", action: {})
            actionButton(systemName: "square.and.arrow.up", title: "Share", action: {})
            actionButton(systemName: "trash", title: "Delete", tint: Tokens.Color.recRed, action: {})
        }
    }

    private func actionButton(systemName: String, title: String, tint: Color = Tokens.Color.warmWhite, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: systemName)
                    .font(.title3)
                Text(title)
                    .font(.caption.weight(.medium))
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
}

#Preview {
    SummaryView()
        .environment(iOSAppState())
        .preferredColorScheme(.dark)
}
