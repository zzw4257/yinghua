# C33 — Code Signing + Notarization Pipeline · 独立审计

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：Apple Developer Documentation (2025) + Xcode 26 + notarytool + Gatekeeper 规范 + project.yml + entitlements

---

## 检查项

### 1. 文件清单

| 期望 | 路径 | 存在？ |
|------|------|--------|
| 主签名 + 公证脚本 | `design/_exploration/C33_code-signing/sign-and-notarize.sh` | ✅（93 行）|
| Makefile 入口 | `design/_exploration/C33_code-signing/Makefile` | ✅（41 行）|
| 首次配置脚本 | `design/_exploration/C33_code-signing/setup-notarytool.sh` | ✅（17 行）|
| xcodegen 项目配置 | `code/Yinghua/project.yml` | ✅（含 signing 配置）|
| Entitlements | `code/Yinghua/Yinghua/Yinghua.entitlements` | ✅（plist 格式）|
| README | `design/_exploration/C33_code-signing/README.md` | ✅ |

### 2. sign-and-notarize.sh 流水线完整性

按 Apple 推荐的 7 步流水线逐项核验：

| 步骤 | 命令 | 实现情况 | 通过？ |
|------|------|----------|--------|
| 0 | 前置检查（`DEVELOPMENT_TEAM_ID` 必填）| `set -euo pipefail` + 显式 echo 错误 + exit 1 | ✅ |
| 1 | 环境检查（xcodebuild / notarytool 版本）| `xcodebuild -version` + `xcrun notarytool --version` | ✅ |
| 2 | xcodegen 生成 `.xcodeproj` | `xcodegen generate` | ✅ |
| 3 | 清理 | `xcodebuild ... clean` | ✅ |
| 4 | Archive | `xcodebuild ... archive` 含 `DEVELOPMENT_TEAM` + `CODE_SIGN_STYLE=Automatic` + `CODE_SIGN_IDENTITY="Apple Distribution"` | ✅ |
| 5 | 导出 `.pkg` | `xcodebuild -exportArchive` + 动态生成 `exportOptionsPlist`（method=app-store, uploadSymbols=true）| ✅ |
| 6 | Notarize | `ditto -c -k ...` 打 zip + `xcrun notarytool submit --keychain-profile ... --wait` | ✅ |
| 7 | Staple | `xcrun stapler staple` + `xcrun stapler validate` | ✅ |
| 8 | 验证 | `codesign -dvv` + `spctl -a -vv` | ✅ |

**与 Apple 官方推荐流水线对齐度**：完全对齐（8 步骤全覆盖）

### 3. Makefile 自定位（任何 cwd 可跑）

- `MAKEFILE_DIR := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))` ✅
- `PROJECT_ROOT := $(abspath $(MAKEFILE_DIR)/../../..)` ✅
- `make release DEVELOPER_TEAM_ID=ABC123XYZ` 入口清晰
- 5 个 target：`build` / `test` / `archive` / `notarize` / `release` / `clean`
- ✅ 跨目录可执行

### 4. project.yml 签名配置

| 配置项 | 值 | 评价 |
|--------|----|------|
| `CODE_SIGN_STYLE` | `Automatic` | ✅ Apple 推荐 |
| `CODE_SIGN_IDENTITY` | `Apple Development`（dev）/ `Apple Distribution`（release · 脚本中）| ✅ 双环境区分 |
| `DEVELOPMENT_TEAM` | `${DEVELOPMENT_TEAM_ID}` 环境变量 | ✅ 安全（不入 Git）|
| `ENABLE_HARDENED_RUNTIME` | `YES` | ✅ App Store 强制 |
| `OTHER_CODE_SIGN_FLAGS` | `"--deep"` | ⚠️ Apple 已弃用 `--deep`（Xcode 14+），但 `--deep` 仍是合法 flag，effect 已被自动处理；**不阻塞但非最佳** |
| `SWIFT_TREAT_WARNINGS_AS_ERRORS` | `NO` | ⚠️ 与 `ENABLE_USER_SCRIPT_SANDBOXING: YES` 同时开启；不阻塞 |
| Bundle ID | `app.yinghua.Yinghua` | ✅ 与 C31 实际代码一致 |

### 5. entitlements 完整性

`Yinghua.entitlements` 8 项沙箱声明：

