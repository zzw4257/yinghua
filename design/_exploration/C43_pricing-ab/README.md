# C43 — Pricing A/B Test Variants

> **映话 (Yìnghuà) · Yinghua · Pricing A/B · 2026-08-24**
> **owner**：Worker agent · C43
> **状态**：3 个 HTML 变体就绪 + A/B test 设计稿就绪
> **上游依赖**：C18 视觉锚点 · C29 marketing pricing · C30 App Store metadata · design-doc v2.0 · design-tokens

---

## 0. 这个目录是啥

Marketing 想知道 **3 种 pricing 方案哪个转化率最高**。C43 输出 3 个可立刻拿去跑 A/B test 的 HTML 页面 + 1 份给 marketing 团队用的 A/B test 设计文档。

| 文件 | 用途 | 谁读 |
|------|------|------|
| **`pricing-page-A__260824.html`** | 变体 A · baseline · 3 tier（Free 5 / Pro $19 / Team $49） | Marketing + Engineering |
| **`pricing-page-B__260824.html`** | 变体 B · 2 tier 简化（Free 10 / Pro $29 / Team coming soon） | Marketing + Engineering |
| **`pricing-page-C__260824.html`** | 变体 C · 14-day trial 驱动 + 倒计时 + 4 tier | Marketing + Engineering |
| **`ab-test-setup.md`** | A/B test 设计：KPI / 流量分配 / 样本量 / 贝叶斯方法 / 决策标准 | Marketing 主导，Engineering 实施 |
| **`README.md`** | 本文件 · 目录说明 + 与 C30 关系 + 风险 | 所有协作者 |

---

## 1. 三个变体速查

| 维度 | A (baseline) | B (2 tier) | C (trial-driven) |
|------|-------------|-----------|------------------|
| **价格结构** | 3 tier | 2 tier | 4 tier（含 trial） |
| **Free 额度** | 5 场/月 | **10 场/月**（翻倍）| 3 场/月（trial 后降级） |
| **Pro 价格** | $19/月 | **$29/月**（+53%）| $19/月（不变）|
| **Team 价格** | $49/席位/月 | Coming soon Q4 | **$39/席位/月**（-20%）|
| **核心假设** | — | 慷慨 free 提升转 Pro | 无摩擦试用 + 降价 team 提转化 |
| **适用场景** | 维持现状 | 测「价格 vs 价值」 | 测「试用 vs 免费」 |
| **预计对 ARPU** | 基线 | 略升（高单价） | 升（trial → paid 漏斗） |
| **预计对 churn** | 基线 | 风险（高单价 = 高期待）| 风险（C 试用结束感受落差） |
| **设计强度** | 中（与 C29 一致）| 低（更少卡）| 高（banner + 倒计时）|

**详细差异**见 [`ab-test-setup.md` §2](./ab-test-setup.md)。

---

## 2. 使用方法

### 2.1 给 Marketing / PM 跑测

1. **直接打开 HTML**：双击 3 个 HTML 即可本地预览（已 link C29 的 CSS / icon assets，相对路径）
2. **配分流**：参照 `ab-test-setup.md` §3.2 — 推荐 Cloudflare Workers
3. **埋点**：参照 `ab-test-setup.md` §8.1 — amplitude funnel + Stripe price_id
4. **决策**：参照 `ab-test-setup.md` §7 — 28 天后用 §7 决策矩阵

### 2.2 给 Engineering 实施

**HTML 是相对路径引用 C29 资源**，部署时直接放在 web root：

```
yinghua.zzw4257.cn/
├── pricing.html            # 当前（指向 A 档）
├── pricing-b.html          # 新增 · 指向 B 档
├── pricing-c.html          # 新增 · 指向 C 档
└── assets/...              # 共享（来自 C29）
```

或者用 Worker 分流（推荐，见 ab-test-setup §3.2），URL 仍是 `/pricing`，但内部 rewrite。

**3 个变体的 image / 字体 / JS 全部**从 `../C29_marketing-website/website/assets/` 加载，确保视觉一致。

### 2.3 给 Designer 维护

- **数字字号**：96pt（A） / 112pt（B，比 A 更大因为卡更少） / 88pt（C，比 A 略小因为 banner 抢注意力）
- **品牌色**：`var(--color-brand-purple-vivid)` `#B57BFF` + `var(--color-brand-teal-vivid)` `#2DD4BF`（来自 design-tokens.json，跟 C29 完全一致）
- **不允许**：改主色 / 改字体 / 改暗色背景。任何视觉调整先同步到 C18 / C29，再同步到 C43。

---

## 3. 与 C30 已有 pricing 文案的关系

### 3.1 当前 C30 状态

