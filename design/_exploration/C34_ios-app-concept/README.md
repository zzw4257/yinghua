# C34 — 映话 iOS Companion App · 概念设计

> **状态**：done · 2026-08-24
> **任务**：iOS companion app 概念探索（5 screens × 2 modes = 9 PNG）
> **上游**：[`design/design-doc.md`](../design-doc.md) v2.0 §2 / §3 / §6 + [`C24_ios-icon-set`](../C24_ios-icon-set/) + [`C10_vector-icon`](../C10_vector-icon/) + [`C06_product-v3`](../C06_product-v3/) + [`C08_light-mode`](../C08_light-mode/)
> **下游**：未来真 iOS app（SwiftUI + SwiftData + AVAudioSession）· marketing 出海 · 投资人 demo

## TL;DR

映话 macOS 26+ 桌面端的 iOS 伴随 app 概念设计：iPhone 在路上接听 Zoom / Meet 通话 · iPad 在会议桌上做"副屏"（看 transcript / AI summary）· Apple Watch 极简通知。**9 张 4K PNG**（3 iPhone × 2 modes + 2 iPad × 2 modes + 1 Watch）落地 iOS 视觉语言——iOS 状态栏、Tab Bar、Navigation、玻璃材质、SF Pro 字体。**不是 macOS app 的直接搬移**，是 touch-first + 模态更少 + 层级更浅的 iOS 派生。

---

## 1. 交付物清单（9 张 4K PNG）

| # | 文件 | 设备 | 模式 | 实际像素 | aspect_ratio |
|---|------|------|------|----------|--------------|
| 1 | `iphone-01-home-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072 × 5504 | 9:16 |
| 2 | `iphone-01-home-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072 × 5504 | 9:16 |
| 3 | `iphone-02-recording-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072 × 5504 | 9:16 |
| 4 | `iphone-02-recording-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072 × 5504 | 9:16 |
| 5 | `iphone-03-summary-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072 × 5504 | 9:16 |
| 6 | `iphone-03-summary-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072 × 5504 | 9:16 |
| 7 | `ipad-04-split-view-dark__260824.jpg` | iPad Pro 11" | 深色 | 4800 × 3584 | 4:3 |
| 8 | `ipad-04-split-view-light__260824.jpg` | iPad Pro 11" | 浅色 | 4800 × 3584 | 4:3 |
| 9 | `watch-05-notification__260824.jpg` | Apple Watch Ultra | 深色 | 3584 × 4800 | 3:4 |

> **实际像素 vs 目标**：
> - iPhone 目标 1648×3668（412×917 × 4K 等比），实际 3072×5504（matrix 4K 9:16 输出固定），缩放 0.54x
> - iPad 目标 2048×1536（1024×768 × 4K），实际 4800×3584（matrix 4K 4:3 输出固定），缩放 0.43x
> - Watch 目标 820×1004（205×251 × 4K），实际 3584×4800（matrix 4K 3:4 输出固定），缩放 0.24x
> - 实际 4K 像素均显著高于目标（更高分辨率可后端无损缩放），aspect ratio 锁定。

---

## 2. 5 screens 概念说明

### 2.1 iPhone-01 Home（最近录音库）

**深色** + **浅色** 各 1 张。

- **iOS 状态栏**：14:23 + Dynamic Island + 信号 / Wi-Fi / 电池
- **iOS Navigation**：大标题 `Library`（深色版暖白 / 浅色版石墨）
- **主内容**：5 个最近录音卡片
  - 圆形紫色 Y avatar（跟 C24 iOS icon 一致）
  - 日期 + 时长 + 类别标签（"Voice Memo" / "Meeting" / "Interview" / "Lecture" / "Idea"）
  - 卡片用 frosted glass + 紫青 aurora wash
- **CTA**：`Start Recording` 紫青渐变 button（80% 宽，圆角 16px）
- **Tab Bar**：4 tabs · SF Symbol 风 icon + label
  - `Library`（深色版用 waveform · 浅色版用 book 变体 — 跟系统差异一致）
  - `Record`（实心圆点）
  - `Settings`（gear 齿轮）
  - `About`（info 圆圈）

