# C60 — Cloudflare Pages Setup Guide

> 映话 (Yìnghuà) · Cloudflare Pages 完整配置指南
> 目标：`yinghua.zzw4257.cn` · 全流程：建项目 → 连 GitHub → 配自定义域 → DNS → 验证 → 故障排查
> 状态：v1 · 2026-08-24 · 预计操作时长 30-45 分钟（含 DNS 等待）

---

## 0. 前置条件

| 条件 | 说明 | 状态 |
|------|------|------|
| Cloudflare 账号 | <https://dash.cloudflare.com/sign-up> | 需有 |
| GitHub 账号 + 仓库 | `zzw4257/yinghua-marketing`（或自定义） | 需有 |
| 域名 `zzw4257.cn` 已在 Cloudflare | Nameservers 指向 Cloudflare | 需有 |
| `yinghua.zzw4257.cn` 子域权限 | 在 `zzw4257.cn` zone 加 CNAME 即可 | 需有 |
| 站点源文件 | `design/_exploration/C29_marketing-website/website/` | ✅ 已就位 |
| 部署包 | `design/_exploration/C29_marketing-website/deploy/` | ✅ 已就位 |

---

## 1. 准备 GitHub 仓库

### 1.1 推送部署包到新 repo

```bash
# 在本地（一次性）
cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/design/_exploration/C29_marketing-website/deploy

# 初始化 repo（如果还没有）
git init
git add .
git commit -m "Initial deploy package for yinghua-marketing"

# GitHub 上先创建空 repo: yinghua-marketing
# 然后:
git remote add origin git@github.com:zzw4257/yinghua-marketing.git
git branch -M main
git push -u origin main
```

> **重要**：`public/` 目录必须包含全部站点文件。Cloudflare Pages 直接发布 `public/` 内容，不会自己跑构建。

### 1.2 验证仓库结构

```
yinghua-marketing/
├── .github/workflows/deploy.yml  # 可选：自动部署
├── public/
│   ├── index.html
│   ├── features.html
│   ├── pricing.html
│   ├── download.html
│   ├── privacy.html
│   ├── terms.html
│   ├── _headers                  # HSTS / CSP
│   ├── _redirects
│   └── assets/...
└── wrangler.toml                 # Pages 配置
```

---

## 2. 创建 Cloudflare Pages Project

### 2.1 Dashboard 创建

1. 登录 <https://dash.cloudflare.com/>
2. 左侧栏 → **Workers & Pages** → **Create application**
3. 选 **Pages** 标签 → **Connect to Git**

### 2.2 连接 GitHub

1. 点 **Connect GitHub** → 授权 Cloudflare 访问你的 GitHub
2. 选择 **Only select repositories** → 选 `yinghua-marketing`（或你的 repo 名）
3. 点 **Install & Authorize**

### 2.3 选择 repository + branch

- **Select your repository**: `zzw4257/yinghua-marketing`
- **Production branch**: `main`

### 2.4 Build settings

| 配置项 | 值 | 备注 |
|--------|------|------|
| **Framework preset** | `None` | 静态站无需框架 |
| **Build command** | `echo 'No build step needed - static HTML'` | 占位命令 |
| **Build output directory** | `public` | 必须与 `wrangler.toml` 中 `pages_build_output_dir` 一致 |

### 2.5 Environment variables

加一个环境变量：
- **Variable name**: `CLOUDFLARE_PAGES_BRANCH`
- **Value**: `main`

### 2.6 首次部署

点 **Save and Deploy**。

预计 30-60 秒，部署完成后会显示：
```
✅ Deployment complete
Preview URL: https://<random-hash>.yinghua.zzw4257.cn
Production URL: https://yinghua.zzw4257.cn
```

**立即访问 `https://yinghua.zzw4257.cn` 验证默认站是否正常。**

---

## 3. 配自定义域 `yinghua.zzw4257.cn`

### 3.1 Cloudflare Dashboard 配 custom domain

1. Cloudflare → **Workers & Pages** → 点 `yinghua-marketing`
2. 顶部 tab 选 **Custom domains**
3. 点 **Set up a custom domain**
4. 输入 `yinghua.zzw4257.cn` → **Continue**
5. Cloudflare 自动检测 zone `yinghua.zzw4257.cn`（如果没激活会先让激活）
6. **Add domain** 确认

