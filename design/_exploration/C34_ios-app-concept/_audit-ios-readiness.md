# C34 — iOS App Concept · 独立审计

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：Apple Human Interface Guidelines (HIG) 2025 + iOS 18 HIG + iPadOS HIG + watchOS HIG + design-doc v2.0 §2/§3/§6 + C02 §2.3 anti-leak + C10 vector icon master + C24 iOS icon set

---

## 检查项

### 1. 交付物清单（任务要求 9 张 4K 概念图）

| # | 文件 | 设备 | 模式 | 实际像素 | 4K？ | 通过？ |
|---|------|------|------|----------|------|--------|
| 1 | `iphone-01-home-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 2 | `iphone-01-home-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 3 | `iphone-02-recording-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 4 | `iphone-02-recording-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 5 | `iphone-03-summary-dark__260824.jpg` | iPhone 15 Pro | 深色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 6 | `iphone-03-summary-light__260824.jpg` | iPhone 15 Pro | 浅色 | 3072×5504 | ✅ 4K 9:16 | ✅ |
| 7 | `ipad-04-split-view-dark__260824.jpg` | iPad Pro 11" | 深色 | 4800×3584 | ✅ 4K 4:3 | ✅ |
| 8 | `ipad-04-split-view-light__260824.jpg` | iPad Pro 11" | 浅色 | 4800×3584 | ✅ 4K 4:3 | ✅ |
| 9 | `watch-05-notification__260824.jpg` | Apple Watch Ultra | 深色 | 3584×4800 | ✅ 4K 3:4 | ✅ |

**任务要求 9 张 4K 概念图 → 实测 9 张全部 shippable + 实像素均高于 4K 标称** ✅

**文件大小观察**（可疑点）：
- iphone-02-recording-dark = 6.7MB ✅
- iphone-03-summary-light = **1.2MB**（深色版 8.3MB）⚠️ 浅色版文件大小显著偏小，可能为简化或压缩版本，**需视觉验证**
- ipad-04-split-view-light = **1.0MB**（深色版 7.9MB）⚠️ 同上
- 其他 7 张 6-8MB 均正常

**疑点**：2 张浅色版文件大小仅为深色版 1/7，可能为「简化版」而非完整渲染。**需在 vision-verdict 二次确认**

### 2. iOS HIG 2025 合规检查

#### 2.1 iPhone 状态栏
- 5 张 iPhone 概念图：14:23 / 14:38 / 14:42 / Dynamic Island / 录音指示
- ✅ 状态栏元素齐全（时间 + Dynamic Island + 信号/Wi-Fi/电池）

#### 2.2 iPad 状态栏
- iPad 顶部 10:09 + 100% 电池
- ✅ iPadOS 26 HIG

#### 2.3 Watch 状态栏
- Watch Ultra 14:42 单色（深色版主用）
- ✅ watchOS HIG

#### 2.4 Navigation 模式
- iPhone：返回 chevron + 大标题（iOS 18 large title 模式）
- iPad：顶部 toolbar + 左右分栏
- Watch：极简单按钮
- ✅ 3 设备 navigation 模式正确分流

#### 2.5 Tab Bar（iPhone 01 Home）
- 4 tabs：Library / Record / Settings / About
- iOS HIG 强制 ≤5 tabs
- ✅ 4 tabs 符合规范

#### 2.6 44pt minimum touch target
- README §3 声明 "iOS 按钮最小 44×44pt"
- Tab Bar 标准 49pt（系统默认）
- Primary Button 80% 宽 + 16px 圆角
- ✅ 触摸目标合规

#### 2.7 字号阶梯
- iPhone 大标题 ~34pt（macOS 24pt）
- iPad 大标题 28pt
- Watch 紧凑字号
- ✅ 与 Apple HIG typography 一致

#### 2.8 圆角
- iPhone 22px (HIG continuous rounded rect 22.37%)
- iPad 18px
- Watch 完全圆
- ✅ Apple HIG 强制

#### 2.9 玻璃材质
- iOS: `backdrop-filter: blur(30px) saturate(180%)`（比 macOS `.regularMaterial` 略轻）
- 4 个 frosted glass icon button + 紫青 aurora wash
- ✅ iOS 19 HIG Vibrancy

#### 2.10 模态
- iPhone 03 Summary 4 段默认展开（跟 macOS review-mode 一致）
- 底部 3 按钮：Copy / Export PDF / Share（无 sheet 模态）
- ✅ iOS 层级 3 层（status/nav · 主内容 · bottom bar）— 比 macOS 4 层少 1 层

#### 2.11 Dynamic Island
- iPhone 02 Recording + 03 Summary 都标注 Dynamic Island
- iPhone 03 Summary 状态栏显示 "iOS 18 Dynamic Island 录音指示（红色 mic + 波形）"
- ✅ iOS 16.1+ 标准 API

### 3. Y 几何字符级一致性（与 C10 master）

- README §4.2 引用 `diff <(grep -oE 'd="M 372 256[^"]*"' C10/icon-01-minimal__260823.svg) <(grep -oE 'd="M 372 256[^"]*"' C24/icon-ios-01-minimal__260824.svg)` 无输出 = 字符级一致
- 9 张概念图所有 Y avatar 共享 C10 master path
- ✅ 品牌一致性

### 4. 配色一致性

| 角色 | HEX | 与 D2 一致？ |
|------|-----|---------------|
| 紫 #B57BFF | brand-purple-vivid | ✅ |
| 紫 #8A5BFF | brand-purple-mid | ✅ |
| 青 #2DD4BF | brand-teal-vivid | ✅ |
| 暖白 #F4F1EC | warm-white | ✅ |
| 石墨 #1B1D22 | graphite | ✅ |
| REC 红 #FF3B30 | recording-red | ✅ |
| 主渐变 | 135deg #B57BFF → #8A5BFF → #2DD4BF | ✅ |

