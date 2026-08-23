# 映话 (Yìnghuà) — Brand Guidelines v1.0

> **状态**：v1.0 · 2026-08-24
> **适用范围**：对外（landing / Product Hunt / 投资人 deck / social / 邮件）+ 对内（设计 / 工程 / 文案 / 招聘 / 客户支持）
> **真相源**：
> - 设计 prose：[`design/design-doc.md`](../design-doc.md) v2.0（D1 · 15 章 ~71KB）
> - 机器 token：[`design/design-tokens.json`](../design-tokens.json)（D2 · 117 token · W3C DTCG）
> - 设计系统母模板：[`design/_exploration/C02_brand-assets/_design-system-prompt.md`](../_exploration/C02_brand-assets/_design-system-prompt.md)
> - 4 个独立 audit：`_exploration/C06_product-v3/_audit-verdict.md` · `C07_app-icon-v3` · `C08_light-mode` · `C09_onboarding-flow`
> - 1 份综合 audit：`_exploration/_final-audit-report-c15-c19.md`
>
> **维护规则**：prose 改 → JSON 同步改 → 本文件同步改。三者 100% 一致是品牌严肃度的底线。

---

## 0. 阅读路径

| 你是 | 至少读 | 强烈推荐 |
|------|--------|----------|
| **新加入的 designer** | §1 身份 / §3 色彩 / §4 字体 / §5 间距圆角 / §10 反模式 | §2 Logo / §7 玻璃 / §9 语音文案 |
| **SwiftUI / Frontend dev** | §3 色彩 / §5 间距圆角 / §7 玻璃 / §8 组件 | §2 Logo / §6 动效 / §12 资产索引 |
| **Marketing / 文案** | §1 身份 / §9 语音文案 / §10 反模式 | §3 色彩 / §11 macOS 规范 |
| **Figma 同学** | 全部 | — |
| **下次 audit 的人** | §10 反模式 / §11 macOS / §12 资产 | §3 色彩 / §6 动效 |

---

## 1. 品牌身份（Brand Identity）

### 1.1 基本信息

| 字段 | 值 | Token / 证据 |
|------|-----|--------------|
| **中文名** | 映话 | D1 §1 |
| **拼音** | Yìnghuà | D1 §1 |
| **英文名** | Yinghua | D1 §1（与拼音不同，英文场景统一 Yinghua）|
| **英文副名** | Yìnghuà | 营销场景用，显示品牌声调 |
| **一句话定位** | macOS 26+ 原生、本地优先的会议 / 面试智能助手 | D1 §1 |
| **平台** | macOS 26+（Tahoe）· SwiftUI 6 + AppKit 互操作 | D1 §1 |
| **形态** | 单一桌面 app（无 companion app、无 web dashboard）· Chrome extension 辅助 | D1 §1 + §13.1 |
| **数据策略** | 本地优先 · 高级 BYOK（自备 OpenAI / Anthropic key）| D1 §1 + §9.3 |
| **核心能力** | 系统音频 + 麦克风录制 · 实时转录（说话人分离）· AI 总结（关键时刻 / 决定 / 待办 / 遗留问题）| D1 §1 |
| **第二大入口** | Chrome extension（Zoom / Meet 网页开会时浮窗）| D1 §1 + C14 / C21 |

### 1.2 调性主轴

> **Apple 克制 + 极光紫作 accent。**
>
> 不是 cyberpunk，不是 SaaS landing page，不是 AI hype。是一个"会出现在你 Dock 里，每天你都会打开几次"的 macOS app。

**调性锚点**：
- ✅ Apple keynote 简洁感
- ✅ 极光紫 `#B57BFF` 作 accent，**不**作大面积
- ✅ 暖白 `#F4F1EC` 主文字，**不**用纯白
- ✅ 中文优先，**不**用中文塞 prompt 让模型乱渲染
- ❌ cyberpunk / 霓虹 / 多色霓虹
- ❌ "AI 驱动 / 智能 / 革新"等营销词
- ❌ Bento 框 + 左侧 bold label 的 SaaS 套路

证据：D1 §1「调性主轴」· D1 §7 反模式 18 条 · C02 §1.1 品牌锁定 · 4 个 audit verdict 一致通过主调性。

### 1.3 核心价值观（4 个 · 不多不少 · 不用营销词）

| # | 价值 | 一句话解释 | 落地表现 |
|---|------|-----------|----------|
| 1 | **本地优先**（Local-first）| 你的数据不出设备 | 转录音频原文 30 天后自动清理（仅保留 transcript + summary）；网络请求仅在用户主动触发"AI 总结"时发生；App Sandbox + hardened runtime |
| 2 | **用户主权**（User sovereignty）| BYOK = 你看得见一切 | API key 存 macOS Keychain（`SecKeychain`），**绝不**上传到我们服务器；你随时可以导出所有数据 |
| 3 | **透明**（Transparency）| 没有黑盒 | AI 总结的每一段都标注来源时间码；说话人颜色映射规则公开；模型选择权交给你 |
| 4 | **安静**（Quietness）| 不用 AI hype 词汇 | 不说"AI 驱动"、"智能"、"革新"；用具体动词"录制 / 转录 / 总结"；icon 系统没有 sparkles 满天飞 |

证据：D1 §1「调性主轴」+ §9.3「本地优先」· C12 tokens `forbidden-patterns.NO_MARKETING_FLOURISH` · D1 §7 #6 禁词清单。

**反例（绝不作核心价值）**：
- ❌ "效率提升"、"全局掌控"（D1 §7 #6 营销词）
- ❌ "极致"、"完美"、"革命性"（D1 §7 禁词）
- ❌ "赋能"、"洞察"（C12 forbidden-patterns）
- ❌ "革新"、"重塑"、"颠覆"（D1 §7 禁词）

---

## 2. Logo 系统

### 2.1 Logo 资产（C10 已 shippable）

| Logo | 容器 | Y 字 | 用途 | 主文件 |
|------|------|------|------|--------|
| **01 MINIMAL** | squircle `#0A0A0F` 近黑 | solid `#F4F1EC` 暖白 | 主 icon / 系统内 / Dock / App Store | [`../C10_vector-icon/icon-01-minimal__260823.svg`](../C10_vector-icon/icon-01-minimal__260823.svg) |
| **02 GRADIENT** | squircle `#0A0A0F` + 15% 紫青 wash | `linear-gradient(135deg, #B57BFF, #8A5BFF, #2DD4BF)` | 营销 / 落地页 / Product Hunt / Twitter / Deck / 邮件 banner | [`../C10_vector-icon/icon-02-gradient__260823.svg`](../C10_vector-icon/icon-02-gradient__260823.svg) |

**统一 Y master**（C10 audit 修复 6 项关键发现）：
- V+stem 拓扑（V 是连续一笔，stem 是第二笔），三段几何端点精确汇聚在 `(512, 416)`，rounded join + cap 完美重叠，**零接缝**
- 笔宽 58px（占 1024 的 5.66%），两变体统一
- stroke-linejoin="round" + stroke-linecap="round"，三端点圆头收尾
- **右捺完全直**（C07 01 v3 弯钩已消除）

证据：C10 README §1.1 / §2.2 / §3 · C07 audit 6 修复项全过。

### 2.2 ❌ 弃用 mark（黑名单）

| 弃用 | 原因 | 证据 |
|------|------|------|
| C07 **02 v3 中间缝 Y**（三段不连续，视觉上像 V+I 叠）| C10 SVG master 已修 | D1 §3.4 · C10 §3 #1 HIGH |
| C07 **01 v3 弯钩右捺**（Apple Music 旧 logo 风格）| C10 SVG master 已改直 | D1 §3.4 · C10 §3 #3 中 |
| C07 **03 GLASS 玻璃球包 Y**（v3 调性异类）| 调性不符 v3 决定 | C07 §D.4 真弃用 · D1 §3.4 |
| C02 v2 **双环 / ∞ 形 / 聊天气泡 mark** | 让用户误以为 Notion / Loom | C02 v2 废弃 · D1 §7 #3 `NO_LEGACY_MARK` |
| C02 v1 **deprecated "OO" 概念图** | 早期探索 | C02 v1 废弃 |
| 任何带 **"AI" 字样** 烧图的 icon 变体 | C09 audit 验证 Anthropic 真渲成 "AI" 字母 | D1 §3.4 · D1 §7 #2 `NO_AI_TEXT_IN_ICON` |
| 任何用 **品牌名作为 icon 字母**（"node" / "Yinghua" 字符）| Figma 后期替换而非烧图 | D1 §3.4 + §7 #14 |
| 任何 **02 GRADIENT 做 Dock icon** | 16×16 渐变压缩为单色，Y 形状变模糊 | D1 §3.3 · C07 §E.1 |

### 2.3 应用规则（10+ 场景 · 锁定）

