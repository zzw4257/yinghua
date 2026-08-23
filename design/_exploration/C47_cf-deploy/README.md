# C47 — 映话 Marketing Website · Cloudflare Pages 部署

> **生产部署配置** · 静态站 · Cloudflare Pages + GitHub Actions
> 状态：v1 · 2026-08-23 · 部署就绪
> 关联产物：C29 (中文版) · C39 (i18n)

---

## ⚠️ 实际语言布局（与最初设计有差异）

原计划 C29 = 英文源版、C39 = i18n 翻译版。**实际 C29 是中文版**（`html lang="zh-Hans"`），C39/zh-Hans 是 C29 的 broken 路径副本，C39/ja-JP 是真日语版（同样 broken 路径）。本次部署按实际内容布局：

| 路径 | 语言 | 来源 | 备注 |
|------|------|------|------|
| `/` | 中文 | C29 | 唯一可用的"默认版"，同时承担 C29 英文 fallback 角色（如果未来要做英文版，直接覆盖根 HTML 即可） |
| `/zh-Hans/` | 中文 | C29 | 与根内容相同。提供显式 zh-Hans 入口（SEO + hreflang） |
| `/ja-JP/` | 日语 | C39/ja-JP | 真实翻译版，相对路径已修复 |

> 📌 **后续任务**：如需英文版，复制 C29 中文版 → 翻译 → 替换 `deploy/public/` 根目录的 6 个 HTML。`zh-Hans/` 子目录可继续承担中文显式入口。

---

## 📦 部署包结构

```
design/_exploration/C29_marketing-website/deploy/
├── wrangler.toml                              # Cloudflare Pages 配置
├── .github/workflows/deploy.yml               # GitHub Actions CI/CD
└── public/                                    # 待部署静态文件（18 HTML + 27 PNG + CSS/JS）
    ├── _redirects                             # Cloudflare Pages 路由规则
    ├── _headers                               # HTTP 安全 + 性能 headers
    ├── index.html                             # 主页（中文）
    ├── features.html
    ├── pricing.html
    ├── download.html
    ├── privacy.html
    ├── terms.html
    ├── favicon.png
    ├── assets/                                # CSS / JS / 9 张图
    │   ├── css/main.css
    │   ├── js/main.js
    │   └── img/
    │       ├── hero-typography.png
    │       ├── icon-02-gradient-32.png
    │       ├── icon-02-gradient-128.png
    │       └── screenshots/01-05-*.png
    ├── zh-Hans/                               # 中文显式入口（与根相同）
    │   ├── index.html
    │   ├── features.html
    │   ├── pricing.html
    │   ├── download.html
    │   ├── privacy.html
    │   ├── terms.html
    │   ├── favicon.png
    │   └── assets/                            # 子目录 assets 独立复制
    └── ja-JP/                                 # 日语版
        ├── index.html                         # 相对路径已修复为 ../assets/ 和 ../favicon.png
        ├── features.html
        ├── pricing.html
        ├── download.html
        ├── privacy.html
        ├── terms.html
        ├── favicon.png
        └── assets/                            # 子目录 assets 独立复制
```

**总大小**：~87 MB（5 张产品截图是主要体积，每个 locale 独立复制 assets = 3×）。

---

## 🚀 一次性配置（Cloudflare 账号 + Pages project）

### 1. 注册 / 登录 Cloudflare
- <https://dash.cloudflare.com/sign-up>（已有账号可跳过）
- 选 Free 套餐即可，Pages 免费额度足够

### 2. 创建 Pages project
- 进入 **Workers & Pages** → **Create application** → **Pages** → **Connect to Git**
- 选择本仓库（`ZJU_archieve/.../2026-8-Interview-dragon`）
- **Project name**：`yinghua-marketing`（决定默认域名 `yinghua.zzw4257.cn`）
- **Build command**：留空
- **Build output directory**：`design/_exploration/C29_marketing-website/deploy/public`
- **Root directory**：（留空，使用仓库根）
- **Environment variables**：无需

> 或者不通过 Git UI，直接后续用 GitHub Actions 推送（见下文）。

### 3. 在 GitHub repo 加 secrets
- `CLOUDFLARE_API_TOKEN`：从 Cloudflare dashboard → **My Profile** → **API Tokens** → **Create Token** → 选 **Edit Cloudflare Pages** template
- `CLOUDFLARE_ACCOUNT_ID`：从 Cloudflare dashboard → **Workers & Pages** → 右下角 **Account ID** 显示

