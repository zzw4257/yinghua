# C26 — 映话 (Yìnghuà) Social Media Template Library

> **状态**：done · 2026-08-24
> **调性**：暗色 / Apple 克制 / 紫青品牌色 / 真实中文 + 英文
> **覆盖**：4 平台（Twitter / Instagram / LinkedIn / 微信公众号）× 多尺寸 = 19 张交付图 + 3 张 4K 母版
> **上游**：C07 02 GRADIENT 矢量 + C18 / C19 marketing visual anchors + D1 design-doc §3 / §7 + D2 design-tokens

## 资产总览（19 张交付 + 3 张 4K 母版）

| # | 文件 | 平台 | 实际尺寸 | Aspect | 用法 |
|---|------|------|----------|--------|------|
| 1 | `twitter/twitter-launch__260824.png` | Twitter / X | 4096 × 4096 | 1:1 | Launch announcement card |
| 2 | `twitter/twitter-feature__260824.png` | Twitter / X | 4096 × 4096 | 1:1 | Feature highlight (实时转录) |
| 3 | `twitter/twitter-quote__260824.png` | Twitter / X | 4096 × 4096 | 1:1 | Customer quote |
| 4 | `instagram/instagram-launch__260824.png` | Instagram feed | 4096 × 4096 | 1:1 | Launch announcement post |
| 5 | `instagram/instagram-feature__260824.png` | Instagram feed | 4096 × 4096 | 1:1 | Feature highlight (AI 总结) |
| 6 | `instagram/instagram-quote__260824.png` | Instagram feed | 4096 × 4096 | 1:1 | Customer quote |
| 7 | `instagram/instagram-story-launch__260824.png` | Instagram Story | 3072 × 5504 | 9:16 | Launch announcement story |
| 8 | `instagram/instagram-story-feature__260824.png` | Instagram Story | 3072 × 5504 | 9:16 | Feature highlight (高级 BYOK) |
| 9 | `instagram/instagram-story-quote__260824.png` | Instagram Story | 3072 × 5504 | 9:16 | Customer quote story |
| 10 | `linkedin/linkedin-post-company__260824.png` | LinkedIn post | 5504 × 3072 | 16:9 | Company intro / brand awareness |
| 11 | `linkedin/linkedin-post-product__260824.png` | LinkedIn post | 5504 × 3072 | 16:9 | Product feature / launch |
| 12 | `linkedin/linkedin-post-hiring__260824.png` | LinkedIn post | 5504 × 3072 | 16:9 | Hiring post |
| 13 | `linkedin/linkedin-banner-company__260824.png` | LinkedIn page banner | **1584 × 396** | 4:1 | Company page banner |
| 14 | `linkedin/linkedin-banner-product__260824.png` | LinkedIn page banner | **1584 × 396** | 4:1 | Product launch banner |
| 15 | `linkedin/linkedin-banner-hiring__260824.png` | LinkedIn page banner | **1584 × 396** | 4:1 | Hiring banner |
| 16 | `linkedin/linkedin-banner-company__260824_4k.png` | LinkedIn page banner | 6336 × 1584 | 4:1 | **4K 母版** — 高分屏使用 |
| 17 | `linkedin/linkedin-banner-product__260824_4k.png` | LinkedIn page banner | 6336 × 1584 | 4:1 | **4K 母版** — 高分屏使用 |
| 18 | `linkedin/linkedin-banner-hiring__260824_4k.png` | LinkedIn page banner | 6336 × 1584 | 4:1 | **4K 母版** — 高分屏使用 |
| 19 | `wechat/wechat-intro__260824.png` | 微信公众号 / 其他 | 5504 × 3072 | 16:9 | 介绍 / 科普 cover |
| 20 | `wechat/wechat-tutorial__260824.png` | 微信公众号 / 其他 | 5504 × 3072 | 16:9 | 教程 / how-to cover |
| 21 | `wechat/wechat-update__260824.png` | 微信公众号 / 其他 | 5504 × 3072 | 16:9 | 产品更新 / changelog cover |
| 22 | `wechat/wechat-hiring__260824.png` | 微信公众号 / 其他 | 5504 × 3072 | 16:9 | 招聘 / jobs cover |

> **总说明**：Twitter 1:1 / IG 1:1 / IG 9:16 / LI 4:1（已被 LinkedIn 官方 1584×396 文档锁定）/ LI post 1200×627（用 16:9 替代）/ WeChat 16:9，4 平台 × 3-4 主题。LinkedIn banner 4:1 不是 4K 模型原生比例（仅 1:1 / 16:9 / 9:16 / 4:3 / 3:4 / 21:9 可用），本批用 21:9 出 4K 母版，Python PIL 居中裁切到 4:1（详见 §5 出图记录）。

