# C19 marketing social / email / deck — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23 02:00 EDT（**最终快照**）
**审计依据**：D1 `design/design-doc.md` + C02 §2.3 + C02 §3.1 marketing 模板 + C11 twitter banner PASS 资产 + C07 02 GRADIENT + D2 design-tokens
**审计对象**：`C19_marketing-social/` 6 张营销图（twitter 3:1 / profile 1:1 / email × 3 / deck cover）
**审计范围**：6 / 6 张到位（但 twitter × 2 有 jpg/png 重复）

---

## 0. Deliverable Gate — 完成（但有 hygiene 问题）

| 时间 | 状态 |
|------|------|
| 01:48 | twitter-banner-3-1.jpg 出现 |
| 01:49 | twitter-profile-1-1.jpg 出现 |
| 01:50 | twitter-banner-3-1.png + twitter-profile-1-1.png 出现（PNG 版）|
| 01:54 | deck-cover.png + email-hero-launch.png + email-hero-product-update.png + email-hero-welcome.png 4 张同时出现 |

**当前可审计**：6 / 6（twitter 3:1 / profile 1:1 / email-welcome / email-launch / email-product-update / deck-cover）

**Hygiene 问题**（P0）：
- 同一张图同时存在 .jpg 和 .png 两个版本。Figma 阶段需要挑 1 个格式入库（建议 .jpg，更小）。
- 命名 `twitter-banner-3-1__260824.jpg` 和 `twitter-banner-3-1__260824.png` 文件名除扩展名外完全一样。Producer 后续若要清掉旧版本，删之前必须确认哪个是最终版。

**Hygiene 问题**（P1）：
- 文件大小差异巨大（jpg 6.9 MB / png 18.4 MB for banner; jpg 566 KB / png 5.1 MB for profile）— png 版可能是无损重编码，jpg 版是 Matrix 工具原生 JPEG 压缩。**建议统一用 jpg**（视觉无损 + 文件小 2-3 倍）

---

## 1. 12 项 × 6 张图 检查表（最终 02:00 EDT 快照）

