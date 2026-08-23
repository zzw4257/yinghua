import SwiftUI

/// Integrations 设置 tab
///
/// 3 个 provider 卡片（Notion / Slack / Custom Webhook）：
/// - 顶部 toggle：是否启用（启用后会议结束自动 push）
/// - 配置区：API key / URL / Database ID / secret
/// - 「测试推送」按钮：发一个最小 probe payload
/// - 「删除」按钮：清空所有凭据
struct IntegrationsSettingsView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.xl) {
            introCard
            ForEach(IntegrationProvider.allCases) { provider in
                IntegrationCard(
                    provider: provider,
                    manager: state.integrationsManager
                )
            }
            privacyNote
        }
    }

    // MARK: - 顶部说明卡

    private var introCard: some View {
        HStack(alignment: .top, spacing: Tokens.Spacing.md) {
            Image(systemName: "antenna.radiowaves.left.and.right")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(Tokens.Color.tealVivid)
                .frame(width: 32, height: 32)
                .background(Circle().fill(Tokens.Color.tealVivid.opacity(0.12)))
            VStack(alignment: .leading, spacing: 4) {
                Text("第三方集成 · 自动推送")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("会议结束后，映话会自动把 AI 总结推到下面启用的服务。默认关闭，按需开启。")
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

    private var privacyNote: some View {
        HStack(alignment: .top, spacing: 6) {
            Image(systemName: "lock.shield.fill")
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
            Text("所有凭据走 macOS Keychain（service: `\(KeychainService.service)`），映话不会上传到任何中转服务器。")
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
        }
    }
}

// MARK: - 单个 provider 卡片

private struct IntegrationCard: View {
    let provider: IntegrationProvider
    @ObservedObject var manager: IntegrationsManager

    // 各 provider 的草稿
    @State private var draft: DraftValues = DraftValues()
    @State private var testResult: TestResult?
    @State private var isTesting: Bool = false

    private struct DraftValues {
        var apiKey: String = ""
        var databaseId: String = ""
        var webhookURL: String = ""
        var secret: String = ""
        var revealed: Set<Field> = []
        enum Field: Hashable { case apiKey, secret }
    }

    private enum TestResult: Equatable {
        case success
        case failure(String)

        var message: String {
            switch self {
            case .success: return "推送成功"
            case .failure(let m): return m
            }
        }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
            header
            if manager.enabledProviders.contains(provider) {
                // 只在 enabled 时显示配置区（避免在 disabled 状态看到一堆空输入）
                configurationSection
            }
        }
        .padding(Tokens.Spacing.md)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous))
        .overlay(
            RoundedRectangle(cornerRadius: Tokens.Radius.card, style: .continuous)
                .stroke(Tokens.Color.hairline, lineWidth: 1)
        )
        .task {
            loadFromKeychain()
        }
    }

    // MARK: - Header（icon + name + toggle + status pill）

    private var header: some View {
        let isOn = Binding<Bool>(
            get: { manager.enabledProviders.contains(provider) },
            set: { newValue in
                manager.setEnabled(provider, enabled: newValue)
            }
        )
        let isConfigured = manager.isConfigured(provider)
        return HStack(spacing: Tokens.Spacing.sm) {
            Image(systemName: provider.iconName)
                .font(.system(size: 14, weight: .medium))
                .foregroundStyle(Tokens.Color.tealVivid)
                .frame(width: 28, height: 28)
                .background(Circle().fill(Tokens.Color.tealVivid.opacity(0.12)))

            VStack(alignment: .leading, spacing: 2) {
                Text(provider.displayName)
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text(provider.subtitle)
                    .font(.system(size: 11))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }

            Spacer()

            if isConfigured {
                pill(text: "已配置", color: Tokens.Color.successGreen)
            } else {
                pill(text: "未配置", color: Tokens.Color.tertiaryText)
            }

            Toggle("", isOn: isOn)
                .labelsHidden()
                .toggleStyle(.switch)
                .tint(Tokens.Color.tealVivid)
        }
    }

    // MARK: - 配置区

    @ViewBuilder
    private var configurationSection: some View {
        Divider().background(Tokens.Color.hairline)

        switch provider {
        case .notion:
            notionFields
        case .slack:
            slackFields
        case .webhook:
            webhookFields
        }

        // 按钮组
        HStack(spacing: Tokens.Spacing.sm) {
            Button {
                save()
            } label: {
                Text("保存")
                    .font(.system(size: 12, weight: .medium))
            }
            .buttonStyle(.borderedProminent)
            .tint(Tokens.Color.purpleVivid)

            Button {
                Task { await testPush() }
            } label: {
                Text(isTesting ? "推送中…" : "测试推送")
                    .font(.system(size: 12, weight: .medium))
            }
            .buttonStyle(.bordered)
            .disabled(isTesting || !manager.isConfigured(provider))

            if hasAnyValue {
                Button(role: .destructive) {
                    clear()
                } label: {
                    Text("清空")
                        .font(.system(size: 12, weight: .medium))
                }
                .buttonStyle(.bordered)
            }

            Spacer()

            if let result = testResult {
                testResultView(result)
            }
        }
    }

    // MARK: - Notion 字段

    @ViewBuilder
    private var notionFields: some View {
        secureField(
            label: "Internal Integration Token",
            placeholder: "secret_xxxxxxxxxxxxxxxxxxxx",
            value: $draft.apiKey,
            field: .apiKey,
            icon: "lock.fill"
        )
        plainField(
            label: "Database ID",
            placeholder: "32 位 database id（带不带 dash 都行）",
            value: $draft.databaseId,
            icon: "tablecells"
        )
    }

    // MARK: - Slack 字段

    @ViewBuilder
    private var slackFields: some View {
        plainField(
            label: "Incoming Webhook URL",
            placeholder: "https://hooks.slack.com/services/T.../B.../...",
            value: $draft.webhookURL,
            icon: "link"
        )
    }

    // MARK: - Webhook 字段

    @ViewBuilder
    private var webhookFields: some View {
        plainField(
            label: "Endpoint URL（HTTPS）",
            placeholder: "https://your-server.com/yinghua/webhook",
            value: $draft.webhookURL,
            icon: "link"
        )
        secureField(
            label: "HMAC 共享密钥（可选）",
            placeholder: "留空 = 不签名",
            value: $draft.secret,
            field: .secret,
            icon: "key.horizontal.fill"
        )
    }

    // MARK: - 输入子组件

    private func plainField(
        label: String,
        placeholder: String,
        value: Binding<String>,
        icon: String
    ) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Tokens.Color.tertiaryText)
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 16)
                TextField(placeholder, text: value)
                    .textFieldStyle(.plain)
                    .font(.system(size: 12, design: .monospaced))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Tokens.Color.nearBlack.opacity(0.4),
                in: RoundedRectangle(cornerRadius: Tokens.Radius.input, style: .continuous)
            )
        }
    }

    private func secureField(
        label: String,
        placeholder: String,
        value: Binding<String>,
        field: DraftValues.Field,
        icon: String
    ) -> some View {
        let isRevealed = draft.revealed.contains(field)
        return VStack(alignment: .leading, spacing: 4) {
            Text(label)
                .font(.system(size: 10, weight: .medium))
                .foregroundStyle(Tokens.Color.tertiaryText)
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .foregroundStyle(Tokens.Color.tertiaryText)
                    .frame(width: 16)
                Group {
                    if isRevealed {
                        TextField(placeholder, text: value)
                    } else {
                        SecureField(placeholder, text: value)
                    }
                }
                .textFieldStyle(.plain)
                .font(.system(size: 12, design: .monospaced))
                .foregroundStyle(Tokens.Color.warmWhite)

                Button {
                    if isRevealed {
                        draft.revealed.remove(field)
                    } else {
                        draft.revealed.insert(field)
                    }
                } label: {
                    Image(systemName: isRevealed ? "eye.slash" : "eye")
                        .font(.system(size: 12))
                        .foregroundStyle(Tokens.Color.tertiaryText)
                }
                .buttonStyle(.plain)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 8)
            .background(
                Tokens.Color.nearBlack.opacity(0.4),
                in: RoundedRectangle(cornerRadius: Tokens.Radius.input, style: .continuous)
            )
        }
    }

    // MARK: - 工具

    private func pill(text: String, color: Color) -> some View {
        Text(text)
            .font(.system(size: 10, weight: .semibold))
            .foregroundStyle(color)
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(color.opacity(0.15), in: Capsule())
    }

    private func testResultView(_ result: TestResult) -> some View {
        let isSuccess = result == .success
        return HStack(spacing: 4) {
            Image(systemName: isSuccess ? "checkmark.circle.fill" : "xmark.octagon.fill")
                .font(.system(size: 12))
                .foregroundStyle(isSuccess ? Tokens.Color.successGreen : Tokens.Color.recRed)
            Text(result.message)
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
                .lineLimit(2)
        }
    }

    private var hasAnyValue: Bool {
        switch provider {
        case .notion:
            return !draft.apiKey.isEmpty || !draft.databaseId.isEmpty
        case .slack:
            return !draft.webhookURL.isEmpty
        case .webhook:
            return !draft.webhookURL.isEmpty || !draft.secret.isEmpty
        }
    }

    // MARK: - 动作

    private func loadFromKeychain() {
        switch provider {
        case .notion:
            draft.apiKey = readKeychain("api_key") ?? ""
            draft.databaseId = readKeychain("database_id") ?? ""
        case .slack:
            draft.webhookURL = readKeychain("webhook_url") ?? ""
        case .webhook:
            draft.webhookURL = readKeychain("url") ?? ""
            draft.secret = readKeychain("secret") ?? ""
        }
    }

    private func save() {
        do {
            switch provider {
            case .notion:
                try KeychainService.saveString(draft.apiKey, account: "integration.notion.api_key")
                try KeychainService.saveString(draft.databaseId, account: "integration.notion.database_id")
            case .slack:
                try KeychainService.saveString(draft.webhookURL, account: "integration.slack.webhook_url")
            case .webhook:
                try KeychainService.saveString(draft.webhookURL, account: "integration.webhook.url")
                try KeychainService.saveString(draft.secret, account: "integration.webhook.secret")
            }
            // 触发 manager 重新读取（让 isConfigured 状态同步）
            manager.objectWillChange.send()
        } catch {
            testResult = .failure("保存失败: \(error.localizedDescription)")
        }
    }

    private func clear() {
        switch provider {
        case .notion:
            KeychainService.deleteItem(account: "integration.notion.api_key")
            KeychainService.deleteItem(account: "integration.notion.database_id")
            draft.apiKey = ""
            draft.databaseId = ""
        case .slack:
            KeychainService.deleteItem(account: "integration.slack.webhook_url")
            draft.webhookURL = ""
        case .webhook:
            KeychainService.deleteItem(account: "integration.webhook.url")
            KeychainService.deleteItem(account: "integration.webhook.secret")
            draft.webhookURL = ""
            draft.secret = ""
        }
        testResult = nil
        manager.objectWillChange.send()
    }

    private func testPush() async {
        // 先保存草稿到 keychain，否则 push 时读不到最新值
        save()
        isTesting = true
        testResult = nil
        defer { isTesting = false }
        if let err = await manager.testPush(provider: provider) {
            testResult = .failure(err)
        } else {
            testResult = .success
        }
    }

    private func readKeychain(_ suffix: String) -> String? {
        let account = "\(provider.keychainPrefix).\(suffix)"
        do {
            guard let raw = try KeychainService.loadString(account: account) else {
                return nil
            }
            return raw.isEmpty ? nil : raw
        } catch {
            return nil
        }
    }
}
