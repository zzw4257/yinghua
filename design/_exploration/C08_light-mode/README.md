# C08 — 浅色 macOS 模式全套产品图

**日期**：2026-08-23
**阶段**：浅色模式探索 · 5 张产品图
**基础**：C06 v3 5 张深色版（结构 / 布局 / 内容 1:1，调色反转到 light mode）
**目标**：覆盖一半用浅色模式的 macOS 用户，与 C06 深色版形成完整配色对

---

## 5 张产品图清单

| # | 场景 | 文件 | 对应 C06 文件 | 状态 |
|---|------|------|---------------|------|
| 01 | meeting-in-progress | `01-meeting/product-meeting-in-progress-light__260823.jpg` | `C06/01-meeting-in-progress/product-meeting-in-progress-v3__260822.png` | ✅ |
| 02 | empty-state | `02-empty/product-empty-state-light__260823.jpg` | `C06/02-empty-state/product-empty-state-v3__260822.png` | ✅ |
| 03 | transcript-focus | `03-transcript/product-transcript-focus-light__260823.png` | `C06/03-transcript-focus/product-transcript-focus-v3__260822.png` | ✅ |
| 04 | review-mode | `04-review/product-review-mode-light__260823.jpg` | `C06/04-review-mode/product-review-mode-v3__260822.png` | ✅（1 次重试：首次上游限流，第二次成功）|
| 05 | onboarding | `05-onboarding/product-onboarding-light__260823.png` | `C06/05-onboarding/product-onboarding-v3__260822.png` | ✅ |

每张目录里同时保留了 `_prompt.txt`（浅色版 prompt），方便后续 Figma 终版复用 / 调优。

---

## 浅色色彩规则（与 C06 深色版对照）

| 元素 | C06 深色版 | C08 浅色版 |
|------|------------|------------|
| 桌面壁纸 | 深空 + 极光紫青（高饱和） | **暖白底 + 极淡极光**（米白 #F4F1EC，浅灰 #E8E6E1 渐变，pale purple top-left + pale teal bottom-right，~12% 饱和度，无星空无霓虹）|
| 菜单栏 | 黑色毛玻璃 | **白色毛玻璃**（半透白 + 1px 灰边 / `#1B1D22 @ 8%`）|
| 菜单栏文字 | 白色 | **石墨色** `#1B1D22` |
| Dock | 玻璃深 | **白玻璃**（半透白 + 1px `#1B1D22 @ 8%` hairline + 浅模糊）|
| Dock 系统图标 | 标准 macOS 11 图标 | **同 11 图标**（系统自带深浅适配）|
| 窗口背景 | 暗色玻璃 + 紫青 wash | **白色 / 极淡灰玻璃** + 10% 紫青 wash |
| 窗口文字主色 | `#F4F1EC` | **`#1B1D22`** |
| 窗口文字次色 | `#F4F1EC @ 80%` | **`#1B1D22 @ 65%`** |
| REC 红点 | `#FF3B30` | **`#FF3B30`**（不变 — 系统色浅深都保持）|
| Speaker avatar STYLE 1 | 紫/青/粉/暖白 | **同色**（avatar 自带深浅适配；暖白底在浅色背景下保持可读）|
| 紫青品牌色 | `#B57BFF → #2DD4BF` | **同色**（品牌色不变）|
| Primary 按钮 | 紫青渐变 | **同色**（不变）|
| Secondary 按钮 | 玻璃深 | **白玻璃 + 1px `#1B1D22 @ 8%` 边** |
| 卡片 / Section 边框 | 1px 8% 白 | **1px 8% 黑**（`#1B1D22 @ 8%` hairline）|
| Ghost link | `#F4F1EC @ 60%` | **`#1B1D22 @ 65%`** |

---

## 与 C06 v3 的连责检查表（9 项 × 5 张图）