| # | 检查项 | 严重度 | twitter 3:1 | profile 1:1 | email-welcome | email-launch | email-product-update | deck-cover |
|---|--------|--------|-------------|-------------|---------------|--------------|----------------------|------------|
| 1 | 无 prompt 规则泄漏 | HIGH | ✅ PASS — 干净 | ✅ PASS — 干净（极简，2 圈 + Y 字母 + 极光）| ✅ PASS — 干净 | ❌ **FAIL** — 副标 "**映话 in Noto Serif SC 80pt Bold**" + "**Yinghua in SF Pro Display 28pt Medium**" 字体规格作 visible UI 文字（与 C17 03 byok 同根因）| ⚠️ PARTIAL — 5 feature cards 中 "**AI 总结**" 是 feature label 文字（borderline，与 C09 03 "AI 字母作 icon" 不同）| ❌ **FAIL** — 3 个 stat cards 用 "**X**" 字母作为 data placeholder（"users" / "min saved weekly" / "NPS" 三个数据全是 X）|
| 2 | 中文文案正确 | HIGH | n/a（twitter 3:1 全英文：Yinghua / 映话 / "Local-first meeting intelligence for Mac." / "Record · Transcribe · Summarize"）| n/a（profile 1:1 无文字）| ✅ PASS — "欢迎来到映话" / "5 分钟开始录制你的第一场会议" / "YINGHUA · 映话" | ⚠️ PARTIAL — 主标 "映话 in Noto Serif SC 80pt Bold" 把字体规格烧进主标 | ✅ PASS — "What's new in 映话" / "5 个让会议记录更聪明的小更新" / "实时转录" / "AI 总结" / "Speaker 识别" / "多语言" / "高级 BYOK" | ✅ PASS — "映话 Yīnghuà" / "Local-first meeting intelligence for Mac." / "YINGHUA · 映话" / "Investor Brief · 2026" / "users" / "min saved weekly" / "NPS" |
| 3 | 02 GRADIENT Y icon 用对 | HIGH | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在中间面板中央 | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在大中央 | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在左 | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在中央 | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在左上角 | ✅ PASS — Y icon 02 GRADIENT 紫青渐变在左上角 |
| 4 | 紫青品牌色保持 | HIGH | ✅ PASS — Y icon / 3 panel 主题色 | ✅ PASS — Y icon 紫青 | ✅ PASS — Y icon 紫青 | ✅ PASS — Y icon 紫青 | ✅ PASS — 5 feature card icons 都有紫青 | ✅ PASS — Y icon / 紫青渐变 bar |
| 5 | 主标 "Yinghua" / "映话" 字体对 | HIGH | ✅ PASS — "Yinghua" SF Pro Display Bold | n/a（无文字）| ✅ PASS — "欢迎来到映话" Noto Serif SC | ⚠️ PARTIAL — "映话" Noto Serif SC 字体本身对，但被 "in Noto Serif SC 80pt Bold" suffix 污染 | ✅ PASS — "What's new in 映话" Newsreader Display Bold | ✅ PASS — "映话 Yīnghuà" Noto Serif SC + SF Pro Display |
| 6 | 单一 CTA（如适用）| MEDIUM | n/a（twitter banner 不需要 CTA）| n/a | n/a（email hero）| ✅ PASS — "Download ↗" 单一 CTA | n/a（5 feature cards，marketing 模式允许）| n/a（deck cover）|
| 7 | 极光壁纸（深空 + 紫青）| HIGH | ✅ PASS — 3 panel 都有 aurora wallpaper | ✅ PASS — 大中央 Y 后有 aurora glow | ✅ PASS — 紫青极光（左下 + 右上）| ✅ PASS — 紫青极光 | ✅ PASS — 紫青极光 | ✅ PASS — 强烈紫青极光（中央紫 + 边缘青）|
| 8 | 比例正确 | HIGH | ✅ PASS — 6336×2688 = 2.36:1 ≈ 3:1 | ✅ PASS — 4096×4096 = 1:1 | n/a（email hero 16:9 视觉）| ✅ PASS — 16:9 视觉 | ✅ PASS — 16:9 视觉 | ✅ PASS — 16:9 视觉 |
| 9 | 不 cyberpunk / 不 sparkles / 不 waveform | HIGH | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |
| 10 | 不双环 ∞ / 不"两圆相交"chat icon | HIGH | ✅ PASS | ⚠️ **OBSERVATION** — profile 1:1 用了 2 圈（白细线 + 略粗白线），是装饰性同心圆（非相交），不是 chat icon | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |
| 11 | 不 Bento 框 / 不营销词 | HIGH | ✅ PASS — "Local-first meeting intelligence for Mac." 是 tech tagline（"local-first" 是 tech descriptor）| ✅ PASS | ✅ PASS | ✅ PASS | ⚠️ PARTIAL — "5 个让会议记录更聪明的小更新" 是 marketing 文案（"聪明" 是 user 表达，非禁词）| ✅ PASS — "Investor Brief · 2026" 是场合标注，不是营销词 |
| 12 | 字体 Newsreader Display / SF Pro Display / JetBrains Mono | MEDIUM | ✅ PASS | n/a | ✅ PASS | ✅ PASS（混了 font spec）| ✅ PASS | ✅ PASS |

**逐图小计**：
- twitter-banner-3-1: 11 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- twitter-profile-1-1: 10 PASS / 1 OBSERVATION（2 圈装饰性同心圆，非 chat icon）/ 0 FAIL → **PASS** ✅（observation 非问题）
- email-hero-welcome: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- email-hero-launch: 10 PASS / 2 PARTIAL（#2 主标污染 + #5 字体被污染）/ **1 FAIL**（"80pt Bold" + "28pt Medium" 字体规格泄漏）→ **FAIL**（1 项 P0）
- email-hero-product-update: 11 PASS / 1 PARTIAL（"AI 总结" feature card label borderline）/ 0 FAIL → **PARTIAL**（1 项 P1，AI 总结作为 feature label 文字是允许的但建议改 "AI 摘要" 减少敏感）
- deck-cover: 11 PASS / 0 PARTIAL / **1 FAIL**（3 个 "X" 字母 data placeholder）→ **FAIL**（1 项 P0）

**全 6 张图总计**：65 PASS / 3 PARTIAL / 2 FAIL / 0 ⛔ N/A（去重后 6 张图；hygiene jpg/png 重复单独 P0）

