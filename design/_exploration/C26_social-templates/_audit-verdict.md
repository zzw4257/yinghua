# C26 Social Templates — 视觉与品牌审计裁定

**审计时间**: 2025-08-24  
**审计者**: Verifier (Mavis)  
**范围**: 4 平台 × 多尺寸社交模板 — Twitter (3)、Instagram (5)、LinkedIn (5)、WeChat (4) — 共 17 个 base 模板 + 部分 4K 变体。  
**参考标准**: `design/design-doc.md` v2.0、`design/design-tokens.json`、`C02_brand-assets/_design-system-prompt.md` §2.3。

---

## Checks performed

1. 目录枚举：twitter (3)、instagram (5)、linkedin (5)、wechat (4) = 17 base + 4K 变体。
2. `sips -g pixelWidth -g pixelHeight` × 全部 17 张 base。
3. 视觉读取全部 17 张（按平台分类缩放到目标长宽比）。
4. 10 项标准检查逐图走查（重点：提示词泄露、字体、品牌色、装饰、营销词）。
5. 平台规范校验：Twitter 16:9 / IG 1:1 square & 9:16 story / LinkedIn 4:1 banner / WeChat 16:9 post & 9:16 story。
6. 与 C10 Y mark 几何一致性。

---

## 证据与观察结果

### 1. 文件清单 vs. spec

`C26_social-templates/`：

| 平台 | base 模板 | 4K 变体 | 校验 |
|---|---|---|---|
| twitter | 3 (announce / quote / thread-header) | 部分 4K | ✅ 3/3 |
| instagram | 5 (post-square×2 / carousel / story-launch / reel-cover) | 部分 4K | ✅ 5/5 |
| linkedin | 5 (banner-4:1 / post / carousel×2 / article-cover) | 部分 4K | ✅ 5/5 |
| wechat | 4 (post-16:9 / article-cover / mini-program-card / story-9:16) | 部分 4K | ✅ 4/4 |
| **合计** | **17 base** | **部分 4K** | **✅ 17/17** |

### 2. 像素尺寸（`sips`）

| 平台 | 文件 | 像素 | 期望 | 结果 |
|---|---|---|---|---|
| twitter | `twitter-announce-1200x675__260824.png` | 1200×675 | 1200×675 (16:9) | ✅ |
| twitter | `twitter-quote-1200x675__260824.png` | 1200×675 | 1200×675 | ✅ |
| twitter | `twitter-thread-header-1500x500__260824.png` | 1500×500 | 1500×500 (3:1) | ✅ |
| instagram | `instagram-post-square-1080__260824.png` ×2 | 1080×1080 | 1080×1080 | ✅ |
| instagram | `instagram-carousel-1080x1350__260824.png` | 1080×1350 | 1080×1350 (4:5) | ✅ |
| instagram | `instagram-story-launch-1080x1920__260824.png` | 1080×1920 | 1080×1920 (9:16) | ✅ |
| instagram | `instagram-reel-cover-1080x1920__260824.png` | 1080×1920 | 1080×1920 | ✅ |
| linkedin | `linkedin-banner-1584x396__260824.png` | 1584×396 | 1584×396 (4:1) | ✅ |
| linkedin | `linkedin-post-1200x627__260824.png` | 1200×627 | 1200×627 | ✅ |
| linkedin | `linkedin-carousel-1080x1080__260824.png` ×2 | 1080×1080 | 1080×1080 | ✅ |
| linkedin | `linkedin-article-cover-1200x627__260824.png` | 1200×627 | 1200×627 | ✅ |
| wechat | `wechat-post-16-9-900x500__260824.png` | 900×500 | 900×500 (16:9) | ✅ |
| wechat | `wechat-article-cover-900x383__260824.png` | 900×383 | 900×383 | ✅ |
| wechat | `wechat-mini-program-card-500x400__260824.png` | 500×400 | 500×400 | ✅ |
| wechat | `wechat-story-9-16-750x1334__260824.png` | 750×1334 | 750×1334 (9:16) | ✅ |

17/17 全部命中平台规范像素。

### 3. 10 项标准检查（按平台聚合）

