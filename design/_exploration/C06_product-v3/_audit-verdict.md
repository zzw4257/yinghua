# C06 v3 5 张图 — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：`design/design-doc.md` §1-8（D1 master）
**审计对象**：`C06_product-v3/01-meeting-in-progress` / `02-empty-state` / `03-transcript-focus` / `04-review-mode` / `05-onboarding`

---

## 1. 9 项 × 5 张图 检查表

| # | 检查项 | D1 规则 | 01 meeting | 02 empty | 03 transcript | 04 review | 05 onboarding |
|---|--------|---------|------------|----------|---------------|-----------|----------------|
| 1 | 菜单栏 6 项（Apple / app 名 / 5 menu / 时钟） | §6.1 | **PASS**（Finder）| **PARTIAL**（❌ 缺 app 名）| **PARTIAL**（❌ 缺 app 名）| **PASS**（Finder）| **PARTIAL**（❌ 缺 app 名）|
| 2 | Dock 10 系统 + 1 分隔点 + 1 Y | §6.2 | **PARTIAL**（10 系统 + Y，❌ 缺分隔点）| **PARTIAL**（10 系统 + Y，❌ 缺分隔点；❌ 日历 "MIY" 乱码）| **FAIL**（只 ~7 系统 + Y，缺 Maps/Music/Settings + 无分隔点）| **FAIL**（13 项 + Y 在中间 + Trash + 无分隔点）| **PARTIAL**（10 系统 + Y + Trash，无分隔点）|
| 3 | 极光壁纸（深空 + 紫青） | §2.1 | **PASS** | **PASS** | **PASS** | **PASS** | **PASS** |
| 4 | 暗色玻璃 vibrancy 窗口 / 14px 圆角 | §2.5, §6.3 | **PASS** | **PASS** | **PASS** | **PASS** | **PASS** |
| 5 | Speaker 头像 STYLE 1（纯色圆+首字母）| §4.3 | **PASS**（A 紫 / B 粉）| n/a | **PASS**（A 紫 / E 青 / M 粉 / P 紫）| **PARTIAL**（✅ 圆+首字母，❌ 但上方有 "STYLE 1" 提示文字泄漏）| n/a |
| 6 | 控制面板 4 段式 + 零 waveform | §4.2 | **PASS**（4 段：REC 红点/transport/secondary/close，无 waveform）| n/a | **PARTIAL**（顶部 REC 条 + ⚙；底部 ⏹ 单按钮；非 4 段浮窗；无 waveform ✅）| n/a | n/a |
| 7 | Primary 按钮紫青渐变 | §4.1 | n/a | n/a | n/a | **PASS**（Share 按钮紫→青渐变）| **PASS**（CTA 紫→青渐变，文字 `Get started 600 15pt` 是 prompt 规则泄漏）|
| 8 | 不 cyberpunk（无 glow / 霓虹 / 星空）| §7 | **PASS** | **PASS** | **PASS** | **PASS** | **PASS** |
| 9 | 无装饰性 sparkles / 双环 ∞ / "AI" 烧图 | §7 | **PASS** | **PASS** | **PASS** | **PASS**（✨ 仅用于 AI SUMMARY section marker，D1 §7 允许）| **PASS** |

**逐图小计**：
- 01 meeting: 6 PASS / 1 PARTIAL（Dock）→ **PARTIAL**
- 02 empty: 5 PASS / 2 PARTIAL（menu、Dock）→ **PARTIAL**
- 03 transcript: 4 PASS / 3 PARTIAL（menu、Dock、control-panel 形式）→ **PARTIAL**
- 04 review: 5 PASS / 1 PARTIAL（avatar 旁 "STYLE 1" 文字泄漏） + 1 FAIL（Dock）→ **PARTIAL**
- 05 onboarding: 4 PASS / 2 PARTIAL（menu、Dock） + 见 §3 新发现问题 → **PARTIAL**

---

## 2. 交叉一致性（5 张图互相对齐）