---

## 1. 按平台分类

### 1.1 Twitter / X（3 张 · 1:1）

| 文件 | 主题 | 元素 |
|------|------|------|
| `twitter-launch__260824.png` | Launch | 大 Y icon + Yinghua + 映话 + 紫青渐变细线 + 映话 · 来了 + 立即下载 ↗ CTA |
| `twitter-feature__260824.png` | Feature | 左上小 Y + 实时转录卡（红点 + 00:12 + 3 行淡化文字）+ 实时转录 · 说话人自动分离 + Live transcript · automatic speaker labels |
| `twitter-quote__260824.png` | Quote | 左上小 Y + 装饰性 " 开口引号 + 「终于可以在 macOS 上，不用开浏览器就录完全程。」 + 紫青细线 + —— 张三，前端工程师 |

### 1.2 Instagram（6 张 = 3 feed 1:1 + 3 story 9:16）

| 文件 | 主题 | 元素 |
|------|------|------|
| `instagram-launch__260824.png` (feed) | Launch | 大 Y icon + 映话 + Yinghua + 映话 · 终于来了 + 立即下载 ↗ CTA + macOS 26+ · 本地优先 · 高级 BYOK microcopy |
| `instagram-feature__260824.png` (feed) | Feature | 左上小 Y + 暗玻璃卡（Summary · 总结 + 3 bullet 渐变点：决定 / 待办 / 遗留）+ AI 总结 · 一目了然 + AI summary · decisions, todos, open questions |
| `instagram-quote__260824.png` (feed) | Quote | 左上小 Y + 装饰性 " 开口引号 + 「面试全程自动转录，最后 AI 直接给我要点。」 + 紫青细线 + —— 李四，后端工程师 |
| `instagram-story-launch__260824.png` (story) | Launch | 大 Y icon（垂直占位）+ 映话 / Yinghua + 终于来了 + 立即下载 ↗ CTA + macOS 26+ · 本地优先 |
| `instagram-story-feature__260824.png` (story) | Feature | 左上小 Y + 高级 BYOK 设置卡（BYOK · 自备 API Key + 3 row: OpenAI / Anthropic / Storage Path，每行带 ✓ 点）+ 高级 BYOK · 数据完全本地 + Bring your own key. Everything stays local. |
| `instagram-story-quote__260824.png` (story) | Quote | 左上小 Y + 装饰性 " 引号 + 「终于可以在 macOS 上，不用开浏览器就录完全程。」 + 紫青细线 + 张三，前端工程师 + 映话 · Yinghua 底部签名 |

### 1.3 LinkedIn（6 张 = 3 post 16:9 + 3 banner 4:1 + 3 4K 母版）

| 文件 | 主题 | 元素 |
|------|------|------|
| `linkedin-post-company__260824.png` | Company | 大 Y icon + 映话 + Yinghua + 紫青细线 + "Local-first meeting intelligence for Mac." + "为面试而生的 macOS 智能助手" + 4 feature pill（本地优先 / AI 总结 / 实时转录 / 高级 BYOK）|
| `linkedin-post-product__260824.png` | Product | 左上小 Y + "实时转录 · AI 总结" + 紫青细线 + "Record once. Get transcript, summary, todos." + 3 bullet（录音中实时生成文字稿 / 自动识别说话人 / 关键决定 / 待办 / 遗留问题一眼可见）+ 右侧暗玻璃 summary 卡（Key decision / Action item / Open question，渐变 100% → 70% → 40% 透明度）|
| `linkedin-post-hiring__260824.png` | Hiring | 左上小 Y + 我们正在招人 · 远程优先 + 紫青细线 + "Hiring · remote-first" + 3 bullet（资深 macOS 工程师 / AI 应用工程师 / 设计师）+ 右侧"查看职位 ↗" CTA |
| `linkedin-banner-company__260824.png` (4:1) | Company | 左 Y + 映话 \| Yinghua + "Local-first meeting intelligence for Mac." + "Record · Transcribe · Summarize" |
| `linkedin-banner-product__260824.png` (4:1) | Product | 左 Y + "实时转录 · AI 总结 · 高级 BYOK" + "Record once. Get transcript, summary, todos." + "免费下载 ↗" CTA |
| `linkedin-banner-hiring__260824.png` (4:1) | Hiring | 左 Y + "映话 · 招人 · 远程优先" + "We are hiring · remote-first" + "查看职位 ↗" CTA |
| `linkedin-banner-*__260824_4k.png` | — | 3 张 4K 母版，4:1 比例 6336×1584，高分屏 / Retina banner 用 |

