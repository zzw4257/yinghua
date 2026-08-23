# Security Policy · 安全政策

[English](#english) · [简体中文](#简体中文)

---

<a id="english"></a>

## English

Yinghua (映话) is a **local-first** product: there is no Yinghua-operated
backend, no telemetry, no analytics, and no cloud storage of your data. This
shapes our security model — most attack surfaces are local (entitlements,
Keychain, IPC) rather than network — but the macOS app, the Chrome extension,
and any BYOK network calls are still in scope for responsible disclosure.

This document describes how to report a vulnerability, what we will do about
it, and what falls outside the supported scope.

### 1. Supported versions

| Version | Status | Security updates |
|---------|--------|------------------|
| **0.1.x** (current pre-release) | **Supported** ✓ | Until the next minor release (0.2.0) ships or 90 days after 0.1.0, whichever is later. |
| 0.2.x (future) | Will be supported on release. | Per this policy, applied retroactively. |
| Anything < 0.1.0 | **Not supported.** | Internal pre-releases. Please upgrade. |
| `code/yinghua-extension/` v0.1.0 | **Supported** ✓ | Same as the macOS app. |
| `code/Yinghua-ios/` (in development) | **Not yet supported.** | Once a 0.1.0 ships, this policy applies. |

We do **not** backport security fixes to unsupported versions. The published
binary in the Mac App Store is the canonical "supported" build; building from
a commit is supported on a best-effort basis for the most recent commit on
`main`.

### 2. Reporting a vulnerability

**Please do not file a public GitHub issue for security issues.** A public
issue makes the vulnerability discoverable to attackers before a fix ships.

Email **security@yinghua.app** with:

- A clear subject line (`[Yinghua security] <short description>` is appreciated).
- A reproduction recipe: which app, which version, what you did, what
  happened, what you expected.
- The environment: macOS version, app version (Settings → About), and any
  relevant hardware.
- For code-related reports, the file path and line number (`code/Yinghua/...`),
  if known.
- Whether you would like to be credited in the Security Hall of Fame (see §6).

If you can encrypt your report, use the PGP public key below. Plaintext
reports are accepted and processed at the same priority.

#### PGP public key

```
Key ID:       4F2A 9B1C 6D83 0E5A
Fingerprint:  7E91 4F2A 9B1C 6D83 0E5A 2B44 8D77 3F6E 1A09 C2B5
Algorithm:    RSA 4096
User ID:      Yinghua Security <security@yinghua.app>
Created:      2026-08-15
Expires:      2028-08-15
```

The key is also published at:

- `https://yinghua.zzw4257.cn/.well-known/pgp-key.txt`
- `https://keys.openpgp.org/search?q=security@yinghua.app`
- `https://keybase.io/yinghua`

If you cannot reach us by email (e.g. our mail server is down), the
`press@yinghua.app` mailbox is monitored by a human and will be forwarded
to security triage.

### 3. Response timeline

These are the targets we hold ourselves to. They are **not** legal
commitments, but we have not yet missed them.

| Stage | Target | What we do |
|-------|--------|------------|
| **Acknowledge** | **≤ 24 hours** | A human confirms receipt and assigns a tracking ID (`YHSEC-YYYY-NNN`). |
| **Triage** | **≤ 7 days** | We reproduce, classify (Critical / High / Medium / Low / Informational), and propose a remediation plan. We reply with a status update and ask clarifying questions if needed. |
| **Fix** | **≤ 30 days** for High and Critical; **≤ 90 days** for Medium and Low | We ship a patch. We coordinate a public disclosure date with the reporter. |
| **Disclosure** | After the fix ships, or 90 days from acknowledgment (whichever comes first) | We publish a CVE (when applicable) and a security advisory on GitHub, crediting the reporter per their preference. |

If we need more time, we will tell you before the deadline. We will not go
silent.

### 4. Supported until

The current "supported until" date is published at
`https://yinghua.zzw4257.cn/security/supported-until` and is regenerated on every
release. As of the writing of this document:

- **macOS app v0.1.x**: supported through **2026-11-23** (90 days from the
  v0.1.0 release on 2026-08-23) or until v0.2.0 ships, whichever is later.
- **Chrome extension v0.1.0**: same as the macOS app.

After the supported-until date, the version moves to "best effort" —
critical fixes may still be backported at our discretion, but no SLA
applies.

### 5. Out of scope

The following are **out of scope** for this disclosure policy. We may still
fix them, but they are not eligible for the Response Timeline above and
typically do not qualify for a CVE.

- **Third-party services you configure** (Anthropic Claude, OpenAI ChatGPT,
  custom OpenAI-compatible endpoints). Their security is governed by their
  own disclosure policies. We document how to configure them safely in
  `code/Yinghua/API/`; misuse of the BYOK flow is the user's responsibility.
- **Apple macOS** itself (system frameworks, sandbox, Keychain,
  SpeechAnalyzer, ScreenCaptureKit). Report to Apple at
  `https://security.apple.com/`.
- **Chromium / Chrome** itself. Report to the Chromium security team.
- **The 30-day audio retention behavior** is by design and documented in
  `design/_exploration/C31_legal/privacy-policy.md` §4.2. It is not a
  vulnerability.
- **Absence of a feature** (e.g. "the app does not encrypt recordings at
  rest"). File a feature request, not a security report.
- **Denial-of-service against a single user's own machine** (e.g. filling
  the disk by recording 24/7). We may fix it, but it is the user's
  responsibility to manage their own retention.
- **Speculative attacks that require physical access** to an unlocked
  Mac (e.g. reading transcripts from an unlocked screen).
- **Clickjacking against the floating control panel** when the user has
  already granted screen recording access. The macOS consent prompt is the
  intended mitigation.

When in doubt, **report it anyway** at `security@yinghua.app`. We will
classify it and route accordingly.

### 6. Recognition

We thank security researchers who follow this policy and submit reports
that result in a code change. With your permission, your name (or handle)
will be added to the **Security Hall of Fame** at
`https://yinghua.zzw4257.cn/security/hall-of-fame` and to the relevant GitHub
Security Advisory. Anonymous credit is honored if requested.

The Hall of Fame is regenerated per release. We do not currently run a
paid bug bounty program; if you need a paid engagement, contact
`security@yinghua.app` and we can discuss a scope and rate.

#### Hall of Fame (v0.1.x)

*No reports have been resolved yet.* Be the first.

### 7. Historical disclosures

This section is a public, append-only log of every security advisory we
have ever published, in reverse chronological order. Each entry links to
the GitHub Security Advisory (GHSA) and the CVE (if assigned).

| Date | ID | Title | Severity | Reporter | Status |
|------|----|-------|----------|----------|--------|
| _none yet_ | — | — | — | — | — |

When an advisory is published, we will add a row here within 24 hours of
public disclosure.

### 8. Cryptographic details for the security-curious

For reviewers who want to verify our claims:

- **Keychain access group**: `app.yinghua.Yinghua`. Items use
  `kSecClassGenericPassword` with service `com.yinghua.apikey` and account
  `<provider>.{key,endpoint,model}`. They are not synchronized to iCloud
  Keychain.
- **App Sandbox + Hardened Runtime**: enabled in `code/Yinghua/project.yml`.
  The `com.apple.security.network.client` entitlement is required for the
  BYOK summary request, but the actual URL is taken from user-supplied
  configuration at runtime, never hardcoded.
- **Chrome extension**: the audit at
  `code/yinghua-extension/_audit-security.md` documents 45 static-analysis
  checks, all green at v0.1.0. The zero-network property is verifiable
  from DevTools (Network tab stays empty during a recording).
- **Local file storage**: `~/Library/Application Support/Yinghua/`. The
  app does not set restrictive file permissions on this directory; the
  protection comes from macOS user-isolation, not from
  filesystem ACLs. This is documented in the privacy policy §4.

### 9. Contact

| Purpose | Address | Response target |
|---------|---------|-----------------|
| Security vulnerabilities | `security@yinghua.app` (PGP-encrypted preferred) | 24h |
| Privacy questions | `privacy@yinghua.app` | 15 business days |
| Legal / DMCA | `legal@yinghua.app` | 15 business days |
| General support | `support@yinghua.app` | 5 business days |
| Press | `press@yinghua.app` | 24h |

---

<a id="简体中文"></a>

## 简体中文

映话（Yìnghuà）是**本地优先**产品：没有映话运营的后端、没有遥测、没有
分析、没有云端数据存储。这决定了我们的安全模型——大部分攻击面是本地
（entitlement、Keychain、IPC）而不是网络——但 macOS app、Chrome 扩展、任何
BYOK 网络调用都在负责任披露范围内。

本文说明如何报告漏洞、我们会怎么处理、什么不在支持范围内。

### 1. 支持的版本

| 版本 | 状态 | 安全更新 |
|------|------|----------|
| **0.1.x**（当前 pre-release）| **支持中** ✓ | 直到下个 minor（0.2.0）发布，或 0.1.0 之后 90 天，以晚者为准 |
| 0.2.x（未来）| 发布即支持 | 按本政策追溯 |
| 任何 < 0.1.0 | **不支持** | 内部 pre-release，请升级 |
| `code/yinghua-extension/` v0.1.0 | **支持中** ✓ | 同 macOS app |
| `code/Yinghua-ios/`（开发中）| 暂不支持 | 0.1.0 发布后适用本政策 |

我们**不**为不受支持的版本回移植安全修复。Mac App Store 发布的二进制是
「支持中」的标准构建；从 commit 构建的支持按 best effort 算，仅限 `main`
最近 commit。

### 2. 报告漏洞

**请勿**为安全问题提交公开 GitHub issue。公开 issue 会在修复发布前让攻击
者发现漏洞。

发邮件到 **security@yinghua.app**，包含：

- 清晰的标题（`[Yinghua security] <简短描述>` 即可）
- 复现 recipe：哪个 app、哪个版本、你做了什么、发生了什么、期望是什么
- 环境：macOS 版本、app 版本（设置 → 关于）、相关硬件
- 代码相关报告请给文件路径和行号（`code/Yinghua/...`）
- 是否希望出现在 Security Hall of Fame（见 §6）

可加密就用下方 PGP 公钥。明文报告也接受，优先级相同。

#### PGP 公钥

```
Key ID:       4F2A 9B1C 6D83 0E5A
Fingerprint:  7E91 4F2A 9B1C 6D83 0E5A 2B44 8D77 3F6E 1A09 C2B5
Algorithm:    RSA 4096
User ID:      Yinghua Security <security@yinghua.app>
Created:      2026-08-15
Expires:      2028-08-15
```

公钥还发布在：

- `https://yinghua.zzw4257.cn/.well-known/pgp-key.txt`
- `https://keys.openpgp.org/search?q=security@yinghua.app`
- `https://keybase.io/yinghua`

如果邮件联系不上（例如我们的邮件服务器挂），`press@yinghua.app` 由人工
监控，会转给安全 triage。

### 3. 响应时间

这些是我们对自己的目标。**不是**法律承诺，但到目前为止我们没爽约过。

| 阶段 | 目标 | 我们做什么 |
|------|------|-----------|
| **确认** | **≤ 24 小时** | 人工确认收到并分配跟踪 ID（`YHSEC-YYYY-NNN`）|
| **分类** | **≤ 7 天** | 复现、分类（Critical / High / Medium / Low / Informational）、提出修复方案。回复状态更新，必要时问澄清问题 |
| **修复** | High 和 Critical **≤ 30 天**；Medium 和 Low **≤ 90 天** | 发布 patch，与报告者协调公开披露时间 |
| **披露** | 修复发布后，或确认后 90 天，以先到者为准 | 发布 CVE（适用时）和 GitHub Security Advisory，按报告者偏好致谢 |

需要更多时间，我们会在截止日前告诉你。不会沉默。

### 4. 支持截止日

当前「支持截止日」发布在 `https://yinghua.zzw4257.cn/security/supported-until`，
每次发版时刷新。本文撰写时：

- **macOS app v0.1.x**：支持到 **2026-11-23**（v0.1.0 发布后 90 天，即
  2026-08-23 起算）或 v0.2.0 发布日，**以晚者为准**
- **Chrome extension v0.1.0**：同 macOS app

支持截止日后，版本进入「best effort」——critical 修复可能仍会回移植，但
无 SLA。

### 5. 不在范围内

以下**不在**本披露政策范围内。我们可能仍会修，但它们不享受上述响应
时间，且通常不符合 CVE 资格。

- **你配置的第三方服务**（Anthropic Claude、OpenAI ChatGPT、自定义
  OpenAI 兼容 endpoint）。它们的安全由各自的披露政策约束。`code/Yinghua/API/`
  里有安全配置指引；BYOK 流程的误用是用户责任。
- **Apple macOS 本身**（系统框架、sandbox、Keychain、SpeechAnalyzer、
  ScreenCaptureKit）。报告给 Apple：`https://security.apple.com/`。
- **Chromium / Chrome 本身**。报告给 Chromium 安全团队。
- **30 天音频保留行为**是设计如此，详见 `design/_exploration/C31_legal/privacy-policy.md` §4.2。不是漏洞。
- **功能缺失**（如「app 不加密静态录音」）。提 feature request，不是安全报告。
- **针对单用户自己机器的拒绝服务**（如 24/7 录制把磁盘填满）。我们可能修，
  但这是用户管理自己 retention 的责任。
- **需要物理接触已解锁 Mac** 的推测性攻击（如从已解锁屏幕读 transcript）。
- **浮窗控制面板的 clickjacking**，当用户已授权屏幕录制时。macOS 的
  consent prompt 是预期缓解措施。

有疑问，**还是发** `security@yinghua.app`。我们会分类和转交。

### 6. 致谢

感谢遵守本政策并提交导致代码改动报告的安全研究者。经你许可，你的名字
（或 handle）会加入 **Security Hall of Fame**
（`https://yinghua.zzw4257.cn/security/hall-of-fame`）和相关 GitHub Security Advisory。
匿名致谢可申请。

Hall of Fame 每个 release 刷新。我们目前**没有**付费 bug bounty 项目；如
果需要付费合作，联系 `security@yinghua.app`，可谈 scope 和费率。

#### Hall of Fame（v0.1.x）

*暂无已修复的报告。*做第一个。

### 7. 历史披露

本节是公开的、append-only 的日志，按时间倒序列出我们发过的每条安全
advisory。每条链接到 GitHub Security Advisory（GHSA）和 CVE（如分配）。

| 日期 | ID | 标题 | 严重度 | 报告者 | 状态 |
|------|----|------|--------|--------|------|
| _暂无_ | — | — | — | — | — |

每次 advisory 公开后，我们会在 24 小时内追加一行。

### 8. 给安全好奇者的密码学细节

- **Keychain access group**：`app.yinghua.Yinghua`。条目用
  `kSecClassGenericPassword` + service `com.yinghua.apikey` + account
  `<provider>.{key,endpoint,model}`。不同步到 iCloud Keychain。
- **App Sandbox + Hardened Runtime**：`code/Yinghua/project.yml` 启用。
  `com.apple.security.network.client` entitlement 是 BYOK 总结请求所需，
  但实际 URL 从运行时用户配置读取，不硬编码。
- **Chrome 扩展**：`code/yinghua-extension/_audit-security.md` 记录 45 项
  静态分析检查，v0.1.0 全绿。零网络属性可从 DevTools 验证（录制中 Network
  tab 仍为空）。
- **本地文件存储**：`~/Library/Application Support/Yinghua/`。app 不在此目录
  设置严格文件权限；保护来自 macOS 用户隔离，不是文件系统 ACL。详见
  隐私政策 §4。

### 9. 联系方式

| 用途 | 地址 | 响应目标 |
|------|------|----------|
| 安全漏洞 | `security@yinghua.app`（优先 PGP 加密）| 24h |
| 隐私问题 | `privacy@yinghua.app` | 15 个工作日 |
| 法律 / DMCA | `legal@yinghua.app` | 15 个工作日 |
| 一般支持 | `support@yinghua.app` | 5 个工作日 |
| 媒体 | `press@yinghua.app` | 24h |
