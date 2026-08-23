# C31 — Privacy Policy & Terms of Service · 独立审计

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：GDPR (EU 2016/679) + CCPA/CPRA (Cal. Civ. Code §1798.100+) + COPPA (15 U.S.C. §§ 6501–6506) + 中国《个人信息保护法》(PIPL, 2021-08-20 实施) + 巴西 LGPD + design-doc §1 价值观

---

## 检查项

### 1. 字数下限

| 文件 | 实测 char | 要求 | 通过？ |
|------|-----------|------|--------|
| `privacy-policy.md` | 15148 | ≥8000 | ✅（189% 超额）|
| `terms-of-service.md` | 12025 | ≥6000 | ✅（200% 超额）|

### 2. 章节完整性

**Privacy Policy**：18 个 `## ` 章节（§0～§17）
- §0 一句话承诺（"我们不收集任何数据"）
- §1 我们是谁（Yinghua Inc. 实体 / Bundle ID / 邮箱）
- §2 适用范围（含第三方 AI 服务的明确排除）
- §3 我们收集什么（5 件明确不做的 + 如何验证）
- §4 我们在本地存储什么（详细目录表）
- §5 API key 怎么用（Keychain / HTTPS / BYOK 流程）
- §6 第三方服务（Anthropic / OpenAI / Custom / Apple）
- §7 系统权限（5 项 NSUsageDescription）
- §8 数据保留与删除（30 天 / Keychain 手动 / 卸载）
- §9 儿童隐私（COPPA）
- §10 GDPR 合规
- §11 CCPA / CPRA 合规
- §12 你的权利（通用）
- §13 数据安全
- §14 国际传输（含 PIPL 跨境）
- §15 政策变更通知
- §16 联系信息
- §17 同意

**ToS**：14 个 `## ` 章节（§0～§13）
- §0 前言
- §1 接受条款
- §2 服务描述
- §3 许可
- §4 订阅与付款
- §5 用户行为准则（含录音同意法多司法管辖区对照）
- §6 知识产权
- §7 免责声明（AS IS + 转录准确率 + AI 幻觉 + 尽职调查）
- §8 责任限制（$50 / 12 个月上限 + 间接损失排除 + 例外）
- §9 终止
- §10 争议解决（仲裁 / 集体诉讼弃权 / 管辖法律）
- §11 杂项（可分割性 / 转让 / 完整协议）
- §12 联系信息
- §13 接受

### 3. 法规覆盖矩阵

| 法规 | 涉及章节 | 关键内容 | 通过？ |
|------|----------|----------|--------|
| **GDPR** (EU) | §10 + §2 + §12 | 透明度（Art. 12-14）/ 数据最小化（Art. 5）/ 隐私设计（Art. 25）/ DPIA（Art. 35）/ 欧盟代表（Art. 27）/ 8 项数据主体权利完整列表 | ✅ |
| **CCPA/CPRA** (加州) | §11 | "非歧视权" / "知情权" / "删除权" / "更正权" / "限制敏感个人信息使用" / 验证流程（Apple ID 末四位）/ 销售/共享声明（"我们没东西可卖"）| ✅ |
| **COPPA** (美国儿童) | §9 | 13 岁以下 / 16 岁欧盟 / 父母同意机制 | ✅ |
| **PIPL** (中国) | §10.5 / §14 | 跨境传输说明（映话不构成"个人信息处理者"）/ 与 AI 提供方通信由用户自决 | ✅ |
| **LGPD** (巴西) | §10.5 | "数据主体权利与 GDPR 类似" | ✅ |
| **UK GDPR** | §10.5 | "与 EU GDPR 类似" | ✅ |

### 4. 引用代码层

- §4.3 macOS Keychain 条目精确到 `kSecAttrService` / `kSecClass` / `kSecAttrAccessible` 三层
- §4.3 给出条目命名约定（`anthropic.key` / `openai.key` / `custom.key`）
- §5.2 BYOK HTTPS 流程到 6 步（含 Anthropic / OpenAI / Custom endpoint URL）
- §5.3 表格列出 9 项内容（key / 转录 / 时间码 / speaker / 音频 / Apple ID / 设备 / 序列号 / 位置）哪些发送 / 不发送
- §6.4 Apple 平台服务列出 6 个系统 API（Speech.framework / AVAudioEngine / ScreenCaptureKit / Security / UserNotifications）
- §7 给出 5 项 `NSUsageDescription` 原文

**与代码对齐度**：
- `code/Yinghua/project.yml` 第 58-64 行确实声明 `NSMicrophoneUsageDescription` / `NSScreenCaptureUsageDescription` / `NSSpeechRecognitionUsageDescription` / `NSAppleEventsUsageDescription` / `NSUserNotificationUsageDescription` 5 项 → 隐私政策 5 项描述一一对应 ✅
- `code/Yinghua/Yinghua/Yinghua.entitlements` 包含 `com.apple.security.app-sandbox` / `com.apple.security.device.audio-input` / `com.apple.security.device.microphone` / `com.apple.security.network.client` → §3.3 "应用包内不包含网络遥测代码" 引用 `com.apple.security.network.client` 描述准确 ✅
- `project.yml` `com.yinghua.Yinghua` Bundle ID → 隐私政策 §1 写 `app.yinghua.Yinghua`（**轻微不一致**：代码是 `app.yinghua.Yinghua` = `app.yinghua.Yinghua` 实际是 `app.yinghua.Yinghua` ← 读 project.yml 第 19 行 `PRODUCT_BUNDLE_IDENTIFIER: app.yinghua.Yinghua`；隐私政策 §1 第 23 行 `app.yinghua.Yinghua`；C30 §14 同样写 `com.yinghua.zzw4257.cn`）— 三处都不一致 ⚠️

