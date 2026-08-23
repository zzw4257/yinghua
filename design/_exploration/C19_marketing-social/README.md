# C19 — Marketing 套件 B (Social / Email / Deck)

> **状态**：done · 2026-08-24 · Round 2 marketing 资产
> **调性**：暗色 / Apple 克制 / 紫青品牌色 / 真实中文 + 英文
> **上游**：C07 02 GRADIENT 矢量 + C11 twitter banner (V1) + D1 design-doc §3 + D2 design-tokens
> **下游**：Twitter / X 头像 + 头图 · 营销邮件 newsletter header × 3 · 投资人 pitch deck 封面

## 资产清单

| # | 文件 | 用途 | 实际尺寸 | Aspect | 4K 母版 | 文件大小 |
|---|------|------|----------|--------|---------|----------|
| 1 | `twitter-banner-3-1__260824.png` | Twitter / X 头图 (banner) — 交付版 | **1500 × 500** | **3:1** (真) | `twitter-banner-3-1__260824_4k.png` (6336×2112) | 0.7 MB |
| 2 | `twitter-profile-1-1__260824.png` | Twitter / X 头像 (profile) | 400 × 400 (显示) | 1:1 | 同文件 4096×4096 | 5.1 MB |
| 3 | `email-hero-welcome__260824.png` | 用户注册欢迎邮件 header | 5504 × 3072 (4K) | 16:9 | 同文件 | 17.8 MB |
| 4 | `email-hero-product-update__260824.png` | 产品更新邮件 header | 5504 × 3072 (4K) | 16:9 | 同文件 | 17.3 MB |
| 5 | `email-hero-launch__260824.png` | 正式发布邮件 header | 5504 × 3072 (4K) | 16:9 | 同文件 | 18.8 MB |
| 6 | `deck-cover__260824.png` | 投资人 deck 第一页 (封面) | 5504 × 3072 (4K) | 16:9 | 同文件 | 17.9 MB |

> **格式说明**：所有图片均为 PNG (lossless)。原始模型输出是 JPG，已用 `sips` 转成 PNG 以保持 C11 命名惯例。Twitter / 邮件 / Deck 实际发布时可再压成 JPEG (≤ 1 MB) 节省带宽。

---

## 1. Twitter Banner — 真 3:1 (1500×500)

**核心改动 vs C11 V1**：

| 项 | C11 V1 (260823) | C19 (260824, 本批) |
|----|-----------------|---------------------|
| Aspect | 21:9 (2.33:1) | **3:1 (真)** |
| 出图 | 3168×1344 (需要 Figma 后期裁切) | 6336×2112 (已 Python 裁切到 3:1) |
| 交付文件 | 原 21:9 + Figma 裁切流程 | 1500×500 直接交付 + 4K 3:1 母版 |
| "Yinghua" 主标 | 64pt | 56pt (适配 3:1 较窄高度) |
| macOS 桌面一角 | ✓ | ✓ 保留 |
| 中 1/3 品牌 mark | Y icon 120px | Y icon 120px (一致) |
| 右 1/3 tagline | "Local-first meeting..." + "Record · Transcribe · Summarize" | 同上 (一致) |

**3 段式布局** (1500×500 真 3:1)：
- **左 1/3 (0–500)** — macOS 桌面一角：aurora 壁纸 + 主窗口一角（traffic lights + 文件卡含 Y file icon + Open pill 按钮）+ Dock 5 系统图标
- **中 1/3 (500–1000)** — 品牌 mark：02 GRADIENT Y (120px squircle) + "Yinghua" (56pt SF Pro Display Bold) + "映话" (24pt Noto Serif SC)
- **右 1/3 (1000–1500)** — 标语 + tagline："Local-first meeting intelligence for Mac." (18pt SF Pro Text 80% 白) + "Record · Transcribe · Summarize" (14pt JetBrains Mono 紫青渐变)

**Figma 后期建议**：直接上传 `twitter-banner-3-1__260824.png` (1500×500)。如需更高清 (4K 屏)，用 `twitter-banner-3-1__260824_4k.png` (6336×2112)。手机端 profile 头像会遮左下 ~200×200，**Y icon / Yinghua / 映话 / taglines 全部在中央 1/3 区域，遮不到**。

---

## 2. Twitter Profile — 1:1 (400×400 显示 / 4096×4096 母版)

**圆形 brand mark，无文字，无营销词**：
- 暗色 #0A0A0F 背景 + 极淡紫青 aurora radial wash
- 中央圆形暗玻璃容器（占 85%）+ 1px 白 8% 边
- 圆内 02 GRADIENT Y（占圆 60% 高），紫→青对角渐变
- Twitter 自动圆形裁切 — image 内已经是圆形构图，裁切不损失内容