| # | 检查项 | 结果 | 证据 |
|---|--------|------|------|
| 10 | Dock 图标顺序一致 | **FAIL** | 5 张图 Dock 顺序各异：01 / 02 是 "10 系统 + Y"；03 只有 ~7 系统 + Y；04 有 13 项（Y 在中间、Trash 末尾）；05 是 "10 系统 + Y + Trash"。没有任何两张图 Dock 完全一致。 |
| 11 | 菜单栏文字一致 | **FAIL** | 01 / 04 有 "Finder" app 名；02 / 03 / 05 没有 app 名。时钟：01/02/03 21:42，04 22:14，05 09:42（05 与其他 4 张差 12 小时）。 |
| 12 | 整体光感 / 玻璃感一致 | **PASS** | 5 张图都是 macOS Sonoma/Sequoia 风格暗色 aurora 桌面 + 系统级 vibrancy 玻璃，"感觉上是同一台 Mac 截的"。 |

---

## 3. V1 已知问题逐条验证（README 列表 + 主动发现）

### 3.1 README 列出的 V1 issue（逐条核对）

| 图 | README 列出 issue | 是否真在图里 | 严重度 |
|----|------------------|--------------|--------|
| 01 meeting | transcript 列 `Speaker name` × 6 | ✅ 看到 6 行 "Speaker name" | medium（Figma 替换）|
| 01 meeting | 顶部 `● REC 02:34` | ✅ 看到（控制面板 + transcript 副屏均有）| medium |
| 01 meeting | transcript 顶部 `TRANSCRIPT` | ✅ 看到 | low |
| 02 empty | 右侧 3 行 `2022-03-17` / `duration` × 3 | ✅ 看到（日期 2022-03-17 / 2021-03-17 / 2021-03-17 + "duration" 占位）| medium |
| 02 empty | 日历 Dock 显示 `MIY` | ✅ 看到（红字 "MIY" 替代 "26"）| **medium** |
| 03 transcript | speaker 名乱码（`Bold aeer name` / `Ploeaker name` / `Moleaker name`）| ✅ 看到 4 种乱码变体 | medium |
| 03 transcript | `● REC 02:34` | ✅ 看到 | medium |
| 04 review | 文件名 `Zoe-frontend-final-round` | ✅ 看到 | medium |
| 04 review | 副标题 `Recorded today · 48 min · 1.2 GB` | ✅ 看到 | medium |
| 04 review | 标签 `MP4` / `EN + ZH` / `2 speakers` | ✅ 看到 | low（这些 target 是英文/缩写）|
| 04 review | `● Zoe 62%` / `● Me 38%` | ✅ 看到 | medium |
| 04 review | 4 段英文标题 | ✅ 看到 Key moments / Decisions / Action items / Open questions | medium |
| 04 review | `AI SUMMARY` / `Regenerate` | ✅ 看到 | medium |
| 04 review | 2x2 按钮 `Copy summary` / `Export PDF` / `Share` / `Done` | ✅ 看到 | medium |
| 04 review | "STYLE 1" prompt 规则文字泄漏 | ✅ 看到（在 transcript 列上方，灰字"STYLE 1"作为 section label）| **high** |
| 05 onboarding | `Yinghua ~14pt regular` prompt 规则泄漏 | ✅ 看到（"Yinghua" 主标题下方灰字"Yinghua ~14pt regular"）| **high** |
| 05 onboarding | `Get started 600 15pt` prompt 规则泄漏 | ✅ 看到（CTA 按钮内文字含 "600 15pt" 字号描述）| **high** |
| 05 onboarding | ghost link `I already have an account` | ✅ 看到（这本身就是 target 文案，非泄漏）| low |
| 05 onboarding | 3 bullet 英文 | ✅ 看到 3 行英文 bullet | medium |
| 05 onboarding | 日历 Dock `ПАН`（Cyrillic）| ✅ 看到（红字 "ПАН" 替代 "26"）| **medium** |

### 3.2 **主动发现的新问题**（README 未列）