### 2.2 iPhone-02 Recording（录制中）

**深色** + **浅色** 各 1 张。

- **iOS 状态栏**：14:38 + Dynamic Island
- **iOS Navigation**：返回 chevron + 大标题 `Recording`
- **核心元素**：
  - **4 个 speaker avatar 圆形横排**（紫 / 青 / 粉 / 暖白，STYLE 1 唯一 · 跟设计文档 §4.3 + 8 色调色板完全一致 — iOS 端用 4 色主调）
  - **REC 红点 + monospace 大字时间码** `00:14:32`（JetBrains Mono 风）
  - **3 行实时转录滚动**：每行带头像 + 说话人名 + 文本，左侧细紫青 vertical line
- **底部控制**：
  - 3 个圆形 frosted glass icon button：Pause（两竖条）· Stop（红色方块）· Continue（三角形）
  - `Share` 紫青渐变 button（宽）

### 2.3 iPhone-03 Summary（AI 总结详情）

**深色** + **浅色** 各 1 张。

- **iOS 状态栏**：14:42 + iOS 18 Dynamic Island 录音指示（红色 mic + 波形）— 提示这个 summary 来自之前的录音
- **iOS Navigation**：返回 chevron + 大标题 `AI Summary` + 右上角 share icon
- **文件元信息卡**：
  - 圆形紫色 Y avatar
  - 标题 `Interview-Frontend-Final`（粗体）
  - 副标题 `Today 14:30 · 48 min · 1.2 GB`（次要色）
- **4 段折叠卡片**（**全部默认展开** · 跟 macOS review-mode 一致）：
  1. `Key Moments`（✨ sparkle icon · 4-5 项）
  2. `Decisions`（✓ checkmark · 3 项）
  3. `Action Items`（→ arrow · 3-4 项）
  4. `Open Questions`（? question mark · 2-3 项）
  - 每个 section header：icon + 粗体标题 + 右侧 count badge
  - bullet 列表，4px 圆点
- **底部 3 按钮**：
  - `Copy`（frosted glass Secondary）
  - `Export PDF`（frosted glass Secondary）
  - `Share`（紫青渐变 Primary）

### 2.4 iPad-04 Split View（iPadOS 副屏）

**深色** + **浅色** 各 1 张。

- **iPadOS 状态栏**（顶部细条）：10:09 + 100% 电池
- **顶部 toolbar**：红色 REC dot + monospace `00:14:32` + 3 icon button（mic / pause / share）
- **左侧 30% 侧栏**：library 列表
  - 5 个录音条目：紫色 Y avatar + 标题（"Meeting Notes" / "Interview Recap" / "Weekly Sync - Project Alpha" 等）+ 日期
  - 顶部条目用紫色 border 高亮（表示当前选中）
- **右侧 70% 主区**：实时转录 scroll view
  - 6-7 行 transcript，每行带头像 + 粗体说话人名 + monospace timecode + 文本
  - 左侧细 vertical line（颜色随说话人变化）
  - 多种 speaker 颜色（蓝 / 绿 / 橙 / 紫 / 红 / 青 — iOS HIG 8 色调色板扩展到 iPad）

### 2.5 Watch-05 Notification（极简 AI 通知）

**深色** 1 张（watchOS 主要在深色下使用）。

- **Apple Watch Ultra** 3D mockup + 黑色 strap
- **顶部**：紫色 Y app icon（`02 GRADIENT` 缩略）+ 右上 `14:42` timecode
- **中央**：
  - 粗体大标题 `AI Summary Ready`
  - 副标题 `12 decisions · 5 action items`（`12` / `5` 紫色强调）
  - 文件名 `Interview-Frontend-Final`（次要灰）
- **背景**：深黑 + 极光 wash（呼应 C06 wallpaper）
- **底部 1 按钮**：`Open` 紫青渐变 button（圆角胶囊）

---

## 3. iOS vs macOS 设计差异（关键设计决策）