添加 `www.yinghua.zzw4257.cn` 同样步骤。

### 3.2 DNS 配置

**前提**：`yinghua.zzw4257.cn` 必须在 Cloudflare 上（要么作为独立 zone，要么作为 `zzw4257.cn` 的子域）。

#### 情况 A：`yinghua.zzw4257.cn` 是独立 zone

Cloudflare 会自动加 CNAME 记录，无需手动配。

#### 情况 B：作为 `zzw4257.cn` 子域（最常见）

1. Cloudflare → `zzw4257.cn` zone → **DNS** → **Records**
2. 加两条 CNAME 记录：

| Type | Name | Target | Proxy status | TTL |
|------|------|--------|--------------|-----|
| CNAME | `yinghua` | `yinghua-marketing.pages.dev` | **Proxied**（橙色云） | Auto |
| CNAME | `www.yinghua` | `yinghua-marketing.pages.dev` | **Proxied**（橙色云） | Auto |

> ⚠️ **必须 Proxied（橙色云）**，否则：
> - 无法自动签发证书
> - 失去 CDN 边缘加速
> - Cloudflare Pages 无法接管流量

### 3.3 等待 SSL 证书

Cloudflare 自动签发 Universal SSL 证书（Let's Encrypt）。

通常 < 5 分钟。验证方法：

1. Cloudflare → `yinghua.zzw4257.cn` zone（如果独立）或 `zzw4257.cn` → **SSL/TLS** → **Edge Certificates**
2. 找到 `*.yinghua.zzw4257.cn` 或 `yinghua.zzw4257.cn` 证书 → 状态应该是 **Active**

### 3.4 SSL/TLS 加密模式

Cloudflare → `yinghua.zzw4257.cn` zone（独立）或 `zzw4257.cn` → **SSL/TLS** → **Overview**

- **加密模式**: 选 **Full (strict)** ✅
  - Full (strict) = 客户端 ↔ Cloudflare（证书）↔ 源站（证书），源站必须有有效证书
  - 由于源站是 Pages 自身，证书自动签发，选 Full (strict) 最安全
- 避免选 **Flexible**（中间人攻击风险）

---

## 4. 验证

### 4.1 DNS 解析

```bash
# 根域
dig yinghua.zzw4257.cn
# 期望: yinghua.zzw4257.cn. 300 IN CNAME yinghua-marketing.pages.dev.

# www 子域
dig www.yinghua.zzw4257.cn
# 期望: www.yinghua.zzw4257.cn. 300 IN CNAME yinghua-marketing.pages.dev.
```

### 4.2 HTTPS 响应

```bash
# 根域
curl -I https://yinghua.zzw4257.cn
```

期望响应头：
```
HTTP/2 200
server: cloudflare
content-type: text/html; charset=utf-8
cf-cache-status: HIT
strict-transport-security: max-age=31536000; includeSubDomains; preload
content-security-policy: default-src 'self'; img-src 'self' data: https:; ...
x-content-type-options: nosniff
x-frame-options: DENY
referrer-policy: strict-origin-when-cross-origin
permissions-policy: microphone=(), camera=(), geolocation=()
```

### 4.3 HTTP → HTTPS 重定向

```bash
curl -I http://yinghua.zzw4257.cn
# 期望: 301 或 308 → https://yinghua.zzw4257.cn
```

### 4.4 www → 根域重定向

```bash
curl -I https://www.yinghua.zzw4257.cn
# 期望: 301 或 308 → https://yinghua.zzw4257.cn
```

如果没自动重定向，需在 Pages 的 **Custom domains** 把 `www.yinghua.zzw4257.cn` 也加进去（Cloudflare 默认会做 301 重定向）。

### 4.5 i18n 路由

```bash
curl -I https://yinghua.zzw4257.cn/zh-Hans/
# 期望: 200
curl -I https://yinghua.zzw4257.cn/ja-JP/
# 期望: 200
```

由 `public/_redirects` 规则决定。检查文件：

```bash
cat public/_redirects
# 期望类似:
# /zh-Hans/*  /zh-Hans/:splat  200
# /ja-JP/*    /ja-JP/:splat    200
```

### 4.6 性能检查

