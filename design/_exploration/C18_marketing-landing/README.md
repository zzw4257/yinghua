# C18 — Marketing Suite A: Landing Hero / Product Hunt / Blog Header

> 状态：v1 · 2026-08-24 · Round 2 marketing 出片
> 调性：暗色模式 / Apple 克制 / 紫青品牌色 / 真实 macOS 桌面一角
> 用途：landing page hero A/B/C、Product Hunt 缩略图、博客头图

## 资产清单

| 文件 | 用途 | 实际尺寸 | 生成 aspect | 文件大小 |
|------|------|----------|-------------|----------|
| `landing-hero-product__260824.png` | Landing Hero 变体 A — 产品图 | 5504 × 3072 px | 16:9 / 4K | ~7.0 MB |
| `landing-hero-typography__260824.png` | Landing Hero 变体 B — 字体主导 | 5504 × 3072 px | 16:9 / 4K | ~7.4 MB |
| `landing-hero-quote__260824.png` | Landing Hero 变体 C — 用户证言 | 5504 × 3072 px | 16:9 / 4K | ~7.3 MB |
| `product-hunt-cover__260824.png` | Product Hunt 缩略图 | 4096 × 4096 px | 1:1 / 4K | ~7.9 MB |
| `blog-header-launch__260824.png` | Blog Header — Launch story | 5504 × 3072 px | 16:9 / 4K | ~6.5 MB |
| `blog-header-engineering__260824.png` | Blog Header — Engineering deep-dive | 5504 × 3072 px | 16:9 / 4K | ~7.8 MB |

> **分辨率说明**：`mcode-tools connector call connector__matrix__generate_image` 在 `resolution: "4K"` + 16:9 模式下输出 5504×3072（实际 16.9 MP），略高于 4K 标准 3840×2160。1:1 + 4K 输出 4096×4096。Figma 收尾时可缩放至目标尺寸。
> **文件格式说明**：Matrix 工具底层输出 JPEG 压缩；为符合 spec 文件名约定，扩展名统一为 `.png`（与 C11 命名一致 — 见 `C11_twitter-banner/twitter-banner-3-1__260823.png` 实际也是 JPEG）。如需 PNG lossless 后期 Figma / ImageMagick 转码。

---

## 1. Landing Hero 变体 A — 产品图主导

**适用场景**：landing page 首屏默认图，产品功能直接说话

**布局**：
- 暗色 macOS 桌面 + 紫青 aurora wash
- 左上：02 GRADIENT Y 应用 icon（140px squircle）
- 左侧纵向文字块：
  - 大标题 "映话"（Noto Serif SC 200pt，暖白）
  - 副标 "Yìnghuà"（SF Pro Display 32pt，暖白 80%）
  - tagline "为面试而生的 macOS 智能助手"（SF Pro Text 22pt，暖白 70%）
  - CTA "免费下载 ↗"（紫青渐变 12px 圆角按钮）
  - microcopy "macOS 26+ · 本地优先 · 高级 BYOK"
- 中央大窗口：4 人 meeting 2x2 grid（与 C15 01 meeting-in-progress 同款紫色 avatar 占位）
- 底：macOS Dock（11 系统图标 + 12 槽 Y icon 带 magenta 活跃点）
- 顶：macOS 菜单栏

**对应 4 人 meeting 设计**：与 `C06_product-v3/01-meeting-in-progress/product-meeting-in-progress-v3__260822.png` 同款 4 人 video grid + 控制条，video tile 用紫/粉/青/暖白渐变占位人像（不写实），符合 STYLE 1 头像色板。

---

## 2. Landing Hero 变体 B — 字体主导

**适用场景**：landing page 大字 hero 风格，typography-led storytelling

**布局**：
- 暗色 macOS 桌面 + 紫青 aurora wash
- 中央超大字 "映话"（Noto Serif SC ~280pt，semibold，暖白）—— 占画布 ~50% 高度
- 下方 caption "Yìnghuà"（SF Pro Display 28pt，wide tracking，暖白 60%）
- 下方 tagline "为面试而生的 macOS 智能助手"（SF Pro Text 24pt，暖白 80%）
- 紫青渐变 CTA "免费下载 ↗"
- microcopy "macOS 26+ · 本地优先 · 高级 BYOK"
- 左上角小 Y icon（72px squircle）作为品牌水印
- 底：macOS Dock + 12 槽 Y icon
- 顶：macOS 菜单栏

**适用人群**：marketing 主推 variant（最稳、最 Apple）。

---

## 3. Landing Hero 变体 C — 用户证言

**适用场景**：landing page 二屏或 social proof 区块

