# Email 3 — T+7 跟进反馈

> **发送时间**：T+7（launch day 后 7 天 · 2026-10-30 周五 10:00 当地时间）
> **目标受众**：T+0 邮件中点击过 CTA 但未完成填表的用户 + 真实活跃用户（按 in-app event 筛）
> **目的**：收集前 7 天的体验反馈 + 用 Pro 1 个月做激励
> **预期指标**：open rate ≥ 28% · click rate ≥ 10% · survey completion ≥ 8%

---

## 邮件元数据

| 字段 | 值 |
|------|-----|
| **From name** | 映话 · Yinghua |
| **From email** | hello@yinghua.app |
| **Reply-to** | support@yinghua.app |
| **Subject** | 你用映话了吗？30 秒反馈帮我们改进 |
| **Pre-header** | 7 天小问题征集 · 答完送 1 个月 Pro |
| **List-Unsubscribe** | `mailto:unsubscribe@yinghua.app?subject=unsub` + `https://yinghua.zzw4257.cn/email/unsubscribe?token={{unsubscribe_token}}` |
| **List-Unsubscribe-Post** | One-Click |
| **Message-ID** | `<{{campaign_id}}@mail.yinghua.zzw4257.cn>` |

---

## 正文（中文 · 实际发送给用户的内容）

### Pre-header（预览文本，~20 字符）

> 7 天小问题征集 · 答完送 1 个月 Pro

---

### Header hero（缩略版）

`https://yinghua.zzw4257.cn/email/hero-launch-thumb-240824.png`（引用 `C19_marketing-social/email-hero-launch__260824.png` 的 50% 缩略版，~600×340）

Alt 文本：`映话 v0.1 上线一周 — 我们在听。`

---

### 标题

# 你用映话了吗？

> 30 秒填完送 Pro

---

### 感谢段

谢谢你过去 7 天试用映话。

我们做这件事的初衷很简单：会议 / 面试场景下，**用户的数据应该留在用户自己的 Mac 上**，AI 总结是助手不是主角。一周下来我们已经收到一些反馈，但还不够 — **你这一票**对我们 v0.2 的方向最重要。

填一份 3 问小问卷（30 秒），答完我们送你 **1 个月 Pro**（价值 $19），不限新老用户。

---

### 3 个快速问题

**Q1. 哪些功能最有价值？**
（多选 · 至少 1 项）
- [ ] 系统级录制（系统音频 + 麦克风）
- [ ] 实时转录（说话人 + 时间戳）
- [ ] AI 总结（4 段：关键瞬间 / 决定 / 待办 / 遗留问题）
- [ ] BYOK（自带 API key）
- [ ] 导出（PDF / Markdown / SRT）

**Q2. 哪些问题？**
（多选 · 可选）
- [ ] 录不到系统音频
- [ ] 转录延迟高 / 识别错
- [ ] 说话人识别切错
- [ ] AI 总结不准确
- [ ] 导出格式不对
- [ ] App 崩溃 / 卡顿
- [ ] 其他：________

**Q3. 哪些功能 missing？**
（自由文本 · 1-3 条）
（例：想要章节标记 / 想要 Notion 集成 / 想要 iOS 同步 / 想要自定义 system prompt）

---

### 单一 CTA

> **30 秒反馈 →** https://yinghua.zzw4257.cn/feedback/t7

---

### 副标 · 答完奖励

> 答完立刻收到 1 个月 Pro 兑换码，24 小时内 email 给你。

奖励机制：填完问卷即生成 single-use promo code（Stripe 端配置），邮件自动发送；**有效 90 天**。

---

### Social proof

> 已经 {{actual_count}} 位用户填了（发邮件前替换为真实数字 · 目标 ≥ 50）

事实纪律：发送前必须用真实数字替换。0 填时不发本邮件 / 改成纯感谢信 + 邀请语。

---

### Footer

```
映话 · Yinghua
© 2026 Yinghua Inc.

本邮件发送至 {{recipient_email}}，因为你使用过映话 v0.1。

退订：https://yinghua.zzw4257.cn/email/unsubscribe?token={{unsubscribe_token}}
隐私政策：https://yinghua.zzw4257.cn/privacy
联系我们：support@yinghua.app
```

---

## 调性自检

| 规则 | 状态 | 备注 |
|------|------|------|
| 18 条禁词 | ✅ 0 命中 | grep 全过 |
| prompt 规则文字泄漏 | ✅ 0 | 无 |
| emoji 代替 icon | ✅ 0 | 仅 checkbox `[ ]` + `→` 箭头 |
| 真实中文 | ✅ | 复用 C30 / C36 / C27 GTM |
| 单一 CTA | ✅ | 仅 1 个「30 秒反馈」按钮 |
| 移动友好 | ✅ | HTML 模板单列 + 复选框可点 |
| Outlook 兼容 | ✅ | table 布局 + inline CSS |
| 真实 CTA 链接 | ✅ | https://yinghua.zzw4257.cn/feedback/t7 |
| 真实 hero image 引用 | ✅ | C19 email-hero-launch 缩略版 |
| 状态词不许升级 | ✅ | social proof 数字明确标"发邮件前替换" |
| 否定结果主动展示 | ✅ | 注明"0 填时不发本邮件" |

---

## A/B 测试（subject line）

| 版本 | Subject |
|------|---------|
| **A**（默认）| 你用映话了吗？30 秒反馈帮我们改进 |
| **B**（激励驱动）| 答完送 1 个月 Pro · 30 秒填 3 个问题 |

- A 组定位：情感驱动 · 「你用了吗」引发反思
- B 组定位：利益驱动 · 直接抛奖励
- 测试时长：发送后 4 小时看 open rate + click rate
- 注意：click rate 高的版本奖励驱动更强，但后续 NPS 可能低（A 组更深思熟虑）

---

## 验证

- [x] 单一 CTA（30 秒反馈）
- [x] 3 个快速问题 · 30 秒可填完
- [x] 不用营销词
- [x] 真实中文
- [x] 真实 hero image 引用（缩略版）
- [x] 移动友好 + Outlook 兼容
- [x] 退订 / 隐私 / 联系 3 段 footer
- [x] A/B subject 测试方案
- [x] 真实 CTA 链接
- [x] social proof 数字明确标"发前替换"
- [x] 否定分支（0 填时不发）有预案
