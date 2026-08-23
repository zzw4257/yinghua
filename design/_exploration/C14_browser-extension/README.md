# C14 — Browser Extension 入口

**日期**：2026-08-23
**阶段**：Round 2 · 第二大使用场景
**基础**：C06 v3 meeting-in-progress + C07 02 GRADIENT（紫青 Y）+ design-doc §2.5 玻璃材质

---

## 背景

映话除了 macOS 桌面 app 形态外，还有一个 **browser extension** 入口。当用户已经在 Zoom / Google Meet 网页里开会时，extension 浮在页面右上角，提供"开始录制 / 录制中状态 / 跳转到桌面 app" 的轻量入口。

这是 C06 v3 主窗口之外的 **第二大使用场景**，补齐后映话才算覆盖"用户已经在浏览器里开会"这条最常见的现实路径。

---

## 文件清单

| 文件 | 场景 | 状态 |
|------|------|------|
| `browser-extension-zoom__260823.jpg` | Zoom meeting 页面 · 录制中 · hover 展开 | ✅ |
| `browser-extension-meet__260823.jpg` | Google Meet 页面 · 待启动 · hover 展开 | ✅ |

两图均为 16:9 · 2K 出图（实际 2752x1536 像素）。

---

## 设计理念

### 两种状态

| 状态 | 形态 | 何时显示 |
|------|------|----------|
| **Default** | 60x60 圆形小气泡（仅 Y icon + 状态点 + 单行 placeholder）| 用户没交互，extension 不抢戏 |
| **Hover / expanded** | 280x80 横向卡片（Y icon + 标题 + 时间码 / 副信息 + 1 个 CTA pill）| 鼠标 hover 或 extension 自动展开 |

两张出图都展示 **expanded 状态**（更信息密度、更能传达品牌），但底部都保留了 1 行 default 状态的占位（"Yinghua · 录制中" / 灰点 + placeholder line），帮助 Figma 同学看 default ↔ expanded 的视觉切换。

### 与 macOS 桌面 app 的视觉一致性

| 元素 | 桌面 app（C06 v3）| Browser extension（本图）|
|------|------------------|--------------------------|
| Y icon | 02 GRADIENT（紫青渐变 squircle）| 02 GRADIENT（完全相同的 Y 缩略图）|
| 品牌色 | 紫 `#B57BFF` → 青 `#2DD4BF` | 同上 |
| 玻璃材质 | `.regularMaterial` + 1px 8% 白边 | 同样的 frosted glass + 1px 白边 |
| 圆角 | 12-16px | 12px（保持系列一致）|
| 录制红点 | `#FF3B30` pulse | `#FF3B30`（不变）|

### 适用场景

- **用户已经在 Zoom / Meet 网页里开会** → extension 自动检测到 meeting room URL → 气泡自然浮在右上 → 用户点击或 hover → 开始录制
- **用户在桌面 app 内开会** → extension 不需要浮在浏览器（录制走 system audio capture，与 extension 无关）
- **用户没在开会** → extension 完全不显示（避免无效打扰）

> 这是一个 **不打扰、natural discovery** 的入口设计：默认态克制到几乎看不见，hover 态提供必要信息 + 1 个明确 CTA。

### STRICT RULES 遵守

| 规则 | 状态 |
|------|------|
| macOS Safari 风格 chrome（traffic lights + URL bar + 标签 + 收藏夹条） | ✅ |
| 视频 grid 是 4 人真实 grid（用 C06 silhouette 风格） | ✅ |
| 气泡 default 状态克制（小、淡、圆形）| ✅（展开卡片下方保留 default 占位）|
| 气泡 expanded 信息密度适中（icon + 状态 + 时间码 + 1 CTA）| ✅ |
| 紫青品牌色保持 | ✅（Open / Start pill 都是紫青渐变）|
| 文字用真实英文（"Recording"、"Click to start recording"）| ✅ |
| 中文 placeholder 真实渲染（"Yinghua · 录制中"）| ✅（Figma 后期替换）|
| 不出现 waveform / sparkles / 星空银河 / "AI" 字样 | ✅ |
| 不出现 emoji 代替 icon | ✅ |
| Aspect 16:9, 2K 出图 | ✅ |

