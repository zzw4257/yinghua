# B4 · 资产版本管理 + 复用策略

> 用途：定义映话 (Yìnghuà) 的所有视觉资产怎么命名、怎么归档、怎么复用、怎么迭代。

## 目录结构

```
design/
  _reference/                   # 抓回来的外部参考（不修改）
    parrot/                     # git clone，不动
    airtranslate/
    textream/
    dockdoor/
    answercue/
    commercial/                 # 商业产品截图 + 文案
      fathom/
        landing/
        dashboard/
        copy-corpus.md
      hedy/  finalroundai/  lockedin/  interviewcoder/  feishu-meeting/  tencent-meeting/

  _pipeline/                    # pipeline 规范（不修改，写死的）
    B1-image-pipeline.md
    B2-video-pipeline.md
    B3-design-composition.md
    B4-asset-versioning.md      # 本文件
    B5-asset-evaluation.md
    B6-asset-code-binding.md

  _exploration/                 # 迭代设计探索（每轮一个目录）
    C01_hero_brand/
      candidates/               # 5 个候选（图片 + 视频 + prompt）
        c01_hero_a_pure-black-cosmic.png
        c01_hero_b_liquid-metal.png
        c01_hero_c_light-band.png
        c01_hero_d_particle-vortex.png
        c01_hero_e_mirror-city.png
        c01_hero_a_pure-black-cosmic.mp4
        ...
      prompts.md                # 5 个候选的完整 prompt
      design-rationale.md       # 每个候选代表什么方向
      user-pick.md              # 用户挑了哪个 / 为什么
      learned.md                # 这一轮学到了什么

    C02_tone_refinement/
    C03_launch_screen/
    ...
    C16_dynamic_knowledge_graph/
    C17_convergence/            # 收敛

  _assets/                      # 最终归档的资产（被选中的）
    icons/                      # 应用 icon
    marketing/                  # 营销图 / hero
    screens/                    # 应用内屏幕
    motion/                     # 动效研究
    voice/                      # 文案 / 语调样本
    components/                 # 组件库截图

  design-doc.md                 # D1 最终设计文档
  design-tokens.json            # D2 设计 token
  competitor-matrix.md          # D3 竞品矩阵
  brand-brief.md                # D5 品牌 brief
```

## 命名规则

### 文件名

- 候选：`cNN_主题_variant.png` （e.g. `c01_hero_a_pure-black-cosmic.png`）
- 选中的最终：`主题-描述.png` （e.g. `hero-cosmic-orb-aurora.png`）
- 归档到 `_assets/` 时去掉 round 前缀
- 永远小写 + 连字符（kebab-case），不用下划线

### 目录

- `_` 前缀 = 元数据 / 不修改（`_reference/`, `_pipeline/`, `_exploration/`, `_assets/`）
- 无前缀 = 主文档（`design-doc.md` 等）

## 版本管理

- **不**用 git LFS（资产太多，git 会变慢）
- 用**目录迭代** + **`selected/` 软链或复制**：
  ```
  C01_hero_brand/
    candidates/                  # 5 个原始候选
    selected/                    # 软链或复制选中的 1-2 个
      → candidates/c01_hero_a_pure-black-cosmic.png
  ```
- 跨 round 引用：用相对路径（不要绝对路径）

## 复用策略

- 选中的资产从 `_exploration/Cxx/` 复制（或软链）到 `_assets/`
- `_assets/` 里的文件**不被修改**（它是 archive / source of truth）
- 新一轮 C 引用上轮选中资产：作为 i2v / reference image
- 复用的资产**永远带上 source 注释**（在 D5 brand brief 或 design doc 里）

## 归档流程

每轮 C 结束：

1. 5 个候选保留在 `candidates/`
2. 选中的 1-2 个 → `selected/`
3. `selected/` 内容复制到 `_assets/` 对应子目录
4. 写 `learned.md`（一段话）
5. 更新 `Cxx_convergence/index.md`（如果有）

每轮 C 开始：

1. 检查上一轮的 `learned.md` → 调整这一轮的 master prompt
2. 检查上一轮的 `selected/` → 作为这一轮的 i2v input 或 reference

## 不在本规范内

- 多模态生图（见 B1）
- 视频（见 B2）
- 写代码时怎么引用资产（见 B6）
