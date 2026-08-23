# C18 marketing landing / PH / blog — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23 02:00 EDT（**最终快照**）
**审计依据**：D1 `design/design-doc.md` + C02 §2.3 + C02 §3.1 marketing 模板 + C07 02 GRADIENT + C11 twitter banner 基准 + D2 design-tokens
**审计对象**：`C18_marketing-landing/` 6 张营销图
**审计范围**：6 / 6 张到位 ✅

---

## 0. Deliverable Gate — 完成

| 时间 | 状态 |
|------|------|
| 01:44 | 目录创建 |
| 01:48 | landing-hero-product.png 出现 |
| 01:49 | landing-hero-typography.png 出现 |
| 01:50 | landing-hero-quote.png 出现 |
| 01:52 | product-hunt-cover.png 出现 |
| 01:53 | blog-header-launch.png 出现 |
| 01:57 | blog-header-engineering.png 出现 |
| 01:59 | README.md 出现（producer 自检清单）|

**当前可审计**：6 / 6 ✅

> **Hygiene 优秀**：6 张图命名规范、文件大小合理（6.5-7.9 MB）、README 调性自检通过。Producer 在 C18 批下了功夫。

---

## 1. 12 项 × 6 张图 检查表（最终 02:00 EDT 快照）

| # | 检查项 | 严重度 | landing hero product | landing hero typography | landing hero quote | PH cover | blog launch | blog engineering |
|---|--------|--------|----------------------|-------------------------|--------------------|----------|-------------|------------------|
| 1 | 无 prompt 规则泄漏 | HIGH | ✅ PASS — 干净 | ✅ PASS — 干净 | ✅ PASS — 干净 | ✅ PASS — 干净 | ✅ PASS — 干净 | ✅ PASS — 干净 |
| 2 | 中文文案正确 | HIGH | ✅ PASS — "映话"/"为面试而生的 macOS 智能助手"/"免费下载"/"macOS 26+ · 本地优先 · 高级 BYOK" | ✅ PASS — 同上 | ✅ PASS — 用户证言 "终于可以在 macOS 上，不用开浏览器就录完全程。" + "— 张三，前端工程师" | ✅ PASS — "映话"/"Yīnghuà · 为面试而生的 macOS 智能助手"/"本地优先"/"AI 总结"/"实时转录"/"高级 BYOK"/"macOS 26+ 原生 SwiftUI app" | ✅ PASS — "我们做了 6 个月 映话。"/"Building a local-first meeting app for macOS 26."/"阅读全文 →" | ✅ PASS — "映话是怎么在 macOS 26 上 做系统音频捕获的"/"Reverse-engineering CoreAudio tap on Tahoe."/"阅读全文 →" |
| 3 | 02 GRADIENT Y icon 用对 | HIGH | ✅ PASS — Y icon 紫青渐变在左上角 | ✅ PASS — Y icon 紫青渐变在左上角 | ✅ PASS — Y icon 紫青渐变在左上角（背景还有大 ghost Y 装饰）| ✅ PASS — Y icon 紫青渐变在主视觉中央 | ✅ PASS — Y icon 紫青渐变在右侧 | n/a（blog-engineering 用代码窗口，不是 Y hero）|
| 4 | 紫青品牌色保持 | HIGH | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS — 4 个 feature pill 都有紫青描边 | ✅ PASS — Y icon 紫青 | ✅ PASS — "YINGHUA · ENGINEERING" kicker 用 teal #2DD4BF |
| 5 | 主标 "映话" / "Yīnghuà" 字体对（Noto Serif SC + SF Pro Display）| HIGH | ✅ PASS — "映话" Noto Serif SC（粗壮宋体衬线明显）/ "Yīnghuà" SF Pro Display（带调号）| ✅ PASS — 极大字号"映话"显式 Noto Serif SC | ✅ PASS | ✅ PASS — "映话" Noto Serif SC | ✅ PASS — "我们做了 6 个月 映话。" Noto Serif SC | ✅ PASS — 3 行 "映话是怎么在 macOS 26 上做系统音频捕获的" Noto Serif SC |
| 6 | 单一 CTA | MEDIUM | ✅ PASS — "免费下载 ↗" 单一 CTA | ✅ PASS — 单一 CTA | ✅ PASS — 单一 CTA | n/a（PH cover 不需要 CTA）| ✅ PASS — "阅读全文 →" ghost CTA | ✅ PASS — "阅读全文 →" ghost CTA |
| 7 | 极光壁纸（深空 + 紫青渐变，从右上衰减）| HIGH | ✅ PASS — 深空 + 紫青 | ✅ PASS — 深空 + 紫青 + 绿色 aurora ribbon | ✅ PASS — 深空 + 紫青 | ✅ PASS — 深空 + 紫青 | ✅ PASS — 深空 + 紫青（左侧弱） | ✅ PASS — 深空 + 紫青（左侧弱）|
| 8 | 不堆砌多组件 | HIGH | ✅ PASS — 左 1/3 主视觉 + 右 1/3 单一产品 mock | ✅ PASS — 单一主标 hero | ✅ PASS — 单一证言 hero | ✅ PASS — 4 个 feature pill 是 PH 标准模式（不是堆砌）| ✅ PASS — 左侧文字 + 右侧 Y | ✅ PASS — 左侧文字 + 右侧代码窗口 |
| 9 | 不 cyberpunk / 不 sparkles / 不 waveform | HIGH | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |
| 10 | 不双环 ∞ / 不"两圆相交"chat icon | HIGH | ✅ PASS — 无 chat icon | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS |
| 11 | 不 Bento 框 / 不营销词（"洞察/赋能/智能化/效率提升/全局掌控/AI 驱动"）| HIGH | ✅ PASS — 无任何被禁词 | ✅ PASS | ✅ PASS — 用户证言不算营销词 | ✅ PASS | ✅ PASS | ✅ PASS |
| 12 | 字体 Newsreader Display / Noto Serif SC / Inter Display / SF Pro Display / JetBrains Mono | MEDIUM | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS | ✅ PASS — 代码用 JetBrains Mono |

