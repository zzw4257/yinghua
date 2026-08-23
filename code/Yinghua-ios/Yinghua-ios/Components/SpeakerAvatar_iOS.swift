import SwiftUI

/// iOS 风格 speaker avatar：纯色圆 + 单字母（与 macOS SpeakerAvatar 一致，命名加 _iOS 后缀避免 iOS / macOS 跨 target 混淆）
struct SpeakerAvatar_iOS: View {
    let speaker: Speaker
    var size: CGFloat = 40

    var body: some View {
        ZStack {
            Circle()
                .fill(speaker.color.color)
            Text(String(speaker.name.prefix(1)))
                .font(.system(size: size * 0.45, weight: .semibold, design: .rounded))
                .foregroundStyle(speaker.color.isBright ? Tokens.Color.graphite : Tokens.Color.warmWhite)
        }
        .frame(width: size, height: size)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(Text("\(speaker.name)"))
    }
}

#Preview {
    HStack(spacing: 16) {
        SpeakerAvatar_iOS(speaker: Speaker(id: "a", name: "面试官", color: .purple))
        SpeakerAvatar_iOS(speaker: Speaker(id: "b", name: "我",     color: .teal),   size: 32)
        SpeakerAvatar_iOS(speaker: Speaker(id: "c", name: "张三",   color: .pink),   size: 24)
        SpeakerAvatar_iOS(speaker: Speaker(id: "d", name: "李四",   color: .warmWhite), size: 20)
    }
    .padding()
    .background(Tokens.Color.nearBlack)
}