| 场景 | 用 | 理由 | 证据 |
|------|----|------|------|
| App icon `.icns`（macOS） | **01 MINIMAL** | 强对比保证 16×16 Dock 缩略可读 | D1 §3.3 · C07 §E.1 |
| Dock 16×16 / 32×32 / 64×64 | **01 MINIMAL** | 02 在 16×16 渐变丢失 | D1 §3.3 · C10 §5 |
| Finder 列表 / sidebar | **01 MINIMAL** | 256×128 finder 都稳 | D1 §3.3 |
| App Switcher | **01 MINIMAL** | 跟 Apple Notes / Reminders letterform icon 视觉重量一致 | D1 §3.3 · C07 §E.3 |
| App Store 1024×1024 | **01 MINIMAL** | Apple 审核偏好 flat squircle + letterform | D1 §3.3 |
| Onboarding 欢迎页内嵌 mark | **01 MINIMAL** | 跟主 icon 一致；避免 onboarding 跟 Dock 是两个不同 logo | D1 §3.3 · C06 audit N3 HIGH |
| Chrome extension icon 16/32/48 | **01 MINIMAL** | 16×16 必须可读 | C14 / C21 |
| **Landing hero** | **02 GRADIENT** | 紫青渐变视觉冲击力强 | D1 §3.3 · C18 README |
| **Product Hunt 缩略图**（240×240）| **02 GRADIENT** | 渐变仍可见，紫青对比在 PH 列表"跳出来" | D1 §3.3 · C18 §4 |
| **Twitter / X header**（3:1）| **02 GRADIENT** | social 出海一眼能记住 | D1 §3.3 · C11 + C19 §1 |
| **Twitter profile 1:1** | **02 GRADIENT** | Twitter 自动裁圆仍稳 | C19 §2 |
| **投资人 deck 封面** | **02 GRADIENT** | 紫青 = 科技感 + Apple 克制 | C19 §4 · C25 |
| **营销邮件 banner**（welcome / update / launch）| **02 GRADIENT** | 与 C18 landing hero 同一颗 Y | C19 §3 |
| **浅色版 onboarding 屏 mark** | **01 MINIMAL 浅色版** | 纯黑 mark 放 cream wallpaper 突兀 | D1 §3.5 · C08 audit L7 |

### 2.4 缩略图可读性测试（C10 §4 验证结果）

| 尺寸 | 01 MINIMAL | 02 GRADIENT | 结论 |
|------|------------|--------------|------|
| 1024×1024 | ✅ Y 清晰，撇捺分明 | ✅ Y 清晰，渐变方向可见 | 都可用（hero / 4K） |
| 256×256 | ✅ Y 清晰 | ✅ Y 清晰，渐变仍可见 | Finder 列表首选 01 |
| 128×128 | ✅ Y 清晰 | ✅ Y 清晰 | Finder sidebar 两者皆可 |
| 64×64 | ✅ Y 清晰，撇捺可辨 | ✅ Y 清晰，渐变压缩但仍可辨 | App Switcher 两者皆可；01 更稳 |
| 32×32 | ✅ Y 可辨 | ⚠️ 渐变接近单色 | 工具栏两者皆可；01 更稳 |
| **16×16** | ✅ **Y 仍可识别**（暖白对近黑对比强）| ❌ 渐变压缩为单色，Y 形状变模糊 | **16×16 仅 01 MINIMAL 可用** |

**为什么 01 MINIMAL 在 16×16 仍可识别**：
1. 暖白 `#F4F1EC` 对近黑 `#0A0A0F` 的 luminance 对比 ≈ 18:1（远超 WCAG AAA 7:1）
2. 撇捺角度对称（41.2° from vertical），低分辨率下保留 Y silhouette
3. 笔宽 58px / 1024 = 5.66%，缩到 16px 后 ≈ 0.91px，配合 anti-alias 不会完全消失

### 2.5 最小使用尺寸（缩略图规则）

| 形态 | 最小尺寸 | 备注 |
|------|----------|------|
| 01 MINIMAL 独立 icon | **16×16** | Dock 缩略 |
| 02 GRADIENT 独立 icon | **64×64** | 不能再小（16-32 渐变丢失） |
| Y 字 letterform 单独使用 | **24px** | UI 内部 mark（比 24px 更小看不清 Y 形） |
| 品牌锁 logo（Y icon + "映话" / "Yinghua" 文字）| **96px 宽** | Figma / 文档 / 名片 |
| App Store 1024×1024 | 1024×1024 | Apple 审核硬性要求 |
| Favicon | 32×32（用 01 MINIMAL）| Chrome extension / web |

### 2.6 浅色版 01 MINIMAL（v2.0 新增）

D1 §3.5 · C08 audit L7 修正。**Figma 终版两份独立 component**，不要做主题变体。

| 元素 | 深色版 | 浅色版 |
|------|--------|--------|
| squircle 容器 | `#0A0A0F` 近黑 | `#FFFFFF` 纯白（轻微 wash）|
| 容器 wash | 无 | 紫青渐变 wash @ 25% opacity |
| Y 颜色 | `#F4F1EC` 暖白 | `#FFFFFF` 纯白（区别于背景 wash）|
| 边缘 hairline | 1px 白色 6% | 1px 紫青 30% `#8A5BFF @ 30%` |
| 用途 | macOS 深色模式主窗体内嵌 mark | 浅色模式 onboarding 屏 |

---

## 3. 色彩（Color System）

> ⚠️ **本节是 ground truth**。所有 hex / rgba 必须与 [`design-tokens.json`](../design-tokens.json) `color.*` 严格一致。改 prose 必同步 token JSON。

### 3.1 主品牌色（Brand · Aurora Gradient）

| 名称 | Hex | 用途 | Token 路径 |
|------|-----|------|-----------|
| 紫 vivid | `#B57BFF` | Primary button 渐变起、speaker avatar A、focus ring | `color.brand.purple-vivid` |
| 紫 mid | `#8A5BFF` | 渐变中段、focus ring、speaker avatar 主色 | `color.brand.purple-mid` |
| 紫 deep | `#2A1240` | 玻璃暗色 wash、recording active dot 备用 | `color.brand.purple-deep` |
| 青 vivid | `#2DD4BF` | Primary button 渐变终、speaker avatar B、vivid 强调 | `color.brand.teal-vivid` |
| 青 deep | `#0E2A2A` | 玻璃暗色 wash | `color.brand.teal-deep` |

**主渐变公式**（3 stop · D1 §2.1）：
```
linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)
```
用于：Primary button · 02 GRADIENT Y 字 fill · 标题装饰细线 · 营销 hero 极光 backdrop。

**简化 2 stop 渐变**（UI 控件）：
```
linear-gradient(135deg, #B57BFF 0%, #2DD4BF 100%)
```
token: `color.brand.gradient-primary-2stop`

### 3.2 语义色（Semantic）

| 名称 | Hex | 用途 | Token 路径 |
|------|-----|------|-----------|
| 录制红 | `#FF3B30` | REC 红点、end-call 按钮、停止按钮 | `color.semantic.recording-red` |
| 警告橙 | `#FF9F0A` | 麦克风静音指示、电池警告 | `color.semantic.warning-orange` |
| 成功绿 | `#34C759` | macOS 系统色（沿用，不自定义）| `color.semantic.success-green` |
| 危险红 | `#FF453A` | macOS 系统色（沿用）| `color.semantic.danger-red` |
| Magenta active | `#E63FB8` | Dock Y 下方活动点（仅系统级）| `color.app-state.magenta-active` |

**用法**：
- `recording-red` 是**状态色**（在录 / 停止）
- `danger-red` 是**操作色**（破坏性：删除 / 退出账号）
- 两者**不可互换**（D1 §2.1）

### 3.3 中性色（Neutrals）

| 名称 | Hex / RGBA | 用途 | Token 路径 |
|------|-----------|------|-----------|
| 近黑 | `#0A0A0F` | App icon 主背景、splash、菜单栏底色 | `color.neutral.near-black` |
| 石墨 | `#1B1D22` | 窗口深色底、卡片底 | `color.neutral.graphite` |
| 玻璃深 | `rgba(10, 10, 15, 0.7)` | 玻璃 vibrancy base（深色模式）| `color.neutral.glass-deep` |
| 暖白 | `#F4F1EC` | 主文字（warm white，避免纯白刺眼）| `color.neutral.warm-white` |
| 次白 | `rgba(244, 241, 236, 0.8)` | 次要文字 | `color.neutral.secondary` |
| 静音白 | `rgba(244, 241, 236, 0.6)` | tertiary 文字、占位符 | `color.neutral.tertiary` |
| 灰边（深色模式）| `rgba(244, 241, 236, 0.08)` | 1px hairline border | `color.neutral.hairline` |
| 灰边（浅色模式）| `rgba(27, 29, 34, 0.12)` | 1px hairline border（C08 LR1 修正）| `color.neutral.hairline-light` |

