# C08 浅色模式 5 张图 — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：`design/design-doc.md` §1-8（D1 master） + `C06_product-v3/_audit-verdict.md`（深色版基线） + `C05_design-tokens-visual/` ref-01/ref-02/ref-04
**审计对象**：`C08_light-mode/01-meeting` / `02-empty` / `03-transcript` / `04-review` / `05-onboarding` 5 张浅色产品图

---

## 0. 摘要（TL;DR）

- **整体调性**：5/5 张图确实在浅色 macOS 调性上对齐了 D1 §2.1 浅色规则（暖白 + 极淡紫青 + 白玻璃 + 石墨字），与 C06 v3 深色版形成完整配色对。
- **C06 V1 痛点修复**：05 onboarding 三大 prompt 规则泄漏（Yinghua 副标题 / "Get started 600 15pt" / 02 GRADIENT Y mark）在 C08 浅色版中**全部修复**；03 transcript 顶部 "STYLE 1" 标签也**修复**。这比 C06 v3 进步显著。
- **新痛点**：01 meeting 仍然是 prompt 规则泄漏最严重的 1 张（"STYLE 1" ×6 + "@ 65%" ×6 + "PRIMARY" ×1 = 13 处泄漏）；02 empty 也有 7 处泄漏（"14pt SF Pro Text 600" + "graphite @ 65%" ×6）。
- **结构性差异**：5 张图菜单栏（5/5 都有 "Finder"）已统一（**比 C06 v3 进步**）；但 Dock 顺序和日历 day-name 仍不一致。
- **VERDICT**：**PARTIAL**。不进 PASS 因为 2 张图（01/02）有严重 prompt 规则泄漏；不进 FAIL 因为剩余 3 张图（03/04/05）调性干净、结构对齐、无重大违反。

---

## 1. 10 项 × 5 张图 检查表

| # | 检查项 | D1 规则 | 01 meeting | 02 empty | 03 transcript | 04 review | 05 onboarding |
|---|--------|---------|------------|----------|---------------|-----------|----------------|
| 1 | 浅色暖白壁纸（cream + 极淡紫青）| §2.1 浅色规则 | **PASS** — 暖白 #F4F1EC + 左上极淡紫 + 右下极淡青 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 |
| 2 | 白毛玻璃菜单栏 + 石墨文字 | §2.5 + §6.1 | **PASS** — 白半透 + 1px 灰边 + 7 项（Apple / Finder / File / Edit / View / Window / Help）| **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 |
| 3 | Dock 11 系统图标（白玻璃）| §6.2 | **PARTIAL** — 12 系统（多 Launchpad + Contacts，**缺 Notes**），无分隔点 | **PARTIAL** — 10 系统 + Y，**无分隔点** | **PARTIAL** — 10 系统 + Y，**无分隔点** | **PARTIAL** — 12 系统（多 Contacts，Notes 错位）+ 分隔点 + Y + **多 1 Trash** | **PARTIAL** — 11 系统（多 Contacts，Notes 错位）+ 分隔点 + Y |
| 4 | 浅色玻璃窗口 + 14px 圆角 | §2.5, §6.3 | **PASS** — 白玻璃 + 14px 圆角 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 |
| 5 | Speaker 头像 STYLE 1（纯色圆+首字母）| §4.3 | **PARTIAL** — 6 圆 + 首字母正确，但**上方有 "STYLE 1" 灰字标签**（prompt 泄漏）| n/a | **PASS** — 7 圆 + 首字母（紫/青/粉），**无标签** | **PASS** — 5 圆 + 首字母（紫/青/粉），**无标签** | n/a |
| 6 | 控制面板 4 段式 + 零 waveform | §4.2 | **PARTIAL** — 3 段式（status/transport/secondary，无 waveform ✅），**但 stop 按钮下方有 "PRIMARY" 灰字泄漏**；C05 ref-04 本身也是 3 段，不是 4 段 | n/a | n/a | n/a | n/a |
| 7 | 紫青品牌色保持（按钮 / Y mark）| §2.1, §4.1 | **PASS** — stop 按钮紫青环 / Y icon 紫青渐变 | **PASS** — 顶部 mic nav 紫青渐变 + 高亮 tile 紫青 glow | **PASS** — avatar 紫/青/粉 + Y icon | **PASS** — Open pill 紫青 / Share 主按钮紫青 / Y icon | **PASS** — Y squircle 紫青渐变 / CTA 紫青 / Y icon |
| 8 | 文字色用 #1B1D22 石墨（不是纯黑）| §2.1 浅色规则 | **PASS** — 主文字为深石墨，非纯黑 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01 |
| 9 | 不 cyberpunk（无 glow / 霓虹 / 星空）| §7 | **PASS** — 无星空 / 无霓虹 / 无 glow；stop 紫青环是 brand 色非 glow | **PASS** — 同 01 | **PASS** — 同 01 | **PASS** — 同 01（AI SUMMARY sparkle 是 §7 允许）| **PASS** — 无 sparkles 围绕 mark |
| 10 | 无 prompt 规则泄漏（"STYLE 1" / "@ 65%" / "PRIMARY" / "14pt" 等）| C07/C06 教训 | **FAIL** — **13 处泄漏**："STYLE 1" ×6（每行 avatar 上）+ "@ 65%" ×6（每行 timestamp 后）+ "PRIMARY" ×1（stop 按钮下） | **FAIL** — **7 处泄漏**："14pt SF Pro Text 600" ×1（Recent header 下）+ "graphite @ 65%" ×6（4 tile + 3 Recording，README 报 6 实测 7）| **PASS** — 0 处泄漏 | **PASS** — 0 处泄漏 | **PASS** — 0 处泄漏 |