### 1.4 微信公众号 / 其他（4 张 · 16:9）

| 文件 | 主题 | 元素 |
|------|------|------|
| `wechat-intro__260824.png` | 介绍 | 大 Y icon + 映话是什么 + 紫青细线 + "一篇 5 分钟读懂的映话入门指南" + "映话 · Yinghua" 签名 |
| `wechat-tutorial__260824.png` | 教程 | 左上小 Y + 3 步开始你的第一次录制 + 紫青细线 + "从下载到生成总结，全程 5 分钟" + 右侧 3 步卡片（1 下载映话 / 2 授权麦克风与系统音频 / 3 开始录制，每卡带大渐变编号）|
| `wechat-update__260824.png` | 更新 | 顶左 Y + 映话 · v0.3 + What's new + 映话 v0.3 更新说明 + 紫青细线 + "5 个让会议记录更聪明的小更新" + 底部 5 feature pill（实时转录 / AI 总结 / 说话人识别 / 多语言 / 高级 BYOK）|
| `wechat-hiring__260824.png` | 招聘 | 顶中 Y + 映话团队 · 招人 + 我们正在招人 · 远程优先 + 紫青细线 + "Hiring · remote-first · macOS / Swift / AI" + 3 角色（资深 macOS 工程师 / AI 应用工程师 / 产品设计师）+ 查看职位详情 ↗ CTA |

---

## 2. 按主题分类

| 主题 | 数量 | 涉及文件 |
|------|------|----------|
| **Launch**（发布公告）| 4 | twitter-launch, instagram-launch, instagram-story-launch, wechat-intro（科普向 launch）|
| **Feature**（功能高亮）| 3 | twitter-feature (实时转录), instagram-feature (AI 总结), instagram-story-feature (高级 BYOK) |
| **Quote**（用户证言）| 3 | twitter-quote, instagram-quote, instagram-story-quote |
| **Company**（公司介绍）| 2 | linkedin-post-company, linkedin-banner-company |
| **Product**（产品介绍）| 2 | linkedin-post-product, linkedin-banner-product |
| **Hiring**（招聘）| 5 | linkedin-post-hiring, linkedin-banner-hiring, wechat-hiring + IG launch story 视作 launch variant |
| **Tutorial**（教程）| 1 | wechat-tutorial |
| **Update**（产品更新）| 1 | wechat-update |

> 单一 CTA / 单一主元素原则在 launch 和 hiring 主题上严格保持（每张最多 1 个紫青渐变按钮）。Feature / quote 主题无 CTA（不抢主体注意力）。

---

## 3. 调性 vs D1 design-doc 自检

| D1 §7 反模式 | 19 张图自检 | 状态 |
|--------------|-------------|------|
| ❌ waveform / EKG / sine wave | 19/19 无 | ✅ |
| ❌ "AI" 字样烧进 hero / icon | 19/19 无（"AI 总结" 是 feature label 文字，不是 brand 烧图）| ✅ |
| ❌ 双环 / ∞ / 聊天气泡 mark | 19/19 无 | ✅ |
| ❌ 星空银河背景（除桌面壁纸外）| 19/19 暗色 + 紫青 aurora wash backdrop，无星空 | ✅ |
| ❌ Bento 框 + 左侧 bold label | 19/19 无（LinkedIn / WeChat 用 iOS Notes 风暗玻璃卡，不是 Bento）| ✅ |
| ❌ 营销词（洞察 / 赋能 / 智能化 / AI 驱动 / 效率提升 / 全局掌控）| 19/19 无 | ✅ |
| ❌ Pie / donut / gauge / radar | 19/19 无 | ✅ |
| ❌ 装饰性 sparkles 散落 hero | 19/19 无 | ✅ |
| ❌ 渐变描边对话图标 | 19/19 无 | ✅ |
| ❌ Glow / halo / 霓虹外发光 | 19/19 无（aurora wash 是 backdrop，不是 glow）| ✅ |
| ❌ 多色霓虹（紫 + 粉 + 青 + 黄全上）| 19/19 仅紫 + 青 + (REC 红 in transcript dot, 仅 twitter-feature) | ✅ |
| ❌ v1 / v2 / v3 / test / draft 文件名 | 19/19 用 `场景-主题__260824.png` 命名 | ✅ |
| ❌ 字体规格 / hex 数值作 visible UI 文字 | 19/19 干净（第 1 版有 2 张失败 → 修复，见 §5 重试记录）| ✅ |
| ❌ 把 prompt 的 font spec 烧进 visible text | 19/19 干净（修复后）| ✅ |
| ❌ typographic 引号（" " vs " "）| 19/19 用 U+201C / U+201D 弯引号 | ✅ |
| ❌ Bento 9 宫格 | 19/19 无 | ✅ |
| ❌ Marketing 感标签（"LEADERSHIP" / "NEW" 大字烧图）| 19/19 干净（除 "v0.3" 版本号小字）| ✅ |