> ⚠️ **永远不要用纯白 `#FFFFFF` 作文字**。刺眼。一律用 `color.neutral.warm-white` `#F4F1EC`。Apple Notes 同款。证据：D1 §2.1 注释 · C12 `forbidden-patterns.NO_PURE_WHITE_TEXT`。

### 3.4 Speaker 调色板（v2.0 8 色扩充）

D1 §4.3 扩充自 C12 4 色 → 8 色（v2.0）。STYLE 1 唯一调色板，系统内**只用这个**。

| # | Hex | 角色 | 命名 | Token |
|---|-----|------|------|-------|
| 1 | `#8A5BFF` | 紫（主）| `purple` | `color.speaker.purple` |
| 2 | `#2DD4BF` | 青（主）| `teal` | `color.speaker.teal` |
| 3 | `#FF6FA9` | 粉（主）| `pink` | `color.speaker.pink` |
| 4 | `#F4F1EC` | 暖白（主）| `warm-white-bg` | `color.speaker.warm-white-bg` |
| 5 | `#FF9F0A` | 橙（扩展，警告相关说话人）| `orange` | `color.semantic.warning-orange`（复用）|
| 6 | `#34C759` | 绿（扩展，主持人 / 你本人）| `green` | `color.semantic.success-green`（复用）|
| 7 | `#5E5CE6` | 靛（扩展）| `indigo` | 自定义 |
| 8 | `#BF5AF2` | 紫红（扩展）| `purple-magenta` | 自定义 |

**派生规则**（C13 `Speaker.color(for: id)`）：
```swift
let palette = ["#8A5BFF", "#2DD4BF", "#FF6FA9", "#F4F1EC",
               "#FF9F0A", "#34C759", "#5E5CE6", "#BF5AF2"]
let color = palette[abs(id.hashValue) % palette.count]
```
**同一说话人 id 跨场景用同色**（`UserDefaults` / SwiftData 持久化：`speaker_{id}_color`）。

### 3.5 玻璃 wash（Dark Mode）

| 元素 | 规格 | Token |
|------|------|-------|
| 玻璃暗色 wash | `linear-gradient(135deg, rgba(181, 123, 255, 0.15) 0%, rgba(45, 212, 191, 0.15) 100%)` | `color.glass.aurora-wash` |
| 玻璃边缘高光 | `rgba(244, 241, 236, 0.08)` | `color.glass.edge-highlight` |
| 阴影 tint | `rgba(0, 0, 0, 0.5)` | `color.glass.shadow-tint` |

### 3.6 浅色模式配色（C08 audit LR1 / D1 §2.7）

色彩反转规则：

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

**Figma 终版用同一份 SwiftUI 代码 + colorScheme adaptive 渲染**。

### 3.7 浅色 vs 深色对比表

| 维度 | 深色模式 | 浅色模式 |
|------|----------|----------|
| 背景 | 近黑 + 紫青 15% wash | 暖白 + 紫青 10% wash |
| 主文字 | `#F4F1EC` | `#1B1D22` |
| 次文字 | `#F4F1EC @ 80%` | `#1B1D22 @ 65%` |
| 卡片边框 | 1px @ 8% 白 | 1px @ 12% 黑 |
| Primary 按钮 | 紫青渐变 + 白字 | 紫青渐变 + 白字 |
| REC 红 | `#FF3B30` | `#FF3B30` |
| 品牌色 | 紫青 | 紫青（**不变**）|
| 玻璃材质 | `.regularMaterial`（深） | `.regularMaterial`（白）|
| 桌面 wallpaper | 极光深空 | 暖白 cream + 极淡 wash |

### 3.8 ❌ 禁用色

| 禁色 | 原因 | 证据 |
|------|------|------|
| 纯白 `#FFFFFF` 文字 | 刺眼 | D1 §2.1 注释 · C12 `NO_PURE_WHITE_TEXT` |
| 任何"neon"色 | cyberpunk / 廉价感 | D1 §7 #10 `NO_NEON_GLOW` · #11 `NO_MULTI_NEON` |
| 任何**渐变描边** | 是 ChatGPT 的"两圆相交"icon 套路 | D1 §7 #9 `NO_TWO_CIRCLES_CHAT_ICON` |
| 任何**外发光 / glow / halo** | cyberpunk | D1 §7 #10 `NO_NEON_GLOW` |
| 紫 + 粉 + 青 + 黄**全上**（多色霓虹）| 散乱 | D1 §7 #11 `NO_MULTI_NEON` · 最多 2-3 色：紫 + 青 + （REC 红）|
| **星空银河 / 行星**作为背景（除桌面壁纸外）| 俗气 + cyberpunk 感 | D1 §7 #4 `NO_STARFIELD_BG` |
| macOS 系统色 success-green / danger-red 之外的自定义"绿 / 蓝" | 跟系统色冲突 | D1 §2.1 |

### 3.9 色彩验证脚本（C12 §5.4 验证）

```bash
# 所有 D1 §2.1 颜色 hex 都在 JSON 里
python3 -c "
import json
text = open('design/design-tokens.json').read()
for hex_code in ['B57BFF', '8A5BFF', '2A1240', '2DD4BF', '0E2A2A',
                 'FF3B30', 'FF9F0A', '34C759', 'FF453A',
                 '0A0A0F', '1B1D22', 'F4F1EC', 'FF6FA9']:
    assert hex_code in text, f'MISSING {hex_code}'
print('13/13 hex FOUND')
"
```

---

## 4. 字体（Typography）

### 4.1 字体家族

| 用途 | 字体 | 字重 | Token |
|------|------|------|-------|
| 大标题（≥24pt）| **SF Pro Display** | 600 / 700 | `typography.font-family.display` |
| 正文（≥14pt）| **SF Pro Text** | 400 / 500 | `typography.font-family.text` |
| 等宽（时间码 / ID）| **JetBrains Mono** | 500 | `typography.font-family.mono` |
| 中文（叙事段落 / 副标题）| **Noto Serif SC** | 400 / 600 | `typography.font-family.serif-zh` |
| 中英混排正文 | SF Pro Text 中文 fallback **Noto Sans SC** | 400 | `typography.font-family.sans-zh` |

**字体 fallback chain**：
- display: `SF Pro Display, system-ui, -apple-system` (中文 → Noto Sans SC)
- text: `SF Pro Text, system-ui, -apple-system` (中文 → Noto Sans SC)
- mono: `JetBrains Mono, ui-monospace, SFMono-Regular`
- serif-zh: `Noto Serif SC, Songti SC, serif`
- sans-zh: `Noto Sans SC, PingFang SC, sans-serif`

### 4.2 中英排版规则

| 场景 | 字体 | 例子 |
|------|------|------|
| 营销 hero 大标 | **Noto Serif SC** Bold（中文）· **Newsreader Display** Bold（英文）| 映话 / Yinghua |
| 营销副标 | SF Pro Display Medium（英文）· Noto Sans SC Medium（中文）| "为面试而生的 macOS 智能助手" |
| UI 中文正文 | SF Pro Text → Noto Sans SC fallback | 录制中 · 转录中 · 总结 |
| UI 英文 | SF Pro Text | "Start Recording" / "Save" / "Cancel" |
| 时间码 / Speaker ID | **JetBrains Mono** Medium | 21:42 · 02:34 |
| 转录文本 | SF Pro Text 14pt | "今天我们聊一下映话的设计" |
| 中文长文阅读（onboarding 欢迎语 / 副标）| **Noto Serif SC** | "你的会议，应该安静一点" |
| 邮件 / 营销长文 | Noto Serif SC 标题 + Noto Sans SC 正文 | 欢迎来到映话 |

### 4.3 字号梯度（D2 `font-size`）

| 名称 | 尺寸 | 用途 | Token |
|------|------|------|-------|
| display-1 | 32pt | Hero / 大标题 — onboarding 欢迎语 | `typography.font-size.display-1` |
| display-2 | 24pt | Section 标题 / 空状态主标 | `typography.font-size.display-2` |
| body-1 | 15pt | 主正文 / Button label | `typography.font-size.body-1` |
| body-2 | 14pt | 次正文 / Transcript 行内容 | `typography.font-size.body-2` |
| caption | 12pt | 副标题 / meta tag / 时间码 | `typography.font-size.caption` |
| mono-sm | 12pt | 时间码 / Speaker ID（配 mono family）| `typography.font-size.mono-sm` |

### 4.4 字重梯度（D2 `font-weight`）

| 名称 | 值 | 用途 |
|------|-----|------|
| regular | 400 | 正文、transcript 行内容 |
| medium | 500 | 强调、时间码、按钮 hover |
| semibold | 600 | 大标题、按钮主操作 |
| bold | 700 | 营销 hero 大标（Noto Serif SC 营销场景） |

### 4.5 中文优先（铁律）

**所有用户可见的标点、按钮、标签、bullet 都用中文**。英文仅出现在：
- 技术术语（API / BYOK / Live transcript / Recording）
- 品牌名（Yinghua）
- 占位符文案（Figma 后期替换）