**逐图小计**：
- 01 meeting: 7 PASS / 2 PARTIAL（avatar 标签 / control panel 标签）/ 1 FAIL（prompt 泄漏）→ **PARTIAL**
- 02 empty: 7 PASS / 1 PARTIAL（Dock）/ 1 FAIL（prompt 泄漏）→ **PARTIAL**
- 03 transcript: 7 PASS / 1 PARTIAL（Dock）→ **PARTIAL**
- 04 review: 7 PASS / 2 PARTIAL（Dock / 额外 Trash）→ **PARTIAL**
- 05 onboarding: 7 PASS / 2 PARTIAL（Dock / Y mark 非 01 MINIMAL 严格定义）→ **PARTIAL**

---

## 2. 交叉一致性（4 项）

| # | 检查项 | 结果 | 证据 |
|---|--------|------|------|
| 11 | 菜单栏文字一致（含 app 名）| **PASS（进步）** | 5/5 张图菜单栏均为 "Apple / Finder / File / Edit / View / Window / Help"（**7 项**），app 名 "Finder" 都在。**C06 v3 时 3/5 张图缺 app 名，已修复**。 |
| 12 | Dock 图标顺序一致 | **FAIL** | 5 张图 Dock 都不一样：01 是 12 系统 + Y（多 Launchpad / Contacts，缺 Notes）；02 是 10 系统 + Y（无分隔点）；03 是 10 系统 + Y（无分隔点）；04 是 12 系统 + 分隔点 + Y + Trash；05 是 11 系统 + 分隔点 + Y。**与 C06 v3 同型问题未修**。 |
| 13 | 整体光感一致（暖白 + 紫青）| **PASS** | 5 张图都是 macOS 浅色 cream wallpaper + 极淡紫青 wash + 白玻璃窗口 + 紫青 accent。"感觉上是同一台 Mac 截的"，与 C06 v3 暗色版形成完整配色对。 |
| 14 | 时钟统一 | **FAIL（与 C06 v3 一致）** | 01/02/03 = 21:42；04 = 22:14；05 = 09:42。5 张图时钟分两组。**C06 v3 也是这种分布，未统一**。 |

---

## 3. V1 已知问题逐条验证（README 列表 + 主动发现）

### 3.1 README 列出的 V1 issue（逐条核对）

