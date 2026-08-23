import SwiftUI

/// Secondary 按钮：玻璃 + 1px 8% 白边（§4.1）
struct SecondaryButton: View {
    let title: String
    var symbol: String? = nil
    var height: CGFloat = 36
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            HStack(spacing: Tokens.Spacing.xs) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 13, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .foregroundStyle(Tokens.Color.warmWhite)
            .frame(maxWidth: .infinity, minHeight: height)
            .background(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous)
                    .stroke(Tokens.Color.hairline, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous))
        }
        .buttonStyle(.plain)
        .contentShape(RoundedRectangle(cornerRadius: Tokens.Radius.button, style: .continuous))
    }
}

#Preview {
    VStack(spacing: 12) {
        SecondaryButton(title: "复制总结", symbol: "doc.on.doc") {}
        SecondaryButton(title: "Export PDF", symbol: "arrow.down.doc") {}
        SecondaryButton(title: "Open") {}
    }
    .padding()
    .frame(width: 360)
    .background(Tokens.Color.nearBlack)
}
