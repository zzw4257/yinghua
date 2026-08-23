import SwiftUI

/// 设置 → Diagnostics tab：crash reporting opt-in 开关 + 隐私说明。
///
/// 与现有 PermissionsSettingsView / APIKeySettingsView 风格保持一致：
/// 用 VStack + custom cards（不强行套 macOS Form / .grouped，避免与全局 dark theme 冲突）。
struct CrashReportingSettingsView: View {
    @ObservedObject private var reporter = CrashReporter.shared

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.xl) {
            introCard
            optInCard
            privacyCard
            dataCard
        }
    }

    // MARK: - 子组件

    private var introCard: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.md) {
            Image(systemName: "stethoscope")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Tokens.Color.tealVivid)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Tokens.Color.tealVivid.opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                Text("诊断与崩溃上报")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("映话默认**不**向任何服务器发送任何数据。下面这个开关默认是关的，**只有你主动打开后**，崩溃信息才会被匿名上传。")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private var optInCard: some View {
        HStack(alignment: .center, spacing: Tokens.Spacing.md) {
            Image(systemName: reporter.isOptIn ? "checkmark.shield.fill" : "shield.slash.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(reporter.isOptIn ? Tokens.Color.successGreen : Tokens.Color.tertiaryText)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(
                        (reporter.isOptIn ? Tokens.Color.successGreen : Tokens.Color.tertiaryText).opacity(0.12)
                    )
                )

            VStack(alignment: .leading, spacing: 2) {
                Text("向映话发送崩溃报告")
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(reporter.isOptIn
                     ? "已开启。下次启动时会尝试上传本地的待发崩溃记录。"
                     : "默认关闭。崩溃信息只保存在你本地的 Mac 上，不会上传。")
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }

            Spacer()

            Toggle("", isOn: $reporter.isOptIn)
                .labelsHidden()
                .toggleStyle(.switch)
                .tint(Tokens.Color.tealVivid)
                .frame(width: 80, alignment: .trailing)
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private var privacyCard: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            Text("隐私承诺")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)

            VStack(alignment: .leading, spacing: 6) {
                privacyRow(icon: "lock.shield.fill", text: "不发送任何个人身份信息（用户名、邮箱、文件路径）")
                privacyRow(icon: "lock.shield.fill", text: "不发送转录文本、录音字节、API key")
                privacyRow(icon: "lock.shield.fill", text: "report 只含 crash 类型、stack trace、app 版本、macOS 版本、设备型号、本次 session 的随机 UUID")
                privacyRow(icon: "lock.shield.fill", text: "随时可以关闭；关闭后已保存的本地待发记录会被清空")
            }
        }
        .padding(Tokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func privacyRow(icon: String, text: String) -> some View {
        HStack(alignment: .firstTextBaseline, spacing: Tokens.Spacing.sm) {
            Image(systemName: icon)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Tokens.Color.successGreen)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 12))
                .foregroundStyle(Tokens.Color.warmWhite.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var dataCard: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            Text("发送内容（crash report 字段）")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)

            VStack(spacing: 0) {
                fieldRow("type", "uncaught_exception | signal | non_fatal")
                Divider().background(Tokens.Color.hairline)
                fieldRow("message", "exception reason / signal name / error description")
                Divider().background(Tokens.Color.hairline)
                fieldRow("stackTrace", "call stack symbols (Swift 符号化后)")
                Divider().background(Tokens.Color.hairline)
                fieldRow("context", "业务 tag，如 function=generateSummary")
                Divider().background(Tokens.Color.hairline)
                fieldRow("appVersion / osVersion / deviceModel", "用于按版本和机型聚合问题")
                Divider().background(Tokens.Color.hairline)
                fieldRow("sessionId", "本次启动的随机 UUID（用于去重）")
            }
            .background(Color.black.opacity(0.2), in: RoundedRectangle(cornerRadius: 6, style: .continuous))
        }
        .padding(Tokens.Spacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func fieldRow(_ key: String, _ value: String) -> some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.sm) {
            Text(key)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundStyle(Tokens.Color.purpleVivid)
                .frame(width: 180, alignment: .leading)
            Text(value)
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Tokens.Color.tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
            Spacer()
        }
        .padding(.horizontal, Tokens.Spacing.md)
        .padding(.vertical, 8)
    }
}

#Preview("Diagnostics") {
    CrashReportingSettingsView()
        .frame(width: 640, height: 700)
        .background(Tokens.Color.nearBlack)
}
