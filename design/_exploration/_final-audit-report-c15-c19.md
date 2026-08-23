# C15-C19 shippable 出片 — 独立审计综合 report

**审计人**：verifier（独立）
**日期**：2026-08-23 02:00 EDT（**最终快照**；02:00 后 producer 无新动作）
**审计依据**：D1 `design/design-doc.md` + C02 §2.3 anti-leak + C02 §2.4 Dock 锁定 + C06/C08/C09 audit baseline + D2 design-tokens
**审计对象**：5 批共 25 张 shippable 图（C15 dark × 5 / C16 light × 5 / C17 onboarding × 3 / C18 marketing landing × 6 / C19 marketing social × 6）
**审计范围**：22 / 25 张到位，3 张缺失（C15 04 review / C15 05 onboarding / C16 05 onboarding）

---

## 0. TL;DR

| 批 | 主题 | 已审 | Shippable PASS | Shippable PARTIAL | FAIL | 缺失 | VERDICT |
|----|------|------|----------------|--------------------|------|------|---------|
| **C15** | dark shippable | 3/5 | 0 | 0 | **3** | 2 | ❌ **FAIL** |
| **C16** | light shippable | 4/5 | 1 | 0 | **3** | 1 | ❌ **FAIL** |
| **C17** | onboarding | 3/3 | 2 | 0 | **1** | 0 | ⚠️ **PARTIAL**（2 PASS + 1 catastrophic FAIL）|
| **C18** | marketing landing / PH / blog | 6/6 | **6** | 0 | 0 | 0 | ✅ **PASS** |
| **C19** | marketing social / email / deck | 6/6 | 3 | 1 | **2** | 0 | ❌ **FAIL** |
| **合计** | — | **22/25** | **12** | **1** | **9** | **3** | — |

**核心数字**：
- **12 / 25 张 shippable-as-is PASS**（48%）
- **1 / 25 张 shippable PARTIAL**（C19 email-product-update borderline，4%）
- **9 / 25 张 FAIL**（36%，需 producer 重做）
- **3 / 25 张缺失**（12%，需 producer 补全）

---

## 1. 5 批逐项详细 verdict

### C15 dark shippable — ❌ FAIL（3/5 已审）

| 资产 | 12 项检查表 | 新发现 | VERDICT |
|------|-------------|--------|---------|
| `01-meeting/product-meeting-in-progress__260824.jpg` | 11 P / 0 Pa / **1 F** | 日历 "**ONLY 26**"（"ONLY" 非 day name）| ❌ FAIL |
| `02-empty/product-empty-state__260824.jpg` | 11 P / 0 Pa / **1 F** | 日历 "**麦月 26**"（"麦月" 中文碎片）| ❌ FAIL |
| `03-transcript/product-transcript-focus__260824.jpg` | 11 P / 0 Pa / **1 F** | 日历 "**ONLY 26**"（与 01 同根因）| ❌ FAIL |
| `04-review/` | — | — | ⛔ 缺失 |
| `05-onboarding/` | — | — | ⛔ 缺失 |

**C15 进步点**：3/3 张图无任何 prompt 规则文字泄漏（"STYLE 1" / "14pt" / "AI" / "node" 全部规避）— producer 在 dark batch 下 addendum 执行良好
**C15 痛点**：日历 day name 乱码家族（C06 "MIY" → C09 "NEN/MEM" → C15 "ONLY/麦月" — 变体在演化，根因未修）

### C16 light shippable — ❌ FAIL（4/5 已审）

| 资产 | 12 项检查表 | 新发现 | VERDICT |
|------|-------------|--------|---------|
| `01-meeting/product-meeting-in-progress-light__260824.png` | 12 P / 0 Pa / 0 F | 干净 | ✅ PASS |
| `02-empty/product-empty-state-light__260824.png` | 10 P / 1 Pa / **1 F** | 4 个 tile 下方 "**65%**" 灰字（C08 老问题复现）；Dock 多 Trash | ❌ FAIL |
| `03-transcript/product-transcript-focus-light__260824.png` | 11 P / 0 Pa / **1 F** | 菜单栏右侧 "**e1n**" 红色乱码（新变体）| ❌ FAIL |
| `04-review/product-review-mode-light__260824.png` | 9 P / 2 Pa / **1 F** | 菜单栏 "**e1n**" + ✨ sparkle borderline | ❌ FAIL |
| `05-onboarding/` | — | — | ⛔ 缺失 |

