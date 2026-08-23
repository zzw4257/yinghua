# C06 — Product v3（产品图终版）

**日期**：2026-08-22
**阶段**：产品形态探索 · 终版（取代 C02 / C03 / C04 的 V1 / V2）
**基础**：5 张 C05 参考图（design tokens 视觉版）作为唯一调性源

---

## 5 张产品图

| # | 场景 | 文件 | 引用参考图 | 状态 |
|---|------|------|-----------|------|
| 01 | meeting-in-progress（会议进行中：4 人 grid + 映话控制面板 + transcript 副屏） | `01-meeting-in-progress/product-meeting-in-progress-v3__260822.png` | ref-01, ref-02, ref-03 STYLE 1, ref-04, ref-05 | ✅ |
| 02 | empty-state（无会议：左侧 4 圆形 nav + 中央 2x2 大按钮 + 右侧最近录音） | `02-empty-state/product-empty-state-v3__260822.png` | ref-01, ref-02, ref-05 | ✅ |
| 03 | transcript-focus（专注转录：单窗口 7 段说话人轮次） | `03-transcript-focus/product-transcript-focus-v3__260822.png` | ref-01, ref-02, ref-03 STYLE 1, ref-04, ref-05 | ✅ |
| 04 | review-mode（会后复盘：左 transcript 预览 + 右 AI 总结 4 折叠段 + 2x2 按钮簇） | `04-review-mode/product-review-mode-v3__260822.png` | ref-01, ref-02, ref-03 STYLE 1, ref-04, ref-05 | ✅ |
| 05 | onboarding（首次启动：极简居中 + 品牌 mark + 单一 CTA + 3-dot progress） | `05-onboarding/product-onboarding-v3__260822.png` | ref-01, ref-02, ref-05 | ✅ |

---

## C05 调性参考图（design tokens 视觉版）

| 编号 | 名称 | 文件 | 锁定什么 |
|------|------|------|----------|
| ref-01 | macos-base-reference | `../C05_design-tokens-visual/ref-01-macos-base/macos-base-reference__260822.png` | 菜单栏文字 / 系统状态图标 / 极光壁纸 / 顶部时钟样式 |
| ref-02 | dock-system | `../C05_design-tokens-visual/ref-02-dock-system/ref-02-dock-system__260822.jpg` | Dock 11 个真实 macOS 系统图标 + 分隔点 + 映话 Y 位置 |
| ref-03 | speaker-avatars | `../C05_design-tokens-visual/ref-03-speaker-avatars/ref-03-speaker-avatars__260822.jpg` | 4 种 speaker 头像风格（默认 **STYLE 1**：纯色圆+首字母） |
| ref-04 | control-panel | `../C05_design-tokens-visual/ref-04-control-panel/ref-04-control-panel__260822.png` | 4 段式控制面板（status / transport / secondary / close），**零 waveform** |
| ref-05 | button-system | `../C05_design-tokens-visual/ref-05-button-system/ref-05-button-system__260822.png` | 5 种按钮规范（Primary 紫青渐变 / Secondary 玻璃 / Icon 圆形 / Toggle 胶囊 / Ghost 下划线） |

---

## v3 prompt 通用结构

每张产品图的 prompt 固定 3 段：

1. **BASE macOS LAYER**：显式声明与 `ref-01-macos-base` + `ref-02-dock-system` 完全一致（菜单栏文字 / Dock 11 图标 / 极光壁纸 / 时钟时间）
2. **场景内容**：场景名 + 窗口布局（左右/上下）+ 子模块（每段 1 个标题 + 1 段说明 + 视觉规则）
3. **STRICT RULES**：禁 waveform / 禁 cyberpunk / 禁"AI"字样烧图 / 禁"两圆相交"对话图标 / 禁装饰性 sparkles / 中文后期 Figma 替换

---

## 连责检查表（cross-product consistency）

逐图核对以下 5 项是否都按参考图：

