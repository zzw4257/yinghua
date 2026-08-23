# 映话 / Yinghua — Mac App Store Submission Listing

> **版本**：v0.1.0 · 2026-08-24
> **目标 SKU**：映话 (Yinghua) · macOS 26 Tahoe · v0.1.0 首发
> **审核路径**：手动发布（审核通过后人工 release）
> **目标审核窗口**：提交后 24-48 小时（Apple 首次 macOS app 典型节奏）

---

## 0. 速查表（Quick Reference · 提交到 App Store Connect 前必看）

| # | 字段 | zh-Hans 值 | en-US 值 | 字符限制 | 状态 |
|---|------|-----------|----------|----------|------|
| 1 | App Name | 映话 (2) | Yinghua (7) | 30 | ✓ |
| 2 | Subtitle | 为面试而生的 macOS 助手 (15) | Local-first meetings on Mac (27) | 30 | ✓ |
| 3 | Category | Productivity + Developer Tools | (same) | — | ✓ |
| 4 | Promotional Text | 165 字符 | 154 字符 | 170 | ✓ |
| 5 | Description | 1258 字符 | 2462 字符 | 4000 | ✓ |
| 6 | Keywords | 41 字符 | 73 字符 | 100 | ✓ |
| 7 | Support URL | https://yinghua.zzw4257.cn/support | (same) | URL | ✓ |
| 8 | Marketing URL | https://yinghua.zzw4257.cn | (same) | URL | ✓ |
| 9 | Privacy Policy URL | https://yinghua.zzw4257.cn/privacy | (same) | URL | ✓ |
| 10 | Copyright | © 2026 Yinghua Inc. | (same) | — | ✓ |
| 11 | Release Notes | 173 字符 | 401 字符 | 4000 | ✓ |
| 12 | Age Rating | 4+ | 4+ | — | ✓ |
| 13 | App Privacy | 见 metadata-zh-Hans.md §13 | 见 metadata-en.md §13 | — | ✓ |
| 14 | Pricing | Freemium + IAP | (same) | — | ✓ |

---

## 1. 提交流程（Submission Flow · 7 步）

### Step 1 · 创建 App Record
- 登录 https://appstoreconnect.apple.com
- 我的 App → 「+」→ 新建 App
- 平台：macOS
- 名称：映话
- 主要语言：简体中文（首次创建默认 locale）
- Bundle ID：com.yinghua.zzw4257.cn（与 Xcode 工程一致）
- SKU：YINGHUA-MAC-001
- 用户访问权限：完全访问（公开发布）

### Step 2 · 填写 App 信息
- 1.0 App 信息 → 按 [README.md §"字段对应表"](./README.md) 填入 11 个字段
- 1.0 版本信息 → 选 1.0 版本（实际代码版本 0.1.0，App Store 显示 1.0）
- 1.0 类别：Productivity + Developer Tools
- 1.0 版权：© 2026 Yinghua Inc.

### Step 3 · 上传截图
- macOS 6.5"+ 必填 3-10 张
- 推荐尺寸：1280×800 或 1440×900（16:10）
- 资产来源：[`_exploration/C23_app-store-screenshots/`](../C23_app-store-screenshots/) 已 shippable 5 张
  - 01-meeting__260824.png
  - 02-transcript__260824.png
  - 03-summary__260824.png
  - 04-onboarding__260824.png
  - 05-empty__260824.png

### Step 4 · 上传 App Icon
- 1024×1024 PNG · 无 alpha · 无圆角（Apple 自动加 squircle mask）
- 资产来源：[`_exploration/C10_vector-icon/`](../C10_vector-icon/) 01 MINIMAL
- 提交前确认：已替换 C13 `AppIcon.appiconset` 占位 PNG（10 个尺寸）

### Step 5 · App Privacy 标签
- 回答 4 个分类问题：数据收集 / 数据使用 / 数据链接 / 跟踪
- 映话答案：见 metadata-zh-Hans.md §13
- 关键：所有问题答「否」或「仅本地不收集」

### Step 6 · 上传 Build
- Xcode 26 → Product → Archive → Distribute App → App Store Connect
- 等待 build 处理（约 10-30 分钟）
- 在「构建版本」中选择已处理的 build

### Step 7 · 提交审核
- 选 build + 勾选「出口合规」「广告标识符」等附加项
- 提交审核
- 等待 24-48 小时

---

## 2. 双语言策略（Bilingual Strategy · zh-Hans + en-US）

### 2.1 锁定规则
- zh-Hans 是 **Primary locale**（App Store Connect 首次创建时选）
- en-US 是 **First alternate locale**（首次发布必填）
- 其他 locale 暂不填（ja / ko 在 v0.2.0 再加）