**Bundle ID 不一致（BLOCKER 候选）**：
- 隐私政策 §1 写：`app.yinghua.Yinghua`
- C30 metadata：Com.yinghua.zzw4257.cn (Yinghua Inc.)
- 实际 project.yml：`app.yinghua.Yinghua` ✅ 真实
- 需在提交前统一为 `app.yinghua.Yinghua`

### 5. 不卖数据承诺

- §3.2 第 5 条明确：「不出售、出租、交换或以任何方式向第三方转让任何用户数据——因为我们根本没有收集任何用户数据。"我们不卖你的数据"这句话在我们的语境下不是"我们不卖"而是"我们没东西可卖"」
- §6.1-6.3 Anthropic / OpenAI / Custom 三方服务的"映话的角色"段落明确不参与通信
- ✅ 承诺真诚、可审计（无后端 / 无 SDK / 无 telemetry 3 重保证）

### 6. Apple Media Services 条款整合

- ToS §1.3 第 3 条：「你与 Apple 之间的 Apple Media Services Terms and Conditions（通过 Mac App Store 订阅时适用）」
- 退款、退订均通过 Apple 渠道
- ✅ App Store 提交必备

### 7. 录音同意法多司法管辖区

- ToS §5.1 详细列出美国（联邦 vs 加州 / 佛州 / 伊州 / 麻州）/ 欧盟 / 中国 / 英国 4 套录音同意法律
- "映话不为你违反录音法律的行为承担任何责任"
- ✅ 高风险场景明确免责

### 8. 出口管制

- ToS §5.5 EAR 约束明示
- ✅ 合规

### 9. DMCA

- ToS §6.5 DMCA 通知流程完整（含 5 项必备信息 + 10 工作日回复）
- ✅ 合规

### 10. 仲裁条款

- ToS §10 仲裁 / 集体诉讼弃权 / 管辖法律
- 与 Apple MAS 协调
- ✅ 完整

---

## 风险与发现

| 严重度 | 项 | 说明 |
|--------|----|------|
| **HIGH** | Bundle ID 不一致 | 隐私政策 §1 写 `app.yinghua.Yinghua`；C30 写 `com.yinghua.zzw4257.cn`；实际 `app.yinghua.Yinghua`。**3 处不一致**会触发 Apple 审核 reject（Privacy URL 返回的 bundle 必须与 binary 一致）|
| MEDIUM | 法律实体 | "Yinghua Inc." 写明 Delaware C-Corp（隐私政策 §1 + ToS §0）但 README 已标 TODO 未实际注册 |
| MEDIUM | 域名 yinghua.zzw4257.cn | Privacy URL 指向 `https://yinghua.zzw4257.cn/privacy` 但 C29 部署后才可访问 |
| LOW | EU 代表（GDPR Art. 27） | §10.4 写"由于不收集数据暂未指定欧盟代表"——这是合理的法律意见，但 EU 监管严格要求在处理 EU 数据时必须有代表，**"不收集"的边界如果未来扩展（如 Pro/Team 上云）需重审** |
| LOW | PIPL 跨境 | §14 说"由你决定是否构成跨境传输，映话不参与"——如果用户用 OpenAI 服务，OpenAI 数据中心在境外，确实由用户承担跨境合规责任，**这是合理但需用户在 onboarding 时明示**（C09 onboarding 流程需补充）|
| LOW | 巴西 LGPD / UK GDPR 引用 | §10.5 一句话引用 GDPR，无独立章节，**对监管严格度来说够用，但与 GDPR §10 详尽度不匹配** |
| LOW | 数据安全章节 §13 | 没有具体加密标准（AES-256 / TLS 1.3 之类）— 对于本地 app 可接受，但企业客户会问 |

---

## 总结

- **VERDICT**: **PARTIAL**
- 关键发现：
  - 字数：privacy 15148 / 8000+ ✅，ToS 12025 / 6000+ ✅（双超额）
  - 章节：privacy 18 章，ToS 14 章 — 完整覆盖 GDPR / CCPA / COPPA / PIPL / LGPD / UK GDPR 6 法规
  - 代码引用：5 项 NSUsageDescription + 3 项 entitlements 与代码 1:1 对齐
  - 不卖数据承诺真诚、可审计
  - **HIGH 风险**：Bundle ID 3 处不一致（隐私政策 / C30 / 实际代码）— Apple 审核会 reject
- 建议（必须修复再提交）：
  1. **统一 Bundle ID 为 `app.yinghua.Yinghua`**（C30 metadata + 隐私政策 §1 + ToS §1.3）
  2. 持有 `yinghua.zzw4257.cn` 域名后实际部署
  3. 注册 Delaware C-Corp 真实实体后替换占位

## 等级

- **PARTIAL**：可修（1 个 HIGH Bundle ID 不一致会阻塞实际提交；其他均为 LOW 可延后）
