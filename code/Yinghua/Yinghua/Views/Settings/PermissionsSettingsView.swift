import SwiftUI
import AppKit

/// 权限 tab —— 4 个权限的状态 pill + 申请 / 跳系统设置按钮
///
/// 设计：
/// - 顶部 intro + "Refresh" 按钮（手动重查 + 显示 last checked）
/// - 每个权限独立 row：icon + 名称 + 详情 + 状态 pill + 申请/管理按钮
/// - 真实接 `PermissionService`（不缓存，每次 view 出现 / refresh 都重新查）
/// - 接受 `refreshTrigger`：切回 tab 时自动重查
struct PermissionsSettingsView: View {
    @Environment(AppState.self) private var state
    let refreshTrigger: Int

    @State private var isRefreshing: Bool = false
    @State private var lastCheckedAt: Date?

    var body: some View {
        @Bindable var state = state
        VStack(alignment: .leading, spacing: Tokens.Spacing.xl) {
            introCard
            refreshToolbar
            ForEach(PermissionKind.allCases) { kind in
                permissionRow(kind: kind)
            }
            bottomNote
        }
        .task(id: refreshTrigger) {
            await refreshAll()
        }
    }

    // MARK: - 操作

    private func refreshAll() async {
        isRefreshing = true
        await state.permissions.checkAll()
        lastCheckedAt = Date()
        isRefreshing = false
    }

    // MARK: - 子组件

    private var introCard: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.md) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Tokens.Color.tealVivid)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Tokens.Color.tealVivid.opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                Text("macOS 系统权限")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("映话是本地优先，所有权限都仅在 macOS 系统弹窗内授权，永不绕过。授权后你可以随时到 系统设置 → 隐私与安全性 撤销。")
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

    /// 顶部工具条：手动刷新 + last checked 时间
    private var refreshToolbar: some View {
        HStack(spacing: Tokens.Spacing.sm) {
            Button {
                Task { await refreshAll() }
            } label: {
                if isRefreshing {
                    HStack(spacing: 4) {
                        ProgressView()
                            .scaleEffect(0.6)
                            .frame(width: 10, height: 10)
                        Text("检查中…")
                    }
                } else {
                    Label("刷新状态", systemImage: "arrow.clockwise")
                }
            }
            .font(.system(size: 12, weight: .medium))
            .buttonStyle(.bordered)
            .disabled(isRefreshing)

            if let last = lastCheckedAt {
                Text("·")
                    .foregroundStyle(Tokens.Color.tertiaryText)
                Text("最后检查: \(last.formatted(.relative(presentation: .numeric)))")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }

            Spacer()

            Button {
                if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security") {
                    NSWorkspace.shared.open(url)
                }
            } label: {
                Label("打开 系统设置", systemImage: "arrow.up.right.square")
            }
            .font(.system(size: 12, weight: .medium))
            .buttonStyle(.bordered)
        }
    }

    private func permissionRow(kind: PermissionKind) -> some View {
        let stateValue = state.permissions.state(for: kind)
        return HStack(alignment: .center, spacing: Tokens.Spacing.md) {
            // 图标
            Image(systemName: kind.symbol)
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(stateValue == .granted ? Tokens.Color.successGreen : Tokens.Color.warmWhite)
                .frame(width: 32, height: 32)
                .background(
                    Circle().fill(
                        (stateValue == .granted ? Tokens.Color.successGreen : Tokens.Color.warmWhite).opacity(0.12)
                    )
                )

            // 文字
            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: 6) {
                    Text(kind.displayName)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(Tokens.Color.warmWhite)
                    if stateValue == .pending {
                        ProgressView()
                            .scaleEffect(0.55)
                            .frame(width: 10, height: 10)
                    }
                }
                Text(kind.detail)
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .fixedSize(horizontal: false, vertical: true)
            }

            Spacer()

            // 状态 pill
            statePill(state: stateValue)
                .frame(width: 84, alignment: .trailing)

            // 按钮
            permissionActionButton(kind: kind, state: stateValue)
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
    }

    private func statePill(state: PermissionState) -> some View {
        let (bg, fg) = state.pillColor
        return Text(state.displayText)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(Color(nsColor: fg))
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(Color(nsColor: bg), in: Capsule())
    }

    @ViewBuilder
    private func permissionActionButton(kind: PermissionKind, state stateValue: PermissionState) -> some View {
        let permissions = self.state.permissions
        switch kind {
        case .microphone:
            if stateValue == .granted {
                Button {
                    permissions.openSystemSettings(for: .microphone)
                } label: {
                    Label("管理", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            } else if stateValue == .pending {
                Button { } label: {
                    Text("等待…")
                }
                .buttonStyle(.bordered)
                .disabled(true)
            } else {
                Button {
                    Task { await permissions.requestMicrophone() }
                } label: {
                    Label("申请", systemImage: "mic.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(Tokens.Color.purpleVivid)
            }
        case .screenRecording:
            if stateValue == .granted {
                Button {
                    permissions.openSystemSettings(for: .screenRecording)
                } label: {
                    Label("管理", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            } else if stateValue == .pending {
                Button { } label: {
                    Text("等待…")
                }
                .buttonStyle(.bordered)
                .disabled(true)
            } else {
                Button {
                    permissions.requestScreenRecording()
                } label: {
                    Label("申请", systemImage: "rectangle.dashed.badge.record")
                }
                .buttonStyle(.borderedProminent)
                .tint(Tokens.Color.purpleVivid)
            }
        case .speechRecognition:
            if stateValue == .granted {
                Button {
                    permissions.openSystemSettings(for: .speechRecognition)
                } label: {
                    Label("管理", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            } else if stateValue == .pending {
                Button { } label: {
                    Text("等待…")
                }
                .buttonStyle(.bordered)
                .disabled(true)
            } else {
                Button {
                    Task { await permissions.requestSpeechRecognition() }
                } label: {
                    Label("申请", systemImage: "waveform.badge.plus")
                }
                .buttonStyle(.borderedProminent)
                .tint(Tokens.Color.purpleVivid)
            }
        case .notifications:
            if stateValue == .granted {
                Button {
                    permissions.openSystemSettings(for: .notifications)
                } label: {
                    Label("管理", systemImage: "gear")
                }
                .buttonStyle(.bordered)
            } else if stateValue == .denied {
                Button {
                    permissions.openSystemSettings(for: .notifications)
                } label: {
                    Label("打开", systemImage: "arrow.up.right.square")
                }
                .buttonStyle(.bordered)
            } else if stateValue == .pending {
                Button { } label: {
                    Text("等待…")
                }
                .buttonStyle(.bordered)
                .disabled(true)
            } else {
                Button {
                    Task { await permissions.requestNotifications() }
                } label: {
                    Label("启用", systemImage: "bell.badge")
                }
                .buttonStyle(.borderedProminent)
                .tint(Tokens.Color.purpleVivid)
            }
        }
    }

    private var bottomNote: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "info.circle")
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
            Text("屏幕录制授权后需要重新启动 app 才能完全生效（macOS 系统限制）。通知和语音识别授权是异步的，可能需要几秒钟。")
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
