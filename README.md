# 映话 · Yinghua

[![Build & Test](https://github.com/yinghua-inc/yinghua/workflows/Build%20%26%20Test/badge.svg)](https://github.com/yinghua-inc/yinghua/actions/workflows/build.yml)
[![Release](https://github.com/yinghua-inc/yinghua/workflows/Release/badge.svg)](https://github.com/yinghua-inc/yinghua/actions/workflows/release.yml)
[![Chrome Extension](https://github.com/yinghua-inc/yinghua/workflows/Chrome%20Extension/badge.svg)](https://github.com/yinghua-inc/yinghua/actions/workflows/extension.yml)

> **A native, local-first meeting & interview assistant for macOS 26+.**
> 录你开的会，转录说话人，让 AI 写总结。**数据留在你的 Mac 上**。BYOK。

[English](#english) · [简体中文](#简体中文) · [繁體中文](#繁體中文) · [日本語](#日本語)

---

<a id="english"></a>

## English

Yinghua (映话) is a native macOS 26+ app that records your system audio and
microphone, transcribes the conversation in real time with speaker separation,
and lets you generate AI summaries (key moments / decisions / action items /
open questions) using your own API key. Everything lives on your Mac.

This repository hosts three deliverables:

| Component | Path | What it is |
|-----------|------|------------|
| **macOS app** | `code/Yinghua/` | SwiftUI 6 + AppKit. macOS 26+. AVAudioEngine + ScreenCaptureKit + SpeechAnalyzer. |
| **iOS app** | `code/Yinghua-ios/` | iOS 26+. Companion capture client (in development). |
| **Chrome extension** | `code/yinghua-extension/` | MV3. Records tab audio from Zoom / Meet / Teams into IndexedDB. Zero network. |
| **Design system** | `design/` | Tokens, components, brand assets, 4 audit verdicts. Single source of truth. |

### Four things this project commits to

1. **Local-first** — your recordings, transcripts, and summaries stay on disk
   under `~/Library/Application Support/Yinghua/`. We do not run a backend.
2. **BYOK** — your API key (OpenAI / Anthropic / custom endpoint) is stored in
   macOS Keychain. Network requests are issued **only** when you click
   *Generate summary*, and only to the endpoint you configured.
3. **No telemetry, no analytics, no crash reporting to us.** The Mac App
   Store–distributed binary has no third-party SDKs.
4. **Open design system.** The visual language (`design/`) is auditable. Brand
   assets, tokens, and the four-shippable-design audit verdicts are public.

### Repository layout

```
.
├── code/
│   ├── Yinghua/              ← macOS app (Swift 6, SwiftUI 6, AppKit interop)
│   ├── Yinghua-ios/          ← iOS app (in development)
│   └── yinghua-extension/    ← Chrome MV3 extension (vanilla JS)
├── design/
│   ├── design-doc.md         ← Visual language prose (v2.0)
│   ├── design-tokens.json    ← W3C DTCG tokens (117)
│   └── _exploration/         ← Audit verdicts, brand kits, shippable packs
├── .github/
│   ├── workflows/            ← CI/CD (build / release / extension)
│   └── SECRETS.md            ← GitHub secrets configuration guide
├── LICENSE                   ← MIT
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md        ← Contributor Covenant 2.1
├── SECURITY.md
└── README.md                 ← this file
```

### CI/CD

| Workflow | Trigger | What it does |
|----------|---------|--------------|
| [**Build & Test**](./.github/workflows/build.yml) | PR + push to `main` | `macos-14` + Xcode 26.6 · xcodegen · xcodebuild Debug / Test / Release · auto-comment on failure |
| [**Release**](./.github/workflows/release.yml) | tag `v*` | `macos-14` · sign + notarize + staple · upload `.dmg` + `.pkg` to GitHub Release (draft) + App Store Connect |
| [**Chrome Extension**](./.github/workflows/extension.yml) | tag `ext-v*` | `ubuntu-latest` · manifest validation · zip · upload to GitHub Release (draft) + optional Chrome Web Store |

See [`.github/SECRETS.md`](./.github/SECRETS.md) for the 4 required secrets (`APPLE_TEAM_ID`, `APPLE_ID`, `APP_SPECIFIC_PASSWORD`, `SLACK_WEBHOOK_URL`) and 4 optional Chrome Web Store secrets.

### Quick start

**macOS app** (requires macOS 26+, Xcode 26+):

```bash
# Install xcodegen if you don't have it
brew install xcodegen

# Generate the Xcode project
cd code/Yinghua
xcodegen generate

# Open in Xcode
open Yinghua.xcodeproj

# …or build from the command line
xcodebuild -project Yinghua.xcodeproj \
           -scheme Yinghua \
           -configuration Debug \
           -destination 'platform=macOS' \
           build
```

**Chrome extension** (developer / unpacked):

1. Open `chrome://extensions/` in Chrome (or any Chromium browser).
2. Enable **Developer mode** (top-right).
3. Click **Load unpacked**, then select `code/yinghua-extension/`.
4. Pin the Y icon to your toolbar.
5. Open a Zoom / Meet / Teams tab — the recording bubble appears top-right.

**iOS app** is in active development. See `code/Yinghua-ios/` and the
`C38_ios-app-scaffold/` exploration for the current state.

### Testing

The macOS app uses XCTest. From `code/Yinghua/`:

```bash
# Run all unit tests
xcodebuild test \
  -project Yinghua.xcodeproj \
  -scheme Yinghua \
  -destination 'platform=macOS'

# Or from Xcode: ⌘U with the Yinghua scheme selected
```

There is no formal test target yet for the Chrome extension — it is exercised
manually across Chrome / Edge / Brave against live Zoom / Meet / Teams pages.
The security audit in
`code/yinghua-extension/_audit-security.md` (45 checkpoints, 0 FAIL, 0
CRITICAL) is the closest thing to a regression suite for v0.1.0.

### Contributing

We welcome bug reports, pull requests, design feedback, and translations.
Before sending a PR, please read:

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — workflow, style, commit conventions
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) — community standards (Contributor Covenant 2.1)
- [`design/design-doc.md`](design/design-doc.md) v2.0 — visual language
- [`design/design-tokens.json`](design/design-tokens.json) — machine-readable
  source of truth for colors, radii, motion, and spacing

Every PR must include tests for new behavior. See *Testing requirements* in
`CONTRIBUTING.md`.

### Security

Found a vulnerability? Please **do not** file a public issue. Email
**security@yinghua.app** (PGP key in
[`SECURITY.md`](SECURITY.md#reporting-a-vulnerability)). We acknowledge
within 24 hours, provide a status update within 7 days, and aim to ship a fix
within 30 days.

### License

[MIT](LICENSE) · Copyright © 2026 Yinghua Inc.

### Acknowledgements

- **Apple** — SwiftUI, AppKit, SpeechAnalyzer, ScreenCaptureKit, AVFoundation.
  The macOS platform is the reason this product exists.
- **Anthropic** and **OpenAI** — BYOK endpoints, with the choice yours.
- **Contributor Covenant** — the basis for our code of conduct.
- **Vladimír Macháček & contributors to [XcodeGen](https://github.com/yonaskolb/XcodeGen)** —
  the project file format that `project.yml` compiles into.

---

<a id="简体中文"></a>

## 简体中文

映话（Yìnghuà）是一款 macOS 26+ 原生应用，录制你的系统音频和麦克风，实时
转录（带说话人分离），并支持用你自己的 API key 生成 AI 总结（关键瞬间 /
决定 / 待办 / 遗留问题）。所有数据保留在你的 Mac 上。

仓库包含四个交付物：

| 组件 | 路径 | 说明 |
|------|------|------|
| **macOS app** | `code/Yinghua/` | SwiftUI 6 + AppKit · macOS 26+ · AVAudioEngine + ScreenCaptureKit + SpeechAnalyzer |
| **iOS app** | `code/Yinghua-ios/` | iOS 26+ · 配套采集客户端（开发中）|
| **Chrome 扩展** | `code/yinghua-extension/` | MV3 · 录制 Zoom / Meet / Teams 标签页音频到 IndexedDB · 零网络 |
| **设计系统** | `design/` | Token、组件、品牌资产、4 份 audit 收口 · 单一真相源 |

### 四个承诺

1. **本地优先**：录音、转录、总结都存在 `~/Library/Application Support/Yinghua/`。我们没有后端。
2. **BYOK**：你的 API key（OpenAI / Anthropic / 自定义 endpoint）存 macOS Keychain。网络请求**仅**在用户主动点击"生成总结"时发出，**且**只发向你配置的 endpoint。
3. **不嵌入任何遥测、分析、崩溃上报 SDK**。Mac App Store 发布的二进制不含第三方 SDK。
4. **设计系统公开**。视觉语言（`design/`）可审计。品牌资产、token、4 份 shippable audit 全部公开。

### 仓库结构

```
.
├── code/
│   ├── Yinghua/              ← macOS app（Swift 6 · SwiftUI 6 · AppKit 互操作）
│   ├── Yinghua-ios/          ← iOS app（开发中）
│   └── yinghua-extension/    ← Chrome MV3 扩展（vanilla JS）
├── design/
│   ├── design-doc.md         ← 视觉语言 prose（v2.0）
│   ├── design-tokens.json    ← W3C DTCG token（117 个）
│   └── _exploration/         ← audit 结论、品牌 kit、shippable pack
├── .github/
│   ├── workflows/            ← CI/CD（build / release / extension）
│   └── SECRETS.md            ← GitHub secrets 配置指南
├── LICENSE                   ← MIT
├── CONTRIBUTING.md
├── CODE_OF_CONDUCT.md        ← Contributor Covenant 2.1
├── SECURITY.md
└── README.md                 ← 本文件
```

### CI/CD

| Workflow | 触发 | 干什么 |
|----------|------|--------|
| [**Build & Test**](./.github/workflows/build.yml) | PR + push 到 `main` | `macos-14` + Xcode 26.6 · xcodegen · xcodebuild Debug / Test / Release · 失败自动 comment PR |
| [**Release**](./.github/workflows/release.yml) | tag `v*` | `macos-14` · 签名 + notarize + staple · 上传 `.dmg` + `.pkg` 到 GitHub Release（draft）+ App Store Connect |
| [**Chrome Extension**](./.github/workflows/extension.yml) | tag `ext-v*` | `ubuntu-latest` · manifest 校验 · zip · 上传到 GitHub Release（draft）+ 可选 Chrome Web Store |

4 个必配 secret + 4 个可选 Chrome Web Store secret 配置见 [`.github/SECRETS.md`](./.github/SECRETS.md)。

### 快速开始

**macOS app**（需要 macOS 26+ 和 Xcode 26+）：

```bash
# 如未安装 xcodegen
brew install xcodegen

# 生成 Xcode 项目
cd code/Yinghua
xcodegen generate

# 在 Xcode 中打开
open Yinghua.xcodeproj

# …或命令行构建
xcodebuild -project Yinghua.xcodeproj \
           -scheme Yinghua \
           -configuration Debug \
           -destination 'platform=macOS' \
           build
```

**Chrome 扩展**（开发者 / unpacked）：

1. 打开 `chrome://extensions/`
2. 启用右上角 **Developer mode**
3. 点击 **Load unpacked**，选择 `code/yinghua-extension/`
4. 把 Y 图标固定到工具栏
5. 打开 Zoom / Meet / Teams 标签页 — 录制气泡出现在右上角

**iOS app** 正在开发。详见 `code/Yinghua-ios/` 和 `design/_exploration/C38_ios-app-scaffold/`。

### 测试

macOS app 使用 XCTest。在 `code/Yinghua/` 下：

```bash
# 跑全部单测
xcodebuild test \
  -project Yinghua.xcodeproj \
  -scheme Yinghua \
  -destination 'platform=macOS'

# 或在 Xcode 中：选中 Yinghua scheme，按 ⌘U
```

Chrome 扩展目前没有正式测试 target — 通过在 Chrome / Edge / Brave 上对真实
Zoom / Meet / Teams 页面做手工测试。`code/yinghua-extension/_audit-security.md`
（45 检查点 · 0 FAIL · 0 CRITICAL）是 v0.1.0 最接近回归测试套件的东西。

### 发版

**macOS app**（打 `v*` tag）：

```bash
# 1. 改 code/Yinghua/project.yml 里的 CFBundleShortVersionString / CFBundleVersion
# 2. commit + push
git commit -am "chore: bump version to 0.2.0"
git push origin main
# 3. 打 tag 触发 release workflow
git tag v0.2.0
git push origin v0.2.0
# 4. 去 GitHub Actions 看 build → 完成后在 Releases 里 publish draft
```

**Chrome 扩展**（打 `ext-v*` tag）：

```bash
# 1. 改 code/yinghua-extension/manifest.json 里的 version
# 2. commit + push
git commit -am "chore: bump extension to 0.1.1"
git push origin main
# 3. 打 tag 触发 extension workflow
git tag ext-v0.1.1
git push origin ext-v0.1.1
# 4. GitHub Actions → Release draft → publish
#    或自动 → Chrome Web Store（需配 4 个 CWS secret）
```

### 贡献

欢迎 bug 报告、PR、设计反馈、翻译。提交 PR 之前请读：

- [`CONTRIBUTING.md`](CONTRIBUTING.md) — 流程、风格、commit 约定
- [`CODE_OF_CONDUCT.md`](CODE_OF_CONDUCT.md) — 社区规范（Contributor Covenant 2.1）
- [`design/design-doc.md`](design/design-doc.md) v2.0 — 视觉语言
- [`design/design-tokens.json`](design/design-tokens.json) — 机器可读真相源

每个 PR 必须为新行为附带测试。详见 `CONTRIBUTING.md` *Testing requirements* 一节。

### 安全

发现漏洞？**请勿**提交公开 issue。请发邮件到 **security@yinghua.app**（PGP
公钥见 [`SECURITY.md`](SECURITY.md#reporting-a-vulnerability)）。我们承诺：
24 小时内确认 · 7 天内给状态更新 · 30 天内发布修复。

### 许可证

[MIT](LICENSE) · Copyright © 2026 Yinghua Inc.

### 致谢

- **Apple** — SwiftUI、AppKit、SpeechAnalyzer、ScreenCaptureKit、AVFoundation。macOS 平台是这款产品存在的原因。
- **Anthropic** 与 **OpenAI** — BYOK endpoint，选择权在你。
- **Contributor Covenant** — 我们的社区规范基础。
- **Vladimír Macháček 及 [XcodeGen](https://github.com/yonaskolb/XcodeGen) 贡献者** — 让 `project.yml` 编译成 xcodeproj 的项目文件格式。

---

<a id="繁體中文"></a>

## 繁體中文

映話（Yìnghuà）是一款 macOS 26+ 原生應用，錄製你的系統音訊與麥克風，即時
轉錄（含說話人分離），並可使用你自己的 API key 產生 AI 摘要（關鍵瞬間 /
決策 / 待辦 / 遺留問題）。所有資料皆保留在你的 Mac 上。

| 元件 | 路徑 | 說明 |
|------|------|------|
| **macOS app** | `code/Yinghua/` | SwiftUI 6 + AppKit · macOS 26+ |
| **iOS app** | `code/Yinghua-ios/` | iOS 26+ · 配套擷取用戶端（開發中）|
| **Chrome 擴充功能** | `code/yinghua-extension/` | MV3 · 將 Zoom / Meet / Teams 標籤頁音訊錄進 IndexedDB · 零網路 |
| **設計系統** | `design/` | 設計 token、元件、品牌資產、四份 audit |

請參閱「English」一節的建置與測試指令，與簡體中文版的差異僅在用語。

---

<a id="日本語"></a>

## 日本語

映話（Yìnghuà / Yinghua）は macOS 26+ ネイティブのアプリで、システム
オーディオとマイクを録音し、話者分離付きのリアルタイム文字起こしを行い、
あなたの API キー（BYOK）で AI 要約を生成します。すべてのデータはお使いの
Mac 内に保持されます。

| コンポーネント | パス | 概要 |
|----------------|------|------|
| **macOS アプリ** | `code/Yinghua/` | SwiftUI 6 + AppKit · macOS 26+ |
| **iOS アプリ** | `code/Yinghua-ios/` | iOS 26+ · 補完クライアント（開発中）|
| **Chrome 拡張機能** | `code/yinghua-extension/` | MV3 · Zoom / Meet / Teams のタブ音声を IndexedDB に保存 · ネットワーク送信なし |
| **デザインシステム** | `design/` | デザイントークン、コンポーネント、ブランド資産、4 件の監査 |

ビルド手順とテスト手順は「English」を参照してください（コマンドは同じです）。