| 图 | README 列出 issue | 是否真在图里 | 严重度 |
|----|------------------|--------------|--------|
| 01 meeting | stop 按钮下 "PRIMARY" 标签 | ✅ 看到（灰字 "PRIMARY" 在 stop 按钮正下方）| medium（要 Figma 删）|
| 01 meeting | transcript 6 行 timestamp 后 "@ 65%" | ✅ 看到（6 处 "02:34:19 @ 65%" / "02:34:20 @ 65%" / ...）| medium（要 Figma 删）|
| 01 meeting | transcript 6 行 avatar 上 "STYLE 1" | ✅ 看到（6 处 "STYLE 1" 灰字在 avatar 上方）| **high**（要 Figma 删）|
| 02 empty | Recent header 下 "14pt SF Pro Text 600" | ✅ 看到（"Recent" 下方灰字 "14pt SF Pro Text 600"）| medium（要 Figma 删）|
| 02 empty | 2x2 tile 下 / Recent 每行 "graphite @ 65%" | ✅ 看到（4 tile 下各 1 处 + 3 Recording 各 1 处 = 7 处；README 报 6 处，实测 7 处）| medium（要 Figma 用真实 placeholder 替换）|
| 02 empty | 日历 "MEN" | ✅ 看到 | medium（Figma 后期替换）|
| 03 transcript | 日历 "HOR" | ✅ 看到 | medium |
| 03 transcript | 第 7 行（Sam）部分被 stop 按钮挡 | ✅ 看到（stop 圆按钮明显覆盖 Sam 行的右侧 timestamp + 文本）| **medium**（Figma 调 stop 位置）|
| 04 review | Dock 多 1 个 Trash icon | ✅ 看到（最右确实有 1 个白垃圾桶 icon）| **medium**（Figma 删 Trash）|
| 04 review | 日历 "DON" | ✅ 看到 | medium |
| 05 onboarding | 日历 "MAAN" | ✅ 看到 | medium |
| 01 meeting | 日历 "SUN" | ✅ 看到 | medium |

> 03 / 04 / 05 的 README 说"无 prompt 规则泄漏"在本次审计中**得到确认**（0 处泄漏，比 C06 v3 改善显著）。

### 3.2 主动发现的新问题（README 未列）

| # | 图 | 新问题 | 严重度 | 说明 |
|---|----|--------|--------|------|
| L1 | 01 meeting | **控制面板遮挡 "Speaker 3" 标签** | low | 左下浮动控制面板部分盖住 2x2 视频 grid 中"Speaker 3"那个 tile 的 name pill，pill 显示成 "ker 3"。Figma 把控制面板往左下多拉 16-24px 即可解决。 |
| L2 | 01 meeting | **Dock 多 Launchpad 多 Contacts，缺 Notes** | medium | D1 §6.2 锁定的 10 系统是 Finder/Safari/Messages/Mail/Notes/Calendar/Reminders/Maps/Music/System Settings。01 Dock 实际渲染：Finder / **Launchpad**（彩色 9-dot grid）/ Safari / Messages / Mail / **Contacts**（棕色 Address Book）/ Calendar / Reminders / Maps / Music / System Settings + Y。**Notes 缺失** + 多了 Launchpad + Contacts。 |
| L3 | 02 empty | **Dock 缺分隔点** | low | 10 系统直接接 Y，没有 §6.2 要求的 1px 分隔点。属于 V1 同型问题，未修。 |
| L4 | 03 transcript | **Dock 缺分隔点** | low | 同 L3。 |
| L5 | 04 review | **Dock Contacts 多 + Notes 错位 + Trash 多** | medium | D1 顺序应是 1) Finder 2) Safari 3) Messages 4) Mail 5) **Notes** 6) Calendar 7) Reminders 8) Maps 9) Music 10) System Settings 11) 分隔点 12) Y。04 Dock 实际：1) Finder 2) Safari 3) Messages 4) Mail 5) **Contacts** 6) Calendar 7) Reminders 8) **Notes**（错位到 8）9) Maps 10) Music 11) System Settings 12) 分隔点 13) Y 14) **Trash**。**多 Contacts + Notes 错位 + 多 Trash**（C06 v3 N6 + N7 同型未修）。 |
| L6 | 05 onboarding | **Dock Contacts 多 + Notes 错位** | medium | 与 04 同型（但 05 有分隔点 ✅）。**多 Contacts + Notes 错位**。C06 v3 N6 同型未修。 |
| L7 | 05 onboarding | **Y mark 不是 01 MINIMAL（黑底白 Y），而是白底紫青渐变 + 白 Y** | low-medium | D1 §3.3 明确"onboarding 欢迎页内嵌 mark | 01 MINIMAL（同主 icon 一致）"，C08 prompt 也写了"white frosted glass surface with a SUBTLE purple-to-teal aurora gradient inside, Y mark in WHITE"，**主动改成了 02 GRADIENT 风格的浅色变体**。这是**为浅色模式做的合理化适配**（纯黑 96px 放在浅色 cream wallpaper 上会突兀），但严格按 D1 §3.3 算 PARTIAL：浅色模式需要重定义 01 MINIMAL（应该是白底 + 紫青 wash + 白 Y），README 应在 D1 加一条 "01 MINIMAL 浅色版" 规范。 |
| L8 | 全部 | **时钟不一致** | low | 01/02/03 = 21:42，04 = 22:14，05 = 09:42。05 早 9:42 可以解读为"首次启动欢迎时间"，但与系列其他 4 张图脱节。Figma 统一改为 22:14 即可。 |
| L9 | 01 / 02 / 03 / 04 | **菜单栏 Finder app 名 与正文 Yinghua 品牌身份脱节** | low | 5 张图菜单栏都是 "Finder"，但 Yinghua app 应该是 menu bar 显示 "Yinghua" app 名（macOS 标准行为是显示当前活跃 app 名）。这是 D1 §6.1 的文字描述问题——文档说 "Apple logo + app 名（"Finder" 或 "Yinghua"）"，但 C08 prompt 统一用了 "Finder"。**C06 v3 同样问题未修**。 |
| L10 | 04 review | **副标题"Recorded today · 48 min · 1.2 GB" + "EN + 中文" 中的中文** | low | 浅色版的 04 review 出现了真实中文"中文"（不是占位符 lorem），说明模型在 prompt 没要求的情况下主动渲染了"中文"。这与 C06 v3 一致。但其他 4 张图（01/02/03/05）都没有中文。D1 规则说"中文优先 / Figma 后期替换"——04 提前混了 1 个真中文，不一致。 |
| L11 | 01 meeting | **mic button row 最右 end-call 红按钮** | n/a | 红色 #FF3B30 + 白色电话图标，符合 D1 §2.1 功能色规则。✅ |
| L12 | 02 empty | **"Open" 文字按钮在 3 个 Recording 卡片右侧** | n/a | Prompt 要求是 "small 'Open' text button in graphite @ 65% (no fill, just text — this is a GHOST button style)"。实际渲染是纯文字"Open"，无背景无边框——**符合 ghost button 规范** ✅。 |
| L13 | 01 meeting | **02 02 03 5 张图均无 dock 全部 10 系统图标** | medium | D1 §6.2 明确锁定 10 个系统图标，5 张图每张都缺 / 多 1-2 个。详见 L2/L5/L6 + 02/03 都缺分隔点。 |

