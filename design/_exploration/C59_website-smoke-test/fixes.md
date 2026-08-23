# C59 — 映话 Marketing Website Broken Link & Fix List

> 任务：**仅 smoke test，不修改任何 HTML/CSS/JS**。本文件是**给后续 worker 的 fix 工单**，不阻塞当前 C29 部署。
> 来源：`smoke-test-report.md` 第 7 节。

---

## Fix 清单（按优先级）

### 🔴 P0 — 无（核心链路全 200，无 broken HTML/asset）

### 🟠 P1 — SEO/i18n 元数据

#### 1.1 缺 `hreflang` alternate link（18/18 HTML）

**问题：** 搜索引擎无法识别 zh-Hans 与 ja-JP 是同一文档的不同语言版本。
**文件：** `index.html`、`features.html`、`pricing.html`、`download.html`、`privacy.html`、`terms.html`、`zh-Hans/*.html` (6)、`ja-JP/*.html` (6)，共 18 个文件。
**推荐加在 `<head>`：**

```html
<!-- root index.html（中文） -->
<link rel="alternate" hreflang="zh-Hans" href="https://yinghua.zzw4257.cn/" />
<link rel="alternate" hreflang="ja-JP" href="https://yinghua.zzw4257.cn/ja-JP/" />
<link rel="alternate" hreflang="x-default" href="https://yinghua.zzw4257.cn/" />

<!-- ja-JP/index.html -->
<link rel="alternate" hreflang="zh-Hans" href="https://yinghua.zzw4257.cn/" />
<link rel="alternate" hreflang="ja-JP" href="https://yinghua.zzw4257.cn/ja-JP/" />
<link rel="alternate" hreflang="x-default" href="https://yinghua.zzw4257.cn/" />
```

> 实际域名需 C29 部署 owner 确认；如无独立 ja-JP/ 路径，hreflang 可指向 `/#ja`。

#### 1.2 缺 `canonical` link（18/18 HTML）

**问题：** 同一内容可能在 `/` 和 `/zh-Hans/` 两路径下被索引。
**推荐：**

```html
<!-- root / zh-Hans HTML -->
<link rel="canonical" href="https://yinghua.zzw4257.cn/" />

<!-- ja-JP HTML -->
<link rel="canonical" href="https://yinghua.zzw4257.cn/ja-JP/" />
```

#### 1.3 缺 `og:locale` / `og:locale:alternate`（18/18 HTML）

**问题：** Facebook / Twitter / LinkedIn 等抓 og 标签时拿不到语言。
**推荐：**

```html
<meta property="og:locale" content="zh_CN" />
<meta property="og:locale:alternate" content="ja_JP" />
```

> ja-JP 页面则把 `og:locale` 写 `ja_JP`，`og:locale:alternate` 写 `zh_CN`。

---

### 🟡 P2 — UX 缺口

#### 2.1 缺语言切换器

**问题：** 站内没有 zh-Hans ↔ ja-JP 互链，访问者必须改 URL 才能切语言。
**文件：** 全部 18 HTML 的 nav 区。
**建议：** 在 header 加一个小尺寸的 locale switcher（中文 ⇄ 日本語），链接到对应 locale 的相同页面（如 `index.html` ↔ `ja-JP/index.html`）。

---

### 🟢 P3 — 生产 hygiene

#### 3.1 缺 `robots.txt`

**文件：** `deploy/public/robots.txt`（不存在）
**推荐内容：**

```
User-agent: *
Allow: /

Sitemap: https://yinghua.zzw4257.cn/sitemap.xml
```

#### 3.2 缺 `sitemap.xml`

**文件：** `deploy/public/sitemap.xml`（不存在）
**建议：** 包含 3 个 locale × 6 页面 = 18 个 `<url>`，每个带 `<xhtml:link rel="alternate" hreflang="...">`。可与 Fix 1.1 一起做。

#### 3.3 缺 `favicon.ico`

**文件：** `deploy/public/favicon.ico`（不存在）
**影响：** 旧 Edge / IE / 部分爬虫会拿不到 icon。Apple 设备用 `apple-touch-icon`（当前是 `icon-02-gradient-128.png`）即可。
**建议：** 把 `favicon.png` 转一份 `.ico` 丢进根目录，或在 HTML 加：

```html
<link rel="icon" type="image/x-icon" href="/favicon.ico" />
<link rel="icon" type="image/png" href="/favicon.png" />
```

---

### 🟢 P3.5 — 部署 / 响应式 polish

#### 3.4 `/index.html 200` 建议改 301

**文件：** `deploy/public/_redirects` 第 1 行。
**当前：**

```
/ /index.html 200
```

**建议改为：**

```
/ /index.html 301
```

**原因：** 200 重写会让首页 canonical 与 URL 不一致，影响 SEO 权重集中。

#### 3.5 1440 断点缺失

**文件：** `assets/css/main.css`（目前只有 1024/768/480 三个宽度断点）。
**问题：** 任务规格要求 4 断点（1440/1024/768/480）。1440 缺失。
**建议：** 确认 1440+ 是否需要专门优化大屏体验（如更宽的 hero grid / 多列排版）；如果需要，添加：

```css
@media (min-width: 1440px) {
  /* 大屏优化 */
}
```

如果「1440」仅是设计参考、layout 默认就支持，则视为意图省略，规格描述需要更新。

---

## 本次 smoke test 中**确认无问题**的项目

| 项 | 状态 |
| --- | --- |
| 18 HTML 200 | ✅ |
| 11 类 asset 200（root + zh-Hans + ja-JP × 3 locale） | ✅ |
| `<html lang>` 属性正确 | ✅ |
| `<title>` 中/日/英各自正确 | ✅ |
| `<meta name="description">` 中/日/英各自正确 | ✅ |
| `<meta name="viewport">` 一致 | ✅ |
| `og:type` / `og:title` / `og:description` / `og:image` 存在 | ✅ |
| 紫青品牌色 `#B57BFF` 在 CSS | ✅ |
| `prefers-reduced-motion`（CSS + JS 双层） | ✅ |
| `prefers-color-scheme: light`（暗/亮双模） | ✅ |
| `@media print` 打印样式 | ✅ |
| 文件 UTF-8 编码、字体 stack 完整 | ✅ |
| `zh-Hans/*.html` 与 root byte-identical | ✅（按 C29 设计意图） |
| `ja-JP/*.html` 真正翻译 | ✅ |
| Cloudflare `_redirects` 文件结构正确 | ✅（需部署后验证） |
| Cloudflare `_headers` 文件结构正确 | ✅（需部署后验证） |

---

## 建议的下一步

1. **C59 closeout**：本测试通过，可进 C60（如有）或直接进 C29 部署。
2. **新工单建议**：开 C61（SEO/i18n 元数据补丁），把 P1 三项一起做（hreflang / canonical / og:locale）— 共 18 个文件批量更新。
3. **新工单建议**：开 C62（生产 hygiene），做 robots.txt + sitemap.xml + favicon.ico + `_redirects` 200→301 改 301。
4. **新工单建议（如确认 1440 是遗漏）**：开 C63（1440 断点补齐）。

如果决定 P1 一定要做，**建议在 C29 上线前**完成；P2/P3 可上线后第一周内补。
