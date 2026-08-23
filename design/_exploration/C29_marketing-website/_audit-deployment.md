# C47 — CF Pages Deployment 独立审计
**审计人**：verifier
**日期**：2026-08-23
**审计依据**：D1 + prior audits (C29, C39_website-i18n)

## 检查项

### 1. wrangler.toml
- **name = "yinghua-marketing"** ✓
- **compatibility_date = "2026-08-01"** ✓
- **pages_build_output_dir = "./public"** ✓
- **[build] command** = echo 占位（静态 HTML 无构建步骤）✓
- **[vars] CLOUDFLARE_PAGES_BRANCH = "main"** ✓
- **行数**：9 行，简洁无冗余 ✓

### 2. public/_redirects
- **8 redirect rules** ✓
- **`/` → `/index.html 200`** —— 根路径 SPA-style 重写（CF Pages 行为，200 = server-side rewrite 不改 URL）✓
- **语言 fallback**：`/zh` → `/zh-Hans/ 301` · `/ja` → `/ja-JP/ 301` ✓
- **privacy + terms 跨语言**：`/privacy` / `/terms` / `/zh-Hans/privacy` / `/zh-Hans/terms` / `/ja-JP/privacy` / `/ja-JP/terms` —— 共 6 条，全部 `200` rewrite ✓
- **注释**（line 1）：诚实说明根 fallback 是中文版（因为 C29 内容实际是中文）✓

### 3. public/_headers
- **`/*` 全局 headers**:
  - `X-Content-Type-Options: nosniff` ✓
  - `X-Frame-Options: DENY` ✓
  - `Referrer-Policy: strict-origin-when-cross-origin` ✓
  - `Permissions-Policy: microphone=(), camera=(), geolocation=()` —— 显式禁用三方/相机/定位 ✓
  - `Strict-Transport-Security: max-age=31536000; includeSubDomains; preload` ✓
  - `Content-Security-Policy: default-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; script-src 'self'; connect-src 'self'` —— 与 marketing site 实际资源（Google Fonts + self img）匹配 ✓
- **`/assets/*` Cache-Control**: `public, max-age=31536000, immutable` —— 1 年强缓存，对 immutable 哈希资产正确 ✓
- **CSP 严格度评估**：`connect-src 'self'` 阻断外发请求（marketing site 自身不需要）✓；`script-src 'self'` 无 `'unsafe-inline'`（无 inline script）✓；`style-src 'unsafe-inline'` 接受（设计系统 inline style 不可避免）✓
- **行数**：10 行，结构清晰

### 4. .github/workflows/deploy.yml
- **name**: "Deploy to Cloudflare Pages" ✓
- **触发**：push to main + paths 限定（`C29/**` + `C39_website-i18n/**` + `deploy/**`）—— 改其他路径不触发（节省 CI）✓
- **timeout-minutes**: 15 ✓
- **Build deploy bundle** (line 16-38):
  - 复制 C29 静态站 → `deploy/public/` ✓
  - 复制 C39 zh-Hans + ja-JP 翻译 → `deploy/public/{zh-Hans,ja-JP}/` ✓
  - **sed 路径修复** (line 25-27): ja-JP 源文件用 `../C29_marketing-website/website/...` 相对路径，sed 改写为 `../`（locale self-contained）—— 显式处理了 C39 跨目录引用的隐患 ✓
  - **assets + favicon 复制到子 locale** (line 30-33): 避免 locale 内 404 ✓
  - **wrangler.toml + _redirects + _headers 复制** (line 36-38) ✓
- **Deploy to Cloudflare Pages** (line 40-47): cloudflare/pages-action@v1 + 4 secret gating（CLOUDFLARE_API_TOKEN / CLOUDFLARE_ACCOUNT_ID / GITHUB_TOKEN）✓
- **缺失**：无 pre-deploy 验证（HTML lint / 链接检查）—— 可接受（marketing site 静态）

### 5. 18 HTML 路径正确性
- **根（6）**：`index.html` / `features.html` / `pricing.html` / `download.html` / `privacy.html` / `terms.html` ✓
- **zh-Hans（6）**：同 6 个 ✓
- **ja-JP（6）**：同 6 个 ✓
- **总计**：6 × 3 = 18 ✓
- **任务要求 18 路径完全匹配** ✓
- **assets/ 子目录**：css / fonts / img / js 全部存在（验证 4 个子目录）✓
- **favicon.png**：根存在 ✓

### 6. 跨文件引用一致性
- `_redirects` 引用的所有目标文件（index/privacy/terms + locale ×3）—— **全部存在于 public/** ✓
- `_headers` `/assets/*` —— public/assets/ 存在 ✓
- deploy.yml paths 触发：`C29_marketing-website/website/**` + `C39_website-i18n/**` + `deploy/**` —— 全部与实际目录布局对齐 ✓

### 7. 关键风险点
- **CSP connect-src 'self'** —— 若日后要加 analytics / Sentry，会被 block —— 这是设计选择（marketing site 不应外发），OK
- **`style-src 'unsafe-inline'`** —— 必要（设计系统 inline style）✓
- **HSTS preload** —— 真要 preload 需提交 hstspreload.org —— 当前只是 header，不影响 ✓

## 关键发现
- **+**：wrangler.toml + _redirects + _headers 三件套完整，CF Pages 部署配置达标 ✓
- **+**：CSP / HSTS / X-Frame-Options / Permissions-Policy 安全 headers 全开 ✓
- **+**：sed 路径修复显式处理 ja-JP 跨目录引用问题 —— 工程细节到位 ✓
- **+**：assets 强缓存 1 年 immutable ✓
- **−（轻微）**：deploy.yml 无 dry-run / preview deploy（PR 不预览，直接 push main 才部署）—— 但 CF Pages dashboard 本身支持 preview branches，是已知能力
- **−（轻微）**：_redirects 没有对 `/pricing` `/features` `/download` 加顶级路径 rewrite（只对 `/privacy` `/terms` 加了）—— 不影响功能，但语义不对称

## 总结
- **VERDICT: PASS**
- 关键发现：CF Pages 部署配置完整（wrangler + redirects + headers + workflow），18 HTML 路径全在，安全 headers 严格。部署到 CF 即可上线。
- 建议：补 PR preview deploy（用 cloudflare/pages-action@v1 的 `wrangler pages deploy --branch` 或加 `pull_request` trigger 到 preview environment）。

## 等级
- **PASS**：可用，无阻塞。