### 3.3 与 C06 v3 对比：C08 修复 vs C06 残留问题

| 问题 | C06 v3 状态 | C08 浅色版状态 | 改进 |
|------|-------------|----------------|------|
| 05 onboarding "Yinghua" 副标题 + "~14pt regular" prompt 泄漏 | FAIL | **PASS**（只有 1 个 "Yinghua" 大标题）| ✅ 修复 |
| 05 onboarding "Get started 600 15pt ↗" 字号泄漏 | FAIL | **PASS**（只有 "Get started →"）| ✅ 修复 |
| 05 onboarding Y mark 错用 02 GRADIENT | FAIL | **PARTIAL**（改为 02 GRADIENT 浅色变体，仍非 01 MINIMAL 严格定义）| ⚠ 部分修 |
| 04 review transcript 上方 "STYLE 1" 文字烧入 | FAIL | **PASS**（04 transcript 无 "STYLE 1" 标签）| ✅ 修复 |
| 03 transcript "STYLE 1" ×6 avatar 上方标签 | FAIL | **PASS**（03 transcript avatar 上方无标签）| ✅ 修复 |
| 03 transcript timestamp "@ 65%" 泄漏 | FAIL | **PASS**（时间码 02:34:55 干净）| ✅ 修复 |
| 菜单栏 5 项 / 缺 app 名（02/03/05）| PARTIAL | **PASS**（5/5 都有 "Finder"）| ✅ 修复 |
| 01 meeting "PRIMARY" 标签泄漏 | 未列 | **FAIL**（仍然存在）| ❌ 未修 |
| 01 meeting "@ 65%" 标签泄漏 | 未列 | **FAIL**（仍然存在，6 处）| ❌ 未修 |
| 01 meeting "STYLE 1" avatar 上方标签 | 未列 | **FAIL**（仍然存在，6 处）| ❌ 未修 |
| 02 empty "14pt SF Pro Text 600" / "graphite @ 65%" 泄漏 | 未列 | **FAIL**（仍然存在，7 处）| ❌ 未修 |
| 04 review Dock Trash 多 1 个 | FAIL | **PARTIAL**（Trash 仍多）| ❌ 未修 |
| 04/05 Dock Contacts 多 + Notes 错位 | FAIL | **PARTIAL**（仍多 + 错位）| ❌ 未修 |
| 5/5 张图 Dock 顺序不一致 | FAIL | **FAIL**（仍不一致）| ❌ 未修 |
| 5/5 张图时钟不一致 | FAIL | **FAIL**（仍 21:42 / 22:14 / 09:42）| ❌ 未修 |
| 5/5 张图日历 day-name 乱码 | FAIL | **FAIL**（SUN/MEN/HOR/DON/MAAN）| ❌ 未修 |
| 03 transcript stop 按钮挡最后一行 | FAIL | **FAIL**（仍挡）| ❌ 未修 |