```bash
# 1. 边缘节点响应时间
curl -o /dev/null -s -w "DNS: %{time_namelookup}s\nConnect: %{time_connect}s\nTLS: %{time_appconnect}s\nTTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n" https://yinghua.zzw4257.cn

# 2. 走 Cloudflare CDN（应 < 100ms）
# 3. 检查头部
curl -sI https://yinghua.zzw4257.cn | grep -i "cf-\|server:"
```

### 4.7 浏览器手动检查

访问 <https://yinghua.zzw4257.cn>：

- ✅ 自动 HTTP → HTTPS
- ✅ 锁图标 + 证书有效
- ✅ 主页 5 段锚点滚动正常
- ✅ 主题切换（暗/亮/自动）正常
- ✅ 6 个页面都正常打开
- ✅ 4 个断点响应式（DevTools 测 1440 / 1024 / 768 / 375）
- ✅ DevTools → Network → 资源 200，cf-cache-status: HIT

---

## 5. HSTS Preload（可选但强烈建议）

### 5.1 准备

`public/_headers` 已包含：
```
Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
```

部署到 `yinghua.zzw4257.cn` 后，浏览器访问即可看到此 header。

### 5.2 提交

1. 访问 <https://hstspreload.org/?domain=yinghua.zzw4257.cn>
2. 检查状态：
   - `max-age` ≥ 1 年 ✅
   - `includeSubDomains` ✅
   - `preload` directive ✅
   - `https://yinghua.zzw4257.cn` 返回 HSTS header ✅
3. 点击 **I understand the implications and wish to proceed** → 提交
4. 等待 1-2 个月进入浏览器内置 HSTS 列表（Chrome / Firefox / Safari / Edge）

### 5.3 注意事项

- ⚠️ 提交后**极难回退**（需要数月走完移除流程）
- ⚠️ `includeSubDomains` 意味着 `*.zzw4257.cn` 所有子域必须都能 HTTPS
  - 如果 `zzw4257.cn` 主站还没 HTTPS，先别加 preload
  - 或者改用 `max-age=31536000; preload` 不带 `includeSubDomains`

---

## 6. GitHub Actions 自动部署（可选）

### 6.1 创建 Cloudflare API Token

1. Cloudflare → **My Profile**（右上角）→ **API Tokens** → **Create Token**
2. 模板选 **Edit Cloudflare Pages**（已限定 Pages 权限）
3. **Account Resources**: 你的 account
4. **Zone Resources**: 选 `zzw4257.cn`（或 `yinghua.zzw4257.cn`）
5. **Continue to summary** → **Create Token**
6. **复制 token**（只显示一次）

### 6.2 获取 Account ID

Cloudflare Dashboard 右侧栏 → **Account ID**（一串 hex）→ 复制。

### 6.3 GitHub Secrets

GitHub repo → **Settings** → **Secrets and variables** → **Actions** → **New repository secret**

| Name | Value |
|------|-------|
| `CLOUDFLARE_API_TOKEN` | 上一步的 token |
| `CLOUDFLARE_ACCOUNT_ID` | Account ID |

### 6.4 验证 workflow 文件

`yinghua-marketing/.github/workflows/deploy.yml` 应该类似：

```yaml
name: Deploy to Cloudflare Pages
on:
  push:
    branches: [main]
jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - name: Deploy
        uses: cloudflare/wrangler-action@v3
        with:
          apiToken: ${{ secrets.CLOUDFLARE_API_TOKEN }}
          accountId: ${{ secrets.CLOUDFLARE_ACCOUNT_ID }}
          command: pages deploy ./public --project-name=yinghua-marketing
```

### 6.5 测试

```bash
# 本地任意修改
echo "<!-- $(date) -->" >> public/index.html
git add . && git commit -m "test auto deploy"
git push origin main
# → GitHub Actions 自动跑 → ~30s 后 yinghua.zzw4257.cn 刷新看到更新
```

---

## 7. 性能优化（部署后可选）

### 7.1 缓存规则

Cloudflare → `yinghua.zzw4257.cn` zone → **Caching** → **Cache Rules**

| 模式 | 路径 | 缓存 TTL |
|------|------|----------|
| HTML | `*.html` | `Edge TTL: 2 hours`, `Browser TTL: 0` (must-revalidate) |
| 静态资源 | `/assets/*` | `Edge TTL: 1 year`, `Browser TTL: 1 year`, `Immutable: ✅` |
| 字体/图片 | `*.png`, `*.svg`, `*.woff2` | `Edge TTL: 1 year` |