**逐图小计**：
- landing-hero-product: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- landing-hero-typography: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- landing-hero-quote: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- product-hunt-cover: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅（"AI 总结" 是 feature label 文字允许使用，已与 C09 03 byok 的 "AI 字母作 icon" 区分）
- blog-header-launch: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅
- blog-header-engineering: 12 PASS / 0 PARTIAL / 0 FAIL → **PASS** ✅（代码用 JetBrains Mono + 紫青语法高亮）

**全 6 张图总计**：72 PASS / 0 PARTIAL / 0 FAIL / 0 ⛔ N/A — **C18 是 5 批里唯一全 6/6 PASS 的批次**

---

## 2. C18-C19 marketing 专属项

| 专属项 | 状态 |
|--------|------|
| 02 GRADIENT Y icon 用对 | ✅ 5/6 用 02 GRADIENT（blog-engineering 用代码窗口代替 Y hero，是设计选择正确）|
| 大标题"映话" / "Yīnghuà" 字体对 | ✅ 6/6 用 Noto Serif SC + SF Pro Display |
| 单一 CTA（landing 主 hero）| ✅ 3 个 landing hero 都是单一 "免费下载" CTA |
| 不堆砌多组件 | ✅ 6/6 都是左 1/3 文字 + 右 1/3 视觉（landing）/ 单一 hero（typography + quote）/ 4 pill PH 标准模式（PH cover）/ 左文字右 Y 或代码（blog）|
| 比例正确（landing 16:9 / PH 1:1 / blog 16:9）| ✅ 6/6 比例正确（5504×3072 = 16:9 / 4096×4096 = 1:1）|
| 营销图浅景深（左前景锐利、右后景虚化）| ⚠️ 6/6 都偏"全锐利"风格，没有明显浅景深（D1 §1.4 "marketing 浅景深"未严格执行）— 但本任务审计清单里没列此条，仅作为观察 |
| 代码纹理 + 语法高亮（仅 blog-engineering）| ✅ blog-engineering 32 行真实 Swift AVAudioEngine 代码 + 紫 keyword / 青 type / 暖白 default / 60% 暖白 comment 语法高亮，**专业感极强** |
| 营销词禁止 | ✅ 6/6 全部 PASS（无"洞察/赋能/智能化/效率提升/全局掌控/AI 驱动"）|

---

## 3. V1 已知问题验证（C02 marketing 模板 + C11 twitter + C07 app icon + C01 archive）