---

## 4. 与 C06 v3 深色版对应关系

### 4.1 5 张图布局结构对齐

| 图 | C06 深色版结构 | C08 浅色版结构 | 对齐 |
|----|----------------|----------------|------|
| 01 meeting | 2x2 video grid + 浮动 control panel + 右侧 transcript 6 行 + 底部 mic row | **同**（2x2 + 浮动 panel + 6 transcript + mic row）| ✅ 完全对齐 |
| 02 empty | 左 4 圆 nav + 中 2x2 tile + 右 3 Recent | **同** | ✅ 完全对齐 |
| 03 transcript | 顶 REC 条 + 7 行 transcript + 右下 stop 按钮 | **同** | ✅ 完全对齐 |
| 04 review | 左 file card + transcript + speaker chips / 右 4 AI summary sections + 2x2 buttons | **同** | ✅ 完全对齐 |
| 05 onboarding | 居中 Y mark + 标题 + 3 bullets + CTA + ghost link + 3-dot | **同** | ✅ 完全对齐 |

**5/5 张图布局结构 100% 对齐深色版**。这是 C08 浅色版最大的设计胜利——**Figma 终版可以一份代码双模渲染**。

### 4.2 色彩反转正确

| 元素 | C06 深色版 | C08 浅色版 | 反转正确？ |
|------|------------|------------|------------|
| 桌面壁纸 | 深空 + 极光紫青 | 暖白 + 极淡紫青 | ✅ |
| 菜单栏 | 黑色毛玻璃 + 暖白字 | **白毛玻璃 + 石墨字** | ✅ |
| Dock | 黑色毛玻璃 | **白色毛玻璃** | ✅ |
| 窗口背景 | 暗色玻璃 + 紫青 wash | **白玻璃 + 10% 紫青 wash** | ✅ |
| 窗口主文字 | `#F4F1EC` 暖白 | **`#1B1D22` 石墨** | ✅ |
| 窗口次文字 | `#F4F1EC @ 80%` | **`#1B1D22 @ 65%`** | ✅ |
| REC 红点 | `#FF3B30` | **`#FF3B30`** | ✅ 不变 |
| 紫青品牌色 | `#B57BFF → #2DD4BF` | **同** | ✅ 不变 |
| Primary 按钮 | 紫青渐变 + 白字 | **紫青渐变 + 白字** | ✅ 不变 |
| Secondary 按钮 | 玻璃深 | **白玻璃 + 1px 灰边** | ✅ |
| 卡片边框 | 1px 8% 白 | **1px 8% 黑** | ✅ |

**色彩反转 100% 符合 D1 §2.1 浅色规则 + README "浅色色彩规则"表**。没有任何一张图"忘了反转"。

### 4.3 浅色独有风险

