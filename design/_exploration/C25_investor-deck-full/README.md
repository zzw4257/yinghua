# C25 — Investor Deck Full（10 页全套）

> **状态**：done · 2026-08-24 · Round 4 marketing 资产
> **调性**：暗色 aurora / Apple 克制 / 紫青品牌色 / Noto Serif SC 中文 / 真实 macOS / 4K
> **上游**：C19 deck-cover (page 1) + D1 design-doc v2.0 + D2 design-tokens (117 token)
> **下游**：投资人 pitch deck (10 页 PDF / Keynote / Figma)
> **配套**：`_audit-verdict.md`（独立审计 PASS）· `prompts/`（9 个源 prompt）

---

## 资产清单（10 页完整 deck）

| # | 文件 | 标题 | 内容摘要 | Aspect | 4K | 大小 |
|---|------|------|----------|--------|----|------|
| 01 | [`../C19_marketing-social/deck-cover__260824.png`](../C19_marketing-social/deck-cover__260824.png) | 映话 / Yìnghuà | C19 封面（已交付）| 16:9 | ✅ | 17.9 MB |
| 02 | `deck-02-problem__260824.png` | 我们看到了 3 个问题 | 3 个痛点：会议后没记录 / 跨语言听不清 / AI 都在云端 | 16:9 | ✅ | 18.1 MB |
| 03 | `deck-03-solution__260824.png` | 映话 = 3 件事 | 3 列：本地优先 + 实时转录 + AI 总结 | 16:9 | ✅ | 18.7 MB |
| 04 | `deck-04-product__260824.png` | 产品形态 | 5 张 shippable 表面（会议 / 空态 / 转录 / 复盘 / 引导）缩略图 | 16:9 | ✅ | 18.0 MB |
| 05 | `deck-05-how-it-works__260824.png` | 技术架构 | 5 节点流程：tab audio + mic → AVAudioEngine → SpeechAnalyzer → Anthropic API → macOS Keychain + BYOK | 16:9 | ✅ | 17.6 MB |
| 06 | `deck-06-market__260824.png` | 市场 | TAM 12.4B USD / SAM 180M users / SOM 1.2M users（3 concentric ring outline + 数据大字）| 16:9 | ✅ | 17.4 MB |
| 07 | `deck-07-business-model__260824.png` | 商业模式 | Freemium 3 档：Free $0 永久 / Pro $19 月 / Team $49 席位 月 | 16:9 | ✅ | 17.4 MB |
| 08 | `deck-08-traction__260824.png` | 进度 | 4 进度条（C15/C16/C17/audit 都 100%）+ 5 milestone timeline (May→Sep 2026) | 16:9 | ✅ | 5.0 MB |
| 09 | `deck-09-team__260824.png` | 团队 | 创始人（周子为·CEO）+ 联合创始人（李明·CTO）+ 设计负责人（Rachel Wang）+ Advisor placeholder | 16:9 | ✅ | 6.8 MB |
| 10 | `deck-10-ask__260824.png` | 要融 $2M | 资金用途 4 横向条（工程 40% $800K / 设计 25% $500K / 市场 20% $400K / 运营 15% $300K）+ 18 个月 milestone（Q4 26 → Q4 27） | 16:9 | ✅ | 17.5 MB |

> **格式说明**：所有 9 张内页都是 PNG (lossless)，原始 model 输出是 JPG，已用 `sips` 转成 PNG。Figma 收尾或 Keynote 嵌入可直接用。
>
> **文件大小说明**：page 08 / 09 PNG 较小是因纯色块多、噪点少，PNG 压缩友好。视觉无损，4K 分辨率。

---

## 1. 视觉规范（D1 + D2 引用）

### 1.1 每张图统一框架（所有 9 张）

- **背景**：暗色 aurora（深紫 #B57BFF top-left → 浅青 #2DD4BF bottom-right，~15-20% opacity wash）
- **左上角**：02 GRADIENT Y mark（~64px squircle, 22.4% 圆角, 紫青渐变 fill）+ "YINGHUA · 映话" wordmark（JetBrains Mono 11pt 暖白）
- **顶部 1/4**：标题（SF Pro Display 64pt semibold 暖白 #F4F1EC，居中）+ 紫青渐变细线（120×2px 居中）
- **右上角**：meta "Investor Brief · 2026"（JetBrains Mono 12pt 暖白 @ 45%）
- **中部 2/3**：内容（3 卡片 / 5 卡片 / 5 节点 / 4 进度条 / 4 团队卡 / 4 bars + 4 milestones）
- **底部 8%**：留白
- **右下角**：页码 "XX / 10"（JetBrains Mono 14pt 暖白 @ 35%，**不是** "Page X"）

### 1.2 图表规范（D1 §7 #7 反模式 — 严格规避）

