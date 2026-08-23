# 映话 (Yìnghuà) — Design Doc (Round 1+2+3 收口 v2.0)

> **版本**：v2.0 · 2026-08-23 02:00
> **状态**：Round 1+2+3 全收口 · 准备 Round 4 shippable
> **取代**：v1.0（2026-08-22 22:00 · 11 章 19K）
> **来源**：
> - **Round 1**：C02 brand assets + C03 product narrative + C04 polish + C05 design tokens visual + C06 product v3 (5 终版) + C07 app icon V3
> - **Round 2**：C08 light mode 5 张 + C09 onboarding 后 2 屏 + C10 矢量 icon 收口 + C11 Twitter banner + C12 design-tokens.json (117 token) + C13 SwiftUI scaffold (BUILD SUCCEEDED) + C14 browser extension
> - **Round 3**：C15-C22 shippable 包规划
> **审计依据**：C06 / C07 / C08 / C09 4 个独立 audit verdict（详见 §15 References）
> **变更摘要**：见 [§0](#0-版本--变更摘要-v20-新增)
> **详细 changelog**：[`_exploration/C22_design-doc-v2/CHANGELOG.md`](_exploration/C22_design-doc-v2/CHANGELOG.md)

本文件是映话设计语言的**唯一真相源**。任何 designer / dev 接手都应该从这里开始。所有具体形态引用都用相对路径指向 `_exploration/` 里的资产。

**机器可读真相源**：[`design-tokens.json`](design-tokens.json)（C12 · 117 token · W3C DTCG 格式）。本文件 prose 形式与 token JSON **严格同步**——改 prose 必须同步 token，反之亦然。

---

## 0. 版本 + 变更摘要（v2.0 新增）

### 0.1 v1.0 → v2.0 速览

| 维度 | v1.0 | v2.0 | 增量 |
|------|------|------|------|
| 章节数 | 11 | 15 | +4（§0 / §12 / §13 / §14 / §15）|
| 文件大小 | ~19KB | ~40KB | +110% |
| 反模式 | 12 | 18 | +6 |
| Token 引用 | ~5 prose hex | 117 machine token | +23x |
| 证据路径 | ~10 | 30+ | +3x |
| 实施支撑 | 设计图定调 | 全资产可施工 | Figma + SwiftUI + Extension 都可用 |

### 0.2 4 audit findings 摘要（驱动 v2.0 内容）

| Audit | 总体 verdict | 关键发现 | v2.0 落地 |
|-------|--------------|----------|-----------|
| **C06 product-v3**（5 张深色）| PARTIAL · 9 项 × 5 = 45 检查点 | • 5 张图 Dock 顺序各异（FAIL）<br>• 3/5 张菜单栏缺 app 名（N1）<br>• 04 "STYLE 1" 文字烧入图（N7 HIGH）<br>• 05 品牌 mark 错用 02 GRADIENT（N3 HIGH）<br>• 05 prompt 规则 2 处泄漏（N9 HIGH）<br>• 10+ V1 issue（placeholder / 中文 / 日历 day-name）| §6.2 Dock 12 项锁 · §6.1 菜单栏 app 名 · §7 #13 prompt 规则 · §3.5 浅色版 01 MINIMAL 定义 · §12 P0 修一批 |
| **C07 app-icon-v3**（3 变体）| PARTIAL · 3 变体逐项 A-G | • 02 Y 中间缝（HIGH）<br>• 3 变体不是同一 Y master（HIGH）<br>• 01 右捺有弯（中）<br>• 01/02 笔画粗细不统一（中）<br>• **03 GLASS 真弃用**（§D.4）<br>• 对比图 "SF Pro 14pt" 文字烧图（低）| §3.1 SVG master 路径 · §3.2 5 营销场景 · §3.3 应用规则 10+ 行 · §3.4 ❌ 03 + 旧 v1/v2 mark 全弃 |
| **C08 light-mode**（5 张浅色）| PARTIAL · 10 项 × 5 = 50 检查点 | • 01 meeting 13 处 prompt 规则泄漏（FAIL）<br>• 02 empty 7 处 prompt 规则泄漏（FAIL）<br>• 5/5 Dock 顺序不一致（FAIL）<br>• 5/5 时钟不一致（21:42 / 22:14 / 09:42）<br>• 5/5 日历 day-name 乱码（SUN/MEN/HOR/DON/MAAN）<br>• 浅色 hairline @ 8% 边缘不可见（LR1）<br>• 浅色版 01 MINIMAL 未定义（L7）| §2.5 浅色 hairline 升 @ 12-15% · §3.5 浅色版 01 MINIMAL 定义 · §7 #15 日历 day-name · §12 P0 批量修 |
| **C09 onboarding**（屏 2/3）| PARTIAL → FAIL 边界 · 10 项 × 2 = 20 | • **屏 3 Anthropic "AI" 字母**（FAIL HIGH · D1 §3.4 + §7 明禁）<br>• 3 屏菜单栏缺 app 名（N1 medium）<br>• 3 屏 Dock 第 5 位错（N2 medium）<br>• 3 屏日历 day-name 乱码 "NEN" / "MEM" / "ПАН"（N3）<br>• Custom card icon 是 "node" 文字（V1-P3-3 low）| §6.1 菜单栏 app 名 · §6.2 Dock 第 5 位 = Notes 锁定 · §7 #14 品牌名烧图 · §12 P0 屏 3 Anthropic icon |

### 0.3 Round 1+2+3 关键决策（沉淀到 v2.0 各章）

详见 [CHANGELOG §"Round 1+2+3 关键决策"](./_exploration/C22_design-doc-v2/CHANGELOG.md#round-123-关键决策沉淀到-v20)。15 条决策已经散落到 §2 / §3 / §6 / §7 / §9 对应位置。

### 0.4 阅读路径

- **Designer / Figma 同学**：先读 §2 / §3 / §4 / §6 / §7 / §12
- **SwiftUI dev**：先读 §2 / §4 / §9 / §10（§10 有 C13 BUILD SUCCEEDED 证据）
- **Chrome extension dev**：先读 §3（C10 SVG master）/ §4 组件 / §14（C21 代码）
- **下次 audit 的人**：先读 §0 / §10 / §15（4 audit verdict 路径）

---

## 1. 身份（Identity）

| 字段 | 值 |
|------|----|
| 产品名 | 映话（Yìnghuà）|
| 英文名 | Yinghua |
| 一句话定位 | macOS 26+ 原生、本地优先的会议 / 面试智能助手 |
| 平台 | macOS 26+（Tahoe）· SwiftUI 6 + AppKit 互操作 |
| 形态 | 单一桌面 app（无 companion app、无 web dashboard）|
| 数据策略 | 本地优先 · 高级 BYOK（自备 OpenAI / Anthropic key）|
| 核心能力 | 系统音频 + 麦克风录制 · 实时转录（说话人分离）· AI 总结（关键时刻 / 决定 / 待办 / 遗留问题）|
| 第二大入口 | Chrome extension（用户已在 Zoom / Meet 网页开会时浮窗）|

### 调性主轴

> **Apple 克制 + 极光紫作 accent。** 不是 cyberpunk，不是 SaaS landing page，不是 AI hype。是一个"会出现在你 Dock 里，每天你都会打开几次"的 macOS app。

---

## 2. 视觉语言（Visual Language）

### 2.1 配色

**主色（brand / aurora gradient）**

| 名称 | Hex | 用途 | Token 路径 |
|------|-----|------|-----------|
| 紫 (vivid) | `#B57BFF` | Primary button 渐变起、speaker avatar A | `color.brand.purple-vivid` |
| 紫 (mid)   | `#8A5BFF` | 渐变中段、focus ring | `color.brand.purple-mid` |
| 紫 (deep)  | `#2A1240` | 玻璃暗色背景 wash、recording active dot 备用 | `color.brand.purple-deep` |
| 青 (vivid) | `#2DD4BF` | Primary button 渐变终、speaker avatar B | `color.brand.teal-vivid` |
| 青 (deep)  | `#0E2A2A` | 玻璃暗色背景 wash | `color.brand.teal-deep` |

**主渐变公式**：`linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)`（C07 02 GRADIENT 与 C06 05 onboarding CTA 完全一致）

**功能色（semantic）**

| 名称 | Hex | 用途 | Token 路径 |
|------|-----|------|-----------|
| 录制红 | `#FF3B30` | REC 红点、end-call 按钮、停止按钮 | `color.semantic.recording-red` |
| 警告橙 | `#FF9F0A` | 麦克风静音、电池警告 | `color.semantic.warning-orange` |
| 成功绿 | `#34C759` | macOS 系统色（沿用，不自定义）| `color.semantic.success-green` |
| 危险红 | `#FF453A` | macOS 系统色（沿用）| `color.semantic.danger-red` |
| Magenta active | `#E63FB8` | Dock Y 下方活动点（仅系统级）| `color.app-state.magenta-active` |

**中性色（neutrals）**

| 名称 | Hex | 用途 | Token 路径 |
|------|-----|------|-----------|
| 近黑 | `#0A0A0F` | App icon 主背景、splash | `color.neutral.near-black` |
| 石墨 | `#1B1D22` | 窗口深色底 | `color.neutral.graphite` |
| 玻璃深 | `#0A0A0F` @ 70% opacity | 玻璃 vibrancy base | `color.neutral.glass-deep` |
| 暖白 | `#F4F1EC` | 主文字（warm white，避免纯白刺眼）| `color.neutral.warm-white` |
| 次白 | `#F4F1EC` @ 80% | 次要文字 | `color.neutral.secondary` |
| 静音白 | `#F4F1EC` @ 60% | tertiary 文字、占位符 | `color.neutral.tertiary` |
| 灰边 | `rgba(244, 241, 236, 0.08)` | 1px hairline border（深色模式）| `color.neutral.hairline` |
| 灰边（浅色）| `rgba(27, 29, 34, 0.12)` | 1px hairline border（浅色模式，C08 LR1 修正）| `color.neutral.hairline-light` |

> 文字色不要用纯白 `#FFFFFF`（刺眼）。`#F4F1EC` 是 Apple Notes 主文字色，温暖耐看。
>
> ⚠️ **v2.0 浅色 hairline 修正**：C08 audit LR1 发现深色版 `@ 8%` hairline 在浅色 cream wallpaper 上几乎不可见（白底 + 灰边对比度太低）。**浅色模式统一用 `@ 12-15%` 黑**。C12 token JSON v1.1.0 起新增 `color.neutral.hairline-light`。
>
> ⚠️ **C12 design-tokens.json 是 ground truth**。所有 hex / px / ms 都以 [design-tokens.json](./design-tokens.json) 为准；prose 改色必须同步改 token。详见 [C12 README §8 维护规则](./_exploration/C12_design-tokens/README.md#8-维护规则)。

### 2.2 字体

| 用途 | 字体 | 字重 | Token 路径 |
|------|------|------|-----------|
| 大标题（≥24pt）| SF Pro Display | 600 / 700 | `typography.font-family.display` + `font-weight.semibold` |
| 正文（≥14pt）| SF Pro Text | 400 / 500 | `typography.font-family.text` + `font-weight.regular` |
| 等宽（时间码 / ID）| JetBrains Mono | 500 | `typography.font-family.mono` |
| 中文（叙事段落 / 副标题）| Noto Serif SC | 400 / 600 | `typography.font-family.serif-zh` |
| 中英混排正文 | SF Pro Text 中文 fallback Noto Sans SC | 400 | `typography.font-family.sans-zh` |

中文优先：所有用户可见的标点、按钮、标签、bullet 都用中文。英文仅出现在：技术术语（API / BYOK / Live transcript）、品牌名（Yinghua）、占位符文案（待 Figma 替换）。

### 2.3 圆角

| 元素 | 圆角 | Token 路径 |
|------|------|-----------|
| 窗口 | 14px（macOS 标准）| `radius.window` |
| App icon | 22.4%（squircle superellipse）| `radius.icon-squircle` |
| 按钮（primary / secondary）| 12px | `radius.button` |
| 按钮（icon button 圆形）| 50%（圆形）| `radius.circle` |
| 按钮（toggle pill）| 50%（胶囊）| `radius.circle` |
| Card / 文件卡 | 12-16px | `radius.card` / `radius.card-lg` |
| 输入框 | 8px | `radius.input` |
| Avatar | 50%（圆形）| `radius.circle` |
| Section header chevron | 6px | `radius.chevron` |

### 2.4 间距

8pt grid。所有 padding / margin / gap 都是 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 的整数倍。详见 [design-tokens.json `spacing`](./design-tokens.json) — 10 个 token。

### 2.5 玻璃与材质

| 材质 | 用法 | Token 路径 |
|------|------|-----------|
| `.regularMaterial` (NSVisualEffectView) | 主窗口背景（vibrancy）| `material.regular` |
| `.popoverMaterial` | 浮层、tooltip、菜单 | `material.popover` |
| `.sidebarMaterial` | 侧栏（如有）| `material.sidebar` |
| **`.ultraThinMaterial`** | **❌ FORBIDDEN** | `material.ultraThin.value = "FORBIDDEN"` |
| 自绘暗色 wash | 玻璃上方叠加一层 aurora tint（紫 → 青，~15% opacity）| `color.glass.aurora-wash` |

**双层防御（C12 §6.3）**：
1. `material.ultraThin.value = "FORBIDDEN"`（token 显式标 FORBIDDEN，dev 查 token 一眼看到）
2. `forbidden-patterns.NO_ULTRA_THIN_GLASS.value = "forbidden"`（规则 section 记录）

无论从哪个入口查（Style Dictionary / Tokens Studio / 手翻 JSON），都能看到禁用标记。

**浅色模式规则**（C08 audit LR1）：
- 深色模式 hairline：`rgba(244, 241, 236, 0.08)`（暖白 @ 8%，深色背景上可见）
- 浅色模式 hairline：`rgba(27, 29, 34, 0.12)`（石墨 @ 12%，浅色背景上可见，对比度提升 50%）
- 浅色模式 aurora wash 强度：10%（深色是 15% — 浅色底色已经亮，wash 过强会脏）

玻璃不要滥用：**只有窗口、浮层、卡片需要玻璃**。文字行内不套玻璃。Dock 已经是系统玻璃，不需要再叠。

### 2.6 动效

| 场景 | 动效 | Token 路径 |
|------|------|-----------|
| 窗口出现 | scale 0.96 → 1.0 + opacity 0 → 1，250ms ease-out | `motion.duration.slow` + `motion.easing.ease-out` |
| 按钮 hover | scale 1.0 → 1.02，120ms spring | `motion.duration.fast` + `motion.easing.spring` |
| 按钮 press | scale 1.0 → 0.98，80ms ease-in | `motion.duration.instant` + `motion.easing.ease-in` |
| 录制开始 | REC 圆点 pulse 1.0 → 1.15 → 1.0，1.4s infinite | `motion.duration.pulse` |
| 折叠段展开 | height 0 → auto，220ms spring，content opacity 跟随 | `motion.duration.normal` + `motion.easing.spring` |
| Dock 图标 bounce | 录制中 Y 图标 4s 一次的微小 bounce（4px amplitude）| `motion.duration.bounce` |
| 一切动效 | 尊重 `prefers-reduced-motion` — 用户开了就全部退化为 fade | `motion.reduce.respect-prefers-reduced-motion = true` |

> ⚠️ **`prefers-reduced-motion` 是铁律，不是 nice-to-have**。C12 token JSON `motion.reduce` 强制标 `respect-prefers-reduced-motion=true`，SwiftUI 用 `@Environment(\.accessibilityReduceMotion)` 检查。详见 [C12 README §3 motion section](./_exploration/C12_design-tokens/README.md#3-跟-d1-2-的对应关系)。

> 动效是表达**关系**，不是装饰。layoutId / camera push 优先，scale / rotate 次之。

### 2.7 浅色模式配色（v2.0 新增）

C08 浅色版 5 张图已落地（PASS 主调性），色彩反转规则如下：

| 元素 | 深色版 | 浅色版 |
|------|--------|--------|
| 桌面壁纸 | 深空 + 极光紫青 wash | 暖白 `#F4F1EC` + 极淡紫青 wash（10%）|
| 菜单栏 | 黑色毛玻璃 + 暖白字 | **白毛玻璃 + 石墨字** |
| Dock | 黑色毛玻璃 | **白色毛玻璃** |
| 窗口背景 | 暗色玻璃 + 紫青 wash @ 15% | **白玻璃 + 10% 紫青 wash** |
| 窗口主文字 | `#F4F1EC` 暖白 | **`#1B1D22` 石墨** |
| 窗口次文字 | `#F4F1EC @ 80%` | **`#1B1D22 @ 65%`** |
| REC 红点 | `#FF3B30` | **`#FF3B30`（不变）** |
| 紫青品牌色 | `#B57BFF → #2DD4BF` | **同（不变）** |
| Primary 按钮 | 紫青渐变 + 白字 | **紫青渐变 + 白字（不变）** |
| Secondary 按钮 | 玻璃深 | **白玻璃 + 1px @ 12% 黑边** |
| 卡片边框 | 1px @ 8% 白 | **1px @ 12% 黑** |

色彩反转 100% 符合 C08 audit §4.2 + D1 §2.1 浅色规则。**Figma 终版用同一份 SwiftUI 代码 + colorScheme adaptive 渲染**。

---

## 3. 图标系统（Iconography）

### 3.1 主 icon（系统内 / Dock / App Store）

**01 MINIMAL — 黑底白 Y**

- 容器：macOS squircle 1024x1024，22.4% 圆角（`rx="229.376"`）
- 背景：纯平 `#0A0A0F`（近黑），可叠 1px 白色 6% opacity 边缘高光
- Y 字：solid `#F4F1EC`（暖白），单 `<path>` master（V+stem 拓扑）
- Y 几何：占 icon 内高 52%，内宽 52%，margin 22%，**笔宽 58px = 5.66%**（C10 audit 修复后统一）
- 拓扑：V（`M 372 256 L 512 416 L 652 256`，三端点汇聚在 `(512,416)`，rounded join + cap 完美重叠，**零接缝**）+ stem（`M 512 416 L 512 768`）
- 笔触：`stroke-linejoin="round"` + `stroke-linecap="round"`，硬直无弯钩

**资产路径**（C10 已 shippable）：
- SVG master：[`_exploration/C10_vector-icon/icon-01-minimal__260823.svg`](./_exploration/C10_vector-icon/icon-01-minimal__260823.svg)
- PNG 多尺寸：`icon-01-minimal-{1024,256,128,64,32,16}__260823.png`
- token 引用：`app-icon.minimal-01.background` = `#0A0A0F` / `app-icon.minimal-01.y-fill` = `#F4F1EC`
- 参考图 v3a：[`_exploration/C07_app-icon-v3/01-minimal-letterform/app-icon-v3a-minimal__260822.png`](./_exploration/C07_app-icon-v3/01-minimal-letterform/app-icon-v3a-minimal__260822.png)

### 3.2 备用 icon（marketing / social）

**02 GRADIENT — 紫青渐变 Y**

- 容器：同 squircle
- 背景：`#0A0A0F` 底 + 15% 紫青 wash（aurora gradient）
- Y 字：同 SVG master，**仅 stroke 改 `url(#yGradient)`**（vivid 紫 → mid 紫 → vivid 青，对角线 135°）
- 渐变：`<linearGradient id="yGradient" x1="0" y1="0" x2="1" y2="1">` 紫 `#B57BFF` → 紫 `#8A5BFF` → 青 `#2DD4BF`

**资产路径**（C10 已 shippable）：
- SVG master：[`_exploration/C10_vector-icon/icon-02-gradient__260823.svg`](./_exploration/C10_vector-icon/icon-02-gradient__260823.svg)
- PNG 多尺寸：`icon-02-gradient-{1024,256,128,64,32,16}__260823.png`
- token 引用：`app-icon.gradient-02.y-fill` = `linear-gradient(135deg, #B57BFF, #8A5BFF, #2DD4BF)`

**Marketing 用途**（C07 §F + C11 落地）：

| 场景 | 用 | 备注 |
|------|----|------|
| **Landing hero** | 02 GRADIENT | 紫青渐变视觉冲击力强，与 05 onboarding 大 Y mark 形成"产品内 Y = marketing Y"一致性 |
| **Product Hunt 缩略图**（240×240）| 02 GRADIENT | 渐变仍可见，紫青对比在 PH 列表"跳出来" |
| **Twitter / X header**（3:1）| 02 GRADIENT | social 出海一眼能记住，参考 [C11 twitter-banner-3-1__260823.png](./_exploration/C11_twitter-banner/twitter-banner-3-1__260823.png) |
| **Twitter profile 1:1** | 02 GRADIENT | 参考 [C11 twitter-profile-1-1__260823.png](./_exploration/C11_twitter-banner/twitter-profile-1-1__260823.png) |
| **投资人 deck 第一页** | 02 GRADIENT | 紫青 = 科技感 + Apple 克制 |
| **营销邮件 banner** | 02 GRADIENT | 同上 |

### 3.3 应用规则（C10 §5 + C07 audit §F 合并）

| 场景 | 用 | 理由 |
|------|----|------|
| App icon `.icns` | **01 MINIMAL** | 主 icon；强对比保证 16×16 Dock 缩略可读（C07 §E.1）|
| Dock 16×16 / 32×32 / 64×64 | **01 MINIMAL** | 02 在 16×16 渐变压缩为单色，Y 形状变模糊（C07 §E.1）|
| Finder 列表 / sidebar | **01 MINIMAL** | 256×128 finder 都稳 |
| App Switcher | **01 MINIMAL** | 跟 Apple Notes / Reminders letterform icon 视觉重量一致（C07 §E.3）|
| Finder 列表（视觉变体）| 01 MINIMAL（256）+ 02 GRADIENT（128 装饰）| 仅 designer 内部对照用，不上产品 |
| App Store 1024×1024 | **01 MINIMAL** | Apple 审核偏好 flat squircle + letterform |
| Onboarding 欢迎页内嵌 mark | **01 MINIMAL** | 跟主 icon 一致；避免 onboarding 跟 Dock 是两个不同 logo |
| Landing hero | **02 GRADIENT** | 见 §3.2 表 |
| Product Hunt 缩略图 | **02 GRADIENT** | 同上 |
| Twitter header / profile | **02 GRADIENT** | 同上 |
| 投资人 deck | **02 GRADIENT** | 同上 |
| 营销邮件 | **02 GRADIENT** | 同上 |
| Chrome extension icon | **01 MINIMAL** | extension 图标 16/32/48 都按 01 走，参考 [`code/yinghua-extension/icons/`](./code/yinghua-extension/icons/) |

### 3.4 ❌ 不再使用

- ❌ C07 **02 v3 版本的"中间缝"Y**（三段不连续，视觉上像 V 跟 I 叠在一起）—— C10 SVG master 已修
- ❌ C07 **01 v3 版本的"弯钩右捺"**（Apple Music 旧 logo 风格）—— C10 SVG master 已改直
- ❌ C07 **03 GLASS 玻璃球包 Y**（v3 调性异类，跟 C06 5 张产品图不协调；C07 §D.4 判真弃用）
- ❌ C02 v2 的**双环 / ∞ 形 / 聊天气泡 mark**
- ❌ C02 v1 的 deprecated "OO" 概念图
- ❌ 任何**带"AI"字样**烧图的 icon 变体（C09 audit V1-P3-1 验证 Anthropic 真的渲成 "AI" 字母，必须用真 brand mark）
- ❌ 任何**用品牌名作为 icon 字母**（"node" / "Yinghua" 字符）—— 见 §7 #14
- ❌ 任何**用 02 GRADIENT 做 Dock icon**（16×16 不可读，C07 §E.1）

### 3.5 浅色版 01 MINIMAL（v2.0 新增 · C08 audit L7 修正）

C08 浅色版 05 onboarding 中央 Y mark 主动改成了"白底 + 紫青 wash + 白 Y"（不是严格按 v1.0 写的"黑底 + 白 Y"），因为纯黑 96px mark 放在浅色 cream wallpaper 上会突兀。**v2.0 显式定义浅色版 01 MINIMAL**：

| 元素 | 深色版 | 浅色版 |
|------|--------|--------|
| squircle 容器 | `#0A0A0F` 近黑 | `#FFFFFF` 纯白（轻微 wash）|
| 容器 wash | 无 | 紫青渐变 wash @ 25% opacity（`linear-gradient(135deg, #B57BFF 25%, #2DD4BF 25%)`）|
| Y 颜色 | `#F4F1EC` 暖白 | `#FFFFFF` 纯白（区别于背景 wash）|
| 边缘 hairline | 1px 白色 6% | 1px 紫青 30%（`#8A5BFF @ 30%`）—— C08 audit LR6 修正对比度 |
| 用途 | macOS 浅色模式主窗体内嵌 mark | 同 |

浅色版 01 MINIMAL token 路径（待 C15 加）：

```json
"app-icon": {
  "minimal-01-light": {
    "background": "#FFFFFF",
    "wash-opacity": 0.25,
    "y-fill": "#FFFFFF",
    "hairline": "rgba(138, 91, 255, 0.30)"
  }
}
```

> **Figma 终版两份独立 component**：`app-icon/01-minimal-dark` + `app-icon/01-minimal-light`，不要做主题变体（颜色差异不大但 wash opacity 是关键）。

---

## 4. 组件库（Component Library）

### 4.1 按钮

5 种按钮类型，全部基于 SwiftUI `ButtonStyle`（C13 已 shippable 3 种：Primary / Secondary / Ghost；Icon / Toggle 后续补）。

| 类型 | 高度 | 圆角 | 背景 | 文字色 | 用途 | Token |
|------|------|------|------|--------|------|-------|
| **Primary** | 36-48 | 12 | 紫青渐变（`#B57BFF → #2DD4BF`，对角 135°）| `#FFFFFF` | 单一主操作（"开始录制"、"Get started"、"Share"）| `button.primary` |
| **Secondary** | 36 | 12 | 玻璃 `.regularMaterial` + 1px 8% 白边 | `#F4F1EC` | 次要操作（"Copy summary"、"Export PDF"）| `button.secondary` |
| **Icon（圆形）**| 32 | 50% | 玻璃 | 图标色 | 工具栏图标按钮（mic / camera / share）| `button.icon` |
| **Toggle（胶囊）**| 28 | 50% | on: 紫青；off: 玻璃 | 跟随 on/off | 开关（如 speaker mute）| `button.toggle` |
| **Ghost** | 24 | 0 | 透明，hover 时 1px 8% 白下划线 | `#F4F1EC` @ 60% → 100% | "Done"、"Cancel"、"Regenerate" 等次要链接 | `button.ghost` |

**三态派生（v2.0 新增）**：

| 状态 | 默认 → 派生规则 | Token 派生 |
|------|---------------|-----------|
| **default** | base | `button.{type}.default` |
| **hover** | background opacity 0.85 → 1.0；或 wash +5% | `button.{type}.hover` |
| **pressed** | scale 0.98（80ms ease-in）| `motion.easing.ease-in` |
| **disabled** | background opacity → 50%；文字色 → `#F4F1EC @ 40%`；cursor: not-allowed | `button.{type}.disabled` |
| **focus** | 2px `#8A5BFF` focus ring，offset 2px | `color.brand.purple-mid` |

**铁律**：单屏最多 1 个 Primary。2x2 网格（review-mode）里 3 个 Secondary + 1 个 Primary 是允许的，因为 Share 是 hero CTA。**Primary × 2 / 屏 = 反模式**（C12 `forbidden-patterns.NO_TWO_PRIMARY_BUTTONS`）。

### 4.2 控制面板（C05 ref-04 + C13 ControlPanel.swift 已 shippable）

会议进行中右下角浮窗，4 段式（status / transport / secondary / close）：

```
┌─────────────────────────────────┐
│ ● REC      02:34                │  ← status 段（红点 + 时间码）
├─────────────────────────────────┤
│  ⏸    ⏹    ▶                   │  ← transport 段（暂停 / 停止 / 继续）
├─────────────────────────────────┤
│  ⚙    ⬆    ✕                   │  ← secondary 段（设置 / 分享 / 关闭）
├─────────────────────────────────┘
```

**铁律**：
- 控制面板内**禁止任何 waveform / EKG / sine wave / audio visualizer**。只用红点 + 时间码传达"在录"。C12 `forbidden-patterns.NO_WAVEFORM` 显式禁。
- 控制面板是浮动小窗（`NSPanel` with `.floating` level + `.nonactivatingPanel`，C13 `ControlPanelWindowController` 已实现）
- 4 段之间用 1px 8% 白 hairline 分隔
- transport 按钮是 Icon（圆形）

**C08 浅色版发现**（audit L6）：C05 ref-04 本身是 3 段式（status / transport / secondary），C06 01 meeting 实际渲染也是 3 段（无 close 段）。**v2.0 修正规范为 3 段式**（status / transport / secondary，close 按钮合并到 secondary 段末位）—— 跟 C05 ref-04 + C06 v3 实际状态对齐。

### 4.3 Speaker Avatar（C13 SpeakerAvatar.swift 已 shippable · STYLE 1 唯一）

**STYLE 1 唯一**（C13 只实现 STYLE 1 · C07 audit §D v3 调性结论）：

- 圆形，36px（列表）/ 28px（紧凑列表）/ 20px（chip 内）
- 背景：纯色（紫 `#8A5BFF` / 青 `#2DD4BF` / 粉 `#FF6FA9` / 暖白 `#F4F1EC`），不渐变
- 文字：白色（暖白底用石墨色），SF Pro Text 600，首字母大写
- 同一说话人跨场景用同色（**颜色按 id hash 稳定**，C13 `Speaker.color(for: id)` 用 `abs(id.hashValue) % palette.count`）

**8 色调色板（v2.0 扩充）**：

C12 tokens JSON `color.speaker` 当前 4 色（紫 / 青 / 粉 / 暖白）。v2.0 扩充到 8 色（待 C15 落 token）：

| # | Hex | 角色 | 命名建议 |
|---|-----|------|---------|
| 1 | `#8A5BFF` | 紫（主）| `purple` |
| 2 | `#2DD4BF` | 青（主）| `teal` |
| 3 | `#FF6FA9` | 粉（主）| `pink` |
| 4 | `#F4F1EC` | 暖白（主）| `warm-white` |
| 5 | `#FF9F0A` | 橙（扩展，警告相关说话人）| `orange` |
| 6 | `#34C759` | 绿（扩展，主持人 / 你本人）| `green` |
| 7 | `#5E5CE6` | 靛（扩展）| `indigo` |
| 8 | `#BF5AF2` | 紫红（扩展）| `purple-magenta` |

**STYLE 2-4 仅在 marketing 截图里出现**（青粉渐变 / 紫色几何 / 暖白方块），系统内**只用 STYLE 1**。C07 §D 验证 v3 调性下 STYLE 2-4 与产品图不协调。

### 4.4 File Card（review-mode 用 · C13 ReviewModeView 已 shippable）

- 容器：12px 圆角，玻璃 + 1px 8% 白边
- 左侧：紫色 Y file icon（48x48，C07 02 GRADIENT 缩略）
- 中间：标题（16pt SF Pro Text 600）+ 副标题（12pt 次白）
- 右侧：Open pill button（Secondary 风格，36x28）
- meta tag 行：3 个小灰底胶囊（`MP4` / `中英双语` / `2 位发言人`）

**Thumbnail 派生（v2.0 新增）**：

| 场景 | File icon 变体 |
|------|---------------|
| 音频文件 | 紫色 Y + 底部 audio waveform 简化版（**不是 waveform visualizer**，是 3 条静态水平线 + 1 个 dot）|
| 视频文件 | 紫色 Y + 底部 play triangle |
| 文本文件 | 紫色 Y + 底部 document lines（3 条静态横线）|
| 未知 | 紫色 Y 单独 |

### 4.5 Transcript Row（C13 TranscriptFocusView 已 shippable）

- 高度：~64px（list）/ ~48px（compact list）
- 左：STYLE 1 avatar 28-36px
- 中：bold 名字（14pt 600）+ 时间码（12pt JetBrains Mono 500 次白）+ 1 行 Lorem ipsum（14pt 400）
- 时间码永远跟名字同行，不另起

**Speaker color 持久化（v2.0 强调）**：
- C13 `Speaker.color(for: id)` 用 `id.hashValue` 稳定映射 4-8 色调色板
- 同一说话人 id 在不同 meeting 里颜色**保持一致**（除非用户手动改）
- 存 `UserDefaults` 或 SwiftData：`speaker_{id}_color = #HEX`
- 颜色映射用 `SpeakerColor.from(id: UUID)` 静态函数

### 4.6 Collapsible Section Card（C13 CollapsibleSectionCard.swift 已 shippable）

- 容器：12px 圆角，1px 8% 白边，玻璃
- Header 行：左 icon（16px）/ bold 标题（16pt 600）/ 右 chevron（toggle 时旋转 90°）
- 折叠时只显示标题 + 计数 badge（"3 items"）
- 展开时 bullet 列表，每 bullet 前 4px 圆点（紫/青/粉 循环）

**Spring 动效 spec（v2.0 新增）**：

```swift
withAnimation(.spring(response: 0.22, dampingFraction: 0.85)) {
    isExpanded.toggle()
}
```

- duration: 220ms（`motion.duration.normal`）
- response: 0.22s
- dampingFraction: 0.85（轻微 overshoot 5%，表达"打开"语义）
- content opacity 跟随：0 → 1 同样 220ms spring
- chevron 旋转：90°，200ms ease-out

**4 段标准**（C06 v3 review-mode 已锁定）：
1. **关键瞬间**（Key moments）— 紫 icon
2. **决定**（Decisions）— 青 icon
3. **待办**（Action items）— 粉 icon
4. **遗留问题**（Open questions）— 暖白 icon

### 4.7 Onboarding 3-dot Progress（C09 屏 1-3 已 shippable）

- 3 个 8px 圆点，间距 12px
- inactive：8px 空心灰圆（描边 1px 8% 白/黑）
- active：12px 实心紫（`#8A5BFF` 接近 focus ring 色）+ 紫色光晕（8px 半径，opacity 30%）
- 已过：8px 实心紫（无光晕）
- 位置：屏 1 底部居中 / 屏 2-3 顶部居中（C09 §4.2 接受"屏 1 底部 vs 屏 2-3 顶部"的有意设计差异）

---

## 5. 产品表面（Product Surfaces）

5 个核心场景（深色 + 浅色 = 10 张 v3 图），全部基于 C06 + C08 定调。详细 prompt 与 V1 修复清单见 `C06_product-v3/README.md` 和 `C08_light-mode/README.md`。

| # | 场景 | 关键元素 | 深色图 | 浅色图 |
|---|------|----------|--------|--------|
| 4.1 | **meeting-in-progress** | 4 人 video grid + 映话控制面板浮窗 + transcript 副屏 + 顶部静音指示 | C06/01 | C08/01 |
| 4.2 | **empty-state** | 左侧 4 圆形 nav（首个 mic 带 magenta active dot）+ 中央 2x2 大方块 + 右侧最近录音 3 行 | C06/02 | C08/02 |
| 4.3 | **transcript-focus** | 单窗口 7 段说话人轮次（STYLE 1 头像），顶部 REC + 时间码 | C06/03 | C08/03 |
| 4.4 | **review-mode** | 左 file card + 5 行 transcript + speaker chips + 右 AI 总结 4 折叠段 + 2x2 按钮簇 | C06/04 | C08/04 |
| 4.5 | **onboarding** | 极简居中 + 品牌 mark + tagline + 3 bullet + 单一 CTA + 3-dot progress | C06/05 | C08/05 |

**Onboarding 3 屏流**（C09 新增）：
- 屏 1：欢迎 + Get started（C06 05）
- 屏 2：权限授权（麦克风 / 屏幕 / 通知 3 张卡）
- 屏 3：BYOK（OpenAI / Anthropic / Custom 3 provider + API key 输入）

### 5.1 单屏铁律

- **主窗口只做一件事**。不要在 meeting 窗口塞 transcript，在 transcript 窗口塞 settings。
- **转录独立成屏 — 用独立 Window Scene（v2.0 强调）**。transcript-focus 是独立 `Window` Scene（C13 `YinghuaApp.swift` 已用 `WindowGroup` + `Window` 定义），**不是主窗口的 tab 切换**。C13 下一步工作 §必做 明确：目前 `transcriptFocus` 还是主窗口的 tab，需要切到独立 `Window` Scene。
- **设置 / preferences 走 macOS 标准 `⌘,`**。不要在主界面放齿轮按钮（控制面板上的 ⚙ 跳系统设置即可）。
- **浮层是有理由才出现**（如转录屏盖在会议视频上方，因为用户需要边开会边看）。不要为美而浮层。

### 5.2 层次结构（4 层 · C02 §1.0 + C06 review）

```
L1 最远：桌面（aurora wallpaper + Dock）
   └─ L2 远：上下文 UI（会议视频方块 / 浏览器窗口 / Notion / PDF）— 虚化 + 降低饱和度
        └─ L3 中：映话产品主窗口 — 清晰 + 玻璃 + 居中
             └─ L4 近：转录屏浮层 / 提示气泡 / 行动项弹窗 — 半透明 + 高斯模糊背景 + 1px stroke
```

4 层。**不要多加层**（L5 = 嵌套浮层 = 反模式，C12 `forbidden-patterns.NO_BENTO_FRAME` 的精神延伸）。

**核心原则**（C02 §1.0）：
- ❌ 绝不在一个窗口里塞 5 个组件
- ✅ 主窗口只做一件事
- ✅ 浮层是有理由才出现
- ✅ 上下文元素放 L2 虚化，不要清晰
- ✅ 旁边有"标志性"的小元素：Finder 文件夹、桌面小文件、菜单栏图标，让画面有"真实在 macOS 工作"的感觉

### 5.3 5 个 surface 与 C13 SwiftUI 实现的对应

| C06/C08 子目录 | SwiftUI 视图 | 状态 |
|----------------|-------------|------|
| `01-meeting-in-progress/` | `MeetingInProgressView` | ✅ 4 人 video grid + REC + transcript 副屏 + 静音指示 |
| `02-empty-state/` | `EmptyStateView` | ✅ 4 圆形 nav（首项 magenta active dot）+ 2x2 大方块 + 右侧 3 行最近 |
| `03-transcript-focus/` | `TranscriptFocusView` | ✅ 7 段说话人轮次 + 顶部 REC + 说话人 chip |
| `04-review-mode/` | `ReviewModeView` | ✅ 左 file card + 5 行 preview + speaker chips + 右 4 折叠段 + 2x2 按钮 |
| `05-onboarding/` | `OnboardingView` | ✅ 极简居中 + Y mark + 3 bullet + 单一 CTA + 3-dot progress |
| `06-09 onboarding 屏 2-3` | `OnboardingPermissionView` + `OnboardingBYOKView` | ⏳ Round 4 补（参考 C09 屏 2/3 设计）|

---

## 6. macOS 强制规范（Locked）

所有 v3 产品图 prompt 都引用这些规则。任何破坏规则的图必须重出，或 Figma 后期修。4 个 audit 反复验证：这些规则是底线，不允许 prompt 偏离。

### 6.1 菜单栏（顶 · 6 项结构）

- 黑色毛玻璃（深色）/ 白毛玻璃（浅色）
- **6 项固定结构**（C09 audit N1 强调 — 缺一不可）：
  1. Apple logo（最左）
  2. **app 名**（"Yinghua" — 当映话是前台 app 时；"Finder" — 当 Finder 是前台时）
  3. App 菜单（plain English：`File Edit View Window Help`）
  4. （左半结束）
  5. 状态图标（Control Center / Battery / Wi-Fi / Search）
  6. 时钟（最右）

**v1.0 错误**：v1.0 写"Apple logo + app 名 + 4 menu + 时钟"是 6 项没错，但 C06 / C08 / C09 三轮 audit 都发现 5/5 张图 prompt 漏写 app 名。**v2.0 强制**：prompt 模板末尾必须显式写 `"Apple logo + app name 'Yinghua' + 'File Edit View Window Help' + battery/Wi-Fi/search icons + clock"`，禁止只写 "Apple + 4 menu"。

### 6.2 Dock（底 · 12 项固定顺序）

**11 个真实 macOS 系统图标 + 1 分隔点 + 1 映话 Y = 13 元素（按位置编号 1-12）**：

| # | 元素 | 必须性 |
|---|------|--------|
| 1 | Finder（蓝白脸）| ✅ 强制 |
| 2 | Safari（蓝色指南针）| ✅ 强制 |
| 3 | Messages（绿色对话气泡）| ✅ 强制 |
| 4 | Mail（蓝色信封）| ✅ 强制 |
| 5 | **Notes（黄色记事本）**| ✅ 强制（**C09 audit N2 强调 — 模型对 Notes 视觉记忆极不稳定，prompt 必须显式写 "macOS Notes (yellow notepad)"**）|
| 6 | Calendar（白色页面 + "26"）| ✅ 强制（**日历 day-name 必删或真渲染，C08 audit L13**）|
| 7 | Reminders（白色 list + 红/黄/绿点）| ✅ 强制 |
| 8 | Maps（地图）| ✅ 强制 |
| 9 | Music（红色音符）| ✅ 强制 |
| 10 | System Settings（灰色齿轮）| ✅ 强制 |
| 11 | **分隔点**（小圆点）| ✅ 强制（**C06 audit N2 强调 — 5 张图 5/5 缺**）|
| 12 | **Yinghua**（紫色 Y 在深色玻璃上，运行时下方有 magenta 小点）| ✅ 强制 |

**v2.0 强制 prompt 模板**（C02 §2.4 + C08 audit P0）：

```
Dock with EXACTLY these 12 elements in this exact order (must match
ref-02-dock-system): Finder, Safari, Messages, Mail, Notes (yellow
notepad, NOT Contacts/Photos), Calendar (showing "26" in red, NO day
name gibberish like "MIY" or Cyrillic), Reminders, Maps, Music, System
Settings, a small separator dot, then the Yinghua app icon (purple
aurora Y on dark glass, with a small magenta active dot below
indicating the app is running). DO NOT add Trash, Launchpad, Contacts,
Photos, or any other icon not in this list.
```

**禁止**：
- ❌ 任意位置插入 Address Book / Photos / FaceTime / Pages / Numbers / Keynote / Trash / Launchpad / Contacts 等不在 12 项列表里的图标
- ❌ Y 不在分隔点之后的位置（位置 12）
- ❌ 任意 2 张图之间 Dock 顺序不一致（**Figma 后期统一 1 套 master dock**，从 C05 ref-02 裁切 12 个 icon 固定贴入 5 张图 — C08 audit P0）
- ❌ 日历顶部 day-name 乱码（"MIY" / "ПАН" / "NEN" / "MEM" / "SUN" / "MEN" / "HOR" / "DON" / "MAAN"）—— 全部禁

### 6.3 窗口装饰

- 三色 traffic light（红 / 黄 / 绿）在窗口左上角（**不可隐藏**——macOS 用户依赖它）
- 标题栏：14px 圆角窗口的 vibrancy 顶部条
- 无边框时不要把 traffic light 藏起来
- SwiftUI 用 `WindowGroup` 默认（系统自带 traffic light，C13 已验证）

### 6.4 禁止行为（v2.0 扩充）

- ❌ 不用 emoji 代替 icon
- ❌ 不用 web 字体模拟 SF Pro（用真 .ttf 或系统字体）
- ❌ 不用 `.ultraThinMaterial` 之类过轻的玻璃（会糊）— C12 token + forbidden 双层防御
- ❌ 不强制 light mode——跟随系统（C13 SwiftUI 用 `@Environment(\.colorScheme)`）
- ❌ 不在 prompt 里把"14pt" / "STYLE 1" / "@ 65%" / "AI" 等规则文字作为可见 label（§7 #13）
- ❌ 不在 prompt 里给 provider / concept card 用品牌名作为 icon（§7 #14）
- ❌ 不在 prompt 里给 macOS UI 元素（菜单 / 状态栏 / Dock 指示）发明 label（§7 #13 + C02 §2.3）

---

## 7. 禁止的反模式（Anti-Patterns · 18 条）

任何产品图、UI 截图、marketing 出片如果出现这些，必须返工或 Figma 后期修。

### 7.1 v1.0 12 条（沿用）

| # | 反模式 | 为什么禁 |
|---|--------|----------|
| 1 | ❌ 任何 waveform / EKG / sine wave / audio visualizer | macOS 录音 UI 用红点+时间码，waveform 是 web/SaaS 套路（C06 §4.2 + C12 forbidden） |
| 2 | ❌ "AI" 字样烧进 icon / hero | 占位符 Figma 后期替换，但绝不直接烧图（C06 N7 + C09 V1-P3-1 验证 Anthropic 真渲成 "AI"）|
| 3 | ❌ 双环 / ∞ / 聊天气泡 mark | 已废弃的 v2 方向，会让用户误以为这是 Notion/Loom（C02 v2）|
| 4 | ❌ 星空银河背景（除桌面壁纸外）| 俗气 + cyberpunk 感 |
| 5 | ❌ Bento 框 + 左侧 bold label | AI 生成的 SaaS landing 套路，Apple 不这么做 |
| 6 | ❌ 营销词：洞察 / 赋能 / 智能化 / 效率提升 / 全局掌控 / AI 驱动 | 状态词升级、空话、不专业 |
| 7 | ❌ Pie / donut / gauge / radar chart | 真实 macOS app 几乎不用，design 调性不符 |
| 8 | ❌ 装饰性 sparkles 散落在 hero | sparkles 只能用在 AI 总结 section 的 marker，不能满天飞 |
| 9 | ❌ 渐变描边的"两圆相交"对话图标 | 是 ChatGPT 的 icon，不要撞 |
| 10 | ❌ Glow / halo / 霓虹外发光 | cyberpunk / 廉价感 |
| 11 | ❌ 多色霓虹（紫 + 粉 + 青 + 黄全上）| 散乱。最多 2-3 色：紫 + 青 + （REC 红）|
| 12 | ❌ 把中文塞进 prompt 让模型渲染 | 模型必乱码，必 Figma 后期替换 |

### 7.2 v2.0 新增 6 条（C06-C09 audit 提炼）

| # | 反模式 | 为什么禁 | 证据 |
|---|--------|----------|------|
| 13 | ❌ **prompt 规则文字泄漏为可见 UI**（"STYLE 1" / "@ 65%" / "14pt regular" / "600 15pt" / "PRIMARY" / "graphite @ 65%"） | 模型把 prompt 里的字号 / 样式标签 / 抽象概念当 UI label 渲染 | C06 N7-N9 + C07 audit + C08 audit 01 FAIL（13 处）+ 02 FAIL（7 处）；C02 §2.3 anti-leak 6 案例 |
| 14 | ❌ **品牌名作为 icon 字母**（"AI" / "node" / "OpenAI" / "Anthropic" 等） | 用 provider 概念卡 / icon 字母代替真实 brand mark | C09 V1-P3-1（Anthropic "AI" 字母 FAIL）+ V1-P3-3（Custom "node" 文字 low）|
| 15 | ❌ **Dock 顺序跨图不一致 / 缺分隔点 / 第 5 位错放 Contacts/Photos** | macOS Dock 是 12 项固定结构，模型对 Notes 视觉记忆极不稳定 | C06 audit N2 + N4 + §2 交叉一致 FAIL；C08 L2/L5/L6；C09 N2；C05 ref-02 是 ground truth |
| 16 | ❌ **日历 day-name 乱码**（"MIY" / "SUN" / "ПАН" / "NEN" / "MEM" / "MEN" / "HOR" / "DON" / "MAAN"） | 模型在没有 day name spec 时生成乱码字符 | C06 N11 + C08 L13 + C09 N3 + 5 张图 5/5 出现 |
| 17 | ❌ **App Switcher 里 icon 不可读**（16×16 缩略后 Y 笔画糊掉、02 渐变压缩为单色） | Dock / App Switcher 是真实使用场景 | C07 §E.1 验证 02 GRADIENT 16×16 不可读 → 只用 01 MINIMAL 做 Dock |
| 18 | ❌ **Extension / 浮窗默认态过抢戏**（default 60×60 圆形气泡 + 强 color + 大状态点 → 用户没交互时抢戏）| 浮窗设计原则是"natural discovery"——不打扰、克制 | C14 README §设计理念 + C14 V1 修复项（placeholder line 长度 / 收藏夹条图标替换）|

### 7.3 命名铁律（v1.0 沿用 · §11 详述）

- ✅ 真实使用场景：`landing-hero` / `social-producthunt-card` / `recording-active` / `summary-complete` / `app-icon` / `meeting-in-progress` / `empty-state` / `transcript-focus` / `review-mode` / `onboarding`
- ❌ 禁用：`v1` / `v2` / `v3` / `v4` / `test` / `draft` / `final-final` / `revised` / `updated`
- 版本信息用 **日期**（`__260822`）和 **场景** 表达

---

## 8. 参考库（Reference Library）

### 8.1 设计 token 视觉版（C05 5 张 · 沿用 v1.0）

所有产品图 prompt 必须引用：

- `C05_design-tokens-visual/ref-01-macos-base/macos-base-reference__260822.png` — 锁菜单栏 / 极光壁纸
- `C05_design-tokens-visual/ref-02-dock-system/ref-02-dock-system__260822.jpg` — **锁 Dock 12 项 master（v2.0 强调 — Figma 后期统一贴入 5 张图）**
- `C05_design-tokens-visual/ref-03-speaker-avatars/ref-03-speaker-avatars__260822.jpg` — Speaker 4 种风格（系统内只用 STYLE 1）
- `C05_design-tokens-visual/ref-04-control-panel/ref-04-control-panel__260822.png` — 3 段式控制面板（v2.0 修正：v1.0 写 4 段是错，实际 3 段）
- `C05_design-tokens-visual/ref-05-button-system/ref-05-button-system__260822.png` — 5 种按钮

### 8.2 矢量 icon master（C10 2 SVG · v2.0 新增）

- [`C10_vector-icon/icon-01-minimal__260823.svg`](./_exploration/C10_vector-icon/icon-01-minimal__260823.svg) — 主 icon 矢量 master
- [`C10_vector-icon/icon-02-gradient__260823.svg`](./_exploration/C10_vector-icon/icon-02-gradient__260823.svg) — marketing 备用 master
- PNG 多尺寸：`icon-{01-minimal,02-gradient}-{1024,256,128,64,32,16}__260823.png` 共 12 个

### 8.3 Design tokens JSON（C12 · 117 token · v2.0 新增）

- [`design/design-tokens.json`](./design-tokens.json) — W3C DTCG 格式，117 leaf token
- 26 color + 15 typography + 10 spacing + 10 radius + 11 motion + 4 elevation + 5 z-index + 4 breakpoint + 4 material + 13 app-icon + 15 forbidden-patterns
- 消费方式：Style Dictionary → Swift / CSS / Figma Tokens plugin
- 详见 [C12 README](./_exploration/C12_design-tokens/README.md)

### 8.4 SwiftUI scaffold 源码（C13 · BUILD SUCCEEDED · v2.0 新增）

- [`code/Yinghua/`](./code/Yinghua/) — 编译通过（Xcode 26.6 · Swift 6.3.3 · arm64-apple-macos26.5）
- 5 个 surface 都有真实布局 + 中文 placeholder
- 关键组件：`Models/DesignTokens.swift` · `Components/SpeakerAvatar.swift` · `Components/PrimaryButton.swift` · `Components/CollapsibleSectionCard.swift` · `Components/ControlPanel.swift` · `Views/MainWindow.swift` 等
- 详见 [C13 README](./code/Yinghua/README.md)

### 8.5 Chrome extension 源码（C21 · v2.0 新增）

- [`code/yinghua-extension/`](./code/yinghua-extension/) — Chrome extension（Manifest V3）
- icons: `icon-{16,48,128}.png`（用 C10 01 MINIMAL 缩略）
- 详见 [C14 README §已知 V1 问题](./_exploration/C14_browser-extension/README.md)（修复项提示）

### 8.6 开源项目（5 个 · 沿用 v1.0）

只参考，不抄。详见 [`design/_reference/`](./_reference/)：

- **Parrot** — 真实 macOS 录音 app 实现
- **AirTranslate** — 实时翻译 UI 模式
- **textream** — 实时转录 + AI 滚动
- **DockDoor** — Window preview 模式
- **AnswerCue** — AI 浮层交互

### 8.7 商业产品（2 个 · 沿用 v1.0）

- **Fathom**（marketing 文案语料 / 简洁定位模板）
- **Final Round**（AI 面试助手 / 直接竞品）

---

## 9. 实现注意（SwiftUI / AppKit · v2.0 大扩充）

> 仅供参考，不是强制。dev 可按团队惯例调整。但所有 v2.0 新增的 token / 三态 / spring spec 都强烈建议用——Figma sync 阶段会一并推。

### 9.1 SwiftUI code pattern（v2.0 详细化 · C13 Models/DesignTokens.swift 已 shippable）

| 组件 | SwiftUI / AppKit 选择 | 关键代码 |
|------|---------------------|---------|
| 主窗口 | `WindowGroup` + `Window`（macOS 13+）| C13 `YinghuaApp.swift` 已用 `@main` + 5 个 scene |
| **独立 transcript window（v2.0 强调）** | `Window("Transcript", id: "transcript")` 独立 scene | C13 下一步 §必做：从 tab 切换切到独立 Window |
| 玻璃背景 | `background(.regularMaterial)` 叠加 `Color` 渐变 wash | C13 `MainWindow.body` |
| 录制浮窗 | `NSPanel` (`.floating` level, `.nonactivatingPanel`) | C13 `ControlPanelWindowController` |
| Dock 图标 | 标准 `NSImage` + `.icns`（用 01 MINIMAL，C10 SVG master 直接出 PNG）| 替换 C13 AppIcon 占位 |
| Speaker avatar | 自定义 `View`，颜色按 id hash 稳定（C13 `Speaker.color(for:)`）| 存 `UserDefaults` 关联说话人 ID |
| 文件卡 | `GroupBox` + 自定义 style | C13 `ReviewModeView` |
| Collapsible section | `DisclosureGroup` 或自绘（追求精确控制时自绘）| C13 `CollapsibleSectionCard.swift` 自绘（更可控）|
| 录制红点 pulse | `withAnimation(.easeInOut.repeatForever)` + `scaleEffect` | C13 ControlPanel |
| BYOK API 配置 | `SecKeychain` 存 key，**不写文件、不上传** | C13 下一步 §必做 |
| 实时转录 | `AVAudioEngine` tap → `SpeechAnalyzer` (macOS 26) 或 Whisper.cpp 本地 | C13 下一步 §必做 |

**DesignTokens.swift 关键结构**（C13 已实现）：

```swift
enum Tokens {
    enum Color {
        static let brandPurpleVivid = Color(red: 0.71, green: 0.48, blue: 1.0)  // #B57BFF
        static let brandTealVivid   = Color(red: 0.18, green: 0.83, blue: 0.75)  // #2DD4BF
        static let warmWhite        = Color(red: 0.96, green: 0.95, blue: 0.93)  // #F4F1EC
        static let recordingRed     = Color(red: 1.0, green: 0.23, blue: 0.19)   // #FF3B30
        // ... 共 ~20 个
    }
    enum Radius {
        static let window: CGFloat = 14
        static let button: CGFloat = 12
        static let circle: CGFloat = .infinity
    }
    enum Spacing {
        static let xs: CGFloat = 4
        static let sm: CGFloat = 8
        // ... 8pt grid
    }
    enum Motion {
        static let instant: TimeInterval = 0.08
        static let fast: TimeInterval = 0.12
        static let normal: TimeInterval = 0.22
        static let slow: TimeInterval = 0.25
        static let spring = Animation.spring(response: 0.22, dampingFraction: 0.85)
    }
}
```

**v2.0 强烈建议**：C13 当前 `DesignTokens.swift` 是手写常量；C12 tokens JSON shippable 后，用 Style Dictionary 自动生成 `DesignTokens.generated.swift`（参考 [C12 README §4.1](./_exploration/C12_design-tokens/README.md#41-swiftui-style-dictionary--swift-extension)），手写文件作为 fallback 保留。

### 9.2 性能预算（v2.0 详细化）

| 指标 | 预算 | 测量方法 | 验证 |
|------|------|----------|------|
| 主窗口冷启动 | < 200ms | Instruments → Time Profiler → 启动到第一帧 | C13 BUILD SUCCEEDED 但未做 performance baseline，C15 补 |
| 录制启动到显示 REC | < 300ms | 用户点 "开始录制" 到浮窗出现 REC 红点 | 同上 |
| 实时转录延迟 | < 800ms | 说话结束到文字出现在 transcript row | 同上 |
| AI 总结生成 | < 8s | 用 Claude Sonnet，按 60 分钟会议，4 段折叠 | 同上 |
| 主窗口内存占用 | < 80MB | Activity Monitor 空闲态 | 同上 |
| 录制 1 小时磁盘写入 | < 50MB | 默认 AAC 压缩 + 24kHz mono | 同上 |

### 9.3 本地优先（v2.0 强化）

- **数据存**：`~/Library/Application Support/Yinghua/`（C13 AppState 注释已写）
- **转录音频原文 30 天后自动清理**（**v2.0 显式 token 化** — C15 加 `storage.transcript-retention-days = 30`；仅保留 transcript + summary，音频原文删除）
- **BYOK 调用走 macOS Keychain**（`SecKeychain` / `kSecClassGenericPassword`），**绝不**上传 key 到我们的服务器
- **网络请求只发生在用户主动触发"AI 总结"时**，且仅传 transcript 文本（不传音频）
- **App Sandbox + hardened runtime**（macOS 26 默认，C13 已开）
- **麦克风 / 屏幕录制 entitlement**（C13 Info.plist 已配 usage description）
- **5 个 surface 切换不重新加载数据**（`@Observable` 全局状态）

### 9.4 prefers-reduced-motion 全局尊重（v2.0 强调）

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

// 在所有 withAnimation 里
let animation: Animation = reduceMotion ? .easeInOut(duration: 0.1) : .spring(response: 0.22, dampingFraction: 0.85)
withAnimation(animation) { ... }
```

C13 当前未实现，C15 必做。

---

## 10. Round 1+2+3 完成度自检（重写 · 每模块带证据路径）

### 10.1 Round 1（已完成 · 2026-08-22 22:00）

| 模块 | 状态 | 证据路径 | 审计 |
|------|------|---------|------|
| A 资源采集 | ✅ | 5 仓库 + 5 索引 + 2 商业产品语料（§8.6 / §8.7）| n/a |
| B 生产管线 | ✅ | 6 份规范（562 行）| n/a |
| C 迭代探索 | ✅ | C01-C07 共 7 轮、~30 张图 | n/a |
| 调性锁定 | ✅ | C05 5 张 tokens + 7 禁止条款 + 4 强制条款 | n/a |
| 5 核心产品图 | ✅ | C06 v3 5 张终版 | **C06 audit PARTIAL**（9 项 × 5 = 45 检查点，30 PASS / 12 PARTIAL / 3 FAIL）|
| App icon 终版 | ✅ | C07 dual（01 主 + 02 备用）| **C07 audit PARTIAL**（3 变体逐项 A-G）|
| Design doc v1.0 | ✅ | 本文件 v1.0（19KB 11 章）| n/a |
| **Design tokens JSON** | ✅ | C12 117 token 25KB | W3C DTCG 合规 · §5 验证 5/5 |
| 矢量 icon 多尺寸 | ✅ | C10 2 SVG + 12 PNG | 6/6 修复项全过 |
| 浅色模式 | ⏳ → ✅ | C08 5 张浅色图 | **C08 audit PARTIAL**（10 项 × 5 = 50 检查点，39 PASS / 9 PARTIAL / 2 FAIL）|
| Onboarding 3 屏 | ⏳ → ✅ | C09 屏 2/3（屏 1 = C06 05）| **C09 audit PARTIAL → FAIL 边界**（10 项 × 2 = 20 检查点，16 PASS / 3 PARTIAL / 1 FAIL）|
| Twitter banner | ✅ | C11 banner + profile | n/a |
| Browser extension | ✅ | C14 2 张图（Zoom + Meet）| n/a |
| 真实 SwiftUI 实现 | ⏳ → ✅ | C13 BUILD SUCCEEDED | Xcode 26.6 · Swift 6.3.3 · arm64-apple-macos26.5 |

### 10.2 Round 2（已完成 · 2026-08-23 01:30）

| 模块 | 状态 | 证据路径 | 审计 |
|------|------|---------|------|
| 4 个独立 audit verdict | ✅ | C06 / C07 / C08 / C09 | 全部 PARTIAL · 主体无崩塌 |
| design-doc v1.0 收口 | ✅ | v1.0 11 章 19KB | n/a |
| SwiftUI 编译通过 | ✅ | C13 xcodebuild BUILD SUCCEEDED | Xcode 26.6 |
| 矢量 icon 收口 | ✅ | C10 2 SVG + 12 PNG | 6/6 修复项全过 |
| 浅色版产品图 | ✅ | C08 5 张 | 39/50 PASS |
| Onboarding 3 屏 | ✅ | C06 屏 1 + C09 屏 2/3 | 屏 1/2 PASS，屏 3 1 FAIL（Anthropic "AI"）|
| Design tokens 工程化 | ✅ | C12 117 token JSON | §5 验证 5/5 |

### 10.3 Round 3（已完成 · 2026-08-23 01:44 · 整合到 v2.0）

| 模块 | 状态 | 证据路径 | 审计 |
|------|------|---------|------|
| 4 audit findings 整合到 design-doc | ✅ | v2.0 §0.2 + §6 + §7 + §9 | n/a |
| Design doc v2.0 收口 | ✅ | v2.0 15 章 ~40KB | n/a |
| **Figma 后期 batch 修清单（v2.0 首次列出）** | ✅ | §12 | P0 17 项 + P1 8 项 + P2 6 项 |
| Round 4 计划 | ✅ | §13 | C15-C22 shippable 包 |
| V1 资产索引 | ✅ | §14 | 5 shippable + 5 V1 待修 |

### 10.4 Round 1+2+3 总结

- **5 个核心产品图**：C06 v3 5 张 + C08 浅色 5 张 = 10 张
- **3 个 app icon 变体**：C07 3 个 → C10 收口为 2 个 SVG master + 12 PNG
- **117 个 design token**：C12 JSON
- **1 个 SwiftUI scaffold**：C13 5 surface + 5 components + 5 models
- **1 个 Chrome extension**：C21 代码 + C14 2 张图
- **4 个独立 audit verdict**：C06 / C07 / C08 / C09（4 个 verifier 独立审查 30+ V1 issue）
- **15 章 design doc**：本文件 v2.0

**全部 major 模块都 PASS / PARTIAL（无 FAIL 主体崩塌）**。剩余工作全是 Figma 后期 batch 修 + SwiftUI 业务逻辑接线 —— Round 4 shippable 包范围。

---

## 11. 命名铁律（再次强调 · v1.0 沿用）

- ✅ 真实使用场景：`landing-hero` / `social-producthunt-card` / `recording-active` / `summary-complete` / `app-icon` / `meeting-in-progress` / `empty-state` / `transcript-focus` / `review-mode` / `onboarding`
- ❌ 禁用：`v1` / `v2` / `v3` / `v4` / `test` / `draft` / `final-final` / `revised` / `updated`
- 版本信息用 **日期**（`__260822`）和 **场景** 表达，不放在文件名里

---

## 12. Figma 后期 batch 修清单（v2.0 新增 · 4 audit 整合）

按 P0 / P1 / P2 排序。P0 = 必须做（否则图不能上线），P1 = 必做（影响品牌严肃度），P2 = 建议做（影响 polish）。

### 12.1 P0 — 必须做（17 项 · Figma 总工时约 8 小时）

| # | 修什么 | 在哪 | 证据 | 工时 |
|---|--------|------|------|------|
| **F1** | 屏 3 Anthropic "AI" 字母 → 真 Anthropic brand mark（白色 chevron / 钻石几何）| C09/03 byok 屏 3 | C09 audit V1-P3-1 FAIL HIGH | 30 min |
| **F2** | 批量删除 01 meeting 13 处 prompt 规则泄漏（"STYLE 1" ×6 / "@ 65%" ×6 / "PRIMARY" ×1）| C08/01 meeting | C08 audit 01 FAIL | 1.5h |
| **F3** | 批量删除 02 empty 7 处 prompt 规则泄漏（"14pt SF Pro Text 600" ×1 / "graphite @ 65%" ×6/7）| C08/02 empty | C08 audit 02 FAIL | 1h |
| **F4** | 批量删除 04 review "STYLE 1" 灰字 + 03 transcript "STYLE 1" 灰字 | C06/04 + C06/03 | C06 audit N7 HIGH | 30 min |
| **F5** | 05 onboarding 副标题 "Yinghua ~14pt regular" → "映话" + CTA "Get started 600 15pt ↗" → "开始使用 ↗" | C06/05 | C06 audit N8 + N9 HIGH | 30 min |
| **F6** | 05 onboarding 品牌 mark 改为 01 MINIMAL（黑底 + 暖白 Y）—— 或用 §3.5 浅色版 01 MINIMAL（按 wallpaper 是深色 / 浅色决定）| C06/05 | C06 audit N3 HIGH | 30 min |
| **F7** | 统一 5 张图 Dock（深色 C06 5 张 + 浅色 C08 5 张 = 10 张）按 §6.2 12 项 master 替换 | C06/01-05 + C08/01-05 | C06 N2/N4 + C08 L2/L5/L6 + C09 N2 | 2h |
| **F8** | 5 张图菜单栏加 "Yinghua" 或 "Finder" app 名（10 张图全部）| C06/01-05 + C08/01-05 | C06 N1 + C08 L9 + C09 N1 | 30 min |
| **F9** | 5 张图日历顶部 day-name 乱码删除或真渲染（"MIY" / "SUN" / "ПАН" / "NEN" / "MEM" / "MEN" / "HOR" / "DON" / "MAAN" → "26" only）| C06/01-05 + C08/01-05 | C06 N11 + C08 L13 + C09 N3 | 1h |
| **F10** | 04 review 多余 Trash 删除 | C06/04 + C08/04 | C06 N6 + C08 L5 | 15 min |
| **F11** | 02 / 04 / 05 / 03 Dock 多余 Contacts / Photos / Address Book / Launchpad 删除 | C08/01 + C08/04 + C08/05 | C08 L2/L5/L6 | 30 min |
| **F12** | 02 / 03 缺分隔点（11 → 12 项）| C08/02 + C08/03 | C08 L3/L4 | 15 min |
| **F13** | 03 transcript stop 按钮移到内容区底部右下、不挡最后一行 Sam | C06/03 + C08/03 | C08 audit §3.1 medium | 1h |
| **F14** | 01 meeting 控制面板左移 16-24px，不挡 "Speaker 3" | C08/01 | C08 audit L1 low | 30 min |
| **F15** | 03 Custom provider card icon "node" 文字 → 简单节点 + 圆点几何 mark | C09/03 byok 屏 3 | C09 audit V1-P3-3 | 15 min |
| **F16** | 03 Custom card 背景紫色 wash 减弱（避免和 active Anthropic 卡视觉混淆）| C09/03 byok 屏 3 | C09 audit N4 low | 15 min |
| **F17** | C07 02 GRADIENT Y 中间缝修复（用 C10 SVG master 直接替换）| C07/02 gradient | C07 audit §V1 #2 HIGH | 30 min |

### 12.2 P1 — 必做（8 项 · Figma 总工时约 4 小时）

| # | 修什么 | 在哪 | 证据 | 工时 |
|---|--------|------|------|------|
| **F18** | 5 张图时钟统一为 22:14（10 张图）| C06/01-05 + C08/01-05 | C06 §2 交叉一致 FAIL + C08 §2 FAIL | 30 min |
| **F19** | 02 progress dot 3 空心灰圆描边加深（8% → 15-20% 灰）| C09/02 + C09/03 | C09 audit N7 极低 | 30 min |
| **F20** | 02 "Screen & System Audio" 描述断行成 2 行——调宽卡片或缩短文案 | C09/02 permission | C09 audit N6 low | 15 min |
| **F21** | 浅色版 01 MINIMAL hairline 加 1px 紫青 @ 30%（§3.5 浅色版定义）| C08/05 onboarding mark | C08 audit LR6 medium | 30 min |
| **F22** | 浅色版 hairline 从 8% 白 → 12% 黑（窗口边缘对比度）| C08/01-05 全部 | C08 audit LR1 low | 1h |
| **F23** | 04 review 副标题 "EN + 中文" 统一为占位符或真中文字串 | C08/04 review | C08 audit L10 + LR7 | 15 min |
| **F24** | C07 01 MINIMAL 右捺改直（用 C10 SVG master 替换）| C07/01 minimal | C07 audit V1 #5 中 | 30 min |
| **F25** | C07 对比图 "SF Pro 14pt 500" / "color #6B6B72" 删除，仅保留 3 个 label | C07 comparison | C07 audit V1 #1 中 | 30 min |

### 12.3 P2 — 建议做（6 项 · Figma 总工时约 2 小时）

| # | 修什么 | 在哪 | 证据 | 工时 |
|---|--------|------|------|------|
| **F26** | 01 mic button row end-call 红按钮风格确认（D1 §2.1 一致）| C08/01 | 已 PASS，可跳过 | 0 min |
| **F27** | Extension Zoom 视频 tile names "Alex Chen / Jordan Park / Sam Rivera / Riley Wu" 替换为 placeholder | C14 Zoom | C14 V1 修复项 | 30 min |
| **F28** | Extension 收藏夹条 favicon 重做（5 个真实 favicon：Yinghua / Zoom / Meet / Notion / Calendar）| C14 全部 | C14 V1 修复项 | 30 min |
| **F29** | Extension 视频 grid 加重 1 层 vibrancy blur（silhouette 太清晰）| C14 Meet | C14 V1 修复项 | 30 min |
| **F30** | Extension traffic light 缩到 12×12px（macOS 真实尺寸）| C14 全部 | C14 V1 修复项 | 15 min |
| **F31** | Extension Zoom "Yinghua · 录制中" 行替换（小红点 + 真中文 + JetBrains Mono 12pt）| C14 Zoom | C14 V1 修复项 | 15 min |

### 12.4 总工时

- **P0**：~8 小时
- **P1**：~4 小时
- **P2**：~2 小时
- **总计**：~14 小时（≈ 2 个工作日）

### 12.5 验证方法（Figma 后期修完后）

1. **10 张产品图**（C06 5 + C08 5）逐一过 10 项 × 5 张检查表（参考 C08 audit §1）
2. **2 张 app icon**（C10 01 + 02）逐一过 C07 audit §A-G
3. **3 张 onboarding 屏**（C06 05 + C09 02 + C09 03）过 10 项 × 3 检查表
4. **2 张 extension 图**（C14 Zoom + Meet）过 C14 STRICT RULES 10 项
5. **统一 4 套资产**：10 张产品图 Dock / 菜单栏 / 时钟 / 日历 day-name 必须全部一致

---

## 13. Round 4 状态（v2.0 新增 · C15-C22 shippable 包）

### 13.1 Round 4 目标

**3 个 shippable 包 = "映话 v0.1 alpha" 可给 5-10 个内部用户用**：

| 包 | 内容 | 价值 |
|----|------|------|
| **App shippable A**（C15）| Figma 终版 10 张产品图 + 3 个 onboarding 屏 + 2 个 app icon + 5 个 token 视觉参考 | 设计资产全部 ready |
| **App shippable B**（C16）| SwiftUI 编译通过 + 5 个 surface 有真实布局 + 业务逻辑接线（录制 + 转录 + BYOK）| **demo 跑得起来** |
| **Extension shippable**（C21）| Chrome extension Manifest V3 + 2 个图 + 实际加载到 Chrome 能弹出 | extension 入口 ready |

### 13.2 Round 4 任务清单

| C-series | 任务 | 依赖 | 状态 | 资源预算 |
|----------|------|------|------|---------|
| **C15** | Dark shippable 包（5 张深色 Figma 终版）| §12 P0 F1-F17（深色部分）+ F18 时钟 | ⏳ 2 工作日 | Figma 设计师 1 人 |
| **C16** | Light shippable 包（5 张浅色 Figma 终版）| §12 P0 F2/F3/F8/F9/F10-F12 + F21/F22（浅色部分）| ⏳ 2 工作日 | Figma 设计师 1 人 |
| **C17** | Onboarding shippable 包（3 屏 Figma 终版）| §12 P0 F1/F8/F9/F15/F16 + F19/F20 | ⏳ 1.5 工作日 | Figma 设计师 1 人 |
| **C18** | Marketing landing（hero + 2-3 sub-section）| 02 GRADIENT + §2 配色 + §7 反模式 | ⏳ 1.5 工作日 | Designer + 文案 |
| **C19** | Marketing social（Twitter banner + profile + 2-3 social card）| C11 复用 + 02 GRADIENT | ⏳ 1 工作日 | Designer |
| **C20** | （预留）|  |  |  |
| **C21** | Browser extension 代码（Manifest V3 + popup + content script）| C14 2 张图 + §3 C10 icon + §4 组件 | ⏳ 3-5 工作日 | Frontend dev 1 人 |
| **C22** | Design doc v2.0 收口（本文件）| 4 audit verdict + C10-C14 全部 | ✅ 完成 | — |

### 13.3 资源预算

- **Figma 设计师**：1 人 × ~6 工作日（C15+C16+C17+C18 部分 + 修 31 项 F1-F31）
- **SwiftUI dev**：1 人 × ~10 工作日（C13 业务逻辑接线 + 5 surface 真实数据 + 测试）
- **Frontend dev**（extension）：1 人 × ~3-5 工作日（C21）
- **Designer/文案**（marketing）：1 人 × ~2.5 工作日（C18+C19）
- **总人时**：~22-25 工作日（约 5 周 1 人 full-time，或 2.5 周 2 人并行）

### 13.4 验收标准（每包 shippable 必须满足）

#### App shippable A — Figma 终版

- [ ] 10 张产品图（C06 5 + C08 5）§12 P0 F1-F17 全部修复
- [ ] 3 屏 onboarding（C06 05 + C09 02 + C09 03）§12 P0 F1/F8/F9/F15/F16 全部修复
- [ ] 2 个 app icon（C10 01 + 02）替换占位 C13 AppIcon
- [ ] Figma library "Yinghua" 创建（用 C12 tokens sync）
- [ ] 主色 / 字体 / 圆角 / 间距 / 玻璃 / 反模式 全部 token 化
- [ ] 1 份 Figma → dev handoff 文档（每个 component 的 spacing / color / 状态）

#### App shippable B — SwiftUI 编译 + 业务逻辑

- [ ] xcodebuild BUILD SUCCEEDED（C13 已达成）
- [ ] 5 个 surface 真实数据（C13 当前是 stub）
  - [ ] `startRecording()` 接 `AVAudioEngine` tap + `SCStream` 系统音频
  - [ ] `transcriptLines` 接 `SpeechAnalyzer` (macOS 26) 或 Whisper.cpp
  - [ ] `summary` 接 BYOK API（OpenAI / Anthropic），key 存 `SecKeychain`
- [ ] Speaker diarization（按声纹分说话人，颜色稳定映射 §4.3）
- [ ] 持久化（SwiftData 或 GRDB 存 `MeetingRecord` 到 `~/Library/Application Support/Yinghua/`）
- [ ] 转录独立成屏（§5.1 独立 `Window` Scene）
- [ ] `prefers-reduced-motion` 全局尊重（§9.4）
- [ ] 浅色模式 token 补全 + `colorScheme` adaptive
- [ ] 性能预算达成（§9.2 6 项）

#### Extension shippable

- [ ] Manifest V3（service worker + content script + popup）
- [ ] Chrome Web Store 提交流程准备（screenshots + description + privacy）
- [ ] Zoom / Meet 自动检测 + 浮窗 default + expanded 两态（C14 设计）
- [ ] "开始录制" → 跳桌面 app 或发起 extension 内录制
- [ ] 1 个 unit test 覆盖 manifest / icon 路径

### 13.5 风险

| 风险 | 概率 | 影响 | 缓解 |
|------|------|------|------|
| Figma 设计师不到位 | 中 | C15-C19 延期 | 备份 designer / 用 Figma AI 插件辅助 |
| 业务逻辑接线超期 | 高 | App shippable B 延期 | 砍 5 surface 业务深度，先做 1-2 个 demo 路径 |
| SpeechAnalyzer API 不稳定（macOS 26 新）| 中 | 转录延迟 / 准确度不达标 | 备用 Whisper.cpp |
| Chrome Web Store 审核拒绝 | 低 | extension 入口延期 | 用 Firefox / Edge 备选 |
| Figma 后期修完仍有 1-2 个新 prompt 泄漏 | 中 | 需要再 audit | C15 完成后跑第 2 轮 audit |

---

## 14. 已知 V1 资产索引（v2.0 新增 · shippable 状态盘点）

### 14.1 已 shippable（可直接用 / 替换占位 / 进产品）

| 资产 | 路径 | 状态 | 替换/集成目标 |
|------|------|------|--------------|
| **C10 01 MINIMAL icon** | `_exploration/C10_vector-icon/icon-01-minimal-*.png` + `.svg` | ✅ shippable · 6 修复项全过 | 替换 C13 `AppIcon.appiconset` 占位 PNG（10 个）+ .icns 打包 |
| **C10 02 GRADIENT icon** | `_exploration/C10_vector-icon/icon-02-gradient-*.png` + `.svg` | ✅ shippable | Marketing 用途（C11 / C18 / C19）|
| **C11 Twitter banner 3:1** | `_exploration/C11_twitter-banner/twitter-banner-3-1__260823.png` | ✅ shippable | 直接上传 Twitter/X header |
| **C11 Twitter profile 1:1** | `_exploration/C11_twitter-banner/twitter-profile-1-1__260823.png` | ✅ shippable | 直接上传 Twitter/X profile |
| **C12 design tokens JSON** | `design/design-tokens.json` | ✅ shippable · 117 token · 5/5 验证 | Style Dictionary → Swift / CSS / Figma Tokens |
| **C13 SwiftUI scaffold** | `code/Yinghua/` | ✅ BUILD SUCCEEDED · 5 surface stub | 业务逻辑接线（C15+）|
| **C13 5 个 component** | `code/Yinghua/Yinghua/Components/*.swift` | ✅ shippable | 直接用 |
| **C13 5 个 model** | `code/Yinghua/Yinghua/Models/*.swift` | ✅ shippable | 直接用 |
| **C21 Chrome extension** | `code/yinghua-extension/` | ✅ Manifest V3 + icon 16/48/128 | C21 收口（popup + content script 待补）|

### 14.2 V1 资产（需要 §12 修 / 不直接 shippable）

| 资产 | 路径 | V1 状态 | 必须做的修复 |
|------|------|---------|-------------|
| **C06/01-05 5 张深色产品图** | `_exploration/C06_product-v3/0{1-5}-*/` | V1 · C06 audit PARTIAL | §12 F4/F5/F6/F7/F8/F9/F10/F13 |
| **C06 05 onboarding 品牌 mark** | C06/05 onboarding | V1 · 错用 02 GRADIENT | §12 F6 |
| **C07 02 GRADIENT** | `_exploration/C07_app-icon-v3/02-gradient-fill/app-icon-v3b-gradient__260822.png` | V1 · Y 中间缝 | §12 F17（用 C10 SVG master 替换）|
| **C07 01 MINIMAL** | C07/01-minimal-letterform/app-icon-v3a-minimal__260822.png | V1 · 右捺弯钩 | §12 F24（用 C10 SVG master 替换）|
| **C07 03 GLASS** | C07/03-glass-orb/ | ❌ 真弃用 | 不要 shippable |
| **C08/01-05 5 张浅色产品图** | `_exploration/C08_light-mode/0{1-5}-*/` | V1 · C08 audit PARTIAL | §12 F2/F3/F7/F8/F9/F10-F12/F14/F21/F22 |
| **C09/02-03 onboarding 后 2 屏** | `_exploration/C09_onboarding-flow/0{2-3}-*/` | V1 · C09 audit PARTIAL→FAIL 边界 | §12 F1/F15/F16 |
| **C14 Zoom + Meet extension 2 张图** | `_exploration/C14_browser-extension/browser-extension-{zoom,meet}__260823.jpg` | V1 · C14 README 已知 6 项 | §12 F27-F31 |

### 14.3 占位 / 临时资源

| 资产 | 路径 | 状态 |
|------|------|------|
| C13 `AppIcon.appiconset` 10 个 PNG | `code/Yinghua/Yinghua/Resources/Assets.xcassets/AppIcon.appiconset/` | 占位 · 用 C10 01 MINIMAL 替换 |
| C13 `Info.plist` usage description | `code/Yinghua/Yinghua/Info.plist` | 占位文案 · 改中文真实文案 |
| C13 项目 metadata（display name / bundle id）| `code/Yinghua/project.yml` | 占位 · 改 "映话" / `com.yinghua.zzw4257.cn` |

---

## 15. References（v2.0 新增 · 全索引）

### 15.1 设计母版 / Token

- **本文件 D1 v2.0**：`design/design-doc.md`（15 章 ~40KB）
- **D1 v1.0 历史**：`design/design-doc.md@v1.0`（Round 1 收口 11 章 19KB，备份在 git history）
- **CHANGELOG v1.0→v2.0**：[`_exploration/C22_design-doc-v2/CHANGELOG.md`](./_exploration/C22_design-doc-v2/CHANGELOG.md)
- **Design tokens JSON**：[`design/design-tokens.json`](./design-tokens.json)（C12 · 117 token）
- **C12 README**：[`_exploration/C12_design-tokens/README.md`](./_exploration/C12_design-tokens/README.md)

### 15.2 4 个 audit verdict

- **C06 product v3 5 张深色产品图**：[`_exploration/C06_product-v3/_audit-verdict.md`](./_exploration/C06_product-v3/_audit-verdict.md) — PARTIAL · 9 项 × 5 = 45 检查点
- **C07 app icon V3 3 变体**：[`_exploration/C07_app-icon-v3/_audit-verdict.md`](./_exploration/C07_app-icon-v3/_audit-verdict.md) — PARTIAL · 3 变体逐项 A-G
- **C08 light mode 5 张浅色产品图**：[`_exploration/C08_light-mode/_audit-verdict.md`](./_exploration/C08_light-mode/_audit-verdict.md) — PARTIAL · 10 项 × 5 = 50 检查点
- **C09 onboarding 后 2 屏**：[`_exploration/C09_onboarding-flow/_audit-verdict.md`](./_exploration/C09_onboarding-flow/_audit-verdict.md) — PARTIAL→FAIL 边界 · 10 项 × 2 = 20 检查点

### 15.3 设计资源（5 仓库 + 2 商业产品 + 5 视觉参考）

**开源项目**（5 个 · `design/_reference/`）：
- **Parrot** — 真实 macOS 录音 app 实现
- **AirTranslate** — 实时翻译 UI 模式
- **textream** — 实时转录 + AI 滚动
- **DockDoor** — Window preview 模式
- **AnswerCue** — AI 浮层交互

**商业产品**（2 个）：
- **Fathom**（marketing 文案语料 / 简洁定位模板）
- **Final Round**（AI 面试助手 / 直接竞品）

**视觉参考**（5 张 · `_exploration/C05_design-tokens-visual/`）：
- `ref-01-macos-base/macos-base-reference__260822.png`
- `ref-02-dock-system/ref-02-dock-system__260822.jpg`（**v2.0 强调 — Dock 12 项 master**）
- `ref-03-speaker-avatars/ref-03-speaker-avatars__260822.jpg`
- `ref-04-control-panel/ref-04-control-panel__260822.png`
- `ref-05-button-system/ref-05-button-system__260822.png`

### 15.4 探索产出（15 个 C-series）

| C-series | 标题 | 路径 | 状态 |
|----------|------|------|------|
| C01 | hero_brand | `_exploration/C01_hero_brand/` | done |
| C01 | redo | `_exploration/C01_redo/` | done |
| C02 | brand-assets | `_exploration/C02_brand-assets/` | done · **含 _design-system-prompt.md（§2.3 anti-leak + §2.4 Dock 12 项是 v2.0 新加）** |
| C03 | product-narrative | `_exploration/C03_product-narrative/` | done |
| C04 | polish | `_exploration/C04_polish/` | done |
| C05 | design-tokens-visual | `_exploration/C05_design-tokens-visual/` | done · 5 ref 图 |
| C06 | product-v3 | `_exploration/C06_product-v3/` | done · 5 张 + audit verdict |
| C07 | app-icon-v3 | `_exploration/C07_app-icon-v3/` | done · 3 变体 + audit verdict |
| C08 | light-mode | `_exploration/C08_light-mode/` | done · 5 张 + audit verdict |
| C09 | onboarding-flow | `_exploration/C09_onboarding-flow/` | done · 3 屏 + audit verdict |
| C10 | vector-icon | `_exploration/C10_vector-icon/` | done · **shippable** · 2 SVG + 12 PNG |
| C11 | twitter-banner | `_exploration/C11_twitter-banner/` | done · **shippable** |
| C12 | design-tokens | `_exploration/C12_design-tokens/` | done · **shippable** · 117 token |
| C13 | swiftui-scaffold | `_exploration/C13_swiftui-scaffold/` | done · **BUILD SUCCEEDED** |
| C14 | browser-extension | `_exploration/C14_browser-extension/` | done · 2 张图 + 6 V1 修复项 |
| C15 | dark-shippable | `_exploration/C15_dark-shippable/` | ⏳ Round 4 |
| C16 | light-shippable | `_exploration/C16_light-shippable/` | ⏳ Round 4 |
| C17 | onboarding-shippable | `_exploration/C17_onboarding-shippable/` | ⏳ Round 4 |
| C18 | marketing-landing | `_exploration/C18_marketing-landing/` | ⏳ Round 4 |
| C19 | marketing-social | `_exploration/C19_marketing-social/` | ⏳ Round 4 |
| C21 | browser-extension-code | `_exploration/C21_browser-extension-code/` | ⏳ Round 4 |
| C22 | design-doc-v2 | `_exploration/C22_design-doc-v2/` | ✅ done（本文件） |

### 15.5 实施代码

- **SwiftUI macOS app**（C13）：[`code/Yinghua/`](./code/Yinghua/) · **BUILD SUCCEEDED** · Xcode 26.6 · Swift 6.3.3
  - README：[`code/Yinghua/README.md`](./code/Yinghua/README.md)
  - 5 surface · 5 component · 5 model · 1 app entry
- **Chrome extension**（C21）：[`code/yinghua-extension/`](./code/yinghua-extension/) · Manifest V3 · icon 16/48/128
  - README：[`_exploration/C14_browser-extension/README.md`](./_exploration/C14_browser-extension/README.md)

### 15.6 5 个核心 surface 路径（深色 + 浅色 = 10 张 v3 图）

**深色版**（C06 v3 · 5 张）：
- `C06_product-v3/01-meeting-in-progress/product-meeting-in-progress-v3__260822.png`
- `C06_product-v3/02-empty-state/product-empty-state-v3__260822.png`
- `C06_product-v3/03-transcript-focus/product-transcript-focus-v3__260822.png`
- `C06_product-v3/04-review-mode/product-review-mode-v3__260822.png`
- `C06_product-v3/05-onboarding/product-onboarding-v3__260822.png`

**浅色版**（C08 · 5 张）：
- `C08_light-mode/01-meeting/product-meeting-in-progress-light__260823.jpg`
- `C08_light-mode/02-empty/product-empty-state-light__260823.jpg`
- `C08_light-mode/03-transcript/product-transcript-focus-light__260823.jpg`
- `C08_light-mode/04-review/product-review-mode-light__260823.jpg`
- `C08_light-mode/05-onboarding/product-onboarding-light__260823.jpg`

**Onboarding 后 2 屏**（C09）：
- `C09_onboarding-flow/02-permission/onboarding-02-permission__260823.jpg`
- `C09_onboarding-flow/03-byok/onboarding-03-byok__260823.jpg`

**Browser extension**（C14 · 2 张）：
- `C14_browser-extension/browser-extension-zoom__260823.jpg`
- `C14_browser-extension/browser-extension-meet__260823.jpg`

**Twitter**（C11 · 2 张）：
- `C11_twitter-banner/twitter-banner-3-1__260823.png`
- `C11_twitter-banner/twitter-profile-1-1__260823.png`

---

**v2.0 收口完成**。下一个改动（§6 强制 / §7 反模式 / §12 F1-F31 任一项）必须同步到 design-tokens.json + 本文件。Figma 后期按 §12 清单 batch 修，Round 4 shippable 包按 §13 推进。