---

## 与其他 C-series 的关系

| C-series | 关系 |
|----------|------|
| C06 v3 meeting-in-progress | 直接参考了 4 人 video grid 的剪影风格 |
| C07 02 GRADIENT | Y icon 直接复用 02 GRADIENT 缩略图 |
| design-doc §2.1 / §2.5 / §2.6 | 紫青色、玻璃材质、动效规范全部继承 |
| C08 / C09 / C10 / C11 | 不依赖，独立可单独用 |

---

## 出图记录

| 图 | 生成时间 | node_id | aspect | 备注 |
|----|----------|---------|--------|------|
| browser-extension-zoom | 01:33 | 433806385922271 | 16:9 · 2K | 一次成功 |
| browser-extension-meet | 01:34 | 433805981552952 | 16:9 · 2K | 一次成功 |

策略：两图都按"hover 展开状态"出图（信息密度更高、更能传达品牌），下方各留 default 状态的 placeholder（小红点 + 灰点各一），Figma 同学做 default ↔ expanded 的 220ms spring 切换动效。

下载：wget --timeout=120 --tries=2，两次都一次过，未触发 retry。

---

## 已知 V1 问题（Figma 修复清单）

| 位置 | 问题 | 修复 |
|------|------|------|
| Zoom 图的 "Yinghua · 录制中" | 模型把 placeholder 渲染成可读文字了（按 spec 应该是模糊 placeholder line）| Figma 把这一行替换为：小红点 + 真中文 "Yinghua · 录制中" + 真 JetBrains Mono 字号 12pt |
| Meet 图的 status row | 灰点已经对了，但下方的 placeholder line 太长（横跨整个卡片宽度）| Figma 缩短 placeholder line 到 80px 宽，左对齐 |
| 两图 browser chrome | 收藏夹条图标是 AI 随便生成的（Work / Favorites / 各种 social logo）| Figma 重做收藏夹条，用 5 个真实 favicon（Yinghua · Zoom · Meet · Notion · Calendar 之类）|
| Zoom 视频 tile names | 模型自动生成了 "Alex Chen / Jordan Park / Sam Rivera / Riley Wu" | Figma 替换为 4 个真实 placeholder 名字 + 1 行静音 / 摄像头图标 |
| Meet 视频 grid | 模糊程度略轻，silhouette 还能看清轮廓 | Figma 加 1 层更重的 vibrancy blur |
| 两图 traffic lights | 颜色是对的但大小略大 | Figma 缩到 macOS 真实 traffic light 尺寸（12x12px）|

---

## 候选 C15 方向（待用户选）

| 方向 | 描述 | 价值 |
|------|------|------|
| **a. Extension default 态** | 把两图的 default 态（小气泡）单独再出 2 张 | 完整 default ↔ expanded 两态 |
| **b. Extension 在其他网站** | Slack huddle / Teams web / Whereby | 覆盖更多使用场景 |
| **c. Extension 弹出 popover** | 点击 bubble 后的 popover（start / settings / recent）| 完整 extension 交互 |
| **d. Extension onboarding** | 装上 extension 后的欢迎页 | 新用户首触点 |
| **e. 回到桌面 app · 浅色模式** | C08 落地出图 | 覆盖一半 macOS 用户 |
| **f. 收口 → D2 design tokens.json** | Round 2 design tokens 工程化 | 准备进 dev 实施 |

---

## 文件结构

```
C14_browser-extension/
├── README.md  ← 本文件
├── browser-extension-zoom__260823.jpg
└── browser-extension-meet__260823.jpg
```