**中文优先的反例（C17 audit 抓到的）**：
- ❌ "Get started 600 15pt ↗"（prompt 规则烧图 · C06 audit N8+N9）
- ❌ "STYLE 1" 作为 UI label（C06 audit N7）
- ❌ "Yinghua ~14pt regular"（字号定义烧图 · C06 audit N8）

证据：D1 §2.2「中文优先」· D1 §7 #13 `NO_PROMPT_TEXT_LEAK` · C02 §2.3 anti-leak 6 案例。

### 4.6 ❌ 字体相关禁

| 禁 | 原因 | 证据 |
|----|------|------|
| ❌ 用 web 字体模拟 SF Pro | 用真 .ttf 或系统字体 | D1 §6.4 |
| ❌ 把字号定义（"14pt 500"、"@ 65%"、"STYLE 1"）作为可见 UI 文字 | 模型把 prompt 规格当 UI label 渲染 | C02 §2.3 · D1 §7 #13 |
| ❌ "AI" 字样烧进 icon / hero | 占位符 Figma 后期替换 | D1 §7 #2 |
| ❌ 品牌名（"node" / "Yinghua"）作为 icon 字母 | D1 §3.4 + §7 #14 |

---

## 5. 间距与圆角（Spacing & Radius）

### 5.1 间距（8pt Grid · D2 `spacing`）

所有 padding / margin / gap 都是 4 / 8 / 12 / 16 / 20 / 24 / 32 / 40 / 48 的整数倍。

| Token | 值 | 用途 |
|-------|-----|------|
| `spacing.0` | 0 | 无 |
| `spacing.xs` | 4px | 8pt grid 起点 |
| `spacing.sm` | 8px | 8pt grid 主单位 |
| `spacing.md` | 12px | Card 内 padding / 列表行间距 |
| `spacing.lg` | 16px | Section padding / 控件间距 |
| `spacing.xl` | 20px | Card 间距 / 大控件 padding |
| `spacing.2xl` | 24px | Section 间距 |
| `spacing.3xl` | 32px | 屏级 padding / 容器间距 |
| `spacing.4xl` | 40px | Hero 段间距 |
| `spacing.5xl` | 48px | 屏顶 / 屏底留白 |

### 5.2 圆角梯度（D2 `radius`）

| Token | 值 | 元素 | 证据 |
|-------|-----|------|------|
| `radius.sm` | 6px | Section header chevron | D1 §2.3 |
| `radius.md` | 8px | 输入框 | D1 §2.3 |
| `radius.lg` | 12px | 按钮 primary / secondary、卡片 | D1 §2.3 + §4.1 |
| `radius.xl` | 14px | 窗口（macOS 标准）| D1 §2.3 |
| `radius.2xl` | 16px | 大卡片 / 文件卡 | D1 §2.3 |
| `radius.window` | 14px | 窗口圆角 alias | D1 §2.3 |
| `radius.button` | 12px | 按钮圆角 alias | D1 §2.3 + §4.1 |
| `radius.icon-squircle` | **22.4%** | App icon 容器（macOS superellipse）| D1 §2.3 + §3.1 |
| `radius.circle` | 50% | Avatar / Icon 按钮 / Toggle pill | D1 §2.3 + §4.3 |

### 5.3 元素-圆角映射（速查）

| 元素 | 圆角 | Token |
|------|------|-------|
| 窗口 | 14px | `radius.window` |
| App icon | 22.4%（squircle superellipse）| `radius.icon-squircle` |
| 按钮（primary / secondary）| 12px | `radius.button` |
| 按钮（icon 圆形）| 50% | `radius.circle` |
| 按钮（toggle pill）| 50%（胶囊）| `radius.circle` |
| 卡片 / 文件卡 | 12-16px | `radius.lg` / `radius.2xl` |
| 输入框 | 8px | `radius.md` |
| Avatar | 50% | `radius.circle` |
| Section header chevron | 6px | `radius.sm` |

---

## 6. 动效（Motion）

> ⚠️ **`prefers-reduced-motion` 是铁律，不是 nice-to-have**。所有动效在用户开启系统 reduce motion 时必须退化为 fade。

### 6.1 Duration 4 档（D2 `motion.duration`）

| Token | 值 | 用途 |
|-------|-----|------|
| `motion.duration.instant` | **80ms** | 按钮 press（scale 1.0 → 0.98，ease-in）|
| `motion.duration.fast` | **120ms** | 按钮 hover（scale 1.0 → 1.02，spring）|
| `motion.duration.normal` | **220ms** | 折叠段展开（height 0 → auto，spring）|
| `motion.duration.slow` | **250ms** | 窗口出现（scale 0.96 → 1.0 + opacity 0 → 1，ease-out）|
| `motion.duration.recording-pulse` | 1400ms | REC 红点 pulse（1.0 → 1.15 → 1.0，infinite）|
| `motion.duration.dock-bounce` | 4000ms | Dock Y 图标 4s 一次 bounce（4px amplitude）|

### 6.2 Easing 4 档（D2 `motion.easing`）

| Token | 值 | 用途 |
|-------|-----|------|
| `motion.easing.standard` | `cubic-bezier(0.4, 0, 0.2, 1)` | 默认 |
| `motion.easing.spring` | `cubic-bezier(0.34, 1.56, 0.64, 1)` | 略 overshoot — 按钮 hover / 折叠段展开 |
| `motion.easing.ease-out` | `cubic-bezier(0, 0, 0.2, 1)` | 出场 — 窗口出现 |
| `motion.easing.ease-in` | `cubic-bezier(0.4, 0, 1, 1)` | 按钮 press |

### 6.3 prefers-reduced-motion 铁律

```swift
@Environment(\.accessibilityReduceMotion) var reduceMotion

let animation: Animation = reduceMotion
    ? .easeInOut(duration: 0.1)           // 退化为 fade
    : .spring(response: 0.22, dampingFraction: 0.85)

withAnimation(animation) { ... }
```

```css
@media (prefers-reduced-motion: reduce) {
  * { transition: opacity 100ms ease; }
}
```

**D2 token JSON 强制**：`motion.reduce.respect-prefers-reduced-motion = true`。

证据：D1 §2.6 · C12 §3 motion section · C12 `motion.reduce` section。

### 6.4 动效是表达关系，不是装饰

- ✅ 优先：layoutId / camera push / state transition
- ✅ 次之：scale / opacity / rotate
- ❌ 禁：装饰性 sparkles 散落（`NO_DECORATIVE_SPARKLES`）· glow / halo 外发光

---

## 7. 玻璃与材质（Glass & Material）

### 7.1 三种 macOS 26 材质

| 材质 | SwiftUI | 用途 | Token |
|------|---------|------|-------|
| `.regularMaterial` | `NSVisualEffectView` | 主窗口背景（vibrancy）| `material.regular` |
| `.popoverMaterial` | `NSVisualEffectView` | 浮层、tooltip、菜单 | `material.popover` |
| `.sidebarMaterial` | `NSVisualEffectView` | 侧栏（如有）| `material.sidebar` |

### 7.2 自绘暗色 wash（D2 `color.glass`）

在 `.regularMaterial` 上方叠加一层 aurora tint：

```swift
.background(.regularMaterial)
.overlay {
    LinearGradient(
        colors: [
            Color(red: 0.71, green: 0.48, blue: 1.0).opacity(0.15),  // 紫
            Color(red: 0.18, green: 0.83, blue: 0.75).opacity(0.15)  // 青
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
```

token: `color.glass.aurora-wash = linear-gradient(135deg, rgba(181, 123, 255, 0.15) 0%, rgba(45, 212, 191, 0.15) 100%)`

### 7.3 ❌ 禁用 `.ultraThinMaterial`（双层防御）

D1 §2.5 · D1 §6.4 铁律。**玻璃太轻会糊**。强制使用 material.regular / popover / sidebar。

**双层防御**（C12 §6.3）：
1. `material.ultraThin.value = "FORBIDDEN"`（token 显式标 FORBIDDEN，dev 查 token 一眼看到）
2. `forbidden-patterns.NO_ULTRA_THIN_GLASS.value = "forbidden"`（规则 section 记录）

无论从哪个入口查（Style Dictionary / Tokens Studio / 手翻 JSON），都能看到禁用标记。

### 7.4 玻璃不要滥用

**只有窗口、浮层、卡片需要玻璃**。
- ❌ 文字行内不套玻璃
- ❌ Dock 已经是系统玻璃，不需要再叠

### 7.5 浅色模式玻璃（C08 audit LR1）

- 深色模式 hairline：`rgba(244, 241, 236, 0.08)`（暖白 @ 8%）
- **浅色模式 hairline**：`rgba(27, 29, 34, 0.12)`（石墨 @ 12%，浅色背景上可见，对比度提升 50%）
- 浅色模式 aurora wash 强度：**10%**（深色是 15% — 浅色底色已经亮，wash 过强会脏）

---

## 8. 组件库（Component Library · 6 个核心组件）