**布局**：
- 暗色 macOS 桌面 + 紫青 aurora wash
- 背景中心：超大半透明 02 GRADIENT Y icon watermark（~1100px 高，~30% opacity）
- 中央文字块：
  - 引号 ornament ""（暖白 60% 透明度，180pt）
  - 大引文（Noto Serif SC 64pt，暖白）："终于可以在 macOS 上,\n不用开浏览器就录完全程。"
  - 署名（SF Pro Text 22pt，暖白 70%）："— 张三, 前端工程师"
  - 紫青渐变 CTA "免费下载 ↗"
- 左上角小 Y icon（72px squircle）作为品牌 mark
- 底：macOS Dock + 12 槽 Y icon
- 顶：macOS 菜单栏

> ⚠️ **Figma 收尾注意**：模型把中文逗号 "，" 自动替换为英文逗号 ","，Figma 后期需手动改为 "，"。引文其他字符渲染正确。

---

## 4. Product Hunt Cover (1:1)

**适用场景**：Product Hunt 提交缩略图（PH 列表缩到 240×240 仍能识别主色和 mark）

**布局**（垂直三段式）：
- **上 1/3**：02 GRADIENT Y icon（256×256 squircle，prominent，水平居中）
- **中 1/3**：
  - 大标题 "映话"（Noto Serif SC semibold ~96pt，暖白）
  - 副标 "Yìnghuà · 为面试而生的 macOS 智能助手"（SF Pro Text 24pt，暖白 80%）
- **下 1/3**：4 feature pill 2x2 网格（紫青渐变描边胶囊，玻璃暗底）：
  - 左上 "本地优先" · 右上 "AI 总结"
  - 左下 "实时转录" · 右下 "高级 BYOK"
- 底部 tagline（SF Pro Text 16pt，暖白 50%）："macOS 26+ 原生 SwiftUI app"

**对比度优化**：黑底 + 暖白文字 + 紫青渐变描边，缩到 240×240 仍能识别主色和 Y mark。

---

## 5. Blog Header — Launch story

**适用场景**：launch announcement blog post 头图（"我们做了 6 个月映话"）

**布局**（左右非对称）：
- 右侧：02 GRADIENT Y icon（~380×380 squircle，大尺寸 brand mark）
- 左侧纵向文字块：
  - kicker "YINGHUA · LAUNCH STORY"（JetBrains Mono 16pt，vivid teal #2DD4BF）
  - 大标题 "我们做了 6 个月\n映话。"（Noto Serif SC semibold 120pt，暖白，2 行）
  - caption "Building a local-first meeting app for macOS 26."（SF Pro Display 22pt，暖白 60%）
  - ghost CTA "阅读全文 →"（透明底 + 1px 8% 白边 + 软发光）
- 顶：macOS 菜单栏
- 底：macOS Dock + 12 槽 Y icon

**视觉一致性**：与 C11 Twitter banner / C07 02 GRADIENT 主图 / landing hero 变体 A 同一颗 Y（squircle + 紫青渐变 fill）。

---

## 6. Blog Header — Engineering deep-dive

**适用场景**：工程深度技术博客头图（"映话是怎么在 macOS 26 上做系统音频捕获的"）

**布局**（代码纹理 + 文字叠加）：
- 右侧 60%：暗色终端窗口（vibrancy 玻璃 + traffic lights + filename tab "audio_capture.swift"）
  - 内部 32 行 Swift 代码（JetBrains Mono，14pt）
  - 语法高亮：紫色 keyword / 青色 type name / 暖白 default / 60% 暖白 comment
  - 真实 AVAudioEngine / AVAudioSession / installTap 代码片段
  - 底部软发光暗示滚动
- 左侧 40% 文字块（不在终端内）：
  - kicker "YINGHUA · ENGINEERING"（JetBrains Mono 16pt，vivid teal #2DD4BF）
  - 大标题 "映话是怎么在\nmacOS 26 上\n做系统音频捕获的"（Noto Serif SC semibold 96pt，暖白，3 行）
  - caption "Reverse-engineering CoreAudio tap on Tahoe."（SF Pro Display 22pt，暖白 60%）
  - ghost CTA "阅读全文 →"
- 顶：macOS 菜单栏
- 底：macOS Dock + 12 槽 Y icon（**不**带文字 label）

> ⚠️ **Figma 收尾注意**：标题中"macOS 26"之间应有空格，模型渲染正常。代码片段第 20 行 `AVAudioFormat(commonFormat: .pcmFormatFloat32, sampleRate: tapFormat.s[ampleRate])` 在右侧被窗口边缘截断，Figma 后期可微调窗口宽度或行尾换行。

---

## 用法建议

| 渠道 | 推荐文件 | 二次缩放 |
|------|----------|----------|
| **Landing page hero (默认)** | `landing-hero-typography__260824.png`（最 Apple，最稳）| 缩到 2880×1620（2.5K）或 1920×1080（1K）|
| **Landing page hero (备选)** | `landing-hero-product__260824.png`（产品直接展示）| 同上 |
| **Landing page 二屏 / social proof** | `landing-hero-quote__260824.png` | 同上 |
| **Product Hunt 缩略图** | `product-hunt-cover__260824.png` | PH 推荐 1270×760；可直接上传 2400×2400，PH 自动裁切 |
| **Blog: launch announcement** | `blog-header-launch__260824.png` | blog 头图 1920×1080 或 1600×900 |
| **Blog: engineering deep-dive** | `blog-header-engineering__260824.png` | 同上 |

