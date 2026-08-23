# C29 — Marketing Website

> **映话 (Yìnghuà) 官方网站** · 静态站 · HTML / CSS / JS
> 状态：v1 · 2026-08-24 · Round 3 marketing 出片
> 设计规范：[`design/design-doc.md`](../../design-doc.md) v2.0 (16 章) + [`design/design-tokens.json`](../../design-tokens.json) (117 token)
> 调性：暗色 + 浅色双主题 · Apple 克制 · 紫青品牌色 · 玻璃面

---

## 📦 文件清单

```
website/
├── index.html              # 主页（5 段锚点滚动 + Footer）
├── features.html           # 详细功能页（4 大功能详解 + 隐私）
├── pricing.html            # 详细定价页（3 tier 卡片 + 对比表 + FAQ）
├── download.html           # 下载页（macOS App Store + 系统要求 + 已知问题 + checksum）
├── privacy.html            # 隐私政策（11 章节正式版）
├── terms.html              # 服务条款（14 章节正式版）
├── favicon.png             # 32x32 站点图标（取自 C10 02 GRADIENT）
├── assets/
│   ├── css/
│   │   └── main.css        # 主样式表（CSS custom properties + 19 章）
│   ├── js/
│   │   └── main.js         # 主题切换 + 平滑滚动 + nav 激活态 + FAQ 折叠
│   └── img/
│       ├── hero-typography.png       # Hero 主视觉（取自 C18 landing-hero-typography）
│       ├── icon-02-gradient-32.png   # 导航图标（取自 C10）
│       ├── icon-02-gradient-128.png  # Apple touch icon
│       └── screenshots/
│           ├── 01-meeting.png        # 取自 C23
│           ├── 02-transcript.png
│           ├── 03-summary.png
│           ├── 04-onboarding.png
│           └── 05-empty.png
└── README.md
```

---

## 🎨 设计规范

### 引用关系

| 规范 | 路径 | 用途 |
|------|------|------|
| **D1 master** | `design/design-doc.md` v2.0 | 设计语言、调性、反模式铁律 |
| **D2 tokens** | `design/design-tokens.json` v1.0 | 117 个 W3C DTCG 格式 token |
| **C18 资产** | `_exploration/C18_marketing-landing/` | Hero 主视觉（landing-hero-typography） |
| **C19 资产** | `_exploration/C19_marketing-social/` | Email/social 营销视觉（未直接复用，原始 C19 资产已交付） |
| **C10 资产** | `_exploration/C10_vector-icon/` | 02 GRADIENT Y 标志（32/128 px PNG + SVG master） |
| **C23 资产** | `_exploration/C23_app-store-screenshots/` | 5 张 shippable 应用截图 |
| **C25 资产** | `_exploration/C25_investor-deck-full/` | 注：因 deck 资产未全出，For Teams 区块临时复用 C23 截图替代 |

### 颜色（取自 D2）

- **Brand**：`#B57BFF` 紫 / `#8A5BFF` 紫中 / `#2A1240` 紫深 / `#2DD4BF` 青 / `#0E2A2A` 青深
- **Neutral**：`#0A0A0F` 近黑 / `#1B1D22` 石墨 / `#F4F1EC` 暖白
- **Semantic**：`#FF3B30` 录制红 / `#FF9F0A` 警告橙 / `#34C759` 成功绿
- **主渐变**：`linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)`

### 字体

- **中文**：`Noto Serif SC`（标题 / 引导文案）+ `Noto Sans SC`（正文 fallback）
- **英文**：`Inter Tight`（标题，400-800）+ `Inter`（正文，400-700）
- **等宽**：`JetBrains Mono`（时间码 / metadata / microcopy）
- **引入**：Google Fonts `<link>` + 系统 fallback（`SF Pro Display` / `PingFang SC`）

### 圆角 / 间距 / 动效

- **圆角**：12-16px 卡片 / 14px 窗口 / 50% 圆形
- **间距**：8pt grid (4/8/12/16/20/24/32/40/48/64/96/128)
- **动效**：120-280ms cubic-bezier，prefers-reduced-motion 全部降级
- **玻璃**：`backdrop-filter: blur(40px) saturate(180%)`（仅 nav 顶栏）

### 响应式断点

- **1440+**（默认）— 全功能
- **1024**（laptop）— Hero 改为单列、features 2 列
- **768**（tablet）— 移动 nav 显示、features 1 列
- **480**（phone）— 紧凑间距、CTA 全宽

---

## 🚀 本地开发

```bash
# 进入站点目录
cd design/_exploration/C29_marketing-website/website

# 启动本地服务器（Python 3）
python3 -m http.server 8000

# 或 Node.js
npx serve -p 8000
```

打开 <http://localhost:8000> 即可。

> 任何静态文件服务器都可以。不需要构建步骤，不依赖 Node 模块。

### 推荐本地测试清单

1. ✅ 6 个页面都能正常打开（`index.html` / `features.html` / `pricing.html` / `download.html` / `privacy.html` / `terms.html`）
2. ✅ 暗色 / 浅色 / 自动 三种主题切换正常（右上角太阳/月亮按钮）
3. ✅ 4 个断点都测试（1440 / 1024 / 768 / 375）— Chrome DevTools
4. ✅ prefers-reduced-motion 开启后无 transform 动效
5. ✅ 主页 5 段锚点跳转（Hero / Features / Preview / Teams / Pricing）
6. ✅ 移动端 nav 折叠菜单