**C16 亮点**：01 meeting 完全干净（C08 13 处泄漏 → 0 处）— 痛点彻底解决
**C16 痛点**：02 empty "65%" 部分复现 + 03/04 菜单栏乱码（addendum 漏掉的新位置）

### C17 onboarding shippable — ⚠️ PARTIAL（3/3 已审）

| 资产 | 12 项检查表 | 新发现 | VERDICT |
|------|-------------|--------|---------|
| `01-welcome/onboarding-01-welcome__260824.png` | 12 P / 0 Pa / 0 F | 完美：Y icon 02 GRADIENT + 3 bullet + 紫青 CTA | ✅ PASS |
| `02-permission/onboarding-02-permission__260824.png` | 11 P / 1 Pa / 0 F | 3 卡片 + 3 pill 状态正确（绿/灰/灰）；dot 2 active；Dock 多 Trash (PARTIAL) | ✅ PASS |
| `03-byok/onboarding-03-byok__260824.png` | 9 P / 1 Pa / **1 CATASTROPHIC F** | **12 处 `~XXpt` / `50% OPACITY` 字体规格作为可见 UI 文字**（C02 §2.3 addendum 漏位置）| ❌ FAIL |

**C17 进步点**：02 菜单栏 app 名 + Dock 第 5 位 + 02/03 日历乱码 — C09 3 个 V1 痛点全部解决
**C17 新痛点**：03 byok 12 处字体规格泄漏 — 这是 C02 §2.3 addendum 的"位置盲区"（之前只禁了 icon 文字，漏了 title / subtitle / button / status / ghost link 全部位置）

### C18 marketing landing / PH / blog — ✅ PASS（6/6 已审）

| 资产 | 12 项检查表 | VERDICT |
|------|-------------|---------|
| `landing-hero-product__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS |
| `landing-hero-typography__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS |
| `landing-hero-quote__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS |
| `product-hunt-cover__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS |
| `blog-header-launch__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS |
| `blog-header-engineering__260824.png` | 12 P / 0 Pa / 0 F | ✅ PASS（32 行真实 Swift AVAudioEngine 代码 + 紫青语法高亮）|

**C18 是 5 批里唯一全 6/6 PASS 的批次**。6 张图都直接复用 C07 02 GRADIENT Y icon（紫青渐变），与 C11 twitter 风格 1:1 一致。

### C19 marketing social / email / deck — ❌ FAIL（6/6 已审）

| 资产 | 12 项检查表 | 新发现 | VERDICT |
|------|-------------|--------|---------|
| `twitter-banner-3-1__260824.jpg` + `.png` | 11 P / 0 Pa / 0 F | 直接复用 C11 PASS 资产 | ✅ PASS（但 jpg/png 重复需清理）|
| `twitter-profile-1-1__260824.jpg` + `.png` | 10 P / 1 Obs / 0 F | 极简（2 圈装饰性同心圆 + Y），非 chat icon | ✅ PASS（同上 hygiene）|
| `email-hero-welcome__260824.png` | 12 P / 0 Pa / 0 F | 干净："欢迎来到映话" + Y icon + 紫青极光 | ✅ PASS |
| `email-hero-launch__260824.png` | 10 P / 2 Pa / **1 F** | 副标 "**映话 in Noto Serif SC 80pt Bold**" + "**Yinghua in SF Pro Display 28pt Medium**" 字体规格烧进 UI | ❌ FAIL |
| `email-hero-product-update__260824.png` | 11 P / 1 Pa / 0 F | 5 feature cards 中 "**AI 总结**" 作为 feature label 文字（borderline，建议改"AI 摘要"）| ⚠️ PARTIAL |
| `deck-cover__260824.png` | 11 P / 0 Pa / **1 F** | 3 个 stat cards 用 literal "**X**" 字母作为 data placeholder（users / min saved weekly / NPS 三个数据全是 X）| ❌ FAIL |

**C19 亮点**：twitter + email-welcome 风格与 C18 一致，pass 资产复用成功
**C19 痛点**：email-launch 字体规格烧图（与 C17 03 byok 同根因）+ deck-cover "X" placeholder（addendum 漏位置的失败模式）

---

## 2. C02 §2.3 addendum 综合提案（5 条 P0 cross-batch 必修）

把 5 份 verdict 里的 5 个 addendum 提案合并，按严重度排序：

### ADDENDUM 9 — **CRITICAL P0**（C17 03 byok + C19 email-launch 同根因）

```
Do NOT include any font-size spec (e.g. "~14pt", "600 15pt", "14pt regular",
"10pt", "12pt 500", "50% OPACITY") as visible text in ANY UI position.
This includes but is not limited to:
  - Main titles / subtitles
  - Button labels (primary, secondary, ghost)
  - Status text / loading indicators
  - Provider card labels
  - Form field placeholders
  - Ghost link suffixes
  - Icon labels
