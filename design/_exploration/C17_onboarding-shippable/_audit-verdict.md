# C17 onboarding shippable — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23 02:00 EDT（**最终快照**）
**审计依据**：D1 `design/design-doc.md` + C02 §2.3 + C02 §2.4 + C09 onboarding 3 屏基准 + D2 design-tokens
**审计对象**：`C17_onboarding-shippable/` 3 张 onboarding 屏 shippable
**审计范围**：3 / 3 张到位 ✅

---

## 0. Deliverable Gate — 完成

| 时间 | 状态 |
|------|------|
| 01:44 | 3 个子目录创建 |
| 01:50 | 01-welcome.png 出现 |
| 01:54 | 02-permission.png 出现 |
| 01:57 | 03-byok.png 出现 |

**当前可审计**：3 / 3 ✅

---

## 1. 12 项 × 3 张图 检查表（最终 02:00 EDT 快照）

| # | 检查项 | 严重度 | 01 welcome | 02 permission | 03 byok |
|---|--------|--------|------------|---------------|---------|
| 1 | 无 prompt 规则泄漏（`STYLE 1` / `~14pt regular` / `600 15pt` / `AI` 字母 / `node` / `TEST`）| HIGH | ✅ PASS — 干净 | ✅ PASS — 干净 | ❌ **CATASTROPHIC FAIL** — **12 处** `~XXpt` / `XXpt XXX` 字体规格作为可见 UI 副标 / button label / ghost link suffix 出现！详见 §2 |
| 2 | 中文文案正确 | HIGH | ✅ PASS — "映话"/"为面试而生的 macOS 智能助手"/"系统级录音 + 麦克风，全程本地"/"实时转录，自动分说话人"/"AI 总结、决定、待办"/"开始使用 ↗"/"已有账号" 全是真实中文 | ✅ PASS — "授权访问"/"映话需要以下 macOS 权限才能录制和转录你的会议"/"麦克风"/"录制系统音频 + 麦克风"/"屏幕录制"/"捕获应用和会议的系统音频"/"通知"/"会后温和提醒"/"继续"/"稍后再说" 全是真实 | ✅ PASS — "你的 key 只存本地 macOS Keychain, 我们看不到"/"选一个 provider, 填 key, 我们用它总结你的会议"/"API KEY"/"测试连接"/"完成设置"/"我稍后再做" 全是真实（除了 ~XXpt 字体规格）|
| 3 | 品牌 mark 正确（Y icon 02 GRADIENT）| HIGH | ✅ PASS — Y icon 02 GRADIENT 紫→青渐变在主窗口顶部居中 | ✅ PASS — 主窗口用 Y icon + "映话" 标题 | ✅ PASS — 主窗口用 Y icon + "映话" 标题 |
| 4 | 紫青品牌色保持 | HIGH | ✅ PASS — "开始使用" CTA 紫青渐变 / Y icon | ✅ PASS — "继续" CTA 紫青渐变 | ✅ PASS — "完成设置" CTA 紫青渐变（虽然混了 "50% OPACITY" 文字）|
| 5 | Dock 12 项统一 | HIGH | ✅ PASS — 11 系统 + Y（无分隔点）| ⚠️ PARTIAL — 11 系统 + Y + **Trash 末位**（多 1 Trash）| ✅ PASS — 11 系统 + Y（无分隔点，无 Trash）|
| 6 | 菜单栏含 app 名 | MEDIUM | ✅ PASS — "Yinghua" 在 Apple logo 右侧 | ✅ PASS — "Yinghua" | ✅ PASS — "Yinghua" |
| 7 | 时钟统一 | LOW | ✅ PASS — 21:42 | ✅ PASS — 21:42 | ✅ PASS — 21:42 |
| 8 | 日历 `26` + 正确 day name | LOW | ✅ PASS — "MON 26" 双显 | ✅ PASS — "TUE 26" 双显 | ✅ PASS — "WED 26" 双显 |
| 9 | 不 cyberpunk / 不 sparkles / 不 waveform | HIGH | ✅ PASS | ✅ PASS | ✅ PASS |
| 10 | 不双环 ∞ / 不"两圆相交"chat icon | HIGH | ✅ PASS — 无 chat icon；Y icon 是抽象字母 mark | ✅ PASS | ✅ PASS — provider card 是抽象几何 mark（OpenAI 花 / Anthropic 钻石 / Custom 六边形），不是 "AI" 字母 / "node" 文字 |
| 11 | 不 Bento 框 / 不营销词 | HIGH | ✅ PASS — 单一 onboarding 窗口 | ✅ PASS | ✅ PASS |
| 12 | 字体 Noto Serif SC / SF Pro Display / SF Pro Text / JetBrains Mono | MEDIUM | ✅ PASS | ✅ PASS | ⚠️ PARTIAL — 主体字体正确（"自带 API key" 是 Noto Serif SC 风格），但所有副标 / button / status 都混了 `~XXpt` 字体规格，**这是字体规则的"自指悖论"** |

