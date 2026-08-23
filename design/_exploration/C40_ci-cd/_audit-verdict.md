# C40 — CI/CD 独立审计
**审计人**：verifier
**日期**：2026-08-23
**审计依据**：D1 + prior audits (C20-security, C20-business-logic, extension-security)

## 检查项

### 1. .github/workflows/build.yml（4 jobs）
- **build-debug** (line 21-72): macos-14 · Xcode 26.6 · xcodegen + xcodebuild Debug · artifact upload (Yinghua-Debug) ✓
- **test** (line 80-124): depends on build-debug · xcodebuild test · `continue-on-error: true` 显式声明当前无 XCTest target · 输出 warning 不 fail（透明） ✓
- **build-release** (line 130-168): `clean build` 跑 Release 配置（编译器优化路径暴露 Debug 看不到的问题，逻辑合理） ✓
- **pr-comment** (line 175-211): 仅 PR + failure 触发 · 用 marocchino/sticky-pull-request-comment@v2 自动在 PR comment · 列三 job 状态 · 常见原因解释 ✓
- **触发**：pull_request + push to main ✓
- **concurrency**：build-${{ workflow }}-${{ ref }} + cancel-in-progress: true（节省 CI 资源） ✓
- **timeout-minutes**: 30/job · 5min for pr-comment ✓

### 2. .github/workflows/release.yml（1 job）
- **release** job (line 19-204): tag push v* · macos-14 · 60 min timeout ✓
- **env 块** (line 31-38): 把 secrets 提升到 env，省去每行 ${{ secrets.* }} ✓
- **Validate secrets** (line 63-77): 三 required secret 缺失即 ::error 退出 ✓
- **Store notarytool credentials** (line 79-86): 注释解释 runner 一次性 VM，profile 不泄漏 ✓
- **Build + Sign + Notarize** (line 88-95): 委托给 `design/_exploration/C33_code-signing/sign-and-notarize.sh`（已确认存在） ✓
- **Verify signature & notarization** (line 97-106): codesign + spctl + stapler 三重 verify ✓
- **Create .dmg** (line 108-118): UDZO 压缩格式 ✓
- **Notify maintainers** (line 146-156): `if: failure()` + `continue-on-error: true` 不阻塞 release ✓
- **Create GitHub Release (draft)** (line 158-204): softprops/action-gh-release@v2 + draft + generate_release_notes + DMG + .pkg ✓
- **altool deprecation 注释** (line 131): 显式标注 MVP 阶段可用，未来切到 notarytool + transporter ✓
- **ext-v tag prefix** (line 5-8 in extension.yml): 与 v* 主 app 区分（良好工程实践） ✓

### 3. .github/workflows/extension.yml（2 jobs）
- **package** (line 20-190): ubuntu-latest · 15 min timeout ✓
  - **Validate manifest.json** (line 43-60): Python 强制检查 manifest_version==3 + semver + 必填字段 ✓
  - **Validate JavaScript syntax** (line 62-73): `node --check` 4 个 JS 文件（background/content/offscreen/popup）—— 4 个文件均已确认存在 ✓
  - **Verify all referenced files exist** (line 75-107): 检查 service_worker + content_scripts + popup + icons 引用路径 —— 防止 manifest 引用幽灵文件 ✓
  - **Check for secrets in source** (line 109-123): grep pattern `(api[_-]?key|secret|password|token|bearer|credential).*=.*["'][A-Za-z0-9+/=]{16,}` —— 对齐 _audit-security.md §1.4 "代码库 0 secrets" 声明 ✓
  - **Zip extension** (line 125-135): 排除 _audit-security.md / README.md / .DS_Store（避免噪音） ✓
  - **Upload zip** (line 137-142) ✓
  - **Create GitHub Release (draft)** (line 144-191) ✓
- **chrome-webstore** (line 196-284): `if: ${{ secrets.* != '' && ... }}` 4 缺失即 skip —— 优雅降级（4 个 CWS secret 全部存在才跑） ✓
  - **Validate Chrome Web Store secrets** (line 220-228) ✓
  - **Upload to CWS (draft)** (line 230-241) ✓
  - **Publish (auto)** (line 243-252): `if: 'false'` —— 默认不 auto publish，需手动 dashboard review ✓
  - **Update release notes with CWS status** (line 254-284): `if: always()` —— skip/fail 也写 status ✓

### 4. .github/SECRETS.md
- **4 必配 + 4 可选**（共 8 个 secret）—— 与 workflow 引用一一对应 ✓
- **每个 secret 都有**：用途 / 在哪找 / 在哪生成 / 安全注意（4 节模板）✓
- **轮换策略表** (line 124-132): APP_SPECIFIC_PASSWORD 6 个月 · SLACK_WEBHOOK_URL 1 年 · CWS_* 1 年 ✓
- **安全红线** (line 136-142): 不要写代码 / 不要在 public log 打印 / 用 ${{ secrets.* }} 引用 / 怀疑泄漏立即 rotate ✓

### 5. 路径引用验证
- `code/Yinghua/project.yml` — EXISTS ✓
- `code/yinghua-extension/manifest.json` — MV3 ✓
- 4 个 JS 文件（background.js, content.js, offscreen.js, popup.js）—— 全部 EXISTS ✓
- `design/_exploration/C33_code-signing/sign-and-notarize.sh` — EXISTS ✓

### 6. 实际构建验证
- **macos-14 + Xcode 26.6** 在当前 runner 不存在，但 workflow 中明确 `sudo xcode-select -s /Applications/Xcode_26.6.app`（合理）
- **本地 xcodebuild** 带 `CODE_SIGNING_ALLOWED=NO` → **BUILD SUCCEEDED** ✓
- 无 `error:` 编译错误 ✓

## 关键发现
- **+**：build.yml 4 job 设计严谨（pr-comment 失败 sticky comment · test job 软失败透明）✓
- **+**：release.yml 显式分离 secrets 验证 + notarytool store + 三重 verify ✓
- **+**：extension.yml 用 Python 强制检查 manifest + 4 JS 文件 syntax + 引用路径 + 硬编码 secret —— 纵深防御 ✓
- **+**：CWS auto-publish 默认 `if: 'false'`（防止误发）✓
- **+**：SECRETS.md 包含轮换策略 + 安全红线，完整可执行 ✓
- **−（轻微）**：release.yml 用 `xcrun altool --upload-app`（Apple 已标记 deprecated），注释里已说明 MVP 阶段可接受 + 未来切到 notarytool + transporter（这是 honest 工程声明，不算 FAIL）
- **−（轻微）**：build.yml 的 test job `continue-on-error: true`（透明但需补 XCTest target 后改为硬失败——注释里已说明）

## 总结
- **VERDICT: PASS**
- 关键发现：3 个 workflow 覆盖 macOS app + Chrome extension 完整 CI/CD 链；SECRETS.md 是可执行的运维文档；本地实际 BUILD SUCCEEDED。
- 建议：altool → notarytool+transporter 切轨 task 单独建，不阻塞当前验收；XCTest target 落地后去掉 test job 的 `continue-on-error`。

## 等级
- **PASS**：可用，无阻塞。`C40_ci-cd/` 可签收。