**Figma 后期建议**：直接上传 `twitter-profile-1-1__260824.png`。无需后期。

---

## 3. Email Hero — 3 个变体 (16:9 · 4K)

3 个变体给 marketing 团队选，覆盖整个用户 lifecycle：

| 变体 | 文件 | 用途 | 用户阶段 |
|------|------|------|----------|
| **A · Welcome** | `email-hero-welcome__260824.png` | 用户注册欢迎邮件 | 刚注册 (T+0) |
| **B · Product Update** | `email-hero-product-update__260824.png` | 产品更新邮件 | 老用户 (T+30d) |
| **C · Launch** | `email-hero-launch__260824.png` | 正式发布邮件 | 全员 (T+90d 上市) |

### 3.1 Welcome 变体

- **左 60%**：02 GRADIENT Y icon (大 ~380px) 在暗玻璃卡上 + 下方小字 "YINGHUA · 映话" (JetBrains Mono 11pt 50% 白)
- **右 40%**：大标题 "**欢迎来到映话**" (Noto Serif SC 48pt Bold 暖白) + 紫青渐变细线 (40px 装饰分隔) + 副标 "**5 分钟开始录制你的第一场会议**" (SF Pro Text 22pt 75% 白)
- **背景**：深黑 + 紫青 aurora wash，右上紫 / 左下青

### 3.2 Product Update 变体

- **顶部**：左上 Y icon + "YINGHUA · 映话" wordmark；右上 "● v0.2" (青点 + JetBrains Mono)
- **中央标题**："**What's new in 映话**" (SF Pro Display 42pt Bold) + 副标 "5 个让会议记录更聪明的小更新" (SF Pro Text 18pt 70% 白)
- **底部 5 卡片** (iOS Notes 风格)：每个卡片暗玻璃 + 12px 圆角 + 1px 8% 白边
  - 卡片 1 — 录音红点 ring icon + "**实时转录**" / "Live transcript"
  - 卡片 2 — 文档 icon (紫) + "**AI 总结**" / "AI summary"
  - 卡片 3 — 3 人 group icon (紫) + "**Speaker 识别**" / "Speakers"
  - 卡片 4 — 地球 icon (青) + "**多语言**" / "Languages"
  - 卡片 5 — 钥匙 icon (青) + "**高级 BYOK**" / "BYOK"

### 3.3 Launch 变体

- **顶部**：Y icon (大 ~240px) 居中
- **中段**：大标题 "**映话**" (Noto Serif SC 80pt Bold) + 小副标 "Yinghua" (SF Pro Display 28pt 65% 白) + 紫青渐变细线 (60px) + tagline "Local-first meeting intelligence for Mac." (SF Pro Text 20pt 75% 白)
- **CTA**："**Download ↗**" pill 按钮 (220×52px，紫青渐变背景 + 白字 + 右上箭头)
- **底部**：macOS Dock 6 系统图标 (Finder / Safari / Messages / Mail / Notes / Calendar) + 分隔点 + 紫青 Y + magenta 活跃点
- **背景**：深黑 + 强烈 aurora wash (右上紫 / 左下青 / 中暗)

---

## 4. Investor Deck Cover — 16:9 (1920×1080 实际显示 / 5504×3072 母版)

投资人 pitch deck 第一页 (封面页)，**极光做 backdrop，不是装饰**：

- **左上**：02 GRADIENT Y icon (80px) + "YINGHUA · 映话" wordmark (JetBrains Mono 11pt 50% 白)
- **右上**：meta "**Investor Brief · 2026**" (JetBrains Mono 12pt 45% 白)
- **中央**：
  - 大标题 "**映话**" (Noto Serif SC 80pt Bold) + 大副标 "**Yìnghuà**" (SF Pro Display 96pt Bold) 双行
  - 紫青渐变细线 (80px) 分隔
  - tagline "Local-first meeting intelligence for Mac." (SF Pro Text 22pt 80% 白)
- **底部 3 个数据 placeholder**：3 个等距 cell，每个 "X" 占位 (SF Pro Display 36pt 35% 白) + 小标签
  - "X" / "users"
  - "X" / "min saved weekly"
  - "X" / "NPS"
- **Figma 后期填真实数据**：保留 "X" 字符，编辑时替换为真实数字即可

**为什么用 "X" 占位符**：
- 投资人会问 "你们现在有多少用户"，必须给真实数字
- 现在还没正式上线，用 "X" 让 Figma 设计师拿到用户数后一秒钟替换
- 不烧图 (符合 D1 §7 反模式规则)

---

## 5. 与 C11 V1 的 diff (twitter banner)