The font-size spec is a DESIGN PROMPT, not user-facing text. Render the
design with the correct font sizes (the model "knows" what 14pt looks like
visually), but DO NOT output the spec string as part of the image.
If the model is confused about what text to render in a UI position, default
to the appropriate content (e.g. button text = "Save" / "Continue" / "Submit",
NOT "14pt 600 Save").
```

**影响**：2 批（C17 / C19）有 14 处泄漏，修 1 个 prompt 改动即可。

### ADDENDUM 6 — P0（C15 3 张日历 day name "ONLY" / "麦月"）

```
Calendar day name MUST be one of these EXACT 7 strings:
  - MON, TUE, WED, THU, FRI, SAT, SUN
Rendered in SF Pro Text 13pt Regular, all caps, color #1B1D22 (light mode)
or #F4F1EC (dark mode), in the top bar of the calendar app icon.
DO NOT render any other characters (English words, Chinese fragments,
Cyrillic, random ASCII) in the day name position. If the model is unsure,
default to "MON".
```

**影响**：4 批（C06 / C09 / C15 / C16 早期）都有这个家族问题。

### ADDENDUM 7 — P0（C16 02 empty "65%" ×4）

```
Do NOT render any percentage text (e.g. "65%", "85%", "100%") as a visual
label, badge, or overlay on any tile, card, button, or icon unless that
percentage has explicit semantic meaning (e.g. speaker talking time 62% / 38%,
progress bar completion 80%, download progress 45%).
Specifically forbidden: opacity / font-size / color-stop percentages
rendered as standalone labels.
```

**影响**：C08 / C16 两批有，区别是"@ 65% opacity overlay" vs "65%" 简化。

### ADDENDUM 8 — P0（C16 03/04 菜单栏 "e1n" 红色乱码）

```
The macOS menu bar right-side status area must contain ONLY these standard
system icons (battery, Wi-Fi, Bluetooth, Spotlight search, Control Center,
Time Machine, Notifications, Time display). DO NOT render any random text
characters, English words, or fragments in the menu bar status area. If
the model is unsure, render the empty status area (icons + time only).
```

**影响**：C16 03/04 两张，1 个新位置。

### ADDENDUM 10 — P0（C19 deck-cover "X" placeholder）

```
Do NOT render literal single letters (X, Y, Z, N, T, N/A, ??, !!) as data
placeholders in any chart, stat card, metric tile, or data visualization.
If a number is unknown or pending, use one of:
  - An ellipsis: "…"
  - A realistic placeholder number: "10K users" / "120 min" / "72 NPS"
  - A "TBD" label with neutral background (not letter X)
