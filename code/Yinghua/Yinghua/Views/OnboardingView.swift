import SwiftUI

/// C06/05 onboarding
/// - 极简居中：品牌 mark + 副标题 + 3 bullet + 单一 CTA + 3-dot progress
struct OnboardingView: View {
    @Environment(AppState.self) private var state

    @State private var step: Int = 0

    var body: some View {
        ZStack {
            // 玻璃 + 极光 wash
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()
            LinearGradient(
                colors: [
                    Tokens.Color.purpleDeep.opacity(0.20),
                    Tokens.Color.tealDeep.opacity(0.10),
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .blendMode(.plusLighter)

            VStack(spacing: Tokens.Spacing.xl) {
                Spacer()

                // 品牌 mark（黑底白 Y，§3.1 01 MINIMAL）
                YinghuaMark(size: 96)
                    .shadow(color: Tokens.Color.purpleVivid.opacity(0.30), radius: 24, x: 0, y: 12)

                // 标题
                VStack(spacing: 8) {
                    Text("映话")
                        .font(.system(size: 28, weight: .semibold))
                        .foregroundStyle(Tokens.Color.warmWhite)
                    Text("macOS 上的本地优先会议助手")
                        .font(.system(size: 14))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }

                // 3 个 bullet
                VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
                    bullet(icon: "mic.fill",
                            title: "系统级录音 + 麦克风",
                            subtitle: "全程本地，不上传")
                    bullet(icon: "text.alignleft",
                            title: "实时转录，自动分说话人",
                            subtitle: "延迟 < 800ms")
                    bullet(icon: "sparkles",
                            title: "AI 总结、决定、待办",
                            subtitle: "BYOK · Keychain 安全保存")
                }
                .padding(.horizontal, Tokens.Spacing.xxl)

                Spacer()

                // CTA
                PrimaryButton(title: "开始使用", symbol: "arrow.right", height: 48) {
                    state.switchSurface(.emptyState)
                }
                .frame(maxWidth: 320)

                // 3-dot progress
                HStack(spacing: 8) {
                    ForEach(0..<3, id: \.self) { i in
                        Circle()
                            .fill(i == step ? Tokens.Color.purpleVivid : Tokens.Color.warmWhite.opacity(0.2))
                            .frame(width: 6, height: 6)
                    }
                }
                .padding(.bottom, Tokens.Spacing.lg)

                GhostButton(title: "已有账号", symbol: nil) {}
                    .padding(.bottom, Tokens.Spacing.xl)
            }
        }
    }

    private func bullet(icon: String, title: String, subtitle: String) -> some View {
        HStack(alignment: .center, spacing: Tokens.Spacing.md) {
            Image(systemName: icon)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(Tokens.Color.purpleVivid)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(Tokens.Color.purpleVivid.opacity(0.10))
                )
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            Spacer()
        }
    }
}

#Preview("Onboarding") {
    OnboardingView()
        .environment(AppState())
        .frame(width: 500, height: 720)
        .background(Tokens.Color.nearBlack)
}
