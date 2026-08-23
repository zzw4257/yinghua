import SwiftUI

/// Primary 按钮：紫青渐变（§4.1）
struct PrimaryButton: View {
    let title: String
    var symbol: String? = nil
    var height: CGFloat = 44
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: Tokens.Spacing.xs) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 14, weight: .semibold))
                }
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity, minHeight: height)
            .background(Tokens.Color.primaryGradient)
            .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous))
            .shadow(color: Tokens.Color.purpleVivid.opacity(0.25), radius: 12, x: 0, y: 6)
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 16) {
        PrimaryButton(title: "开始录制", symbol: "record.circle") {}
        PrimaryButton(title: "Get started", symbol: "arrow.right", height: 36) {}
        PrimaryButton(title: "Share", symbol: "square.and.arrow.up") {}
    }
    .padding()
    .frame(width: 360)
    .background(Tokens.Color.nearBlack)
}