---

## 📦 部署

### Vercel（推荐）

```bash
cd design/_exploration/C29_marketing-website/website
npx vercel --prod
```

或通过 Vercel Dashboard 导入 Git 仓库，build 设置：
- **Framework Preset**: Other
- **Build Command**: 留空
- **Output Directory**: `.`

### Netlify

```bash
cd design/_exploration/C29_marketing-website/website
npx netlify deploy --prod --dir=.
```

或通过 Netlify Dashboard：
- **Build command**: 留空
- **Publish directory**: `.`

### Cloudflare Pages

```bash
cd design/_exploration/C29_marketing-website/website
npx wrangler pages deploy . --project-name=yinghua
```

### 自托管

任何支持静态文件的 Web 服务器都可以（Nginx / Apache / Caddy）。把整个 `website/` 目录上传到服务器根目录即可。

### 域名 / HTTPS

将 `yinghua.zzw4257.cn`（或你的域名）的 DNS 指向你的静态托管服务，配置 SSL 证书（Vercel / Netlify / Cloudflare 都自动签发 Let's Encrypt）。

---

## 🔗 与 _exploration/ 已交付资产的关系

| 页面区块 | 复用资产 | 实际文件 |
|---------|---------|----------|
| **Hero 主视觉** | C18 landing-hero-typography | `_exploration/C18_marketing-landing/landing-hero-typography__260824.png` |
| **导航 Logo** | C10 02 GRADIENT Y 32px | `_exploration/C10_vector-icon/icon-02-gradient-32__260823.png` |
| **Apple Touch Icon** | C10 02 GRADIENT Y 128px | `_exploration/C10_vector-icon/icon-02-gradient-128__260823.png` |
| **Favicon** | C10 02 GRADIENT Y 32px | 同上 |
| **产品截图 1-5** | C23 App Store screenshots | `_exploration/C23_app-store-screenshots/01..05-*.png` |
| **For Teams 视觉** | C25 暂缺，用 C23 截图替代 | 03-summary / 02-transcript / 04-onboarding |
| **Feature block 视觉** | C23 App Store screenshots（替代 C19 email heroes） | `_exploration/C23_app-store-screenshots/` 4 张 |

### C25 后续

`_exploration/C25_investor-deck-full/` 目前只输出了 deck-02-problem 一张图。当 C25 后续补齐 team / traction / product / cover 等完整 deck 资产后，可以把 `index.html` 中 "For Teams" 区块的 `teams-visual` 部分替换为 deck 截图。

---

## 🚫 严格 STRICT RULES（已遵守）

- ✅ **无 Bento 框** — 用 Glass card + section 组合，不用 6 宫格
- ✅ **无营销词** — 全文无 "洞察 / 赋能 / 智能化 / 效率提升 / 全局掌控 / AI 驱动"
- ✅ **无 sparkles 装饰** — Hero 没有满天飞 ✨，仅 1 个 REC 红点 pulse
- ✅ **无 AI 烧图** — 截图都是真实 macOS app 截图，不用 "AI brain" 假视觉
- ✅ **无 emoji 代替 icon** — 全部用 SF Symbol 风格 inline SVG
- ✅ **无 v1/v2/test 命名** — 文件名直接用 `pricing.html` / `features.html`
- ✅ **中文字体** — Google Fonts Noto Serif/Sans SC + PingFang 系统 fallback
- ✅ **响应式 4 断点** — 1440 / 1024 / 768 / 375
- ✅ **prefers-reduced-motion 降级** — `@media (prefers-reduced-motion: reduce) { ... }`

---

## 📝 内容来源

- 主页文案 / Tagline：自研，遵循 D1 §1 Identity（"为面试而生的 macOS 智能助手"）
- 功能描述：基于 `_exploration/C06_product-v3/` 5 张产品截图 + `_exploration/C22_design-doc-v2/` 设计文档
- 定价结构：基于 C13 SwiftUI scaffold 商业化分析
- 隐私政策 / 服务条款：参考 GDPR / CCPA / 中国《个人信息保护法》要求编制
- 系统要求：参考 `_exploration/C13_swiftui-scaffold/` 的 macOS 26+ 技术约束

---

## 🔄 后续维护

| 任务 | 频率 | 方式 |
|------|------|------|
| 同步 D2 design-tokens | 设计 token 变更时 | 重新生成 CSS 自定义属性块（`main.css` §1） |
| 替换 Hero 视觉 | 营销 campaign 变更时 | 替换 `assets/img/hero-typography.png` 即可，CSS 不用动 |
| 新增功能页面 | 重大功能上线时 | 复制 `features.html` 改 nav active + section id |
| 法律条款更新 | 法规变更 / 业务调整 | 直接编辑 `privacy.html` / `terms.html`，版本号更新 |

---

## 📚 上下游

- **上游**：`design/design-doc.md` v2.0 + `design/design-tokens.json` v1.0
- **下游**：
  - C30 app-store-metadata（引用本 README + 主 CTA 文案）
  - C31 legal（本项目已生成 privacy/terms 模板，C31 同步细化）
  - C32 press-kit（引用本 README + 截图）
  - C36 support-docs（引用本 README + FAQ）

---

**版本**：v1.0 · 2026-08-24
**部署状态**：待部署
**License**：本项目源码 MIT · 截图与设计资产遵循 D1 §15 许可
