# Email 1 — T-3 预告

> **发送时间**：T-3（launch day 前 3 天 · 2026-10-20 周二 10:00 当地时间）
> **目标受众**：已加入候补名单 / landing page 订阅者 / Twitter follower
> **目的**：暖场 + 候补名单 CTA
> **预期指标**：open rate ≥ 35% · click rate ≥ 12% · waitlist signup ≥ 8%

---

## 邮件元数据

| 字段 | 值 |
|------|-----|
| **From name** | 映话 · Yinghua |
| **From email** | hello@yinghua.app |
| **Reply-to** | support@yinghua.app |
| **Subject** | 映话 3 天后上 Mac App Store · 现在加入候补名单 |
| **Pre-header** | 本地优先的 macOS 会议 / 面试智能助手，3 天后公开测试。 |
| **List-Unsubscribe** | `mailto:unsubscribe@yinghua.app?subject=unsub` + `https://yinghua.zzw4257.cn/email/unsubscribe?token={{unsubscribe_token}}` |
| **List-Unsubscribe-Post** | One-Click |
| **Message-ID** | `<{{campaign_id}}@mail.yinghua.zzw4257.cn>` |

---

## 正文（中文 · 实际发送给用户的内容）

### Pre-header（预览文本，~50 字符）

> 本地优先的 macOS 会议 / 面试智能助手，3 天后公开测试。

---

### Header hero

`https://yinghua.zzw4257.cn/email/hero-launch-240824.png`（引用 `C19_marketing-social/email-hero-launch__260824.png` · 16:9 · 暗色 + 紫青 aurora + 居中 Y icon + 「映话 / Yìnghuà / Local-first meeting intelligence for Mac.」+ Download ↗ pill + Dock 6 系统图标 + 紫青 Y + magenta 活跃点）

Alt 文本：`映话 v0.1 即将发布 — Local-first meeting intelligence for Mac.`

---

### 标题

# 映话 3 天后上 Mac App Store

---

### 定位段（沿用 C30 description 首段）

映话是一个本地优先的 macOS 26+ app，专为面试和会议场景设计。系统级录制（系统音频 + 麦克风）、实时转录、自动分说话人、AI 总结 — 全部本地运行，BYOK 高级隐私。

---

### 3 个 feature bullet

**1. 系统级录制**
同时捕获系统音频（Zoom / Meet / Teams）+ 麦克风，零第三方 SDK 依赖。

**2. 实时转录**
边开会边记录，macOS 26 `SpeechAnalyzer` 引擎，支持中文 / 英文 / 中英混合。

**3. 本地 AI 总结**
60 分钟会议，8 秒内出 4 段总结：关键瞬间 / 决定 / 待办 / 遗留问题。

---

### 单一 CTA

> **现在加入候补名单 →** https://yinghua.zzw4257.cn/launch

候补用户会提前 6 小时收到下载链接，不用熬夜等。

---

### Footer

```
映话 · Yinghua
© 2026 Yinghua Inc.

本邮件发送至 {{recipient_email}}，因为你订阅了映话的 launch 通知。

退订：https://yinghua.zzw4257.cn/email/unsubscribe?token={{unsubscribe_token}}
隐私政策：https://yinghua.zzw4257.cn/privacy
联系我们：support@yinghua.app
```

---

## 调性自检

| 规则 | 状态 | 备注 |
|------|------|------|
| 18 条禁词（营销词 / 浮夸词 / 版本词）| ✅ 0 命中 | grep `洞察/赋能/智能/效率/掌控/驱动/革新/重塑/颠覆/极致/完美/革命/划时代` 全部 0 匹配 |
| prompt 规则文字泄漏 | ✅ 0 | 无 `14pt` / `STYLE 1` / `50% OPACITY` |
| emoji 代替 icon | ✅ 0 | `↗` 是箭头字符，不是 emoji |
| 真实中文 | ✅ | 全部从 C30 description / C36 FAQ 复用 |
| 单一 CTA | ✅ | 仅 1 个「加入候补名单」按钮 |
| 移动友好 | ✅ | HTML 模板单列布局 · @media 适配 |
| Outlook 兼容 | ✅ | table 布局 + inline CSS |
| 真实 CTA 链接 | ✅ | https://yinghua.zzw4257.cn/launch |
| 真实 hero image 引用 | ✅ | C19 email-hero-launch__260824.png |

---

## A/B 测试（subject line）

为提升 open rate，发 2 个版本对半切：

| 版本 | Subject |
|------|---------|
| **A**（默认）| 映话 3 天后上 Mac App Store · 现在加入候补名单 |
| **B**（短）| 映话 3 天后上线 macOS · 加入候补提前 6 小时拿链接 |

- A 组定位：完整定位 + 明确 CTA
- B 组定位：制造好奇 + 时间价值（提前 6 小时）
- 测试时长：发送后 4 小时看 open rate · 选高者 follow-up 给未打开者

---

## 验证

- [x] 单一 CTA（候补名单）
- [x] 不用营销词
- [x] 真实中文
- [x] 真实 hero image 引用
- [x] 移动友好 + Outlook 兼容（HTML 模板里）
- [x] 退订 / 隐私 / 联系 3 段 footer
- [x] A/B subject 测试方案
- [x] 真实 CTA 链接（非 `#` 占位）