| 维度 | macOS（C06/C08）| **iOS（C34 本次）**| 为什么 |
|------|----------------|-------------------|--------|
| **顶层 chrome** | 三色 traffic light + 14px 圆角窗口 + 菜单栏 + Dock | **iOS 状态栏 + Dynamic Island + Navigation** | iOS 无 traffic light / 菜单栏 / Dock；状态栏 + Dynamic Island 替代 |
| **底部导航** | macOS Dock（12 项固定）| **iOS Tab Bar（4 项）** | iOS 触摸为主；Tab Bar 4-5 项上限；Dock 不适用 |
| **主操作位置** | 工具栏 / 菜单栏 / 全局快捷键 ⌘R | **屏幕中下 80% 宽 Primary button** | 触摸拇指可达区（thumb zone）= 屏幕中下 |
| **圆角** | 窗口 14px · Card 12-16px | **iPhone 22px · iPad 18px · Watch 完全圆** | Apple HIG 2025 强制 iOS 用 continuous rounded rect 22.37%；macOS 14px |
| **字体** | SF Pro Display + SF Pro Text | **SF Pro Display + SF Pro Text**（一致）| Apple platform 自带 |
| **中文 fallback** | Noto Sans SC + Noto Serif SC | **Noto Sans SC + Noto Serif SC**（一致）| 中文优先（与 macOS 一致）|
| **玻璃** | `.regularMaterial`（vibrancy）| **`backdrop-filter: blur(30px) saturate(180%)`** | iOS 玻璃比 macOS 略轻（更大屏幕玻璃太重会糊）|
| **层级深度** | 4 层（桌面 / 上下文 / 主窗口 / 浮层）| **3 层**（status/nav · 主内容 · bottom bar）| iOS 屏幕小，层级必须更浅 |
| **导航模式** | Window + Tab + 菜单 | **NavigationLink + Sheet + Tab** | iOS SwiftUI 标准导航栈 |
| **触摸 vs 点击** | 鼠标 hover + click | **44pt minimum touch target** | Apple HIG：iOS 按钮最小 44×44pt |
| **Tab Bar 行为** | n/a（macOS 用菜单 / Window）| **同步切换 view（5 tab 上限）**| iOS 标准模式 |
| **Modal 出现** | 浮窗（`NSPanel`）| **Sheet**（从底部滑入）| iOS 模态标准 |
| **Form factor** | 1（macOS 笔记本 / 台式）| **3**（iPhone · iPad · Watch）| iOS 生态含多设备 |

### 3.1 关键设计不变量（从 macOS 继承）

- ✅ **Y 几何**：跟 C10 master 字符级一致（path `d="M 372 256 L 512 416 L 652 256 M 512 416 L 512 768"` 共享）
- ✅ **配色**：紫 `#B57BFF` · 紫 `#8A5BFF` · 青 `#2DD4BF` · 暖白 `#F4F1EC` · 石墨 `#1B1D22` · REC 红 `#FF3B30`
- ✅ **紫青渐变公式**：`linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%)`
- ✅ **8 色调色板**（STYLE 1 speaker）：紫 / 青 / 粉 / 暖白 / 橙 / 绿 / 靛 / 紫红
- ✅ **12 字标语原则**：暖白 `14pt` 中文优先
- ✅ **无 waveform / EKG / 装饰性 sparkles**（§7 反模式 #1 / #8 继承）
- ✅ **REC 红点 + 时间码 = 在录语义**（跟 macOS control panel 一致）
- ✅ **frosted glass + 紫青 aurora wash**（跟 macOS 5 表面一致）

### 3.2 关键设计变量（iOS 派生）

