import SwiftUI
import AppKit

/// API 密钥设置 tab
///
/// - 3 个 provider（openai / anthropic / custom）的 key 输入 + 状态 + 测试连接 + 删除
/// - 真实接 KeychainService（不写文件 / 不上传）
/// - 测试连接真实发请求到 provider endpoint（带耗时统计）
/// - 顶部有一个 "全部 provider 配置状态" 摘要条
/// - 接受 `refreshTrigger` 用于切回 tab 时重读 keychain（防止外部变更后 UI 滞后）
struct APIKeySettingsView: View {
    @Environment(AppState.self) private var state

    /// tab 切换 / 父级触发
    let refreshTrigger: Int

    @State private var draftKeys: [APIProvider: String] = [:]
    @State private var draftEndpoints: [APIProvider: String] = [:]
    @State private var draftModels: [APIProvider: String] = [:]
    @State private var revealed: Set<APIProvider> = []
    @State private var testResults: [APIProvider: TestResult] = [:]
    @State private var saveFlash: [APIProvider: Date] = [:]  // 保存成功 → 短暂高亮用

    var body: some View {
        @Bindable var state = state

        VStack(alignment: .leading, spacing: Tokens.Spacing.xl) {
            introCard
            providerStatusSummary
            ForEach(APIProvider.allCases) { provider in
                providerCard(provider: provider)
            }
            privacyNote
        }
        .task(id: refreshTrigger) {
            // 每次 refreshTrigger 变化时重新从 keychain 加载
            reloadAll()
        }
    }

    // MARK: - 数据加载

    private func reloadAll() {
        for provider in APIProvider.allCases {
            draftKeys[provider] = KeychainService.loadAPIKey(for: provider) ?? ""
            draftEndpoints[provider] = (KeychainService.loadEndpoint(for: provider) ?? provider.defaultEndpoint)?.absoluteString ?? ""
            draftModels[provider] = (KeychainService.loadModel(for: provider) ?? provider.defaultModel)
        }
    }

    // MARK: - 子组件

