# 映话 TestFlight Beta 计划总览

> **C51 · v0.1.0 公开前封闭 beta**
> **状态**：v1.0 · 2026-08-23 · 写作中
> **owner**：Worker agent · C51
> **基础**：[`../C27_brand-guidelines/gtm-plan__260824.md`](../C27_brand-guidelines/gtm-plan__260824.md) §5 上市里程碑 · [`../C30_app-store-metadata/`](../C30_app-store-metadata/) 14 字段 · [`../C36_support-docs/`](../C36_support-docs/) 5 份母本 · [`../C18_marketing-landing/`](../C18_marketing-landing/) 6 张视觉资产

---

## 0. TL;DR

| 维度 | 内容 |
|------|------|
| **项目** | 映话 (Yìnghuà) · macOS 26+ · v0.1.0 上市前封闭 TestFlight beta |
| **目标** | 在公开上市前 2 周内发现阻塞性 bug / 验证 BYOK 闭环 / 收集 NPS 基线 / 累积 5+ 公开证言 |
| **时间** | T-14（招募启动）→ T+0（公开上市）= **2 周封闭 beta**；T+0 → T+7 = **1 周公开观察期**（同一 build，公开下载） |
| **容量** | 招募 **300 名** 封闭 beta tester（TestFlight 硬上限 10,000，留 33× 安全余量） |
| **用户分群** | 60% 求职面试 · 20% 远程会议 · 20% 内容创作 |
| **关键指标** | 装机 ≥ 270 / 7-day retention ≥ 60% / NPS ≥ 50 / Crash rate < 0.1% / 5+ 公开证言 |
| **下一里程碑** | T+7 决定 v0.1.1 修哪些 P0 / P1 bug → T+14 v0.1.1 hotfix → T+30 v0.2（来自 C27 GTM §5.7） |

---

## 1. 名称 / 目标 / 时间窗口 / 容量

### 1.1 项目代号

**代号**：映话 TestFlight Beta · Wave 1（v0.1.0 上市前）
- 内部别名：Yinghua Beta · Closed Wave 1
- 公开 tagline："映话首批 300 人内测"（中文） / "Yinghua Closed Beta · 300 testers"（英文）
- 不叫「限量」「独家」「抢先」（C27 §9.2 禁词清单）

### 1.2 5 个目标（按优先级）

1. **发现 P0 / P1 阻塞性 bug**（录不进 / 转录全乱 / 总结必崩 / Keychain 异常）
2. **验证 BYOK 完整闭环**（key 配置 → 总结 → 缓存 → 失败重试 → 限额提示）
3. **建立 NPS 基线**（目标 ≥ 50，作为 T+30 / T+90 / T+180 的对照锚点）
4. **累积 5+ 公开证言**（带签名的 quote，用于 C18 landing hero C 变体 + App Store 截图 caption）
5. **验证 macOS 26 SpeechAnalyzer 在真实设备 / 真实会议场景的稳定性**（不是开发机的 5 秒试录，是 30-60 分钟真实会议）

### 1.3 时间窗口

```
T-14        T-7         T-0 (= GT-0 上市)         T+7            T+30
│           │           │                          │              │
▼           ▼           ▼                          ▼              ▼
招募启动   招募关闭     封闭 beta 启动 + Email 1   v0.1.1 hotfix  v0.2 大版本
landing    筛选 300    Email 4 (T+14 同 GTM T+0)   (来自 C27 GTM §5.7)
live +     配 TF slot  → 公开上市 on Mac App Store
表单开放   + 入 Discord
```

**重要：T 的双时基**
- **本文件 T 系**（TestFlight beta 视角）：T-0 = 封闭 beta 启动日 = 公开上市日
- **GTM 计划 T 系**（公开上市视角，C27 §5）：GT-0 = 公开上市日
- **两套 T 系同步**：本文件 T+14 = GTM GT-0（即公开上市当天的 email 4）

### 1.4 容量

| 维度 | 数量 | 依据 |
|------|------|------|
| **TestFlight internal tester 上限** | 100 | Apple 硬限制，不需要 App Review |
| **TestFlight external tester 上限** | 10,000 | 需要 Apple 简审（首次 build 走 review） |
| **目标 active testers** | 300 | 用户任务要求 200-500，取中位 |
| **申请表 buffer** | 500 | 接受 500 申请 → 选 300 → 200 进候补名单 |
| **1-on-1 call 配额** | 15 | PM 时间预算：每场 30 分钟 × 5 天 = 15 场 |
| **Discord #beta-feedback 容量** | 不限 | Discord server 默认 500,000 |

