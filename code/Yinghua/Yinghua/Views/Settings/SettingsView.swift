import SwiftUI

/// 设置窗口（独立 Window，5 个 tab：API keys / Integrations / Permissions / Diagnostics / About）
///
/// 设计：
/// - 顶部 brand header（mark + 标题 + API key 状态指示）
/// - 中间 segmented Picker 在多个 tab 间切换
/// - 主体 ScrollView 装具体内容
/// - 玻璃面 + 暖白文字，对齐 Tokens 设计 token
struct SettingsView: View {
    @Environment(AppState.self) private var state
    @State private var selectedTab: SettingsTab = .apiKeys
    /// 触发子视图 refresh：每次切 tab +1（用于 permissions 重查、API key 重读）
    @State private var refreshTrigger: Int = 0

    var body: some View {
        @Bindable var state = state
        VStack(spacing: 0) {
            header

            Divider().background(Tokens.Color.hairline)

            // tab 切换
            VStack(spacing: 0) {
                Picker("", selection: $selectedTab) {
                    ForEach(SettingsTab.allCases) { tab in
                        tabLabel(tab).tag(tab)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .padding(.horizontal, Tokens.Spacing.lg)
                .padding(.vertical, Tokens.Spacing.md)
                .onChange(of: selectedTab) { _, _ in
                    // 切 tab 时触发子视图重查（权限 / key 状态可能变化）
                    refreshTrigger += 1
                }

                Divider().background(Tokens.Color.hairline)

                ScrollView {
                    Group {
                        switch selectedTab {
                        case .apiKeys:
                            APIKeySettingsView(refreshTrigger: refreshTrigger)
                                .environment(state)
                        case .integrations:
                            IntegrationsSettingsView()
                                .environment(state)
                        case .permissions:
                            PermissionsSettingsView(refreshTrigger: refreshTrigger)
                                .environment(state)
                        case .diagnostics:
                            CrashReportingSettingsView()
                        case .about:
                            AboutView()
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .topLeading)
                    .padding(Tokens.Spacing.xl)
                }
            }
        }
        .frame(width: 700, height: 640)
        .background(Tokens.Color.nearBlack)
    }

    // MARK: - Header

    private var header: some View {
        HStack(spacing: Tokens.Spacing.md) {
            YinghuaMark(size: 32)
                .shadow(color: Tokens.Color.purpleVivid.opacity(0.20), radius: 8, x: 0, y: 2)

            VStack(alignment: .leading, spacing: 2) {
                Text("映话 · 设置")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("本地优先 · BYOK · 隐私")
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }

            Spacer()

            // 右上角：API key 状态紧凑指示（不是营销 chip）
            keyStatusIndicator
        }
        .padding(.horizontal, Tokens.Spacing.lg)
        .padding(.vertical, Tokens.Spacing.md)
        .background(.regularMaterial)
    }

    /// Header 右侧的 key 配置状态指示
    /// - 全部未配置：灰色 dot + "无 API key"
    /// - 至少 1 个：紫色 dot + "N provider 已配置"
    @ViewBuilder
    private var keyStatusIndicator: some View {
        let configured = APIProvider.allCases.filter { KeychainService.hasKey(for: $0) }
        HStack(spacing: 6) {
            Circle()
                .fill(configured.isEmpty
                      ? Tokens.Color.tertiaryText
                      : Tokens.Color.purpleVivid)
                .frame(width: 7, height: 7)
            Text(configured.isEmpty
                 ? "无 API key"
                 : "\(configured.count) provider 已配置")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(Tokens.Color.tertiaryText)
        }
    }

    // MARK: - Tab 标签（带 dot 提示当前 tab 的状态）

    @ViewBuilder
    private func tabLabel(_ tab: SettingsTab) -> some View {
        HStack(spacing: 6) {
            Image(systemName: tab.symbol)
                .font(.system(size: 11, weight: .medium))
            Text(tab.title)
        }
    }
}

enum SettingsTab: String, CaseIterable, Identifiable, Hashable {
    case apiKeys
    case integrations
    case permissions
    case diagnostics
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .apiKeys:      return "API 密钥"
        case .integrations: return "集成"
        case .permissions:  return "权限"
        case .diagnostics:  return "诊断"
        case .about:        return "关于"
        }
    }

    var symbol: String {
        switch self {
        case .apiKeys:      return "key.fill"
        case .integrations: return "antenna.radiowaves.left.and.right"
        case .permissions:  return "lock.shield.fill"
        case .diagnostics:  return "stethoscope"
        case .about:        return "info.circle.fill"
        }
    }
}

#Preview("Settings") {
    SettingsView()
        .environment(AppState())
        .frame(width: 700, height: 640)
}
