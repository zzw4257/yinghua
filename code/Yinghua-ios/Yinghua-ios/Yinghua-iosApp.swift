import SwiftUI

@main
struct Yinghua_iosApp: App {
    @State private var appState = iOSAppState()

    var body: some Scene {
        WindowGroup {
            RootView()
                .environment(appState)
                .preferredColorScheme(.dark)
                .tint(Tokens.Color.purpleMid)
        }
    }
}

/// iOS 4-tab 根容器
struct RootView: View {
    @Environment(iOSAppState.self) private var appState

    var body: some View {
        TabView(selection: Bindable(appState).selectedTab) {
            HomeView()
                .tabItem {
                    Label(AppTab.library.title, systemImage: AppTab.library.systemImage)
                }
                .tag(AppTab.library)

            RecordingView()
                .tabItem {
                    Label(AppTab.record.title, systemImage: AppTab.record.systemImage)
                }
                .tag(AppTab.record)

            SettingsView()
                .tabItem {
                    Label(AppTab.settings.title, systemImage: AppTab.settings.systemImage)
                }
                .tag(AppTab.settings)

            AboutView()
                .tabItem {
                    Label(AppTab.about.title, systemImage: AppTab.about.systemImage)
                }
                .tag(AppTab.about)
        }
    }
}