    private var introCard: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.md) {
            Image(systemName: "key.fill")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Tokens.Color.purpleVivid)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Tokens.Color.purpleVivid.opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                Text("BYOK · 自备密钥")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("你的 API key 只存于本机 macOS Keychain，不会上传到任何服务器。AI 总结只在 Review Mode 主动触发时才发起请求。")
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

    /// 顶部摘要：3 个 provider 各自的配置状态（一行紧凑 chip）
    private var providerStatusSummary: some View {
        HStack(spacing: Tokens.Spacing.sm) {
            ForEach(APIProvider.allCases) { provider in
                let hasKey = (draftKeys[provider]?.isEmpty == false)
                HStack(spacing: 6) {
                    Circle()
                        .fill(hasKey ? Tokens.Color.successGreen : Tokens.Color.tertiaryText)
                        .frame(width: 6, height: 6)
                    Text(provider.displayName)
                        .font(.system(size: 11, weight: .medium))
                        .foregroundStyle(hasKey ? Tokens.Color.warmWhite : Tokens.Color.tertiaryText)
                    if hasKey {
                        Image(systemName: "checkmark")
                            .font(.system(size: 9, weight: .bold))
                            .foregroundStyle(Tokens.Color.successGreen)
                    }
                }
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(
                    Capsule().fill(
                        hasKey
                        ? Tokens.Color.successGreen.opacity(0.10)
                        : Tokens.Color.warmWhite.opacity(0.04)
                    )
                )
            }
            Spacer()
        }
    }

    private func providerCard(provider: APIProvider) -> some View {
        let hasKey = (draftKeys[provider]?.isEmpty == false)
        let justSaved = (saveFlash[provider].map { Date().timeIntervalSince($0) < 2 }) ?? false
        return VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
            // header
            HStack {
                Image(systemName: providerIcon(provider))
                    .font(.system(size: 14))
                    .foregroundStyle(providerTint(provider))
                Text(provider.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                if justSaved {
                    Label("已保存", systemImage: "checkmark.circle.fill")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(Tokens.Color.successGreen)
                        .transition(.opacity)
                }
                Spacer()
                if hasKey {
                    pill(text: "已配置", color: Tokens.Color.successGreen)
                } else {
                    pill(text: "未配置", color: Tokens.Color.tertiaryText)
                }
            }

            // API key 输入
            apiKeyInput(provider: provider)

            // Custom provider 额外显示 endpoint
            if provider == .custom {
                endpointInput(provider: provider)
            }

            // model 输入（可选）
            modelInput(provider: provider)

            // 按钮组
            HStack(spacing: Tokens.Spacing.sm) {
                Button {
                    saveProvider(provider)
                } label: {
                    Label("保存", systemImage: "square.and.arrow.down")
                        .font(.system(size: 12, weight: .medium))
                }
                .buttonStyle(.borderedProminent)
                .tint(Tokens.Color.purpleVivid)
                .disabled((draftKeys[provider]?.isEmpty ?? true))

                if hasKey {
                    Button {
                        Task { await testConnection(provider) }
                    } label: {
                        if testResults[provider]?.isTesting == true {
                            HStack(spacing: 4) {
                                ProgressView()
                                    .scaleEffect(0.6)
                                    .frame(width: 10, height: 10)
                                Text("测试中…")
                            }
                        } else {
                            Label("测试连接", systemImage: "antenna.radiowaves.left.and.right")
                        }
                    }
                    .font(.system(size: 12, weight: .medium))
                    .buttonStyle(.bordered)
                    .disabled(testResults[provider]?.isTesting == true)

                    Button(role: .destructive) {
                        clearProvider(provider)
                    } label: {
                        Label("删除", systemImage: "trash")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .buttonStyle(.bordered)
                }

                Spacer()

                // test 结果（不测试时显示）
                if let result = testResults[provider], !result.isTesting {
                    testResultView(result)
                }
            }
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(justSaved ? Tokens.Color.successGreen.opacity(0.6) : Tokens.Color.hairline,
                        lineWidth: justSaved ? 1.5 : 1)
        )
        .animation(.easeInOut(duration: 0.2), value: justSaved)
    }

    // MARK: - 输入组件

    private func apiKeyInput(provider: APIProvider) -> some View {
        let binding = Binding(
            get: { draftKeys[provider] ?? "" },
            set: { draftKeys[provider] = $0 }
        )
        let isRevealed = revealed.contains(provider)
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("API key")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(0.5)
                    .foregroundStyle(Tokens.Color.tertiaryText)
                Spacer()
                Text(provider == .anthropic ? "格式：sk-ant-…" : "格式：sk-…")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            HStack(spacing: 6) {
                Image(systemName: "lock.fill")
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 16)
                Group {
                    if isRevealed {
                        TextField("sk-…", text: binding)
                    } else {
                        SecureField("sk-…", text: binding)
                    }
                }
                .textFieldStyle(.plain)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(Tokens.Color.warmWhite)

                Button {
                    if isRevealed {
                        revealed.remove(provider)
                    } else {
                        revealed.insert(provider)
                    }
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .font(.system(size: 12))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
                .buttonStyle(.plain)
                .help(isRevealed ? "隐藏" : "显示（不进入剪贴板）")
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Tokens.Color.nearBlack.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: Tokens.Radius.input, style: .continuous))
        }
    }

    private func endpointInput(provider: APIProvider) -> some View {
        let binding = Binding(
            get: { draftEndpoints[provider] ?? "" },
            set: { draftEndpoints[provider] = $0 }
        )
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("Endpoint")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(0.5)
                    .foregroundStyle(Tokens.Color.tertiaryText)
                Spacer()
                Text("必须 HTTPS")
                    .font(.system(size: 9))
                    .foregroundStyle(Tokens.Color.warningOrange)
            }
            HStack(spacing: 6) {
                Image(systemName: "network")
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 16)
                TextField("https://your-endpoint.com", text: binding)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Tokens.Color.nearBlack.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: Tokens.Radius.input, style: .continuous))
        }
    }

    private func modelInput(provider: APIProvider) -> some View {
        let binding = Binding(
            get: { draftModels[provider] ?? "" },
            set: { draftModels[provider] = $0 }
        )
        return VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Text("Model")
                    .font(.system(size: 10, weight: .semibold))
                    .tracking(0.5)
                    .foregroundStyle(Tokens.Color.tertiaryText)
                Spacer()
                Text("默认: \(provider.defaultModel.isEmpty ? "无（必填）" : provider.defaultModel)")
                    .font(.system(size: 9, design: .monospaced))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            HStack(spacing: 6) {
                Image(systemName: "cpu")
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 16)
                TextField(provider.defaultModel.isEmpty ? "例如 gpt-4o, claude-sonnet-4-5, …" : provider.defaultModel, text: binding)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(Tokens.Color.nearBlack.opacity(0.4),
                        in: RoundedRectangle(cornerRadius: Tokens.Radius.input, style: .continuous))
        }
    }

    private var privacyNote: some View {
        HStack(spacing: 6) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
            Text("Keychain 入口 service: `\(KeychainService.service)` · 访问控制: AfterFirstUnlock")
                .font(.system(size: 11, design: .monospaced))
                .foregroundStyle(Tokens.Color.tertiaryText)
        }
    }

    // MARK: - 测试结果视图

    @ViewBuilder
    private func testResultView(_ result: TestResult) -> some View {
        switch result.outcome {
        case .testing:
            HStack(spacing: 4) {
                ProgressView()
                    .controlSize(.small)
                Text("测试中…")
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
        case .success(let model, let latencyMs):
            HStack(spacing: 4) {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.successGreen)
                Text("已连接 · \(model) · \(latencyMs) ms")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
        case .failure(let message):
            HStack(spacing: 4) {
                Image(systemName: "xmark.octagon.fill")
                    .font(.system(size: 12))
                    .foregroundStyle(Tokens.Color.recRed)
                Text(message)
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.recRed)
                    .lineLimit(2)
            }
            .help(message)
        }
    }

    private func pill(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
    }

    // MARK: - 工具

    private func providerIcon(_ provider: APIProvider) -> String {
        switch provider {
        case .openai:    return "circle.hexagongrid.fill"
        case .anthropic: return "circle.grid.cross.fill"
        case .custom:    return "wrench.and.screwdriver.fill"
        }
    }

    private func providerTint(_ provider: APIProvider) -> Color {
        switch provider {
        case .openai:    return Tokens.Color.tealVivid
        case .anthropic: return Tokens.Color.pink
        case .custom:    return Tokens.Color.purpleMid
        }
    }

    // MARK: - 动作

    private func saveProvider(_ provider: APIProvider) {
        do {
            try KeychainService.saveAPIKey(draftKeys[provider] ?? "", for: provider)
            if provider == .custom {
                let url = URL(string: draftEndpoints[provider] ?? "")
                try KeychainService.saveEndpoint(url, for: provider)
            }
            // model 永远保存（即使是空 → KeychainService 会 delete；下次读用 default）
            let modelDraft = draftModels[provider] ?? ""
            try KeychainService.saveModel(modelDraft.isEmpty ? nil : modelDraft, for: provider)

            // 闪 2 秒"已保存"
            withAnimation(.easeInOut(duration: 0.2)) {
                saveFlash[provider] = Date()
            }
            // 清除该 provider 的旧 test 结果（key 变了）
            testResults[provider] = nil
            // 2 秒后自动消除
            Task {
                try? await Task.sleep(for: .seconds(2))
                await MainActor.run {
                    if let saved = saveFlash[provider],
                       Date().timeIntervalSince(saved) >= 2 {
                        saveFlash[provider] = nil
                    }
                }
            }
        } catch {
            testResults[provider] = TestResult(
                outcome: .failure("保存失败: \(error.localizedDescription)"),
                isTesting: false
            )
        }
    }

    private func clearProvider(_ provider: APIProvider) {
        KeychainService.deleteAll(for: provider)
        draftKeys[provider] = ""
        draftEndpoints[provider] = provider.defaultEndpoint?.absoluteString ?? ""
        draftModels[provider] = provider.defaultModel
        testResults[provider] = nil
        saveFlash[provider] = nil
    }

    private func testConnection(_ provider: APIProvider) async {
        testResults[provider] = TestResult(outcome: .testing, isTesting: true)
        do {
            // 先把 draft 写进 keychain（resolve 时 keychainService 读的是 saved 值）
            try KeychainService.saveAPIKey(draftKeys[provider] ?? "", for: provider)
            if provider == .custom {
                let url = URL(string: draftEndpoints[provider] ?? "")
                try KeychainService.saveEndpoint(url, for: provider)
            }
            let modelDraft = draftModels[provider] ?? ""
            try KeychainService.saveModel(modelDraft.isEmpty ? nil : modelDraft, for: provider)

            let config = try SummaryService.Config.resolve(
                provider: provider,
                apiKey: KeychainService.loadAPIKey(for: provider) ?? "",
                storedEndpoint: KeychainService.loadEndpoint(for: provider),
                storedModel: KeychainService.loadModel(for: provider)
            )

            // 测活 + 计时
            let start = Date()
            try await state.summaryService.testConnection(config: config)
            let latencyMs = Int(Date().timeIntervalSince(start) * 1000)

            testResults[provider] = TestResult(
                outcome: .success(model: config.model, latencyMs: latencyMs),
                isTesting: false
            )
        } catch {
            testResults[provider] = TestResult(
                outcome: .failure(error.localizedDescription),
                isTesting: false
            )
        }
    }
}

// MARK: - 测试结果模型

private struct TestResult {
    enum Outcome {
        case testing
        case success(model: String, latencyMs: Int)
        case failure(String)
    }
    let outcome: Outcome
    let isTesting: Bool
}