`_headers` 已为 `/assets/*` 设了 `Cache-Control: public, max-age=31536000, immutable`，优先级高于规则。

### 7.2 Brotli 压缩

Cloudflare 默认开启 Brotli + Gzip，无需手动配。

### 7.3 Early Hints（103）

Cloudflare → **Speed** → **Optimization** → **Early Hints**: 启用

可以提前推送 critical assets。

### 7.4 HTTP/3 (QUIC)

Cloudflare → **Network** → **HTTP/3 (with QUIC)**: 启用

---

## 8. 监控 + 日志

### 8.1 Pages Analytics

Cloudflare → **Workers & Pages** → `yinghua-marketing` → **Analytics**

看：
- Requests / Bandwidth / Errors
- Web Vitals (LCP / FID / CLS)
- Cache hit ratio（应 > 90%）

### 8.2 DNS 健康

Cloudflare → `zzw4257.cn` → **DNS** → 检查 `yinghua` 和 `www.yinghua` 记录

### 8.3 实时日志（可选）

Cloudflare → **Workers & Pages** → `yinghua-marketing` → **Logs** → **Begin log stream**

可推送到 R2 / Datadog / S3 长期存档。

---

## 9. 故障排查

### 9.1 自定义域 Pending > 15min

```bash
# 1. 检查 DNS
dig yinghua.zzw4257.cn
# 期望: CNAME → yinghua-marketing.pages.dev

# 2. 检查 zone 是否激活
# Cloudflare Dashboard 顶部应显示 Active 状态

# 3. 检查 Proxied（橙色云）
# Cloudflare DNS 记录表里云图标必须是橙色
```

修复：
- DNS 记录必须是 Proxied（橙色云）
- Target 必须是 `yinghua-marketing.pages.dev`（不要带 https://）
- 等待 DNS 传播（Cloudflare 内部通常 < 60s）

### 9.2 证书签发失败

| 错误 | 原因 | 解决 |
|------|------|------|
| `CAA record prevents issuance` | 域名有 CAA 记录限制 | 删除 `zzw4257.cn` 的 CAA 记录，或加 `0 issue "letsencrypt.org"` |
| `Zone not found` | zone 未激活 | 在 Cloudflare 添加 `yinghua.zzw4257.cn` zone 或作为子域 |
| `CNAME not found` | DNS 记录不存在或不对 | 重新加 CNAME @ → yinghua-marketing.pages.dev，Proxied |
| `Rate limit` | Let's Encrypt 速率限制 | 等待 1 小时后重试，或改用 Cloudflare 自己的 CA |

### 9.3 HTTP → HTTPS 不重定向

Cloudflare → `zzw4257.cn` 或 `yinghua.zzw4257.cn` zone → **SSL/TLS** → **Edge Certificates** → **Always Use HTTPS**: **ON**

### 9.4 `_headers` 不生效

| 原因 | 解决 |
|------|------|
| 不是 Pages project | 确认是 **Pages**（非 Workers / 非 Workers Assets） |
| 文件位置错 | `_headers` 必须在 `public/` 根目录（部署输出目录），不是项目根 |
| 大小写错 | Linux 文件名小写，检查 `ls public/_headers` |
| 缩进错 | Cloudflare `_headers` 用 **2 空格**缩进，path 在第一行 |

### 9.5 `_redirects` 不生效

同上检查。

测试：
```bash
curl -sI https://yinghua.zzw4257.cn/zh-Hans/ | head -3
# 期望 200 + location 重定向到 /zh-Hans/xxx
```

### 9.6 GitHub Actions 401 Unauthorized

```bash
# 1. API Token 权限不够
# 解决: 重新生成，选 "Edit Cloudflare Pages" 模板

# 2. Account ID 错
# 解决: 重新从 Cloudflare Dashboard 右侧栏复制

# 3. Token 过期
# 解决: 重新生成 + 更新 GitHub Secret
```

### 9.7 部署后 404

| 原因 | 解决 |
|------|------|
| `pages_build_output_dir` 错 | 改为 `./public`（与 `wrangler.toml` 一致） |
| `public/` 目录为空 | 检查 GitHub repo 是否包含 `public/index.html` |
| GitHub Actions 推送了空目录 | workflow 改成 `pages deploy ./public` |

