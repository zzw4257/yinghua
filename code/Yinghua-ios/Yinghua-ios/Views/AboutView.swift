import SwiftUI

/// iOS 屏 5 · About
/// - iOS 简洁 about 页
/// - App icon + name + version
/// - 致谢
struct AboutView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: Tokens.Spacing.lg) {
                    appIconHeader
                        .padding(.top, Tokens.Spacing.xl)

                    VStack(spacing: Tokens.Spacing.xs) {
                        Text("映话")
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(Tokens.Color.warmWhite)
                        Text("Yìnghuà")
                            .font(.title3)
                            .foregroundStyle(Tokens.Color.tertiaryText)
                        Text("v0.1.0 (1)")
                            .font(.subheadline)
                            .foregroundStyle(Tokens.Color.tertiaryText)
                            .padding(.top, 2)
                    }

                    tagline

                    Divider()
                        .background(Tokens.Color.hairline)
                        .padding(.horizontal, Tokens.Spacing.xl)
                        .padding(.vertical, Tokens.Spacing.md)

                    acknowledgements
                        .padding(.horizontal, Tokens.Spacing.md)

                    Spacer(minLength: Tokens.Spacing.xl)
                }
                .padding(.bottom, Tokens.Spacing.xxl)
            }
            .background(Tokens.Color.nearBlack.ignoresSafeArea())
            .navigationTitle("About")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    // MARK: - 顶部 icon + name

    private var appIconHeader: some View {
        ZStack {
            RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge * 1.5, style: .continuous)
                .fill(Tokens.Color.graphite)
                .frame(width: 120, height: 120)
                .overlay(
                    RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge * 1.5, style: .continuous)
                        .stroke(Tokens.Color.hairline, lineWidth: 1)
                )
            Image(systemName: "waveform")
                .font(.system(size: 56, weight: .light))
                .foregroundStyle(Tokens.Color.primaryGradient)
        }
    }

    // MARK: - 一句话 tagline

    private var tagline: some View {
        Text("每一场对话，都被认真听见。")
            .font(.body)
            .foregroundStyle(Tokens.Color.secondaryText)
            .multilineTextAlignment(.center)
            .padding(.horizontal, Tokens.Spacing.xl)
    }

    // MARK: - 致谢

    private var acknowledgements: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
            Text("致谢")
                .font(.headline)
                .foregroundStyle(Tokens.Color.warmWhite)

            VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
                ackRow(title: "设计系统", value: "映话 D1 · 117 tokens")
                ackRow(title: "图标", value: "C24 iOS Icon Set")
                ackRow(title: "概念", value: "C34 iOS 5 屏概念图")
                ackRow(title: "macOS 端", value: "Yinghua for macOS 26+")
                ackRow(title: "隐私", value: "本机优先 · 无追踪")
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

            Text("© 2026 Yinghua Inc.")
                .font(.caption)
                .foregroundStyle(Tokens.Color.tertiaryText)
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.top, Tokens.Spacing.md)
        }
    }

    private func ackRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .font(.subheadline)
                .foregroundStyle(Tokens.Color.secondaryText)
            Spacer()
            Text(value)
                .font(.subheadline)
                .foregroundStyle(Tokens.Color.warmWhite)
        }
    }
}

#Preview {
    AboutView()
        .preferredColorScheme(.dark)
}