| Key | 值 | 用途 | 通过？ |
|-----|----|------|--------|
| `com.apple.security.app-sandbox` | true | App Store 强制 | ✅ |
| `com.apple.security.device.audio-input` | true | AVAudioEngine 必需 | ✅ |
| `com.apple.security.device.microphone` | true | 麦克风权限对应 | ✅ |
| `com.apple.security.network.client` | true | BYOK HTTPS 出口 | ✅ |
| `com.apple.security.network.server` | false | 显式拒绝监听 | ✅（defense in depth）|
| `com.apple.security.files.user-selected.read-write` | true | 用户选择文件导出 | ✅ |
| `com.apple.security.files.downloads.read-write` | true | 导出到 Downloads | ✅ |
| `com.apple.security.print` | false | 显式拒绝打印 | ✅ |

**与项目需求对齐**：
- ScreenCaptureKit（系统音频）需要 `com.apple.security.device.audio-input` ✅
- BYOK 需 `com.apple.security.network.client` ✅
- 无网络监听（不收集数据承诺）✅
- 无摄像头 / 蓝牙 / 通讯录 / 位置（与 C31 §7.6 一致）✅

### 6. Hardened Runtime

- `ENABLE_HARDENED_RUNTIME: YES` ✅
- 配合 entitlements，沙箱 + Hardened Runtime 双重保护
- 与 C31 §3.3 "App Sandbox + Hardened Runtime 双重保护" 承诺一致

### 7. notarytool Keychain Profile

- `setup-notarytool.sh` 用 `xcrun notarytool store-credentials` 把 Apple ID + Team ID + App-specific password 存到 keychain
- profile 名 `yinghua-notarytool` 与主脚本 `NOTARYTOOL_PROFILE="yinghua-notarytool"` 一致
- 密码输入用 `read -s`（不回显）
- ✅ 凭证安全 + 避免每次输入

### 8. 故障排查表

README 列出 4 个常见错误 + 原因 + 修法：
- `No signing identity found` → Xcode 登录
- `Profile doesn't include signing certificate` → 创建 Distribution cert
- `notarytool submit failed: Authentication failed` → 重跑 setup
- `stapler validate failed` → 等几分钟重跑

✅ 实用

### 9. Bundle ID 一致性

- project.yml: `app.yinghua.Yinghua` ✅
- sign-and-notarize.sh: `BUNDLE_ID="app.yinghua.Yinghua"` ✅
- C30 metadata: `com.yinghua.zzw4257.cn` ❌ 不一致（C30 audit 已标记）
- C31 privacy: `app.yinghua.Yinghua`（§1 真实版 / §1.3 隐含）
- C33 自身 100% 内部一致

### 10. Xcode 26 / macOS 26 兼容性

- `MACOSX_DEPLOYMENT_TARGET: "26.0"` ✅
- `deploymentTarget.macOS: "26.0"` ✅
- `LSMinimumSystemVersion: "26.0"` Info.plist
- Xcode 26 命令行工具（`xcodebuild` / `xcrun notarytool`）
- ✅ Apple 2025 stack

---

## 风险与发现

| 严重度 | 项 | 说明 |
|--------|----|------|
| LOW | `--deep` 已弃用 | Apple 自 Xcode 14 起不再需要 `--deep`（automatic 模式自动 nested 签名）；不阻塞但应在 Xcode 26 中移除 |
| LOW | `SWIFT_TREAT_WARNINGS_AS_ERRORS: NO` | 跟 sandboxing YES 配合不冲突，但是 Swift 6 严格并发下 warnings 会很多；建议 release 阶段改 YES |
| LOW | notarize 失败未做重试 | `xcrun notarytool submit --wait` 后若失败只 echo 失败但未 retry；Apple 公证偶发 5xx 时需手动重跑 |
| LOW | C30 bundle ID 不一致 | C30 写 `com.yinghua.zzw4257.cn`，实际是 `app.yinghua.Yinghua`；C33 签名 + 隐私政策一致，C30 是 out-of-sync |
| LOW | 测试覆盖 | `make test` target 存在但未在 audit 范围（需要跑 XCTest 验证） |

---

## 总结

- **VERDICT**: **PASS**
- 关键发现：
  - 完整 8 步骤签名 + 公证流水线（与 Apple 官方推荐 1:1 对齐）
  - Makefile 自定位、5 target 入口清晰
  - project.yml + entitlements 完整覆盖 App Store 沙箱要求
  - Hardened Runtime 启用
  - notarytool keychain profile 安全存储
  - 故障排查表实用
- 建议：
  1. 移除 `--deep`（已弃用）
  2. Release 阶段开 `SWIFT_TREAT_WARNINGS_AS_ERRORS: YES`
  3. notarytool 失败加重试逻辑
  4. 同步 C30 bundle ID（已在 C30 audit 标记）

## 等级

- **PASS**：可用
- 满足任务要求全部 4 项（sign-and-notarize.sh · Makefile · project.yml · entitlements 全部 shippable，零阻塞）
