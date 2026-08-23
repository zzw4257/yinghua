# C59 — 映话 Marketing Website 本地 Smoke Test Report

**Test scope:** Local serve all 18 HTML pages (en/root + zh-Hans + ja-JP), verify assets, i18n routing, and key content.
**Status:** ⚠️ **READY with caveats** — 18/18 HTML + 所有 asset 全部 200 OK；但发现一组 **SEO/i18n 元数据缺口**（无 hreflang / canonical / og:locale / robots.txt / sitemap.xml），不影响本地 serve，但生产前应补齐。
**Date:** 2026-08-23 09:17 EDT
**Tester:** Mavis worker (branch `mvs_a455333bd03244cc9e6ce346dc4f9afb`)

---

## 1. 测试环境

| 项 | 值 |
| --- | --- |
| OS | macOS 27.0 (build 26A5416b) |
| Python | 3.12.2 (`/opt/homebrew/bin/python3`) |
| Server | `python3 -m http.server 8765`（root 在 `design/_exploration/C29_marketing-website/deploy/public`） |
| curl | 8.7.1 (arm64-apple-darwin) |
| Port | 8765 (TCP LISTEN) |
| Server PID | 32817 |
| HTTP/1.1 | IPv6 (`::1`) |

**重要限制：** `python3 -m http.server` **不解析** Cloudflare Pages 的 `_redirects` / `_headers` 文件——它们只在 Cloudflare Pages 部署后生效。本测试中相关行为只能推断。

---

## 2. 18 HTML 页面状态

**结果：18/18 全部 `200 OK`** ✅

| # | 路径 | 状态 | 字节 | 备注 |
| --- | --- | --- | --- | --- |
| 1 | `/` | 200 | 25781 | 默认中文（root） |
| 2 | `/index.html` | 200 | 25781 | 中文 |
| 3 | `/features.html` | 200 | 18205 | 中文 |
| 4 | `/pricing.html` | 200 | 25893 | 中文 |
| 5 | `/download.html` | 200 | 15501 | 中文 |
| 6 | `/privacy.html` | 200 | 13662 | 中文 |
| 7 | `/terms.html` | 200 | 14268 | 中文 |
| 8 | `/zh-Hans/` | 200 | 25781 | 中文（与 root byte-identical） |
| 9 | `/zh-Hans/index.html` | 200 | 25781 | MD5 `382b36ce...` |
| 10 | `/zh-Hans/features.html` | 200 | 18205 | MD5 与 root features 相同 |
| 11 | `/zh-Hans/pricing.html` | 200 | 25893 | MD5 与 root pricing 相同 |
| 12 | `/zh-Hans/download.html` | 200 | 15501 | MD5 与 root download 相同 |
| 13 | `/zh-Hans/privacy.html` | 200 | 13662 | MD5 与 root privacy 相同 |
| 14 | `/zh-Hans/terms.html` | 200 | 14268 | MD5 与 root terms 相同 |
| 15 | `/ja-JP/` | 200 | 28011 | 日文（真正翻译） |
| 16 | `/ja-JP/index.html` | 200 | 28011 | MD5 `a785ea01...` |
| 17 | `/ja-JP/features.html` | 200 | 20443 | 日文 |
| 18 | `/ja-JP/pricing.html` | 200 | 28778 | 日文 |
| 19 | `/ja-JP/download.html` | 200 | 16965 | 日文 |
| 20 | `/ja-JP/privacy.html` | 200 | 16782 | 日文 |
| 21 | `/ja-JP/terms.html` | 200 | 17991 | 日文 |

> 注：表中 21 行是因为 `/` 路径同时验证了 1 次。**18 个独立文件全部 200。**

### 关键发现

- **`zh-Hans/*.html` 与 `index.html` 等 root 文件 byte-identical**（MD5 一致）。这与任务说明「C29 实际是中文」一致：root 默认就是中文，`/zh-Hans/` 是显式中文路由的副本，**不是 bug**。
- `ja-JP/*.html` 与 root 不同：MD5 不同、字节更大、`<html lang="ja-Jp">`、title/meta description 全部是日文。**真翻译。**
- `/` 和 `/index.html` 都返回中文 title（python http.server 自动 serve `index.html`）。

---

## 3. 关键 Asset 状态

**结果：所有引用 asset 全部 `200 OK`** ✅

