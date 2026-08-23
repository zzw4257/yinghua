# Contributing to Yinghua · 贡献指南

[English](#english) · [简体中文](#简体中文)

---

<a id="english"></a>

## English

Thank you for considering a contribution to Yinghua (映话). This document
covers everything you need to send a high-quality pull request: development
environment, repository layout, build & test commands, commit message style,
and review workflow.

By participating in this project you agree to follow our
[Code of Conduct](CODE_OF_CONDUCT.md) (Contributor Covenant 2.1).

### 1. What you can contribute

| Type | Where it goes | How |
|------|---------------|-----|
| **Bug report** | GitHub Issues | Use the *Bug report* template. Include OS version, app version, repro steps, expected vs actual behavior. Screenshots and screen recordings welcome. |
| **Feature request** | GitHub Issues | Use the *Feature request* template. Describe the user problem first; the proposed implementation is secondary. |
| **Code (macOS app)** | Pull request to `code/Yinghua/` | Follow the workflow below. |
| **Code (iOS app)** | Pull request to `code/Yinghua-ios/` | Same workflow, smaller surface area. |
| **Code (Chrome extension)** | Pull request to `code/yinghua-extension/` | Vanilla JS only. No build step, no transpilers, no third-party dependencies. |
| **Documentation** | Pull request to `README.md`, `code/*/README.md`, this file, or `design/*.md` | Plain Markdown. Keep the bilingual structure (English first, Chinese second). |
| **Design feedback** | GitHub Issues or `design/_exploration/` PR | Reference specific files in `design/_exploration/`. Cite the audit verdict if applicable. |
| **Translation** | PRs to this file, the README, or the design doc | Source of truth is English. Add a new language block in the same style. |
| **Security vulnerability** | **Email** `security@yinghua.app` — see [`SECURITY.md`](SECURITY.md) | Do **not** open a public issue. |

### 2. Development environment

| Tool | Version | Why |
|------|---------|-----|
| **macOS** | 26 (Tahoe) or later | The macOS app targets the macOS 26 SDK. Older macOS will fail to build. |
| **Xcode** | 26.0 or later | Swift 6, SwiftUI 6, AppKit interop, SpeechAnalyzer. |
| **Swift** | 6.0+ | Matches the `SWIFT_VERSION` in `code/Yinghua/project.yml`. |
| **xcodegen** | latest | `brew install xcodegen`. Source of truth for `Yinghua.xcodeproj` is `project.yml`; regenerate after every project change. |
| **Git** | 2.39+ | For `git worktree` workflows. |
| **Chrome / Chromium** | current stable | For extension development. Edge, Brave, and Arc are also valid. |
| **Node.js** | *not required* | The Chrome extension is vanilla JS with zero build step. |
| **Python / other** | *not required* | The macOS app has zero runtime dependencies. |
| **SwiftLint** | *optional but recommended* | See *Code style* below. |

If you only edit the Chrome extension, you do not need Xcode.

### 3. Repository layout

```
.
├── code/
│   ├── Yinghua/              ← macOS app (Swift 6, SwiftUI 6, AppKit interop)
│   │   ├── project.yml       ← xcodegen source. EDIT THIS, not the .xcodeproj.
│   │   ├── Yinghua.xcodeproj/← generated. Do not commit manual changes.
│   │   └── Yinghua/
│   │       ├── Models/
│   │       ├── Audio/
│   │       ├── Transcription/
│   │       ├── API/
│   │       ├── Permissions/
│   │       ├── Components/
│   │       └── Views/
│   ├── Yinghua-ios/          ← iOS app (in development)
│   └── yinghua-extension/    ← Chrome MV3 extension
│       ├── manifest.json     ← MV3 manifest
│       ├── background.js     ← service worker
│       ├── content.js        ← in-page bubble
│       ├── offscreen.html    ← hidden document
│       ├── offscreen.js      ← MediaRecorder
│       ├── popup.html/.js/.css
│       └── icons/
└── design/                   ← visual language source of truth
    ├── design-doc.md         ← prose
    ├── design-tokens.json    ← W3C DTCG
    └── _exploration/         ← audits, brand kits, shippable packs
```

### 4. Build & test

#### macOS app

```bash
# 1. Clone
git clone https://github.com/yinghua-inc/yinghua.git
cd yinghua/code/Yinghua

# 2. Generate the Xcode project (after every project.yml change)
xcodegen generate

# 3. Build
xcodebuild -project Yinghua.xcodeproj \
           -scheme Yinghua \
           -configuration Debug \
           -destination 'platform=macOS' \
           build

# 4. Run tests
xcodebuild test \
  -project Yinghua.xcodeproj \
  -scheme Yinghua \
  -destination 'platform=macOS'

# 5. Open in Xcode for interactive work
open Yinghua.xcodeproj
```

Notes:

- **Never** hand-edit `Yinghua.xcodeproj/project.pbxproj` — your changes will
  be overwritten by the next `xcodegen generate`.
- Audio capture and screen recording require a real Mac with a microphone and
  the relevant macOS permission grants. CI does not exercise them.
- Build setting `ENABLE_HARDENED_RUNTIME = YES` is mandatory.

#### Chrome extension

There is no build step. Edit a file, save, click *Reload* on
`chrome://extensions/`, and re-test.

```bash
# Sanity-check the manifest
python3 -c "import json,sys; json.load(open('code/yinghua-extension/manifest.json'))"

# Open the extension popup in isolation
open "chrome-extension://<extension-id>/popup.html"
```

#### iOS app

TBD — see `code/Yinghua-ios/` once the scaffold lands.

### 5. Pull request workflow

1. **Open an issue first** for non-trivial changes. We use the *Bug report*
   or *Feature request* template. Maintainers will confirm scope before you
   spend hours on a PR that gets rejected for direction.
2. **Fork** the repository, then create a branch:
   ```bash
   git checkout -b fix/issue-123-empty-state-crash
   git checkout -b feat/transcript-export-md
   git checkout -b docs/clarify-byok-storage
   ```
   Use one of these prefixes: `fix/`, `feat/`, `chore/`, `docs/`, `refactor/`,
   `test/`, `design/`, `i18n/`.
3. **Make focused commits**. One logical change per commit. Avoid drive-by
   refactors.
4. **Write tests** for any new behavior (see *Testing requirements* below).
5. **Run the full build + test suite** locally before pushing.
6. **Push** and open a pull request. Fill in the PR template completely —
   link the issue, describe the change, list test coverage, and attach
   before/after screenshots for visual changes.
7. **Wait for review**. A maintainer will respond within **5 business days**.
   Reviews may request changes; this is normal, not a rejection.
8. **Squash and merge** is the default merge strategy. The PR title becomes
   the commit message; keep it under 72 characters and in the imperative
   mood ("Fix …", "Add …", "Refactor …").

### 6. Commit message conventions

We follow [Conventional Commits](https://www.conventionalcommits.org/) 1.0.0.

```
<type>(<scope>): <short summary>

<body — wrap at 72 characters>

<footer — issue references, breaking change notes>
```

| Type | When |
|------|------|
| `feat` | New user-visible behavior |
| `fix` | Bug fix |
| `refactor` | Code change that neither fixes a bug nor adds a feature |
| `perf` | Performance improvement |
| `test` | Adding or correcting tests |
| `docs` | Documentation only |
| `chore` | Build, tooling, dependency changes |
| `design` | Design system changes (token, component, asset) |
| `i18n` | Translation or localization |
| `revert` | Reverts a prior commit |

Scope examples: `macos/app`, `macos/audio`, `macos/transcription`,
`macos/summary`, `extension/manifest`, `extension/content`, `extension/popup`,
`design/tokens`, `docs/readme`.

Breaking changes must include a `!` after the type/scope and a `BREAKING
CHANGE:` footer paragraph.

Examples:

```
feat(macos/transcription): add continuous Chinese-English code-switching

Uses DictationTranscriber in multi-locale mode. Falls back to the
previous single-locale transcription if the user has not granted
Speech framework access to multiple locales.

Closes #142
```

```
fix(extension/content): sanitize meeting URL before injection

The Zoom/Meet/Teams URL was previously inserted into the bubble DOM
unsanitized. While the host pages restrict script execution in this
region, defense-in-depth requires the same input hygiene everywhere
we touch innerHTML.

Reviewed by @maintainer.
```

### 7. Code style

#### Swift (macOS / iOS apps)

- **SwiftLint** is the source of truth. A `.swiftlint.yml` ships at the repo
  root. The configuration is intentionally minimal: opt-in rules for `force_*`
  and `file_length`, plus the default Swift 6 concurrency rules.
  Install: `brew install swiftlint`. Run: `swiftlint` from any `code/*/`
  directory.
- **4-space indentation**, no tabs.
- **Line length**: 120 characters soft, 140 hard (enforced by SwiftLint
  `line_length`).
- **Naming**: `UpperCamelCase` for types, `lowerCamelCase` for everything
  else. Acronyms are uppercased (`URLSession`, not `UrlSession`).
- **Concurrency**: prefer `async`/`await` and `AsyncStream` over callbacks
  and `Combine` for new code. macOS 14+ `@Observable` is preferred over
  `ObservableObject` + `@Published`.
- **Documentation comments**: every public type and every non-trivial
  function gets a `///` doc comment. Use `// MARK: -` to group
  related methods inside a type.
- **Token access**: never hardcode a hex color or spacing value. Use
  `Models/DesignTokens.swift` (`Tokens.Color.brandPurpleVivid`, etc.).
  Visual literals belong in `design/design-tokens.json`, not in source.
- **`prefers-reduced-motion`** must be honored for every animation. Use
  `@Environment(\.accessibilityReduceMotion)`.

#### JavaScript (Chrome extension)

- **Plain ES2022+** — no TypeScript, no transpilers, no bundlers.
- **2-space indentation**.
- **`const` over `let`**. Never use `var`.
- **No external dependencies**. The extension is fully self-contained.
- **No `fetch`, `XMLHttpRequest`, `WebSocket`, `eval`, `new Function`,
  `document.write`**, or remote `<img src=…>`. See
  `code/yinghua-extension/_audit-security.md` for the rationale and how to
  keep it that way.
- **`innerHTML`** is permitted only for static templates; never interpolate
  user input or remote data.
- **Logging** is restricted to two `console.*` calls inside error handlers
  (`offscreen.js:126`, `offscreen.js:146`). Do not add more without
  re-running the security audit.

#### Markdown

- One sentence per line. Wrap prose at ~80 columns in the source.
- Reference code with the `path:line` format so it becomes a clickable
  link in GitHub.
- Bilingual sections: **English first, Chinese second**, separated by a
  horizontal rule and a level-2 heading. Do not interleave the two
  languages within a paragraph.

### 8. Testing requirements

Every pull request that changes behavior must include tests.

| Component | Test framework | Required coverage |
|-----------|----------------|-------------------|
| macOS app | XCTest | New `Models/`, `API/`, `Transcription/`, `Audio/` logic must have unit tests. New `Views/` should have a snapshot test if non-trivial. |
| iOS app | XCTest | Same conventions as macOS. |
| Chrome extension | Manual + audit re-run | Run the security audit checklist against your change. The audit lives at `code/yinghua-extension/_audit-security.md`; re-run the static-analysis grep commands and update the count if your diff introduces new `innerHTML`, `console.*`, or URL strings. |

A PR without tests will be asked to add them before merge, except for
purely-cosmetic changes (whitespace, comment fixes, doc typos) that
explicitly say so in the PR body.

### 9. Internationalization

Yinghua is **Chinese-first** in the product UI and **English-first** in
developer-facing materials (READMEs, doc comments, commit messages).

- **App strings** are extracted by `SWIFT_EMIT_LOC_STRINGS = YES`. New
  user-visible strings must be added to `Localizable.strings` (zh-Hans is
  the development language; en is the secondary locale).
- **Markdown docs** in this repository follow the order: English, then
  Simplified Chinese, then other locales as they land.
- **Token names** in `design/design-tokens.json` are English-only.
- **Commit messages and PR titles** are English. The body may be bilingual
  if a non-trivial change needs additional Chinese context.

### 10. What we will *not* accept

- **AI-generated code dumps** without the contributor having read and
  understood every line. If you used an LLM, you must still be able to
  answer questions about the diff in review.
- **Telemetry, analytics, or crash-reporting SDKs**. The macOS binary must
  remain free of third-party dependencies.
- **Network calls in the Chrome extension**. The extension's zero-network
  property is a hard contract, not a guideline.
- **Hardcoded API keys, tokens, or endpoints** in any committed file.
  Personal API keys have leaked into open-source repos too many times.
- **Marketing copy in the codebase.** No "AI-driven", "intelligent",
  "revolutionary", "empowering" language in user-facing strings or README
  prose. See `design/design-tokens.json` → `forbidden-patterns` for the
  full list and `design/_exploration/C27_brand-guidelines/` §1.3 for the
  rationale.
- **Dependencies that don't pass our threat model.** If you want to add a
  new Swift package, propose it as an issue first with a justification
  and a supply-chain story.

### 11. Questions?

Open a GitHub Discussion (preferred for open-ended questions) or email
`contributors@yinghua.app`. For security issues, see
[`SECURITY.md`](SECURITY.md).

---

<a id="简体中文"></a>

## 简体中文

感谢你考虑为映话（Yìnghuà）做贡献。本文档涵盖提交高质量 PR 所需的全部内容：
开发环境、仓库结构、构建与测试命令、commit 风格、PR 流程。

参与本项目即表示你同意遵守我们的 [Code of Conduct](CODE_OF_CONDUCT.md)
（Contributor Covenant 2.1）。

### 1. 你能贡献什么

| 类型 | 投递位置 | 方式 |
|------|----------|------|
| **Bug 报告** | GitHub Issues | 用 *Bug report* 模板。包含 OS 版本、app 版本、复现步骤、期望 vs 实际行为。截图和录屏欢迎。 |
| **功能请求** | GitHub Issues | 用 *Feature request* 模板。先描述用户痛点；实现细节其次。 |
| **代码（macOS app）** | PR 到 `code/Yinghua/` | 遵循下面的流程。 |
| **代码（iOS app）** | PR 到 `code/Yinghua-ios/` | 同上，scope 较小。 |
| **代码（Chrome 扩展）** | PR 到 `code/yinghua-extension/` | 纯 vanilla JS，无构建步骤，无第三方依赖。 |
| **文档** | PR 到 `README.md`、`code/*/README.md`、本文件或 `design/*.md` | 纯 Markdown，保持双语结构（英文优先，中文其次）。 |
| **设计反馈** | GitHub Issues 或 `design/_exploration/` PR | 引用 `design/_exploration/` 里的具体文件。如适用，引用 audit 结论。 |
| **翻译** | 本文件 / README / design doc 的 PR | 英文是真相源，添加新语言块。 |
| **安全漏洞** | **邮件** `security@yinghua.app` — 见 [`SECURITY.md`](SECURITY.md) | **不要**开公开 issue。 |

### 2. 开发环境

| 工具 | 版本 | 原因 |
|------|------|------|
| **macOS** | 26 (Tahoe) 或更高 | macOS app 目标 SDK 是 macOS 26 |
| **Xcode** | 26.0 或更高 | Swift 6、SwiftUI 6、AppKit、SpeechAnalyzer |
| **Swift** | 6.0+ | 对应 `code/Yinghua/project.yml` 里的 `SWIFT_VERSION` |
| **xcodegen** | latest | `brew install xcodegen` · `Yinghua.xcodeproj` 的真相源是 `project.yml` |
| **Git** | 2.39+ | 支持 `git worktree` |
| **Chrome / Chromium** | 当前 stable | 扩展开发用 |
| **Node.js** | *不需要* | 扩展是纯 vanilla JS |
| **Python** | *不需要* | macOS app 零运行时依赖 |
| **SwiftLint** | *可选但推荐* | 见下方 *Code style* |

只改 Chrome 扩展的话不需要 Xcode。

### 3. 仓库结构

```
.
├── code/
│   ├── Yinghua/              ← macOS app（Swift 6 · SwiftUI 6 · AppKit 互操作）
│   │   ├── project.yml       ← xcodegen 源 · 改这个，不是 .xcodeproj
│   │   ├── Yinghua.xcodeproj/← 生成产物 · 不要手改后提交
│   │   └── Yinghua/
│   │       ├── Models/
│   │       ├── Audio/
│   │       ├── Transcription/
│   │       ├── API/
│   │       ├── Permissions/
│   │       ├── Components/
│   │       └── Views/
│   ├── Yinghua-ios/          ← iOS app（开发中）
│   └── yinghua-extension/    ← Chrome MV3 扩展
│       ├── manifest.json
│       ├── background.js
│       ├── content.js
│       ├── offscreen.html
│       ├── offscreen.js
│       ├── popup.html/.js/.css
│       └── icons/
└── design/                   ← 视觉语言真相源
    ├── design-doc.md         ← prose
    ├── design-tokens.json    ← W8C DTCG
    └── _exploration/         ← audit · 品牌 kit · shippable pack
```

### 4. 构建与测试

#### macOS app

```bash
# 1. 克隆
git clone https://github.com/yinghua-inc/yinghua.git
cd yinghua/code/Yinghua

# 2. 生成 Xcode 项目（每次改 project.yml 都要重新生成）
xcodegen generate

# 3. 构建
xcodebuild -project Yinghua.xcodeproj \
           -scheme Yinghua \
           -configuration Debug \
           -destination 'platform=macOS' \
           build

# 4. 跑测试
xcodebuild test \
  -project Yinghua.xcodeproj \
  -scheme Yinghua \
  -destination 'platform=macOS'

# 5. 在 Xcode 中打开
open Yinghua.xcodeproj
```

注意：

- **永远不要**手改 `Yinghua.xcodeproj/project.pbxproj` — 下次 `xcodegen generate` 会被覆盖。
- 音频录制和屏幕录制需要真实 Mac + 麦克风 + 相应 macOS 权限。CI 不跑这两类。
- `ENABLE_HARDENED_RUNTIME = YES` 是强制的。

#### Chrome 扩展

没有构建步骤。改一个文件，保存，在 `chrome://extensions/` 上点 *Reload*，重新测。

```bash
# 校验 manifest JSON
python3 -c "import json,sys; json.load(open('code/yinghua-extension/manifest.json'))"
```

#### iOS app

待定 — 等 `code/Yinghua-ios/` scaffold 落地。

### 5. PR 流程

1. **先开 issue** 讨论非 trivial 改动。维护者会确认 scope，避免你花几小时写的 PR 因为方向被拒。
2. **Fork** 仓库后建分支：
   ```bash
   git checkout -b fix/issue-123-empty-state-crash
   git checkout -b feat/transcript-export-md
   git checkout -b docs/clarify-byok-storage
   ```
   用 `fix/`、`feat/`、`chore/`、`docs/`、`refactor/`、`test/`、`design/`、`i18n/` 前缀。
3. **聚焦的 commit**。一次逻辑变更一个 commit，避免顺手 refactor。
4. **写测试**（见下方 *测试要求*）。
5. **本地跑全量 build + test** 再 push。
6. **Push** 后开 PR。完整填写 PR 模板：关联 issue、描述改动、列出测试覆盖、附 before/after 截图（视觉改动）。
7. **等 review**。维护者 **5 个工作日内**回复。Review 可能要求改动，这是常态，不是拒绝。
8. **Squash and merge** 是默认策略。PR 标题就是 commit 消息，保持 72 字符以内、祈使语气（"Fix …"、"Add …"、"Refactor …"）。

### 6. Commit 约定

我们用 [Conventional Commits](https://www.conventionalcommits.org/) 1.0.0。

```
<type>(<scope>): <short summary>

<body — 72 字符换行>

<footer — issue 引用、breaking change 说明>
```

Type 见英文版表格。Scope 例：`macos/app`、`macos/audio`、`macos/transcription`、
`macos/summary`、`extension/manifest`、`extension/content`、`extension/popup`、
`design/tokens`、`docs/readme`。

Breaking change 在 type/scope 后加 `!`，并在 footer 写 `BREAKING CHANGE:` 段。

### 7. Code style

#### Swift（macOS / iOS app）

- **SwiftLint** 是真相源。仓库根有 `.swiftlint.yml`，配置刻意精简：只 opt-in
  `force_*` 和 `file_length`，加 Swift 6 并发的默认规则。
  安装：`brew install swiftlint`。运行：在 `code/*/` 任一目录里跑 `swiftlint`。
- **4 空格缩进**，不用 tab。
- **行长**：120 字符软上限，140 硬上限（SwiftLint `line_length` 强制）。
- **命名**：`UpperCamelCase` 用于类型，其他一律 `lowerCamelCase`。缩写大写
  （`URLSession` 不是 `UrlSession`）。
- **并发**：新代码优先 `async`/`await` 和 `AsyncStream`，少用 callback 和
  `Combine`。macOS 14+ 用 `@Observable`，少用 `ObservableObject` + `@Published`。
- **文档注释**：每个 public 类型和非平凡函数都要 `///`。类型内用 `// MARK: -` 分组。
- **Token 访问**：永远不要硬编码 hex 色或间距。用 `Models/DesignTokens.swift`
  （`Tokens.Color.brandPurpleVivid` 等）。视觉字面量属于 `design/design-tokens.json`，
  不属于源码。
- **每个动画必须尊重 `prefers-reduced-motion`**。用 `@Environment(\.accessibilityReduceMotion)`。

#### JavaScript（Chrome 扩展）

- **纯 ES2022+** — 不用 TypeScript，不用转译器，不用打包器。
- **2 空格缩进**。
- **`const` 优先 `let`**。不用 `var`。
- **零外部依赖**。扩展完全自包含。
- **不用 `fetch`、`XMLHttpRequest`、`WebSocket`、`eval`、`new Function`、
  `document.write`**，也不用远程 `<img src=…>`。理由和保持方式见
  `code/yinghua-extension/_audit-security.md`。
- **`innerHTML`** 只用于静态模板，禁止插入用户输入或远程数据。
- **日志** 限定在 `offscreen.js:126` 和 `offscreen.js:146` 两处错误处理。
  加新位置需要重跑安全审计。

#### Markdown

- 一句一行。源里 ~80 列换行。
- 代码引用用 `path:line` 格式（GitHub 上自动变可点链接）。
- 双语章节：**英文优先，中文其次**，用 `---` 和二级标题隔开。段内不要中英混排。

### 8. 测试要求

每个改行为的 PR 必须带测试。

| 组件 | 测试框架 | 覆盖要求 |
|------|----------|----------|
| macOS app | XCTest | `Models/`、`API/`、`Transcription/`、`Audio/` 新逻辑必须有单测。`Views/` 新增非平凡组件应有 snapshot test。 |
| iOS app | XCTest | 同 macOS。 |
| Chrome 扩展 | 手工 + audit 重跑 | 跑 `code/yinghua-extension/_audit-security.md` 里的静态分析 grep 命令；如果 diff 引入新 `innerHTML`、`console.*` 或 URL 字符串，更新计数。 |

不带测试的 PR 会被要求先加测试再合，**纯样式改动**（空白、注释、文档错字）除外，但要在 PR body 里明确说明。

### 9. 国际化

映话产品 UI **中文优先**，开发者面向材料（README、文档注释、commit 消息）**英文优先**。

- **App 字符串** 由 `SWIFT_EMIT_LOC_STRINGS = YES` 抽取。新可见字符串必须加进
  `Localizable.strings`（开发语言是 zh-Hans，二级 locale 是 en）。
- **Markdown 文档** 顺序：英文 → 简体中文 → 其他 locale（按落地顺序）。
- **Token 名** 只用英文。
- **Commit 消息和 PR 标题** 用英文。Body 需要额外中文上下文时可用双语。

### 10. 我们不会接受的内容

- **AI 生成的代码倾倒**，贡献者没有读懂每一行。用 LLM 可以，但 review 时你得能答出 diff 里任何一行。
- **遥测、分析、崩溃上报 SDK**。macOS 二进制必须保持零第三方依赖。
- **Chrome 扩展里的网络调用**。扩展的零网络属性是硬约束，不是建议。
- **硬编码的 API key、token、endpoint** 出现在提交文件里。
- **代码里的营销词**：禁止 "AI 驱动"、"智能"、"革新"、"赋能" 出现在用户可见字符串或 README prose。完整清单见 `design/design-tokens.json` → `forbidden-patterns`，理由见 `design/_exploration/C27_brand-guidelines/` §1.3。
- **不通过我们威胁模型的新依赖**。要加 Swift package，先提 issue，写清理由和供应链故事。

### 11. 有问题？

开 GitHub Discussion（开放式问题优先）或发邮件 `contributors@yinghua.app`。
安全问题见 [`SECURITY.md`](SECURITY.md)。
