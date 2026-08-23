# C11 — Twitter Banner & Profile (映话 / Yinghua)

> 状态：v1 · 2026-08-23 · Round 2 marketing 资产
> 调性：暗色模式 / Apple 克制 / 紫青品牌色 / 真实 macOS 桌面一角

## 资产清单

| 文件 | 用途 | 实际尺寸 | 生成 aspect | 文件大小 |
|------|------|----------|-------------|----------|
| `twitter-banner-3-1__260823.png` | Twitter / X 头图 (banner) | 3168 × 1344 px | 21:9（最接近 3:1） | ~1.9 MB |
| `twitter-profile-1-1__260823.png` | Twitter / X 头像 (profile) | 2048 × 2048 px | 1:1 | ~1.7 MB |

> **Aspect ratio 说明**：Twitter 官方推荐 banner 尺寸 1500 × 500（3:1）。`mcode-tools connector` 的 `generate_image` enum 仅支持 `1:1 / 16:9 / 9:16 / 4:3 / 3:4 / 21:9`，**3:1 不在选项内**。本批次 banner 用 `21:9`（2.33:1）出图，是 3:1（3.0:1）之前最宽的可用 aspect。Figma 收尾时把 3168×1344 **上下各裁 144 px → 3168×1056 → 缩放到 1500×500** 即可得到完美 3:1。重要内容（Y icon / "Yinghua" / 映话 / tagline）都在垂直中央，裁切安全。

---

## 1. Twitter Banner（3:1 = 1500×500）

**位置**：profile 顶部 hero banner，桌面端全宽 / 移动端下边缘被头像遮

**左 1/3 — macOS 桌面一角**：
- 暗色 aurora 壁纸（深紫 → 青）
- macOS Dock 底部一截（5 个系统图标 + 紫青 Y 应用图标带 magenta 活跃点）
- 主窗口一角：交通灯按钮（红黄绿）+ 文件卡（紫色 Y file icon + Open pill）
- ⚠️ 故意不画出完整窗口，暗示「截到了一角真实 macOS 使用场景」

**中 1/3 — 品牌 mark + 名称**：
- 02 GRADIENT Y icon（120px squircle 容器，对应 C07 app-icon-v3b）
- "**Yinghua**" — SF Pro Display Bold 64pt 等效，暖白 #F4F1EC
- "**映话**" — Noto Serif SC 24pt 等效，暖白 #F4F1EC（模型本次渲染正常，Figma 后期可微调）

**右 1/3 — 标语 + tagline**：
- "**Local-first meeting intelligence for Mac.**" — SF Pro Text 18pt 等效，暖白 90% opacity
- "**Record · Transcribe · Summarize**" — JetBrains Mono 14pt 等效，**紫→青渐变文字填充**（vivid 紫 #B57BFF → vivid 青 #2DD4BF）

**背景**：整张 banner 是连续暗色底，#0A0A0F + 紫青 aurora wash，让左边的 macOS 桌面自然过渡到中间的暗色中心区。

---

## 2. Twitter Profile（1:1 = 400×400 显示圆形）

**位置**：profile 头像，Twitter 自动裁切为圆形显示

**内容**：
- 暗色背景 #0A0A0F（带极淡紫青 aurora radial wash）
- 中央圆形 mark（占画布 85%），暗色玻璃 + 紫青 aurora tint + 1px 白 8% hairline
- 圆形内 02 GRADIENT Y 居中（占圆 60% 高），紫→青渐变 Y
- **无文字**：纯品牌 mark，**不是 marketing banner**

**为什么不出文字**：Twitter 头像在 timeline 里只有 ~48px 显示，文字永远糊掉。Profile 只做识别用，文案交给 banner + bio。

---

## Twitter 发布建议

### Profile（头像）
- 直接上传 `twitter-profile-1-1__260823.png`（1:1）
- Twitter 自动圆形裁切，**image 内已经是圆形构图**所以裁切不会损失内容

### Banner（头图）
- Twitter 推荐尺寸 1500 × 500；**手机端 profile 头像会遮住左下角约 200×200**
- Figma 收尾后上传 `twitter-banner-3-1__260823.png`（已上下裁切到 3:1）
- 重要内容（Y / Yinghua / 映话 / tagline）都在中央 1/3 — 即使头像遮左下也不影响

### Bio 文案（≤160 字符）

> **映话 Yinghua** · Local-first meeting intelligence for Mac.
> Record · Transcribe · Summarize — all on-device.
> macOS 26 · SwiftUI · BYOK
> 🇨🇳 杭州 / 远程

或者更简洁版：