| Asset | root | zh-Hans | ja-JP | 字节 |
| --- | --- | --- | --- | --- |
| `assets/css/main.css` | 200 | 200 | 200 (`../assets/...`) | 40975 |
| `assets/js/main.js` | 200 | 200 | 200 (`../assets/...`) | 7440 |
| `assets/img/hero-typography.png` | 200 | 200 | 200 (`../assets/...`) | 7444775 |
| `assets/img/icon-02-gradient-32.png` | 200 | 200 | 200 (`../assets/...`) | 767 |
| `assets/img/icon-02-gradient-128.png` | 200 | 200 | 200 (`../assets/...`) | 3723 |
| `assets/img/screenshots/01-meeting.png` | 200 | 200 | 200 (`../assets/...`) | 4644341 |
| `assets/img/screenshots/02-transcript.png` | 200 | 200 | 200 (`../assets/...`) | 4726666 |
| `assets/img/screenshots/03-summary.png` | 200 | 200 | 200 (`../assets/...`) | 4612596 |
| `assets/img/screenshots/04-onboarding.png` | 200 | 200 | 200 (`../assets/...`) | 4222503 |
| `assets/img/screenshots/05-empty.png` | 200 | 200 | 200 (`../assets/...`) | 4536609 |
| `favicon.png` | 200 | 200 | 200 (`../favicon.png`) | 767 |

> **路径细节：** root 和 zh-Hans HTML 使用相对 `assets/...`；ja-JP HTML 使用 `../assets/...`（向上到 `/public/assets/`）。两套都 resolve 到 200，因为 root `/public/assets/` 完整存在，ja-JP 的 `../` 解析到 root 资源；每个 locale 也各自有完整副本（`zh-Hans/assets/`、`ja-JP/assets/`），**双保险**。

### Asset 资源缺位（不影响本地 serve，但生产/SEO 应补）

| 资源 | 状态 | 影响 |
| --- | --- | --- |
| `favicon.ico` | **404** | 大多数浏览器自动请求 ICO；当前 HTML 用 `favicon.png`（Apple-touch 用），主流浏览器能 fallback，但 IE / 旧 Edge / 一些爬虫期望 `.ico` 存在 |
| `robots.txt` | **404** | SEO：搜索引擎拿不到 crawl 指令。生产环境**必须**补 |
| `sitemap.xml` | **404** | SEO：Google/Bing 拿不到站点地图。生产环境**必须**补 |

> 这三个是「**server 端**」问题，**当前任务范围**（仅测 HTML/asset serve）之外，但应在 C29 部署 checklist 单独标注。

---

## 4. i18n 路由验证

### 4.1 `<html lang="...">` 属性

| Locale | HTML lang | 验证 |
| --- | --- | --- |
| root `index.html` | `zh-Hans` | ✅ |
| `zh-Hans/index.html` | `zh-Hans` | ✅ |
| `ja-JP/index.html` | `ja-JP` | ✅ |

### 4.2 短码重定向（`_redirects`）

```text
/zh /zh-Hans/ 301
/ja /ja-JP/ 301
```

**本地测试：** `/zh` → **404**（python3 http.server 不解析 `_redirects`） ❌
**预期：** Cloudflare Pages 部署后会 301 重定向。**部署验证项，需在生产环境复测。**

### 4.3 默认语言行为

- `/` → 200，返回 root `index.html`（中文）。✅ 符合「C29 实际是中文」。
- `/zh-Hans/` → 200，返回中文（与 root 内容一致）。✅
- `/ja-JP/` → 200，返回日文。✅

### 4.4 跨 locale 导航（**SEO/i18n 缺口**）

- ❌ **无 `<link rel="alternate" hreflang="...">` 标签**（18 个 HTML 中 0 个）
- ❌ **无 `<link rel="canonical">` 标签**
- ❌ **无 `og:locale` / `og:locale:alternate` meta**
- ❌ **无语言切换器**（HTML 内无 zh-Hans ↔ ja-JP 之间的导航链接，访问者无法在站内切语言）
- ❌ **无 hreflang x-default**

**影响：** Google/Bing 不会自动把 zh-Hans 和 ja-JP 页面识别为不同语言的同一文档；可能让搜索引擎在 SERP 选错语言版本。**生产前必须补 hreflang（最低限度）。**

---

## 5. 关键内容验证

| 项 | 期望 | 实际 | 结果 |
| --- | --- | --- | --- |
| `<title>` (root index) | 含品牌「映话」 | `映话 — 为面试而生的 macOS 智能助手` | ✅ |
| `<title>` (zh-Hans index) | 中文 | `映话 — 为面试而生的 macOS 智能助手` | ✅ |
| `<title>` (ja-JP index) | 日文 | `映話 — 面接のための macOS スマートアシスタント` | ✅ |
| `<meta name="description">` (root) | 中文 | 完整含「映话」「macOS 26+」「本地优先」 | ✅ |
| `<meta name="description">` (ja-JP) | 日文 | 完整含「映話」「macOS 26+ ネイティブ」「ローカル優先」 | ✅ |
| `<meta name="viewport">` (3 locales) | `width=device-width, initial-scale=1.0, viewport-fit=cover` | 全部 3 locale 一致 | ✅ |
| `og:type` / `og:title` / `og:description` / `og:image` | 社交分享 | 全部存在，root 用 `assets/img/hero-typography.png` | ✅ |
| 紫青品牌色 `#B57BFF` 在 CSS | 必须 | `main.css` line 13/20/21，定义 `--color-brand-purple-vivid` 和两个 gradient | ✅ |
| 响应式断点 | 1440 / 1024 / 768 / 480 | ⚠️ **仅 1024 / 768 / 480**；缺 1440 | ⚠️ |
| `prefers-reduced-motion` 降级 | 必须 | CSS line 1726 + JS line 188 双层处理 | ✅ |
| `prefers-color-scheme: light` | 深/浅双模 | CSS line 155 | ✅ |
| `@media print` | 打印样式 | CSS line 1746 | ✅ |