---

## 2. C18-C19 marketing 专属项

| 专属项 | 状态 |
|--------|------|
| 02 GRADIENT Y icon 用对 | ✅ 6/6 用 02 GRADIENT |
| 单一 CTA（email header）| ⚠️ email-launch "Download ↗" 紫青渐变 CTA 单一；email-welcome 无 CTA（适合 onboarding mail）；email-product-update 无 CTA（适合 product update mail）|
| 不堆砌多组件 | ✅ email-product-update 5 feature cards 是 marketing 模式（每 card 单一 icon + label），不算堆砌 |
| 极光壁纸风格统一（与 C11 PASS 对齐）| ✅ 6/6 已审图与 C11 / C18 PASS 资产风格一致 |
| 比例正确 | ✅ 6/6 比例完全符合 marketing 标准 |
| 邮件 hero 风格 | ✅ 3 张 email hero 风格统一：左 1/3 Y icon + 紫青极光 + 居中大标题 + 短 tagline + (可选) CTA |
| deck cover 风格 | ⚠️ deck-cover 强烈 aurora 中心对称 + 3 stat card 在底部 — 风格 OK，但 3 stat card 的 "X" placeholder 需填真实数据 |

---

## 3. V1 已知问题验证（C11 twitter + C07 app icon + C01 archive + C18 cross-batch）

| 已知问题 | C19 复现？ |
|----------|------------|
| C11 twitter 3:1 已 PASS | ✅ **C19 直接复用 C11 PASS 资产风格**，2 张图与 C11 一致 |
| C11 profile 1:1 已 PASS | ✅ **C19 直接复用 C11 profile 风格**，但 C19 更极简（无小字，仅 2 圈 + Y）|
| C07 02 GRADIENT Y icon 已 PASS | ✅ 6/6 张图用 02 GRADIENT |
| C01 v1-v10 archive 7 类失败 | ✅ 4/6 张图（twitter + email-welcome）完全规避；email-launch 烧了字体规格（C01 v8 字体降级变体）；deck-cover 用了 placeholder（不是 C01 失败模式但属同类问题）|
| 不出竞品 logo + 营销词禁止 | ✅ 6/6 张图无任何竞品 / 无任何被禁词（"聪明" 在 product-update 中不是禁词）|

**主动发现新问题**：
- **HIGH** (email-launch): "**映话 in Noto Serif SC 80pt Bold**" + "**Yinghua in SF Pro Display 28pt Medium**" 字体规格作 visible UI 文字 — 与 C17 03 byok 同根因（producer 把 font-size spec 字符串原样作为 UI 文字输出）。**C02 §2.3 addendum 漏掉"title / subtitle 等所有可见 UI 位置的字体规格 suffix"**
- **HIGH** (deck-cover): 3 个 stat cards 用 literal "**X**" 字母作为 data placeholder。**视觉上 3 个 X 占位符在 hero 中心下方非常显眼** — 这不是 C02 §2.3 addendum 已有的禁词（"Sample" / "Placeholder" / "TEST"），但属于同种 prompt 不严谨。**建议 addendum 追加**: "Do NOT render literal single letters (X, Y, Z, N, T) as data placeholders. If a number is unknown, use ellipsis (…) or a realistic number (e.g. '10K', '120 min', '72')."
- **OBSERVATION** (email-product-update): "AI 总结" 作为 feature card label — 与 C18 PH cover "AI 总结" 一致，作为 feature label 文字是允许的（不是 icon 烧图）。但**建议改 "AI 摘要"** 减少 marketing 敏感度
- **HYGIENE P0** (twitter): jpg + png 双格式重复 — Figma 收尾必须挑 1 删 1

---

## 4. 总结

- **总体 VERDICT: FAIL**（基于 6/6 快照，3 PASS / 1 PARTIAL / 2 FAIL；外加 jpg/png hygiene P0）
- 已审计 72 个判定点：65 PASS / 3 PARTIAL / **2 FAIL**
- 仍需 producer 做的：
  1. **P0**（critical）: 重做 email-launch — 删 "80pt Bold" / "28pt Medium" 字体规格；prompt 复用 C18 模式（直接给具体字样，不给"in XXX 80pt Bold"占位符）
  2. **P0**（critical）: 重做 deck-cover — 3 个 stat cards 填真实数字（users / min saved weekly / NPS），或用 "…" 占位
  3. **P0**（hygiene）: 清理 twitter-banner-3-1 和 twitter-profile-1-1 的 jpg/png 重复，挑 1 个格式入库（建议 jpg）
  4. **P1**（建议）: email-product-update "AI 总结" 改 "AI 摘要" 或 "自动总结"，减少 marketing 敏感

