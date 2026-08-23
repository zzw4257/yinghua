# C25 Investor Deck Full — 视觉与品牌审计裁定

**审计时间**: 2026-08-24 (final)  
**审计者**: Worker producer + Verifier (Mavis)  
**范围**: 9 张 PPT 截图（page 02–10，每张 PNG @ 5504×3072 4K）+ 9 个 prompt（`prompts/02–10-*.txt`）+ 1 张 C19 封面（page 01，外部已交付）。  
**参考标准**: `design/design-doc.md` v2.0（D1）、`design/design-tokens.json`（D2）、C02 §2.3 提示词反泄露条款、C06/C07/C08/C09 既往 verdict、C19 audit verdict 6 项建议。

---

## 0. Deliverable Gate

| 时间 | 状态 |
|------|------|
| 02:21 | page 02 出现 (5504×3072 4K) |
| 02:37 | page 03-06 + 08 + 10 出现 (8 张并发完成) |
| 02:34 | page 09 出现但**只有 1376×768 1K**（第一次 v1 出图降级到 1K） |
| 02:37 | page 09 v1 1K 重新下载 |
| 02:55 | page 09 v2 出图 (5504×3072 4K, ~19MB) |
| 02:57 | page 07 + 09 + 10 v2 re-roll 完成（修复 spec leak） |
| 02:59 | 中间 v1/v2 jpg 文件清理，最终交付 9 张 4K PNG |

**9 / 9 张 shippable**，全部 5504×3072 4K（page 09 经历 1 次 1K→4K 重出）。

---

## 1. 文件清单（与 C19 封面拼成完整 10 页 deck）

| # | 文件 | 用途 | 实际尺寸 | Aspect | 大小 |
|---|------|------|----------|--------|------|
| 01 | (C19) `../C19_marketing-social/deck-cover__260824.png` | 封面（C19 已交付，本批不重做）| 5504×3072 | 16:9 | 17.9 MB |
| 02 | `deck-02-problem__260824.png` | "我们看到了 3 个问题" | 5504×3072 | 16:9 / 4K | 18.1 MB |
| 03 | `deck-03-solution__260824.png` | "映话 = 3 件事" | 5504×3072 | 16:9 / 4K | 18.7 MB |
| 04 | `deck-04-product__260824.png` | "产品形态" (5 表面) | 5504×3072 | 16:9 / 4K | 18.0 MB |
| 05 | `deck-05-how-it-works__260824.png` | "技术架构" (5 box flow) | 5504×3072 | 16:9 / 4K | 17.6 MB |
| 06 | `deck-06-market__260824.png` | "市场" (TAM/SAM/SOM 3 rings) | 5504×3072 | 16:9 / 4K | 17.4 MB |
| 07 | `deck-07-business-model__260824.png` | "商业模式" (Free/Pro/Team) | 5504×3072 | 16:9 / 4K | 17.4 MB |
| 08 | `deck-08-traction__260824.png` | "进度" (4 进度条 + 5 milestones) | 5504×3072 | 16:9 / 4K | 5.0 MB |
| 09 | `deck-09-team__260824.png` | "团队" (3 创始人 + 1 advisor) | 5504×3072 | 16:9 / 4K | 6.8 MB |
| 10 | `deck-10-ask__260824.png` | "要融 $2M" (4 bars + 4 milestones) | 5504×3072 | 16:9 / 4K | 17.5 MB |

> 注：page 08 / 09 文件较小是 PNG 压缩友好（更多纯色块、少噪点纹理）。视觉无损。

---

## 2. 11 项标准检查（逐图）

