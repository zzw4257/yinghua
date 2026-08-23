import SwiftUI

/// 主窗口外壳（用 NavigationSplitView 在 4 个主 surface 之间切换）
struct MainWindow: View {
    @Environment(AppState.self) private var state

    var body: some View {
        @Bindable var state = state

        ZStack {
            // 玻璃背景（§2.5）
            Rectangle()
                .fill(.regularMaterial)
                .ignoresSafeArea()

            // 极光渐变 wash（紫 → 青，~15% opacity）
            LinearGradient(
                colors: [
                    Tokens.Color.purpleDeep.opacity(0.18),
                    Tokens.Color.tealDeep.opacity(0.10),
                    .clear,
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            .blendMode(.plusLighter)

            NavigationSplitView(columnVisibility: .constant(.all)) {
                sidebar
            } detail: {
                detailContent
            }
            .navigationSplitViewStyle(.balanced)
        }
        .frame(minWidth: 1000, minHeight: 700)
    }

    // MARK: - 侧栏

    private var sidebar: some View {
        @Bindable var state = state
        return List(selection: Binding(
            get: { state.currentSurface },
            set: { newValue in
                if let v = newValue { state.switchSurface(v) }
            }
        )) {
            Section {
                ForEach([AppSurface.emptyState, .meetingInProgress, .transcriptFocus, .reviewMode]) { surface in
                    Label {
                        Text(surface.title)
                    } icon: {
                        Image(systemName: surface.symbol)
                    }
                    .tag(surface as AppSurface?)
                }
            } header: {
                HStack(spacing: 6) {
                    YinghuaMark(size: 18)
                    Text("映话")
                        .font(.system(size: 13, weight: .semibold))
                }
                .foregroundStyle(Tokens.Color.tertiaryText)
            }
        }
        .listStyle(.sidebar)
        .navigationSplitViewColumnWidth(min: 200, ideal: 220, max: 260)
    }

    // MARK: - 详情

    @ViewBuilder
    private var detailContent: some View {
        switch state.currentSurface {
        case .emptyState:
            EmptyStateView()
        case .meetingInProgress:
            MeetingInProgressView()
        case .transcriptFocus:
            TranscriptFocusView()
        case .reviewMode:
            ReviewModeView()
        case .onboarding:
            // onboarding 走独立 Window，不在主窗口出现
            EmptyStateView()
        }
    }
}

/// 极简 Y mark（与 C07 01 MINIMAL 对应，黑底白 Y）
struct YinghuaMark: View {
    var size: CGFloat = 24

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: size * 0.224, style: .continuous)
                .fill(Tokens.Color.nearBlack)
                .frame(width: size, height: size)
            Text("Y")
                .font(.system(size: size * 0.52, weight: .heavy, design: .rounded))
                .foregroundStyle(Tokens.Color.warmWhite)
        }
    }
}

#Preview("MainWindow") {
    MainWindow()
        .environment(AppState())
        .frame(width: 1200, height: 800)
}