### 断点偏差（**SPEC 偏差**）

任务规格写「4 断点（1440 / 1024 / 768 / 480）」。当前 `main.css` 实际只有 3 个宽度断点：

```css
@media (max-width: 1024px) { ... }   /* line 1573 */
@media (max-width: 768px)  { ... }   /* line 1632 */
@media (max-width: 480px)  { ... }   /* line 1685 */
```

**1440 断点缺失。** 影响：1441–∞ 区间没有专门样式（一般 layout 默认即 desktop，无功能性破坏，但若设计有 1440+ 优化大屏体验则会有偏差）。建议确认 1440 断点是有意省略还是遗漏。

---

## 6. `_redirects` / `_headers` 状态

```text
# /workspace/.../deploy/public/_redirects
/ /index.html 200
/zh /zh-Hans/ 301
/ja /ja-JP/ 301
/privacy /privacy.html 200
/terms /terms.html 200
/zh-Hans/privacy /zh-Hans/privacy.html 200
/zh-Hans/terms /zh-Hans/terms.html 200
/ja-JP/privacy /ja-JP/privacy.html 200
/ja-JP/terms /ja-JP/terms.html 200
```

```text
# /workspace/.../deploy/public/_headers
/*
  X-Content-Type-Options: nosniff
  X-Frame-Options: DENY
  Referrer-Policy: strict-origin-when-cross-origin
  Permissions-Policy: microphone=(), camera=(), geolocation=()
  Strict-Transport-Security: max-age=31536000; includeSubDomains; preload
  Content-Security-Policy: default-src 'self'; img-src 'self' data: https:; style-src 'self' 'unsafe-inline' https://fonts.googleapis.com; font-src https://fonts.gstatic.com; script-src 'self'; connect-src 'self'

/assets/*
  Cache-Control: public, max-age=31536000, immutable
```

**注意：** 这些文件**只被 Cloudflare Pages 解析**。python3 http.server 完全忽略。部署到 CF Pages 后才能验证其生效。

> **`/ /index.html 200` 的小建议：** 该规则用 200 而非 301，对 SEO 来说可能让首页和外链分散。建议改为 301。**这是一个潜在 SEO bug**（不在本测试验收范围，但记录）。

---

## 7. Broken Link / 问题清单

| 类别 | 数量 | 文件 | 优先级 |
| --- | --- | --- | --- |
| HTML 404 | **0** | — | — |
| Asset 404（被 HTML 引用） | **0** | — | — |
| Asset 404（未引用，服务器缺失） | 3 | `favicon.ico`、`robots.txt`、`sitemap.xml` | 中（生产前补） |
| hreflang 标签 | **缺失** | 全部 18 HTML | 高（SEO） |
| canonical 标签 | **缺失** | 全部 18 HTML | 中（SEO） |
| og:locale / og:locale:alternate | **缺失** | 全部 18 HTML | 中（社交分享） |
| 语言切换器 | **缺失** | 全部 18 HTML | 中（UX） |
| 1440 断点 | **缺失** | `assets/css/main.css` | 低（需确认意图） |
| `/zh`、`/ja` 短码重定向 | 本地 404 | `_redirects`（CF-only） | 低（部署后即生效） |
| `favicon.ico` 缺位 | 404 | — | 低（现代浏览器 fallback） |

详见 `fixes.md`。

---

## 8. 总评

### ✅ **READY**（带 caveats）

**核心 smoke test 完全通过：**
- 18/18 HTML 全部 200 OK
- 所有 CSS / JS / 图片 / favicon 全部 200 OK
- 3 个 locale 都能独立 serve
- 品牌色、断点（3/4）、reduced-motion、双模、print 全部到位
- og 标签、viewport、lang 属性正常
- i18n 短码 `_redirects` 文件结构正确（CF 部署后即生效）

**需要后续 fix（不在本任务范围，但建议记录在 C29 部署 checklist）：**
1. **高优先（SEO/i18n）：** 补 hreflang、canonical、og:locale 系列标签
2. **中优先（UX）：** 加语言切换器（站内外互链 zh-Hans / ja-JP）
3. **中优先（生产 hygiene）：** 补 `robots.txt` 和 `sitemap.xml`
4. **低优先（polish）：** 评估 1440 断点、`/favicon.ico`、`/index.html 200` 改 301

**本测试无 broken link 阻塞部署。** Local serve 路径完全健康。