| # | 图 | 新问题 | 严重度 | 说明 |
|---|----|--------|--------|------|
| N1 | 02 / 03 / 05 | **菜单栏缺 app 名** | medium | 3 张图菜单栏只有 Apple + 5 menu + 时钟，缺 "Finder" / "Yinghua"。D1 §6.1 明确要求 "Apple logo + app 名（'Finder' 或 'Yinghua'）+ 'File Edit View Window Help'"。**根因**：4 / 5 张图的 prompt 把 D1 的 "Apple + app name + 4 menu" 错误写成 "Apple + 5 menu"（少了 app 名），模型忠实执行了 prompt 但违反了 D1 master。 |
| N2 | 04 review | **Dock 严重不一致** | high | 13 项，Y 在中间（位置 13），末尾有 Trash，无分隔点。D1 §6.2 要求 Y 必须在分隔点之后（位置 12）。模型完全没遵守 prompt 中 "EXACTLY these 11 icons in this order" 的指示。 |
| N3 | 05 onboarding | **Y mark 错用 02 GRADIENT 而非 01 MINIMAL** | high | 中央品牌 mark 是暗色背景 + 紫青渐变 Y（02 GRADIENT 风格）。D1 §3.3 明文规定 "onboarding 欢迎页内嵌 mark | 01 MINIMAL（同主 icon 一致）"，应当是黑底 + 纯暖白 Y。同时 prompt 也明确写了 "Y mark in white"，但模型没遵守。 |
| N4 | 03 transcript | **Dock 图标严重缺失** | high | Dock 只有 ~7 个系统图标（Finder / Safari / Messages / Mail / Notes / Calendar / Reminders），缺 Maps / Music / System Settings 等。明显少于其他 4 张图。 |
| N5 | 03 transcript | **控制面板非 4 段式浮窗** | low-medium | 03 没有 D1 §4.2 描述的 4 段式浮窗（status / transport / secondary / close），而是把 REC 放在 title bar + 单 stop 按钮在右下角。这是 transcript 场景的合理化设计，不算严重违反 D1（因为 D1 §4.2 主要针对 meeting-in-progress），但与连责检查表预期不一致。 |
| N6 | 05 onboarding | **Dock 多出 Contacts / Address Book** | low | 05 Dock 第 5 位出现一个木纹 Address Book（通讯录）图标，不在 D1 §6.2 锁定的 10 系统图标列表里。 |
| N7 | 04 review | **"STYLE 1" 文字直接烧入图像** | high | 不只是 prompt 泄漏在 prompt 文件里，而是模型把 "STYLE 1" 作为可见文字渲染到 UI 上（位于 transcript 列表上方）。这是 prompt 规则被模型当作 label 渲染的典型案例，需要 Figma 删除。 |
| N8 | 05 onboarding | **品牌名重复 "Yinghua / Yinghua"** | medium | 大标题 "Yinghua"（应该是映话），下方又写 "Yinghua ~14pt regular"（prompt 规则泄漏）。Figma 需替换为 "映话" 中文 + 删除 prompt 泄漏。 |
| N9 | 05 onboarding | **CTA 按钮文字含字号描述** | high | 按钮上文字是 "Get started 600 15pt ↗"，其中 "600 15pt" 是 prompt 中的字号定义泄漏。Figma 必须重写为 "开始使用 ↗"。 |
| N10 | 05 onboarding | **时区/时间与系列其他图不一致** | low | 05 时钟 09:42，其他 4 张是 21:42 / 22:14。可能想表达"早 9:42 第一次打开"，但和系列其他图脱节。 |
| N11 | 03 transcript | **顶部状态栏最右侧的 ⓧ 状态图标异常** | low | 03 状态栏最右是 ⓧ 风格图标（不常见于标准 macOS 状态栏；正常应该是 battery / Wi-Fi / search / control center / Siri / clock）。需检查是否模型生成了非标准图标。 |

---

## 4. 总结

### 总体 VERDICT: **PARTIAL**