### 8.1 5 种按钮（D1 §4.1 · C13 已 shippable 3 种）

| 类型 | 高度 | 圆角 | 背景 | 文字色 | 用途 | Token |
|------|------|------|------|--------|------|-------|
| **Primary** | 36-48 | 12 | 紫青渐变（`#B57BFF → #2DD4BF`，135°）| `#FFFFFF` | 单一主操作（"开始录制"、"Get started"、"Share"）| `button.primary` |
| **Secondary** | 36 | 12 | 玻璃 `.regularMaterial` + 1px 8% 白边 | `#F4F1EC` | 次要操作（"Copy summary"、"Export PDF"）| `button.secondary` |
| **Icon（圆形）**| 32 | 50% | 玻璃 | 图标色 | 工具栏（mic / camera / share）| `button.icon` |
| **Toggle（胶囊）**| 28 | 50% | on: 紫青；off: 玻璃 | 跟随 on/off | 开关（speaker mute）| `button.toggle` |
| **Ghost** | 24 | 0 | 透明，hover 时 1px 8% 白下划线 | `#F4F1EC @ 60% → 100%` | "Done"、"Cancel"、"Regenerate" | `button.ghost` |

**三态派生**：

| 状态 | 默认 → 派生规则 | Token |
|------|---------------|-------|
| **default** | base | `button.{type}.default` |
| **hover** | background opacity 0.85 → 1.0；或 wash +5% | `button.{type}.hover` |
| **pressed** | scale 0.98（80ms ease-in）| `motion.easing.ease-in` |
| **disabled** | background opacity → 50%；文字色 → `#F4F1EC @ 40%`；cursor: not-allowed | `button.{type}.disabled` |
| **focus** | 2px `#8A5BFF` focus ring，offset 2px | `color.brand.purple-mid` |

**铁律**（D1 §4.1 + C12 `NO_TWO_PRIMARY_BUTTONS`）：单屏最多 1 个 Primary。2x2 网格（review-mode）里 3 个 Secondary + 1 个 Primary 是允许的，因为 Share 是 hero CTA。**Primary × 2 / 屏 = 反模式**。

### 8.2 4 段式控制面板（D1 §4.2 · C13 `ControlPanelWindowController` 已 shippable）

会议进行中右下角浮窗，3 段式（v2.0 修正自 C08 audit L6）：

```
┌─────────────────────────────────┐
│ ● REC      02:34                │  ← status 段（红点 + 时间码）
├─────────────────────────────────┤
│  ⏸    ⏹    ▶                   │  ← transport 段（暂停 / 停止 / 继续）
├─────────────────────────────────┤
│  ⚙    ⬆    ✕                   │  ← secondary 段（设置 / 分享 / 关闭）
└─────────────────────────────────┘
```

**铁律**：
- 控制面板内**禁止任何 waveform / EKG / sine wave / audio visualizer**。只用红点 + 时间码传达"在录"。C12 `forbidden-patterns.NO_WAVEFORM` 显式禁。
- 控制面板是浮动小窗（`NSPanel` with `.floating` level + `.nonactivatingPanel`）
- 3 段之间用 1px 8% 白 hairline 分隔
- transport 按钮是 Icon（圆形）

### 8.3 Speaker Avatar（C13 `SpeakerAvatar.swift` 已 shippable · STYLE 1 唯一）

- 圆形，36px（列表）/ 28px（紧凑列表）/ 20px（chip 内）
- 背景：纯色（紫 `#8A5BFF` / 青 `#2DD4BF` / 粉 `#FF6FA9` / 暖白 `#F4F1EC`），**不渐变**
- 文字：白色（暖白底用石墨色），SF Pro Text 600，**首字母大写**
- 同一说话人跨场景用同色（颜色按 id hash 稳定，C13 `Speaker.color(for: id)` 用 `abs(id.hashValue) % palette.count`）

**8 色调色板**见 §3.4。

**STYLE 2-4 仅在 marketing 截图里出现**（青粉渐变 / 紫色几何 / 暖白方块），系统内**只用 STYLE 1**。C07 §D 验证 v3 调性下 STYLE 2-4 与产品图不协调。

### 8.4 File Card（review-mode 用 · C13 `ReviewModeView` 已 shippable）

- 容器：12px 圆角，玻璃 + 1px 8% 白边
- 左侧：紫色 Y file icon（48x48，C07 02 GRADIENT 缩略）
- 中间：标题（16pt SF Pro Text 600）+ 副标题（12pt 次白）
- 右侧：Open pill button（Secondary 风格，36x28）
- meta tag 行：3 个小灰底胶囊（`MP4` / `中英双语` / `2 位发言人`）

**Thumbnail 派生**（D1 §4.4 v2.0 新增）：

| 场景 | File icon 变体 |
|------|---------------|
| 音频文件 | 紫色 Y + 底部 audio waveform 简化版（**不是 waveform visualizer**，是 3 条静态水平线 + 1 个 dot）|
| 视频文件 | 紫色 Y + 底部 play triangle |
| 文本文件 | 紫色 Y + 底部 document lines（3 条静态横线）|
| 未知 | 紫色 Y 单独 |

### 8.5 Transcript Row（C13 `TranscriptFocusView` 已 shippable）

- 高度：~64px（list）/ ~48px（compact list）
- 左：STYLE 1 avatar 28-36px
- 中：bold 名字（14pt 600）+ 时间码（12pt JetBrains Mono 500 次白）+ 1 行 Lorem ipsum（14pt 400）
- **时间码永远跟名字同行，不另起**（D1 §4.5）

**Speaker color 持久化**（v2.0 强调）：
- 同一说话人 id 在不同 meeting 里颜色**保持一致**（除非用户手动改）
- 存 `UserDefaults` 或 SwiftData：`speaker_{id}_color = #HEX`
- 颜色映射用 `SpeakerColor.from(id: UUID)` 静态函数

### 8.6 Collapsible Section Card（C13 `CollapsibleSectionCard.swift` 已 shippable）

- 容器：12px 圆角，1px 8% 白边，玻璃
- Header 行：左 icon（16px）/ bold 标题（16pt 600）/ 右 chevron（toggle 时旋转 90°）
- 折叠时只显示标题 + 计数 badge（"3 items"）
- 展开时 bullet 列表，每 bullet 前 4px 圆点（紫/青/粉 循环）

**Spring 动效 spec**（D1 §4.6 v2.0 新增）：

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

**4 段标准**（C06 v3 review-mode 锁定）：
1. **关键瞬间**（Key moments）— 紫 icon
2. **决定**（Decisions）— 青 icon
3. **待办**（Action items）— 粉 icon
4. **遗留问题**（Open questions）— 暖白 icon

---

## 9. 语音与文案（Voice & Copy）

### 9.1 中文优先（铁律）

**所有用户可见的标点、按钮、标签、bullet 都用中文**。英文仅出现在：
- 技术术语（API / BYOK / Live transcript / Recording）
- 品牌名（Yinghua）
- 占位符文案（Figma 后期替换）

**示例**（来自 C18 README / C19 README）：
- ✅ "免费下载" / "开始录制" / "转录中" / "总结" / "保存" / "分享" / "导出"
- ❌ "Get started" / "Start Recording" / "Summarize"

### 9.2 ❌ 禁用词清单（18 条 · D1 §7 #6 + 4 audit 提炼）

| 类别 | 禁用词 | 原因 | 证据 |
|------|--------|------|------|
| **版本词** | v1 / v2 / v3 / v4 | 命名铁律 — 用日期+场景 | D1 §11 · C02 §4 |
| | test / draft / final-final / revised / updated | 同上 | D1 §11 |
| **营销词**（D1 §7 #6）| 洞察 | 营销词、空话 | C12 `NO_MARKETING_FLOURISH` |
| | 赋能 | 同上 | C12 `NO_MARKETING_FLOURISH` |
| | 智能化 | 同上 | D1 §7 #6 |
| | 效率提升 | 同上 | D1 §7 #6 |
| | 全局掌控 | 同上 | D1 §7 #6 |
| | AI 驱动 | 同上（带 "AI" 字样更敏感）| D1 §7 #6 |
| | 智能 | 跟"AI 驱动"同族 | D1 §7 #6 |
| **浮夸词** | 革新 | 状态词升级 | D1 §7 #6 |
| | 重塑 | 同上 | D1 §7 #6 |
| | 颠覆 | 同上 | D1 §7 #6 |
| | 极致 | 同上 | D1 §7 #6 |
| | 完美 | 同上 | D1 §7 #6 |
| | 革命性 | 同上 | D1 §7 #6 |
| | 划时代 | 同上 | D1 §7 #6 |
| **prompt 泄漏**（D1 §7 #13）| 14pt / 600 15pt / @ 65% / STYLE 1 / PRIMARY / 50% OPACITY | 模型把规格当 UI label 渲染 | C02 §2.3 · C06/C17/C19 audit |
| **icon 烧词** | "AI" / "node" / 品牌名作为 icon 字母 | Figma 后期替换而非烧图 | D1 §3.4 + §7 #14 · C09 audit V1-P3-1 |