**调性自检通过**。可以发 Figma 收口。

---

## 4. 用法建议

### 4.1 发布节奏

| 阶段 | 推荐用 | 频次 |
|------|--------|------|
| **Pre-launch（T-14 ~ T-7）**| wechat-intro + wechat-tutorial（公众号科普 + 教程 pre-warm）| 1 篇/周 |
| **Launch day（T0）**| twitter-launch + instagram-launch + instagram-story-launch + linkedin-post-company + linkedin-banner-company + wechat-intro（同时铺 6 平台）| 一次性 burst |
| **Post-launch（T+7 ~ T+30）**| twitter-feature + instagram-feature + linkedin-post-product（feature 轮换：实时转录 → AI 总结 → BYOK 三周）| 1 张/周轮换 |
| **Social proof（T+30+）**| twitter-quote + instagram-quote + instagram-story-quote（每月 1 个客户证言）| 1 张/月 |
| **Hiring（持续）**| linkedin-post-hiring + linkedin-banner-hiring + wechat-hiring（招聘长期挂着）| 长期挂 |
| **Changelog（每发版）**| wechat-update + linkedin-post-product（每次发版）| 每次发版 |

### 4.2 平台调性差异

- **Twitter / X**：信息密度低，单 quote / single feature card 即可；扩 profile cover 用 C19 已有 `twitter-profile-1-1` 资产。
- **Instagram**：feed 1:1 给"声明"用，story 9:16 给"互动 + swipe up"用；feed 配品牌 + 1 元素，story 配品牌 + 1 元素 + 1 CTA（IG story link sticker 用）。
- **LinkedIn**：B2B 调性，post 16:9 文字密度高，banner 4:1 文字稀疏靠品牌识别。
- **微信公众号 / 其他**：16:9 是公众号"题图"标准比例（建议尺寸 900×500 像素显示，2x 实际 1800×1000，本批 4K 母版 5504×3072 远超需求）。

### 4.3 Figma 收口

- 中文字体在 Figma 用 Noto Serif SC（标题）/ Noto Sans SC（正文）锁定
- 英文字体用 SF Pro Display / SF Pro Text
- 02 GRADIENT Y icon 替换为 C10 SVG master 真 squircle
- 渐变细线用 Linear gradient 135° + 紫青渐变
- 紫青 brand gradient CTA 用 `linear-gradient(135deg, #B57BFF, #8A5BFF, #2DD4BF)`

---

## 5. 出图记录

| 项 | 值 |
|----|----|
| 时间 | 2026-08-24 02:15-02:35 EDT（约 20 分钟出图 + 5 分钟裁切 + 10 分钟修复）|
| 工具 | `mcode-tools connector call connector__matrix__generate_image` |
| 模型 | gpt-image-2 / 4K 出图 |
| Aspect 选项 | 1:1 / 16:9 / 9:16 / 21:9（4:1 不支持，用 21:9 裁切）|
| 总提交 | 6 个 batch call（Twitter 3 / IG feed 3 / IG story 3 / LI post 3 / LI banner 3 / WeChat 4 = 19 images）+ 1 fix batch（2 images）= 21 个 call |
| 重试次数 | 2（twitter-quote + instagram-story-launch，font spec 漏出，详见下）|
| 转换 | `mcode-tools get-asset-url` → `wget` → `sips -s format png` |
| 裁切 | Python PIL：21:9 (6336×2688) 居中裁切到 4:1 (6336×1584) + Lanczos resize 1584×396 |

### 5.1 LinkedIn banner 4:1 workaround

`mcode-tools connector` 的 `generate_image` 不支持 4:1。本批 banner 用 21:9 (2.33:1) 出 4K 母版 6336×2688，再用 Python PIL 居中裁切到 4:1 (6336×1584)，最后 Lanczos resize 到交付版 1584×396：

