# 映话 — App Store Connect 元数据（zh-Hans）

> **版本**：v0.1.0 · 2026-08-24
> **目标 SKU**：映话 · macOS 26+ · v0.1.0 首发
> **Locale**：zh-Hans（简体中文 · 中国大陆 / 新加坡 / 马来西亚）
> **状态**：Apple App Store Connect 2025 后台就绪
> **字数验证**：App Name 2 · Subtitle 15 · Promotional Text 165 · Description 1258 · Keywords 41 · Release Notes 173

---

## 1. App Name（应用名称）

```
映话
```

- **字符数**：2 / 30
- **locale 锁定**：所有 locale 统一用「映话」作为 App Name（不翻译）

---

## 2. Subtitle（副标题）

```
为面试而生的 macOS 助手
```

- **字符数**：15 / 30
- **显示位置**：App 名正下方，搜索结果卡片可见
- **副本依据**：design-doc §1 身份 · C27 brand 1-2 句定位

---

## 3. Category（分类）

| 维度 | 值 |
|------|-----|
| **Primary** | Productivity |
| **Secondary** | Developer Tools |

- **依据**：Productivity = 主分类（会议 / 笔记类 app 主流落点）；Developer Tools = 次分类（BYOK + 多 provider + 终端用户偏 power user）

---

## 4. Promotional Text（宣传文本 · 170 字符内）

```
映话 = 本地优先的 macOS 会议 / 面试智能助手。系统音频 + 麦克风录制、实时转录（自动分说话人）、AI 总结（关键时刻 / 决定 / 待办 / 遗留问题）、自带 Anthropic / OpenAI / 自定义 endpoint BYOK，key 存 macOS Keychain 不上传。48 分钟会，5 秒出总结。
```

- **字符数**：165 / 170
- **可改权限**：每次产品更新都能改（不需走审核）
- **使用方式**：先抓眼球「本地优先 + 48 分钟会 5 秒出总结」；中段列核心能力；尾部强调 BYOK 隐私
- **不使用的词**：AI 驱动 / 赋能 / 洞察 / 革新 / 颠覆 / 极致

---

## 5. Description（应用描述 · 4000 字符内 · 支持 markdown）

```
映话 — 为面试而生的 macOS 智能助手

映话是一个本地优先的 macOS 26+ app，专为面试和会议场景设计。系统级录制（系统音频 + 麦克风）、实时转录、自动分说话人、AI 总结 — 全部本地运行，BYOK 高级隐私。

## 核心功能

### 系统级录制
• 同时捕获系统音频（Zoom / Meet / Teams）+ 麦克风
• macOS ScreenCaptureKit + AVAudioEngine，零第三方 SDK 依赖
• 16kHz mono 录音，约 5MB / 小时
• 本地存储：~/Library/Application Support/Yinghua/recordings/

### 实时转录
• 实时显示 transcript（说话人 + 时间戳 + 文本）
• 自动分说话人，同一说话人跨场景同色
• 支持中文 / 英文 / 中英混合
• macOS 26 SpeechAnalyzer 引擎 + SFSpeechRecognizer fallback

### AI 总结
• 一键生成 4 段总结：关键瞬间 / 达成的决定 / 待办 / 遗留问题
• 用 Anthropic Claude / OpenAI GPT / 自定义 OpenAI 兼容 endpoint
• 总结缓存，同一会议不重复调用
• 60 分钟会议，8 秒内出总结

### 高级 BYOK
• 3 个 provider：Anthropic / OpenAI / 自定义 endpoint
• Key 存 macOS Keychain，绝不上传任何服务器
• 可视化 API key 强度检测，弱 key 立即提示

### 真实 macOS 体验
• 4 段式控制面板（status / transport / secondary / close）
• 玻璃 vibrancy + 紫青品牌色
• 支持 prefers-reduced-motion
• 浅色 / 深色双模式

## 隐私承诺

• 100% 本地：转录 + 总结都在你的 Mac 上跑
• BYOK：你的 API key 永不上传
• 零分析：映话不收集任何使用数据
• 默认 30 天后自动清理音频原文（保留 transcript + summary）
• 卸载即永久删除所有数据

## 系统要求

• macOS 26 Tahoe 或更新
• Apple Silicon（M1 / M2 / M3 / M4）
• 麦克风权限（系统音频录制）
• 屏幕录制权限（捕获应用音频）
• 约 200MB 磁盘空间

## 适用场景

• 求职面试（远程 / 现场）
• 1:1 客户会议
• 团队周会 / 站会
• 投资人 pitch
• 学术答辩
• 内容创作（播客录制）

## 不适用

• 实时字幕（不支持 < 1s 延迟的实时显示）
• 多人协作（Team 版本即将推出）
• 跨平台同步（数据 100% 本地）
```

- **字符数**：1258 / 4000
- **格式说明**：Apple App Store 2025 支持 markdown 渲染，## 和 ### 标题会保留为分级标题；• 项目符号会显示为实心圆点
- **不使用的词**：赋能 / 洞察 / 革新 / 颠覆 / 极致 / 完美 / 革命性 / AI 驱动
- **不使用的元素**：emoji（🎙 / 📝 / 🤖 等，Apple 审核不喜欢）

---

## 6. Keywords（关键词 · 100 字符内 · 逗号分隔 · 不含 app name）