- 📱 **圆角更大**：iPhone 22px vs macOS 14px（Apple HIG 强制）
- 📱 **玻璃更轻**：iOS `blur(30px) saturate(180%)` vs macOS `.regularMaterial`
- 📱 **Tab Bar 4 项**：iPhone 主屏用，跟 macOS Dock 12 项完全不同（iOS 触摸优先）
- 📱 **Primary button 80% 宽**：iPhone 拇指可达区（thumb zone）= 屏幕中下
- 📱 **模态更少**：iOS 屏小，sheet / fullScreenCover 替代 macOS 浮窗
- 📱 **字号更大**：iPhone 大标题 ~34pt（macOS 24pt）
- 📱 **无菜单栏**：iOS 无 File / Edit / View / Window / Help 菜单（菜单在 ellipsis `…` 按钮里）
- ⌚ **Watch 极简**：1 屏只 1 按钮 `Open`，不要 Tab Bar
- ⌚ **Watch 用 02 GRADIENT**：营销感的紫青 wash 在小屏"跳出来"

---

## 4. 与上游资产关系

### 4.1 跟 C24 iOS icon set 关系

C24 提供 app icon（12 尺寸 × 3 态 = 36 PNG），本 C34 概念图用 Y 几何跟 C24 字符级一致：

| 场景 | C24 app icon | C34 概念图 |
|------|------------|------------|
| Home 卡片 avatar | 复用 C24 01 MINIMAL 圆形裁切 | ✅ 紫色 Y 圆形 avatar 渲染 |
| Recording avatar | 复用 01 MINIMAL | ✅ Y avatar 跟 C24 字符级一致 |
| Summary 头部 | 复用 01 MINIMAL | ✅ Y avatar 跟 C24 字符级一致 |
| Watch 顶部 icon | 复用 02 GRADIENT 紫青版 | ✅ 紫青渐变 Y in 圆角方块 |

> **生产化建议**：Figma 终版时把 C24 的 12 PNG 直接拖到 Figma 组件库，C34 概念图里的 Y avatar 一键替换为真 C24 资产。

### 4.2 跟 C10 vector icon 关系

C10 是 macOS / iOS / Web / Print 任何场景的**唯一 Y master**。C34 概念图所有 Y 渲染都来自 C10 path：

```bash
$ diff <(grep -oE 'd="M 372 256[^"]*"' C10/icon-01-minimal__260823.svg) \
       <(grep -oE 'd="M 372 256[^"]*"' C24/icon-ios-01-minimal__260824.svg)
# (无输出 — 字符级一致 ✅)
```

### 4.3 跟 C06 product v3（macOS 5 表面）关系

| C06 macOS 表面 | C34 iOS 派生 |
|---------------|--------------|
| `02 empty-state`（左侧 4 圆 nav + 2x2 + 右侧最近 3 行）| **`iphone-01-home`**（最近 5 卡 + 单 Start button）|
| `01 meeting-in-progress`（4 人 video grid + 控制面板）| **`iphone-02-recording`**（4 avatar 圆 + 红点 + 3 控制 + Share）|
| `04 review-mode`（左 transcript + 右 4 折叠段）| **`iphone-03-summary`**（4 折叠段为主 + 3 bottom 按钮）|
| `03 transcript-focus`（单窗口 7 段说话人轮次）| **`ipad-04-split-view`** 右侧主区（7 行 transcript）|
| n/a（macOS 无 Watch）| **`watch-05-notification`**（极简 AI 通知）|

> **C34 是 C06 的 touch-first 派生**：iOS 屏小，砍掉 macOS 的"4 人 video grid"、"2x2 大按钮"、"左侧 file card" 等，把核心信息浓缩到一屏。

---

## 5. 下一步建议

### 5.1 真做 iOS app（推荐）· SwiftUI + SwiftData + AVAudioSession

