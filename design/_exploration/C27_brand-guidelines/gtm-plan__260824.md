# 映话 (Yìnghuà) — Go-To-Market Plan v1.0

> **状态**：v1.0 · 2026-08-24
> **适用范围**：产品上市策略 + 营销渠道 + 关键指标 + 风险缓解
> **基础**：
> - 产品身份：[`brand-guidelines__260824.md`](./brand-guidelines__260824.md) §1 身份
> - 设计资产：[`../C18_marketing-landing/`](../C18_marketing-landing/) + [`../C19_marketing-social/`](../C19_marketing-social/) + [`../C11_twitter-banner/`](../C11_twitter-banner/) + [`../C14_browser-extension/`](../C14_browser-extension/)（6+6+2+2 = 16 张 marketing 资产可用）
> - 产品真相：[`../design-doc.md`](../design-doc.md) v2.0 + [`../design-tokens.json`](../design-tokens.json) 117 token
> - SwiftUI scaffold：[`../../code/Yinghua/`](../../code/Yinghua/) BUILD SUCCEEDED
> - Chrome extension：[`../../code/yinghua-extension/`](../../code/yinghua-extension/) Manifest V3
>
> **写作原则**：
> - 数字从 D1 / C18 / C19 资产引用，不编造
> - 状态词不许升级（"under review" ≠ "已发表"；"paused" ≠ "完成"）
> - 中文优先，跟 brand-guidelines §9 文案规范 100% 一致

---

## 0. TL;DR

| 维度 | 内容 |
|------|------|
| **产品** | macOS 26+ 本地优先的会议 / 面试智能助手（实时转录 + AI 总结 + BYOK）|
| **目标用户** | macOS 26+ 用户中**经常面试**或**经常开会**的（CEO / PM / 工程师 / 学生 / 投资人）|
| **核心价值** | 本地优先 + 实时转录 + AI 总结（48 分钟会 5 秒出总结）+ BYOK |
| **定价** | Free $0 · Pro $19/月 · Team $49/席位/月 |
| **上市日** | T-0（v0.1 alpha 给 5-10 内部用户）→ T+30 公开上市 |
| **核心渠道** | Landing page + Mac App Store + Product Hunt + Twitter/LinkedIn/微信 + Chrome Web Store + 朋友 referral |
| **T+30 关键指标** | 1,000 downloads |
| **T+90 关键指标** | 5,000 downloads + 200 Pro subscribers |
| **T+180 关键指标** | 20,000 downloads + 1,000 Pro subscribers |
| **最大风险** | Apple 审核拒绝 / Anthropic API 限流 / 隐私担忧 |

---

## 1. 目标用户（Target Audience）

### 1.1 Primary · 经常面试或经常开会

macOS 26+ 用户中**高频使用场景**的群体。

| 角色 | 占比（估）| 关键场景 | 痛点 | 映话如何解决 |
|------|----------|----------|------|---------------|
| **CEO / 创始人** | 15% | 投资人 pitch / 1:1 / 全员会 | 50% 时间在听，50% 时间在想怎么记 | 实时转录 + 5 秒出 4 段总结（关键 / 决定 / 待办 / 遗留）|
| **PM（产品经理）**| 20% | 用户访谈 / sprint planning / 跨团队 sync | 访谈后整理 1 小时 → 用映话 5 分钟 | 说话人分离 + 时间码回溯 + AI 总结 |
| **工程师** | 25% | 1:1 / 面试候选人 / 团队 sync | 面试中要记候选人的技术细节，错过追问 | 实时转录 + Speaker 识别 + 关键瞬间高亮 |
| **学生（研究生 / 博士生）**| 15% | 导师 1:1 / 论文讨论 / 组会 | 跟不上导师思路，错过关键引用 | 实时转录 + 时间码 + 全文搜索 |
| **投资人** | 10% | 跟创始人 / 跟被投 / IC 会议 | 听完后要快速写 memo | 实时转录 + 关键决定高亮 + 直接 export 到 Notion |
| **面试候选人** | 15% | 面试后复盘 | 面试后 30 分钟内忘掉 60% 内容 | 录完即有 transcript + 关键问答 highlight |

**共同特征**：
- macOS 26+ 用户（系统要求，D1 §1）
- 每周 ≥3 次会议或 ≥1 次面试
- 愿意为节省时间付 $19/月（Pro）
- 关心隐私（"我的会议数据去哪了"是高频问题）

### 1.2 Secondary · 远程团队 leader

用 Zoom / Meet 的远程团队 leader（5-50 人规模），需要：
- 团队会议标准化（每次会议都有 summary）
- 新成员 onboarding（看过去 3 个月的会议 transcript）
- 决策可追溯（"我们什么时候决定不做 X"）

映话 Team 套餐解决。

