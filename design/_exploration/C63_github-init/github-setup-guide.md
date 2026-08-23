# 映话 GitHub Repo · Setup Guide

## 1. 在 GitHub 创建 repo

在 https://github.com/new 创建：

- Owner: `yinghua-inc`（或你的个人 org）
- Name: `yinghua`
- Visibility: Public
- **不**勾选 "Add README"（我们已有）

## 2. 仓库配置

### Settings → General

- Default branch: main
- Pull Requests: Allow squash merging
- Releases: Enable

### Settings → Secrets and variables → Actions

加 secrets（C40 workflow 用）：

- `APPLE_ID`：Apple Developer 账号邮箱
- `APP_SPECIFIC_PASSWORD`：appleid.apple.com 生成的 app-specific password
- `APPLE_TEAM_ID`：10 字符 Team ID
- `CLOUDFLARE_API_TOKEN`：Cloudflare API token
- `CLOUDFLARE_ACCOUNT_ID`：Cloudflare account ID

### Settings → Pages

（**不**用 GitHub Pages · 用 Cloudflare Pages）

### Settings → Environments

加 2 个 environment：

- `production`（保护 main 分支）
- `staging`（保护 PR preview）

### Settings → Code security and analysis

- 启用 Dependabot alerts
- 启用 Dependabot security updates
- 启用 Secret scanning
- 启用 Code scanning（CodeQL）

## 3. 第一次 push

```bash
# 仓库根（映话 monorepo 根）
cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon

# 加 remote
git remote add origin git@github.com:yinghua-inc/yinghua.git
# 或 HTTPS
# git remote add origin https://github.com/yinghua-inc/yinghua.git

# 推 main 分支
git push -u origin main

# 第一次 release
git tag v0.1.0
git push origin v0.1.0
```

## 4. 验证

- [ ] main 分支可见
- [ ] GitHub Actions 跑 3 个 workflow（build / release / extension）
- [ ] build workflow 成功（v0.1.0 commit push 后）
- [ ] release workflow 等 git tag 触发
- [ ] extension workflow 等 ext-v* tag 触发

## 5. 域名（yinghua.zzw4257.cn）

参见 C60 Cloudflare Pages setup guide。

## 6. 推荐下一步

- [ ] 启用 GitHub Discussions（社区问答）
- [ ] 启用 GitHub Wiki（如需要）
- [ ] 配 branch protection rules
- [ ] 配 required reviewers（至少 1 人 approve PR）
