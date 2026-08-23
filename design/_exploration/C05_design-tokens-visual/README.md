# 映话 Design Tokens — 视觉版（C05 参考图库）

> 这是 design tokens 的视觉化版本。每个参考图对应一个"约束规范"，后续所有产品图 prompt 都必须引用所有相关参考图，避免每张图"飘"。

---

## 套件结构

```
C05_design-tokens-visual/
├── README.md                                # 本文件
├── ref-01-macos-base/                        # 基础 macOS 桌面
│   └── macos-base-reference__260822.png
├── ref-02-dock-system/                       # ⭐ 真实 macOS Dock 11 个图标
│   └── ref-02-dock-system__260822.jpg
├── ref-03-speaker-avatars/                   # ⭐ Speaker 头像 4 种风格
│   └── ref-03-speaker-avatars__260822.jpg
├── ref-04-control-panel/                     # ⭐ 干净录音控制面板
│   └── ref-04-control-panel__260822.png
└── ref-05-button-system/                     # 待做：按钮设计 5 种规范
```

---

## 每个参考图怎么用

### ref-01 macos-base
- **作用**：锁菜单栏 + 壁纸 + Dock 位置
- **使用规范**：所有产品图必须用同一壁纸（深空 + 极光渐变），菜单栏结构（Apple+File/Edit/View/Window/Help+Control Center/Battery/Wi-Fi/Search/Time 21:42）
- **来源**：C04_polish/00-macos-base-reference（已复用）

### ref-02 dock-system ⭐ 新增
- **作用**：锁定 Dock 的 11 个真实 macOS 系统图标
- **图标顺序固定**：Finder / Safari / Mail / Messages / Notes / Calendar / Reminders / Maps / Music / System Settings / 分隔点 / Yinghua
- **为什么用真实图标**：用户反馈"之前看到 C03 02 那张 Dock 丰富更好"，所以不能只有 5 个图标
- **后续 prompt 必须包含**：
  ```
  "The Dock in the product image must be identical to ref-02-dock-system:
  glass material strip with exactly 11 icons in this order:
  Finder Safari Mail Messages Notes Calendar Reminders Maps Music System Settings | separator | Yinghua.
  No other icons allowed. Yinghua has magenta active dot."
  ```

### ref-03 speaker-avatars ⭐ 新增
- **作用**：锁 speaker 头像的 4 种风格选项
- **4 种风格**：
  - **STYLE 1**：紫色实色圆 + 白色首字母（推荐：最系统级）
  - **STYLE 2**：青→粉对角渐变圆（无字母，纯抽象）
  - **STYLE 3**：紫色 + 重叠圆几何图案
  - **STYLE 4**：暖白方块（squircle）+ 深色首字母
- **后续 prompt 必须包含**：
  ```
  "Speaker avatars must use STYLE X from ref-03-speaker-avatars:
  [describe the chosen style].
  All speaker avatars in the same image must use the same style.
  Avatar size: 32-48px diameter depending on context."
  ```

### ref-04 control-panel ⭐ 新增
- **作用**：锁录音控制面板的设计语言
- **核心规则**：
  - 4 段式横向布局（status / transport / secondary / close）
  - **无任何 waveform / sine wave / ekg / bar visualization**
  - 状态用红点 + REC + 时间码
  - 停止按钮是主操作（紫色光晕）
  - 玻璃材质 + 1px 描边
- **后续 prompt 必须包含**：
  ```
  "The audio control panel must be identical to ref-04-control-panel:
  glass card with 4 horizontal sections.
  NO waveform, NO sine wave, NO audio bar, NO ekg-style visualization.
  Status: red dot + REC label + monospace time counter.
  Transport: 3 circular buttons (pause, stop, play) with stop being primary.
  Secondary: settings + share icons.
  Close: X icon.
  Style: Apple HIG clean minimal restrained."
  ```

---

## C05 不出产品图（重要！）

**这次只做参考图库，不出任何产品图。** 等用户对参考图定调后，下一轮（C06）才用参考图做产品图。

原因：
- 之前每轮都"先出产品图给你看"，结果每张都飘
- 参考图不锁，产品图就永远会重新发明视觉
- 现在先把"约束"立住，下一轮做产品图时 prompt 引用所有参考图，调性就锁住

---

## 已知接受 / 待改进

- ref-02 dock-system 没有 magenta active dot（参考图展示完整 Dock 不需要 active 状态）— 后续产品图 prompt 单独强调
- ref-03 speaker-avatars "STYLE 1/2/3/4" 文字烧进图（作为参考图标签可接受）
- ref-04 control-panel "REC 02:34" 文字烧进图（作为参考图标签可接受）
- ref-05 button-system 还没做（留到 C06 一起做）

---

## 下一步（C06 规划）

1. **C06 用 4 张参考图重做 C03 的 5 张产品图**：
   - 01 empty-state
   - 02 meeting-in-progress
   - 03 transcript-focus
   - 04 review-mode
   - 05 onboarding
2. **C06 同时补 ref-05 button-system**（按钮设计 5 种规范）
3. **每次只出 1-2 张产品图**，让用户逐张检查，不再批量赶工

---

## 文件清单

```
C05_design-tokens-visual/
├── ref-01-macos-base/macos-base-reference__260822.png           (1.86 MB) ← 从 C04 复用
├── ref-02-dock-system/ref-02-dock-system__260822.jpg            (1.83 MB) ⭐
├── ref-03-speaker-avatars/ref-03-speaker-avatars__260822.jpg    (1.61 MB) ⭐
└── ref-04-control-panel/ref-04-control-panel__260822.png        (3.75 MB) ⭐
```