| # | 检查 | twitter | instagram | linkedin | wechat | 总失败 |
|---|---|---|---|---|---|
| 1 | 提示词规则泄露 | ❌ (1) | ❌ (1) | ✅ | ✅ | **2** |
| 2 | 中文字体 | ✅ | ✅ | ✅ | ✅ | 0 |
| 3 | 紫青品牌色 | ✅ | ✅ | ✅ | ✅ | 0 |
| 4 | 无赛博朋克 / 双环 / emoji | ✅ | ✅ | ✅ | ✅ | 0 |
| 5 | 无营销词 | ✅ | ✅ | ✅ | ✅ | 0 |
| 6 | 命名规范 | ✅ | ✅ | ✅ | ✅ | 0 |
| 7 | 像素 | ✅ | ✅ | ✅ | ✅ | 0 |
| 8 | 与 02 GRADIENT 几何一致 | ✅ | ✅ | ✅ | ✅ | 0 |
| 9 | 跨图基调 | ✅ | ✅ | ✅ | ✅ | 0 |
| 10 | 明 / 暗 | ✅ | ✅ | ✅ | ✅ | 0 |

### 4. 失败细节：2 处 CRITICAL 提示词泄露

#### (a) Twitter — `twitter-quote-1200x675__260824.png`

- 画面底部（quote 卡片下方）出现可见文字：**"SF Pro Text 22pt 70%"**。
- 含义：prompt 中规定的「font-family: SF Pro Text; font-size: 22pt; opacity: 70%」字段被字面渲染到画面上。
- 位置在右下角水印区（应该是签名 / 落款）。
- 违反 C02 §2.3 反泄露规则。

#### (b) Instagram — `instagram-story-launch-1080x1920__260824.png`

- 画面底部 CTA 按钮上方出现可见文字：**"SF Pro Text · 18pt, warm white · 50% opacity"**。
- 含义：prompt 中规定的「font-family: SF Pro Text; font-size: 18pt; color: warm white; opacity: 50%」字段被字面渲染到画面上。
- 位置在 9:16 story 的安全区（应保留给 CTA / 行动号召按钮）。
- 违反 C02 §2.3 反泄露规则。

#### 跨图观察

- 同一系列的 `instagram-post-square-1080__260824.png` × 2、`instagram-reel-cover-1080x1920__260824.png`、`instagram-carousel-1080x1350__260824.png` 未出现 prompt 泄露 — 说明泄露是 prompt 06 / 07 的局部 bug，不是全平台失败。
- `linkedin-*` 5/5 干净，`wechat-*` 4/4 干净，`twitter-announce-1200x675__260824.png` 和 `twitter-thread-header-1500x500__260824.png` 也干净 — 仅 2 张图失败。

### 5. 中英双语分布（按平台规范）

- Twitter：英文 quote 为主、hashtag 中文 OK。
- Instagram：中文 + 英文 hashtag，bilingual 平衡。
- LinkedIn：英文主标题 + 中文落款（专业语境）。
- WeChat：纯中文（公众号生态），含 emoji 风格规避（已检查，无 emoji）。

所有平台均无营销违禁词（洞察 / 赋能 / 智能化 / 效率提升 / AI 驱动）。

### 6. 与 C10 / 02 GRADIENT 几何

- 17 张图的 Y 角标位置和缩放与 C10 baseline 100% 一致。
- 紫青渐变 `#7C5CFF → #3DCFD6` 落在 hashtag / CTA / 强调句上。

---

## Findings（按严重度排序）

| Sev | 检查 | 状态 | 处置 |
|---|---|---|---|
| **HIGH** | `twitter-quote-1200x675__260824.png` — "SF Pro Text 22pt 70%" prompt 字段泄露 | 1/17 触发 | **P0 fix**：删除水印区文字或替换为真实签名 |
| **HIGH** | `instagram-story-launch-1080x1920__260824.png` — "SF Pro Text · 18pt, warm white · 50% opacity" prompt 字段泄露 | 1/17 触发 | **P0 fix**：删除 CTA 上方说明文字或替换为真实 button label |
| — | 其它 8 项检查 | 15/17 PASS | — |

---

## VERDICT: **PARTIAL**

- **Shippable**: **15 / 17** base 模板
- **Not shippable**: **2 / 17**（`twitter-quote-1200x675` + `instagram-story-launch-1080x1920`）
- **Figma 待修**: **2 项 P0**
  - F1: twitter-quote 底部水印文字替换 / 删除
  - F2: instagram-story-launch CTA 上方说明文字替换 / 删除

**说明**：17 张 base 模板的像素、品牌色、字体、跨图基调、平台规范全部通过。唯一阻断项是 2 张图把 prompt 字段当文案渲染到画面上（违反 C02 §2.3 反泄露规则），均为「水印 / 落款」区的局部 bug，修复简单（删除或替换为真实文字），预计 ≤ 30 min 即可 ship 全平台。其余 15 张可直接发布。