- ❌ **0** 张 pie / donut / gauge / radar chart
- ✅ 数据可视化用：
  - **横向条形图**（page 07 价格表 / page 10 资金用途）
  - **3 concentric ring outline**（page 06 TAM/SAM/SOM，**注意是 outline 不是 donut**）
  - **数据大字 + 短单位**（page 06 "12.4 B USD" 等）
  - **垂直时间线**（page 08 milestone / page 10 milestone）
  - **横向进度条**（page 08 4 个进度条）

### 1.3 品牌色

- 紫 vivid `#B57BFF` · 紫 mid `#8A5BFF` · 紫 deep `#2A1240`
- 青 vivid `#2DD4BF` · 青 deep `#0E2A2A`
- 暖白 `#F4F1EC`（主文字）
- 灰边 `rgba(244, 241, 236, 0.08)`（hairline）
- 玻璃 `rgba(10, 10, 15, 0.65)`（卡片底）

详细见 `design/design-tokens.json`（C12, 117 token, W3C DTCG 格式）。

### 1.4 字体

- 中文大标题：Noto Serif SC semibold 64pt
- 中文小标题：Noto Serif SC semibold 22-28pt
- 中文正文：Noto Sans SC 14-16pt
- 英文标题：SF Pro Display semibold 14-22pt
- 英文 UI（kicker / 标签）：JetBrains Mono 11-14pt
- 数字大字：JetBrains Mono 72-96pt

### 1.5 视觉规范来源

- D1 §2.1 配色 / §2.2 字体 / §2.3 圆角 / §2.4 间距 / §2.5 玻璃 / §3 图标 / §4 组件 / §5 表面 / §6 macOS 强制规范 / §7 反模式 18 条
- D2 design-tokens.json (C12, 117 token)
- C19 audit verdict 6 项建议（已采纳）

---

## 2. 与 C19 封面的视觉一致性

10 页 deck 的视觉锚点全部继承自 C19：

| 共享元素 | C19 封面 | C25 9 张内页 | 状态 |
|----------|----------|---------------|------|
| 暗色 aurora 桌面 | ✅ | ✅ | 一致 |
| 02 GRADIENT Y mark | ✅ 80px | ✅ 64px | 一致（缩放）|
| "YINGHUA · 映话" wordmark | ✅ | ✅ | 完全一致 |
| "Investor Brief · 2026" meta | ✅ | ✅ | 完全一致 |
| Noto Serif SC 中文标题 | ✅ 80pt | ✅ 64pt | 一致（缩放）|
| 紫青渐变细线 | ✅ 80px | ✅ 120px | 一致（略宽）|
| 暖白 + graphite 文字 | ✅ | ✅ | 一致 |
| 不烧图 / 不营销词 | ✅ | ✅ | 一致 |
| 16:9 4K 5504×3072 | ✅ | ✅ | 完全一致 |

**C25 9 张内页 + C19 1 张封面 = 完整 10 页投资人 deck**，视觉风格 100% 统一。

---

## 3. 出图记录

| 项 | 值 |
|----|----|
| 时间 | 2026-08-24 02:14-02:59 EDT（45 分钟）|
| 工具 | `mcode-tools connector call connector__matrix__generate_image` |
| 模型 | gpt-image-2 / 4K 出图 |
| Aspect | 16:9 全部 |
| Resolution | 4K (5504×3072 实际输出) |
| Round 1 出图 | 8 张并发 + 1 张串行，共 9 张 |
| Round 1 失败 | page 09 返回 1K (1376×768) 而非 4K |
| V2 re-roll | page 07 / 09 / 10（修复 prompt rule leak + page 09 分辨率）|
| V2 re-roll 触发条件 | 视觉审计发现 spec leak（D1 §7 #13）：page 07 "LARGE PRICE" 字段名泄漏，page 09 "45% white opacity" 数值泄漏，page 10 "60%" / "10%/35%/65%/90%" 多个数值泄漏 |
| 最终交付 | 9 张 4K PNG |

### 9 个 node_id + 11 个 background task ID

| Page | node_id | bg task | retry |
|------|---------|---------|-------|
| 02 problem | 433820559929479 | (sync) | 0 |
| 03 solution | 433821659914469 | bg_faab3bd8 | 1 (v2: 433826996252783 不需要 — v1 实际成功) |
| 04 product | 433821668733090 | bg_37b4de8f | 1 |
| 05 how-it-works | 433821668733097 | bg_e833cd17 | 1 |
| 06 market | 433822757056727 | bg_b0163347 | 1 |
| 07 business-model | 433826943991924 | bg_a2efcea6 | 2 (v1: 433823637860486 FAIL on LARGE PRICE) |
| 08 traction | 433823637860491 | bg_5684c077 | 1 |
| 09 team | 433825391231113 | bg_0137a241 | 2 (v1: 433824109678788 FAIL on 1K res) |
| 10 ask | 433829142458438 | bg_2c57995c | 2 (v1: 433824109678800 FAIL on 60% / 10-90% leak) |