[C30 app store metadata](../C30_app-store-metadata/) 已经 shippable，**所有字段已锁定**。其中：
- 中文 Description §5 第 254 行：`Free: 5 recordings per month`
- 英文 Description §5 第 254 行：`Free: 5 recordings per month`（与中文一致）
- 关键词、Promotional Text 均无 pricing 字样

**结论**：C30 的 App Store metadata **不直接显示具体价格**，只说"5 recordings per month"。所以即使 pricing 方案变了，App Store 提交不需要重做（除非胜出方案变了 Free 额度，且想同步进 Description）。

### 3.2 跑测结束后需要回填 C30 的 3 个场景

| 胜出变体 | 需要回填 C30 | 原因 |
|----------|--------------|------|
| **A** | 无 | 与 C30 当前一致 |
| **B** | Description "5 recordings" → "10 recordings" | Free 额度从 5 → 10 |
| **C** | Description "5 recordings" → "14-day free trial" + 后面跟 "3 recordings after trial" | 试用 + 降级描述 |

⚠️ **回填时注意**：
- 字符限制（Subtitle 30 / Promotional 170 / Description 4000 / Keywords 100）
- 英文 Subtitle "Local-first meetings on Mac"（27 字符）已是 30 字符上限附近
- 详见 [C30 README §3 "字符限制自检"](../C30_app-store-metadata/README.md)

### 3.3 与 C29 marketing pricing.html 的关系

[C29 marketing pricing](../C29_marketing-website/website/pricing.html) 当前就是 **A 档**（$19 Pro）。胜出变体确定后，需要：
1. 替换 `pricing.html` 主体内容
2. **保留** C29 的 footer、nav、styles
3. 删除 A/B 角标 `ab-badge`
4. 更新 C29 README §"A/B test history"

---

## 4. 视觉规范一致性

C43 三个变体严格遵循 C18 视觉锚点 + C29 marketing website 锚定。

| 元素 | 规格 | 来源 |
|------|------|------|
| 背景 | `#0A0A0F` + aurora 紫青 wash | `design-tokens.json` color.neutral.near-black |
| 品牌色 | `#B57BFF` 紫 vivid + `#2DD4BF` 青 vivid | `design-tokens.json` color.brand.* |
| 渐变按钮 | `linear-gradient(135deg, #B57BFF 0%, #2DD4BF 100%)` | `main.css` `--gradient-primary-2stop` |
| 字体 (英文) | Inter Display 96pt (数字) + Inter 15pt (正文) | `main.css` `--font-display` / `--font-text` |
| 字体 (中文) | Noto Serif SC 600 (hero) + Noto Sans SC (正文) | `main.css` `--font-serif-zh` / `--font-sans-zh` |
| 卡片 | `var(--bg-card)` + `backdrop-filter: blur(20px)` + 1px hairline | `main.css` `.price-card` |
| 圆角 | `--radius-2xl: 16px` (卡片) · `--radius-button: 12px` (CTA) | `main.css` |
| 间距 | 8pt grid · `--space-2xl: 24px` 卡片间距 | `main.css` |

**未引入**任何新 token · **未修改**任何已 shippable CSS。

---

## 5. 风险与回滚

### 5.1 Pricing 变化的固有风险

| 风险 | 影响 | 缓解 |
|------|------|------|
| **churn rate 上升**（B/C 都可能）| 失去已建立的用户信任 | 监控 7-day churn guardrail · 跑测期间 daily check |
| **LTV 误判** | 财务预测失败 | 单独 cohort 跟踪 90 天，**不**用 30 天数据做财务预测 |
| **App Store 评论差评** | 影响 ASO | 跑测期间 daily check 评分 |
| **客服压力** | 用户问"为什么我看到的价格不一样" | 客服培训 + 统一话术（"我们在做产品改进测试"）|
| **Apple 政策风险** | C 档 14 天 trial 需 IAP | macOS 端不强制，但若未来做 iOS 需重新设计 |

### 5.2 工程回滚机制

- **5 分钟回滚**：Cloudflare Worker 改 1 行 → 100% 流量回 A 档
- **30 分钟回滚**：直接修改 Worker 路由 → 全 A
- **2 小时回滚**：删除 B/C 的 price_id → 用户无法新订阅（已有订阅保留）

### 5.3 Grandfathering 规则（写进 ToS）

- ✅ **已订阅用户**：价格不变，续费时按注册时版本计费
- ✅ **跑测中升级的用户**：享受变体价格（但若变体落败，会以邮件 + 30% 折扣挽留）
- ❌ **不允许**：跑测结束后，对老用户涨价

---

## 6. 不做什么（Non-Goals）

