import SwiftUI
import AppKit

/// About tab —— 版本 / 数据目录 / 致谢 / 外部链接
///
/// - 顶部：真实 AppIcon（NSImage 优先 + 自绘 YinghuaMark 兜底）
/// - 中部：版本 / 构建号 / 平台 / 存储路径 + "在 Finder 中显示"
/// - 致谢：Apple / Anthropic / OpenAI / 产品作者
/// - 链接：项目主页 / GitHub / 支持
struct AboutView: View {
    // Bundle 元数据（懒读取一次）
    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "0.1.0"
    }
    private var buildNumber: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "1"
    }
    private var bundleId: String {
        Bundle.main.bundleIdentifier ?? "app.yinghua.Yinghua"
    }
    private var dataDirectory: URL {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first
            ?? URL(fileURLWithPath: NSHomeDirectory())
        return base.appendingPathComponent("Yinghua", isDirectory: true)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.xl) {
            brandSection
            detailSection
            creditsSection
            linksSection
            copyrightLine
        }
    }

    // MARK: - 子组件

    private var brandSection: some View {
        HStack(spacing: Tokens.Spacing.lg) {
            // 真实 AppIcon（AppIcon 缺失时用 YinghuaMark 兜底）
            Group {
                if let appIcon = NSImage(named: "AppIcon"),
                   appIcon.size.width > 0 {
                    Image(nsImage: appIcon)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                } else {
                    YinghuaMark(size: 72)
                }
            }
            .frame(width: 72, height: 72)
            .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            .shadow(color: Tokens.Color.purpleVivid.opacity(0.30), radius: 20, x: 0, y: 10)

            VStack(alignment: .leading, spacing: 6) {
                Text("映话")
                    .font(.system(size: 28, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("Yìnghuà")
                    .font(.system(size: 14, weight: .medium, design: .monospaced))
                    .foregroundStyle(Tokens.Color.purpleVivid)
                Text("macOS 上的本地优先会议助手")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            Spacer()
        }
        .padding(Tokens.Spacing.lg)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private var detailSection: some View {
        VStack(alignment: .leading, spacing: 0) {
            detailRow(label: "版本", value: "\(appVersion) (\(buildNumber))")
            Divider().background(Tokens.Color.hairline)
            detailRow(label: "Bundle", value: bundleId, monospaced: true)
            Divider().background(Tokens.Color.hairline)
            detailRow(label: "平台", value: "macOS 26+ · Apple Silicon")
            Divider().background(Tokens.Color.hairline)
            detailRow(label: "语言", value: "Swift 6.0 · SwiftUI · AppKit")
            Divider().background(Tokens.Color.hairline)
            HStack {
                Text("数据存储")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 80, alignment: .leading)
                Text(dataDirectory.path)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite)
                    .lineLimit(1)
                    .truncationMode(.middle)
                Spacer()
                Button {
                    revealInFinder(dataDirectory)
                } label: {
                    Label("在 Finder 中显示", systemImage: "folder")
                        .font(.system(size: 11, weight: .medium))
                }
                .buttonStyle(.bordered)
            }
            .padding(.horizontal, Tokens.Spacing.md)
            .padding(.vertical, 10)
        }
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func detailRow(label: String, value: String, monospaced: Bool = false) -> some View {
        HStack {
            Text(label)
                .font(.system(size: 12, weight: .medium))
                .foregroundStyle(Tokens.Color.tertiaryText)
                .frame(width: 80, alignment: .leading)
            Group {
                if monospaced {
                    Text(value)
                        .font(.system(size: 12, design: .monospaced))
                } else {
                    Text(value)
                        .font(.system(size: 12, weight: .medium, design: .monospaced))
                }
            }
            .foregroundStyle(Tokens.Color.warmWhite)
            Spacer()
        }
        .padding(.horizontal, Tokens.Spacing.md)
        .padding(.vertical, 10)
    }

    private var creditsSection: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.sm) {
            Text("致谢")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)

            VStack(alignment: .leading, spacing: 6) {
                creditRow(name: "Apple", note: "AVFoundation · ScreenCaptureKit · Speech · SwiftUI")
                creditRow(name: "Anthropic", note: "Claude Messages API")
                creditRow(name: "OpenAI", note: "Chat Completions API")
                creditRow(name: "周子为 (Ziwei Zhou)", note: "产品设计 · 编码")
            }
            .font(.system(size: 12))
            .foregroundStyle(Tokens.Color.warmWhite.opacity(0.85))
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func creditRow(name: String, note: String) -> some View {
        HStack(alignment: .firstTextBaseline) {
            Text(name)
                .font(.system(size: 12, weight: .semibold))
                .frame(width: 160, alignment: .leading)
            Text(note)
                .font(.system(size: 12))
                .foregroundStyle(Tokens.Color.tertiaryText)
        }
    }

    private var linksSection: some View {
        HStack(spacing: Tokens.Spacing.md) {
            Spacer()
            linkButton(title: "yinghua.zzw4257.cn", url: "https://yinghua.zzw4257.cn")
            Text("·").foregroundStyle(Tokens.Color.tertiaryText)
            linkButton(title: "GitHub", url: "https://github.com/yinghua-inc")
            Text("·").foregroundStyle(Tokens.Color.tertiaryText)
            linkButton(title: "支持", url: "https://yinghua.zzw4257.cn/support")
            Spacer()
        }
        .font(.system(size: 12))
    }

    private func linkButton(title: String, url: String) -> some View {
        Button {
            if let u = URL(string: url) { NSWorkspace.shared.open(u) }
        } label: {
            Text(title)
                .font(.system(size: 12))
                .foregroundStyle(Tokens.Color.purpleVivid)
                .underline()
        }
        .buttonStyle(.plain)
    }

    private var copyrightLine: some View {
        Text("© 2026 Yinghua Inc. · 本地优先 · BYOK")
            .font(.system(size: 10, design: .monospaced))
            .foregroundStyle(Tokens.Color.tertiaryText)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, Tokens.Spacing.xs)
    }

    // MARK: - 工具

    private func revealInFinder(_ url: URL) {
        // 目录不存在时创建（首次启动可能还没建过）
        try? FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
        NSWorkspace.shared.activateFileViewerSelecting([url])
    }
}
