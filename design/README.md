# 映话 (Yìnghuà) — Round 1 设计探索

> 这是本轮设计探索的入口。所有产物按 `A / B / C / D` 四层组织。
> **plan 不预设设计结论**——所有具体形态在 `_exploration/Cxx_*/` 里涌现。

## 目录

```
design/
  _reference/         # A 层：抓回来的外部资产（不修改）
    parrot/  airtranslate/  textream/  dockdoor/  answercue/  commercial/
  _pipeline/          # B 层：生产管线规范（不修改，写死）
    B1-image-pipeline.md  B2-video-pipeline.md  B3-design-composition.md
    B4-asset-versioning.md B5-asset-evaluation.md B6-asset-code-binding.md
  _exploration/       # C 层：迭代设计探索（每轮一个目录）
    C01_hero_brand/    # ← 当前正在跑的 round
  design-doc.md       # D1：最终设计文档（Round 1 收口已写）
  design-tokens.json  # D2：设计 token JSON（Round 2 写）
  competitor-matrix.md # D3：竞品矩阵
  brand-brief.md      # D5：品牌 brief
```

## 当前进度

| 层 | 状态 |
|---|---|
| A1: 5 仓库 clone | ✅ Done（Parrot / AirTranslate / textream / DockDoor / AnswerCue） |
| A2: 资产索引（5 仓库） | ✅ Done（469 行 markdown） |
| A3: 关键源码截图 | ⏳ 按需（仓库内 Assets.xcassets 已索引） |
| A4: 商业产品截图 | ⏳ Playwright 后续批量抓 |
| A5: 文案语料库 | ✅ Done（Fathom + FinalRound 模板） |
| A6: 动效样本 | ⏳ 后续跑 H3 |
| A7: 资产复用清单 | ✅ 集成在 A2 内 |
| B1-B6: 6 份生产管线规范 | ✅ Done（562 行 markdown） |
| **C1: 5 个 hero 方向** | ✅ Done（5 张 2K 图） → 归档到 `C01_redo/archived_v1/` |
| **C02: Brand Assets V1** | ✅ Done（5 张 2K 图，3 套件） → 见 `_exploration/C02_brand-assets/` |
| **C03: Product Narrative V2** | ✅ Done（5 张产品 + 1 张 icon V2） → 见 `_exploration/C03_product-narrative/` |
| **C04: Polish V2** | ✅ Done（3 张：base reference + 2 张重做） → 见 `_exploration/C04_polish/` |
| **C05: Design Tokens Visual** | ✅ Done（5 张参考图库：macos-base / dock / speaker / control-panel / button-system） → 见 `_exploration/C05_design-tokens-visual/` |
| **C06: Product v3（终版）** | ✅ Done（5 张产品图：meeting / empty / transcript / review / onboarding） → 见 `_exploration/C06_product-v3/` |
| **C07: App Icon V3 探索** | ✅ Done（3 变体：minimal / gradient / glass） → 见 `_exploration/C07_app-icon-v3/` |
| **C08: 收口 → D1 design doc** | ✅ Done（`design-doc.md` 19K，11 章节，Round 1 单一真相源） |
| **C08 Light Mode**（Round 2）| ✅ Done（5 张浅色版 + README），verdict 待出 |
| **C09 Onboarding Flow**（Round 2）| ✅ Done（屏 2 权限 + 屏 3 BYOK + README），verdict 待出 |
| **Audit C06 v3 vs D1** | ✅ PARTIAL（33 PASS / 9 PARTIAL / 3 FAIL）|
| **Audit C07 icon vs C06** | ✅ PARTIAL（双生策略方向对，6 条 Figma 修复）|
| **C10 矢量 icon 精修**（Round 3）| ✅ Done（2 SVG + 12 PNG，C07 audit 6/6 修复）|
| **C11 Twitter banner 3:1**（Round 3）| ✅ Done（banner 21:9 + profile 1:1）|
| **C12 design-tokens.json**（Round 3）| ✅ Done（117 tokens 11 sections，W3C DTCG）|
| **C13 SwiftUI scaffold**（Round 3）| ✅ Done（18 源/1830 行，BUILD SUCCEEDED）|
| **C14 Browser extension 入口**（Round 3）| ✅ Done（Zoom + Meet 2 张）|
| **Audit C08 浅色**（Round 3）| ✅ PARTIAL |
| **Audit C09 Onboarding**（Round 3）| ✅ PARTIAL |
| **C15 dark shippable**（Round 4）| 🟡 worker 跑中（`bg_7e4b0cda`）— 5 张 4K，re-generate + 全 V1 修复 |
| **C16 light shippable**（Round 4）| 🟡 worker 跑中（`bg_f55ba234`）— 5 张 4K，re-generate + 全 V1 修复 |
| **C17 onboarding shippable**（Round 4）| 🟡 worker 跑中（`bg_87d8e0fe`）— 3 张 4K，Anthropic 真几何 mark + 全 V1 修复 |
| **C18 marketing A**（Round 4）| 🟡 worker 跑中（`bg_fc5e9811`）— landing hero × 3 + PH cover + blog × 2，4K |
| **C19 marketing B**（Round 4）| 🟡 worker 跑中（`bg_08e9b730`）— Twitter 3:1 + profile + email × 3 + deck cover，4K |
| **C20 SwiftUI 真业务**（Round 4）| 🟡 worker 跑中（`bg_9cb8997a`）— AVAudioEngine + SCStream + SpeechAnalyzer + BYOK + Anthropic API |
| **C21 Chrome extension 真代码**（Round 4）| ✅ Done（13 文件 / 2,056 LoC，MV3 + content + background + offscreen + popup，零网络调用）|
| **C22 D2 design-doc v2.0**（Round 4）| 🟡 worker 跑中（`bg_a5bb3b30`）— D1 升级到 15 章，整合 4 audit + Round 4 计划 |
| **Audit C15-C19 shippable**（Round 4）| 🟡 verifier 跑中（`bg_48250e97`）— 25 张图 × 12 项检查 |
| Round 2 候选 | ⏳ 矢量 icon 精修 / design-tokens.json / Twitter banner / Browser extension |
| C3-C16 | ⏳ 后续按顺序跑 |
| D1: design doc（master block）| ✅ Done（Round 1 收口，详见 `design-doc.md`）|
| D2-D5 | ⏳ Round 2 写 |