### 9.8 缓存一直 STALE

Cloudflare → **Caching** → **Configuration** → **Browser Cache TTL**: 选 **Respect Existing Headers**（让 `_headers` 里的 `Cache-Control` 生效）

或 **Purge Cache** 强制刷新。

### 9.9 移动端布局错乱

- 检查 viewport meta：`<meta name="viewport" content="width=device-width, initial-scale=1">` 在每个 HTML `<head>` 中
- Chrome DevTools 测 375 / 768 / 1024 / 1440
- `_headers` 中 CSP 不能 block 关键资源

---

## 10. 验收清单

部署完成确认：

- [ ] GitHub repo `zzw4257/yinghua-marketing` 已创建并推送
- [ ] Cloudflare Pages project `yinghua-marketing` 已创建
- [ ] 首次部署成功，`https://yinghua.zzw4257.cn` 可访问
- [ ] DNS CNAME 已加：`yinghua` 和 `www.yinghua` 都 Proxied → `yinghua-marketing.pages.dev`
- [ ] Custom domains 已配：`yinghua.zzw4257.cn` + `www.yinghua.zzw4257.cn`
- [ ] SSL 证书状态 Active
- [ ] `curl -I https://yinghua.zzw4257.cn` 返回 200
- [ ] HSTS header 存在
- [ ] i18n 路由工作：`/zh-Hans/` 和 `/ja-JP/`
- [ ] 6 个页面都正常（index / features / pricing / download / privacy / terms）
- [ ] 4 断点响应式测试通过（1440 / 1024 / 768 / 375）
- [ ] prefers-reduced-motion 降级测试通过
- [ ] GitHub Actions 自动部署测试通过
- [ ] HSTS preload 提交到 hstspreload.org（可选）

---

## 11. 后续任务

| 任务 | 说明 | 依赖 |
|------|------|------|
| C61_analytics | 接入 Cloudflare Analytics Web Analytics 或 Plausible | 部署完成 |
| C62_legal-review | 隐私/条款发布前法律复核 | 内容定稿 |
| C63_cdn-cache-tuning | 缓存规则细化（HTML 短缓存 + 静态资源长缓存） | 部署完成 + 真实流量 |
| C64_uptime-monitoring | 接入 BetterStack / UptimeRobot 监控 | 部署完成 |
| C65_hsts-preload | 提交 HSTS preload | 部署完成 + 1 个月稳定期 |

---

## 12. 速查

```bash
# DNS 查询
dig yinghua.zzw4257.cn +short
dig www.yinghua.zzw4257.cn +short

# HTTPS 状态
curl -sI https://yinghua.zzw4257.cn | head -10

# HSTS header
curl -sI https://yinghua.zzw4257.cn | grep -i strict-transport

# 缓存命中
curl -sI https://yinghua.zzw4257.cn | grep -i cf-cache

# 性能
curl -o /dev/null -s -w "TTFB: %{time_starttransfer}s\nTotal: %{time_total}s\n" https://yinghua.zzw4257.cn

# 证书检查
echo | openssl s_client -servername yinghua.zzw4257.cn -connect yinghua.zzw4257.cn:443 2>/dev/null | openssl x509 -noout -dates
```

---

## 13. 文档版本

**v1.0** · 2026-08-24
作者：zzw4257 · 映话 (Yìnghuà) 团队

---

## 14. 相关文档

- [`../C29_marketing-website/deploy/wrangler.toml`](../C29_marketing-website/deploy/wrangler.toml) — Pages 配置
- [`../C29_marketing-website/deploy/README.md`](../C29_marketing-website/deploy/README.md) — 部署包说明
- [`../C29_marketing-website/deploy/public/_headers`](../C29_marketing-website/deploy/public/_headers) — 安全头
- [`../C29_marketing-website/deploy/public/_redirects`](../C29_marketing-website/deploy/public/_redirects) — i18n 路由
- [`../C29_marketing-website/README.md`](../C29_marketing-website/README.md) — 站点源 README
- [Cloudflare Pages 官方文档](https://developers.cloudflare.com/pages/)
- [Cloudflare DNS 文档](https://developers.cloudflare.com/dns/)
- [HSTS Preload](https://hstspreload.org/)
