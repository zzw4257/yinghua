# 映话 Design System — AI 生图共用 Prompt 宪法

> 这份文档是后续所有生图 prompt 的"母模板"。每个具体场景的 prompt 都基于这份母模板填场景变量，禁止偏离。

---

## 1. 品牌锁定（任何场景下都不许偏离）

### 1.0 层次结构（重要！C03 新增）

**产品套件强制要求 4 层视觉层次**（从远到近）：

| 层 | 内容 | 处理方式 |
|---|---|---|
| L1 最远 | macOS 桌面 / 壁纸 | 极光渐变（同 marketing hero） |
| L2 远 | 上下文 UI（会议视频方块 / 浏览器窗口 / Notion / PDF） | **虚化 + 降低饱和度**，只露形态不露细节 |
| L3 中 | 映话产品主窗口 | **清晰 + 玻璃 + 居中** |
| L4 近 | 转录屏浮层 / 提示气泡 / 行动项弹窗 | **半透明 + 高斯模糊背景 + 1px stroke** |

**核心原则**：
- ❌ 绝不在一个窗口里塞 5 个组件（违反"眼睛专注一个任务"）
- ✅ 主窗口只做一件事（录音 / 转录 / 总结 / 知识库 各自独立）
- ✅ 浮层是有理由才出现（如转录屏盖在会议视频上方，因为用户需要边开会边看）
- ✅ 上下文元素（视频方块 / 浏览器 / 文件）放 L2 虚化，不要清晰
- ✅ 旁边有"标志性"的小元素：Finder 文件夹、桌面小文件、菜单栏图标，让画面有"真实在 macOS 工作"的感觉

### 1.1 色彩

| 角色 | 名称 | HEX | 用法 |
|---|---|---|---|
| **主品牌色** | Aurora Purple | `#7B3FE4` | 大面积强调、按钮、链接、图表 |
| 副品牌色 | Cyan Glow | `#2EE6E0` | 录音/实时状态、数据流光 |
| 副品牌色 | Magenta Spark | `#E63FB8` | 重要提示、关键词高亮、状态点 |
| 中性浅 | 暖白 | `#F4F1EC` | 主文字、玻璃面反光 |
| 中性深 | Graphite | `#1B1D22` | 背景、卡片底、文字 |
| 中性深+ | 深空 | `#0B0C10` | 最深底色、阴影 |

**主渐变公式**：`linear-gradient(135deg, #7B3FE4 0%, #2EE6E0 60%, #E63FB8 100%)`
**玻璃面反光**：`rgba(244, 241, 236, 0.12)` overlay on `#1B1D22` base

### 1.2 字体

| 场景 | 字体 |
|---|---|
| 营销主标 | Newsreader Display Bold（英文） / Noto Serif SC Bold（中文） |
| 营销副标 | Inter Display Medium |
| UI 中文 | PingFang SC / 苹方 |
| UI 英文 | SF Pro Display / SF Pro Text |
| 数据/时间 | JetBrains Mono Medium |
| 字幕/转录 | SF Mono Regular |

### 1.3 形状语言

- **圆角**：12-16px（卡片），24px（大容器），999px（圆形头像/状态点）
- **描边**：1px stroke `rgba(255,255,255,0.08)` 模拟 macOS 玻璃分割线
- **阴影**：双层阴影 — 紧贴 4px `rgba(0,0,0,0.3)` + 长投影 24px `rgba(0,0,0,0.5)`
- **玻璃**：`backdrop-filter: blur(40px) saturate(180%)` 风格，NSVisualEffectView 材质感

### 1.4 视角与光源

- **营销图**：正面 0°，光源来自右上 45°，aurora 渐变光从右上往左下衰减
- **产品图**：22° 透视（伪 3D），桌面 50° 透视倾斜
- **图标**：完全正面 0°，无透视
- **景深**：营销图浅景深（左前景锐利，右后景虚化），产品图全锐利

---

## 2. 严禁（Prompt 反制条款）

每张图的 prompt 末尾必须包含以下一段（中英双语都加）：