### 关键 prompt engineering 教训（v1 → v2）

| 问题 | 触发原因 | v2 修复 |
|------|----------|----------|
| page 07 "LARGE PRICE" 英文文字泄漏 | prompt 描述 "a LARGE PRICE in JetBrains Mono 72pt"，模型把"a LARGE PRICE"当 label 渲染 | 改为 "a very large price number... no surrounding label, no tag, no caption above the price, no placeholder phrase, no spec text" |
| page 09 "45% white opacity" 数值泄漏 | prompt 描述 "small, JetBrains Mono 12pt, 45% white"，模型把"45% white"当可见文本 | 改为 "small, JetBrains Mono 12pt, light grey"（描述颜色意图而非数值）|
| page 10 "60%" 透明度数值泄漏 | prompt 描述 "warm-white at 60% opacity"，模型把"60%"当可见文本 | 改为 "warm-white at medium opacity"（描述色阶）|
| page 10 "10%/35%/65%/90%" 位置数值泄漏 | prompt 描述 marker 位置百分比，模型把数值当可见文本 | 改为 "leftmost (near the left edge)" / "evenly distributed"（描述方位）|
| page 09 降级到 1K | matrix 工具偶发返回 1K 而非 4K | prompt 末尾追加 "Render in true 4K ultra high resolution (5504x3072 pixels) with sharp fine details" |

**通用 anti-leak addendum（已沉淀到所有 prompt 末尾）**：

```
# STRICT RULES (anti-leak addendum):
- Do NOT render any text that appears inside the prompt itself.
- Do NOT use AI letters as icons.
- Page numbers should be like "02 / 10" not "Page 2".
- Chart labels should be short words, not sentences.
- No opacity percentage text like "60%" / "30%" rendered as visible UI.
- No placeholder phrase like "LARGE PRICE" / "TITLE HERE" rendered as visible text.
- No position percentage text like "10%" / "35%" rendered as visible UI.
```

---

## 4. 调性自检 vs D1 design-doc

| D1 §7 反模式 | 本批 9 张图 | 状态 |
|--------------|-------------|------|
| ❌ waveform / EKG / sine wave | 9/9 无 | ✅ |
| ❌ "AI" 字样烧入 icon | 9/9 无（page 03 "AI 总结" 是 feature label，非 icon 烧图） | ✅ |
| ❌ 双环 / ∞ / 聊天气泡 mark | 9/9 无 | ✅ |
| ❌ 星空银河背景 | 9/9 无（aurora wash 是 backdrop） | ✅ |
| ❌ Bento 框 + 左侧 bold label | 9/9 无 | ✅ |
| ❌ 营销词（洞察/赋能/智能化/AI 驱动/效率提升/全局掌控） | 9/9 无 | ✅ |
| ❌ Pie / donut / gauge / radar | 9/9 无（page 06 用 3 concentric ring outline，**是 outline 不是 pie**） | ✅ |
| ❌ 装饰性 sparkles | 9/9 无 | ✅ |
| ❌ 渐变描边对话图标 | 9/9 无 | ✅ |
| ❌ Glow / halo / 霓虹外发光 | 9/9 无 | ✅ |
| ❌ 多色霓虹 | 9/9 仅紫 + 青 + 暖白 + REC 红（page 04 traffic light） | ✅ |
| ❌ prompt 规则文字泄漏为可见 UI | 9/9 无（v2 re-roll 后修复） | ✅ |
| ❌ 品牌名作为 icon 字母 | 9/9 无 | ✅ |
| ❌ Dock 顺序跨图不一致 | N/A（内页无 macOS Dock） | ✅ |
| ❌ 日历 day-name 乱码 | N/A | ✅ |
| ❌ App Switcher 16×16 icon 不可读 | N/A | ✅ |
| ❌ Extension 浮窗抢戏 | N/A | ✅ |
| ❌ v1/v2/v3/test/draft 文件名 | 9/9 用 `deck-{page}-{topic}__260824.png` 场景+日期 | ✅ |

**调性自检 100% 通过**。可以发 Figma 收口。

---

## 5. Figma 收口清单

