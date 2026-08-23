# GitHub Secrets 配置指南

> 映话 (Yìnghuà) CI/CD 用的 repo-level secrets。
> **配置位置**：仓库 `Settings` → `Secrets and variables` → `Actions` → `New repository secret`

---

## 必配：macOS app release（4 个）

### 1. `APPLE_TEAM_ID`

- **值**：10 字符的 Apple Developer Team ID
- **在哪找**：
  1. 打开 <https://developer.apple.com/account>
  2. 登录 Apple Developer 账号
  3. 右上角点 **Membership**
  4. **Team ID** 就是（例：`ABC123XYZ4`）
- **用于**：
  - `xcodebuild` 的 `DEVELOPMENT_TEAM` 参数
  - `xcodebuild -exportArchive` 的 `teamID`（exportOptions.plist）
  - `xcrun notarytool` 的 `--team-id`

### 2. `APPLE_ID`

- **值**：Apple Developer 账号邮箱（例：`you@example.com`）
- **在哪找**：就是你注册 Apple Developer Program 时用的 Apple ID
- **用于**：
  - `xcrun notarytool store-credentials` 的 `--apple-id`
  - `xcrun altool --upload-app` 的 `--username`

### 3. `APP_SPECIFIC_PASSWORD`

- **值**：16 字符的 app-specific password（**不是** Apple ID 的密码）
- **在哪生成**：
  1. 登录 <https://appleid.apple.com>
  2. 左侧 **App-Specific Passwords**
  3. 点 **Generate Password**（需要 2FA）
  4. 标签写 `yinghua-ci`
  5. 复制生成的 `xxxx-xxxx-xxxx-xxxx` 格式密码
- **用于**：
  - `xcrun notarytool store-credentials` 的 `--password`
  - `xcrun altool --upload-app` 的 `--password`
- **安全注意**：
  - 只在 CI 上下文使用，**不要**用主 Apple ID 密码
  - 每个泄露的 app-specific password 可独立 revoke（在 appleid.apple.com 可重置）
  - 泄漏后立即在 appleid.apple.com revoke + 在 GitHub 重新生成

### 4. `SLACK_WEBHOOK_URL` *(可选，但推荐)*

- **值**：Slack incoming webhook URL
- **在哪生成**：
  1. 打开 <https://api.slack.com/apps>
  2. **Create New App** → 选 workspace
  3. **Incoming Webhooks** → 开关打开 → **Add New Webhook to Workspace**
  4. 选 channel，复制 `https://hooks.slack.com/services/...` 格式 URL
- **用于**：`release.yml` 失败时通知 maintainer
- **可省**：如果不配 Slack，release 失败时只会在 Actions UI 显示，不会发外部通知

---

## 可选：Chrome Web Store 自动上传（4 个）

> 这 4 个 secret 全部配齐后，`extension.yml` 的 `chrome-webstore` job 才会跑。
> 任意一个缺失，job 自动 skip（不影响主 release）。
> MVP 阶段建议先只在 GitHub Release 发包，web store 手动传 zip。

### 5. `CHROME_WEBSTORE_CLIENT_ID`

- **值**：OAuth 2.0 client ID
- **在哪生成**：
  1. 打开 <https://console.cloud.google.com/>
  2. 新建（或选）项目：`yinghua-extension`
  3. **APIs & Services** → **Enable APIs** → 启用 **Chrome Web Store API**
  4. **Credentials** → **Create Credentials** → **OAuth 2.0 Client ID**
  5. Application type: **Web application**
  6. 填名 `yinghua-cws-upload`
  7. 创建后复制 **Client ID**

### 6. `CHROME_WEBSTORE_CLIENT_SECRET`

- **值**：同上面 OAuth 2.0 client 的 secret
- **在哪找**：和 `CHROME_WEBSTORE_CLIENT_ID` 同一个凭证页，**Client secret** 字段
- **生成后只显示一次** — 复制保存

### 7. `CHROME_WEBSTORE_REFRESH_TOKEN`

- **值**：OAuth 2.0 refresh token（长期）
- **在哪生成**：
  1. 用同一个 OAuth client 走一次授权流程
  2. 装 `chrome-webstore-upload-cli`：`npm install -g chrome-webstore-upload-cli`
  3. 跑 `chrome-webstore-upload-cli init`（按提示走 OAuth flow）
  4. 生成的 `~/.config/chrome-webstore-upload/config.json` 里 `refresh_token` 字段
  5. 也可以直接走 <https://developer.chrome.com/docs/webstore/using-api#requesttoken> 的步骤
- **用于**：每次发新版本时换 access token（access token 1 小时过期，refresh token 长期有效）
- **安全注意**：refresh token 等同于账号权限，泄漏立即在 Google Cloud Console 撤销

### 8. `CHROME_WEBSTORE_EXTENSION_ID`

- **值**：Chrome Web Store 上的 extension ID（32 字符）
- **在哪找**：
  1. 第一次把 extension 提交到 CWS 后得到
  2. 或者 Chrome Web Store Developer Dashboard → 你的 extension → URL 里那串
  3. 例：`abcdefghijklmnopqrstuvwxyzabcdef`
- **用于**：`chrome-webstore-upload` 的 `--extension-id`

---

## 校验清单

配置完成后本地校验：

```bash
# 检查 release workflow 能正确读 secrets（不会真跑）
gh workflow view release.yml --repo yinghua-inc/yinghua

# 触发一次空 release tag，看 sign 步骤是否能过
git tag v0.0.0-test-ci
git push origin v0.0.0-test-ci
# 然后去 Actions 里 cancel（不想真出 release）
```

---

## 轮换策略

| Secret | 轮换周期 | 轮换方式 |
|--------|---------|---------|
| `APPLE_TEAM_ID` | 几乎不变 | 换 team 时才变 |
| `APPLE_ID` | 几乎不变 | 换 Apple ID 账号时 |
| `APP_SPECIFIC_PASSWORD` | 6 个月 / 怀疑泄漏 | 在 appleid.apple.com revoke + GitHub 重新生成 |
| `SLACK_WEBHOOK_URL` | 1 年 / 团队成员变动 | 在 Slack 重新生成 |
| `CHROME_WEBSTORE_*` | 1 年 / 怀疑泄漏 | Google Cloud Console 撤销 + 重新走 OAuth flow |

---

## 安全红线

- ❌ **永远不要** 把 secrets 写到代码、README、commit message、PR comment
- ❌ **永远不要** 在 public fork / public PR 的 log 里打印 secret
- ✅ 用 `${{ secrets.* }}` 引用，GitHub 自动 mask（但只在引用处 mask，其他地方出现仍会泄漏）
- ✅ 用 `continue-on-error` + 错误信息时避免 echo secret
- ✅ 怀疑泄漏时立即 rotate，比担心 false positive 安全