```
STRICT RULES:
- NO text rendering at all in the image. All text will be added later in design software.
  (图像中不渲染任何文字。所有文字后期叠加。)
- NO brand names from competitors: do NOT show Fathom, Final Round, Raycast, DockDoor, Otter, Fireflies, Zoom, Teams, Meet.
  (不出现任何竞品品牌名。)
- All visible UI labels in the rendered scene (if any) must be in Simplified Chinese, using real word combinations — NEVER random characters or fragments.
  (画面中任何可见 UI 标签必须是简体中文，真实词组，禁止字符碎片。)
- DO NOT include any recognizable person, real face, or stock-photo style.
  (不出现真实人物面孔、stock photo 风格。)
- DO NOT render logos of Tencent Meeting, Lark, Feishu, DingTalk, Zoom, Microsoft Teams, Google Meet. Use a generic abstract meeting icon instead (two overlapping circles).
  (不出腾讯会议/飞书/钉钉/Zoom/Teams/Meet 的真实 logo，用通用抽象双圆图标。)
- macOS elements: traffic light buttons (red/yellow/green) must be in correct order top-left, menu bar with Apple logo and File/Edit/View/Window/Help.
  (macOS 元素：三色按钮位置正确，菜单栏 Apple logo + File/Edit/View/Window/Help。)
```

### 2.1 禁止装饰性视觉元素（C04 新增，用户反馈）

**绝对禁止**（这些是"看起来很酷但实际不存在"的生图模型幻觉）：

| 元素 | 禁止原因 |
|---|---|
| **心电图样 / audio waveform bar / 密集 sine wave** | 真实 macOS 录音控件没有这种东西。状态用"红点 + 简短标签"即可 |
| **艺术化风格**（cyberpunk / 抽象油画 / 散乱粒子） | 我们要 Apple keynote 克制感，不要 AI 艺术化 |
| **星空 / 银河 / 行星** | 与 brand system 的"深空 + 极光"冲突（除非明显是桌面壁纸） |
| **"AI"字样烧进图** | 后期 Figma 替换，用图形而非文字 |
| **对话框气泡互相交叉错位** | 看起来像涂鸦 |
| **"对话"作为"两个圆相交"图标** | 之前的 prompt 反制失败，必须明确禁止 |

**正确做法**：
- 录音状态：红点 + "REC" 简短标签 + 时间码
- 转录波形（如果必须）：**用极简的水平线 + 微弱起伏**，不要密集 bar
- AI 标识：用抽象几何图形，不用文字

### 2.2 macOS 底层严格锁定（C04 新增，参考图 `macos-base-reference.png`）

**所有产品图必须共用同一套 macOS 基础设置**（菜单栏 + Dock + 壁纸），由参考图 `01-macos-base-reference__260822.png` 锁定：

| 元素 | 锁定规格 |
|---|---|
| **壁纸** | 深空 + 极光渐变（紫→青→粉，从右上衰减）。**有星空元素可以接受**（macOS 真实壁纸也有），但要轻 |
| **菜单栏（左半）** | Apple logo + File / Edit / View / Window / Help（5 个固定菜单项） |
| **菜单栏（右半）** | 固定图标顺序：Control Center / Battery / Wi-Fi / Search / Time（21:42） |
| **菜单栏（背景）** | 半透明深色 backdrop blur |
| **Dock 位置** | 屏幕底部居中，玻璃材质 |
| **Dock 图标（严格 5 个）** | Finder / Safari / Notes / Calendar / 映话（顺序固定） |
| **Dock 样式** | 圆角矩形（~70px 高），5 个图标等距分布，映话在最后 |
| **Dock 映话 icon 状态** | 必有 magenta 活动小点（活动应用） |

**禁止 Dock 出现其他图标**（Messages / Mail / Photos / Apple TV / Music / App Store / System Settings / Launchpad / Trash / FaceTime / Reminders / Maps / Contacts / Pages / Numbers / Keynote / iMovie / GarageBand — 全部不允许）。

**prompt 模板必须包含**：
```
"Identical macOS base layer as reference image 01-macos-base-reference: 
menu bar (Apple logo, File Edit View Window Help, Control Center, Battery, Wi-Fi, Search, Time 21:42),
Dock with exactly 5 icons in this exact order: Finder, Safari, Notes, Calendar, Yinghua (with magenta active dot), 
deep space aurora wallpaper (purple to cyan to magenta gradient from top-right)."
```

---

## 3. 场景模板（用于填具体图）

### 3.1 营销图模板（marketing-*）

```
[场景]：a hero image for marketing material of a macOS-native AI interview/meeting assistant called "映话 / Yìnghuà"
[载体]：16:9 (2880×1620) for landing page hero / Product Hunt cover / blog header
[构图]：foreground = a translucent glass card cluster showing 5 product features; background = deep space gradient with aurora glow from top-right
[主标占位]：(画布中央偏左，巨大字号，留 50% 空间给后期文字叠加)
[副标占位]：(主标下方，留 30% 空间)
```