**判定理由**：
- 9 项 × 5 张 = 45 个判定点中，PASS ≈ 33 / PARTIAL ≈ 9 / FAIL ≈ 3。
- 没有"5+ 不可修"或"主体崩塌"的 FAIL（Y 字形错、整张图 cyberpunk、窗口无 traffic light 等均未发生）。
- 所有 FAIL 和 high-severity PARTIAL 都是**Figma 后期可修的**：文字替换 / 删除 prompt 泄漏 / 调换 Dock 图标 / 改 Y mark 风格。模型本身没有结构性错误。
- 整体调性（暗色 aurora 桌面 + vibrancy 玻璃 + 紫青 accent + Apple 克制）锁定成功，5 张图视觉语言一致。

### 最严重的 3 个问题（按"影响品牌严肃度"排序）

1. **【HIGH】05 onboarding 品牌 mark 错用 02 GRADIENT**（新发现 N3）
   - 位置：`05-onboarding/product-onboarding-v3__260822.png` 中央 96x96 mark
   - 现状：暗色背景 + 紫青渐变 Y（02 GRADIENT 风格）
   - D1 规则：§3.3 "onboarding 欢迎页内嵌 mark | 01 MINIMAL（同主 icon 一致）"，应当是 `#0A0A0F` 黑底 + 纯 `#F4F1EC` 暖白 Y
   - 修法：Figma 替换为 01 MINIMAL mark

2. **【HIGH】04 review "STYLE 1" prompt 规则文字直接烧入图像**（新发现 N7）
   - 位置：transcript 列上方，灰字小标签
   - 现状：模型把 prompt 中的 `STYLE 1` 当成 UI label 渲染
   - 修法：Figma 删除该文字

3. **【HIGH】05 onboarding prompt 规则文字两处泄漏**（README 已列 + N8 + N9）
   - 位置：副标题 `Yinghua ~14pt regular` + CTA 按钮 `Get started 600 15pt ↗`
   - 现状：模型把 prompt 里的 "14pt regular" 和 "600 15pt" 字号描述直接当文案渲染
   - 修法：Figma 替换为 "映话" + "开始使用 ↗"

### 给 Round 2 (C08 / C09 / Figma pass) 的建议

| 建议 | 优先级 |
|------|--------|
| **Figma 后期修一批**（一张 Figma 文件就够）：所有英文 placeholder → 中文；删除 "STYLE 1" / "Yinghua ~14pt regular" / "Get started 600 15pt"；日历 "MIY" / "ПАН" → "26" | P0（必须做，否则 5 张图不能上线）|
| **统一 5 张图 Dock**：按 D1 §6.2 锁定的 12 项顺序（10 系统 + 分隔点 + Y）做一套 master dock，Figma 统一贴入 5 张图 | P0 |
| **统一菜单栏**：所有 5 张图菜单栏加 "Finder" 或 "Yinghua" app 名 | P1 |
| **05 Y mark 改 01 MINIMAL** | P0 |
| **删除 05 Dock 多余的 Address Book 和 Trash**（04 也删 Trash）| P1 |
| **时间统一**：5 张图时钟统一为同一时间（如 22:14） | P2 |
| **下次 prompt 模板修正**："Apple logo, app name 'Yinghua'/'Finder', 'File Edit View Window Help'" 而不是 "Apple logo, 'File Edit View Window Help'" | P1（避免 Round 2 重蹈覆辙）|
| **下次 prompt 加显式禁止**："Do NOT render any text from the prompt itself (e.g. '~14pt regular', 'STYLE 1', '600 15pt')" | P1 |

---

## 5. 给 owner 的回 report

- **VERDICT**：**PARTIAL**
- **是否需要重出图**：**不需要重出**。所有问题在 Figma 后期可修。建议 Round 2 直接进入 Figma 精修轮（一次性批量替换文字、统一 Dock、修 05 Y mark），不必再调生图模型。
- **最严重的 3 个问题**（见 §4）：05 Y mark 错风格 / 04 STYLE 1 文字烧图 / 05 prompt 规则两处泄漏
- **新发现 11 项问题**（README 没列），全部记录在 §3.2，重要程度从 high 到 low 都已标注
