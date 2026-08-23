# 映话 Support Docs

> C36 deliverable · 5 份支持文档母本
> 输出给：C29 marketing website 的 `/support` 子页 + `support@yinghua.app` 自动回复模板

---

## 5 个文件

| 文件 | 内容 | 目标位置 |
|------|------|----------|
| [faq.md](./faq.md) | 10 个最常见用户问题 · 100-200 字每个 | C29 `/support` 页 |
| [troubleshooting.md](./troubleshooting.md) | 8 个诊断 + 修法 · 引用实际代码 | C29 `/support/troubleshooting` 页 |
| [permissions-explained.md](./permissions-explained.md) | 4 个权限深度解释 | C29 `/support/permissions` 页 + onboarding 屏 2 详情 |
| [contact.md](./contact.md) | 5 个支持渠道 + 响应时间 | C29 footer + App Store support URL |
| `README.md`（本文件） | 用法 + 交叉引用 | 仅内部 |

---

## 用法

### 给 C29 marketing website 的内容

每份 md 都是 C29 `/support` 路径下某个子页的**源文**。`yinghua.zzw4257.cn/support` 是个静态生成站（应该是 Astro 或 11ty—— C18 landing 用的栈），把 md 直接渲染即可。

**关键**：每份 md 都有「最后一行引用块」指向其他 4 份 md——保留这个相对路径，部署时不会断。

### 给 `support@yinghua.app` 自动回复

`contact.md` 是欢迎邮件的母本。当用户首次发邮件到 support@：

```
Subject: 映话支持 - [Ticket #<auto>]

Hi,

我们收到了你的邮件。我们承诺 24 小时内回复（工作日）。

在你等的时候，90% 的问题能在下面 3 份文档里直接找到答案：

📚 常见问题 → https://yinghua.zzw4257.cn/support/faq
🔧 排查指南 → https://yinghua.zzw4257.cn/support/troubleshooting  
🔐 权限说明 → https://yinghua.zzw4257.cn/support/permissions

如果你的问题不在上面，**回复这封邮件** 附上：
- 映话版本（菜单栏 Yinghua → 关于）
- macOS 版本
- 复现步骤
- （如适用）诊断包：Yinghua → 帮助 → 诊断包

— 映话 Support Team
```

引用 `contact.md` 的「自助 checklist」段作为这个邮件的核心结构。

---

## 交叉引用 · 全图

```
                    design-doc v2.0 §9 实现注意
                            ↓
            ┌───────────────┴───────────────┐
            │                               │
       C30 app-store                  C31 legal 隐私
            │                               │
            ▼                               ▼
       系统要求                          API key 存储
       (macOS 26+ / Apple Silicon)       (Keychain 永不传)
            │                               │
            ▼                               ▼
    ┌───────────────┐               ┌──────────────┐
    │   faq.md      │ ←────────────→│  contact.md  │
    │  (10 问题)    │               │  (5 渠道)    │
    └───────┬───────┘               └──────────────┘
            │                               ▲
            ▼                               │
    ┌───────────────┐               ┌───────┴───────┐
    │ permissions   │ ←────────────→│ troublesh.    │
    │  -explained   │               │   (8 诊断)    │
    └───────────────┘               └───────────────┘
            │                               │
            └──────────────┬────────────────┘
                           ▼
                  code/Yinghua/.../*.swift
                  - AudioCaptureService
                  - TranscriptionService
                  - SummaryService
                  - KeychainService
                  - PermissionService
```

---

## 详细引用关系

### `faq.md` 引用了

- **C30 app-store-metadata** — FAQ #01 系统要求
- **C31 legal 隐私政策 §3.2** — FAQ #03 API key 存储
- **code/Yinghua/.../API/KeychainService.swift** — FAQ #03 实际 Keychain 实现
- **code/Yinghua/.../Audio/AudioCaptureService.swift** — FAQ #07-08 实际录音实现
- **code/Yinghua/.../Transcription/TranscriptionService.swift** — FAQ #09 speaker diarization
- **design-doc v2.0 §9.3 本地优先** — FAQ #05 30 天清理策略
- **design-doc v2.0 §9.2 性能预算** — FAQ #04 离线能力

