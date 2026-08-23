import SwiftUI

/// Speaker avatar：纯色圆 + 单字母（STYLE 1，§4.3）
struct SpeakerAvatar: View {
    let speaker: Speaker
    var size: CGFloat = 36

    var body: some View {
        ZStack {
            Circle()
                .fill(speaker.color.color)
            Text(String(speaker.name.prefix(1)))
                .font(.system(size: size * 0.45, weight: .semibold))
                .foregroundStyle(speaker.color.isBright ? Tokens.Color.graphite : Tokens.Color.warmWhite)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(speaker.name)"))
    }
}

#Preview {
    HStack(spacing: 16) {
        SpeakerAvatar(speaker: Speaker(id: "a", name: "面试官", color: .purple))
        SpeakerAvatar(speaker: Speaker(id: "b", name: "我",     color: .teal),   size: 28)
        SpeakerAvatar(speaker: Speaker(id: "c", name: "张三",   color: .pink),   size: 20)
        SpeakerAvatar(speaker: Speaker(id: "d", name: "李四",   color: .warmWhite), size: 20)
    }
    .padding()
    .background(Tokens.Color.nearBlack)
}