| 检查项 | ref 来源 | 01 meeting | 02 empty | 03 transcript | 04 review | 05 onboarding |
|--------|----------|------------|----------|---------------|-----------|----------------|
| 浅色暖白壁纸 | ref-01 浅色版 | ✅ 暖白 + 极淡紫青 | ✅ 暖白 + 极淡紫青 | ✅ 暖白 + 极淡紫青 | ✅ 暖白 + 极淡紫青 | ✅ 暖白 + 极淡紫青 |
| 菜单栏文字 6 项（白毛玻璃 + 石墨字） | ref-01 浅色版 | ✅ Finder/File/Edit/View/Window/Help + 21:42 | ✅ 同 | ✅ 同 | ✅ Finder 22:14 | ✅ 09:42 |
| Dock 11 系统图标（白玻璃） | ref-02 浅色版 | ✅ 11 + Y | ✅ 11 + Y | ✅ 11 + Y | ✅ 11 + Y + Trash 副 | ✅ 11 + Y |
| Speaker 头像 STYLE 1 | ref-03 | ✅ 紫/青/粉，纯色圆 | n/a | ✅ 紫/青/粉 | ✅ 紫/青/粉 | n/a |
| 控制面板 4 段式无 waveform | ref-04 | ✅ REC/02:34 + 紫青 stop 环 | n/a | n/a | n/a | n/a |
| 按钮符合 ref-05 5 种规范 | ref-05 | ✅ Primary 紫青 stop | ✅ 4 圆形 nav + 2x2 tiles | n/a | ✅ Primary Share 紫青 + 3 Secondary 白玻璃 | ✅ Primary 紫青 + Ghost |
| 紫青品牌色保持 | ref-05 | ✅ stop 按钮 + Y icon | ✅ active mic nav | n/a（无 brand 元素）| ✅ Open pill + Share | ✅ Y squircle + CTA |
| 整体不 cyberpunk | — | ✅ 浅色系，无霓虹 | ✅ 浅色系 | ✅ 浅色系 | ✅ 浅色系 | ✅ 浅色系 |
| 整体不装饰（Apple 克制） | — | ✅ 干净 | ✅ 干净 | ✅ 干净 | ✅ 干净 | ✅ 极简 |

---

## V1 已知问题（Figma 后期修复清单）

> 与 C06 v3 V1 问题同型；这些是生图模型的固有偏差，不影响 light-mode 调性的方向性判断。

### 文字 / 规则泄漏（prompt rule leakage）

模型偶尔把 prompt 里的设计 token 文字直接渲染为可见文字。

| 图 | 位置 | 泄漏内容 | 修复方向 |
|----|------|----------|----------|
| 01 meeting | 控制面板 stop 按钮下方 | "PRIMARY" 标签 | Figma 终版删除 |
| 01 meeting | transcript 6 行的 timestamp 后 | "@ 65%" 反复出现 | Figma 终版删除（timestamp 只保留 "02:34:19"）|
| 01 meeting | transcript 6 行 avatar 上方 | "STYLE 1" 标签 | Figma 终版删除 |
| 02 empty | Recent 列 header 下方 | "14pt SF Pro Text 600" | Figma 终版删除（只保留 "Recent"）|
| 02 empty | 2x2 tile 下方 / Recent 每行 | "graphite @ 65%" 反复出现 | Figma 终版用真实 placeholder 文案替换 |

> 04 review 和 05 onboarding 没有出现 prompt 规则泄漏（在 prompt 末尾加了显式 "Do NOT print ... font names / sizes / opacity values" 起作用了）。

### Dock 日历图标

| 图 | 渲染 | 原因 |
|----|------|------|
| 01 meeting | "26" + "SUN" | 模型根据上下文自由发挥 day-name，V1 已知 |
| 02 empty | "26" + "MEN" | 同上 |
| 03 transcript | "26" + "HOR" | 同上 |
| 04 review | "26" + "DON" | 同上（更接近真实 "MON" / "TUE" 但仍错）|
| 05 onboarding | "26" + "MAAN" | 同上 |

> Figma 终版统一替换为标准 `26` + 当日 day name。

### 其他小问题