### `troubleshooting.md` 引用了

- **code/Yinghua/.../Audio/AudioCaptureService.swift** — §01 §04 屏幕录制 + 麦克风
- **code/Yinghua/.../Transcription/TranscriptionService.swift** — §02 AssetInventory 模型下载
- **code/Yinghua/.../API/SummaryService.swift** — §03 Invalid key 校验
- **code/Yinghua/.../API/APIProvider.swift** — §03 provider 鉴权 scheme
- **code/Yinghua/.../Permissions/PermissionService.swift** — §05 §07 权限流
- **code/Yinghua/.../YinghuaApp.swift** — §06 MenuBarExtra 优先级
- **C13 AppState.swift** — §08 v0.1→v0.2 迁移
- **design-doc v2.0 §9** — §07 macOS 限制（重启 app 限制）

### `permissions-explained.md` 引用了

- **code/Yinghua/.../Audio/AudioCaptureService.swift:174-284** — 麦克风 + 屏幕录制
- **code/Yinghua/.../Transcription/TranscriptionService.swift:109-208** — 语音识别
- **code/Yinghua/.../Permissions/PermissionService.swift:99-211** — 全 4 权限统一管理
- **code/Yinghua/Yinghua/Info.plist** — 4 个 `NS*UsageDescription` 提示文案
- **C31 legal 隐私政策** — 各权限的「数据去哪儿」段落
- **onboarding 屏 2（设计稿）** — 4 权限的 UI 排布 + 引导文案

### `contact.md` 引用了

- **C29 marketing website footer** — 联系方式展示
- **App Store support URL** — `support@yinghua.app` 是 App Store 后台填的
- **C31 legal 隐私政策 §联系信息** — 官方地址 / 法人
- **security.txt** — `/.well-known/security.txt` 标准

---

## 内容纪律（v2.0 调性锁）

所有 5 份 md 遵守：

- ✅ **中文优先** + 关键英文术语保留
- ✅ **真实数字** + **真实代码引用**（不写「很快」「一些」这种虚词）
- ✅ **失败也讲**（v0.1→v0.2 迁移会失败、5+ 人说话人会乱、过期 API key 会报 invalid）
- ✅ **3 段折叠**：用途 / 不授权会怎样 / 数据流（不写「赋能」「智能」这种营销词）
- ❌ **不写**「我们相信」「我们的使命」「AI 驱动」「高效」等无信息量的话
- ❌ **不写**「即将推出」「敬请期待」等拖延语——有就写 v0.X 版本号

---

## 维护

| 触发更新 | 谁负责 | 频率 |
|----------|--------|------|
| 映话新版本发布（v0.3 / v0.4...） | 文档 owner（暂定周子为） | 每个 release |
| 真实用户反馈的新高频问题 | support@ 收件人 | 每月 |
| macOS 27 升级（API 变动） | 文档 owner + 1 个 dev | 当年 |
| 设计 token / 提示文案改 | C29 marketing owner | 跟 design-doc v3 同步 |

---

## 验收

- ✅ 5 个 md 全交付
- ✅ FAQ 10 个 · 真实用户问题（不是模板）
- ✅ Troubleshooting 8 个 · 诊断 + 修法（带代码引用）
- ✅ Permissions 4 个 · 用途 + 不授权后果 + 数据流（三段折叠）
- ✅ Contact 全渠道 + 响应时间 + 时区
- ✅ 引用 C29 / C30 / C31 / code/ 设计 doc

---

*生成时间：2026-08-23 · C36 任务收口 · 详见 `_audit-c20-business-logic.md` 和 design-doc v2.0 §9*