### 2.2 翻译原则
- App Name：所有 locale 统一用本地化版本（zh-Hans=映话，en=Yinghua）
- Subtitle：完整翻译，保持 30 字符内
- Description：完整翻译，**不**直译机器腔；保留 • bullet 风格
- Keywords：完整本地化重写，**不**机翻（机翻会丢 SEO 价值）
- 其他 URL：所有 locale 共用（yinghua.zzw4257.cn 单域名）

### 2.3 字符差异（zh vs en）
- 英文整体比中文长 30-50%
- 字段截断风险：Promotional Text / Subtitle / Keywords
- 本次提交已验证：
  - en Subtitle 从 48 字符压到 27 字符（删去 "and interview"）
  - en Promotional Text 从 247 字符压到 154 字符（删去 4 段标签 + 简化动词）

---

## 3. 关键决策记录（Submission Decisions）

### 3.1 不用 emoji
**决定**：功能列表用 • 不用 🎙 / 📝 / 🤖
**理由**：
- Apple App Store 审核指南 2.3.8「App 应使用自己设计或已授权的图形资产」对 emoji 描述不清
- 4 个 audit 一致反 emoji（C06 / C07 / C08 / C09）
- 视觉上 • bullet 更克制

### 3.2 不用营销词
**决定**：Description 不出现 赋能 / 洞察 / 革新 / 颠覆 / AI 驱动 / 极致 / 完美 / 革命性
**理由**：C27 brand guidelines §1.3 + design-doc §7 #6 禁词清单
**允许**：本地优先 / 100% / BYOK / 实时 / 8 秒出总结（具体动词 + 具体数字）

### 3.3 Freemium 定价
**决定**：v0.1.0 首发走 Freemium（免费 + 内购 Pro / Team）
**理由**：C25 investor-deck-full/prompts/07-business-model.txt 锁定 3 tier
**注意**：IAP 必须在 App Store Connect → 「内购项目」中单独配置，本次 metadata 不涉及

### 3.4 手动发布
**决定**：v0.1.0 走手动发布（不自动 release）
**理由**：
- 首次发布需人工验证 + 准备营销物料
- 避免审核通过后半夜自动上架

### 3.5 全球首发
**决定**：所有 175 个 App Store 地区全部启用
**理由**：
- v0.1.0 是产品首发，主攻英文 + 中文
- macOS app 国际化压力小（无语言资源文件）
- 后续根据下载数据优化地区策略

---

## 4. 风险与回滚（Risks & Rollback）

| 风险 | 概率 | 影响 | 缓解 |
|------|------|------|------|
| Apple 审核 reject（Guideline 2.1 - App 完成度）| 中 | 高 | 准备 1-2 段 demo 视频，证明核心流程跑通 |
| Apple 审核 reject（Guideline 5.1.1 - 隐私）| 低 | 中 | Privacy Policy 详尽；App Privacy 标签 0 数据收集；BYOK 解释清晰 |
| Promotional Text 字符数超限 | 已避免 | — | 已在 en 压到 154 字符 |
| 截图被 Apple 退回（尺寸 / 模拟器痕迹）| 中 | 中 | C23 5 张图已 shippable，含 macOS menu bar；提交前再 review |
| Build 编译失败（Xcode 26）| 低 | 高 | 已在 C16 light-shippable 包通过编译；C13 BUILD SUCCEEDED |
| Bundle ID 冲突 | 极低 | 高 | 提前在 App Store Connect 注册（Step 1）|

---

## 5. 提交后待办（Post-Submission TODO）

- [ ] 提交后 1 小时：检查「App 状态」变「正在等待审核」
- [ ] 审核中：每天 1 次查看邮件 + App Store Connect
- [ ] 审核通过：手动 release 到 App Store
- [ ] 上架后：发推（C19 social templates 准备）
- [ ] 上架后 1 周：监控 reviews + 关键指标（下载 / 评分 / 崩溃率）

---

## 6. 未来版本（v0.2.0+）

- 增加 ja-JP / ko-KR locale
- 启用 TestFlight 外部测试（需要 1000+ 邮箱）
- 添加 Pro / Team IAP 实际配置
- 添加「What's New」中文 + 英文独立版本

---

## 7. 相关链接

- [metadata-zh-Hans.md](./metadata-zh-Hans.md) — 11 字段中文版（本次提交用）
- [metadata-en.md](./metadata-en.md) — 11 字段英文版（本次提交用）
- [README.md](./README.md) — 使用说明 + 字段对应表
- [`../C27_brand-guidelines/brand-guidelines__260824.md`](../C27_brand-guidelines/brand-guidelines__260824.md) — 品牌守则
- [`../design-doc.md`](../../design-doc.md) — 设计文档 v2.0
- [`../C25_investor-deck-full/prompts/07-business-model.txt`](../C25_investor-deck-full/prompts/07-business-model.txt) — 定价 3 tier
- [`../C23_app-store-screenshots/`](../C23_app-store-screenshots/) — App Store 截图 5 张
- [`../C10_vector-icon/`](../C10_vector-icon/) — App Icon 矢量源文件