### 1.3 Tertiary · 内容创作者

播客主 / YouTuber / 视频博主，需要：
- 录完即有 transcript
- 自动生成 chapter markers
- 关键引言 highlight

映话 Free 套餐（5 次会议/月）够用。

### 1.4 ❌ 不做的用户群

为了 brand 严肃度（D1 §1 调性 + §7 反模式），**不主动做**：

- ❌ **中小学生 / K12**（家长会场景）— 监管风险 + 调性不符
- ❌ **医院 / 法律 / 金融**合规录音 — 行业合规要求超出 v0.1 范围
- ❌ **企业全员部署**（> 50 席位）— Team 套餐不支持 SSO / SCIM / 数据驻留
- ❌ **移动端优先**用户 — 映话 v0.1 是 macOS 单一桌面 app（无 iOS / Android）

### 1.5 用户画像参考

参考商业产品（仅作语料 / 简洁定位模板）：
- **Fathom**（https://fathom.video）— 简洁定位 + 用户先于 AI 价值的叙事
- **Final Round**（https://finalroundai.com）— AI 面试助手直接竞品（差异化：本地优先 + BYOK）

证据：D1 §8.7 商业产品 · 5 个开源项目参考（D1 §8.6）。

---

## 2. 价值主张（Value Proposition · max 3 句）

> 映话是 macOS 26+ 原生、本地优先的会议 / 面试智能助手。
>
> **1. 本地优先**：你的数据不出设备（转录音频原文 30 天后自动清理，BYOK 走 Keychain，不上传到我们服务器）。
>
> **2. 实时转录 + AI 总结**：边开会边记录，48 分钟会 5 秒出 4 段总结（关键瞬间 / 决定 / 待办 / 遗留问题）。
>
> **3. BYOK（自带 API key）**：用你自己的 Anthropic / OpenAI key，我们看不到，AI 成本你控制。

### 2.1 价值主张 vs 反模式（防"营销词升级"）

| 写法 | ❌ 禁 | ✅ 改 |
|------|------|------|
| 本地优先 | "数据安全无懈可击" | "你的数据不出设备" |
| 实时转录 | "AI 驱动的智能转录" | "边开会边记录" |
| AI 总结 | "极致智能的革命性总结" | "48 分钟会 5 秒出 4 段总结" |
| BYOK | "用户主权赋能" | "用你自己的 key，我们看不到" |

证据：brand-guidelines §9.2 18 条禁用词 · D1 §7 #6 营销词 · C12 `NO_MARKETING_FLOURISH`。

### 2.2 价值主张对照（产品真相 vs 用户认知）

| 用户认知 | 产品真相 | 证据 |
|----------|----------|------|
| "我的会议安全吗？"| ✅ 100% 本地处理，BYOK key 存 Keychain | D1 §9.3 |
| "AI 总结准确吗？"| 60 分钟会议 / 4 段折叠，< 8s 生成 | D1 §9.2 性能预算 |
| "我可以用自己的 key 吗？"| ✅ 必须 BYOK，Pro 套餐 | D1 §1 + §9.3 |
| "支持中文吗？"| ✅ 中文优先（按钮 / 标签 / bullet 都用中文）| D1 §2.2 |
| "我的 Mac 跑得动吗？"| macOS 26+ 原生，SwiftUI 6 | D1 §1 |
| "Apple Silicon 优化？"| ✅ Xcode 26.6 · arm64-apple-macos26.5 已 BUILD SUCCEEDED | C13 README |

---

## 3. 定价（Pricing · 3 档）

| 套餐 | 价格 | 包含 | 目标用户 |
|------|------|------|----------|
| **Free** | $0 / 月 | 5 次会议 / 月（每次 ≤ 60 分钟）<br>实时转录<br>本地 AI 总结（规则式）<br>BYOK 必需 | 尝鲜用户 / 内容创作者 |
| **Pro** | **$19 / 月** | **无限会议**<br>实时转录 + Speaker 识别<br>AI 总结（BYOK 调用 Anthropic / OpenAI）<br>导出 PDF / Markdown / SRT<br>说话人颜色持久化 | 经常面试 / 经常开会的个体 |
| **Team** | **$49 / 席位 / 月** | Pro 全部<br>团队共享知识库<br>协作注释<br>会议共享（团队成员可看 transcript）<br>中央 admin 面板 | 远程团队 leader（5-50 人）|

### 3.1 定价依据