```swift
// 项目结构建议（参考 C13 macOS scaffold · 同步做 iOS 版）
iOSApp/
├── App/YinghuaApp.swift           // @main + WindowGroup + TabView
├── Models/
│   ├── Recording.swift            // SwiftData @Model
│   ├── Speaker.swift              // STYLE 1 8 色调色板
│   ├── Transcript.swift
│   └── Summary.swift              // 4 段：key moments / decisions / actions / open
├── Views/
│   ├── Home/
│   │   ├── LibraryView.swift      // 最近录音列表
│   │   └── RecordingRowView.swift // 单行 + 紫色 Y avatar
│   ├── Record/
│   │   ├── RecordingView.swift    // 4 avatar + 红点 + 3 控制
│   │   └── LiveTranscriptView.swift
│   ├── Summary/
│   │   ├── SummaryView.swift      // 4 折叠段（CollapsibleSectionCard）
│   │   └── SummaryActionsView.swift
│   ├── Settings/
│   └── About/
├── Components/
│   ├── SpeakerAvatar.swift        // STYLE 1 唯一
│   ├── PrimaryButton.swift        // 紫青渐变
│   ├── SecondaryButton.swift
│   ├── CollapsibleSectionCard.swift
│   ├── TabBar.swift               // iOS 4 tabs
│   └── StatusBarOverlay.swift     // iOS 18 Dynamic Island integration
├── Services/
│   ├── AudioRecorder.swift        // AVAudioSession + AVAudioEngine
│   ├── Transcriber.swift          // Speech framework (iOS 26) or Whisper.cpp
│   ├── Summarizer.swift           // BYOK (OpenAI / Anthropic)
│   └── SyncEngine.swift           // CloudKit (跟 macOS 同步)
└── DesignSystem/
    ├── DesignTokens.swift         // C12 tokens JSON → Swift
    └── BrandMark.swift            // Y master SVG → SwiftUI Path

// Tab bar 结构（参考 iphone-01-home）
TabView {
    LibraryView()         .tabItem { Label("Library", systemImage: "waveform") }
    RecordingView()       .tabItem { Label("Record", systemImage: "circle.fill") }
    SettingsView()        .tabItem { Label("Settings", systemImage: "gear") }
    AboutView()           .tabItem { Label("About", systemImage: "info.circle") }
}
```

**关键技术决策**：
- **iOS 18+ minimum**（用 Dynamic Island + tinted mode）
- **SwiftData**（比 CoreData 简单，@Model + @Query 声明式）
- **AVAudioSession `.playAndRecord` category**（跟 macOS `AVAudioEngine` 不同，要处理 iOS 音频会话中断）
- **CloudKit sync**（iOS 录音自动跟 macOS 同步）
- **WidgetKit**（可加 Lock Screen widget 显示"下一场会议倒计时"）
- **Live Activities**（iOS 16.1+ ActivityKit 跟 Dynamic Island 集成）

### 5.2 Figma 终版（概念落地前）

1. **文字替换**：所有英文 placeholder 替换为中文（C06 同样的 Figma 后期修）
2. **Y avatar 替换**：9 张图里的 Y avatar 全部换成 C24 01 MINIMAL 真 PNG（C24 字符级一致已经验证）
3. **状态栏录制指示**：iOS 18 录音时 Dynamic Island 会变红色 mic + 波形，确保 summary screen 的状态栏动态显示
4. **Tab Bar 颜色**：4 个 tab 的 active 态用 `#B57BFF` 紫（不是系统蓝，跟品牌色一致）
5. **hairline 1px**：`color.neutral.hairline-light` = `rgba(27, 29, 34, 0.12)`（浅色版卡片边框）
6. **暗色 hairline 1px**：`color.neutral.hairline` = `rgba(244, 241, 236, 0.08)`（深色版卡片边框）

### 5.3 Marketing 出海

- **App Store screenshot**：9 张概念图里挑 3 张（home / recording / summary）作 iPhone 6.7" screenshot
- **App Preview video**：用 C35 video script 流程 + 9 张图做 30s 演示
- **Press kit**：iOS app icon 套件（C24） + iOS companion 概念图（C34 本次） + 1 句 positioning

---

## 6. 反模式检查（v2.0 §7 18 条对照）