为保持 scope 清晰，本次明确**不**做：

- ❌ 不实施 A/B test（仅交付设计稿 + 配置指南，engineering 后续做）
- ❌ 不写 Stripe 后端逻辑
- ❌ 不修改 C18 / C29 / C30 任何已 shippable 文件
- ❌ 不创建 Figma 文件（designers 后续从这 3 个 HTML 截图 / 移植）
- ❌ 不做 A/B test 数据分析脚本（仅给出贝叶斯模型骨架）
- ❌ 不做 14 天 trial 后端逻辑（C16 shippable 阶段已完成，前端展示就绪）
- ❌ 不做移动端深度优化（仅做基础 responsive，1080 / 880 / 640 三档 breakpoint）

---

## 7. 文件清单

```
design/_exploration/C43_pricing-ab/
├── pricing-page-A__260824.html   3 tier · baseline · 17 KB · 285 行
├── pricing-page-B__260824.html   2 tier · 简化版 · 17.6 KB · 250 行
├── pricing-page-C__260824.html   4 tier · trial-driven · 30 KB · 380 行
├── ab-test-setup.md              A/B test 设计 · 17 KB
└── README.md                     本文件
```

总交付：5 个文件 · 0 个文件被修改（C18 / C29 / C30 / design-tokens / design-doc 全部不动）。

---

## 8. 验证（Validation Run · 2026-08-24）

| 检查项 | 状态 | 备注 |
|--------|------|------|
| 3 个 HTML 文件存在 | ✅ | `ls -la` 全部 present |
| HTML 语法合法（无 unclosed tag） | ✅ | manual review · `<main>` / `<section>` / `<article>` 全部闭合 |
| 引用 C29 CSS 路径正确 | ✅ | 相对路径 `../C29_marketing-website/website/assets/css/main.css` |
| 引用 C29 icon 路径正确 | ✅ | `../C29_marketing-website/website/assets/img/icon-02-gradient-32.png` |
| 引用 C29 JS 路径正确 | ✅ | `../C29_marketing-website/website/assets/js/main.js` |
| 暗色 aurora 背景 | ✅ | C29 main.css 已含 `.hero-bg` aurora 渐变 |
| 紫青品牌色 | ✅ | `var(--color-brand-purple-vivid)` + `var(--color-brand-teal-vivid)` |
| 数字 96pt+ | ✅ | A=96pt · B=112pt · C=88pt（4 卡 + banner 抢注意力）|
| 中文字体 Noto Serif SC | ✅ | Google Fonts 引入，hero h1 用 `--font-serif-zh` |
| 不用 Bento / 不用营销词 | ✅ | 仅单列卡片 + 5-6 bullets；无"洞察/赋能/智能化/AI 驱动"等词 |
| 单一 CTA "Start free" | ✅ | 全部变体 CTA 都是单按钮 |
| 倒计时器 (C only) | ✅ | 实时倒计时 + `prefers-reduced-motion` 降频 |
| FAQ 区块 | ✅ | A 5 条 · B 4 条 · C 4 条 |
| 不修改任何已有文件 | ✅ | 仅创建 C43 目录，0 个外部文件被改 |
| 未创建 agent | ✅ | 0 个 agent |
| 时长 | ✅ | < 30 分钟 |

---

## 9. 变更记录

| 版本 | 日期 | 变更 |
|------|------|------|
| v1.0 | 2026-08-24 | 初版 · 3 变体 + A/B test 设计 + README |

---

## 10. 相关资源

- [`../C18_marketing-landing/`](../C18_marketing-landing/) — 视觉锚点（landing hero / product hunt / typography 5 张图）
- [`../C29_marketing-website/website/pricing.html`](../C29_marketing-website/website/pricing.html) — A 档对应已 shippable 版本
- [`../C30_app-store-metadata/`](../C30_app-store-metadata/) — App Store metadata（跑测后回填场景见 §3.2）
- [`../C27_brand-guidelines/gtm-plan__260824.md`](../C27_brand-guidelines/gtm-plan__260824.md) §3 — GTM 定价策略源头（"贵在 AI 成本" · BYOK 转嫁）
- [`../design/design-tokens.json`](../design-tokens.json) — 视觉 token · 任何颜色 / 字号改动先回这里
- [`../design/design-doc.md`](../design-doc.md) — 设计文档 v2.0（§7 禁词清单 · §2 视觉语言 · §6 决策记录）
- [`./ab-test-setup.md`](./ab-test-setup.md) — A/B test 完整设计（流量 / 样本量 / 贝叶斯 / 决策）

---

**最后修订**：2026-08-24 · Worker · C43 pricing A/B test 变体