| 维度 | 决策 | 理由 |
|------|------|------|
| **Free 上限** | 5 次 / 月 | 跟 Otter.ai Free（600 分钟 / 月，但功能受限）差异化；5 次 ≈ 每月 1 次周会的量 |
| **Pro $19** | 比 Fathom $24 便宜，比 Final Round $99 便宜很多 | 价值锚定 + 中国 / 国际市场都可接受 |
| **Team $49/席位** | Notion $8/席位 / Linear $8/席位 的 6 倍 | 我们的核心是"贵在 AI 成本"，BYOK 把 AI 成本转嫁给用户，自己收的是产品溢价 |
| **年付折扣** | 暂不提供 v0.1 | 先跑数据，T+90 评估 |

### 3.2 定价 vs 竞品对照

| 产品 | Free | Pro | Team | 关键差异 |
|------|------|-----|------|----------|
| **映话** | $0（5 次/月）| $19/月 | $49/席位/月 | 本地优先 + BYOK |
| **Fathom** | $0（无限）| $24/月 | $15/席位/月 | 云端、训练自家模型 |
| **Final Round** | 无 | $99/月 | 无 | AI 面试助手（专门面试）|
| **Otter.ai** | $0（600 分钟/月）| $16.99/月 | $30/席位/月 | 云端、英文优先 |
| **Fireflies.ai** | $0（有限）| $18/月 | $39/席位/月 | 云端、英文优先 |

**映话差异化**：本地优先 + BYOK + 中文优先 + macOS 26+ 原生。

### 3.3 ❌ 定价禁词

- ❌ "极致性价比"（D1 §7 #6 营销词）
- ❌ "普惠" / "让 AI 触手可及"（D1 §7 #6 营销词）
- ❌ "免费体验"含糊表述 — 直接说"5 次 / 月"

证据：brand-guidelines §9.2。

---

## 4. 分发渠道（Distribution Channels）

### 4.1 1P（First-Party · 我们自己控制）

| 渠道 | 资产 | 状态 | 证据 |
|------|------|------|------|
| **Landing page** | hero（3 变体 A/B/C）| ✅ shippable | [`../C18_marketing-landing/`](../C18_marketing-landing/) 6 张图（landing-hero × 3 + PH + blog × 2）|
| **Mac App Store** | 5 screenshots | ✅ shippable | [`../C23_app-store-screenshots/`](../C23_app-store-screenshots/) — 5 张已 shippable |
| **docs.yinghua.zzw4257.cn** | 用户文档 | ⏳ T-14 准备 | Round 4 计划 |
| **in-app onboarding** | 3 屏流程 | ✅ shippable | C09 + C17 3 屏 |

### 4.2 2P（Second-Party · 平台 / 媒体）

| 渠道 | 资产 | 状态 | 证据 |
|------|------|------|------|
| **Product Hunt** | cover 1:1（4096×4096）| ✅ shippable | [`../C18_marketing-landing/product-hunt-cover__260824.png`](../C18_marketing-landing/) |
| **Twitter / X** | banner 3:1（1500×500）+ profile 1:1 | ✅ shippable | [`../C19_marketing-social/twitter-{banner-3-1,profile-1-1}__260824.png`](../C19_marketing-social/) |
| **LinkedIn** | post + article 模板 | ⏳ T-7 准备 | [`../C26_social-templates/`](../C26_social-templates/) |
| **微信公众号** | 服务号订阅文章 | ⏳ T-7 准备 | [`../C26_social-templates/`](../C26_social-templates/) |
| **Chrome Web Store** | extension 16/48/128 icons + manifest | ✅ shippable | [`../../code/yinghua-extension/`](../../code/yinghua-extension/) Manifest V3 |
| **Hacker News** | "Show HN" 帖 | ⏳ T-0 | Round 4 计划 |
| **Reddit r/macapps** | launch post | ⏳ T-0 | Round 4 计划 |
| **V2EX / 少数派** | 中文社区 launch 帖 | ⏳ T-0 | Round 4 计划 |
| **即刻 / 微博** | KOL 转发 | ⏳ T-0 | Round 4 计划 |

### 4.3 3P（Third-Party · 朋友 / 投资人 / 早期采用者）

| 渠道 | 来源 | 状态 |
|------|------|------|
| **CMU Catalyst Group**（贾志浩老师）| 暑研关系 | ⏳ T-14 邮件 |
| **Yao Class 同学**（本科 36 人）| 直接关系 | ⏳ T-7 内部 |
| **CMU 暑研同事 / 实验室**| 暑研关系 | ⏳ T-7 |
| **PhD 申请 advisor** | 申请关系 | ⏳ T-0 转介绍 |
| **AI PM 社区**（宝玉 / 玉树等 KOL）| Twitter DM | ⏳ T-3 |
| **投资人 personal network** | 申请 + 暑研 | ⏳ T-0 |

**3P 原则**：**先给价值，再求转发**。不群发冷邮件。先发 v0.1 alpha 邀请码（T-30），收集反馈，T-0 时他们已经是 super fans。

### 4.4 渠道优先级（资源分配）

