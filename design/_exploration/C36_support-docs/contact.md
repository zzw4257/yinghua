# 联系映话支持

> 5 个渠道 · 按紧急程度选 · 响应时间写在每条上
> 来源：映话 C29 website footer + App Store support URL 母本。

## 选哪个渠道？

```
                紧急？ ─→  安全漏洞 / 隐私事故 / 凭据泄露
                              ↓
                         security@yinghua.app（< 12h）
                              ↓
                         ⚠️ 用 PGP 加密，pubkey 在 https://yinghua.zzw4257.cn/.well-known/pgp.asc

                用着卡？ ─→  功能 bug / 转录异常 / 总结不工作
                              ↓
                         support@yinghua.app（< 24h 工作日）
                              ↓
                         附：Yinghua.app → 帮助 → 「诊断包」（生成 zip，含 logs + 系统信息）

                想吐槽？ ─→  新功能想法 / UI 反馈 / 吐槽
                              ↓
                         Discord（最快） / Twitter DM（次快）

                死磕技术？ ─→  源码相关 / 自己改 build / 提 PR
                              ↓
                         GitHub Issues（社区驱动，无 SLA）
```

---

## 5 个渠道 · 详细信息

### 📧 Email · 主要支持

| 字段 | 值 |
|------|------|
| 地址 | **support@yinghua.app** |
| 响应时间 | **< 24h 工作日**（北京时间 9:00-21:00，周末 +1 天） |
| 语言 | 中文 / English 都能处理，**中文优先** |
| 适合 | 功能 bug、设置问题、退款咨询、合作咨询 |
| 不适合 | 紧急安全报告（用 security@）· 营销骚扰 |

**提效技巧**：发邮件前先点「映话 → 帮助 → 诊断包」——会生成一个 zip（含 logs + 系统配置 + 最近的错误 trace），**附在邮件里能省来回 3 轮**。

---

### 🐦 Twitter / X DM · 公开反馈

| 字段 | 值 |
|------|------|
| 账号 | **@yinghua_app** |
| 响应时间 | **< 48h**（非工作时间不保证） |
| 语言 | 优先中文 / English 也行 |
| 适合 | 公开反馈（我们会回 tweet 给其他用户看）· 简单问题 · 想看公开 acknowledge |
| 不适合 | 涉及凭据 / 系统信息（公开推特不安全） |

---

### 💬 Discord · 社区 + 实时

| 字段 | 值 |
|------|------|
| 邀请链接 | **https://discord.gg/yinghua** |
| 响应时间 | **即时**（社区驱动，活跃时段秒回，UTC 12:00-24:00 响应最密集） |
| 频道 | `#help`（功能问题）· `#feedback`（吐槽/想法）· `#dev`（技术实现讨论）· `#announce`（只读，新版本通知） |
| 适合 | 快速问、围观别人怎么用、听 roadmap、debug 时贴 log |
| 不适合 | 紧急安全 / 退款 / 涉及凭据 |

**社区文化**：映话 team 在 `#dev` 频道常驻（周子为 + 1 个 maintainer）。你的 bug report 很可能**当天被 maintainer 看到**——但**不承诺 SLA**。

---

### 🐙 GitHub Issues · 开发者 / 长期 bug

| 字段 | 值 |
|------|------|
| 地址 | **https://github.com/yinghua-inc/yinghua** |
| 响应时间 | **社区驱动**（无 SLA，可能 1 周） |
| 适合 | 复现步骤清晰的 bug、源码相关问题、PR / RFC 讨论 |
| 不适合 | 日常使用问题（去 Discord 更快）· 不会写代码的用户（去 Email） |

**写 issue 前**：
1. 先搜 [existing issues](https://github.com/yinghua-inc/yinghua/issues) —— 90% 你遇到的问题已经有人提了
2. 用我们的 issue template（自动加载）
3. macOS 版本 / 映话版本 / 复现步骤 / 期望 vs 实际 —— 缺一项 maintainer 会直接 close

---

### 🚨 安全报告 · 私密 + 加急

| 字段 | 值 |
|------|------|
| 地址 | **security@yinghua.app** |
| 响应时间 | **< 12h**（含周末） |
| PGP 公钥 | https://yinghua.zzw4257.cn/.well-known/pgp.asc |
| 适合 | 凭据泄露、隐私事故、Keychain 漏洞、绕过权限隔离的 attack vector |
| **bug bounty** | v0.2 起启动 bounty program，high severity report 最高 $500（详细规则见 security policy） |

**走这个渠道如果你**：
- 发现映话把 API key 上传到了某个 endpoint
- 找到一种让映话录到 sandbox 外音频的途径
- 在 transcript 文件里发现其他用户的残留数据
- 任何让你**心里咯噔一下**的事

**不**用这个渠道问一般问题——会拖慢我们处理真安全事件的响应。

---

## 时区参考

- **北京时间（UTC+8）**：周一-周五 9:00-21:00 是主力响应窗口
- **美东时间（UTC-5）**：周一-周五 9:00-17:00 有维护人员
- **重叠时间**：北京时间 21:00 - 23:00 是两面都有人的「黄金窗口」—— 复杂问题尽量撞这个时间

---

## 提交 bug 前 · 自助 checklist

- [ ] 已查 [faq.md](./faq.md) · 10 个高频问题
- [ ] 已查 [troubleshooting.md](./troubleshooting.md) · 8 个诊断流
- [ ] 已升级到最新版本（菜单栏 Yinghua → 关于 → Check for updates）
- [ ] 已生成诊断包（Yinghua → 帮助 → 诊断包）

**全做完再发邮件** —— 5 分钟省我们 30 分钟互相问。

---

## 退款 / 计费

- 退款：support@yinghua.app，标题写「Refund」+ 订单号（Apple 发的 receipt 邮件里有）
- 订阅取消：App Store → 账户设置 → 订阅 → Yinghua Pro → 取消（**不要删 app**，删 app 不等于取消订阅）
- Pro 功能疑问：同上

---

*引用：C29 marketing website footer · App Store support URL · security.txt · C31 legal 联系信息*
