# C15 dark shippable — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23 02:00 EDT（**最终快照**，02:00 后无新图到达）
**审计依据**：D1 `design/design-doc.md` + C02 §2.3 anti-leak + C02 §2.4 Dock 锁定 + C06 v3 dark 基准 + D2 design-tokens
**审计对象**：`C15_dark-shippable/design/` 5 张深色产品 shippable
**审计范围**：3 / 5 张到位（01 meeting / 02 empty / 03 transcript）｜04 review / 05 onboarding 子目录仍空

---

## 0. Deliverable Gate — 部分完成

| 时间 | 状态 |
|------|------|
| 01:44 | 5 个子目录创建，0 张图 |
| 01:53 | 01-meeting 出现 v1/v2/v3 三版本（v3 为最终） |
| 01:55 | 01-meeting 移动到 `design/01-meeting/product-meeting-in-progress__260824.jpg`（v1/v2 已清） |
| 01:56 | 02-empty 出现 → `design/02-empty/product-empty-state__260824.jpg` |
| 02:00 | 03-transcript 出现 → `design/03-transcript/product-transcript-focus__260824.jpg`；04-review / 05-onboarding 子目录仍空 |
| 02:00 | **快照锁定** |

**当前可审计**：3 / 5（01/02/03）
**未审计**：04 review / 05 onboarding — 2 张图 producer 在快照锁定时未到位

> **Hygiene 已改善**：v1/v2 多版本问题已清理（01-meeting 只剩 v3，移到 `design/` 子目录）

---

## 1. 12 项 × 5 张图 检查表（最终 02:00 EDT 快照）

| # | 检查项 | 严重度 | 01 meeting | 02 empty | 03 transcript | 04 review | 05 onboarding |
|---|--------|--------|------------|----------|---------------|-----------|----------------|
| 1 | 无 prompt 规则泄漏（`STYLE 1` / `~14pt regular` / `600 15pt` / `AI` 字母 / `node` / `TEST`）| HIGH | ✅ PASS — 干净 | ✅ PASS — 干净 | ✅ PASS — 干净 | ⛔ N/A | ⛔ N/A |
| 2 | 中文文案正确 | HIGH | ✅ PASS — "面试·前端终面"/"录制中 02:34"/speaker 对话全是真实词组 | ✅ PASS — "新建录制"/"导入音频"/"浏览器扩展"/"知识库"/"最近录音" 真实 | ✅ PASS — speaker 中英对话全部真实（自我介绍 / React 开发 / DOM 节点）| ⛔ N/A | ⛔ N/A |
| 3 | 品牌 mark 正确（Y icon 02 GRADIENT）| HIGH | ✅ PASS — Dock 末位 Y 紫→青渐变 | ✅ PASS — Dock 末位 Y 紫→青渐变 | ✅ PASS — Dock 末位 Y 紫→青渐变 | ⛔ N/A | ⛔ N/A |
| 4 | 紫青品牌色保持 | HIGH | ✅ PASS — 极光壁纸 / 头像渐变 / Y icon | ✅ PASS — tile 渐变 / Y icon / mic avatar 紫青 | ✅ PASS — 头像渐变 / Y icon | ⛔ N/A | ⛔ N/A |
| 5 | Dock 12 项统一（10-11 系统 + 分隔点 + Y）| HIGH | ✅ PASS — 11 系统 + Y（无分隔点），与 C05 ref-02 锁定一致 | ✅ PASS — 11 系统 + Y（无分隔点）| ✅ PASS — 11 系统 + Y | ⛔ N/A | ⛔ N/A |
| 6 | 菜单栏含 app 名 | MEDIUM | ✅ PASS — "Yinghua" 在 Apple logo 右侧 | ✅ PASS — "Yinghua" | ✅ PASS — "Yinghua" | ⛔ N/A | ⛔ N/A |
| 7 | 时钟统一 | LOW | ✅ PASS — 21:42 | ✅ PASS — 21:42 | ✅ PASS — 21:42 | ⛔ N/A | ⛔ N/A |
| 8 | 日历 `26` + 正确 day name | LOW | ❌ **FAIL** — 日历显示 "**ONLY 26**"（"ONLY" 是英文词非 day name）| ❌ **FAIL** — 日历显示 "**麦月 26**"（"麦月" 是中文碎片）| ❌ **FAIL** — 日历显示 "**ONLY 26**"（与 01 同根因）| ⛔ N/A | ⛔ N/A |
| 9 | 不 cyberpunk / 不 sparkles / 不 waveform | HIGH | ✅ PASS — 干净 macOS 极光 + 4 人 video grid（无 sparkles 装饰）| ✅ PASS — 干净 macOS 极光 + 4 tile 渐变 icon | ✅ PASS — 干净 macOS 极光 + transcript | ⛔ N/A | ⛔ N/A |
| 10 | 不双环 ∞ / 不"两圆相交"chat icon | HIGH | ✅ PASS — 无 chat icon | ✅ PASS — 无 chat icon | ✅ PASS — 无 chat icon | ⛔ N/A | ⛔ N/A |
| 11 | 不 Bento 框 / 不营销词 | HIGH | ✅ PASS — 单一产品窗口 | ✅ PASS — 单一产品窗口 | ✅ PASS — 单一产品窗口 | ⛔ N/A | ⛔ N/A |
| 12 | 字体 Noto Serif SC / SF Pro Display / SF Pro Text / JetBrains Mono | MEDIUM | ✅ PASS | ✅ PASS | ✅ PASS | ⛔ N/A | ⛔ N/A |