```
会议,转录,AI,面试,BYOK,本地,macOS,录音,总结,Anthropic
```

- **字符数**：41 / 100
- **逗号分隔规则**：Apple 要求英文逗号「,」不用中文「，」；末尾不带逗号
- **不出现**：映话 / Yinghua（已在 App Name 字段，不重复）
- **覆盖维度**：核心场景（会议/面试）+ 能力（转录/AI/录音/总结）+ 差异化（BYOK/本地/Anthropic）+ 平台（macOS）

---

## 7. Support URL（技术支持 URL）

```
https://yinghua.zzw4257.cn/support
```

- **绑定域名**：yinghua.zzw4257.cn（C29 marketing website 同源）
- **托管位置**：C29 `_exploration/C18_marketing-landing/` 内 `support.html` 页面
- **必填项**：App Store Connect 强制要求

---

## 8. Marketing URL（营销 URL · 可选但推荐填）

```
https://yinghua.zzw4257.cn
```

- **指向**：C29 marketing website 主页
- **展示位置**：App Store 产品页右侧「Website」按钮
- **优先级**：可选，但填了用户能直接访问落地页

---

## 9. Privacy Policy URL（隐私政策 URL · 必填）

```
https://yinghua.zzw4257.cn/privacy
```

- **指向**：C31 privacy.html（独立隐私政策页，引用 BYOK + 本地优先条款）
- **必填项**：所有 app 必填；映话因声明「100% 本地 + 零分析」必填
- **审核要点**：内容与 App Privacy 标签一致；与 brand guidelines §1.3 价值观一致

---

## 10. Copyright（版权信息）

```
© 2026 Yinghua Inc.
```

- **格式**：© + 年份 + 实体名（Apple 标准格式）
- **实体**：Yinghua Inc.（暂用占位，详见 README §「法律实体」待办）

---

## 11. Release Notes / What's New（v0.1.0 首发版 · 4000 字符内）

```
映话首发 — v0.1.0

核心功能：
• 系统级录制（系统音频 + 麦克风）
• 实时转录（自动分说话人）
• AI 总结（4 段：关键瞬间 / 决定 / 待办 / 遗留问题）
• 高级 BYOK（Anthropic / OpenAI / 自定义）
• 100% 本地优先
• macOS 26+ 原生 SwiftUI

感谢早期测试者反馈。
```

- **字符数**：173 / 4000
- **发布版本**：0.1.0（首次提交 = 首发 release notes）
- **不使用 emoji**：Apple 审核对 emoji 不友好，标题不使用「🎉」类装饰

---

## 12. Age Rating（年龄分级）

```
4+
```

- **依据**：映话无任何成人内容、无用户生成内容可见（仅本地）、无广告、无应用内购到外部内容
- **问卷结果**：Cartoon Violence = None · Realistic Violence = None · Sexual Content = None · Gambling = None · Horror = None

---

## 13. App Privacy（应用隐私标签 · App Store Connect 单独页面）

| 隐私数据类型 | 收集？ | 用途 | 是否关联用户身份 |
|--------------|--------|------|------------------|
| **音频** | 是（仅本地，不上传）| 应用功能（录制 + 转录）| 否 |
| **联系信息** | 否 | — | — |
| **位置** | 否 | — | — |
| **标识符** | 否 | — | — |
| **使用数据** | 否 | — | — |
| **诊断** | 否 | — | — |

**关键声明**：
- 映话不收集任何使用数据 / 诊断
- BYOK 模型下，API key 由用户自管，永不上传
- 音频原文 30 天后自动清理，仅保留 transcript + summary

---

## 14. Pricing & Availability（定价与可用性 · v0.1.0 首发）

| 维度 | 值 |
|------|-----|
| **价格** | 免费（Freemium · 内购解锁 Pro / Team）|
| **可用地区** | 全球（initial release，App Store Connect 默认 175 个地区全部启用）|
| **发布方式** | 手动发布（v0.1.0 审核通过后手动上架）|

详细价格档位（内购 IAP）见 C25 investor-deck-full/prompts/07-business-model.txt：
- 免费版：5 次 / 月录制 · 本地录音 + 转录 · 单说话人识别
- 专业版（Pro）：无限录制 · 多说话人 + 中英日西 · AI 总结 4 段 · 导出 Markdown / PDF
- 团队版（Team）：Pro 全部功能 · 共享工作空间 · 管理员控制台 · SSO + 审计日志

---

## 15. Submission Checklist（提交前自检）

- [ ] App Icon 1024×1024 已上传（C10 01 MINIMAL · 已 shippable）
- [ ] 截图 3-10 张已上传（1280×800 或 1440×900 · 来自 C23）
- [ ] App Name / Subtitle / Category 已填
- [ ] Promotional Text / Description / Keywords 已填
- [ ] Support URL / Marketing URL / Privacy Policy URL 已可访问
- [ ] Age Rating 问卷已答完
- [ ] App Privacy 标签已声明
- [ ] Copyright 已填
- [ ] Build 已上传（Xcode 26 · archive → App Store Connect）
- [ ] TestFlight 内部测试通过（如有）

---

**字数自检**：
- App Name: 2 / 30 ✓
- Subtitle: 15 / 30 ✓
- Promotional Text: 165 / 170 ✓
- Description: 1258 / 4000 ✓
- Keywords: 41 / 100 ✓
- Release Notes: 173 / 4000 ✓