### 9.3 ✅ 推荐动词（具体 / 可执行）

| 动词 | 英文 | 用途 |
|------|------|------|
| 录制 | Record | 主操作 |
| 转录 | Transcribe | 实时转录 |
| 总结 | Summarize | AI 总结 |
| 保存 | Save | 持久化 |
| 分享 | Share | 导出 / 协作 |
| 导出 | Export | 文件导出 |
| 复制 | Copy | 剪贴板 |
| 删除 | Delete | 破坏性操作 |
| 停止 | Stop | 录制控制 |
| 暂停 | Pause | 录制控制 |
| 继续 | Resume | 录制控制 |

### 9.4 ✅ 推荐形容词（事实 / 状态）

| 形容词 | 英文 | 适用 |
|--------|------|------|
| 本地 | Local | 本地优先 |
| 实时 | Live / Real-time | 转录延迟 < 800ms |
| 安静 | Quiet | 调性主轴 |
| 干净 | Clean | UI / 文案 |
| 透明 | Transparent | BYOK / 说话人识别 |
| 原生 | Native | SwiftUI 6 + AppKit |
| 简短 | Brief | 文案长度 |

### 9.5 ❌ 状态词不许升级（铁律 · 来自用户偏好）

- ❌ "under review" ≠ "已发表"
- ❌ "paused" ≠ "完成"
- ❌ "V1 资产" ≠ "可上"

**事实纪律**：不报没测过的数字。否定结果主动展示。证据：C17/C19 audit 抓到的 3 处 X placeholder（"X" / "X users" / "X NPS"）全部是状态词升级的反例。

### 9.6 文案长度规则

| 场景 | 长度 | 例子 |
|------|------|------|
| 按钮 label | 1-4 字 | "开始录制" / "保存" / "取消" |
| 章节标题 | 6-12 字 | "实时转录" / "AI 总结" |
| 副标 / tagline | 14-24 字 | "为面试而生的 macOS 智能助手" |
| Onboarding 欢迎语 | 8-16 字 | "你的会议，应该安静一点" |
| 邮件 subject | 12-20 字 | "欢迎来到映话" / "What's new in 映话" |
| Blog 标题 | 16-32 字 | "映话是怎么在 macOS 26 上做系统音频捕获的" |

### 9.7 ❌ 不要用 emoji 代替 icon（D1 §6.4）

emoji 是**字符**，不是 icon。它们在不同系统渲染不一致，会破坏品牌严肃度。

- ❌ "🎙️ 录制中"（emoji）
- ✅ "● REC 02:34"（红点 + 文本 + 时间码 · D1 §4.2 控制面板规范）

---

## 10. 反模式（Anti-Patterns · 18 条 + 6 条 prompt 泄漏反例）

> 任何产品图、UI 截图、marketing 出片如果出现这些，必须返工或 Figma 后期修。
>
> 来源：D1 §7 18 条 + 4 audit verdict 提炼的 6 条 prompt 泄漏反例 + C02 §2.3 anti-leak 6 案例。

### 10.1 v1.0 12 条（沿用 · D1 §7.1）

| # | 反模式 | 为什么禁 | 证据 / Token |
|---|--------|----------|--------------|
| 1 | ❌ 任何 waveform / EKG / sine wave / audio visualizer | macOS 录音 UI 用红点+时间码，waveform 是 web/SaaS 套路 | C06 §4.2 · C12 `NO_WAVEFORM` |
| 2 | ❌ "AI" 字样烧进 icon / hero | 占位符 Figma 后期替换，但绝不直接烧图 | C06 N7 · C09 V1-P3-1 · C12 `NO_AI_TEXT_IN_ICON` |
| 3 | ❌ 双环 / ∞ / 聊天气泡 mark | 已废弃的 v2 方向，会让用户误以为这是 Notion/Loom | C02 v2 · C12 `NO_LEGACY_MARK` |
| 4 | ❌ 星空银河背景（除桌面壁纸外）| 俗气 + cyberpunk 感 | C12 `NO_STARFIELD_BG` |
| 5 | ❌ Bento 框 + 左侧 bold label | AI 生成的 SaaS landing 套路，Apple 不这么做 | C12 `NO_BENTO_FRAME` |
| 6 | ❌ 营销词：洞察 / 赋能 / 智能化 / 效率提升 / 全局掌控 / AI 驱动 | 状态词升级、空话、不专业 | D1 §7 #6 · C12 `NO_MARKETING_FLOURISH` |
| 7 | ❌ Pie / donut / gauge / radar chart | 真实 macOS app 几乎不用 | C12 `NO_PIE_DONUT_GAUGE` |
| 8 | ❌ 装饰性 sparkles 散落在 hero | sparkles 只能用在 AI 总结 section 的 marker | C12 `NO_DECORATIVE_SPARKLES` |
| 9 | ❌ 渐变描边的"两圆相交"对话图标 | 是 ChatGPT 的 icon，不要撞 | C12 `NO_TWO_CIRCLES_CHAT_ICON` |
| 10 | ❌ Glow / halo / 霓虹外发光 | cyberpunk / 廉价感 | C12 `NO_NEON_GLOW` |
| 11 | ❌ 多色霓虹（紫 + 粉 + 青 + 黄全上）| 散乱。最多 2-3 色 | C12 `NO_MULTI_NEON` |
| 12 | ❌ 把中文塞进 prompt 让模型渲染 | 模型必乱码，必 Figma 后期替换 | D1 §7 #12 · C17 audit |

### 10.2 v2.0 新增 6 条（D1 §7.2 · C06-C09 audit 提炼）

| # | 反模式 | 为什么禁 | 证据 |
|---|--------|----------|------|
| 13 | ❌ **prompt 规则文字泄漏为可见 UI**（"STYLE 1" / "@ 65%" / "14pt regular" / "600 15pt" / "PRIMARY" / "graphite @ 65%" / "50% OPACITY"）| 模型把 prompt 里的字号 / 样式标签 / 抽象概念当 UI label 渲染 | C06 N7-N9 · C07 audit · C08 audit 01 FAIL (13 处) · 02 FAIL (7 处) · C17 03 byok FAIL (12 处) · C19 email-launch FAIL · C02 §2.3 anti-leak 6 案例 · C12 `NO_PROMPT_TEXT_LEAK` |
| 14 | ❌ **品牌名作为 icon 字母**（"AI" / "node" / "OpenAI" / "Anthropic" 等）| 用 provider 概念卡 / icon 字母代替真实 brand mark | C09 V1-P3-1 (Anthropic "AI" 字母 FAIL HIGH) · V1-P3-3 (Custom "node" 文字 low) |
| 15 | ❌ **Dock 顺序跨图不一致 / 缺分隔点 / 第 5 位错放 Contacts/Photos** | macOS Dock 是 12 项固定结构，模型对 Notes 视觉记忆极不稳定 | C06 audit N2+N4 · C08 L2/L5/L6 · C09 N2 · C05 ref-02 是 ground truth |
| 16 | ❌ **日历 day-name 乱码**（"MIY" / "SUN" / "ПАН" / "NEN" / "MEM" / "MEN" / "HOR" / "DON" / "MAAN" / "ONLY" / "麦月"）| 模型在没有 day name spec 时生成乱码字符 | C06 N11 · C08 L13 · C09 N3 · 5 张图 5/5 出现 |
| 17 | ❌ **App Switcher 里 icon 不可读**（16×16 缩略后 Y 笔画糊掉、02 渐变压缩为单色）| Dock / App Switcher 是真实使用场景 | C07 §E.1 验证 02 GRADIENT 16×16 不可读 → 只用 01 MINIMAL 做 Dock |
| 18 | ❌ **Extension / 浮窗默认态过抢戏**（default 60×60 圆形气泡 + 强 color + 大状态点 → 用户没交互时抢戏）| 浮窗设计原则是"natural discovery"——不打扰、克制 | C14 README §设计理念 + C14 V1 修复项 |

### 10.3 6 条 prompt 泄漏反例（C02 §2.3 提炼 · 4 audit 一致）

| 泄漏内容 | 出现位置 | 严重度 |
|----------|----------|--------|
| `STYLE 1` 文字作为 avatar 区段标题 | C06 04 review transcript 列上方 | HIGH |
| `Yinghua ~14pt regular`（字号定义）| C06 05 onboarding 副标题 | HIGH |
| `Get started 600 15pt ↗`（按钮字号定义）| C06 05 onboarding CTA | HIGH |
| `AI` 字母作为 Anthropic provider card icon | C09 03 byok | HIGH |
| `node` 文字作为 Custom provider card icon | C09 03 byok | low |
| 日历 Dock 文字 `MIY` / `NEN` / `MEM` / `ПАН` / `麦月`（应渲染 `26`）| C06/C09/C15/C16 5+ 批 | medium |

