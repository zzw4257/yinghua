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

<a id="cloudflare-pages-2"></a>

## 必配：Cloudflare Pages marketing 网站（2 个）

> 这 2 个 secret 配齐后，`.github/workflows/deploy-pages.yml` 和
> `deploy-pages-preview.yml` 才能正常跑 deploy。
> **不配**也不会让现有 build/release/extension workflow 失败（独立的工作流），
> 但 marketing 站点无法通过 CI 自动部署。

### 9. `CLOUDFLARE_API_TOKEN`

- **值**：从 Cloudflare Dashboard 创建的 API token
- **在哪生成**（推荐正式方案）：
  1. 打开 <https://dash.cloudflare.com/profile/api-tokens>
  2. **Create Token** → 模板 **Edit Cloudflare Pages**
  3. **Account Resources**：`Include → zzw4257 account`
  4. **Zone Resources**：Include → Specific zone → `yinghua.zzw4257.cn`（如已接入 Cloudflare）或留空
  5. **Permissions** 检查清单：
     - `Account → Account Settings: Read`（zone 读必需）
     - `Account → Cloudflare Pages: Edit`（Pages 部署必需）
  6. **IP Address Filtering**：**留空**（推荐）或把 GitHub Actions 的 IP 段加白
     - GitHub Actions IP 段：<https://api.github.com/meta> 里 `actions` 字段
  7. **TTL**：可选；不设默认不过期
  8. 点击 **Continue to summary** → **Create Token**
  9. 复制 token（**只显示一次**）
- **用于**：
  - `.github/workflows/deploy-pages.yml` 的 `cloudflare/pages-action@v1` 步骤
  - `.github/workflows/deploy-pages-preview.yml` 同上
- **C72 教训**：早期 token 配了 IP allowlist + 缺 Pages:Edit 权限，从 worker 本机调 API
  一直 401/403（错误码 9109 / 10000）。C74 改走 GitHub Actions 是因为 runner
  出口 IP 在 GitHub 段，大概率不在原 token 的 deny list 里。如果新 token 也
  失败，**第一件事**就是确认 IP filtering 留空。
- **安全注意**：
  - token 等同于账号 Pages 写入权限，泄漏立即在 Dashboard 撤销
  - 不要在 commit / PR comment / log / 公开频道里出现
  - GitHub Actions 的 `secrets.*` 引用会自动 mask（但只在引用处）

### 10. `CLOUDFLARE_ACCOUNT_ID`

- **值**：`a802c5b7499e1f9e2259a295823d853d`（硬编码常量）
- **在哪找**：
  1. 打开 <https://dash.cloudflare.com/>
  2. 右下角 **API** 卡片里 **Account ID** 字段
  3. 或 URL `https://dash.cloudflare.com/<ACCOUNT_ID>/...` 里的那串
- **用于**：
  - Cloudflare API 所有 endpoint 的 path 参数 `/accounts/{id}/...`
  - GitHub Actions `cloudflare/pages-action@v1` 的 `accountId` 输入

---

<a id="cloudflare-pages-setup"></a>

### Cloudflare Pages 项目初始化（owner 一次性操作）

> 这步**只在第一次**需要做。GitHub Actions 只负责上传文件，不创建项目
> 也不配自定义域。

#### 1. 创建 Pages project

1. <https://dash.cloudflare.com/> → **Workers & Pages** → **Create application** → **Pages** → **Direct Upload**
2. **Project name**：`yinghua-marketing`
3. **Production branch**：`main`（与 GitHub repo 默认分支对齐）
4. **Build command**：留空（静态站无构建）
5. **Build output directory**：留空（稍后从 GitHub Actions 上传，不需要 CF 自己 build）
6. 点 **Save and Deploy** — 这会创建一个空的 `preview` 部署，可忽略

#### 2. 添加自定义域

1. Pages project → **Custom domains** → **Set up a custom domain**
2. 输入 `yinghua.zzw4257.cn` → **Continue**
3. Cloudflare 会自动检测 DNS（如果 zone 已在 CF）→ **Activate**
4. 如 zone 不在 Cloudflare，按提示去域名注册商加 CNAME
5. 重复 1-4 加 `www.yinghua.zzw4257.cn`（301 → 裸域）

#### 3. 第一次手动上传（验证项目配置）

如果想不等 GitHub Actions 触发，先在 Dashboard 跑一次：

1. Pages project → **Create deployment** → **Direct Upload**
2. 上传 `design/_exploration/C29_marketing-website/deploy/public/` 的 zip
3. 部署完成后访问 <https://yinghua-marketing.pages.dev/> 验证 6 页面 + ja-JP/ + zh-Hans/ 子目录

#### 4. 配置 GitHub repo secrets

按上面 §9 §10 在 `Settings → Secrets and variables → Actions` 加 2 个 secret。

#### 5. 触发第一次 Actions deploy

```bash
git commit --allow-empty -m "ci: trigger first Cloudflare Pages deploy"
git push upstream main
```

去 GitHub Actions 看 `Deploy Pages` workflow 跑完，访问
<https://yinghua.zzw4257.cn/> 验证。

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
| `CLOUDFLARE_API_TOKEN` | 1 年 / 怀疑泄漏 | Dashboard 撤销 + 重新创建（IP filtering 留空） |
| `CLOUDFLARE_ACCOUNT_ID` | 几乎不变 | 换 Cloudflare 账号时 |

---

## 安全红线

- ❌ **永远不要** 把 secrets 写到代码、README、commit message、PR comment
- ❌ **永远不要** 在 public fork / public PR 的 log 里打印 secret
- ✅ 用 `${{ secrets.* }}` 引用，GitHub 自动 mask（但只在引用处 mask，其他地方出现仍会泄漏）
- ✅ 用 `continue-on-error` + 错误信息时避免 echo secret
- ✅ 怀疑泄漏时立即 rotate，比担心 false positive 安全
