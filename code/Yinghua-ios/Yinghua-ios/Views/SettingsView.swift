import SwiftUI

/// iOS 屏 4 · Settings
/// - iOS Form 风格
/// - Sections：API Provider / API Key / Permissions / About
/// - 用 NavigationLink 跳详情
struct SettingsView: View {
    @State private var selectedProvider: APIProvider = .anthropic
    @State private var apiKey: String = ""
    @State private var notificationsEnabled: Bool = true
    @State private var autoTranscribe: Bool = true

    var body: some View {
        NavigationStack {
            Form {
                Section {
                    Picker("Provider", selection: $selectedProvider) {
                        ForEach(APIProvider.allCases) { provider in
                            Text(provider.displayName).tag(provider)
                        }
                    }
                    NavigationLink {
                        APIKeyEditor(apiKey: $apiKey, provider: selectedProvider)
                    } label: {
                        HStack {
                            Text("API Key")
                            Spacer()
                            Text(apiKey.isEmpty ? "未设置" : "•••• \(apiKey.suffix(4))")
                                .foregroundStyle(Tokens.Color.tertiaryText)
                        }
                    }
                } header: {
                    Text("AI 总结")
                } footer: {
                    Text("映话使用所选 provider 生成 AI 总结。API key 仅保存在本机 Keychain。")
                }

                Section("Permissions") {
                    permissionRow(
                        icon: "mic.fill",
                        title: "Microphone",
                        subtitle: "Required for recording"
                    )
                    permissionRow(
                        icon: "waveform",
                        title: "Speech Recognition",
                        subtitle: "On-device transcription"
                    )
                    permissionRow(
                        icon: "bell.fill",
                        title: "Notifications",
                        subtitle: "Recording summary ready"
                    )
                    Toggle("Enable Notifications", isOn: $notificationsEnabled)
                    Toggle("Auto-Transcribe", isOn: $autoTranscribe)
                }

                Section("Recording") {
                    Picker("Quality", selection: .constant("High")) {
                        Text("Low").tag("Low")
                        Text("Medium").tag("Medium")
                        Text("High").tag("High")
                    }
                    NavigationLink {
                        Text("Language preferences")
                            .navigationTitle("Languages")
                            .toolbarColorScheme(.dark, for: .navigationBar)
                    } label: {
                        HStack {
                            Text("Languages")
                            Spacer()
                            Text("English, 中文")
                                .foregroundStyle(Tokens.Color.tertiaryText)
                        }
                    }
                }

                Section("About") {
                    NavigationLink {
                        AboutView()
                    } label: {
                        HStack {
                            Image(systemName: "info.circle")
                            Text("About Yinghua")
                        }
                    }
                    HStack {
                        Text("Version")
                        Spacer()
                        Text("0.1.0 (1)")
                            .foregroundStyle(Tokens.Color.tertiaryText)
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Tokens.Color.nearBlack)
            .navigationTitle("Settings")
            .toolbarColorScheme(.dark, for: .navigationBar)
        }
    }

    private func permissionRow(icon: String, title: String, subtitle: String) -> some View {
        HStack(spacing: Tokens.Spacing.sm) {
            Image(systemName: icon)
                .frame(width: 24)
                .foregroundStyle(Tokens.Color.purpleVivid)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.body)
                Text(subtitle)
                    .font(.caption)
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            Spacer()
            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Tokens.Color.successGreen)
        }
    }
}

/// API Provider（与 macOS 端 APIProvider 对齐）
enum APIProvider: String, CaseIterable, Identifiable, Codable {
    case anthropic
    case openai
    case google
    case custom

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .anthropic: return "Anthropic"
        case .openai:    return "OpenAI"
        case .google:    return "Google"
        case .custom:    return "Custom"
        }
    }
}

/// API Key 编辑器（占位）
private struct APIKeyEditor: View {
    @Binding var apiKey: String
    let provider: APIProvider

    var body: some View {
        Form {
            Section {
                SecureField("API Key", text: $apiKey)
                    .textContentType(.password)
                    .autocapitalization(.none)
            } header: {
                Text("\(provider.displayName) API Key")
            } footer: {
                Text("此 key 仅保存在本机 iOS Keychain。v0.1 演示用，未实际启用。")
            }
        }
        .scrollContentBackground(.hidden)
        .background(Tokens.Color.nearBlack)
        .navigationTitle("API Key")
        .toolbarColorScheme(.dark, for: .navigationBar)
    }
}

#Preview {
    SettingsView()
        .preferredColorScheme(.dark)
}