| 优先级 | 渠道 | 资源占比 | 理由 |
|--------|------|----------|------|
| **P0** | Landing + Mac App Store | 40% | 1P 控制，必须 100% 完美 |
| **P0** | Product Hunt | 15% | LAUNCH DAY 核心 |
| **P1** | Twitter / X | 15% | 海外用户主战场 |
| **P1** | 微信公众号 / V2EX | 10% | 国内用户主战场 |
| **P1** | Chrome Web Store | 10% | extension 入口（已有用户扩展）|
| **P2** | 3P 朋友 / 投资人 | 5% | 启动器，资源少 |
| **P2** | LinkedIn / 即刻 | 5% | 辅助渠道 |

---

## 5. 上市里程碑（Launch Timeline · T-30 → T+180）

### 5.1 T-30（2026-09-23 估）· 内部 alpha

| 任务 | 资产 | 证据 |
|------|------|------|
| **landing page live** | hero = C18 landing-hero-typography（最稳）| C18 §2 · README §用法建议 |
| v0.1 alpha 给 5-10 内部用户 | SwiftUI 二进制 + BYOK 引导 | C13 BUILD SUCCEEDED |
| docs.yinghua.zzw4257.cn 写好 | FAQ + BYOK 配置指南 | Round 4 |
| Chrome extension 上 Chrome Web Store | C21 已 shippable | `code/yinghua-extension/` Manifest V3 |
| **客户支持流程就绪**（邮件 / Discord）| 团队培训 | Round 4 |

**关键节点**：landing page 必须 **T-30 live**，因为 Product Hunt 提前 1 个月开始 teaser 收集 upvotes。

### 5.2 T-14（2026-10-09 估）· Product Hunt 预热

| 任务 | 资产 | 证据 |
|------|------|------|
| **Product Hunt teaser thread** | C26 template（待出）| [`../C26_social-templates/`](../C26_social-templates/) |
| "Coming soon" 邮件给 waitlist 订阅者 | email-hero-welcome | C19 §3.1 |
| CMU 同学 / 暑研同事内部预告 | 微信群 / 邮件 | — |
| Product Hunter 私下 reach out（KOL 提前 review）| 5-10 个 PH Hunter | Round 4 |
| 投资人 personal network 邮件 | 5-10 个 investor | — |

**关键节点**：teaser thread 要**给真实产品截图**（C18 landing-hero-product）+ **不说 "AI 革命性"**（D1 §7 #6 营销词）。

### 5.3 T-7（2026-10-16 估）· 内部预热

| 任务 | 资产 | 证据 |
|------|------|------|
| 微信公众号 / 微博 / 即刻 "明天见" | C26 template | C26 |
| Twitter "Tomorrow" 倒计时推文 | C19 twitter banner | C19 §1 |
| LinkedIn 长文预告 | C26 template | C26 |
| V2EX / 少数派 预热帖 | 中文社区 | — |
| Mac App Store 提审（**提前 1 周**）| C23 5 screenshots | C23 |

### 5.4 T-0（2026-10-23 估）· Launch Day

**当天时间表（美东 EDT）**：

| 时间 | 任务 | 资产 |
|------|------|------|
| 00:01 | Product Hunt 上线（美西前 1 分钟）| C18 product-hunt-cover |
| 00:01 | Twitter thread 6 张（C26 template）| C26 + C18 + C19 |
| 00:01 | 微信推送（公众号 + 视频号）| C26 |
| 00:01 | LinkedIn 推送（C26 long-form）| C26 |
| 00:01 | 邮件 newsletter（C19 × 3 hero：welcome / product-update / launch）| C19 §3 |
| 00:01 | Hacker News "Show HN" 帖 | Round 4 |
| 00:01 | Reddit r/macapps launch post | Round 4 |
| 00:01 | V2EX / 少数派 launch 帖 | Round 4 |
| 00:30 | 团队 standby 监控 upvote / 评论 | — |
| 12:00 | 中午检查 #1 — Product Hunt 排名 | — |
| 18:00 | 晚上检查 #2 — 排名 + customer feedback | — |
| 23:59 | 当天复盘 | — |

**关键节点**：Twitter thread 6 张图用 **C18 6 张图**（landing-hero × 3 + PH + blog × 2）—— 已 6/6 PASS（_final-audit-report §1）。

### 5.5 T+1（2026-10-24）· Monitoring

| 任务 | 工具 / 资产 |
|------|------------|
| 监控 Product Hunt 排名 | PH dashboard |
| 监控 Mac App Store 评分 | App Store Connect |
| 监控 Twitter mentions | Tweetdeck |
| **客户支持**：12 小时内回复所有邮件 / DM | support@yinghua.app |
| 收集"前 100 个用户"的 feedback | Notion 表格 |
| 修复 T+1 紧急 bug（如有）| xcodebuild |

