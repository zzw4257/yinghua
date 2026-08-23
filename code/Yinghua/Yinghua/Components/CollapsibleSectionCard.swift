import SwiftUI

/// Collapsible section card（§4.6）
/// 自绘而非 DisclosureGroup：精确控制折叠 / 展开动效、bullet 颜色循环
struct CollapsibleSectionCard<Content: View>: View {
    let icon: String
    let title: String
    let count: Int?
    @ViewBuilder let content: () -> Content

    @State private var isExpanded: Bool = true

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            Button {
                withAnimation(.spring(response: 0.22, dampingFraction: 0.86)) {
                    isExpanded.toggle()
                }
            } label: {
                HStack(spacing: Tokens.Spacing.sm) {
                    Image(systemName: icon)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(Tokens.Color.purpleVivid)
                        .frame(width: 16)
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(Tokens.Color.warmWhite)
                    if let count {
                        Text("\(count) 项")
                            .font(.system(size: 11, weight: .medium))
                            .foregroundStyle(Tokens.Color.tertiaryText)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(
                                Capsule().fill(Tokens.Color.warmWhite.opacity(0.08))
                            )
                    }
                    Spacer()
                    Image(systemName: "chevron.right")
                        .font(.system(size: 11, weight: .semibold))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                        .rotationEffect(.degrees(isExpanded ? 90 : 0))
                }
                .padding(.horizontal, Tokens.Spacing.md)
                .padding(.vertical, Tokens.Spacing.sm)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            // Content
            if isExpanded {
                VStack(alignment: .leading, spacing: Tokens.Spacing.xs) {
                    content()
                }
                .padding(.horizontal, Tokens.Spacing.md)
                .padding(.bottom, Tokens.Spacing.md)
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(.regularMaterial)
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
    }
}

/// Collapsible section 里的 bullet 项（紫 / 青 / 粉 循环）
struct BulletItem: View {
    let text: String
    var index: Int = 0

    private var dotColor: Color {
        let palette: [Color] = [Tokens.Color.purpleVivid, Tokens.Color.tealVivid, Tokens.Color.pink]
        return palette[index % palette.count]
    }

    var body: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.sm) {
            Circle()
                .fill(dotColor)
                .frame(width: 4, height: 4)
                .padding(.top, 8)
            Text(text)
                .font(.system(size: 13))
                .foregroundStyle(Tokens.Color.warmWhite.opacity(0.9))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    VStack(spacing: 12) {
        CollapsibleSectionCard(icon: "sparkles", title: "关键瞬间", count: 3) {
            BulletItem(text: "候选人在系统设计题中提出用 LRU 缓存 + 写穿策略。", index: 0)
            BulletItem(text: "12 分钟内完成 medium 难度编码。", index: 1)
            BulletItem(text: "反向给面试官讲了一题。", index: 2)
        }
        CollapsibleSectionCard(icon: "checkmark.circle", title: "达成的决定", count: 1) {
            BulletItem(text: "通过技术一面，进入二面。", index: 0)
        }
    }
    .padding()
    .background(Tokens.Color.nearBlack)
}