### 4. 域名绑定（yinghua.zzw4257.cn）
- 在 Cloudflare DNS 添加：
  - `CNAME @ → yinghua-marketing.pages.dev`（proxied）
  - `CNAME www → yinghua-marketing.pages.dev`（proxied）
- 然后在 Pages project → **Custom domains** → 添加 `yinghua.zzw4257.cn` + `www.yinghua.zzw4257.cn`

> **重要**：C30 app-store-metadata 引用的 Support URL = `yinghua.zzw4257.cn/support`，本次部署不包含 `/support` 路径（无该页面文件）。**需要在 Cloudflare Pages 加一条 redirect**：`/support → https://github.com/zzw4257/yinghua-support` 或在后续 C36 support-docs 出片后补 `support.html`。

---

## 🔄 自动部署

push 到 `main` 分支（且改动 `C29_marketing-website/website/**`、`C39_website-i18n/**` 或 `deploy/**`）→ GitHub Actions 自动 build + deploy → 1-2 分钟后 `yinghua.zzw4257.cn` 更新。

工作流位置：`design/_exploration/C29_marketing-website/deploy/.github/workflows/deploy.yml`

```yaml
# 触发条件：push to main，且路径在以下范围内
paths:
  - 'design/_exploration/C29_marketing-website/website/**'
  - 'design/_exploration/C39_website-i18n/**'
  - 'deploy/**'
```

**Build 步骤做的事**：
1. 复制 C29 源到 `deploy/public/`（覆盖）
2. 复制 C39/zh-Hans 到 `deploy/public/zh-Hans/`
3. 复制 C39/ja-JP 到 `deploy/public/ja-JP/`
4. **sed 修复 ja-JP 路径**（`../C29_marketing-website/website/` → `../`）— 关键步骤，否则 broken 路径
5. 复制 assets + favicon 到 zh-Hans/ 和 ja-JP/（locale self-contained）
6. 复制 wrangler.toml + _redirects + _headers
7. `cloudflare/pages-action@v1` 推送到 Pages

---

## 🛠️ 本地测试

### 方式 1：Python 内置 server（最简单）

```bash
cd design/_exploration/C29_marketing-website/deploy/public
python3 -m http.server 8000
# 访问 http://localhost:8000
```

### 方式 2：wrangler pages dev（推荐，模拟 Cloudflare Pages 行为）

```bash
# 安装 wrangler
npm install -g wrangler

# 启动本地 Pages dev server
cd design/_exploration/C29_marketing-website/deploy
npx wrangler pages dev ./public
# 访问 http://localhost:8788
# 验证 _redirects 和 _headers 生效
```

### 方式 3：Node serve

```bash
cd design/_exploration/C29_marketing-website/deploy/public
npx serve -p 8000
```

### 推荐本地测试清单

1. ✅ 18 个页面都能正常打开（6 根 + 6 zh-Hans + 6 ja-JP）
2. ✅ 暗色 / 浅色 / 自动 三种主题切换正常（右上角太阳/月亮按钮）
3. ✅ 4 个断点都测试（1440 / 1024 / 768 / 375）— Chrome DevTools
4. ✅ `prefers-reduced-motion` 开启后无 transform 动效
5. ✅ 主页 5 段锚点跳转（Hero / Features / Preview / Teams / Pricing）
6. ✅ 日语版字体（Noto Serif JP / Noto Sans JP）正常加载
7. ✅ Cloudflare Pages dev 测试 `/zh` → 301 → `/zh-Hans/`、`/privacy` → 200 → `/privacy.html`

---

## 🔒 安全 + 性能 Headers

`deploy/public/_headers` 配置了：

| Header | 值 | 作用 |
|--------|----|----|
| `X-Content-Type-Options` | `nosniff` | 阻止 MIME 嗅探 |
| `X-Frame-Options` | `DENY` | 阻止 clickjacking |
| `Referrer-Policy` | `strict-origin-when-cross-origin` | 隐私友好 referrer |
| `Permissions-Policy` | `microphone=(), camera=(), geolocation=()` | 禁用敏感 API（映话不需要） |
| `Strict-Transport-Security` | `max-age=31536000; includeSubDomains; preload` | 强制 HTTPS 1 年，可提交 HSTS preload list |
| `Content-Security-Policy` | `default-src 'self'; img-src 'self' data: https:; ...` | 限制资源来源，禁止 inline script（XSS 防护） |
| `Cache-Control: /assets/*` | `public, max-age=31536000, immutable` | assets 缓存 1 年（带 hash 改名可换 immutable） |