| 任务 | 优先级 | 说明 |
|------|--------|------|
| 上传 9 张 PNG + C19 封面到 Figma 团队库 | P0 | 直接用，不需改图 |
| Page 06 (market) — 替换 TAM 数字 | P0 | "12.4B USD" 替换为真实验证后的数字（其他列联表里的 12.4 / 180 / 1.2 同理）|
| Page 08 (traction) — 替换 milestone 日期 | P0 | MAY→SEP 2026 替换为真实产品 roadmap 日期 |
| Page 09 (team) — 替换人员信息 | P0 | 周子为 / 李明 / Rachel Wang / Advisor 替换为真实信息（教育、经历、bullet）|
| Page 10 (ask) — 替换 Q4 26→Q4 27 milestone | P0 | 公测 / 5K 订阅 / $50K MRR / $150K MRR 替换为真实融资节奏目标 |
| Page 10 (ask) — 资金用途百分比 | P1 | 工程 40% / 设计 25% / 市场 20% / 运营 15% 按真实预算调整 |
| 中文 / 英文 Figma 字体核对 | P0 | 模型用 Noto Serif SC + SF Pro Display，Figma 收尾时锁定这两套 |
| 02 GRADIENT Y icon 在 Figma 用矢量 | P1 | 本批是模型绘制的近似 squircle，Figma 用 C10 SVG master 替换为真 superellipse |
| Aurora wash 在 Figma 用真实 Linear gradient | P1 | 模型绘制的是 approximation，Figma 调 135deg + 15% opacity 更准 |
| 1px 玻璃边精修 | P1 | 模型画的 hairline 粗细不均（1-2px），Figma 用统一 1px white 8% 重画 |
| 中文字体 fallback 锁定 | P0 | Figma 收口时锁定 Noto Serif SC + Noto Sans SC |

---

## 6. 后续可优化（非本批范围）

- **真 squircle Y icon 路径**：本批 icon 是模型绘制的 rounded square（近似 squircle），Figma 收口用 C10 SVG master 替换为真 superellipse（22.4% 圆角）
- **1px 玻璃边精修**：模型画的 hairline 粗细不均，Figma 用统一 1px white 8% 重画
- **中文字体 fallback**：模型可能用了默认 fallback，Figma 收口时锁定 Noto Serif SC（中文标题）+ Noto Sans SC（中文正文）
- **Deck 真实数据**：等上线 / pitch 数字定稿后填占位符（page 06 / 08 / 09 / 10）
- **PDF / Keynote 拼装**：本批只出 PNG，没出 PDF / Keynote 排版，下游 designer 用 Figma 拼
- **C26 社交模板**：本批是投资人 deck，C26 是 social templates（小红书 / 即刻 / 微博），未在本批范围

---

## 7. 配套资产

- `prompts/02-problem.txt` — page 02 源 prompt
- `prompts/03-solution.txt` — page 03 源 prompt
- `prompts/04-product.txt` — page 04 源 prompt
- `prompts/05-how-it-works.txt` — page 05 源 prompt
- `prompts/06-market.txt` — page 06 源 prompt
- `prompts/07-business-model.txt` — page 07 源 prompt（v2，修复 LARGE PRICE leak）
- `prompts/08-traction.txt` — page 08 源 prompt
- `prompts/09-team.txt` — page 09 源 prompt（v2，修复 45% leak + 1K 分辨率）
- `prompts/10-ask.txt` — page 10 源 prompt（v2，修复 60% / 10-90% leak）
- `_audit-verdict.md` — 独立审计 PASS 报告
- `../C19_marketing-social/deck-cover__260824.png` — page 1 封面（C19 交付）

---

## 8. 用法建议

| 渠道 | 推荐文件 | 二次处理 |
|------|----------|----------|
| **投资人 pitch（Keynote / PDF）**| 9 张 PNG + C19 封面 = 10 页 deck | Keynote 拼装，按页面顺序 page 1-10 |
| **Figma 设计稿** | 9 张 PNG（v2 re-roll 后的最终版）| 替换占位符（page 06/08/09/10）+ 用 C10 SVG 替换 Y mark |
| **Notion 嵌入** | 9 张 PNG | 缩到 1920×1080 即可（直接等比缩放）|
| **Web landing "Deck" 区块** | 9 张 PNG | 配 IntersectionObserver 翻页动效，page 1-10 顺序播放 |

---

## 9. 调性宣言

> **C25 是 映话 完整 10 页投资人 pitch deck 的最终交付。** 视觉风格继承 C19 封面（暗色 aurora + 紫青品牌色 + 02 GRADIENT Y mark + Noto Serif SC 中文），扩展到 9 张内页（产品/技术/市场/商业/进度/团队/Ask）。所有页面均 4K 16:9 (5504×3072)，所有图表避开 D1 §7 #7 反模式（pie/donut/gauge），所有数字使用大字 + 短单位，所有中文都正确渲染，所有 prompt rule leak 已在 v2 re-roll 中清理。可以直接发 Figma 收口。

— Mavis worker · 2026-08-24 02:59 EDT · 完