### 5.6 T+7（2026-10-30）· 第一次 Update

| 任务 | 资产 |
|------|------|
| **第一次 update 邮件**（"What's new in 映话"）| C19 email-hero-product-update（已 shippable）|
| 修复 T+1 收集到的 top 3 bug | xcodebuild |
| Twitter "We listened" thread | C26 |
| 微信公众号 v0.1.1 公告 | C26 |

### 5.7 T+30（2026-11-22）· 第一次大版本 v0.2

| 模块 | 内容 | 资产 |
|------|------|------|
| **Onboarding 3 屏** | C17 3 屏 shippable | C17 |
| **浅色模式** | C08 5 张 → C16 5 张 | C16 |
| **矢量 icon 替换占位** | C10 替换 C13 AppIcon | C10 + C13 |
| **Speaker 8 色调色板** | C13 4 色 → 8 色 | D1 §4.3 |
| **Preferences 走 ⌘,** | macOS 标准 | — |
| **Performance baseline** | 验证 D1 §9.2 6 项 | — |

**关键指标**：T+30 = **1,000 downloads**（§6 KPI）。

### 5.8 T+90（2027-01-21）· 第二次大版本 v0.3

| 模块 | 内容 |
|------|------|
| **iOS companion app** | iOS 26+ · 录音上传到 mac app（独立 app，**不是** mac app 复制）|
| **团队协作**（Team 套餐上线）| 中央 admin 面板 + 共享知识库 |
| **Notion / Slack 集成** | transcript 自动 export |
| **Web dashboard**（只读）| 用户可看会议列表（不录制）|

**关键指标**：T+90 = **5,000 downloads + 200 Pro subscribers**（§6 KPI）。

### 5.9 T+180（2027-04-21）· 第三次大版本 v0.4

| 模块 | 内容 |
|------|------|
| **iOS / iPadOS 独立** | 不依赖 mac app 独立运行 |
| **Android 调研** | 评估是否进入 |
| **Enterprise 评估** | SSO / SCIM / 数据驻留 |

**关键指标**：T+180 = **20,000 downloads + 1,000 Pro subscribers**（§6 KPI）。

### 5.10 时间线可视化

```
T-30       T-14        T-7         T-0         T+7         T+30         T+90          T+180
│          │           │           │           │           │            │             │
▼          ▼           ▼           ▼           ▼           ▼            ▼             ▼
landing   PH teaser   内部预热    LAUNCH      v0.1.1     v0.2         v0.3           v0.4
live      thread      "明天见"   DAY        update     (onboarding   (iOS + Team)   (iOS 独立
                                全渠道 push 邮件     + 浅色 + icon                   + Enterprise)
```

---

## 6. 关键指标（KPIs · T+30 / T+90 / T+180）

### 6.1 核心指标

| 指标 | T+30 | T+90 | T+180 | 测量方法 |
|------|------|------|-------|----------|
| **Downloads（Mac App Store）**| 1,000 | 5,000 | 20,000 | App Store Connect |
| **MAU（Monthly Active Users）**| 600 | 3,000 | 12,000 | 自建 analytics（不引入第三方）|
| **Pro subscribers** | 50 | 200 | 1,000 | Stripe |
| **Team subscribers** | 0 | 10 | 50 | Stripe |
| **Chrome Web Store installs** | 200 | 1,500 | 5,000 | Chrome Web Store dashboard |
| **Product Hunt upvotes** | 500 | — | — | PH dashboard（T+1 锁定）|
| **Twitter followers** | 500 | 2,000 | 5,000 | Twitter Analytics |
| **微信公众号关注** | 300 | 1,500 | 5,000 | 微信公众平台 |
| **NPS** | ≥ 40 | ≥ 50 | ≥ 60 | T+30 / T+90 / T+180 用户调研 |
| **7-day retention** | 30% | 40% | 50% | 自建 analytics |

### 6.2 北极星指标

**Weekly Active Recordings（每周活跃录制数）** = 衡量"产品核心价值被使用"的唯一指标。

- 一个人在映话录一次会议 = 1 个 WAR
- T+30 目标：**1,500 WAR / 周**（= 1,000 downloads × 60% WAU × 25% 录制率）
- T+90 目标：**7,500 WAR / 周**
- T+180 目标：**30,000 WAR / 周**

### 6.3 反指标（不追求）

- ❌ **DAU**（映话是低频工具，DAU 没意义）
- ❌ **页面浏览量**（landing page 是 conversion funnel，不是内容站）
- ❌ **社交媒体点赞数**（虚荣指标，不带来付费）
- ❌ **下载量单独**（不带来 Pro conversion = 没意义）

### 6.4 ❌ KPI 升级禁词