> Local-first meeting intelligence for Mac. 映话
> Record meetings · Live transcript · AI summary
> macOS 26+ · Apple Silicon · BYOK

### Pinned tweet 建议

> 🎙️ 映话 0.1 — 我们把 macOS 26 录屏 + 实时转录 + AI 总结做成一个本地优先的 app。
> 系统音频 + mic 录制 · 说话人分离 · 关键时刻 / 决定 / 待办
> ⌘+R 一键开始，不上传原始音频。
> DM 我拿测试资格 🙏

---

## 跟 C07 02 GRADIENT 的连贯性

C11 banner 和 profile 都使用 C07 app-icon-v3 的 **02 GRADIENT** 变体作为品牌 mark，跟 landing hero / Product Hunt 缩略图 / 投资人 deck 第一页 **同一颗 Y**：

| 场景 | 用 C07 哪个 icon |
|------|-----------------|
| App icon (.icns) / Dock / Finder / App Store | 01 MINIMAL（黑底白 Y） |
| **Twitter banner** | **02 GRADIENT（本批）** |
| **Twitter profile** | **02 GRADIENT（本批）** |
| Landing hero | 02 GRADIENT |
| Product Hunt 缩略图 | 02 GRADIENT |
| 营销邮件 | 02 GRADIENT |
| 投资人 deck 第一页 | 02 GRADIENT |
| Onboarding 欢迎页 mark | 01 MINIMAL（跟主 icon 一致） |

也就是说：用户从 Twitter 看到的是紫青 Y 点亮 → landing page 也是紫青 Y 点亮 → 下载后 Dock / Finder 看到的是黑底白 Y（01 MINIMAL）。**两种 Y 是同一个 letterform，只是 fill 不同**（白 vs 紫青渐变），brand identity 永远一致。

---

## 出图记录

| 项 | 值 |
|----|----|
| 时间 | 2026-08-23 01:31-01:35 EDT |
| 工具 | `mcode-tools connector call connector__matrix__generate_image` |
| 模型参数 | banner: aspect 21:9 / 2K; profile: aspect 1:1 / 2K |
| Banner node_id | 433806832427175 |
| Profile node_id | 433808055148639 |
| 下载方式 | `mcode-tools get-asset-url` → `wget -q` |
| 重试次数 | 0（一次成功）|
| Figma 后期 | banner 需裁切 3168×1344 → 3168×1056 → 缩放 1500×500；profile 直接上传 |

### Banner prompt 摘要
宽 3:1 暗色 Twitter banner，三段式：左 1/3 macOS 桌面一角（含 dock + 主窗口一角 + 文件卡），中 1/3 Y icon + "Yinghua" + "映话"，右 1/3 "Local-first meeting intelligence for Mac." + "Record · Transcribe · Summarize" 渐变文字。紫青品牌色，严格禁用 waveform / EKG / AI 烧图 / cyberpunk / 装饰 sparkles。

### Profile prompt 摘要
1:1 方形头像，正中圆形 brand mark（暗玻璃 + 紫青 aurora tint + 1px 8% 白边 hairline），圆心 Y 占 60% 高，Y 是紫→青渐变。无文字，无 logo 名称，无营销词。Apple-grade 极简。

---

## 调性自检 vs D1 design-doc

| D1 §7 反模式 | 本批次是否踩雷 |
|--------------|----------------|
| ❌ waveform / EKG / sine wave | ✅ 无 |
| ❌ "AI" 字样烧图 | ✅ 无（tagline 是 "Local-first meeting intelligence for Mac."，没说 "AI"） |
| ❌ 双环 / ∞ / 聊天气泡 mark | ✅ 无（Y 是单字 letterform） |
| ❌ 星空银河背景（除桌面壁纸外） | ✅ 无（profile 极淡 wash 不是 galaxy） |
| ❌ Bento 框 + 左侧 bold label | ✅ 无 |
| ❌ 营销词（洞察/赋能/智能化/AI 驱动） | ✅ 无 |
| ❌ Pie / donut / gauge | ✅ 无 |
| ❌ 装饰性 sparkles 散落 hero | ✅ 无 |
| ❌ 渐变描边对话图标 | ✅ 无 |
| ❌ Glow / halo / 霓虹外发光 | ✅ 无 |
| ❌ 多色霓虹（紫+粉+青+黄）| ✅ 无（只有紫+青+REC 红） |
| ❌ v1/v2/v3/test/draft 文件名 | ✅ 无（用 `twitter-banner-3-1__260823.png` 场景+日期） |

**调性自检通过**。可以发 Figma 收口。
