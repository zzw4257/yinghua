# C07 — App Icon V3 探索

**日期**：2026-08-22
**阶段**：品牌第一触点 · 3 变体方向
**基础**：C02 v2（双环/∞ 形）+ C05/C06 已落地的 Y 字形（活跃方向）

---

## ⚠️ 与 V2 的关键不一致

C02 v2 (`brand-app-icon-v2__260822.jpg`) 是一个**双环 / 类 ∞ / 聊天气泡** 形 mark，与 C05 / C06 实际在所有产品图里使用的 **Y 字形**完全不同。

V3 探索基于**已落地的 Y 方向**（因为 C05/C06 全部产品图都用 Y，包括 Dock 11 图标里的映话位置）。如果团队想回归 V2 的双环方向，需在 V4 重新启动。

---

## 3 个变体

| 变体 | 文件 | 调性 | 与 C06 一致性 |
|------|------|------|---------------|
| **01 MINIMAL** | `01-minimal-letterform/app-icon-v3a-minimal__260822.png` | 极简字形 · 黑底白 Y · Apple Notes 风格 | 与 v3 5 张产品图 Dock 里的 Y 一致 |
| **02 GRADIENT** | `02-gradient-fill/app-icon-v3b-gradient__260822.png` | 渐变 Y · 紫青渐变填充 · Apple Music 风格 | 与 v3 5 张产品图里的紫青品牌色一致 |
| **03 GLASS** | `03-glass-orb/app-icon-v3c-glass-orb__260822.jpg` | 玻璃容器 · Y 在玻璃球里 · macOS Sonoma widget 风格 | 与产品图 glass 主题一致 |

**对比图**（3 个并排 + 标签）：`app-icon-v3-comparison__260822.jpg`

---

## 调性对比

| 维度 | 01 MINIMAL | 02 GRADIENT | 03 GLASS |
|------|------------|-------------|----------|
| 颜色饱和度 | 极低（黑+白）| 中（紫青）| 中-高（紫青 + 玻璃高光）|
| 视觉重量 | 轻 | 中 | 重 |
| Apple-restrained | ★★★★★ | ★★★★ | ★★★ |
| 品牌识别度 | 中（白 Y）| 高（紫青品牌色）| 中（玻璃+白 Y）|
| 与 v3 产品图连贯性 | 高（同样 Y 形）| 高（同样紫青）| 中（多一层玻璃）|
| Dock 16x16 缩略可读性 | ★★★★★ | ★★★★ | ★★★ |
| Marketing 出片力 | 中 | 高 | 高 |

---

## 选型建议

| 用途 | 推荐 |
|------|------|
| 严肃 / 专业 / Apple 原生派 | **01 MINIMAL** |
| Marketing / landing hero / social 出海 | **02 GRADIENT** |
| 想要差异化 / Sonoma widget 感 | **03 GLASS** |
| 备选 | 01 为主，02 渐变作为 marketing 变体（很多 Apple app 这样做：系统里用极简版，App Store 截图用渐变版）|

**我的推荐**：01 MINIMAL 作为主 icon（Apple 克制、缩略图友好、与 v3 产品图连贯），02 GRADIENT 留作 marketing 专用版本（landing / Product Hunt / Twitter banner）。03 GLASS 太"装饰"了，对 v3 调性反而不利。

## ✅ 定调（2026-08-22 用户确认）

**01 MINIMAL（黑底白 Y）= 主 icon**
**02 GRADIENT（紫青渐变 Y）= marketing 专用变体**

具体应用场景：
- 系统内 / Dock / Finder / App Switcher → 01 MINIMAL
- App Store 图标（1024x1024）→ 01 MINIMAL
- Landing page hero / Product Hunt 缩略图 / Twitter banner / 营销邮件 → 02 GRADIENT
- 03 GLASS 不采纳（偏离 v3 调性）

---

## V1 已知问题（Figma 修复清单）

| 位置 | 问题 | 修复 |
|------|------|------|
| `app-icon-v3-comparison__260822.jpg` | 标签下方出现"SF Pro 14pt 500"和"color #6B6B72"（prompt 规则泄漏）| Figma 删除这两行，仅保留"01 MINIMAL / 02 GRADIENT / 03 GLASS" |
| 02 GRADIENT 的 Y | 中间两臂与竖笔交汇处有视觉小缝（不是合并成一个连续 Y）| 矢量重绘时确保三笔合一 |
| 03 GLASS 的 Y | Y 在玻璃球内显得略小（占 orb 不到 50% 高度）| 重绘时 Y 撑满 orb 60-65% 高度 |
| 全部 | Y 字体粗细略不统一 | Figma 用同一 Y master 形状，不要每张单独画 |

---

## 候选 C08 方向（待用户选）

| 方向 | 描述 | 价值 |
|------|------|------|
| **a. 继续 icon 优化** | 用 C07 选出的 1 个方向，做 3 种尺寸（16x16 / 64x64 / 1024x1024）矢量精修 | icon 准备导出可用资产 |
| **b. 浅色 macOS 模式全套** | 5 张 v3 重出一遍浅色版 | 覆盖一半 macOS 用户 |
| **c. Onboarding 3 屏流** | 补 onboarding 后两屏（权限 + BYOK）| 首启体验完整 |
| **d. Twitter 3:1 banner** | social 出海素材 | 产品 marketing 出海 |
| **e. Browser extension 入口** | Zoom/Meet 页面气泡截图 | 第二大使用场景 |
| **f. 收口 → D1 design doc** | 收 C06 + C07，写 design doc.md（master block）| Round 1 收口，准备 Round 2 |

---

## 文件清单

```
C07_app-icon-v3/
├── README.md  ← 本文件
├── app-icon-v3-comparison__260822.jpg  ← 3 个并排对比
├── 01-minimal-letterform/
│   ├── _prompt.txt
│   └── app-icon-v3a-minimal__260822.png
├── 02-gradient-fill/
│   └── app-icon-v3b-gradient__260822.png
└── 03-glass-orb/
    ├── _prompt.txt
    └── app-icon-v3c-glass-orb__260822.jpg
```

---

## 出图记录

| 图 | 生成时间 | node_id | 备注 |
|----|----------|---------|------|
| v3a minimal | 23:11 | 433771450503274 | 1:1 单图，retry 1 次 |
| v3b gradient | 23:12 | 433772902297878 | 1:1 单图 |
| v3c glass orb | 23:14 | 433772809109796 | 1:1 单图 |
| comparison | 23:17 | 433772902297894 | 1:1 拼版（3:1 多次失败，转 1:1）|

策略：3:1 长图 2 次连续失败（后端 500），1:1 通过；最终改用 1:1 内含 3 图横排。
下载：wget --timeout=120 --tries=2。