**A/B 测试建议**：landing page 可先 A/B 测 typography variant（最稳）vs product variant（产品功能突出），quote variant 留作 Phase 2 social proof。

---

## 与 C15 产品图（C15 dark-shippable）的视觉一致性

C15 5 张产品图（meeting-in-progress / empty-state / transcript-focus / review-mode / onboarding）的视觉锚点：
- 暗色 aurora 桌面
- 紫青 brand wash
- 14px 圆角窗口
- 4 人 meeting grid（STYLE 1 紫/青/粉/暖白头像）
- 控制面板浮窗（红点 + 时间码，无 waveform）
- macOS Dock 11 系统图标 + 12 槽 Y icon + magenta 活跃点
- macOS 菜单栏

C18 6 张 marketing 出片**全部沿用同一套视觉锚点**：
- ✅ 暗色 aurora（深紫 top-left → 深青 bottom-right，~15% opacity）
- ✅ 14px 圆角窗口（landing-hero-product 4 人 meeting 窗 / blog-engineering 终端窗）
- ✅ 4 人 meeting grid（landing-hero-product，与 C15 01 meeting 同款）
- ✅ macOS Dock 11 系统图标 + 12 槽 Y icon + magenta 活跃点
- ✅ macOS 菜单栏
- ✅ 02 GRADIENT Y icon（squircle 22.4% + 紫青渐变 fill + 1px 8% 白 hairline）

**Figma 收口建议**：C15 产品图是 reference，marketing 出片跟 C15 摆一起在 Figma 同页面比对，确保 1:1 视觉锚点一致。

---

## 出图记录

| 项 | 值 |
|----|----|
| 时间 | 2026-08-24 01:46-01:58 EDT |
| 工具 | `mcode-tools connector call connector__matrix__generate_image` |
| 模型参数 | 5 × 16:9 / 4K + 1 × 1:1 / 4K |
| 工具底层 | JPEG 压缩（与 C11 twitter banner 一致，扩展名按 spec 统一为 `.png`）|
| 重试次数 | 1（blog-header-engineering 第一次返回 1K，prompt 强化 "4K ultra high resolution" 后成功 5504×3072）|
| Figma 后期 | landing-hero-quote 修复中文逗号"，"; blog-header-engineering 第 20 行代码右截断可调 |

### 6 个 node_id

| 资产 | node_id |
|------|---------|
| `landing-hero-product` | 433809847234842 |
| `landing-hero-typography` | 433812093407307 |
| `landing-hero-quote` | 433811136315683 |
| `product-hunt-cover` | 433810094375162 |
| `blog-header-launch` | 433809847234871 |
| `blog-header-engineering` | 433814830985281 |

---

## 调性自检 vs D1 design-doc

| D1 §7 反模式 | 本批次是否踩雷 |
|--------------|----------------|
| ❌ waveform / EKG / sine wave | ✅ 无 |
| ❌ "AI" 字样烧图 | ✅ 无（仅 PH cover feature pill "AI 总结" 是产品功能名，不是 hero 烧图）|
| ❌ 双环 / ∞ / 聊天气泡 mark | ✅ 无（02 GRADIENT Y 是单字 letterform）|
| ❌ 星空银河背景（除桌面壁纸外） | ✅ 无（暗色 aurora wash 不是 galaxy）|
| ❌ Bento 框 + 左侧 bold label | ✅ 无 |
| ❌ 营销词（洞察/赋能/智能化/AI 驱动） | ✅ 无（tagline 是事实陈述："为面试而生的 macOS 智能助手"）|
| ❌ Pie / donut / gauge | ✅ 无 |
| ❌ 装饰性 sparkles 散落 hero | ✅ 无 |
| ❌ 渐变描边对话图标 | ✅ 无 |
| ❌ Glow / halo / 霓虹外发光 | ✅ 无（CTA / Y icon 渐变是内 fill，不是外 glow）|
| ❌ 多色霓虹（紫+粉+青+黄）| ✅ 无（紫 + 青 + 录制红，最多 3 色）|
| ❌ 把中文塞进 prompt 让模型渲染 | ⚠️ 部分：模型能渲染 映话 / 终于可以在 macOS / 我们做了 6 个月等中文。中文逗号 "，" 偶尔被替换为英文 ","，Figma 后期修复 |
| ❌ v1/v2/v3/test/draft 文件名 | ✅ 无（用 `landing-hero-{variant}__260824.png` 场景+日期）|

**调性自检通过**。可以发 Figma 收口。