**逐图小计**：
- 01 welcome: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- 02 permission: 11 PASS / 1 PARTIAL（Trash 在 Dock 末位）/ 0 FAIL → **PASS** ✅（PARTIAL 非阻塞）
- 03 byok: 9 PASS / 1 PARTIAL（字体"自指悖论"）/ **1 CATASTROPHIC FAIL**（12 处 `~XXpt` 字体规格泄漏 + "50% OPACITY" prompt term 可见）→ **FAIL**（P0 hard block）

**全 3 张图总计**：32 PASS / 2 PARTIAL / 1 FAIL（12 处泄漏算 1 个 FAIL bucket）/ 0 ⛔ N/A

---

## 2. 1.5 — C17 03 byok 字体规格泄漏清单（**CRITICAL**）

| # | 位置 | 泄漏内容 | 严重度 |
|---|------|----------|--------|
| 1 | 主标题 | "**自带 API key ~26pt**" | HIGH |
| 2 | 副标题 | "选一个 provider, 填 key, 我们用它总结你的会议 **~14pt**" | HIGH |
| 3 | OpenAI card | "**~13pt 600**" suffix + "GPT-4o, o1 **~10pt**" suffix | HIGH |
| 4 | Anthropic card (SELECTED) | "**~13pt 600**" suffix + "Claude Sonnet 4 **~10pt**" suffix | HIGH |
| 5 | Custom card | "**~13pt 600**" suffix + "Self-hosted **~10pt**" suffix | HIGH |
| 6 | 测试连接 button | "**~12pt 500**" suffix | HIGH |
| 7 | status 文字 | "Testing connection... **~13pt 500**" | HIGH |
| 8 | **CTA button** | "**50% OPACITY** 完成设置 **~14pt 600**" | **CATASTROPHIC**（连 "50% OPACITY" 这个 prompt term 都被烧到 UI！）|
| 9 | ghost link | "我稍后再做 **~12pt**" | HIGH |

**总计 9 行 / 12 处** `~XXpt` / `50% OPACITY` 字体规格作为可见 UI 文字泄漏。

**根因**：producer 把 prompt 里的 font-size spec 字符串（如 "~14pt 600"）原样作为 UI 文字输出。**C02 §2.3 addendum 写的是"禁 `~14pt regular` 字体规格作 icon 文字"** — 但 producer 这次是当作**主标题 / 副标题 / button label 的 suffix**（不是 icon 文字），**addendum 没覆盖这种位置**。

**C09 03 byok V1 baseline 对比**：C09 03 byok 也有问题但主要是 "AI" 字母 + "node" 文字 + 多余 card。**C17 03 byok 是新变体 — provider card 本身正确（OpenAI / Anthropic / Custom 抽象几何 mark），但全屏 12 处字体规格泄漏** — 这是一个 producer 在 C09 fix 时学到了 "禁 AI 字母" 但没学到 "禁字体规格 suffix"。