**逐图小计**：
- 01 meeting: 11 PASS / 0 PARTIAL / **1 FAIL** (日历 "ONLY 26") → **FAIL**（1 项 P0）
- 02 empty: 11 PASS / 0 PARTIAL / **1 FAIL** (日历 "麦月 26") → **FAIL**（1 项 P0）
- 03 transcript: 11 PASS / 0 PARTIAL / **1 FAIL** (日历 "ONLY 26") → **FAIL**（1 项 P0）
- 04 review: ⛔ N/A
- 05 onboarding: ⛔ N/A

**全 5 张图总计**：33 PASS / 0 PARTIAL / 3 FAIL / 24 ⛔ N/A

---

## 2. C15-C19 专属项

| 专属项 | 状态 |
|--------|------|
| 5 张图布局结构 1:1 对应 C06 v3 dark 基准 | ⚠️ PARTIAL — 已出的 3 张结构对得上 C06（4 人 meeting grid + 控制面板浮窗 + transcript 流），02 empty 与 C06 02 / C16 02 同款 quick action grid；04/05 还未审计 |
| 浅色 / 深色反转正确（C16 vs C15 配对）| ✅ PASS（基于 C16 已审 4 张）— C15 01 dark aurora + 4 video tiles；C16 01 light cream + 4 video tiles + transcript panel — 整体反转正确，**但 C15 01 没有 transcript panel 右侧栏**（C16 01 有 speaker list）— 推测是 C15 01 focus 在 video grid 而非 transcript |
| 3 屏流视觉一致（C17 vs C09 配对）| n/a（C15 是产品图非 onboarding，3 屏专属项不适用）|
| 录制控制面板（红点 + 时间码 + 3 控制按钮）| ✅ 01 meeting 浮层 "录制中 02:34" + ⏸/⏹/▶ + 设置/分享/✕ — 正确，**无 waveform** 装饰 |
| quick action tile × 4（新建 / 导入 / 扩展 / 知识库）| ✅ 02 empty 4 tile 干净，**未踩 C16 02 "65%" 坑**（C15 02 已避开该问题）|
| speaker 头像渐变（紫/青/粉/暖白 4 色）| ✅ 01 meeting 4 头像 + 03 transcript speaker 头像 全部用渐变占位（不写实）|

---

## 3. V1 已知问题验证（C06 audit 30+ 项 + C02 §2.3 addendum）