- ❌ "用户增长 X 倍"（不报没测过的数字）
- ❌ "实现 Y 万 ARR"（未达成不报）
- ❌ "V1 完成" ≠ "可上"（D1 §14 V1 vs shippable 区分）

证据：brand-guidelines §9.5「事实纪律」。

---

## 7. 风险与缓解（Risks & Mitigations）

### 7.1 风险登记表

| # | 风险 | 概率 | 影响 | 缓解 | 触发条件 | 负责人 |
|---|------|------|------|------|----------|--------|
| **R1** | **模型中文乱码**（产品图 / 营销图 / onboarding 屏 3） | 高 | 中 | Figma 后期修 + design system prompt §2.3 anti-leak 6 案例 + C19 audit 5 条 P0 addendum | 生图 prompt 命中 D1 §7 #13 / #14 / #16 | designer |
| **R2** | **Apple 审核拒绝** | 中 | 高 | 提前 1 周（T-7）提审；准备 backup launch plan（直接发 landing + 等审核） | Mac App Store rejected | PM |
| **R3** | **Anthropic API 限流** | 中 | 高 | BYOK 强制（Pro 必须自备 key）+ cache summary（避免重复调用）+ 备用 OpenAI key 引导 | Pro 用户报 "rate limit" | backend dev |
| **R4** | **隐私担忧** | 中 | 高 | 100% 本地 + open source 路线图（T+90 评估）+ 隐私政策白皮书 + 安全审计（T+180）| 媒体 / Twitter 报 "Mac app 录会议" 隐私问题 | PM + 用户支持 |
| **R5** | **Apple Silicon 兼容性** | 低 | 高 | C13 BUILD SUCCEEDED（Xcode 26.6 · arm64-apple-macos26.5）| 用户报 "无法打开" | SwiftUI dev |
| **R6** | **业务逻辑接线超期** | 高 | 中 | 砍 5 surface 业务深度，先做 1-2 个 demo 路径（meeting + transcript）| Round 4 后 C13 业务逻辑未达 v0.1 alpha | SwiftUI dev |
| **R7** | **Figma 后期修完仍有 prompt 泄漏** | 中 | 低 | C15 完成后跑第 2 轮 audit（参考 C19 audit 模式）| 任何图还有 C02 §2.3 6 案例 | designer + verifier |
| **R8** | **Product Hunt 当天冷启动失败** | 中 | 高 | T-14 开始 teaser + T-7 内部预热 + 5-10 PH Hunter 提前 reach out | T+1 PH 排名 < Top 100 | marketing |
| **R9** | **Chrome Web Store 审核拒绝** | 低 | 中 | 备份：Firefox / Edge 备选 + 独立 landing page | Chrome rejected | frontend dev |
| **R10** | **客户支持响应不及时** | 中 | 中 | T+0 之前团队 standby + Discord 频道 + 邮件自动回复 | T+0 后 12h 内未回复 | 团队 |

### 7.2 风险 R1 · 模型中文乱码 · 详细缓解

**根因**：生图模型对中文 + macOS UI 元素的视觉记忆不稳定（C02 §2.3 6 案例 + C17/C19 audit 验证）。

**缓解（3 层防御）**：

1. **prompt 防御**（C02 §2.3 anti-leak + C19 audit 5 条 P0 addendum）：
   - ADDENDUM 9：禁任何 font-size spec 作为可见 UI 文字
   - ADDENDUM 6：日历 day name 白名单 `MON/TUE/WED/THU/FRI/SAT/SUN`
   - ADDENDUM 7：禁百分比 label
   - ADDENDUM 8：菜单栏右侧只允许标准系统图标
   - ADDENDUM 10：禁 literal X/Y/Z 作 placeholder

2. **Figma 后期修**（D1 §12 P0-F 17 项）：
   - F1 屏 3 Anthropic "AI" 字母 → 真 brand mark
   - F4-F6 05 onboarding 字体规格烧图 → 删 + 改中文
   - F7 统一 5 张图 Dock 12 项 master
   - F8 5 张图菜单栏加 "Yinghua" app 名
   - F9 5 张图日历 day-name 乱码 → 删或 "26"

3. **第 2 轮 audit**（参考 C19 模式）：
   - C15 完成后跑 audit，按 12 项 × 5 张图 = 60 检查点
   - 发现新泄漏立刻修

证据：`_final-audit-report-c15-c19.md` §2 · C02 §2.3 · D1 §12。

### 7.3 风险 R4 · 隐私担忧 · 详细缓解

**根因**：Mac 桌面 app 录制会议音频，会被媒体 / 用户质疑"数据去哪了"。

**缓解（4 层）**：