**TestFlight 选型**：用 **external tester**（300 ≤ 10,000 硬上限），不走 internal。理由：
- internal tester ≤ 100，不够 300
- external tester 可邀请公开 email（支持非 Apple Developer Program 成员）
- external 第一次走简审（约 24-48h），提前在 T-7 提交

---

## 2. 用户分群（300 名配额）

> 分群不是按「身份」分，是按「主要使用场景」分。一个面试候选人 80% 时间用于面试 + 20% 团队 sync，归「求职面试」。

| 分群 | 配额 | 人数 | 关键特征 | 期望产出的反馈 |
|------|------|------|----------|----------------|
| **A · 求职面试** | **60%** | 180 | 未来 90 天有 ≥ 1 次面试（远程 or on-site）；关心「我刚才答得怎么样」「哪几个技术点没答好」| 面试场景的 mic 切换 / 单人长录稳定性 / 关键问答高亮（v0.2 功能预告）的真实需求 |
| **B · 远程会议** | **20%** | 60 | 远程团队成员；每周 ≥ 3 次会议；关心「会后 5 分钟能出总结」| 多说话人 diarization 准确率 / Speaker 颜色持久化 / export 格式 |
| **C · 内容创作** | **20%** | 60 | 播客 / YouTube / 课程录制；关心「自动 chapter / 自动 SRT」| 长录 (>60min) 稳定性 / 背景噪音处理 / 静音段处理 |

### 2.1 分群筛选机制

申请表第 3 字段「用途」让用户自选 3 选 1：
- 选项 A：求职面试（180 配额）
- 选项 B：远程会议（60 配额）
- 选项 C：内容创作（60 配额）

按时间戳 + email 域名（公司邮箱 vs 个人邮箱）排序：
- 先到先得，直到该分组满
- 满后自动进候补名单（waitlist）

### 2.2 配额监控

- 实时：Notion 表格（`Beta Applicants DB`）按分组计数
- 每日 22:00（北京时间）snapshot 到 Slack #yinghua-beta-ops
- 配额超调 10% 内可接受，超调 20% 触发 PM 介入调整下批邀请

---

## 3. 关键里程碑（2 周封闭 + 1 周观察）

| 时点 | 任务 | 负责人 | 交付物 |
|------|------|--------|--------|
| **T-14** | 招募 landing page 上线（yinghua.zzw4257.cn/beta）| designer + PM | landing 页面 + 4 字段表单 + 后端 |
| **T-14** | Twitter / LinkedIn / Product Hunt teaser 第一波 | PM | 3 渠道发帖 |
| **T-14** | Reddit r/macapps / r/MacOS 长帖 | 社区 owner | 2 个 subreddit 帖 |
| **T-14** | Hacker News "Show HN" 预约（定时 T-0 发布）| PM | HN scheduled post |
| **T-14** | IndieHackers 社区 thread | PM | 1 个主帖 + 2 个回复 |
| **T-7** | 招募关闭（表单 23:59 截止）| PM | 关闭后导出 CSV |
| **T-7** | 筛选 300 + 候补 200 + 拒绝 100+ | PM | Notion 表格最终态 |
| **T-7** | TestFlight external build 提交 Apple 简审 | dev | build 1.0 提交 |
| **T-3** | Apple 简审通过，收到 external tester 邀请链接 | dev | TF 邀请 URL 就绪 |
| **T-2** | Discord #beta-feedback 频道就位 + 300 个邀请码生成 | PM + 社区 | Discord 配置 + CSV |
| **T-0 day 0** | 发送 **Email 1**（欢迎 + TestFlight 邀请）| PM | 300 emails 发出 |
| **T-0 day 0** | Discord 公告 #announce | 社区 | 1 个置顶公告 |
| **T+3 day 3** | 发送 **Email 2**（怎么用 + 5 个用例）| PM | 300 emails 发出 |
| **T+7 day 7** | 发送 **Email 3**（征集 feedback + 1-on-1 邀请）| PM | 300 emails + 15 个 call slot |
| **T+7 day 7** | 第 1 周 metrics dashboard 锁定 | dev | 5 KPI 实测数 |
| **T+7 day 7** | v0.1.1 hotfix 修 P0 / P1 bug（基于 beta 反馈）| dev | v0.1.1 build |
| **T+14 day 14** | 发送 **Email 4**（感谢 + 公开上市预告）| PM | 300 emails |
| **T+14 day 14** | 公开上市 on Mac App Store | PM | 1.0 提交 → 审核通过 → release |
| **T+14 day 14** | 公开上市当天同步发 Twitter thread 6 张 | PM | C18 6 张图 |
| **T+21 day 21** | 封闭 beta 关闭，Discord #beta-feedback 改 read-only | 社区 | 频道锁 |
| **T+30** | v0.2 大版本（来自 C27 GTM §5.7）| dev | onboarding 3 屏 + 浅色模式 + 矢量 icon |