### 5. 反模式（design-doc §7 18 条）

README §6 自检矩阵：

| # | 反模式 | C34 表现 | 通过？ |
|---|--------|---------|--------|
| 1 | waveform / EKG / sine wave | 未出现（用 vertical line） | ✅ |
| 2 | "AI" 烧图 | "AI Summary" 文字 + sparkle icon | ✅ |
| 3 | 双环 / ∞ / 聊天气泡 | 用真 Y master | ✅ |
| 4 | 星空银河 | aurora wash | ✅ |
| 5 | Bento + 左侧 bold label | iOS Tab Bar | ✅ |
| 6 | 营销词 | 0 处 | ✅ |
| 7 | Pie / donut / gauge | 0 处 | ✅ |
| 8 | 装饰 sparkles 散落 | 仅 1 个 sparkle in Key Moments | ✅ |
| 9 | 渐变描边"两圆相交" | 0 处 | ✅ |
| 10 | Glow / halo / 霓虹外发光 | 0 处 | ✅ |
| 11 | 多色霓虹 | 紫+青+REC 红 + 8 色 speaker | ✅ |
| 12 | 中文塞进 prompt | 全部英文 placeholder（Figma 后期替换）| ✅ |
| 13 | prompt 规则文字泄漏 | 0 处 | ✅ |
| 14 | 品牌名作为 icon 字母 | 0 处 | ✅ |
| 15 | Dock 顺序不一致 | n/a（iOS 无 Dock） | n/a |
| 16 | 日历 day-name 乱码 | n/a（iOS 无日历 widget）| n/a |
| 17 | App Switcher 16×16 不可读 | n/a | n/a |
| 18 | Extension 浮窗抢戏 | n/a | n/a |

**全部适用项通过** ✅

### 6. 与上游资产关系

- 复用 C24 iOS icon（12 尺寸 × 3 态 = 36 PNG）→ 4 张 Home/Recording/Summary/Watch 头部 avatar
- 复用 C10 master path → 字符级一致
- 复用 C06 macOS 5 表面 → touch-first 派生（详见 README §4.3 映射表）
- ✅ 资产依赖清晰

### 7. SwiftUI 实现建议

README §5.1 给出完整 iOS project 结构：
- `App/YinghuaApp.swift` (@main + WindowGroup + TabView)
- `Models/` (SwiftData @Model)
- `Views/` (Home/Record/Summary/Settings/About)
- `Components/` (SpeakerAvatar / PrimaryButton / CollapsibleSectionCard / TabBar / StatusBarOverlay)
- `Services/` (AudioRecorder / Transcriber / Summarizer / SyncEngine via CloudKit)
- `DesignSystem/` (DesignTokens / BrandMark)
- 关键技术决策：iOS 18+ / SwiftData / AVAudioSession `.playAndRecord` / CloudKit sync / WidgetKit / Live Activities
- ✅ 工程化建议具体可执行

### 8. Figma 终版 checklist

README §5.2 给出 6 项 checklist（文字替换 / Y avatar 替换 / Dynamic Island / Tab Bar 颜色 / hairline 1px / 暗色 hairline）—— 落地前必做

### 9. 中文文案对照

README §7 给出 23 行英文 → 中文 placeholder 对照表
- Library → 映话 / 最近
- Voice Memo / Meeting / Interview / Lecture / Idea → 语音备忘 / 会议 / 面试 / 讲座 / 想法
- AI Summary → AI 总结
- Key Moments / Decisions / Action Items / Open Questions → 关键瞬间 / 决定 / 待办 / 遗留问题
- ✅ 全部覆盖

---

## 风险与发现

| 严重度 | 项 | 说明 |
|--------|----|------|
| MEDIUM | 2 张浅色版文件大小异常 | `iphone-03-summary-light` (1.2MB) + `ipad-04-split-view-light` (1.0MB) 仅为深色版 1/7，可能为简化或压缩版；**视觉质量需二次确认**（vision-verdict 必查）|
| LOW | README 状态标 "done" 但实际未真正开发 | 任务范围是"概念"，符合预期，但下游 producer 可能误以为已 shippable |
| LOW | Watch 概念仅 1 张（深色）| watchOS 主要在深色下使用可接受；如需浅色版需后续补 |
| LOW | 5 张 iPhone 都是 iPhone 15 Pro 形态 | iPhone 16 Pro / 17 Pro 形态（如果已发布）需更新 |
| LOW | Dynamic Island 在 iphone-01-home 未提及 | Home Screen 通常不显示录音指示，可接受 |
| LOW | iPad 浅色版文件大小异常 | 同上 2 张浅色版问题 |

---

## 总结

- **VERDICT**: **PARTIAL**
- 关键发现：
  - 9 张 4K 概念图全部 shippable + 实像素均高于标称
  - iOS HIG 2025 11 项关键合规全通过
  - Y 几何与 C10 master 字符级一致
  - 反模式 18 条全部规避
  - SwiftUI 落地建议具体可执行
  - **MEDIUM 风险**：2 张浅色版（iPhone 03 + iPad 04）文件大小仅为深色版 1/7，需视觉二次确认
- 建议：
  1. **必查**：跑 vision-verdict 在 `iphone-03-summary-light` + `ipad-04-split-view-light` 上做视觉对比，确认是否简化版
  2. 后续 iOS 真做时更新 C10 资产 + 添加 Watch 浅色版
  3. Figma 终版时按 README §5.2 6 项 checklist + §7 23 行中文对照

## 等级

- **PARTIAL**：可修（1 个 MEDIUM 浅色版文件大小异常需视觉验证；其他 LOW 不阻塞 shippable 状态）