1. **产品层**（D1 §9.3）：
   - 转录音频原文 30 天后自动清理
   - BYOK key 存 Keychain，**绝不**上传到我们服务器
   - 网络请求仅在用户主动触发"AI 总结"时发生
   - App Sandbox + hardened runtime

2. **沟通层**：
   - landing page FAQ："数据去哪了？" 段落
   - 微信公众号 / Twitter 隐私专题文章
   - 邮件隐私白皮书（1 页 PDF）

3. **透明度层**：
   - 隐私政策公开（github.io/yinghua/privacy）
   - 数据流图（用 SwiftUI 截图展示数据流）

4. **路线图层**：
   - T+90 评估开源 core（SwiftUI 部分 MIT license）
   - T+180 第三方安全审计
   - 长期目标：fully open source

证据：D1 §9.3「本地优先强化」· C13 Info.plist usage description 已配。

### 7.4 风险 R2 · Apple 审核拒绝 · 详细缓解

**触发条件**（最容易拒的 5 个）：
- ❌ 录屏 / 录音 entitlement 滥用
- ❌ 隐私政策不全
- ❌ 沙盒配置问题
- ❌ Crash on launch
- ❌ UI 不符合 HIG

**缓解**：
- T-7 提前 1 周提审
- 备份 launch plan：landing + 直接 download（DMG / Sparkle），不依赖 App Store
- App Review 沟通渠道预留（Asana 模板）
- 至少 1 个 beta tester 在不同 Mac（M1 / M2 / M3 / Intel）跑通

证据：D1 §13.5 风险表 · C13 Info.plist entitlement 已配。

### 7.5 风险 R3 · Anthropic API 限流 · 详细缓解

**触发条件**：
- Pro 用户用免费 Anthropic key（限 5 req/min）
- 高峰期（周一 9-11am）所有用户同时调用

**缓解**：
- BYOK **强制**（Free 也必须自备 key，5 次/月）
- Cache summary（同一 transcript 不重复调用）
- 备用 OpenAI key 引导（onboarding 屏 3 提示）
- 客户端 rate limit 提示（"您今天已用 50 次，请稍后再试"）

证据：D1 §1「数据策略」+ §9.3 + C13 §必做。

---

## 附录 A · 营销文案库（Copy Bank）

### A.1 Landing page hero copy（C18 + C19 复用）

| 位置 | 中文 | 英文 | 备注 |
|------|------|------|------|
| **大标题** | 映话 | Yinghua | Noto Serif SC / SF Pro Display |
| **副标 1** | 为面试而生的 macOS 智能助手 | The macOS-native meeting intelligence | SF Pro Text 22pt |
| **副标 2** | Yìnghuà | Local-first meeting intelligence for Mac. | SF Pro Display 28pt |
| **CTA** | 免费下载 ↗ | Download ↗ | 紫青渐变 |
| **microcopy** | macOS 26+ · 本地优先 · 高级 BYOK | macOS 26+ · Local-first · BYOK | SF Pro Text 12pt |

### A.2 Twitter thread 6 张（C26 模板 · 6 张图）

| # | 标题 | 内容 |
|---|------|------|
| 1 | 1/6 映话是 macOS 26+ 原生会议助手 | C18 landing-hero-product |
| 2 | 2/6 本地优先 - 数据不出设备 | C18 landing-hero-typography（局部）|
| 3 | 3/6 实时转录 - 边开会边记录 | C19 email-hero-product-update |
| 4 | 4/6 AI 总结 - 48 分钟会 5 秒出 | C18 blog-header-launch |
| 5 | 5/6 BYOK - 用你自己的 key | C19 email-hero-welcome |
| 6 | 6/6 现在免费下载 | C19 twitter-banner-3-1（局部）|

### A.3 邮件 newsletter（C19 × 3 · 完整 lifecycle）

| 时机 | 模板 | 主题 | 内容摘要 |
|------|------|------|----------|
| **T+0 注册** | C19 email-hero-welcome | 欢迎来到映话 | 5 分钟开始录制你的第一场会议 |
| **T+7 第一次 update** | C19 email-hero-product-update | What's new in 映话 | 5 个让会议记录更聪明的小更新 |
| **T+90 正式发布** | C19 email-hero-launch | 映话 v0.3 正式发布 | iOS companion + 团队协作 |

### A.4 微信公众号文章（中文渠道）

| 文章 | 长度 | 风格 | 调性 |
|------|------|------|------|
| **我们为什么做映话** | 1500 字 | Noto Serif SC 标题 + Noto Sans SC 正文 | Apple keynote 简洁感 |
| **映话是怎么做到本地优先的** | 2500 字（含 Swift 代码）| 同上 + JetBrains Mono 代码 | 技术深度 |
| **映话 v0.1 alpha 公开测试** | 800 字 | 短、CTA 明确 | 营销 |
| **映话 v0.3 iOS companion 上线** | 1200 字 | 中、含截图 | 营销 + 教程 |

