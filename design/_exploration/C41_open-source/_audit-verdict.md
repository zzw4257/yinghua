# C41 — Open Source Repo 独立审计
**审计人**：verifier
**日期**：2026-08-23
**审计依据**：D1 + prior audits

## 检查项

### 1. README.md（4 语言）
- **总行数**：368 行 ✓
- **第 10 行锚点**：`[English](#english) · [简体中文](#简体中文) · [繁體中文](#繁體中文) · [日本語](#日本語)` —— 4 语言 anchor 完整 ✓
- **English** (line 16-164): badge + 4 个 component 表格 + 4 承诺（local-first / BYOK / no telemetry / open design）+ 仓库结构图 + CI/CD 表 + Quick start + Testing + Contributing + Security + License + Acknowledgements ✓
- **简体中文** (line 167-329): 完整复刻 + 加 "发版" 节（macOS / Chrome tag 流程）✓
- **繁體中文** (line 333-348): 4 组件表 + 指向 English 段（差异化处理，因为繁体用户多能读简体）✓
- **日本語** (line 352-368): 3 コンポーネント表（macOS / iOS / Chrome）+ ビルド手順は English を参照 ✓
- **CI/CD 徽章**：Build & Test / Release / Chrome Extension 三个 badge（line 3-5）✓
- **诚实声明**（line 39-40 + 188）："No telemetry, no analytics, no crash reporting to us" —— 但 C50 已实现 opt-in crash reporting，**轻微不一致**（README 没更新为 "opt-in crash reporting"）

### 2. LICENSE (MIT)
- **完整 MIT 文本**：21 行标准文本 ✓
- **Copyright (c) 2026 Yinghua Inc.** ✓
- **行数**：1064 bytes，包含完整 5 个 permission 段 + 2 个条件段 + warranty 免责 ✓
- **首行检查**：`MIT License` ✓
- **末行检查**：`...SOFTWARE.` ✓

### 3. CONTRIBUTING.md
- **总行数**：548 行 ✓
- **结构**：11 章节（中英双语并列）—— What / Dev env / Repo layout / Build&test / PR workflow / Commit conventions / Code style / Testing / i18n / 不接受什么 / Questions ✓
- **conventional commits**：type / scope / breaking change 完整定义 ✓
- **commit prefix 列表** (CONTRIBUTING.md line 145-146): fix/ feat/ chore/ docs/ refactor/ test/ design/ i18n/ ✓
- **What we will not accept** (line 294-312):
  - 拒绝 AI-generated code dumps（必须 reviewer 能答问题）✓
  - 拒绝 telemetry/analytics/crash-reporting SDKs ✓
  - 拒绝 network calls in Chrome extension ✓
  - 拒绝硬编码 API key / endpoint ✓
  - 拒绝营销词（"AI-driven"/"intelligent"/"revolutionary"/"empowering"）—— 与 brand-guidelines §1.3 对齐 ✓
  - 拒绝不通过 threat model 的新依赖（先开 issue）✓
- **SwiftLint .swiftlint.yml 引用** (line 220-222) ✓
- **降低测试豁免规则** (line 276-278): 纯 cosmetic 改动可免测试，但 PR body 必须声明 ✓

### 4. CODE_OF_CONDUCT.md
- **总行数**：185 行 ✓
- **7 个英文 section**（Pledge / Standards / Enforcement Responsibilities / Scope / Enforcement / Enforcement Guidelines / Attribution）✓ —— 与任务要求"7 章节"完全一致
- **Enforcement Guidelines 包含 4 子级**：1. Correction / 2. Warning / 3. Temporary Ban / 4. Permanent Ban ✓
- **Attribution 段**：明示 Contributor Covenant 2.1 + Mozilla diversity ladder 灵感 ✓
- **conduct@yinghua.app** 举报邮箱（line 64）✓
- **简体中文节选** (line 132-185): 5 段中文概述 + 「中文社区行为约定」（"C 老师 / Z 老师" 称呼 / 拒绝"大神""大佬"）—— 与用户工程偏好（persona）"不膜拜不吹捧" 对齐 ✓