```python
from PIL import Image
src = Image.open("linkedin-banner-company__260824.png")  # 6336x2688 (21:9)
crop_top = (2688 - 1584) // 2  # 552
cropped = src.crop((0, crop_top, 6336, 2688 - crop_top))  # 6336x1584 (4:1)
cropped.save("linkedin-banner-company__260824_4k.png", optimize=True)  # 4K master
cropped.resize((1584, 396), Image.LANCZOS).save(
    "linkedin-banner-company__260824.png", optimize=True)  # LinkedIn spec
```

### 5.2 Font spec leak 修复（C19 同根因）

**问题**：第 1 版 prompt 用 "in Noto Serif SC at 80pt semibold, warm white" 的写法，模型在 visible text 中渲染了 "SF Pro Text 22pt 70%" / "SF Pro Text · 18pt, warm white · 50% opacity" 等 font spec。

**Fail 的 2 张图**（已修复）：
- `twitter/twitter-quote__260824.png` — 第 1 版出现 "SF Pro Text 22pt 70%" 烧图
- `instagram/instagram-story-launch__260824.png` — 第 1 版出现 "SF Pro Text · 18pt, warm white · 50% opacity" 烧图

**修复**：去掉 visible text 段里的 font spec 命名，prompt 改用 "in serif font" / "in sans-serif font" 描述，不带具体字号；模型按系统默认渲染。

**C02 §2.3 anti-leak 教训**：
- 字体规格（font name + size + color）只能用于描述层级（heading / subhead / caption），不能与 "rendering" 段并列。
- C19 audit 已经在 C17 03 byok / email-launch 上踩过同根因（producer 把 font-size spec 字符串原样作为 UI 文字输出）。本批 fix 已避免重复。

### 5.3 4K 出图 aspect 实际分辨率

| Aspect | 实际分辨率 | 备注 |
|--------|------------|------|
| 1:1 | 4096 × 4096 | Twitter / Instagram feed 标准 |
| 16:9 | 5504 × 3072 | 比 4K UHD (3840×2160) 大 ~14% |
| 9:16 | 3072 × 5504 | Instagram Story 标准 |
| 21:9 (裁到 4:1) | 6336 × 1584 (裁后) / 1584×396 (resize 后) | LinkedIn 4:1 |

---

## 6. 后续可优化（非本批范围）

- **真 squircle Y icon**：本批 icon 是模型绘制的 rounded square（近似 squircle）。Figma 收口用 C10 SVG master 替换为真 superellipse。
- **中文字体 fallback**：模型在中文场景下可能用了默认 fallback 字体（看起来是 Songti / Mincho），Figma 收口时锁定 Noto Serif SC。
- **Aurora wash 强度**：模型绘制的 wash 是 approximation，Figma 调 135° + 12-18% opacity 更准。
- **Compressed 发布版**：当前每张 5-20 MB，Twitter / IG 实际发布需压成 JPEG ≤ 1 MB。
- **Story swipe-up link**：IG Story 模板默认无 link sticker，发布时手动加。
- **LinkedIn post 1200×627**：本批用 16:9 (5504×3072) 出图，发布时 Figma 裁切到 1200×627。也可单独出 1200×627 master。
- **更多 quote 变体**：当前 quote 主题用 "张三" / "李四" 作占位，Figma 收口替换为真实客户名 + 头像（头像用 C10 的 avatar 紫粉青渐变）。

---

## 7. Figma 收口清单

| 任务 | 优先级 | 说明 |
|------|--------|------|
| 上传 19 张 PNG 到 Figma 团队库 | P0 | 直接用，不需改图 |
| 中文 / 英文 Figma 字体核对 | P0 | 模型渲染跟 Figma 字体微差，逐图核对 |
| 02 GRADIENT Y icon 用真 SVG | P1 | C10 SVG master 复用 |
| Aurora wash Figma 重画 | P1 | 135° + 12-18% opacity |
| Twitter banner 3:1（已有 C11 资产）| P0 | C19 已有，本批 Twitter 是 1:1 feed card |
| LinkedIn banner 4:1 单独上传 4K 母版 | P0 | 用于 LinkedIn 公司页 banner |
| LinkedIn post 1200×627 单独切 | P1 | 本批 16:9 大图可裁 |

---

**审计依据**：[C19 marketing social 审计 verdict](../C19_marketing-social/_audit-verdict.md) 12 项检查 + C02 §2.3 anti-leak addendum + D1 design-doc §7 反模式 + D2 design-tokens。
