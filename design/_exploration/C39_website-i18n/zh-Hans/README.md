# C39 — Marketing Website i18n (zh-Hans)

> **映话 (Yìnghuà) 官方营销网站 · 简体中文版** · 静态站 · HTML / CSS / JS
> 状态：v1 · 2026-08-24 · C39 多语言出片（zh-Hans + ja-JP）
> 源站点：[`../../C29_marketing-website/website/`](../../C29_marketing-website/website/)（共享 CSS / JS / 图片资产）
> 设计规范：[`../../design-doc.md`](../../design-doc.md) v2.0 (16 章) + [`../../design-tokens.json`](../../design-tokens.json) (117 token)
> 调性：暗色 + 浅色双主题 · Apple 克制 · 紫青品牌色 · 玻璃面

---

## 📦 文件清单

```
zh-Hans/
├── index.html              # 主页（5 段锚点滚动 + Footer）· lang="zh-Hans"
├── features.html           # 详细功能页（4 大功能详解 + 隐私）· lang="zh-Hans"
├── pricing.html            # 详细定价页（3 tier 卡片 + 对比表 + FAQ）· lang="zh-Hans"
├── download.html           # 下载页（macOS App Store + 系统要求 + 已知问题 + checksum）· lang="zh-Hans"
├── privacy.html            # 隐私政策（11 章节正式版）· lang="zh-Hans"
├── terms.html              # 服务条款（14 章节正式版）· lang="zh-Hans"
└── README.md               # 本文件
```

> **资产复用**：本目录的 6 个 HTML 全部引用 C29 的共享资源（`../C29_marketing-website/website/assets/...`），包括：
> - `assets/css/main.css` · 主样式表
> - `assets/js/main.js` · 主题切换 + 平滑滚动 + nav 激活态 + FAQ 折叠
> - `assets/img/*.png` · Hero、icon、5 张 App Store 截图
> - `favicon.png` · 站点图标
>
> 这意味着 CSS / JS / 图片的单一更新源仍在 C29，**C39 不会复制这些资源**。

---

## 🈯 文案规范

### 翻译规则

- **保留所有视觉元素**（图片 / 颜色 / 布局 / 字体引用）
- **只翻译文字内容**（标题 / 段落 / 按钮 / label）
- **保留技术术语英文**：API、BYOK、macOS、SwiftUI、Anthropic、OpenAI、Keychain、Whisper
- **不**翻译：
  - 文件名 / 类名 / 路径
  - "Yinghua Inc."（公司实体名）
  - "Yinghua"（产品英文名）
  - `yinghua.zzw4257.cn` 域名
  - 邮箱地址（`team@yinghua.app` 等）
  - 数字（保持原样）
  - 货币符号（¥、$）

### 关键文案

| 项 | zh-Hans 值 |
|----|------------|
| 主标题 | 映话 |
| 副标 | 为面试而生的 macOS 智能助手 |
| 主 CTA | 免费下载 macOS |
| 次 CTA | 先看预览 / 了解功能 / 查看团队方案 |
| 核心标签 | 实时转录 / AI 总结 / 本地优先 / BYOK |
| 品牌双行 | 映话 · Yinghua |
| 副标英文音 | Yìnghuà · Yinghua |
| 价格 | Free ¥0 永久 / Pro $19 月 / Team $49 席位月 |
| 货币 | ¥（人民币） / $（美元） |

---

## 🎨 字体

- **中文标题**：`Noto Serif SC`（400-700）
- **中文正文**：`Noto Sans SC`（400-600）
- **英文标题**：`Inter Tight`（500-800）+ `Inter Display` fallback
- **英文正文**：`Inter`（400-700）
- **等宽**：`JetBrains Mono`（时间码 / metadata / microcopy）
- **引入**：Google Fonts `<link>` + 系统 fallback（`SF Pro Display` / `PingFang SC`）

Google Fonts URL:
```
https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&family=Inter+Tight:wght@500;600;700;800&family=JetBrains+Mono:wght@400;500&family=Noto+Sans+SC:wght@400;500;600&family=Noto+Serif+SC:wght@400;500;600;700&display=swap
```

---

## 🚀 本地开发

```bash
# 进入站点根目录
cd design/_exploration/C29_marketing-website/website

# 启动本地服务器（Python 3）
python3 -m http.server 8000

# 然后浏览器访问
# 中文版：http://localhost:8000/../../C39_website-i18n/zh-Hans/index.html
# 日文版：http://localhost:8000/../../C39_website-i18n/ja-JP/index.html
```

或更简单的方式 — 在 C39 根目录启动服务器：

```bash
cd design/_exploration/C39_website-i18n
python3 -m http.server 8001
# 中文：http://localhost:8001/zh-Hans/index.html
# 日文：http://localhost:8001/ja-JP/index.html
```

### 推荐本地测试清单

1. ✅ 6 个页面都能正常打开
2. ✅ 所有相对路径解析正确（`../C29_marketing-website/website/...`）
3. ✅ CSS 加载正常、字体回退正常、暗色 / 浅色切换正常
4. ✅ 4 个断点都测试（1440 / 1024 / 768 / 375）
5. ✅ 5 张产品截图全部加载成功
6. ✅ 移动端 nav 折叠菜单

---

## 🔗 与 C29 的关系

| 维度 | 处理 |
|------|------|
| **资产所有权** | 所有 CSS / JS / 图片仍在 C29，本目录只引用 |
| **HTML 模板** | 6 个 HTML 与 C29 一一对应（index / features / pricing / download / privacy / terms）|
| **文案内容** | 与 C29 完全一致（C29 本身就是 zh-Hans）|
| **字体** | 沿用 C29 的 Noto Serif SC / Noto Sans SC |
| **颜色 / 间距 / 圆角** | 沿用 C29 → design-tokens.json → CSS 自定义属性 |
| **结构改动** | 无（仅调整资产路径为相对引用）|

> **C29 是单一更新源**。如果需要更新 CSS / JS / 图片，请直接修改 C29；本目录的 HTML 会自动生效。
> 如果需要更新 HTML 内容（文案、布局），请同步修改 C29 和本目录的 12 个文件（zh-Hans + ja-JP）。

---

## 📝 与其他语言版本的关系

| 语言 | 路径 | 字符集 | 主要字体 |
|------|------|--------|----------|
| 简体中文 | `zh-Hans/`（本目录）| 简体中文 | Noto Serif SC / Noto Sans SC |
| 日本語 | [`../ja-JP/`](../ja-JP/) | 日本語 | Noto Serif JP / Noto Sans JP |
| English | 暂未出 | 后续添加 | Inter / Inter Display |

---

## ✅ 验收清单

- [x] 6 个 HTML 页面（index / features / pricing / download / privacy / terms）
- [x] 全部 `lang="zh-Hans"`
- [x] 字体：Noto Serif SC（标题） + Noto Sans SC（正文）
- [x] 品牌：映话 · Yinghua（中文 + 英文双行）
- [x] 主标题：「映话」+ 副标音标：「Yìnghuà · Yinghua」
- [x] 技术术语保留英文：BYOK / API / macOS / SwiftUI / Anthropic / OpenAI / Keychain
- [x] 不翻译：邮箱、域名、文件名、公司实体名
- [x] 与 C29 视觉 1:1 对应
- [x] 引用 C29 资产路径有效
- [x] README.md（本文件）说明完整

---

**版本**：v1.0 · 2026-08-24
**License**：本项目源码 MIT · 截图与设计资产遵循 D1 §15 许可
