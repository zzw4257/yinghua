import SwiftUI

/// iOS 屏 1 · Library
/// - NavigationStack（标题 "Library"）
/// - ScrollView + LazyVStack
/// - 顶部：大紫青渐变 button "Start Recording"（占宽 80%）
/// - 下方：library item card 列表
struct HomeView: View {
    @Environment(iOSAppState.self) private var appState

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: Tokens.Spacing.md) {
                    startRecordingButton
                        .padding(.top, Tokens.Spacing.sm)

                    Text("Recent")
                        .font(.headline)
                        .foregroundStyle(Tokens.Color.warmWhite)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.horizontal, Tokens.Spacing.md)
                        .padding(.top, Tokens.Spacing.xs)

                    ForEach(appState.library) { item in
                        LibraryItemCard(item: item)
                            .padding(.horizontal, Tokens.Spacing.md)
                    }
                }
                .padding(.bottom, Tokens.Spacing.xxl)
            }
            .background(Tokens.Color.nearBlack.ignoresSafeArea())
            .navigationTitle("Library")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - 渐变 Start Recording 按钮

    private var startRecordingButton: some View {
        Button {
            appState.selectedTab = .record
        } label: {
            HStack(spacing: Tokens.Spacing.sm) {
                Image(systemName: "record.circle.fill")
                    .font(.title2)
                Text("Start Recording")
                    .font(.headline)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 56)
            .background(
                RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous)
                    .fill(Tokens.Color.primaryGradient)
            )
            .shadow(color: Tokens.Color.purpleVivid.opacity(0.4), radius: 16, x: 0, y: 8)
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity)
        .padding(.horizontal, Tokens.Spacing.lg)
    }
}

// MARK: - Library Card

private struct LibraryItemCard: View {
    let item: LibraryItem

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(item.title)
                        .font(.headline)
                        .foregroundStyle(Tokens.Color.warmWhite)
                        .lineLimit(2)
                    Text(item.dateLabel)
                        .font(.caption)
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
                Spacer()
                Text(item.durationLabel)
                    .font(.caption.monospacedDigit())
                    .foregroundStyle(Tokens.Color.secondaryText)
                    .padding(.horizontal, Tokens.Spacing.xs)
                    .padding(.vertical, 4)
                    .background(
                        Capsule().fill(Tokens.Color.hairline)
                    )
            }

            HStack(spacing: -8) {
                ForEach(item.speakers.prefix(3)) { speaker in
                    SpeakerAvatar_iOS(speaker: speaker, size: 24)
                        .overlay(
                            Circle().stroke(Tokens.Color.nearBlack, lineWidth: 2)
                        )
                }
                if item.speakers.count > 3 {
                    Text("+\(item.speakers.count - 3)")
                        .font(.caption2.weight(.semibold))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                        .padding(.leading, Tokens.Spacing.xs)
                }
                Spacer()
            }

            if let firstKey = item.summary.keyMoments.first {
                Text(firstKey)
                    .font(.subheadline)
                    .foregroundStyle(Tokens.Color.secondaryText)
                    .lineLimit(2)
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
    }
}

#Preview {
    HomeView()
        .environment(iOSAppState())
        .preferredColorScheme(.dark)
}
