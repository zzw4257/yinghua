# 映话 Brand Assets V1 — 完整设计资产套件

> 这一组是 V1 定调资产。5 张图覆盖营销主图 / 社交分享 / 产品真实界面 / 应用图标。所有图共享同一套 Design System（见 `_design-system-prompt.md`）。

---

## 套件结构

```
C02_brand-assets/
├── _design-system-prompt.md          # 共用 prompt 母模板（颜色/字体/玻璃/视角/反制条款）
├── README.md                          # 本文件
├── 01-marketing/                      # 营销套件
│   ├── marketing-landing-hero__260822.jpg           # 16:9，落地页主视觉 / 博客头图
│   ├── marketing-social-producthunt-card__260822.jpg  # 1:1，社交分享 / Product Hunt
│   └── marketing-social-producthunt-card-DEPRECATED__260822.jpg  # ⚠️ v1 偏了（带星空），弃用
├── 02-product/                        # 产品真实界面套件
│   ├── product-recording-active__260822.jpg        # 16:9，录音中
│   └── product-summary-complete__260822.jpg        # 16:9，会后总结
└── 03-brand/                          # 品牌资产套件
    └── brand-app-icon-showcase__260822.jpg         # 16:9，App icon 主标 + 三尺寸 Dock 展示
```

---

## 每张图的使用规范

### 1. `marketing-landing-hero__260822.jpg`
- **用途**：官网落地页主 hero / 博客头图 / 演讲封面
- **尺寸**：2752 × 1536（2K），可裁切至 16:9 任意尺寸
- **后期叠加**：标题"映话"放左半边中央、副标下方、CTA 按钮
- **禁忌**：不要再做"自由职业 + AI" 风格的占位图
- **状态**：✅ 终版，**唯一一处主营销图**

### 2. `marketing-social-producthunt-card__260822.jpg`
- **用途**：Product Hunt / 微博 / X (Twitter) 头图 / 微信分享卡
- **尺寸**：2048 × 2048（1:1 方形）
- **后期叠加**：app 名称 + tagline 放左半边（深空区）
- **禁忌**：不要裁掉右下两个玻璃卡片，那是核心视觉
- **状态**：✅ 终版（v2，已弃 v1）
- **⚠️ 弃用**：`marketing-social-producthunt-card-DEPRECATED__260822.jpg`（v1 多了星空银河元素，与主图调性不一致，留作对照）

### 3. `product-recording-active__260822.jpg`
- **用途**：App Store 截图、官网"看看它怎么工作"段、文档插图、Onboarding 演示
- **尺寸**：2752 × 1536（2K）
- **后期叠加**：左侧人物标签 / 中间转录文字 / 右侧问映话输入框文字
- **注意**：生图中的中文是模型幻觉（"面响官" 等错别字），**必须用 Figma 替换为正确中文**——`面试官`、`实时转录`、`问映话`
- **状态**：✅ 终版，调性锁定

### 4. `product-summary-complete__260822.jpg`
- **用途**：App Store 截图第二张、官网"会后自动整理"段、博客"为什么本地优先"插图
- **尺寸**：2752 × 1536（2K）
- **后期叠加**：会议标题、3 个 speaker 名字、4 行 AI 总结 bullet、3 个 action item checkbox
- **注意**：与 product-recording-active 共享同一壁纸 + 同一 Dock，是连贯的产品叙事
- **状态**：✅ 终版

### 5. `brand-app-icon-showcase__260822.jpg`
- **用途**：App Store 商店图标（需裁切 1024×1024 主图）、官网品牌页、媒体 kit
- **尺寸**：2752 × 1536（2K）
- **后期叠加**：可裁切中央 1024×1024 作为 app icon
- **设计基线**：squircle 22% 圆角 / 紫青对角渐变 / 抽象"对话波形"图形 / 无文字
- **状态**：✅ V1 基线，下一轮可优化"对话波形"图形（让两半更对称 / 更有故事感）

---

## 调性锁定（Design Tokens）

所有图共享的视觉规范，已写入 `_design-system-prompt.md`：

| 类别 | 锁定值 |
|---|---|
| 主品牌色 | `#7B3FE4` Aurora Purple |
| 副品牌色 | `#2EE6E0` Cyan Glow + `#E63FB8` Magenta Spark |
| 中性 | `#F4F1EC` 暖白 / `#1B1D22` Graphite / `#0B0C10` 深空 |
| 渐变 | `linear-gradient(135deg, #7B3FE4 0%, #2EE6E0 60%, #E63FB8 100%)` |
| 圆角 | 12-16px（卡片）/ 22%（squircle icon） |
| 玻璃 | `backdrop-filter: blur(40px) saturate(180%)` 风格 |
| 描边 | `1px stroke rgba(255,255,255,0.08)` |
| 视角 | 营销 0° / 产品 22° / Icon 0° |
| 光源 | 右上 45°，aurora 渐变光从右上往左下衰减 |

---

## 调性自检（5 张图放一起看）

✅ 一致：
- 同一深空底色
- 同一极光渐变（紫→青→粉，从右上衰减）
- 同一玻璃质感（16px 圆角 + 1px 描边 + 高斯模糊反光）
- 同一色板（绝无其他色相出现）
- 同一光源方向

✅ 互不重复：
- marketing 套件：纯视觉、零 UI
- product 套件：真实 macOS 应用（菜单栏/三色按钮/Dock 全齐）
- brand 套件：icon 设计语言

---

## 已知问题（V1 接受，V2 修复）

1. **生图模型对中文渲染始终乱码**（产品图中"面响官""实时表幕屈"等错别字）— 必须用 Figma 后期替换为正确中文（参见 `_design-system-prompt.md` 第 2 节反制条款已写明，这是已知硬伤）
2. **App icon 中央"对话波形"图形**偏弱（两个 speech bubble 略散乱）— V2 可优化为更对称的"映"字形抽象
3. **Twitter 3:1 banner 缺失**（生图后端不支持 3:1 比例，2 次重试都失败）— 暂用 social card 1:1 替代，或后续用 Figma 裁切 landing hero 制作

---

## 下一轮可探索方向

1. **App icon V2**：让"对话波形"更精致（对称 / 加层次 / 试不同抽象路径：对话流、声音的"映"、镜像）
2. **Twitter banner**：用 Figma 裁切 landing hero + 加文字，绕开生图不支持 3:1 的限制
3. **App 内 Onboarding 三屏**：欢迎 / 第一次录音 / 第一次看总结（需要重做产品套件以连贯）
4. **深色 vs 浅色模式**：现在全是深色底，可探索浅色 macOS 模式下的视觉
5. **Icon 系统**：导出 app icon 在 macOS Finder / Launchpad / Mail / Spotlight 多种上下文展示