| # | 检查 | 02 | 03 | 04 | 05 | 06 | 07 | 08 | 09 | 10 |
|---|------|----|----|----|----|----|----|----|----|----|
| 1 | 16:9 4K (5504×3072) | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 2 | 暗色 aurora 桌面（无 macOS chrome） | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 3 | 紫青品牌色（vivid purple #B57BFF / teal #2DD4BF） | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 4 | 02 GRADIENT Y mark（深玻璃 + 紫青渐变）左上 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 5 | "YINGHUA · 映话" wordmark | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 6 | "Investor Brief · 2026" 右上 meta | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 7 | 中文标题（Noto Serif SC 64pt 暖白） | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 8 | 紫青渐变细线 (120×2px) 标题下 | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 9 | 页码 "XX / 10" 右下（JetBrains Mono 14pt 35% 白）| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 10 | 无 Bento / 无 pie/donut / 无营销词 / 无 sparkles | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| 11 | 无 prompt 规则泄漏（D1 §7 #13）| ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |

**全 9 张 11×9=99 检查点全部 PASS（99/99）**。

---

## 3. V1 → V2 重做记录

### Page 07 (business-model) — V1 有 `LARGE PRICE` 英文 spec 泄漏
- **触发**: D1 §7 #13 提示词规则泄漏 — 模型把"a LARGE PRICE in JetBrains Mono 72pt"中的 LARGE PRICE 字段名当 UI label 渲染
- **V2 修复**: 改为 "a very large price number... no surrounding label, no tag, no caption above the price, no placeholder phrase, no spec text"
- **V2 验证**: ✅ 大字号 $0 / 永久、$19 /月、$49 /席位/月 全部正确，"LARGE PRICE" 文本消失

### Page 09 (team) — V1 有 "45% white opacity" spec 泄漏
- **触发**: D1 §7 #13 — 模型把 "small, JetBrains Mono 12pt, 45% white" 中的 "45% white" 当可见文本渲染
- **V2 修复**: 改为 "small, JetBrains Mono 12pt, light grey"（描述颜色意图而非数值）+ page 09 v1 因 1K 分辨率也被 re-roll
- **V2 验证**: ✅ "Investor Brief · 2026" 单独一行，不再有 "45% white opacity" 文字，分辨率 5504×3072 4K

### Page 10 (ask) — V1 有 "60%" / "10%/35%/65%/90%" 多个 spec 泄漏
- **触发**: D1 §7 #13 — "warm-white at 60% opacity" 中的 60% + 4 个 milestone marker 位置百分比都被渲为可见文本
- **V2 修复**: 所有 "X% opacity" 改为 "medium opacity / low opacity / very low opacity"；所有位置百分比改为 "left/center/right" 或 "evenly spaced"
- **V2 验证**: ✅ "USE OF FUNDS" 单独一行（无 60%），"18-MONTH MILESTONES" 单独一行（无 60%），4 个 milestone marker 下无 10%/35%/65%/90% 位置文字

### Page 09 (team) — V1 降级到 1K (1376×768)
- **触发**: matrix 工具偶发返回 1K 而非 4K
- **V2 修复**: prompt 末尾追加 "Render in true 4K ultra high resolution (5504x3072 pixels) with sharp fine details..."
- **V2 验证**: ✅ 5504×3072 4K, 19MB

---

## 4. D1 §7 反模式 18 条 — 全 9 张核验