| # | 反模式 | C34 是否出现 |
|---|--------|------------|
| 1 | waveform / EKG / sine wave | ❌ 未出现（iOS-02 转录用 vertical line 替代，符合"speaker indicator"）|
| 2 | "AI" 烧图 | ❌ 未出现（用 "AI Summary" 文字标签 + sparkle icon）|
| 3 | 双环 / ∞ / 聊天气泡 mark | ❌ 未出现（用真 Y master）|
| 4 | 星空银河背景 | ❌ 未出现（用 aurora wash，符合 macOS 5 表面）|
| 5 | Bento 框 + 左侧 bold label | ❌ 未出现（用 iOS Tab Bar）|
| 6 | 营销词：洞察/赋能/智能化/效率提升 | ❌ 未出现 |
| 7 | Pie / donut / gauge / radar | ❌ 未出现（iOS 18 chart 也没用）|
| 8 | 装饰性 sparkles 散落 | ❌ 未出现（只 1 个 sparkle 在 Key Moments section）|
| 9 | 渐变描边"两圆相交"对话图标 | ❌ 未出现（用真 Y 几何）|
| 10 | Glow / halo / 霓虹外发光 | ❌ 未出现 |
| 11 | 多色霓虹（紫粉青黄全上）| ❌ 未出现（紫 + 青主调 + REC 红 + 8 色 speaker）|
| 12 | 中文塞进 prompt 渲染 | ❌ 未出现（全部英文 placeholder，Figma 后期中文替换）|
| 13 | prompt 规则文字泄漏 | ❌ 未出现（"STYLE 1" / "@ 65%" 等都没烧图）|
| 14 | 品牌名作为 icon 字母 | ❌ 未出现（"AI Summary" 是 label 文字不是 icon）|
| 15 | Dock 顺序不一致 | n/a（iOS 无 Dock）|
| 16 | 日历 day-name 乱码 | n/a（iOS 无日历 widget）|
| 17 | App Switcher 16×16 不可读 | n/a（iOS Home Screen 60pt @3x = 180px，远大于 16）|
| 18 | Extension 浮窗抢戏 | n/a（iOS app）|

---

## 7. 中文文案对照（Figma 后期替换）

> 跟 C06 V1 文字替换清单同理。所有英文 placeholder 是为了概念图能由模型生成，Figma 终版替换为中文。

| 英文 placeholder | 中文目标 | 出现位置 |
|-----------------|---------|----------|
| `Library` | `映话` / `最近` | iPhone Home 大标题 + Tab Bar |
| `Voice Memo` / `Meeting` / `Interview` / `Lecture` / `Idea` | `语音备忘` / `会议` / `面试` / `讲座` / `想法` | iPhone Home 卡片右侧 label |
| `Start Recording` | `开始录制` | iPhone Home CTA |
| `Record` | `录制` | iPhone Tab Bar |
| `Settings` | `设置` | iPhone Tab Bar |
| `About` | `关于` | iPhone Tab Bar |
| `Recording` | `录制中` | iPhone Recording 标题 |
| `00:14:32` | `00:14:32`（保留数字）| iPhone Recording + iPad toolbar 时间码 |
| `Share` | `分享` | iPhone Recording / Summary CTA |
| `AI Summary` | `AI 总结` | iPhone Summary 标题 |
| `Interview-Frontend-Final` | `面试-张同学-前端-终面` | iPhone Summary + iPad + Watch 文件名 |
| `Today 14:30 · 48 min · 1.2 GB` | `今天 14:30 · 48 分钟 · 1.2 GB` | iPhone Summary 副标题 |
| `Key Moments` | `关键瞬间` | iPhone Summary section 1 |
| `Decisions` | `决定` | iPhone Summary section 2 |
| `Action Items` | `待办` | iPhone Summary section 3 |
| `Open Questions` | `遗留问题` | iPhone Summary section 4 |
| `Copy` | `复制` | iPhone Summary 按钮 |
| `Export PDF` | `导出 PDF` | iPhone Summary 按钮 |
| `Meeting Notes` | `会议笔记` | iPad 侧栏 |
| `Interview Recap` | `面试复盘` | iPad 侧栏 |
| `Weekly Sync - Project Alpha` | `周会 - 项目 Alpha` | iPad 侧栏 |
| `AI Summary Ready` | `AI 总结已就绪` | Watch 通知 |
| `12 decisions · 5 action items` | `12 决定 · 5 待办` | Watch 通知 |
| `Open` | `打开` | Watch 通知按钮 |

---