---

## 4. 风险登记表

| # | 风险 | 概率 | 影响 | 缓解 | 触发条件 |
|---|------|------|------|------|----------|
| **R1** | Apple TestFlight external review 拒绝 | 中 | 高 | 提前 T-7 提交；准备 1-2 段 demo 视频 | Apple reject email |
| **R2** | SpeechAnalyzer 在真实场景掉链子（中英文混读 / 多人抢话）| 高 | 中 | B + C 组配额 30% 给「中英文混读」场景；出问题就 push 给 v0.2 | beta tester 报「转录乱」 |
| **R3** | Anthropic API 限流（beta tester 集中用）| 中 | 中 | BYOK 强制（用户自备 key）+ cache summary + Email 3 提前告知 | support@ 收 3+ rate limit 邮件 |
| **R4** | 招募配额失衡（求职 300 / 远程 0 / 创作 0）| 中 | 中 | 招募 3 天后 snapshot，按比例调整下批推广 | 实际配额偏离目标 ±20% |
| **R5** | beta tester 集中爆 P0 bug 当天没人力响应 | 中 | 高 | 排班表（PM + 1 dev 7×12h standby） + Slack on-call | T+0 to T+7 任一工作日 |
| **R6** | NPS 低于 30（说明产品核心价值不成立）| 低 | 高 | 触发 v0.1.1 hotfix + 1-on-1 call 拉满 15 场深挖 | T+7 NPS 实测 |
| **R7** | 隐私担忧（"Mac app 录会议"被媒体误读）| 中 | 中 | 100% 本地 + BYOK 强调 + privacy 页面置顶（C31）+ 准备 1 段 30 秒说明视频 | 任何媒体 / Twitter 报"隐私" |
| **R8** | 招募 landing page 表单被刷（bot 灌水）| 中 | 中 | Cloudflare Turnstile（无感 CAPTCHA） + email 域名黑名单 + 单 IP 限 3 次/天 | 异常申请量 |

---

## 5. 与 GTM 的关系

| 维度 | C51（TestFlight beta · 本文档）| C27 GTM plan（公开上市）|
|------|--------------------------------|--------------------------|
| **时间窗** | T-14 → T+14（封闭 beta）| T-30 → T+180（整个上市）|
| **用户量** | 300 封闭 + 200 候补 | 1,000 (T+30) / 5,000 (T+90) / 20,000 (T+180) |
| **核心指标** | 装机 / 7d retention / NPS / crash / 5+ 证言 | downloads / MAU / Pro subs / WAR |
| **主战场** | TestFlight + Discord + Email | Mac App Store + Product Hunt + Landing |
| **风险侧重点** | 闭环验证 + bug 修复 | 增长 + 付费转化 |

**接力关系**：
- T+14 公开上市日，300 beta tester 自动迁移成「前 300 个公开用户」 → 邀请加入「映话 Champions」社区（C57）
- beta 期间收集的 5+ 证言 → 直接进 C18 landing hero C 变体
- beta 期间修复的 P0/P1 bug → 进 C30 release notes「What's new in v0.1.1」
- 候补名单 200 人 → 公开上市当天发邀请码（C54 launch-emails 第 1 封）

---

## 6. 验收

- ✅ 6 个文件全交付（README + 5 主体）
- ✅ 时间线 T-14 → T+14 完整（含 T+21 收尾）
- ✅ 用户分群 60/20/20 + 筛选机制
- ✅ 8 项风险 + 缓解 + 触发条件
- ✅ 与 C27 GTM 的接力关系明确
- ✅ 4 封 email 模板（见 `beta-tester-onboarding.md`）
- ✅ 4 个 feedback channel（见 `feedback-collection.md`）
- ✅ 5 个 KPI 可测量（见 `beta-metrics-dashboard.md`）

---

*引用：C27 §5 上市里程碑 · C30 §15 提交 checklist · C36 §contact 5 渠道 · C18 6 张视觉资产 · design-doc v2.0 §9 本地优先*