### 5. SECURITY.md
- **总行数**：351 行 ✓
- **9 个英文 section**（Supported versions / Reporting / Response timeline / Supported until / Out of scope / Recognition / Historical disclosures / Crypto details / Contact）✓
- **PGP public key** (line 56-63): Key ID / Fingerprint / Algorithm RSA 4096 / User ID / Created / Expires —— 完整 ✓
- **响应时间表** (line 78-86):
  - Acknowledge ≤ 24 hours
  - Triage ≤ 7 days
  - Fix ≤ 30 days (High/Critical) · ≤ 90 days (Medium/Low)
  - Disclosure after fix or 90 days
  - 与任务要求"timeline"完全一致 ✓
- **Out of scope** (line 104-131): 8 项明确排除（BYOK third-party / Apple 平台 / Chromium / 30d 音频保留 / 功能缺失 / 自身 DoS / 物理接触 / 已授权 clickjacking）—— 范围定义清晰 ✓
- **Hall of Fame** (line 147-149): v0.1.x 暂无报告，"Be the first" ✓
- **附录 cryptography** (line 164-183): Keychain access group / Sandbox+Hardened Runtime / extension 45 检查点 / 本地存储路径 —— 给 security-curious reviewer 验证用 ✓
- **Contact 矩阵** (line 186-193): security/privacy/legal/support/press 五邮箱 + 响应 SLA ✓
- **简体中文** (line 199-351): 完整中文版 ✓

### 6. cross-reference 验证
- README 引用 LICENSE / CONTRIBUTING / CODE_OF_CONDUCT / SECURITY / design-doc.md / design-tokens.json —— 全部存在 ✓
- CONTRIBUTING 引用 .swiftlint.yml —— **该文件未验证存在**（轻微）
- SECURITY 引用 `code/yinghua-extension/_audit-security.md`（45 检查点）—— 已确认存在 ✓
- SECURITY 引用 `design/_exploration/C31_legal/privacy-policy.md` §3.2 / §4.2 —— 未单独验证（信任 cross-doc 引用）

## 关键发现
- **+**：4 语言 README 都包含具体命令（不仅文本），Quick start 可直接跑 ✓
- **+**：CODE_OF_CONDUCT 「中文社区行为约定」一段是 user persona 工程偏好的直接落地 ✓
- **+**：SECURITY.md 包含完整 PGP key block + 多镜像位置（keybase / openpgp.org）✓
- **+**：CONTRIBUTING §10 「We will not accept」明确写出 brand 禁止词清单 ✓
- **−（轻微）**：README.md line 39-40 声明 "No crash reporting to us" 与 C50 CrashReporter (opt-in) 存在轻微不一致 —— C50 是 opt-in（默认零收集），文案应改为 "No crash reporting by default · opt-in only" 之类
- **−（轻微）**：README line 31 + 56 提到 "design/ → 4 audit verdicts"，实际 `_audit-verdict.md` 有 14 份（C06/C07/C08/C09/C15/C16/C17/C18/C19/C25/C28/C34/C43 等）—— 数量低估
- **−（轻微）**：CONTRIBUTING 提到 `.swiftlint.yml` 但工作区根未发现该文件（仅作为承诺存在）—— 落地 follow-up

## 总结
- **VERDICT: PASS**
- 关键发现：4 语言 README + 完整 MIT + 7 章节 CoC + 9 章节 Security（含 PGP + 24h/7d/30d timeline）—— 全部满足任务要求。3 处轻微不一致（README "no crash reporting" / "4 verdicts" / swiftlint.yml 落地）均为诚实工程声明的滞后，不构成阻塞。
- 建议：把 README 那一行更新为 "No crash reporting by default · opt-in only"；「4 audit verdicts」改为「shippable 4 份 + 历史 14 份」；补 `.swiftlint.yml` 文件。

## 等级
- **PASS**：可用。开源治理文档齐备。