| # | 风险 | 严重度 | 说明 |
|---|------|--------|------|
| LR1 | **玻璃窗口边缘对比度偏低** | low | 14px 圆角白玻璃窗 + 暖白 wallpaper + 1px #1B1D22@8% hairline。边缘的对比度比深色版（暗玻璃 + 暗 wallpaper + 白 hairline @ 8%）低。**1px @ 8% 灰边在暖白底上几乎不可见**。在 5 张图里能看到窗口边界主要靠 drop shadow 而不是 hairline。**Figma 终版建议把 hairline 从 @ 8% 提到 @ 12-15%**，或者在 14px 圆角外加更明显的 1px dark border @ 15%。 |
| LR2 | **Primary 紫青渐变在白底上不如暗色突出** | low | 05 CTA "Get started →" 紫青渐变在白玻璃窗口上仍然可见，但视觉权重比 C06 v3 暗色版低。**Figma 终版可以保持**，因为是 macOS 标准做法。 |
| LR3 | **Speaker avatar 紫/青/粉 + 白字在浅色 tile 上对比度** | low | 04 / 03 的 avatar 在白玻璃上仍是纯色圆 + 白首字母，对比度足够。✅ |
| LR4 | **"Open" pill 紫青渐变在白 file card 上** | low | 04 review file card 内 "Open" 紫青 pill 可见。✅ |
| LR5 | **5 张图 cream wallpaper 渐变方向不同** | low | 01-04 都是"左上极淡紫 + 右下极淡青"标准方向；05 也一致。**整体光感方向 5/5 统一**。✅ |
| LR6 | **05 brand mark 在白底上不够"黑"** | medium | 浅色版 05 mark 是白玻璃 + 紫青 wash + 白 Y。在白 wallpaper 上对比度偏低，远看几乎融入背景。**Figma 终版建议给 96x96 mark 加 1px 紫青 hairline @ 30% 或者把 wash opacity 提到 25-30%**，让 mark 边界更明确。 |
| LR7 | **04 review file card 中"中文"真字串** | low | "EN + 中文" 提前混了 1 个真中文，与其他 4 张图不一致。Figma 终版统一处理。 |

---

## 5. 总结

### 总体 VERDICT: **PARTIAL**

**判定理由**：
- 10 项 × 5 张 = 50 个判定点中，PASS ≈ 39 / PARTIAL ≈ 9 / FAIL ≈ 2。
- **没有"主体崩塌"或"5+ 不可修"的 FAIL**（Y 字形错、整张图 cyberpunk、窗口无 traffic light、整张图纯白 SaaS 等均未发生）。
- 2 个 FAIL 全部集中在 prompt 规则泄漏（01 ×13 处 + 02 ×7 处 = 20 处），是**Figma 后期可修**的。
- 9 个 PARTIAL 中 5 个是 Dock 顺序 / 系统图标缺失（D1 §6.2 锁定的 10 系统在 5 张图里有 4 种不同的渲染方式），是 Figma 后期可修的。
- **整体调性（暖白 + 极淡紫青 + 白玻璃 + 石墨字）锁定成功**，5 张图视觉语言一致，与 C06 v3 深色版形成完整配色对。
- **C06 v3 的 5 个高严重度 prompt 泄漏问题中 3 个已修复**（05 onboarding 全部 3 个 + 04 review STYLE 1 标签 + 03 transcript 顶部 STYLE 1 标签），是本轮最大进步。

### 最严重的 3 个问题（按"影响品牌严肃度"排序）

1. **【HIGH】01 meeting prompt 规则文字 13 处泄漏**
   - 位置：`01-meeting/product-meeting-in-progress-light__260823.jpg`
   - 现状：
     - transcript 6 行 avatar 上方："STYLE 1" ×6（灰字小标签）
     - transcript 6 行 timestamp 后："@ 65%" ×6（如 "02:34:19 @ 65%"）
     - 控制面板 stop 按钮下方："PRIMARY"（灰字）
   - 修法：Figma 一次性删除所有 "STYLE 1" / "@ 65%" / "PRIMARY" 灰字。03 transcript 的 prompt 已经成功避免了这些泄漏（03 prompt 末尾加了 "Do NOT print ... 'STYLE 1' / '65%' / 'PRIMARY'"），**把同一段显式禁止加到 01 prompt 模板里**，未来重出图也会修。

2. **【HIGH】02 empty prompt 规则文字 7 处泄漏**
   - 位置：`02-empty/product-empty-state-light__260823.jpg`
   - 现状：
     - Recent header 下方："14pt SF Pro Text 600"（灰字）
     - 2x2 tile 下方 ×4 + Recording 卡片副标题 ×3："graphite @ 65%"（灰字，重复 7 次）
   - 修法：Figma 一次性删除所有 "14pt SF Pro Text 600" / "graphite @ 65%"。**把 2x2 tile 替换为真实占位文案**（如 "新建录制" / "导入音频" / "查看文档" / "分享"），Recent 卡片副标题替换为真实时间（如 "今天 14:30 · 48 min"）。

