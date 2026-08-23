# 映话 Press Kit 使用指南

## 这是什么
映话 (Yìnghuà / Yinghua) 的 press kit — 一次性发给记者、媒体、投资人的资料包。所有资料以本目录 + 已 shippable 的 C-series 资源为准。

## 包含什么

### 本目录
- [`fact-sheet.md`](./fact-sheet.md) — 关键数据速查表（中英对照）
- [`boilerplate.md`](./boilerplate.md) — 3 个长度的公司介绍（50 / 100 / 200 字 · 中英对照）+ 引用规则
- [`one-pager.md`](./one-pager.md) — 1 页 press release（中文 + 英文版）
- [`contact.md`](./contact.md) — 联系方式 + 响应时间 + 素材自助入口

### 引用关系（其他 C-series 资源）
- `../C10_vector-icon/` — **logo**（4 个 SVG + 12 张 PNG · 01 MINIMAL 系统内 + 02 GRADIENT 营销用）
- `../C18_marketing-landing/` — **3 marketing hero** + Product Hunt cover
- `../C19_marketing-social/` — **Twitter banner** + profile + 邮件 hero（社媒素材）
- `../C25_investor-deck-full/` — **10 页投资人 deck**
- `../C30_app-store-metadata/` — **App Store 文案**（复用 boilerplate）
- `../C27_brand-guidelines/` — **品牌书**（引用任何素材前必看）

## 怎么用

### 1. 快速引用（≤ 5 分钟）
直接复制 [`fact-sheet.md`](./fact-sheet.md) 表格。

### 2. 写文章 / 博客（≤ 30 分钟）
按目标渠道长度选用 [`boilerplate.md`](./boilerplate.md)：
- 50 字 → Twitter bio / 邮件签名
- 100 字 → 媒体文章开头
- 200 字 → 媒体 one-pager / 投资人引言

### 3. 发新闻稿（≤ 1 小时）
复制 [`one-pager.md`](./one-pager.md)：
- 改 `[Founder Name]` 为真实姓名
- 改 `2026-08-23` 为发稿日
- 改联系方式中具体占位（如有）
- 选中文版或英文版

### 4. 找 logo
`../C10_vector-icon/`：
- 系统内 / Dock / App Store → **01 MINIMAL**（16×16 仍可识别）
- 营销 / Landing / Twitter / 投资人 deck → **02 GRADIENT**（紫青渐变）
- 16×16 缩略图只能用 01 MINIMAL

### 5. 要更多 / 专访 / 投资人
- 媒体：press@yinghua.app（< 24h）
- 投资人：investors@yinghua.app（< 48h）
- 创始人直接：见 [`contact.md`](./contact.md)

## 不可用（do not）

### 措辞
- ❌ 不用 emoji 代替 icon
- ❌ 不用 "AI 驱动" / "智能" / "革新" / "颠覆" / "极致" / "完美" 等营销词
- ❌ 不用 "赋能" / "洞察" / "智能化" / "效率提升" / "全局掌控" / "重塑"
- ❌ 不用 cyberpunk / 渐变描边 / sparkles / 外发光 / 霓虹
- ❌ 不用 "AI" 字样烧图（icon 验证过模型会乱渲染）

### 视觉
- ❌ 不用 emoji 作为品牌元素
- ❌ 不用渐变描边的 "两圆相交" chat icon 套路
- ❌ 不用星空银河 / 多色霓虹 / 行星背景（除桌面壁纸外）
- ❌ 不用纯白 `#FFFFFF` 作主文字（用 `#F4F1EC` 暖白）
- ❌ 不用 macOS 系统色之外的自定义绿 / 蓝

### 引用
- ❌ 不混用中英文名（首次 `映话 (Yìnghuà / Yinghua)`，后续单选一种）
- ❌ 不省略公司实体名（始终 `Yinghua Inc.`）
- ❌ 不擅自修改 logo 几何或配色（用 C10 原始 SVG）

## 引用规则速查

| 场景 | 写法 |
|------|------|
| 首次出现 | `映话 (Yìnghuà / Yinghua)` 或 `Yinghua (Yìnghuà / 映话)` |
| 后续 | `Yinghua` 或 `映话`（二选一）|
| 公司实体 | 始终 `Yinghua Inc.`（不要简写）|
| 品牌定位 | "macOS 26+ 原生、本地优先的会议 / 面试智能助手" |
| 核心能力 | "系统级录制 / 实时转录 / AI 总结"（三个具体动词）|
| 隐私 | "100% 本地运行 · BYOK · 零数据收集" |

## 维护

- **prose 改动**：以 [`brand-guidelines.md`](../C27_brand-guidelines/brand-guidelines__260824.md) 为真相源
- **logo 改动**：以 [`C10_vector-icon/`](../C10_vector-icon/) 为真相源
- **tokens 改动**：以 [`design/design-tokens.json`](../../design-tokens.json) 为真相源
- 三者改动需同步更新本目录

## 版本

- v1.0 · 2026-08-23 · 初次发布