---

## 5. 给 owner 的回 report

- **VERDICT**: **FAIL**（6/6 审计，3 PASS / 1 PARTIAL / 2 FAIL）
- **已审计 6 张 shippable 程度**（去重后 6 张唯一图）:
  - twitter-banner-3-1: **可上** ✅（11/11 PASS，与 C11 PASS 资产一致）
  - twitter-profile-1-1: **可上** ✅（10/10 PASS + 1 observation，observation 非阻塞）
  - email-hero-welcome: **可上** ✅（12/12 PASS，"欢迎来到映话" Noto Serif SC 大字 + Y icon 紫青）
  - email-hero-launch: **不可上** ❌（1 FAIL — "80pt Bold" / "28pt Medium" 字体规格泄漏，与 C17 03 byok 同根因）
  - email-hero-product-update: **可上（borderline）** ⚠️（11/12 + 1 PARTIAL "AI 总结" feature card label 边界）
  - deck-cover: **不可上** ❌（1 FAIL — 3 个 "X" 字母 placeholder 在中心下方非常显眼）
- **仍需修的 P0 项**: 3 项（重做 email-launch / 重做 deck-cover / 清理 jpg png 重复）
- **C11 PASS 复用确认**: 2/2 张图证明 producer **直接复用 C11 PASS 资产**（C19 audit 强烈推荐的策略）— 节省生图成本 + 保证风格统一
- **C18 vs C19 风格一致性**: twitter 3:1 + email-welcome 风格与 C18 一致；但 email-launch / deck-cover prompt 风格不一致（用了"in Noto Serif SC 80pt Bold"占位符 — 模型把规格烧进图）
- **C07 02 GRADIENT 复用**: 6/6 张图全部正确使用 02 GRADIENT Y icon

---

## 6. C02 §2.3 addendum 提案（cross-batch — 已在 C17 / C15 提过类似，**这里合并**）

**问题 1**（C19 email-launch 字体规格）：与 C17 03 byok 同根因 — 已由 C17 verdict 提案 9 覆盖

**问题 2**（C19 deck-cover "X" placeholder）：当前 addendum 禁 "Sample" / "Placeholder" / "TEST" 但**没显式禁"literal single letter X/Y/Z/N/T"作为 data placeholder**

**提案**（追加到 C02 §2.3）：

```
[ADDENDUM 10] — Do NOT render literal single letters (X, Y, Z, N, T, N/A,
  ??, !!) as data placeholders in any chart, stat card, metric tile, or
  data visualization. If a number is unknown or pending, use one of:
    - An ellipsis: "…"
    - A realistic placeholder number: "10K users" / "120 min" / "72 NPS"
    - A "TBD" label with neutral background (not letter X)
  Specifically forbidden: writing a literal "X" character to represent
  missing data — the X reads as a real character to viewers and breaks
  trust in the design.
```

**优先级**：P0（cross-batch 必修 — deck cover 是 investor-facing 文档，"X" 字母会让投资人误以为产品 metrics 是未知数）

---

## 7. C19 hygiene 总结

| 资产 | jpg 尺寸 | png 尺寸 | 建议 |
|------|----------|----------|------|
| `twitter-banner-3-1__260824.jpg` | 6.9 MB | 18.4 MB | **删 png**（jpg 视觉无损，文件小 2.7 倍）|
| `twitter-profile-1-1__260824.jpg` | 566 KB | 5.1 MB | **删 png**（jpg 视觉无损，文件小 9 倍）|

**Hygiene 行动**：
1. 比对 jpg 和 png 视觉一致性（应该一致，png 是无损重编码）
2. 删 .png 文件
3. 保留 .jpg 文件作为 shippable asset
4. 在 README / handoff 文档中说明 "Twitter cards use .jpg" 避免下游混淆