3. **【MEDIUM】5/5 张图 Dock 顺序 / 系统图标不一致**
   - 位置：5 张图底部 Dock
   - 现状：
     - 01：12 系统（多 Launchpad + Contacts，缺 Notes，无分隔点）
     - 02：10 系统 + Y（无分隔点）
     - 03：10 系统 + Y（无分隔点）
     - 04：12 系统（多 Contacts，Notes 错位）+ 分隔点 + Y + Trash
     - 05：11 系统（多 Contacts，Notes 错位）+ 分隔点 + Y
   - 修法：Figma 终版用**统一 master dock** 替换 5 张图底部 Dock，按 D1 §6.2 锁定的 12 项顺序：1) Finder 2) Safari 3) Messages 4) Mail 5) Notes 6) Calendar 7) Reminders 8) Maps 9) Music 10) System Settings 11) 分隔点 12) Y。日历 "26" day name 统一替换为标准 day（MON/TUE/WED/THU/FRI/SAT/SUN）。

### 给 Round 3 矢量精修 / Figma 后期 的建议

| 建议 | 优先级 | 工作量 |
|------|--------|--------|
| **批量删除 01 + 02 的所有 prompt 规则泄漏文字**（共 20 处）| P0 | Figma 1 小时 |
| **统一 5 张图 Dock**（用 master dock 替换，统一到 12 项标准顺序）| P0 | Figma 2 小时 |
| **批量删除 04 Dock Trash + 替换 5 张图日历 day-name** | P0 | Figma 1 小时 |
| **5 张图时钟统一为 22:14** | P1 | Figma 30 分钟 |
| **03 transcript stop 按钮移到内容区底部右下、不挡最后一行** | P1 | Figma 1 小时 |
| **01 meeting 控制面板左移 16-24px，不挡 "Speaker 3"** | P2 | Figma 30 分钟 |
| **05 brand mark 提升对比度**（hairline @ 30% 或 wash 25-30%）| P2 | Figma 30 分钟 |
| **把 4 review "EN + 中文" 统一为占位符 / 真中文字串** | P2 | Figma 15 分钟 |
| **5 张图菜单栏加 "Yinghua" app 名（替代 "Finder"）** | P2 | Figma 15 分钟 |
| **下次出图 prompt 模板修正**：在 01 / 02 prompt 末尾复制 03 的 "Do NOT print ... STYLE 1 / @ 65% / PRIMARY / 14pt / graphite" 段 | P0（避免 Round 2 重蹈覆辙）| 改 prompt 10 分钟 |
| **下次出图 prompt 加显式 11 icon 顺序 + 强制分隔点 + 禁止加 Trash** | P0 | 改 prompt 10 分钟 |
| **D1 §3.3 加 "01 MINIMAL 浅色版" 规范**：白底 + 紫青 wash @ 25% + 白 Y | P1 | 改 D1 1 小时 |
| **D1 §2.5 浅色模式 hairline 从 @ 8% 提到 @ 12-15%**（窗口边缘可见性）| P1 | 改 D1 30 分钟 |

---

## 6. 给 owner 的回 report

- **VERDICT**：**PARTIAL**
- **浅色版是否可直接进 Round 3 矢量精修 / Figma 后期**：
  - **可以，且建议直接进**。C08 浅色版已经把 5 张图的整体调性锁定（暖白 + 紫青 + 白玻璃 + 石墨字），结构 1:1 对齐 C06 v3 深色版，比 C06 v3 修复了 5 个高严重度问题。剩余的 20 处 prompt 泄漏 + 5 张图 Dock 不一致都是 Figma 后期可修的，**不需要重出图**。
- **最严重的 3 个问题**（见 §5）：
  1. 01 meeting prompt 规则泄漏 13 处（STYLE 1 / @ 65% / PRIMARY）
  2. 02 empty prompt 规则泄漏 7 处（14pt SF Pro Text 600 / graphite @ 65%）
  3. 5/5 张图 Dock 顺序 / 系统图标不一致（D1 §6.2 锁定 12 项顺序在 5 张图里有 4 种不同渲染）
- **新发现 13 项问题**（L1-L13），全部记录在 §3.2，重要程度从 high 到 low 都已标注
- **建议立即做**：Figma 后期 P0 三件套（删 01/02 泄漏 + 统一 5 张图 Dock + 改日历 day-name）= ~4 小时
- **建议中期做**：5 张图时钟统一 + 03 stop 按钮位置 + 05 Y mark 对比度 = ~2 小时
- **下次出图 prompt 必须改**：把 03 的 "Do NOT print ... STYLE 1 / @ 65% / PRIMARY / 14pt" 显式禁止段复制到所有 prompt 末尾