> 当前 CSP 未加 `script-src` 的 `https://www.googletagmanager.com`（如未来用 GA 需加）。`style-src 'unsafe-inline'` 是为了支持 `<style>` 块（如 C39/ja-JP 的 lang 切换 CSS），如要更严可改 nonce 方案。

---

## 🛣️ 路由规则（_redirects）

| 路径 | 目标 | 状态码 | 说明 |
|------|------|--------|------|
| `/` | `/index.html` | 200 | 直接服务（Cloudflare Pages 默认会自动 `/index.html`，这行是显式） |
| `/zh` | `/zh-Hans/` | 301 | 短别名 → 显式中文入口 |
| `/ja` | `/ja-JP/` | 301 | 短别名 → 显式日文入口 |
| `/privacy` | `/privacy.html` | 200 | 不带 .html 友好 URL |
| `/terms` | `/terms.html` | 200 | 同上 |
| `/zh-Hans/privacy` | `/zh-Hans/privacy.html` | 200 | 同上 |
| `/zh-Hans/terms` | `/zh-Hans/terms.html` | 200 | 同上 |
| `/ja-JP/privacy` | `/ja-JP/privacy.html` | 200 | 同上 |
| `/ja-JP/terms` | `/ja-JP/terms.html` | 200 | 同上 |

> 暂未配置 `/zh-Hans/privacy/` 这种带尾斜杠的 variant。如有 SEO 需求可补。

---

## ⚡ 性能预期

- **TTFB**：Cloudflare Pages 全球 CDN（300+ 节点），任意地区 < 100ms
- **HTML 缓存**：1 天（默认，无显式 `Cache-Control`，会走 `s-maxage=300, must-revalidate`）
- **assets 缓存**：1 年（`max-age=31536000, immutable`）— 假设未来通过文件 hash 改名（目前是固定文件名，如果改内容会有缓存问题；如需 atomic deploy，可改用 build step 加 hash）
- **免费额度**：5 万次请求/天、5 GB 带宽/月 — 足够前 6 个月 launch
- **HTTPS**：Cloudflare Pages 自动签发 Let's Encrypt + HSTS preload 资格

---

## 📝 已知限制 / 后续任务

- [ ] **/support 路径缺失** — C30 app-store-metadata 的 Support URL = `yinghua.zzw4257.cn/support`，需要 C36 support-docs 出片后补 `support.html`，或加 `_redirects` 规则转发到 GitHub repo
- [ ] **英文版缺失** — 当前根 / 默认是中文。**长期建议**：复制 C29 → 翻译 → 覆盖 `deploy/public/*.html` 根目录 6 个文件
- [ ] **assets 重复 3 份**（87MB）— 长期可改用 `<base href="/">` 标签统一指向根 assets，省 2/3 体积，但需要改 HTML（当前方案不修改源文件）
- [ ] **HSTS preload 提交** — `_headers` 声明了 `preload`，但需要去 <https://hstspreload.org> 提交 `yinghua.zzw4257.cn` 才能真正进浏览器 preload list
- [ ] **Search engine 收录** — 需在 Cloudflare Pages 加 `_headers` 的 `sitemap.xml`（C32 press-kit 后续可补），并在 Google Search Console 提交

---

## 🔗 上下游

| 上游 | 关系 |
|------|------|
| C29_marketing-website | 提供 6 HTML + assets |
| C39_website-i18n | 提供 ja-JP 翻译（zh-Hans 暂未用，根 + zh-Hans 来自 C29） |
| C30_app-store-metadata | 引用 Support URL = `yinghua.zzw4257.cn/support`（**未实现**） |
| C31_legal | 提供 privacy-policy.md / terms-of-service.md（**未在 deploy bundle 中合并为 HTML**，C29 内部已有更简版） |

| 下游 | 关系 |
|------|------|
| yinghua.zzw4257.cn | 主站（待绑定） |
| App Store 审核 | Support URL 引用 yinghua.zzw4257.cn/support（**待补**） |

---

**版本**：v1.0 · 2026-08-23
**部署状态**：ready（手动上传 deploy/public/ 即上线，CI 触发已配置待 push 到 main）
**License**：MIT
