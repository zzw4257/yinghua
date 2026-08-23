import SwiftUI

/// Ghost 按钮：透明 + hover 下划线（§4.1）
struct GhostButton: View {
    let title: String
    var symbol: String? = nil
    var action: () -> Void = {}

    @State private var isHovering = false

    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                if let symbol {
                    Image(systemName: symbol)
                        .font(.system(size: 12, weight: .medium))
                }
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .underline(isHovering)
            }
            .foregroundStyle(isHovering ? Tokens.Color.warmWhite : Tokens.Color.tertiaryText)
            .frame(minHeight: 24)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .onHover { isHovering = $0 }
        .animation(.easeOut(duration: 0.12), value: isHovering)
    }
}

#Preview {
    HStack {
        GhostButton(title: "完成", symbol: "checkmark") {}
        GhostButton(title: "Cancel") {}
        GhostButton(title: "Regenerate", symbol: "arrow.clockwise") {}
    }
    .padding()
    .background(Tokens.Color.nearBlack)
}