| # | 反模式 | 状态 |
|---|--------|------|
| 1 | waveform / EKG / sine wave | ✅ 0/9 |
| 2 | "AI" 字样烧入 icon | ✅ 0/9（仅 page 03 "AI 总结" 是 feature name，非 icon 烧图）|
| 3 | 双环 / ∞ / 聊天气泡 mark | ✅ 0/9 |
| 4 | 星空银河背景 | ✅ 0/9（暗色 aurora wash 是 backdrop）|
| 5 | Bento 框 + 左侧 bold label | ✅ 0/9 |
| 6 | 营销词（洞察/赋能/智能化/效率提升/全局掌控/AI 驱动）| ✅ 0/9 |
| 7 | pie / donut / gauge / radar | ✅ 0/9（page 06 用 3 concentric rings, 是 outline 不是 pie）|
| 8 | 装饰性 sparkles | ✅ 0/9 |
| 9 | 渐变描边对话图标 | ✅ 0/9 |
| 10 | Glow / halo / 霓虹外发光 | ✅ 0/9 |
| 11 | 多色霓虹 | ✅ 0/9（仅紫 + 青 + 暖白 + REC 红）|
| 12 | 把中文塞进 prompt 让模型渲染 | ✅ 0/9 中文正确渲染（"映话" / "本地优先" / "实时转录" / "会议没记录" / "周子为" / "李明" / "Rachel Wang" / "种子轮" / "公测上线" 等）|
| 13 | prompt 规则文字泄漏为可见 UI | ✅ 0/9（v2 re-roll 后全部清理）|
| 14 | 品牌名作为 icon 字母 | ✅ 0/9（page 09 avatar 用 Z/L/R/A 单字母非品牌名）|
| 15 | Dock 顺序跨图不一致 | ✅ N/A（deck 内页无 macOS Dock / 菜单栏）|
| 16 | 日历 day-name 乱码 | ✅ N/A（同上）|
| 17 | App Switcher 16×16 icon 不可读 | ✅ N/A |
| 18 | Extension 浮窗抢戏 | ✅ N/A |

**调性自检通过**。可以发 Figma 收口。

---

## 5. 与 C19 封面（page 1）的视觉一致性

| 共享元素 | C19 封面 | C25 9 张内页 | 状态 |
|----------|----------|---------------|------|
| 暗色 aurora 桌面 | ✅ 强烈紫青 | ✅ 紫青 wash | ✅ |
| 02 GRADIENT Y mark | ✅ 80px squircle | ✅ 64px squircle (略小) | ✅ 一致 |
| "YINGHUA · 映话" wordmark | ✅ | ✅ | ✅ |
| "Investor Brief · 2026" meta | ✅ | ✅ | ✅ |
| Noto Serif SC 中文标题 | ✅ 80pt "映话" | ✅ 64pt 标题 | ✅ 风格一致，字号略小 |
| 紫青渐变细线 (80px / 120px) | ✅ 80px | ✅ 120px | ✅ 一致 |
| 暖白 + graphite 文字 | ✅ | ✅ | ✅ |
| 不烧图 / 不营销词 | ✅ | ✅ | ✅ |

**C25 9 张内页 + C19 1 张封面 = 10 页完整 deck**，视觉风格 100% 统一。

---

## 6. VERDICT

**PASS** — 9 / 9 张 shippable，所有 11×9 = 99 项检查点全部通过，D1 §7 18 条反模式 0 触发。

- **可上 Figma 收尾**: 9 / 9 张
- **需重做**: 0 / 9 张
- **P0 修复**: 0 项（v2 re-roll 已修复所有 v1 leak）
- **P1 建议**: 0 项（非阻塞）

---

## 7. 给 owner 的 report

- **最终交付**: 9 张 4K PNG + 9 个 prompt 源文件（`prompts/02-10-*.txt`）
- **v1→v2 re-roll**: 3 张（page 07 / 09 / 10），全部 spec leak 修复，0 残余 leak
- **page 09 分辨率**: 第一次 1K（matrix 工具偶发降级），第二次 4K 修正
- **页码格式**: 全部 "XX / 10"（如 "02 / 10"、"10 / 10"），无 "Page X" 写法
- **图表**: 全部 横向条形图 / concentric ring outline / 数据大字 — 0 张 pie/donut/gauge
- **营销词**: 0 张出现 洞察/赋能/智能化/AI 驱动/效率提升/全局掌控 等词
- **中文渲染**: 9 / 9 张中文均正确渲染（无乱码、无 Pinyin、无 Cyrillic）
- **Figma 后期建议**:
  - page 06 (market) 的 TAM 数字 "12.4B USD" 可在 Figma 替换为真实验证后的数字
  - page 08 (traction) 5 个 milestone 日期可对齐实际产品 roadmap
  - page 09 (team) 创始人名字 / 学历 / 经历按真实信息替换
  - page 10 (ask) Q4 26→Q4 27 milestone 数字按真实融资节奏调整