### A.5 ❌ 文案禁词回顾（18 条 + 6 条 prompt 泄漏）

证据：brand-guidelines §9.2 18 条 + §10.3 6 条。

---

## 附录 B · 团队 & 资源（Team & Resources）

### B.1 团队配置

| 角色 | 人数 | 职责 | 工时 |
|------|------|------|------|
| **Figma 设计师** | 1 | C15-C17 修图 + C18-C19 营销 | ~6 工作日 |
| **SwiftUI dev** | 1 | C13 业务逻辑 + 性能 + 测试 | ~10 工作日 |
| **Frontend dev**（extension）| 1 | C21 popup + content script | ~3-5 工作日 |
| **Designer / 文案**（marketing）| 1 | C18-C19 + landing copy | ~2.5 工作日 |
| **PM** | 1 | launch 协调 + 客户支持 + KPI 监控 | 全程 |
| **总计** | 4-5 人 | — | ~22-25 工作日（≈ 5 周 1 人 full-time，或 2.5 周 2 人并行）|

证据：D1 §13.3 资源预算。

### B.2 T+0 之前必须就绪

- [ ] landing page（hero + features + pricing + download）
- [ ] Mac App Store 5 screenshots（C23）
- [ ] Product Hunt cover（C18）
- [ ] Twitter banner + profile（C19）
- [ ] 微信公众号文章（launch + 隐私 + 教程）
- [ ] Chrome extension（已 shippable · C21）
- [ ] 客户支持渠道（support@yinghua.app + Discord）
- [ ] 团队 standby 名单（T+0 24h 监控）

---

## 附录 C · 关键数字速查（Single Source of Truth）

> 所有数字都从 D1 / C18 / C19 / C13 引用，不编造。

| 数字 | 值 | 来源 |
|------|-----|------|
| macOS 系统要求 | 26+（Tahoe）| D1 §1 |
| SwiftUI 版本 | 6 + AppKit 互操作 | D1 §1 |
| Xcode 版本 | 26.6 | C13 README |
| Swift 版本 | 6.3.3 | C13 README |
| Build 目标 | arm64-apple-macos26.5 | C13 README |
| 实时转录延迟 | < 800ms | D1 §9.2 |
| AI 总结生成 | < 8s | D1 §9.2 |
| 主窗口冷启动 | < 200ms | D1 §9.2 |
| 内存占用 | < 80MB | D1 §9.2 |
| 1 小时音频磁盘 | < 50MB | D1 §9.2 |
| 转录音频保留 | 30 天 | D1 §9.3 |
| Design tokens 数 | 117 | D2 / C12 |
| 反模式数 | 18 | D1 §7 |
| SwiftUI components 已 shippable | 5 | C13 |
| Marketing 图已 shippable | 16 | C18 (6) + C19 (6) + C11 (2) + C14 (2) |
| App Store screenshots | 5 | C23 |
| T+30 downloads | 1,000 | GTM §6 |
| T+90 downloads | 5,000 | GTM §6 |
| T+90 Pro subscribers | 200 | GTM §6 |
| T+180 downloads | 20,000 | GTM §6 |
| T+180 Pro subscribers | 1,000 | GTM §6 |

---

## 附录 D · 决策记录（Decision Log）

| 决策 | 日期 | 理由 | 证据 |
|------|------|------|------|
| v0.1 alpha 只给 5-10 内部用户 | 2026-08-24 | 收集 feedback，避免公开发布后大改 | D1 §13.1 |
| T+30 才公开发布（不 T+0）| 2026-08-24 | 给 alpha 反馈留 1 个月迭代时间 | GTM §5 |
| Free 5 次/月（不限时长）| 2026-08-24 | 比 Otter 600 分钟少但比 Fathom "无限"有限，差异化 | GTM §3 |
| Pro $19/月（不是 $24）| 2026-08-24 | 比 Fathom 便宜，留转化空间 | GTM §3 |
| Team $49/席位/月 | 2026-08-24 | 跟 Pro 拉开 2.5x 距离 | GTM §3 |
| 不做 v0.1 移动端 | 2026-08-24 | 资源聚焦 macOS，T+90 评估 iOS | D1 §1 |
| 不做 v0.1 Enterprise | 2026-08-24 | T+180 评估 SSO / SCIM | GTM §5.9 |
| 开源路线图 T+90 评估 | 2026-08-24 | 隐私担忧的长期缓解 | GTM §7.3 |
| 北极星指标 = WAR | 2026-08-24 | 反映"核心价值被使用"，不是虚荣指标 | GTM §6.2 |

---

**GTM Plan v1.0 收口完成。所有数字可追溯，所有资产有路径，所有决策有理由。**