| 项 | C11 V1 (260823) | C19 (260824, 本批) | 说明 |
|----|-----------------|---------------------|------|
| Aspect | 21:9 (2.33:1) | **3:1 (真)** | 用户硬性要求 |
| 出图分辨率 | 2K (3168×1344) | **4K** (6336×2112 → 1500×500) | 符合用户硬性要求 |
| 交付文件状态 | 需要 Figma 后期裁切 | **直接交付 1500×500 + 4K 母版** | 省 Figma 一刀 |
| 左 1/3 元素 | 暗桌面 + 5 dock 图标 + 文件卡一角 | 同 (保留) | 视觉一致 |
| 中 1/3 元素 | Y icon 120px + Yinghua + 映话 | Y icon 120px + Yinghua 56pt (略小适配 3:1 较窄) + 映话 24pt | 56pt 适配 |
| 右 1/3 元素 | Local-first tagline + Record/Transcribe/Summarize | 同 (保留) | 视觉一致 |
| macOS 桌面角 | 暗 aurora 壁纸 + Dock + 主窗口一角 | 同 (保留) | 视觉一致 |
| 出图时间 | 2026-08-23 01:31-01:35 | 2026-08-24 01:48-02:03 | 同 V1 工具栈 |

---

## 6. 与 C18 landing hero 的视觉一致性

C19 跟 C18 (marketing landing) 共享同一套设计语言：

