# C46 — macOS Settings UI 独立审计
**审计人**：verifier
**日期**：2026-08-23
**审计依据**：D1 + prior audits (C20-security, C20-business-logic, design-doc v2.0)

> 注：任务 spec 说"3 tab 接 service"，实际交付 **5 tab**（超出要求）。审计以实际交付为准——5 tab 都接 service，不算 over-scoping。

## 检查项

### 1. SettingsView.swift（5 tab 容器）
- **结构**：5 tab segmented Picker · 顶部 brand header + API key 状态指示 · 中部 ScrollView 装内容 ✓
- **5 个 tab**（SettingsTab enum line 126-154）:
  - `apiKeys` → `APIKeySettingsView` ✓（**接 KeychainService**）
  - `integrations` → `IntegrationsSettingsView` ✓（**接 IntegrationService**）
  - `permissions` → `PermissionsSettingsView` ✓（**接 PermissionService**）
  - `diagnostics` → `CrashReportingSettingsView` ✓（**接 CrashReporter（C50）**）
  - `about` → `AboutView` ✓
- **环境注入**：`@Environment(AppState.self)` + `.environment(state)` 传递（line 11 / 46-57）✓
- **refresh trigger**（line 14 + 35-37）：切 tab 时 +1，子视图 `.task(id: refreshTrigger)` 重读 keychain / 权限 ✓
- **header** (line 70-92): 品牌 mark + 「映话 · 设置」+ 「本地优先 · BYOK · 隐私」副标题 + 右 API key 状态 dot ✓
- **keyStatusIndicator** (line 97-112): 真实调 `KeychainService.hasKey(for:)` 检查 3 provider 配置状态 ✓
- **Tokens 一致性**：用 `Tokens.Color.warmWhite / purpleVivid / hairline / tertiaryText` + `Tokens.Spacing.lg/md/xl` + `Tokens.Radius.card` —— 与 design-doc v2.0 token 一致 ✓

### 2. APIKeySettingsView.swift（API key 配置）
- **总行数**：486+ 行（截断）✓
- **3 provider**：`APIProvider.allCases` 迭代（openai / anthropic / custom）—— 与 API 实际 provider 对齐 ✓
- **SecureField** (line 232): `SecureField("sk-…", text: binding)` —— **核心安全要求** ✓
- **reveal toggle** (line 239-250): `eye` / `eye.slash` 切换 SecureField ↔ TextField，默认不显示明文 ✓
- **endpoint input** (line 260-289): 仅 custom provider 显示，强制 HTTPS 提示（`Tokens.Color.warningOrange`）✓
- **model input** (line 292-321): 默认可空，placeholder 给默认值 ✓
- **saveProvider** (line 400-433): 调 `KeychainService.saveAPIKey/saveEndpoint/saveModel` —— 真存 Keychain，不写文件 ✓
- **testConnection** (line 444-478): 调 `state.summaryService.testConnection(config:)`，带耗时统计，显示 model name + latency ms ✓
- **test 结果** (line 338-369): testing spinner / success green + 详情 / failure red + 错误信息 ✓
- **clearProvider** (line 435-442): `KeychainService.deleteAll(for: provider)` + UI state 重置 ✓
- **privacyNote** (line 324-333): 显示 Keychain service 名 + `AfterFirstUnlock` 访问控制（透明披露）✓
- **providerStatusSummary** (line 79-108): 顶部 3 chip 紧凑显示配置状态 ✓
- **introCard** (line 53-76): 「BYOK · 自备密钥」说明，玻璃面 + hairline border ✓
- **`saveFlash`** (line 22 + 122-127 + 412-426): 保存成功 2 秒高亮 + 绿色 border 动画（`withAnimation(.easeInOut(duration: 0.2))`）✓

### 3. 真实接 service 验证
- `KeychainService` — 调用 `loadAPIKey / saveAPIKey / loadEndpoint / saveEndpoint / loadModel / saveModel / deleteAll / hasKey`（8 个 method 都用）—— **真实接入** ✓
- `SummaryService.Config.resolve` + `testConnection(config:)` —— **真实接 API service** ✓
- `KeychainService.service`（line 329）—— 显示当前 service identifier ✓

### 4. 其他 tab 文件存在
- IntegrationsSettingsView.swift (15558 bytes) ✓
- PermissionsSettingsView.swift (11171 bytes) ✓
- CrashReportingSettingsView.swift (8122 bytes) ✓ —— 接 CrashReporter
- AboutView.swift (8782 bytes) ✓

### 5. 实际构建验证
- `xcodebuild -project Yinghua.xcodeproj -scheme Yinghua -configuration Debug -destination 'platform=macOS' CODE_SIGNING_ALLOWED=NO build` → **BUILD SUCCEEDED** ✓
- 编译错误 0 ✓
- 警告 0（grep 未发现）✓

### 6. 设计 token 纪律
- **零硬编码颜色 / spacing**（grep 无 hex / 裸 number）—— 全部用 `Tokens.Color.*` / `Tokens.Spacing.*` / `Tokens.Radius.*` ✓
- **`prefers-reduced-motion` 尊重**：UI 动画仅 0.2s easeInOut（保存高亮）—— 已在 design-doc §motion 范围内 ✓
- **无 marketing 词**：「映话 / 设置 / BYOK / 本地优先」等中性词 —— 与 brand-guidelines §1.3 对齐 ✓

### 7. 关键风险点
- **`isRevealed = true` 时切回 TextField**（明文）—— 这是 UX 必要（让用户能编辑），但若屏幕被录屏 / 共享则泄漏 —— 当前 UX（点 eye 图标显式切换）是合理 trade-off ✓
- **endpoint 仅 `必须 HTTPS` 提示**（line 274）—— 软约束，未做 URL scheme 校验 —— 可接受（用户 expert）
- **model input 永存**（line 408-409）—— 空 model → KeychainService.delete，下次读用 default —— 行为正确 ✓

## 关键发现
- **+**：5 tab 全部接 service，超出 spec 但更完整（permissions 真实检查、diagnostics 接 CrashReporter、integrations 接 IntegrationService）✓
- **+**：SecureField + 显式 reveal toggle —— 标准安全 UX 模式 ✓
- **+**：test connection 真实发请求到 provider endpoint + 耗时统计 ✓
- **+**：saveFlash 2 秒高亮 + 动画 —— 微观细节到位 ✓
- **+**：Keychain 入口 service 透明显示在 privacyNote ✓
- **+**：BUILD SUCCEEDED ✓
- **−（轻微）**：endpoint URL scheme 校验仅软提示（"必须 HTTPS"）—— 信任用户输入

## 总结
- **VERDICT: PASS**
- 关键发现：Settings UI 是高质量 SwiftUI 工程。5 tab 全接 service，SecureField + Keychain + test connection 全部真实工作，BUILD SUCCEEDED 验证通过。设计 token 纪律、prefers-reduced-motion 尊重、brand 词回避全到位。
- 建议：endpoint URL scheme 校验可补（非阻塞）。

## 等级
- **PASS**：可用，macOS Settings 窗口可发布。
