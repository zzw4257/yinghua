# 映话 Brand Assets C04 — Polish 套件（V2 修正）

> 这次只改 3 个点：去伪波形、锁 macOS 底层、转录内容更清晰。

---

## 解决的 C03 三大问题

| 用户反馈 | C03 的错 | C04 的修 |
|---|---|---|
| "左下角心电图样波形没必要" | 录音主控画了 audio waveform bar | **改用 REC + 时间码**，完全无波形 |
| "Dock 一会这样一会那样" | 每张图 Dock 自由发挥（5 / 13 / 4 个图标） | **做了一张 `macos-base-reference.png` 锁底层**，所有产品图共用 |
| "转录内容要清晰一点" | 转录行用横线 placeholder | **改用真版式**：speaker 圆点 + 名字 + 时间戳 + 对话文字 |
| "画风要再打磨" | 一些图偏艺术化 | 更系统级、更克制 |

---

## 套件结构

```
C04_polish/
├── README.md                                          # 本文件
├── 00-macos-base-reference/                            # ⭐ 锁底层
│   └── macos-base-reference__260822.png
├── 01-meeting-in-progress-v2/                          # ⭐ 去掉伪波形
│   └── product-meeting-in-progress-v2__260822.png
└── 02-transcript-focus-v2/                             # ⭐ 更清晰转录
    └── product-transcript-focus-v2__260822.png
```

---

## 1. macOS 基础参考图 ⭐（关键新文件）

**文件**：`00-macos-base-reference/macos-base-reference__260822.png`
**用途**：所有后续产品图的"底层锚"。每张产品图的 prompt 必须描述"identical to this base layer"。

**锁定的元素**：

| 元素 | 锁定规格 |
|---|---|
| 壁纸 | 深空 + 极光渐变（紫→青→粉，从右上衰减），可有轻星空 |
| 菜单栏（左半） | Apple logo + File / Edit / View / Window / Help |
| 菜单栏（右半） | Control Center / Battery / Wi-Fi / Search / Time 21:42 |
| Dock 位置 | 屏幕底部居中，玻璃材质 |
| **Dock 图标（严格 5 个）** | **Finder / Safari / Notes / Calendar / 映话**（顺序固定） |
| 映话 app icon | magenta active dot（活动应用） |

**禁止 Dock 出现**：Messages / Mail / Photos / Apple TV / Music / App Store / Settings / Launchpad / Trash / FaceTime / Reminders / Maps / Contacts / Pages / Numbers / Keynote — 全部不允许。

---

## 2. 录音主控重做（去伪波形）

**文件**：`01-meeting-in-progress-v2/product-meeting-in-progress-v2__260822.png`

**对比 C03**：

| 维度 | C03 | C04 V2 |
|---|---|---|
| 录音状态指示 | 红点 + 青色 audio waveform bar + stop 按钮 | **红点 + REC + 02:34 + 停止按钮**（无波形） |
| Dock | 13+ 图标（不固定） | 5 个图标（与 base reference 一致） |
| 视频方块人物 | 真实人脸虚化 | **抽象剪影**（silhouette） |
| 静音指示 | 右上角小徽章 | 右上角"Mute" 文字 + 麦克风图标 |
| 标题 | 无 | 顶部小字 "Yinghua"（后期可去） |
| 整体调性 | 偏艺术化 | 系统级、克制 |

**核心改进**：录音控件**真实化** — 真实 macOS 录音 UI 只有简洁的红点 + 时间码，不会有 audio waveform bar。

---

## 3. 转录浮层重做（更清晰）

**文件**：`02-transcript-focus-v2/product-transcript-focus-v2__260822.png`

**对比 C03**：

| 维度 | C03 | C04 V2 |
|---|---|---|
| 顶部 header | 红点 + 波形 + 实时波形 | **红点 + REC + 02:34 + 齿轮**（无波形） |
| 对话行版式 | speaker 圆点 + 名字 + 横线 placeholder | **speaker 圆点 + Speaker A [21:38] + Text placeholder 1. / 2.**（清晰版式） |
| 字号 | 中等 | **更大、清晰易读** |
| 行距 | 紧凑 | **宽松、breathable** |
| 整体可读性 | 中（要脑补） | **高（一目了然）** |

**核心改进**：转录屏要的是"reading view"，版式必须像 Notion / 微信消息那样清晰。

---

## 母模板更新（已写入 `_design-system-prompt.md`）

### 2.1 禁止装饰性视觉元素（新增）
- 心电图样 / audio waveform bar / 密集 sine wave — **禁止**
- 艺术化风格（cyberpunk / 抽象油画 / 散乱粒子）— **禁止**
- 星空 / 银河 / 行星 — **禁止（除非明显是桌面壁纸）**
- "AI" 字样烧进图 — **禁止**
- 对话框气泡互相交叉错位 — **禁止**
- "对话"作为"两个圆相交"图标 — **禁止**

### 2.2 macOS 底层严格锁定（新增）
所有产品图必须**完全一致**的菜单栏 / Dock / 壁纸，由 base reference 图锁定。任何偏离 = 废图。

---

## 下一轮可探索（C05+）

1. **重做 C03 的 01 / 04 / 05**（empty state / review mode / onboarding）— 让它们也用 base reference 底层
2. **C03 02 meeting in progress v1 归档**（已用 v2 替代）
3. **icon V3**（继续优化中央图形）
4. **Onboarding 3 屏流**（welcome → first recording → first summary）
5. **浅色 macOS 模式**

---

## 文件清单

```
C04_polish/
├── 00-macos-base-reference/macos-base-reference__260822.png                (1.86 MB) ⭐
├── 01-meeting-in-progress-v2/product-meeting-in-progress-v2__260822.png    (2.20 MB) ⭐
└── 02-transcript-focus-v2/product-transcript-focus-v2__260822.png          (5.52 MB) ⭐
```