| 图 | 问题 | 说明 |
|----|------|------|
| 01 meeting | 控制面板"PRIMARY" 文字泄漏 | 跟 C06 v3 02 empty "STYLE 1" 文字泄漏同型 |
| 03 transcript | 第 7 行（Sam）部分被 stop 按钮挡住 | 模型在长列表最后一行位置把 stop 按钮覆盖了；Figma 终版调整 stop 按钮位置到内容区底部右侧、不挡最后一行 |
| 04 review | Dock 多出 1 个 Trash icon | 模型在 11 图标基础上额外加了 1 个；Figma 终版删 Trash，统一为 11 |
| 全部图 | Notes / Maps 等部分系统 icon 细节模糊 | 模型不能 100% 还原系统 icon 的细节；Figma 终版用真系统 icon 替换 |

### 继承自 C06 v3 的问题

中文乱码、日历 day name 错、prompt 规则泄漏 — 在 C08 浅色版里全部继承（V1 同一类模型偏差）。Round 3 推进时建议：

1. Figma 终版替换所有英文 placeholder 为真实中文（参考 D1 5.x 节的逐图对照表）
2. 统一替换 5 张图的所有 Dock 11 图标为真系统 icon
3. 删除 5 张图里所有 prompt 规则泄漏文字
4. 如果想做"完美版"，建议用 macOS 真实截图 + SwiftUI design templates（`https://developer.apple.com/design/resources/`）合成，而不是继续让生图模型做 UI 还原

---

## 出图记录

| 图 | 生成时间 | node_id | 是否重试 | 备注 |
|----|----------|---------|----------|------|
| 01 meeting | 00:51 | 433797805158473 | 1/1 首成功 | 浅色首张，prompt 模板确立 |
| 02 empty | 00:53 | 433798694105288 | 1/1 首成功 | "graphite @ 65%" 泄漏严重 |
| 03 transcript | 00:55 | 433796151984239 | 1/1 首成功 | 7 段说话人 + 紫青 stop 圆环 |
| 04 review | 00:57 | 433799913603212 | **2/2 第二次成功**（首次 upstream 限流，等 15s 重试）| "Yinghua" 标题、4 段 AI summary 折叠、Share 紫青 |
| 05 onboarding | 00:59 | 433799913603224 | 1/1 首成功 | 极简居中、Y squircle 紫青渐变、CTA 紫青 |

**策略**：
- 每张 1 提交 1 图，避免 batch 失败拖垮。
- 04 review 第一次撞上游限流，**严格按 error 提示保持 prompt 不变**，等 15s 重试 → 成功。
- 下载：统一用 `wget --timeout=120 --tries=2`（curl OSS URL 必超时）。

**生图后端**：`connector__matrix__generate_image`（model 不可选，2K / 16:9，~1-2 分钟/张）。

---

## 文件清单

```
C08_light-mode/
├── README.md                                     ← 本文件
├── 01-meeting/
│   ├── _prompt.txt
│   └── product-meeting-in-progress-light__260823.jpg
├── 02-empty/
│   ├── _prompt.txt
│   └── product-empty-state-light__260823.jpg
├── 03-transcript/
│   ├── _prompt.txt
│   └── product-transcript-focus-light__260823.png
├── 04-review/
│   ├── _prompt.txt
│   └── product-review-mode-light__260823.jpg
└── 05-onboarding/
    ├── _prompt.txt
    └── product-onboarding-light__260823.png
```

---

## Round 2 → Round 3 候选

| 方向 | 价值 |
|------|------|
| **Figma 终版替换** | 解决 V1 全部问题（中文、日历、prompt 泄漏、dock 图标细节）。Round 3 第一步。 |
| **Onboarding 3 屏流** | 当前只有第 1 屏；补"权限申请（麦克风/屏幕录制）"+ "BYOK API key" + "首次录制引导" |
| **设计 tokens JSON** | D1 文档 → JSON schema（颜色 / 字体 / 圆角 / 间距 / 阴影 / 动效），dev 可直接 import |
| **矢量 icon 多尺寸** | 把 C07 app icon + 系统 icon + 状态 icon 出成 .icns / .svg 多尺寸包 |
| **Twitter / X 3:1 banner** | 用 C06 + C08 共 10 张图裁切组合出 social header + profile pic |
| **Browser extension 入口** | "在 Zoom/Meet 页面右上角出现 Yinghua 小气泡"的 web 截图（第二大使用场景）|
| **真实 SwiftUI 实现** | 照 D1 §9 实现 notes，让设计师与 dev 同源 |