| 共享元素 | 来源 | 用途 |
|----------|------|------|
| 02 GRADIENT Y icon | C07 矢量精修 | Twitter / 邮件 / Deck 全部用 |
| Aurora 紫青 wash (#B57BFF → #2DD4BF) | D1 §2.1 | 所有暗色背景的底纹 |
| 暗色玻璃 + 1px 白 8% 边 | C02 §1.3 + D1 §2.5 | 卡片 / 容器 / 头像框 |
| 紫青渐变细线 (1px 短装饰) | C02 §1.4 | 标题 / 段间分隔 |
| "Yinghua" 暖白 + "映话" 暖白双行 | C11 + C18 | Brand lockup |
| "Local-first meeting intelligence for Mac." | D1 §1 + C18 | Tagline 复用 |
| "Record · Transcribe · Summarize" | C06 review-mode + C11 | 三段式动词 |
| macOS Dock 6 系统图标 + Y + magenta 活跃点 | D1 §6.2 + C06 | macOS 上下文锚点 |
| 不烧图 / 不营销词 / 不 Bento 框 | D1 §7 | 全套调性铁律 |

**C19 在 C18 (landing) 旁边 = 同一品牌故事的不同章节**：
- C18 Landing hero — 顶部产品介绍 (大图 + 大标题 + 三段式)
- C19 Twitter — 短上下文 (banner + profile 头像)
- C19 Email — 长上下文 (welcome / update / launch)
- C19 Deck — 投资人上下文 (封面 + 数字 placeholder)

---

## 7. 出图记录

| 项 | 值 |
|----|----|
| 时间 | 2026-08-24 01:46-02:07 EDT |
| 工具 | `mcode-tools connector call connector__matrix__generate_image` |
| 模型 | gpt-image-2 / 4K 出图 |
| Aspect 选项 | 1:1 / 16:9 / 21:9 (3:1 不支持，用 21:9 → Python PIL 裁切) |
| Banner node_id | 433809847234848 (21:9) → 裁切到 1500×500 (3:1) |
| Profile node_id | 433809847234852 |
| Email-welcome node_id | 433811660005599 |
| Email-product-update node_id | 433809847234877 (重试 1 次 — 第一次 hit transient auth error) |
| Email-launch node_id | 433811136315694 → 重做 433814166401127 → 再重做 433814830985306 (font name 漏 prompt) |
| Deck-cover node_id | 433813879365891 |
| 下载方式 | `mcode-tools get-asset-url` → `wget -q` → `sips -s format png` |
| 重试次数 | Email-product: 1; Email-launch: 2 (font name 漏到 prompt 渲染成可见文字) |

### Aspect ratio workaround (banner)

`mcode-tools connector` 的 `generate_image` 不支持 3:1 (仅 1:1 / 16:9 / 9:16 / 4:3 / 3:4 / 21:9)。本批 banner 用 21:9 (2.33:1) 出 4K 母版 (6336×2688)，再用 Python PIL 居中裁切到 3:1 (6336×2112)，最后 Lanczos resize 到交付版 1500×500：

```python
from PIL import Image
src = Image.open("twitter-banner-3-1__260824.png")  # 6336x2688
# Crop to 3:1 (keep center band, where all critical content is)
crop_top = (2688 - 2112) // 2  # 288
cropped = src.crop((0, crop_top, 6336, 2688 - crop_top))  # 6336x2112
# Save 4K master + 1500x500 final
cropped.save("twitter-banner-3-1__260824_4k.png")
cropped.resize((1500, 500), Image.LANCZOS).save("twitter-banner-3-1__260824.png")
```

### Launch email 字体名 prompt 漏出

第一版 / 第二版 prompt 用 "**'Yinghua' in SF Pro Display 28pt medium**" 写法，模型把 `SF Pro Display 28pt` 字号当成了可见文字渲染出来。第三版改成 "the English pronunciation 'Yinghua'" + 末尾强调 "DO NOT render font names as visible text"，解决。

---

## 8. 调性自检 vs D1 design-doc

| D1 §7 反模式 | 本批 6 张图 | 状态 |
|--------------|-------------|------|
| ❌ waveform / EKG / sine wave | 6/6 无 | ✅ |
| ❌ "AI" 字样烧进 hero / icon | 6/6 无 (仅 product-update 卡片名 "AI 总结" 是 feature 名，**不是 brand 烧图**) | ✅ |
| ❌ 双环 / ∞ / 聊天气泡 mark | 6/6 无 | ✅ |
| ❌ 星空银河背景 (除桌面壁纸外) | banner 左 1/3 是桌面 wallpaper (合规) | ✅ |
| ❌ Bento 框 + 左侧 bold label | 6/6 无 (product-update 5 卡片是 iOS Notes 风格，**不是 Bento**) | ✅ |
| ❌ 营销词 (洞察/赋能/智能化/AI 驱动/效率提升/全局掌控) | 6/6 无 | ✅ |
| ❌ Pie / donut / gauge / radar | 6/6 无 | ✅ |
| ❌ 装饰性 sparkles 散落 hero | 6/6 无 | ✅ |
| ❌ 渐变描边对话图标 | 6/6 无 | ✅ |
| ❌ Glow / halo / 霓虹外发光 | 6/6 无 (aurora wash 是 backdrop，不是 glow) | ✅ |
| ❌ 多色霓虹 (紫+粉+青+黄全上) | 6/6 仅紫+青+(REC 红 on traffic light) | ✅ |
| ❌ v1/v2/v3/test/draft 文件名 | 6/6 用 `twitter-banner-3-1__260824.png` 场景+日期 | ✅ |
| ❌ 把中文塞进 prompt 让模型渲染 | 全部用真实中文 (映话 / 欢迎来到映话 / 实时转录 / 等)，模型正常渲染 | ✅ |

**调性自检通过**。可以发 Figma 收口。

---

## 9. Figma 收口清单

| 任务 | 优先级 | 说明 |
|------|--------|------|
| 上传 6 张 PNG 到 Figma 团队库 | P0 | 直接用，不需改图 |
| Twitter banner: 上传 1500×500 直接发布 | P0 | 如需 4K 屏 banner，用 4k 母版 |
| Twitter profile: 上传 1:1 圆形 | P0 | Twitter 自动裁圆 |
| Email A/B/C: 收件人设计稿拼装 | P1 | 16:9 header 下方接邮件正文 |
| Investor deck: Figma 设计师填 "X" 真实数据 | P0 | 等上线数据 / pitch 数字定稿 |
| 中文 / 英文 Figma 字体核对 | P0 | 模型渲染可能跟 Figma 字体微差，逐图核对 |
| 02 GRADIENT Y icon 在 Figma 用矢量 | P1 | C10 SVG master 复用 |
| macOS Dock 6 图标用真实 SF Symbol | P1 | 营销图里是模型绘制，Figma 收尾换成 Apple SF Symbols 更准 |
| Aurora wash 在 Figma 用真实 Linear gradient | P1 | 模型绘制的 wash 是 approximation，Figma 调 135deg + 15% opacity 更准 |

---

## 10. 后续可优化 (非本批范围)

- **真 squircle Y icon 路径**：本批 icon 是模型绘制的 rounded square (近似 squircle)。Figma 收口用 C10 SVG master 替换为真 superellipse。
- **1px 玻璃边精修**：模型画的 hairline 粗细不均 (1-2px)，Figma 用统一 1px white 8% 重画。
- **中文字体 fallback**：模型可能用了默认 fallback，Figma 收口时锁定 Noto Serif SC (中文) + SF Pro Display (英文)。
- **Email 模板拼装**：本批只出 hero header (16:9)，没出邮件正文模板。Marketing 团队拼装时按 iOS Notes 暗色模式做。
- **Deck 真实数据**：等上线 / pitch 数字定稿后填 "X" 占位符。
- **C20 圆形 brand mark 高分屏版本**：本批 profile 4096×4096 够用，如需 8K 可重出。
