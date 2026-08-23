# 映话 (Yìnghuà) — Deploy Package

> 映话官方网站 **Cloudflare Pages 部署包**
> 状态：v1 · 2026-08-24 · 静态站 · HTML / CSS / JS
> 源站：[`../website/`](../website/) · 站点内容：[`../README.md`](../README.md)

---

## 📦 目录结构

```
deploy/
├── wrangler.toml              # Cloudflare Pages 配置 + 自定义域注释
├── README.md                  # 本文件
├── .github/
│   └── workflows/
│       └── deploy.yml         # GitHub Actions 触发 Pages 部署
└── public/                    # = 网站构建输出
    ├── index.html             # 主页
    ├── features.html          # 功能页
    ├── pricing.html           # 定价页
    ├── download.html          # 下载页
    ├── privacy.html           # 隐私政策
    ├── terms.html             # 服务条款
    ├── favicon.png
    ├── _headers               # 静态站安全头 + HSTS preload
    ├── _redirects             # i18n 路由
    ├── assets/                # CSS / JS / 图
    ├── zh-Hans/               # 简体中文版
    └── ja-JP/                 # 日文版
```

---

## 🚀 首次部署

### 1. 创建 Cloudflare Pages project

1. Cloudflare Dashboard → **Workers & Pages** → **Create application** → **Pages** → **Connect to Git**
2. 选择 `zzw4257/yinghua-marketing`（或你的 repo 名）
3. **Build settings**:
   - **Framework preset**: `None`
   - **Build command**: `echo 'No build step needed'`
   - **Build output directory**: `public`
4. **Environment variables**:
   - `CLOUDFLARE_PAGES_BRANCH` = `main`
5. 点 **Save and Deploy** → 等待首次部署完成（< 1 分钟）

### 2. 默认 URL

部署成功后可在 `https://yinghua.zzw4257.cn` 访问。

---

## 🌐 自定义域：yinghua.zzw4257.cn

### DNS 配置（Cloudflare Dashboard）

1. Cloudflare → `yinghua.zzw4257.cn` zone → **DNS** → **Records**
2. 加 CNAME 记录：
   - **Name**: `@`（根域）· **Target**: `yinghua-marketing.pages.dev` · **Proxy status**: **Proxied**（橙色云）
   - **Name**: `www` · **Target**: `yinghua-marketing.pages.dev` · **Proxy status**: **Proxied**（橙色云）

> 注：必须 Proxied（橙色云）才能让 Cloudflare 自动签发证书 + 走 CDN。DNS-only（灰色云）会失去边缘加速。

### Cloudflare Pages 配自定义域

1. Cloudflare → **Workers & Pages** → `yinghua-marketing` → **Custom domains**
2. 点 **Set up a custom domain** → 输入 `yinghua.zzw4257.cn` → **Continue** → **Add domain**
3. 同样加 `www.yinghua.zzw4257.cn`

Cloudflare 会自动：
- 验证 DNS（自动加 `_cf-custom-hostname` 验证记录）
- 签发边缘证书（Universal SSL / Let's Encrypt）
- 在 zone 和 Pages project 之间建立关联

### 等待 SSL

通常 < 5 分钟。可在 **Custom domains** 页面看状态：🟢 Active 即就绪。

如果超过 15 分钟仍 🟡 Pending：
- 检查 DNS 记录是否 Proxied（必须是橙色云）
- 确认 zone `yinghua.zzw4257.cn` 已在 Cloudflare 激活
- 在 **SSL/TLS** → **Edge Certificates** 手动检查证书状态

### 验证

```bash
# 1. HTTP → HTTPS 重定向
curl -I http://yinghua.zzw4257.cn
# 期望: 301/308 → https://yinghua.zzw4257.cn

# 2. HTTPS 200 + CF 缓存命中
curl -I https://yinghua.zzw4257.cn
# 期望:
#   HTTP/2 200
#   server: cloudflare
#   cf-cache-status: HIT
#   strict-transport-security: max-age=31536000; includeSubDomains; preload
#   content-security-policy: default-src 'self'; ...

# 3. www 重定向到根域（Cloudflare 自动配）
curl -I https://www.yinghua.zzw4257.cn
# 期望: 301/308 → https://yinghua.zzw4257.cn
```