Specifically forbidden: writing a literal "X" character to represent
missing data — the X reads as a real character to viewers and breaks
trust in the design.
```

**影响**：C19 deck-cover 1 张，1 个新失败模式。

---

## 3. Hygiene 整理清单

| 资产 | 问题 | 行动 |
|------|------|------|
| `C15_dark-shippable/` 早期 v1/v2/v3 三版本 | 已自动清理（只留 v3 在 `design/01-meeting/`）| ✅ 无需行动 |
| `C19_marketing-social/twitter-banner-3-1__260824.jpg` + `.png` | 同图双格式 | **删 png，保留 jpg**（6.9 MB vs 18.4 MB）|
| `C19_marketing-social/twitter-profile-1-1__260824.jpg` + `.png` | 同图双格式 | **删 png，保留 jpg**（566 KB vs 5.1 MB）|
| `C18_marketing-landing/README.md` | producer 自检清单 | ✅ 保留作为 producer 文档 |
| `C1*/0X-*/_prompt.txt` + `_args.json` + `_gen-log.md` | producer 工程元数据 | ✅ 保留作为 audit trail |

---

## 4. 总 shippable 盘点（22 / 25 实际到位）

| 状态 | 数量 | 资产清单 |
|------|------|----------|
| **可上 (PASS)** | **12** | C16 01 meeting / C17 01 welcome / C17 02 permission / C18 6 张 / C19 twitter 3:1 / C19 profile 1:1 / C19 email-welcome |
| **可上 (PARTIAL borderline)** | **1** | C19 email-product-update（"AI 总结" feature label 边界，Figma 可改文案不改图）|
| **不可上 (FAIL — 需重做)** | **9** | C15 01/02/03（日历 day name）/ C16 02（"65%" ×4）/ C16 03/04（菜单栏 "e1n"）/ C17 03 byok（12 处字体规格）/ C19 email-launch（字体规格）/ C19 deck-cover（"X" placeholder）|
| **缺失 (未出图)** | **3** | C15 04 review / C15 05 onboarding / C16 05 onboarding |

---

## 5. P0 行动项（按优先级）

### 必修（5 批 × P0 修图，~14 项）

1. **C02 §2.3 addendum 9**（字体规格禁 visible UI 文字）— critical，修这一条可同时修 C17 03 byok + C19 email-launch 两批
2. **C02 §2.3 addendum 6**（日历 day name 白名单）— 必修，修这一条可同时修 C15 3 张图
3. **C02 §2.3 addendum 7**（禁百分比 label）— 必修，修这一条可修 C16 02 empty
4. **C02 §2.3 addendum 8**（菜单栏右侧只允许标准图标）— 必修，修这一条可修 C16 03/04 两张图
5. **C02 §2.3 addendum 10**（禁 literal X/Y/Z 作 placeholder）— 必修，修这一条可修 C19 deck-cover
6. **补图 3 张**：C15 04 review / C15 05 onboarding / C16 05 onboarding
7. **清理 jpg/png 重复**：C19 twitter × 2

### 建议（P1 优化）

8. C17 02 permission Dock 去掉 Trash（与 C05 ref-02 一致）
9. C16 02 empty Dock 去掉 Trash
10. C19 email-product-update "AI 总结" 改 "AI 摘要" 减少 marketing 敏感
11. C18 marketing 浅景深（D1 §1.4 写明但 6 张都没体现 — 仅作观察）
12. C19 profile 1:1 的 `_prompt.txt` 加标注 "concentric circles = decorative, not chat icon"（防下游误读）

---

## 6. 跨批对比 / 学习

### C18 vs C19 风格一致性

| 维度 | C18 | C19 |
|------|-----|-----|
| 6/6 shippable? | ✅ 6/6 PASS | ❌ 3 PASS / 1 PARTIAL / 2 FAIL |
| 02 GRADIENT Y icon | ✅ 6/6 用 | ✅ 6/6 用 |
| prompt 风格 | **具体字样**（"映话" / "Yīnghuà" / Noto Serif SC）— 给出后模型不混 | **占位符风格**（"映话 in Noto Serif SC 80pt Bold" / "What's new in 映话"）— 给出"in XXX 80pt Bold"占位符后模型把规格烧进图 |
| pass 资产复用 | ✅ 复用 C07 02 GRADIENT | ✅ 复用 C11 twitter（2 张）+ ✅ 复用 C18 模式（3 张 email）|
| 主要失败模式 | 0 | 字体规格烧图（email-launch）+ X placeholder（deck）|

**关键学习**：marketing 场景下，**prompt 用具体字样 vs 占位符风格决定了输出是否含字体规格**。C18 模式可作为 cross-batch reference。

### C15 vs C16 风格一致性

| 维度 | C15 (dark) | C16 (light) |
|------|------------|-------------|
| 已审计 | 3/5 | 4/5 |
| 主要失败模式 | 日历 day name 乱码 | 菜单栏乱码 + tile 65% 泄漏 |
| 失败变体 | English word "ONLY" + Chinese fragment "麦月" | English letters "e1n" + percentage "65%" |
| 共同根因 | producer 不确定 macOS 系统 UI 元素的具体内容 | 同上 |

**关键学习**：C15 + C16 都在**"producer 不确定 macOS 系统 UI 内容"** 上反复失败，但**位置不同**（calendar vs menu bar vs tile overlay）— 这说明 addendum 不能只列"禁 X"，还要列"必填白名单"。

---

## 7. 给 owner 的最终结论

### 现状（02:00 EDT 快照）

- **22 / 25 张图到位**（88%）
- **12 张 shippable-as-is PASS**（48%）
- **1 张 shippable PARTIAL borderline**（4%）
- **9 张 FAIL**（36%）— 集中在 3 个失败模式家族：日历 day name / 菜单栏 / 字体规格
- **3 张缺失**（12%）— 集中在 C15 / C16 最后一屏（onboarding / review）

### Shippable 比例

- **By batch**：C18 6/6 > C19 3/6 > C17 2/3 > C16 1/4 > C15 0/3
- **By category**：marketing (C18 + C19 部分) > onboarding > product (C15 + C16)
- **核心 insight**：**marketing 场景的 prompt 规则执行最好**（C18 6/6 PASS），**product 场景的 macOS 系统 UI 元素规则执行最差**（C15 / C16 5/8 FAIL）

### 推荐 ship 顺序

1. **现在可 ship**：12 PASS + 1 PARTIAL = **13 张**（C16 01 + C17 01/02 + C18 6 + C19 twitter 2 + C19 email-welcome + C19 email-product-update）
2. **修复后 ship**：9 FAIL + 3 缺失 = **12 张**（需 producer 跑一轮修复 + 补图）
3. **不建议 ship 顺序**：先 marketing（C18 优先）→ 再 onboarding（C17 01/02）→ 最后 product（C15 / C16 修复后）

### 最大风险

**C02 §2.3 addendum 漏位置的 3 个新失败模式**（菜单栏 / font spec suffix / X placeholder）— 现有 addendum 6 个反例（"STYLE 1" / "~14pt regular" / "600 15pt" / "AI" / "node" / "TEST"）是按"已知 token"列的，但 producer 失败模式在**位置演化**（从 icon 文字 → 标题 suffix → 菜单栏右侧 → stat card placeholder）。**建议 owner 把 5 条 addendum 提案（§2）合并入 C02 §2.3 作为 v2.0**，并要求 producer 在所有未来 prompt 中强制引用 addendum v2.0。

### verifier 自身限制

- 我是 verifier，**不修改任何项目文件**（不重生图、不改 prompt、不改 source 图）— 本报告只描述 finding，不返回去让 producer 改
- 5 份 verdict + 1 份综合 report 是 6 个新文件 — 写入 `design/_exploration/C1X-*/_audit-verdict.md` 和 `design/_exploration/_final-audit-report-c15-c19.md`
- 审计快照时间为 **2026-08-23 02:00 EDT**；02:00 后 producer 仍有 race condition（C15 04/05 可能在写），但**我锁定快照不再更新 verdict**（避免与 producer 永远赛跑）

### 文件交付清单

```
design/_exploration/
├── C15_dark-shippable/_audit-verdict.md            (9.7K, 02:00 EDT)
├── C16_light-shippable/_audit-verdict.md           (11.8K, 02:00 EDT)
├── C17_onboarding-shippable/_audit-verdict.md      (12.2K, 02:00 EDT)
├── C18_marketing-landing/_audit-verdict.md         (11.0K, 02:00 EDT)
├── C19_marketing-social/_audit-verdict.md          (13.9K, 02:00 EDT)
└── _final-audit-report-c15-c19.md                  (本文件)
```

5 份 verdict 文件包含完整的 12 项 × N 张 检查表 + 专属项 + V1 已知问题 + addendum 提案 + 给 owner 回 report。本综合 report 是 5 份的合并 + cross-batch 横向对比 + 总体 shippable 盘点。