**addendum（C02 §2.3）必须在每个生图 prompt 末尾追加**：

```
STRICT RULES (anti-leak addendum):
- Do NOT render any text that appears inside the prompt itself.
  Specifically forbidden visible text: "~14pt regular", "600 15pt",
  "STYLE 1", "STYLE 2", "AI", "node", "TEST", "Sample", "Placeholder",
  or any font-size / weight / style spec from the prompt.
- Do NOT render brand names as icon glyphs. Provider cards (OpenAI /
  Anthropic / Custom) and other concept tiles must use abstract geometric
  shapes (diamond / chevron / square / circle), never letters or words.
- Do NOT invent labels for app menu names, status bars, or dock
  indicators. If you don't know what the macOS UI text should be,
  leave that area empty.
- The Dock calendar app icon must show the number "26" (or any
  two-digit number). Do NOT render gibberish text like "MIY" or
  Cyrillic characters.
```

**C19 audit 新增 5 条 P0 addendum**（5 批综合）：
- **ADDENDUM 9**（CRITICAL P0）：禁任何 font-size spec 作为可见 UI 文字
- **ADDENDUM 6**（P0）：日历 day name 白名单 `MON/TUE/WED/THU/FRI/SAT/SUN`
- **ADDENDUM 7**（P0）：禁百分比 label
- **ADDENDUM 8**（P0）：菜单栏右侧只允许标准系统图标
- **ADDENDUM 10**（P0）：禁 literal X/Y/Z 作 placeholder

证据：`_final-audit-report-c15-c19.md` §2。

---

## 11. macOS 规范（macOS Standards · 锁定）

所有 v3 产品图 prompt 都引用这些规则。任何破坏规则的图必须重出，或 Figma 后期修。4 个 audit 反复验证：这些规则是底线，不允许 prompt 偏离。

### 11.1 菜单栏（顶 · 6 项结构 · C09 audit N1 强调）

- 黑色毛玻璃（深色）/ 白毛玻璃（浅色）
- **6 项固定结构**（缺一不可）：
  1. Apple logo（最左）
  2. **app 名**（"Yinghua" — 当映话是前台 app 时；"Finder" — 当 Finder 是前台时）
  3. App 菜单（plain English：`File Edit View Window Help`）
  4. （左半结束）
  5. 状态图标（Control Center / Battery / Wi-Fi / Search）
  6. 时钟（最右）

**v2.0 强制**：prompt 模板末尾必须显式写 `"Apple logo + app name 'Yinghua' + 'File Edit View Window Help' + battery/Wi-Fi/search icons + clock"`，禁止只写 "Apple + 4 menu"。

**C16 audit 抓到的失败模式**：菜单栏右侧出现 "e1n" 红色乱码 → ADDENDUM 8：菜单栏右侧只允许标准系统图标（battery, Wi-Fi, Bluetooth, Spotlight, Control Center, Time Machine, Notifications, Time）。

### 11.2 Dock（底 · 12 项固定顺序 · D1 §6.2 强锁）

**11 个真实 macOS 系统图标 + 1 分隔点 + 1 映话 Y = 12 元素**：

| # | 元素 | 必须性 |
|---|------|--------|
| 1 | Finder（蓝白脸）| ✅ 强制 |
| 2 | Safari（蓝色指南针）| ✅ 强制 |
| 3 | Messages（绿色对话气泡）| ✅ 强制 |
| 4 | Mail（蓝色信封）| ✅ 强制 |
| 5 | **Notes（黄色记事本）**| ✅ 强制（**prompt 必须显式写 "macOS Notes (yellow notepad)"**，模型视觉记忆极不稳定）|
| 6 | Calendar（白色页面 + "26"）| ✅ 强制（日历 day-name 必删或真渲染）|
| 7 | Reminders（白色 list + 红/黄/绿点）| ✅ 强制 |
| 8 | Maps（地图）| ✅ 强制 |
| 9 | Music（红色音符）| ✅ 强制 |
| 10 | System Settings（灰色齿轮）| ✅ 强制 |
| 11 | **分隔点**（小圆点）| ✅ 强制（**5 张图 5/5 缺** — C06 audit N2）|
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
- ❌ 任意 2 张图之间 Dock 顺序不一致（**Figma 后期统一 1 套 master dock**，从 C05 ref-02 裁切 12 个 icon 固定贴入）
- ❌ 日历顶部 day-name 乱码

### 11.3 窗口装饰（D1 §6.3）

- 三色 traffic light（红 / 黄 / 绿）在窗口左上角（**不可隐藏**——macOS 用户依赖它）
- 标题栏：14px 圆角窗口的 vibrancy 顶部条
- 无边框时不要把 traffic light 藏起来
- SwiftUI 用 `WindowGroup` 默认（系统自带 traffic light，C13 已验证）

### 11.4 时钟统一（C06 / C08 audit 抓到的失败模式）

- 5 张产品图（C06 5 + C08 5）时钟**必须统一**
- v1.0 写 21:42（设计 doc 示例值）；v2.0 接受 22:14（每张图统一即可，**绝对不允许** 21:42 / 22:14 / 09:42 跨图不一致）
- 锁方法：从 C05 ref-01 裁切菜单栏，固定贴入 10 张图

### 11.5 禁止行为（D1 §6.4 · v2.0 扩充）

- ❌ 不用 emoji 代替 icon（D1 §6.4 · §9.7）
- ❌ 不用 web 字体模拟 SF Pro（用真 .ttf 或系统字体）
- ❌ 不用 `.ultraThinMaterial` 之类过轻的玻璃（会糊）— C12 token + forbidden 双层防御
- ❌ 不强制 light mode——跟随系统（C13 SwiftUI 用 `@Environment(\.colorScheme)`）
- ❌ 不在 prompt 里把"14pt" / "STYLE 1" / "@ 65%" / "AI" 等规则文字作为可见 label（§7 #13）
- ❌ 不在 prompt 里给 provider / concept card 用品牌名作为 icon（§7 #14）
- ❌ 不在 prompt 里给 macOS UI 元素（菜单 / 状态栏 / Dock 指示）发明 label（§7 #13 + C02 §2.3）

---

## 12. 资产索引（Asset Index · C01-C28 全部）

### 12.1 已 shippable（可直接用 / 替换占位 / 进产品）

| 资产 | 路径 | 状态 | Token / 集成目标 |
|------|------|------|-----------------|
| **C10 01 MINIMAL icon** | [`../C10_vector-icon/icon-01-minimal-*.png`](../C10_vector-icon/) + `.svg` | ✅ shippable · 6/6 修复项全过 | 替换 C13 `AppIcon.appiconset` 占位 PNG（10 个）+ .icns 打包 |
| **C10 02 GRADIENT icon** | [`../C10_vector-icon/icon-02-gradient-*.png`](../C10_vector-icon/) + `.svg` | ✅ shippable | Marketing 用途（C11 / C18 / C19）|
| **C11 Twitter banner 3:1**（旧版 21:9）| [`../C11_twitter-banner/twitter-banner-3-1__260823.png`](../C11_twitter-banner/) | ✅ shippable | Twitter/X header（已被 C19 1500×500 3:1 替换）|
| **C11 Twitter profile 1:1**（旧版）| [`../C11_twitter-banner/twitter-profile-1-1__260823.png`](../C11_twitter-banner/) | ✅ shippable | 已被 C19 1:1 替换 |
| **C12 design tokens JSON** | [`../design-tokens.json`](../design-tokens.json) | ✅ shippable · 117 token · 5/5 验证 | Style Dictionary → Swift / CSS / Figma Tokens |
| **C13 SwiftUI scaffold** | [`../../code/Yinghua/`](../../code/Yinghua/) | ✅ BUILD SUCCEEDED · 5 surface stub | 业务逻辑接线（Round 4+）|
| **C13 5 个 component** | `code/Yinghua/Yinghua/Components/*.swift` | ✅ shippable | PrimaryButton / SecondaryButton / SpeakerAvatar / CollapsibleSectionCard / ControlPanel |
| **C13 5 个 model** | `code/Yinghua/Yinghua/Models/*.swift` | ✅ shippable | DesignTokens / Meeting / Speaker / Summary / AppState |
| **C18 landing hero 3 变体** | [`../C18_marketing-landing/landing-hero-{product,typography,quote}__260824.png`](../C18_marketing-landing/) | ✅ 6/6 PASS | landing page hero（A/B/C 测）|
| **C18 PH cover** | [`../C18_marketing-landing/product-hunt-cover__260824.png`](../C18_marketing-landing/) | ✅ PASS | Product Hunt 缩略图 |
| **C18 blog header × 2** | [`../C18_marketing-landing/blog-header-{launch,engineering}__260824.png`](../C18_marketing-landing/) | ✅ 2/2 PASS | blog 头图 |
| **C19 twitter banner 3:1**（真）| [`../C19_marketing-social/twitter-banner-3-1__260824.png`](../C19_marketing-social/)（1500×500）| ✅ PASS | 直接上传 Twitter/X header |
| **C19 twitter profile 1:1** | [`../C19_marketing-social/twitter-profile-1-1__260824.png`](../C19_marketing-social/) | ✅ PASS | Twitter profile |
| **C19 email × 3** | [`../C19_marketing-social/email-hero-{welcome,product-update,launch}__260824.png`](../C19_marketing-social/) | ✅ 3/3 PASS（launch FAIL 中 font spec 已修）| 营销邮件 header（welcome / update / launch）|
| **C19 deck cover** | [`../C19_marketing-social/deck-cover__260824.png`](../C19_marketing-social/) | ✅ PASS（Figma 后期填 "X" → 真实数据）| 投资人 deck 第一页 |
| **C21 Chrome extension 代码** | [`../../code/yinghua-extension/`](../../code/yinghua-extension/) | ✅ Manifest V3 + icon 16/48/128 | C21 popup + content script 已 shippable |