## 锁定

- **产品名**：映话 (Yìnghuà)
- **平台**：macOS 26+ 原生 SwiftUI + AppKit
- **云策略**：本地优先 + 高级 BYOK
- **调性方向**：极光紫 + 深空（强玻璃 + 渐变）
- **首选参考**：Final Round AI / Fathom / Parrot / AirTranslate / textream / DockDoor

## 探索轮（C1-C16）

详见 plan.md "C. 迭代式设计探索层" 章节。每轮流程：
1. 多模态生成 3-5 个候选 → 落到 `_exploration/Cxx_*/candidates/`
2. 用户挑 1-2 → 写 `user-pick.md`
3. 深挖到可看质量
4. 写 `learned.md`（一段话）
5. 跨轮收敛：design doc 里的 master block

## 关键文件

- [plan.md](.minimax/v2/sessions/2026/08/22/16-25-56-441-session_bXZzXzRmMTNkNjQ1OThmZDRiMTI5YTFiYzZmNjBjNWIyNWUx/artifacts/plan.md) — 完整 plan
- [_pipeline/B1-image-pipeline.md](_pipeline/B1-image-pipeline.md) — 图片生产管线
- [_pipeline/B2-video-pipeline.md](_pipeline/B2-video-pipeline.md) — 视频生产管线
- [_pipeline/B4-asset-versioning.md](_pipeline/B4-asset-versioning.md) — 资产命名 / 归档
- [_pipeline/B5-asset-evaluation.md](_pipeline/B5-asset-evaluation.md) — 评估 checklist
- [_pipeline/B6-asset-code-binding.md](_pipeline/B6-asset-code-binding.md) — 资产-代码绑定
- [_reference/parrot/assets-index.md](_reference/parrot/assets-index.md) — Parrot 资产索引
- [_reference/airtranslate/assets-index.md](_reference/airtranslate/assets-index.md) — AirTranslate 资产索引
- [_reference/textream/assets-index.md](_reference/textream/assets-index.md) — textream 资产索引
- [_reference/dockdoor/assets-index.md](_reference/dockdoor/assets-index.md) — DockDoor 资产索引