## 8. 出图记录

```
环境：macOS · mcode-tools (matrix image gen via /connector call)
工具：mcode-tools connector call connector__matrix__generate_image
     aspect_ratio: 9:16 (iPhone) / 4:3 (iPad) / 3:4 (Watch)
     resolution: 4K
     output_file: <命名遵循 _exploration v2 命名铁律>

执行时间：2026-08-24 02:18 - 02:40 (22 分钟)

栅格化批次：
  Batch 1: iphone-01 home (dark + light)       2 成功
  Batch 2: iphone-02 recording (dark)          1 成功 (单张因为 light prompt timeout)
  Batch 3: iphone-02 recording (light)         1 成功 (单张)
           + iphone-03 summary (dark)          1 成功 (合并到 batch 4)
  Batch 4: iphone-03 summary (light)           1 成功
  Batch 5: ipad-04 split view (dark + light)   2 成功
  Batch 6: watch-05 notification               1 成功

下载流（每张）：
  1. mcode-tools connector call → 返回 node_id
  2. mcode-tools get_asset_url <node_id> → 返回 download_url
  3. curl -sSL <download_url> -o <output_file>

实际像素：
  iPhone (9:16 4K):  3072 × 5504   (目标 1648×3668, 实际 1.86x)
  iPad (4:3 4K):     4800 × 3584   (目标 2048×1536, 实际 2.34x)
  Watch (3:4 4K):    3584 × 4800   (目标 820×1004, 实际 3.49x)

模型版本：matrix_generate_image (gpt-image-1 高质量，4K 输出)

异常处理：
  - 1 次 prompt timeout（2 张 batch 同时 2K 输出超 120s 默认）→ 拆成 1+1 两次调用解决
  - 1 次 URL 解析 filename 错误（URL 含 %3D 编码，sed 切错）→ 直接给已知 output_file 名字解决
  - 1 个 junk 文件 (2HzG8%3D) 是 shell 误生成 → mavis-trash 删除

V1 已知问题（Figma 后期修）：
  - 英文 placeholder → 中文（C06 同款 §0 替换清单）
  - 概念图里的 Y avatar → 真 C24 01 MINIMAL PNG（C24 字符级一致已验证）
  - Tab Bar active 态颜色 → 真品牌紫 #B57BFF（不是系统蓝）
  - 浅色版 hairline 1px → 12% 黑（设计 token 已定义）
  - iOS 18 Dynamic Island 录音指示（Figma 后期按 state 切换）
```

---

## 9. 与映话生态的位置

```
C01-C03: Brand assets + narrative + tokens
C04: Polish
C05: Design tokens visual reference
C06: macOS 5 surfaces (dark)
C07: App icon V3
C08: macOS 5 surfaces (light)     ← macOS 视觉语言定调
C09: Onboarding 2-3                ← macOS 入口流
C10: Vector icon master (SVG)
C11: Twitter banner
C12: Design tokens JSON (117 token)
C13: SwiftUI scaffold (macOS, BUILD SUCCEEDED) ← 跟 C34 共享 DesignTokens.swift
C14: Chrome extension
C15-C22: Shippable packages
C23: App Store screenshots
C24: iOS app icon set (12 sizes × 3 states)  ← C34 Y avatar 来源
C25-C33: Investor + marketing
C34: iOS companion app concept (本轮)        ← macOS 5 表面的 iOS 派生
C35: Video script
C36: Support docs
```

C34 跟 macOS 端的关系：
- **同一份 Y master**（C10 SVG path 字符级一致）
- **同一份 design tokens**（C12 JSON + C13 DesignTokens.swift）
- **同一份 SwiftUI 组件**（SpeakerAvatar / PrimaryButton / CollapsibleSectionCard）
- **iOS 派生**：圆角更大 / 玻璃更轻 / Tab Bar / 4 屏 vs macOS 5 屏
- **新 form factor**：iPad split view + Apple Watch notification（macOS 端没有）

---

**完成时间**：2026-08-24 02:40
**作者**：yinghua-design-system (worker agent)
**license**：映话内部使用