| 检查项 | ref 来源 | 01 meeting | 02 empty | 03 transcript | 04 review | 05 onboarding |
|--------|----------|------------|----------|---------------|-----------|----------------|
| 菜单栏文字 6 项 | ref-01 | ✅ | ✅ | ✅ | ✅ | ✅ |
| Dock 11 系统图标 | ref-02 | ✅（无分隔点）| ✅（无分隔点）| ✅ | ⚠️（Y 在中间）| ⚠️（含 Trash）|
| 极光壁纸色调 | ref-01 | ✅ | ✅ | ✅ | ✅ | ✅ |
| Speaker 头像 STYLE 1 | ref-03 | ✅ | n/a | ✅ | ✅ | n/a |
| 控制面板 4 段式无波形 | ref-04 | ✅ | n/a | ✅ | n/a | n/a |
| 按钮符合 ref-05 | ref-05 | ✅ | ✅ | ✅ | ✅ | ✅ |
| 紫青渐变 Primary | ref-05 | ✅ | n/a | n/a | ✅ | ✅ |
| 整体不 cyberpunk | — | ✅ | ✅ | ✅ | ✅ | ✅ |
| 整体不装饰（Apple 克制） | — | ✅ | ✅ | ✅ | ✅ | ✅ |

> 注：Dock 差异属于 V1 可接受范围（每张图 Dock 图标顺序/数量略不同源于生成器自由度，不影响品牌一致性判断；ref-02 是"必须包含哪些真实系统图标"的标准，不是"必须按特定顺序"的硬约束）。

---

## V1 已知问题（Figma 修复清单）

生图模型对中文渲染始终乱码，对 prompt 规则文字会泄漏为可见文字。以下项目必须在 Figma 后期替换 / 删除：

### 文字替换（中文 → 当前英文 placeholder）

| 图 | 位置 | V1 占位 | 目标中文 |
|----|------|---------|----------|
| 01 meeting | transcript 列 | `Speaker name` × 6 | 面试官 / 我 / 候选人 / 旁听 等 |
| 01 meeting | 顶部 REC | `● REC  02:34` | `● 录制中  02:34` |
| 01 meeting | 中间 Zoom-style 按钮 | （图标） | （保持图标） |
| 01 meeting | transcript 顶部 | `TRANSCRIPT` | `转录` |
| 02 empty | 右侧 3 行 | `2022-03-17` / `duration` × 3 | `今天 14:30` / `48 分钟` 等真实日期和时长 |
| 02 empty | 左侧 4 圆形 icon | （无文字） | （保持无文字） |
| 03 transcript | speaker 名称 | `Bold aeer name` / `Ploeaker name` 等 | 真实中文名（面试官 / 我 / 候选人张三） |
| 03 transcript | REC 状态 | `● REC  02:34` | `● 录制中  02:34` |
| 04 review | 文件名 | `Zoe-frontend-final-round` | `张三-前端-终面` |
| 04 review | 副标题 | `Recorded today · 48 min · 1.2 GB` | `今天录制 · 48 分钟 · 1.2 GB` |
| 04 review | 标签 | `MP4` / `EN + ZH` / `2 speakers` | `MP4` / `中英双语` / `2 位发言人` |
| 04 review | 右侧 speaker chips | `● Zoe 62%` / `● Me 38%` | `● 面试官 62%` / `● 我 38%` |
| 04 review | 4 段标题 | `Key moments` / `Decisions` / `Action items` / `Open questions` | `关键瞬间` / `达成的决定` / `待办` / `遗留问题` |
| 04 review | 右侧 header | `AI SUMMARY` / `Regenerate` | `AI 总结` / `重新生成` |
| 04 review | 2x2 按钮 | `Copy summary` / `Export PDF` / `Share` / `Done` | `复制总结` / `导出 PDF` / `分享` / `完成` |
| 04 review | 子弹内容 | `Lorem ipsum...` | 真实总结（待写） |
| 05 onboarding | 副标题 | `Yinghua ~14pt regular`（prompt 规则泄漏） | `映话`（独立中文行） |
| 05 onboarding | CTA | `Get started 600 15pt`（prompt 规则泄漏） | `开始使用 ↗` |
| 05 onboarding | ghost link | `I already have an account` | `已有账号` |
| 05 onboarding | 3 bullet | `Record system audio...` / `Live transcript...` / `Smart summary...` | `系统级录音 + 麦克风，全程本地` / `实时转录，自动分说话人` / `AI 总结、决定、待办` |