### 12.2 与 C10 SVG / C12 tokens / C13 SwiftUI 的关系

```
                 ┌──────────────────────────────┐
                 │  D1 design-doc.md v2.0       │ ← prose 真相源
                 │  (15 章 · 71KB)              │
                 └──────────┬───────────────────┘
                            │
              ┌─────────────┼─────────────┐
              ↓             ↓             ↓
     ┌──────────────┐ ┌──────────┐ ┌──────────────┐
     │ C12 JSON     │ │ C10 SVG  │ │ C13 SwiftUI  │
     │ 117 token    │ │ 2 master │ │ 5 surface    │
     │ W3C DTCG     │ │ 12 PNG   │ │ 5 component  │
     └──────┬───────┘ └────┬─────┘ └──────┬───────┘
            │              │              │
            │       ┌──────┴──────┐       │
            │       ↓             ↓       ↓
            │  C18 landing   C19 social  Yinghua.app
            │  C11 Twitter   C25 deck
            │  C21 extension icons
            │
            └─→ Figma Tokens / Style Dictionary / Web
```

- **C10 SVG master** → Figma 终版 / .icns 打包 / Chrome extension icon
- **C12 tokens JSON** → Figma Tokens plugin / Style Dictionary → Swift / CSS
- **C13 SwiftUI** → macOS app 主二进制 + `DesignTokens.generated.swift` 自动生成

### 12.3 V1 资产（需 §12 D1 v2.0 修 / 不直接 shippable）

| 资产 | 路径 | V1 状态 | 必做的修复（D1 §12 P0-F 编号）|
|------|------|---------|----------------------------------|
| C06 5 张深色产品图 | [`../C06_product-v3/0{1-5}-*/`](../C06_product-v3/) | V1 · C06 audit PARTIAL | F4/F5/F6/F7/F8/F9/F10/F13 |
| C08 5 张浅色产品图 | [`../C08_light-mode/0{1-5}-*/`](../C08_light-mode/) | V1 · C08 audit PARTIAL | F2/F3/F7/F8/F9/F10/F11/F12/F14/F21/F22 |
| C09 02-03 onboarding | [`../C09_onboarding-flow/0{2-3}-*/`](../C09_onboarding-flow/) | V1 · C09 audit PARTIAL→FAIL | F1/F15/F16 |
| C14 Zoom + Meet extension 2 张图 | [`../C14_browser-extension/browser-extension-{zoom,meet}__260823.jpg`](../C14_browser-extension/) | V1 · 6 项已知 | F27-F31 |
| C07 02 GRADIENT v3 旧 PNG | [`../C07_app-icon-v3/02-gradient-fill/`](../C07_app-icon-v3/) | V1 · Y 中间缝 | F17（用 C10 SVG master 替换）|
| C07 01 MINIMAL v3 旧 PNG | [`../C07_app-icon-v3/01-minimal-letterform/`](../C07_app-icon-v3/) | V1 · 右捺弯钩 | F24（用 C10 SVG master 替换）|
| C07 03 GLASS | [`../C07_app-icon-v3/03-glass-orb/`](../C07_app-icon-v3/) | ❌ **真弃用** | 不要 shippable |

### 12.4 占位 / 临时资源

| 资产 | 路径 | 状态 |
|------|------|------|
| C13 `AppIcon.appiconset` 10 个 PNG | `code/Yinghua/Yinghua/Resources/Assets.xcassets/AppIcon.appiconset/` | 占位 · 用 C10 01 MINIMAL 替换 |
| C13 `Info.plist` usage description | `code/Yinghua/Yinghua/Info.plist` | 占位文案 · 改中文真实文案 |
| C13 项目 metadata | `code/Yinghua/project.yml` | 占位 · 改 "映话" / `com.yinghua.zzw4257.cn` |
| C24 iOS icon set | [`../C24_ios-icon-set/AppIcon.appiconset/`](../C24_ios-icon-set/) | 占位 · 用 C10 01 MINIMAL 替换 |

### 12.5 5 个核心 surface 路径（D1 §15.6 · 10 张 v3 图）

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

---

## 附录 A · 命名铁律

- ✅ 真实使用场景：`landing-hero` / `social-producthunt-card` / `recording-active` / `summary-complete` / `app-icon` / `meeting-in-progress` / `empty-state` / `transcript-focus` / `review-mode` / `onboarding`
- ❌ 禁用：`v1` / `v2` / `v3` / `v4` / `test` / `draft` / `final-final` / `revised` / `updated`
- 版本信息用 **日期**（`__260822`）和 **场景** 表达

证据：D1 §11 · C02 §4 命名规范。

---

## 附录 B · 维护规则

1. **D1 改 → JSON 同步改 → 本文件同步改**。三者 100% 一致是品牌严肃度的底线。
2. **新增 token 必须进 forbidden check**。任何新加视觉元素先看 `forbidden-patterns` 15 条，撞了改设计。
3. **命名走角色不走向量**。`color.brand.purple-vivid` 不叫 `color.purple-light` — 按角色划。
4. **改动必须过 [C12 §5 验证](../C12_design-tokens/README.md#5-验证方法) 5 项**。任何 PR / 提交前跑一次全套验证。
5. **版本号更新**。任何 breaking change → `$metadata.version` bump minor。新增 token → patch。
6. **反模式** 18 条 + 6 条 prompt 泄漏 + 5 条 C19 addendum 是底线。Figma 精修前先过反模式清单。

---

## 附录 C · 验证脚本（一键自检）

```bash
# 1. JSON 语法合法
python3 -m json.tool design/design-tokens.json > /dev/null && echo "JSON_VALID"

# 2. D1 §2 子节所有 token 都在
python3 -c "
import json
d = json.load(open('design/design-tokens.json'))
required = [
    'color.brand.purple-vivid', 'color.brand.purple-mid', 'color.brand.teal-vivid',
    'color.semantic.recording-red', 'color.neutral.near-black', 'color.neutral.warm-white',
    'typography.font-family.display', 'typography.font-family.serif-zh',
    'radius.window', 'radius.icon-squircle', 'radius.button',
    'spacing.sm', 'spacing.lg', 'spacing.xl',
    'motion.duration.instant', 'motion.duration.fast', 'motion.duration.normal', 'motion.duration.slow',
    'material.regular', 'material.popover', 'material.sidebar',
    'app-icon.y-geometry.height-pct', 'app-icon.y-geometry.width-pct',
]
for p in required:
    cur = d
    for k in p.split('.'):
        cur = cur.get(k, None) if isinstance(cur, dict) else None
    assert cur is not None and 'value' in cur, f'MISSING: {p}'
print(f'OK: all {len(required)} D1 §2 paths present')
"

# 3. 所有 hex 都在 JSON
python3 -c "
import json
text = open('design/design-tokens.json').read()
for hex_code in ['B57BFF', '8A5BFF', '2A1240', '2DD4BF', '0E2A2A',
                 'FF3B30', 'FF9F0A', '34C759', 'FF453A',
                 '0A0A0F', '1B1D22', 'F4F1EC', 'FF6FA9']:
    assert hex_code in text, f'MISSING {hex_code}'
print('13/13 hex FOUND')
"

# 4. forbidden-patterns 数量 ≥ 15
python3 -c "
import json
d = json.load(open('design/design-tokens.json'))
print(f'forbidden-patterns: {len(d[\"forbidden-patterns\"])}')
assert len(d['forbidden-patterns']) >= 15
"

# 5. 0 反模式踩雷（grep 营销词）
for word in 洞察 赋能 智能化 效率提升 全局掌控 AI驱动 革新 重塑 颠覆 极致 完美 革命性 划时代; do
    ! grep -r --include="*.swift" --include="*.swiftui" --include="*.tsx" -l "$word" code/ 2>/dev/null
done && echo "无营销词泄漏"
```

---

**Brand Guidelines v1.0 收口完成。下一个改动（D1 / D2 / 反模式任一项）必须同步更新本文件。**