**判定**：C17 03 byok 是**单图最大失败案例**（12 处泄漏），但**功能完整、provider card 正确、3-dot 进度正确、calendar 正确** — producer 知道做什么，**只是 prompt 不知道"字体规格不能当 UI 文字 suffix 输出"**。**修起来 1 个 prompt 改动即可**（不是 12 处图都要重画）。

---

## 3. C15-C19 专属项

| 专属项 | 状态 |
|--------|------|
| 3 屏流视觉一致（C17 vs C09 配对）| ✅ PASS — 3 屏都是 aurora 暗色 + 14px 圆角窗口 + 3-dot 进度（dot 1/2/3 渐次 active）+ 紫青渐变 CTA |
| 3-dot 进度指示器（屏 1 dot 1 / 屏 2 dot 2 / 屏 3 dot 3 active）| ✅ PASS — 01 dot 1 active / 02 dot 2 active / 03 dot 3 active（全部正确）|
| Welcome 屏 hero / 庆祝视觉 / 单一 CTA | ✅ 01 完美：Y icon 居中 + "映话" 大字 + tagline + 3 bullet points + "开始使用" CTA + "已有账号" ghost link |
| Permission 屏 3 张卡片 + Granted/Pending/Optional pill | ✅ 02 完美：3 cards (麦克风/屏幕录制/通知) + 绿色 "已授权" pill（麦克风）+ 灰色 "待授权" pill（屏幕录制）+ 灰色 "可选" pill（通知）|
| BYOK 屏 provider cards（OpenAI / Anthropic / Custom 抽象几何）| ✅ 03 provider card icon 正确（OpenAI 花 / Anthropic 钻石 / Custom 六边形），**修复了 C09 03 "AI 字母 + node 文字"问题** — 但新引入 12 处 `~XXpt` 字体规格泄漏 |

---

## 4. V1 已知问题验证（C09 onboarding 3 屏基线 + C02 §2.3 6 个反例）

| 已知问题 | C17 复现？ |
|----------|------------|
| 02 permission 菜单栏缺 app 名 | ✅ 修复 — "Yinghua" 在 02 菜单栏右侧 |
| 02 permission Dock 第 5 位 Contacts 而非 Notes | ✅ 修复 — 第 5 位是 Notes（不在 02 子目录漏一个 — Notes 在第 5 个 slot，看图确实是 Notes，不是 Contacts）|
| 02/03 日历顶部 "NEN" / "MEM" 红色乱码 | ✅ 修复 — MON 26 / TUE 26 / WED 26 全部正确 |
| **03 byok Anthropic provider card 是黑色方块+白色 "AI" 字母**（HIGH FAIL）| ✅ 修复 — Anthropic card 用紫色 SELECTED 描边 + 抽象钻石几何 mark（不是 "AI" 字母）|
| 03 byok Custom provider card icon 是 "node" 小写文字 | ✅ 修复 — Custom card 用抽象六边形几何 mark（不是 "node" 文字）|
| 3-dot 进度指示器正确 | ✅ PASS |
| Primary 按钮紫青渐变 + 50% disabled 态 | ⚠️ 03 byok "完成设置" 按钮显示 "50% OPACITY" 文字 — **这是 prompt 规格泄漏，不是真正的 50% disabled 态**。C09 03 的 "50% disabled" 是半透明渲染，C17 03 是把 "50% OPACITY" 当成 CTA 文字 suffix 输出 |

**主动发现新问题**：
- **CATASTROPHIC** (C17 03): 12 处 `~XXpt` / `50% OPACITY` 字体规格泄漏（详见 §2 清单）— C02 §2.3 addendum 漏掉"主标题 / 副标题 / button / status / ghost link 等所有可见 UI 位置的字体规格 suffix"
- **LOW** (C17 02): Dock 末位多 Trash icon（与 C05 ref-02 不一致）— 但与 C16 02 同款，说明 producer 在 permission 屏沿用 empty state 模板

