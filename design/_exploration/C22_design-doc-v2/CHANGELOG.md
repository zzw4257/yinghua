# Design Doc v1.0 → v2.0 CHANGELOG

## 摘要

- **v1.0**（2026-08-22 22:00）：Round 1 收口，11 章 19K
- **v2.0**（2026-08-23 02:00）：Round 1+2+3 收口，15 章 ~40K

**v2.0 定位**：从"产品图定调"升级到"全资产可施工"。把 4 轮 audit 找出的所有可量化问题固化为 machine-checkable 规则，让 Figma 后期 batch 修 + SwiftUI 实施 + Chrome extension 实施都有单一真相源。

## 新增章节

| 章 | 标题 | 价值 |
|----|------|------|
| **§0** | 版本 + 变更摘要 | 让人 30 秒内搞清 v2 改了什么、为什么改 |
| **§12** | Figma 后期 batch 修清单 | 4 audit 找出的 30+ V1 issue，按 P0/P1/P2 优先级排序，Figma 同学照单全做 |
| **§13** | Round 4 状态 | C15-C22 计划 / 资源预算 / 验收标准（shippable 包）|
| **§14** | 已知 V1 资产索引 | 哪些 shippable（C06/C07/C10/C11/C12/C13）哪些 V1（C08/C09/Dock/master 统一）|
| **§15** | References 全索引 | 5 仓库 + 2 商业产品 + 4 audit verdict + C12 tokens + C13 source + C21 extension 路径全索引 |

## 既有章节更新

| 章 | 改动内容 | 来源 |
|----|----------|------|
| **§1 身份** | 不变（Round 1 已收口）| — |
| **§2 视觉语言** | 2.1 加 "C12 design-tokens.json 是 ground truth" 引用；2.5 玻璃加 .ultraThin 禁用理由（**双层防御** — token value=FORBIDDEN + forbidden-patterns 双重标记）；2.6 动效加 reduced-motion 铁律（**token + doc 同步**）| C12 tokens §2 / §6.3 |
| **§3 图标系统** | 3.1 加 C10 矢量 SVG master 路径（01 + 02）；3.2 加 marketing 用途表（5 场景）；3.3 应用规则表扩充（10+ 场景）；3.4 扩充"不再使用"清单（**v1 / v2 双环 + 03 GLASS** + 任何"AI"字母）| C10 README §5 / C07 audit §D |
| **§4 组件库** | 4.1 按钮加 **disabled / hover / pressed 三态派生**；4.3 Speaker 加 **8 色调色板**（system 4 + extended 4）；4.4 File card 加 thumbnail 派生；4.5 Transcript row 加 **speaker color 持久化**（按 id hash 稳定）；4.6 Collapsible 加 **spring 动效 spec**（0.22s response 0.5 dampingFraction 0.85）| C12 speaker tokens / C13 SpeakerAvatar / C13 CollapsibleSectionCard |
| **§5 产品表面** | 5.1 加 **"转录独立成屏 — 用独立 Window Scene"**（C13 已 mark 必做）；5.2 层次 4 层（桌面 / 虚化上下文 / 映话主控 / 浮层）| C13 下一步工作 / C02 §1.0 4 层视觉层次 |
| **§6 macOS 强制规范** | 6.1 菜单栏必须含 app 名（"Yinghua"）；6.2 Dock **强制 12 项顺序**（10 系统 + 1 分隔点 + 1 Y）；**5 张图不一致时 Figma 后期统一 master dock**；6.3 traffic light 不可隐藏；6.4 新增 **"禁止行为"**（emoji 替 icon / web font 模拟 SF Pro / 强制 light mode 等 4 条）| C02 §2.4 / C06 audit N2 / C08 audit §3.3 |
| **§7 反模式** | 从 12 条扩到 **18 条**，新增 6 条：prompt 规则文字泄漏 / Dock 顺序跨图不一致 / 日历 day-name 乱码 / 品牌名作为 icon 字母（如 "AI"）/ App Switcher 里 icon 不可读 / extension 默认态过抢戏 | C07 audit / C06 audit N1-N11 / C08 audit L1-L13 / C09 audit N1-N11 / C14 README |
| **§8 参考库** | 加 C07 矢量 icon master / C12 design-tokens.json / C13 SwiftUI 源码（已 BUILD SUCCEEDED）/ C21 Chrome extension 源码 | C10/12/13/21 |
| **§9 实现注意** | 9.1 详细 SwiftUI code pattern（v1.0 没有）；9.2 性能预算（v1.0 简略 → v2 加 measurement 方法）；9.3 本地优先加 **"transcript 默认 30 天清理"**（v1.0 已说但未强调；v2 显式 token）| C13 Models/DesignTokens.swift / C12 `transcript-retention` token（待 C15 加）|
| **§10 自检** | **重写**：每模块带证据路径 + Round 1+2+3 状态 + Round 4 计划 | 4 audit 证据汇总 |
| **§11 命名铁律** | 不变（Round 1 已是铁律）| — |

## Round 1+2+3 关键决策（沉淀到 v2.0）