### HSTS preload 提交

`public/_headers` 已声明 `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload`。

部署到 `yinghua.zzw4257.cn` 后：

1. 访问 <https://hstspreload.org/?domain=yinghua.zzw4257.cn>
2. 确认 `max-age` ≥ 1 年 + `includeSubDomains` + `preload` 三项都勾选
3. 点 **Check status** → **I understand and wish to proceed** → **Submit**
4. 等待 1-2 个月进入 Chrome / Firefox / Safari 内置 HSTS 列表

> 提交后**无法轻易回退**（需要数月走完移除流程），确保域下所有子域都支持 HTTPS。

---

## 🔁 GitHub Actions 自动部署

`.github/workflows/deploy.yml` 在每次 `main` 分支 push 时自动触发 `wrangler pages deploy`。

### 配置 secrets

1. Cloudflare → **My Profile** → **API Tokens** → **Create Token**
2. 模板选 **Edit Cloudflare Pages** → 限定到 `yinghua-marketing` project
3. GitHub repo → **Settings** → **Secrets and variables** → **Actions**
4. 加 secrets：
   - `CLOUDFLARE_API_TOKEN` — 上面生成的 token
   - `CLOUDFLARE_ACCOUNT_ID` — Cloudflare Dashboard 右侧栏

### 触发流程

```
git push origin main
  ↓
GitHub Actions (deploy.yml)
  ↓
wrangler pages deploy ./public --project-name=yinghua-marketing
  ↓
Cloudflare Pages → 30s 内全球边缘节点同步
  ↓
yinghua.zzw4257.cn 自动更新
```

---

## 🛠 故障排查

| 症状 | 原因 | 解决 |
|------|------|------|
| 自定义域 Pending > 15min | DNS 未 Proxied / 记录错 | DNS 记录必须 Proxied（橙色云），Target 必须是 `yinghua-marketing.pages.dev` |
| 证书签发失败 | zone 未激活 / CAA 记录冲突 | **SSL/TLS** → **Edge Certificates** 看具体错误；临时关闭 CAA |
| HTTP → HTTPS 不重定向 | SSL 模式不对 | **SSL/TLS** → **Overview** → 选 **Full (strict)** |
| `_headers` 不生效 | 不是 Cloudflare Pages / 文件位置错 | 确认是 Pages project（非 Workers）+ `_headers` 在 `public/` 根目录 |
| `_redirects` 不生效 | 同上 | 同上 + 语法必须是 `[Source] [Destination] [Status]` |
| 部署后 404 | `pages_build_output_dir` 错 | `wrangler.toml` 必须是 `pages_build_output_dir = "./public"` |
| GitHub Actions 401 | API token 权限不够 | 重新生成 token，选 **Edit Cloudflare Pages** 模板 |
| 缓存一直 STALE | 缓存规则过严 | **Caching** → **Cache Rules** 检查；HTML 默认 300s 即可 |

### 回滚

```bash
# Cloudflare Dashboard → Pages → yinghua-marketing → Deployments
# 找到上一个稳定版本 → ⋯ → Rollback to this deploy
```

---

## 📋 验收清单

- [x] `wrangler.toml` 配置 Pages project name + build output
- [x] `_headers` 包含 HSTS preload + CSP + 权限策略
- [x] `_redirects` 配置 i18n 路由
- [ ] Cloudflare Pages project 已创建并连 GitHub
- [ ] GitHub Actions secrets 已配置
- [ ] DNS 记录已加（@ + www · Proxied）
- [ ] 自定义域 `yinghua.zzw4257.cn` 已绑定并 Active
- [ ] `curl -I https://yinghua.zzw4257.cn` 返回 200 + HSTS header
- [ ] HSTS preload 已提交到 hstspreload.org

---

## 📚 上下游

- **上游**：[`../website/`](../website/) — 站点源
- **下游**：
  - C60_cf-pages-setup/setup-guide.md — 完整部署配置指南
  - C61_analytics — 接入分析（部署后做）
  - C62_legal-review — 隐私/条款发布前法律复核

---

**版本**：v1.0 · 2026-08-24
**部署状态**：待首次部署 + 自定义域激活
**License**：MIT