| C06 已知问题 | C15 复现？ |
|--------------|------------|
| 04 review "STYLE 1" 灰字泄漏 | ✅ 3/3 已审图无此问题 |
| 05 onboarding "Yinghua ~14pt regular" 副标题泄漏 | ⛔ UNVERIFIABLE（05 未出）|
| 05 onboarding "Get started 600 15pt ↗" CTA 字号泄漏 | ⛔ UNVERIFIABLE（05 未出）|
| 02/03 日历 "MIY" / "ПАН" 乱码 | ❌ **C15 3/3 复现同类问题** — 01 "ONLY" / 02 "麦月" / 03 "ONLY"。**变体更新**：之前 C06/C09 是 random ASCII / Cyrillic 字符串；C15 batch 模型输出 **English word** ("ONLY") 或 **Chinese fragments** ("麦月")。**C02 §2.3 addendum 提到"必须 26 + 禁 gibberish"但没显式禁"任何非 MON-TUE-WED-THU-FRI-SAT-SUN 的字符串"** — 建议在 addendum 追加显式白名单 |
| 02/03 缺菜单栏 app 名 | ✅ 3/3 修复 — Yinghua 在 Apple logo 右侧 |
| Dock 顺序 5 张不一致 | ⚠️ C15 已出的 3 张 Dock 顺序一致（Finder/Safari/compass/Messages/Mail/Notes/Calendar/Reminders/Maps/Music/Settings + Y），符合 C05 ref-02 |

**主动发现新问题**：
- **HIGH** (3/3 张): 日历顶部 day name 渲染错位（"ONLY" / "麦月"）— 与 C06 "MIY" / C09 "NEN" / "MEM" 同根因，但变体更新
- **OBSERVATION** (1/3 张): 02 empty 的 4 个 quick action tile 干净 — 证明 producer 能避开 C16 02 的 "65%" 坑。说明 C16 02 是 producer 偶发失误而非系统性错误
- **POSITIVE** (3/3 张): C15 完全无 prompt 规则文字泄漏（"STYLE 1" / "14pt" / "AI" 等），与 C08 light 早期 13 处泄漏形成鲜明对比 — prompt addendum 起了作用（至少对 dark batch）

---

## 4. 总结

- **总体 VERDICT: FAIL**（基于 3/5 快照，3 张全 FAIL 因日历 gibberish；2 张缺失）
- 已审计 36 个判定点：33 PASS / 0 PARTIAL / **3 FAIL**
- 未审计 24 个判定点（2 张图未到位）
- 仍需 producer 做的：
  1. **P0**：补全 04 review / 05 onboarding 2 张图
  2. **P0**（3 张全要修）：日历 day name 改为 ENGLISH 3-letter 白名单（MON / TUE / WED / THU / FRI / SAT / SUN），不要让模型随机生成
  3. **P1**（建议）：C02 §2.3 addendum 追加"日历 day name 白名单"显式约束

---

## 5. 给 owner 的回 report

- **VERDICT**: **FAIL**（3/5 审计，3 张全 FAIL 因日历 day name gibberish）
- **已审计 3 张 shippable 程度**:
  - 01 meeting: **不可上**（1 FAIL — 日历 "ONLY 26"，Figma 后期可裁日历但生产 prompt 必须修）
  - 02 empty: **不可上**（1 FAIL — 日历 "麦月 26"）
  - 03 transcript: **不可上**（1 FAIL — 日历 "ONLY 26"）
- **仍需修的 P0 项**: 2 项（补 2 张 + 修 3 张日历 day name）
- **C06 V1 痛点复现**: 1/1（日历 day name 乱码家族 — C06 "MIY" → C09 "NEN/MEM" → C15 "ONLY/麦月"，**变体在演化，根因未修**）
- **C15 进步点**: 无 prompt 文字泄漏（vs C08 13 处泄漏）— producer 在 addendum 强制下已学会禁 "STYLE 1" / "14pt" / "AI" / "node"，但**日历 day name 仍没强制白名单**

---

## 6. C02 §2.3 addendum 提案（cross-batch）

**问题**：当前 addendum 写的是 "Dock calendar must show the day name" + "禁 gibberish"，但 producer 仍输出 "ONLY" / "麦月" / "MIY" / "NEN" 等错误 day name。

**提案**（追加到 C02 §2.3）：

```
[ADDENDUM 6] — Calendar day name MUST be one of these EXACT 7 strings:
  - MON, TUE, WED, THU, FRI, SAT, SUN
  Rendered in SF Pro Text 13pt Regular, all caps, color #1B1D22 (light mode)
  or #F4F1EC (dark mode), in the top bar of the calendar app icon.
  DO NOT render any other characters (English words, Chinese fragments,
  Cyrillic, random ASCII) in the day name position. The day name is the
  SHORT 3-letter weekday abbreviation; if the model is unsure, default
  to "MON".
```

**优先级**：P0（cross-batch 必修 — 5 批里 4 批都有这个家族问题）