---

## 5. 总结

- **总体 VERDICT: PARTIAL**（基于 3/3 快照，2 PASS / 1 FAIL-by-catastrophic-leak）
- 已审计 36 个判定点：32 PASS / 2 PARTIAL / **1 FAIL bucket (12 处)**
- 仍需 producer 做的：
  1. **P0**（critical）: 重做 03 byok — 删 12 处 `~XXpt` / `50% OPACITY` 字体规格；prompt 显式加 "Do NOT include any font-size spec (e.g. '~14pt', '600 15pt', '14pt regular') as visible UI text in any title, subtitle, button label, status, or ghost link. The model is rendering the design spec AS the design."
  2. **P1**（建议）: 02 permission Dock 去掉 Trash（与 C05 ref-02 一致）

---

## 6. 给 owner 的回 report

- **VERDICT**: **PARTIAL**（3/3 审计，2 PASS / 1 FAIL by 12 处字体规格泄漏）
- **已审计 3 张 shippable 程度**:
  - 01 welcome: **可上** ✅（12/12 PASS，干净，Y icon 02 GRADIENT 紫青渐变 + 3 bullet points + 紫青渐变 CTA）
  - 02 permission: **可上** ✅（11/11 PASS + 1 PARTIAL Trash，3 卡片 + 3 pill 状态正确，dot 2 active 正确）
  - 03 byok: **不可上** ❌（1 CATASTROPHIC FAIL — 12 处 `~XXpt` / `50% OPACITY` 字体规格泄漏）
- **仍需修的 P0 项**: 1 项（重做 03 byok 即可，1 个 prompt 改动）
- **C09 V1 痛点验证**:
  - ✅ 02 permission 菜单栏 app 名：已修
  - ✅ 02 permission Dock 第 5 位：已修
  - ✅ 02/03 日历乱码：已修
  - ✅ 03 byok "AI" 字母：已修（Anthropic 抽象钻石 mark）
  - ✅ 03 byok "node" 文字：已修（Custom 抽象六边形 mark）
  - ❌ **新失败模式**：03 byok 字体规格泄漏（C02 §2.3 addendum 漏位置 — 之前禁的是 icon 文字，漏了 title / subtitle / button / status / ghost link 全部位置）
- **C17 已大幅进步**: 01 / 02 完美干净 + 03 主体功能正确 — 5 批里 onboarding 3 屏是功能完成度最高的一组（除了字体规格这个 prompt rule 问题）

---

## 7. C02 §2.3 addendum 提案（cross-batch — **最优先**）

**问题**：C02 §2.3 现行 addendum 写的是 "**禁字体规格作 icon 文字**"（specific to icons），但 producer 把字体规格烧到了**所有可见 UI 位置**（title / subtitle / button / status / ghost link）。

**提案**（追加到 C02 §2.3，**最强约束**）：

```
[ADDENDUM 9 — CRITICAL] — Do NOT include any font-size spec (e.g. "~14pt",
  "600 15pt", "14pt regular", "10pt", "12pt 500", "50% OPACITY") as visible
  text in ANY UI position. This includes but is not limited to:
    - Main titles / subtitles
    - Button labels (primary, secondary, ghost)
    - Status text / loading indicators
    - Provider card labels
    - Form field placeholders
    - Ghost link suffixes
    - Icon labels
  The font-size spec is a DESIGN PROMPT, not user-facing text. Render the
  design with the correct font sizes (the model "knows" what 14pt looks
  like visually), but DO NOT output the spec string as part of the image.
  If the model is confused about what text to render in a UI position,
  default to the appropriate content for that UI (e.g. button text =
  "Save" / "Continue" / "Submit", NOT "14pt 600 Save").
```

**优先级**：**P0 CRITICAL**（cross-batch 必修 — C17 03 + C19 email-launch 都有这个家族问题）