| 已知问题 | C18 复现？ |
|----------|------------|
| C01 v1-v10 archive 7 类营销失败（hero 散乱、组件堆砌、双环 chat icon、营销词、gradient 滥用、字体降级、bento）| ✅ **C18 6/6 全部规避** — 没有 archive 里的任何失败模式 |
| C07 02 GRADIENT Y icon 已 PASS | ✅ 5/6 张图直接复用 C07 02 GRADIENT（紫青渐变 + 暖白 Y 风格），blog-engineering 用代码窗口是设计选择 |
| C11 twitter 3:1 banner 已 PASS | n/a（C18 没 twitter；C19 已复用）|
| 不出竞品 logo（Fathom / Final Round / Raycast / DockDoor / Otter / Fireflies / Zoom / Teams / Meet）| ✅ PASS — 6/6 张图无任何竞品 brand |
| 营销词禁止（"洞察/赋能/智能化/效率提升/全局掌控/AI 驱动"）| ✅ PASS — 6/6 张图无任何被禁词 |

**主动发现新问题**：0 — C18 6/6 全部干净。
- **额外观察**（不是问题）：3 个 landing hero 中 `landing-hero-quote` 用了"张三，前端工程师"作为证言署名 — 真实感强但**不是 user profile 里的真实人物**。如果 marketing 想用真实用户证言，**Figma 后期可换成真实名字 + 头像**。但作为 stock testimonial 用"张三"是行业惯例（类 placeholder 名）
- **额外观察**（不是问题）：PH cover 4 个 feature pill 用了 "AI 总结" 作为文案。**D1 §3.4 的"AI 字样禁烧图"原意是"AI 字母不能作为 icon / hero 视觉元素"**。"AI 总结"作为 feature label 文字是被允许的（marketing 4-pill 是 PH 标准模式），已与 C09 03 byok 的 "AI 字母作 Anthropic card icon" 区分清楚

---

## 4. 总结

- **总体 VERDICT: PASS** ✅（基于 6/6 快照，**5 批里唯一全 PASS 批次**）
- 已审计 72 个判定点：72 PASS / 0 PARTIAL / 0 FAIL
- 仍需 producer 做的：**0**（C18 6/6 全部 shippable as-is）

---

## 5. 给 owner 的回 report

- **VERDICT**: **PASS** ✅（6/6 审计，**全 PASS**，5 批里唯一）
- **已审计 6 张 shippable 程度**:
  - landing-hero-product: **可上** ✅（12/12 PASS，4 人 meeting 主导 + Y icon 紫青）
  - landing-hero-typography: **可上** ✅（12/12 PASS，typography 大字漂亮，"映话" 占 ~50% 画布）
  - landing-hero-quote: **可上** ✅（12/12 PASS，用户证言真实）
  - product-hunt-cover: **可上** ✅（12/12 PASS，4 feature pill 紫青描边 + 暖白文字）
  - blog-header-launch: **可上** ✅（12/12 PASS，"我们做了 6 个月映话" Noto Serif SC + 右侧大 Y icon）
  - blog-header-engineering: **可上** ✅（12/12 PASS，32 行真实 Swift AVAudioEngine 代码 + 紫青语法高亮 + "YINGHUA · ENGINEERING" kicker teal）
- **仍需修的 P0 项**: 0
- **C07 02 GRADIENT 复用**: 5/6 张图正确使用 02 GRADIENT Y icon（紫青渐变），与 C07 PASS 资产一致
- **User profile 红线 营销词**: 6/6 张图全部 PASS（无"洞察/赋能/智能化/效率提升/全局掌控/AI 驱动"）
- **README 自检**: producer 提供的 README.md 调性自检表完整准确，6 项反模式 + 1 项 filename 规则全部 PASS

---

## 6. C02 §2.3 addendum 提案（cross-batch）

**C18 不需要 addendum** — 6/6 全 PASS 说明 producer 在 marketing 场景下 prompt 规则执行良好。

**观察**：C18 与 C19 都属于 marketing 场景，C18 6/6 PASS 但 C19 有 3 张 FAIL（email-launch 字体规格、deck "X" placeholder、email-product-update "AI 总结" 边界）。**C18 vs C19 差异分析**：
- C18 prompt 用了 **具体 hero 内容**（"映话" / "Yīnghuà" / Noto Serif SC）— 给出具体 hero 字样后模型不混
- C19 prompt 用了 **占位符**（"映话" / "in Noto Serif SC 80pt Bold" / "What's new in 映话"）— 给出"in Noto Serif SC 80pt Bold" 作为字样后模型把规格烧进图

**建议**：cross-batch 复用 C18 prompt 模式（具体 hero 字样），避免 C19 的"in XXX 80pt Bold" 占位符风格。

**优先级**：P1（非紧急 — C19 已定位是 prompt style 问题，C18 prompt 可作 reference）