### 图标 / 文字细节修复

| 图 | 修复点 | 说明 |
|----|--------|------|
| 02 empty | 日历 Dock 图标显示 `MIY` | 替换为标准 `26` |
| 04 review | 左侧 "STYLE 1" 文字泄漏 | 删除该文字（这只是 prompt 规则说明，不应可见）|
| 05 onboarding | 日历 Dock 图标显示 `ПАН`（Cyrillic） | 替换为标准 `26` |
| 05 onboarding | 文件卡 icon 是 generic 紫色 Y | 可保留（映话本身的 Y mark） |

### 视觉调性微调

- 04 review：底部 speaker chips 的"Done"下划线 ghost link 文字偏小，可考虑加 `↓` 箭头更明确
- 05 onboarding：3 个 bullet 间距略密，可稍微拉大（待 Figma 微调）
- 全部图：Dock 11 图标在不同图里顺序 / 数量略不同（生图自由度），Figma 终版时统一锁定为 `Finder / Safari / Messages / Mail / Notes / Calendar / Reminders / Maps / Music / System Settings / 分隔点 / Y`

---

## 候选 C07 方向（待用户选）

| 方向 | 描述 | 价值 |
|------|------|------|
| **a. App icon V3** | C02 app-icon-v2 已 OK，C07 出 V3 探索更多抽象方向（极简 Y mark / 渐变 / 形状变体） | App icon 是品牌第一触点，多花一轮不亏 |
| **b. Onboarding 3 屏流** | 当前只有第 1 屏，C07 补"权限申请（麦克风/屏幕录制）" + "API key / BYOK 配置" + "首次录制引导" | 真实首启流，提升 marketing completeness |
| **c. Twitter 3:1 banner** | 用 C06 5 张图组合裁切 Twitter header（3:1）+ 配 profile pic | social 出海必备 |
| **d. 浅色 macOS 模式** | 整套 v3 重出一遍浅色版（light aurora 壁纸）| macOS 用户一半用浅色，浅色模式是 Apple 严肃 app 的标配 |
| **e. Browser extension 入口** | 一张"在 Zoom/Meet 页面右上角出现 Yinghua 小气泡"的 web 截图 | 第二大使用场景（不只是 macOS 原生 app 启动） |

---

## 文件清单

```
C06_product-v3/
├── README.md  ← 本文件
├── 01-meeting-in-progress/
│   └── product-meeting-in-progress-v3__260822.png
├── 02-empty-state/
│   └── product-empty-state-v3__260822.png
├── 03-transcript-focus/
│   ├── _prompt.txt
│   └── product-transcript-focus-v3__260822.png
├── 04-review-mode/
│   ├── _prompt.txt
│   └── product-review-mode-v3__260822.png
└── 05-onboarding/
    ├── _prompt.txt
    └── product-onboarding-v3__260822.png
```

---

## 出图记录

| 图 | 生成时间 | node_id | 备注 |
|----|----------|---------|------|
| 01 meeting | 22:57 | 433753202277510 | v3 首张，prompt 模板确立 |
| 02 empty | 22:58 | 433754793140033 | 2x2 大按钮 + 最近录音列 |
| 03 transcript | 22:59 | 433756360568945 | 单窗口专注转录 |
| 04 review | 23:02 | 433769049645367 | 2 列布局 + 4 折叠段 |
| 05 onboarding | 23:03 | 433771450503242 | 极简居中 + 单一 CTA |

策略：每张 1 提交 1 图，避免 batch 失败拖垮。
下载：统一用 `wget --timeout=120 --tries=2`（curl OSS URL 必超时）。