### 3.2 产品真实界面模板（product-*）

```
[场景]：a real macOS desktop with the 映话 app window open, captured at 22° perspective
[载体]：16:9 (2880×1620) for App Store screenshots, documentation, in-app onboarding
[构图]：桌面 wallpaper 是 aurora 渐变；映话窗口在中央，浮在 Dock 上方；菜单栏完整可见（右上角时间、Wi-Fi、电池）；Dock 在底部（包含 映话、Finder、Safari、Notes 4-5 个图标）
[窗口内容]：(具体场景：录音中 / 总结完成 / 知识库 / AI 建议)
```

### 3.3 品牌资产模板（brand-*）

```
[场景]：the 映话 app icon, square 1:1, displayed in three contexts (1024×1024 standalone / inside macOS Dock with active glow / inside Launchpad grid)
[载体]：1024×1024 / 1440×900 (with dock context)
[构图]：icon 主体是极光紫渐变 + 抽象"对话波形"图形（无任何文字）；右下小角展示在 macOS Dock 中的状态（带 active dot）
```

---

## 4. 命名规范

```
<category>-<usage>-<variation>__<date>.<ext>

示例：
- marketing-landing-hero__260822.jpg
- marketing-social-twitter-banner__260822.jpg
- product-recording-active__260822.jpg
- product-summary-complete__260822.jpg
- brand-app-icon-1024__260822.jpg
- brand-app-icon-in-dock__260822.jpg
```

**禁词**：v1, v2, v3, test, draft, experiment, hero1, hero2, ...

---

## 5. 验证清单（每张图生成后必须对照）

- [ ] 16:9 或 1:1 比例正确
- [ ] 主品牌色 #7B3FE4 至少出现 1 次显著位置
- [ ] 玻璃质感正确（半透明 + 高斯模糊反光）
- [ ] 圆角符合 12-16px 规范
- [ ] 没有任何外部品牌名 / 真实人物面孔
- [ ] macOS 元素（如果出现）位置正确
- [ ] 中文（如果出现）必须是真实词组，不是字符碎片
- [ ] 整体光照方向一致（右上 → 左下）

### 2.3 禁止 prompt 规则文字泄漏为可见 UI（C07/C06 audit 新增，2026-08-23）

**这是生图模型最顽固的失败模式** —— 模型把 prompt 里的字号 / 样式标签 / 抽象概念**当 UI label 渲染**。C06/C07 audit 发现的 6 个实例：

| 泄漏内容 | 出现位置 | 严重度 |
|----------|----------|--------|
| `STYLE 1` 文字作为 avatar 区段标题 | C06 04 review transcript 列上方 | HIGH |
| `Yinghua ~14pt regular`（字号定义）| C06 05 onboarding 副标题 | HIGH |
| `Get started 600 15pt ↗`（按钮字号定义）| C06 05 onboarding CTA | HIGH |
| `AI` 字母作为 Anthropic provider card icon | C09 03 byok | medium |
| `node` 文字作为 Custom provider card icon | C09 03 byok | low |
| 日历 Dock 文字 `MIY` / `NEN` / `MEN` / `ПАН`（应渲染 `26`）| C06 02/03/04 + C09 02/03 | low |

**每张 prompt 末尾 STRICT RULES 必须追加**：

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

### 2.4 Dock 规格更新（C07 audit 新增，2026-08-23）

**老 §2.2 写的 "5 个图标" 是 C02 早期版本的简化版**，C05 design tokens visual 阶段（ref-02-dock-system）已扩展为 11 个真实 macOS 系统图标 + 分隔点 + 映话 Y。**所有新 prompt 必须按 C05 ref-02 锁定**：

```
Dock with EXACTLY these 12 elements in this exact order (must match
ref-02-dock-system): Finder, Safari, Messages, Mail, Notes, Calendar
(showing "26" in red), Reminders, Maps, Music, System Settings, a
small separator dot, then the Yinghua app icon (purple aurora Y on
dark glass, with a small magenta active dot below indicating the app
is running).
```

**禁止**：
- 任意位置插入 Address Book / Photos / FaceTime / Pages / Numbers / Keynote / Trash 等不在列表里的图标
- Y 不在分隔点之后的位置
- 任意 2 张图之间 Dock 顺序不一致（Figma 后期统一 1 套 master dock）