| # | 决策 | 来源 | v2 落地 |
|---|------|------|---------|
| D1 | 紫青 = brand 渐变（`#B57BFF` → `#2DD4BF` 对角）| C06 v3 + C07 02 GRADIENT | §2.1 表格 |
| D2 | 暖白 `#F4F1EC` 是主文字色（不是 #FFFFFF）| C06 v3 5/5 PASS | §2.1 表格 |
| D3 | **01 MINIMAL 是主 icon，02 GRADIENT 是 marketing 备用** | C07 audit §D + §F | §3.3 表 |
| D4 | 03 GLASS **真弃用**（不是第 4 候选）| C07 audit §D.4 | §3.4 ❌ 列表 |
| D5 | **macOS Notes 必须在 Dock 第 5 位**（模型对 Notes 视觉记忆极不稳定）| C09 audit N2 + C08 audit L5 | §6.2 强制表 + §7 反模式 |
| D6 | **Dock 必须 12 项固定顺序**（10 系统 + 1 分隔点 + 1 Y）| C02 §2.4 / C09 audit N2 | §6.2 强制表 + §7 反模式 |
| D7 | **菜单栏必须含 app 名 "Yinghua"**（不是只 "File Edit View"）| C06 N1 + C08 L9 + C09 N1 | §6.1 强制表 |
| D8 | **Prompt 规则文字禁止渲染**（"STYLE 1" / "@ 65%" / "14pt regular" / "AI" 等）| C06 N7-N9 + C07 audit + C08 01/02 FAIL | §7 反模式 #13 |
| D9 | **日历 day-name 必须删或真渲染**（"MIY" / "SUN" / "ПАН" / "NEN" / "MEM" 全部禁）| C06 N11 + C08 L13 + C09 N3 | §7 反模式 #15 |
| D10 | **Speaker 颜色按 id hash 稳定**（同一说话人跨场景同色）| C13 Speaker.swift | §4.3 调色板 |
| D11 | **prefers-reduced-motion 铁律**（不是 nice-to-have）| C12 motion.reduce + C13 README | §2.6 表格 + §7 反模式 |
| D12 | **transcript 默认 30 天清理**（音频原文；保留 transcript + summary）| v1.0 §9.2 沿用 | §9.3 |
| D13 | **Window scene 而非 Tab 切换**（meeting / transcript 各自独立窗口）| C13 下一步工作 §必做 | §5.1 单屏铁律 |
| D14 | **玻璃 hairline 浅色模式 @ 12-15%**（深色仍 @ 8%）| C08 audit LR1 | §2.5 浅色规则 |
| D15 | **浅色模式 01 MINIMAL 派生**（白底 + 紫青 wash @ 25% + 白 Y）| C08 audit L7 | §3.5 浅色版定义 |

## 来源依据

- **4 个 audit verdict**：
  - `C06_product-v3/_audit-verdict.md` — 5/5 PARTIAL · 9 项 × 5 = 45 检查点 · 新发现 N1-N11
  - `C07_app-icon-v3/_audit-verdict.md` — 总体 PARTIAL · 3 变体逐项 A-G · 6 条 Figma 修复项
  - `C08_light-mode/_audit-verdict.md` — 总体 PARTIAL · 10 项 × 5 = 50 检查点 · 新发现 L1-L13
  - `C09_onboarding-flow/_audit-verdict.md` — PARTIAL 接近 FAIL 边界 · 10 项 × 2 = 20 检查点 · 新发现 N1-N11 · 屏 3 Anthropic "AI" 字母 1 个 FAIL
- **C10 SVG master** 修复 C07 6 项（中间缝 / Y master 统一 / 右捺改直 / 笔画粗细统一 / 03 弃用 / 标签清理）
- **C12 117 token JSON** = 颜色 26 + 字体 15 + 间距 10 + 圆角 10 + 动效 11 + elevation 4 + z-index 5 + breakpoint 4 + material 4 + app-icon 13 + forbidden-patterns 15
- **C13 BUILD SUCCEEDED** 验证（Xcode 26.6 · Swift 6.3.3 · arm64-apple-macos26.5）
- **C02 §2.3 anti-leak** = 6 个泄漏案例 + 4 段 STRICT RULES addendum
- **C02 §2.4 Dock 12 项** = 10 系统 + 1 分隔点 + 1 Y，固定顺序

## 增量

- 文件大小：19K → ~40K（+110%）
- 章节数：11 → 15（+4 章）
- 反模式：12 → 18（+6 条）
- 设计 token 引用：~5 个 prose hex → 117 个 machine-checkable tokens
- 检查点：0 → 30+ V1 issue 跟踪表
- 证据路径：~10 个 → 30+ 个（4 audit 全部 link）

## 不修改范围

- ❌ `design/design-tokens.json`（C12 已收口）
- ❌ 任何 `_exploration/` 下 audit / exploration 产出
- ❌ 任何 `code/` 下 SwiftUI / Extension 源码
- ❌ 任何 v3 product 图（5/5 张 PNG 保持现状，等 Figma 后期 batch 修）

## 下一轮

- v2.0 写完后立即进入 Figma 后期 batch 修（§12 清单）
- Round 4 shippable 包（C15-C22）按 §13 计划推进
- 任何 D2 token / D3 icon / D4 03 弃用等新决策必须立刻同步到本 v2.0
