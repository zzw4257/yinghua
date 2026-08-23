# C30 — Mac App Store Metadata · README

> **映话 (Yìnghuà) · Yinghua · macOS 26+ · v0.1.0 首发**
> **状态**：4 文件 shippable · 2026-08-24
> **owner**：Worker agent · C30
> **上游依赖**：C10 icon / C23 screenshots / C25 pricing / C27 brand / design-doc v2.0

---

## 0. 这个目录是啥

C30 包含映话 v0.1.0 在 Apple App Store Connect 后台填写的**所有文本字段**（不含截图 / icon / build）。

| 文件 | 用途 | 谁读 |
|------|------|------|
| **`metadata-zh-Hans.md`** | 11 个字段中文版（zh-Hans locale）| 提交人 |
| **`metadata-en.md`** | 11 个字段英文版（en-US locale）| 提交人 |
| **`app-store-listing.md`** | 综合提交 checklist + 决策记录 | 提交人 / review |
| **`README.md`** | 本文件 · 字段对应表 + 使用说明 | 提交人 |

---

## 1. 字段对应表（Field Mapping · App Store Connect 2025）

> 在 App Store Connect 后台 → 我的 App → 映话 → 1.0 App 信息 / 1.0 版本信息

| # | 字段名 | App Store Connect 位置 | 本目录来源文件 | 章节 |
|---|--------|------------------------|----------------|------|
| 1 | App Name | 1.0 App 信息 → 名称 | metadata-zh-Hans.md / metadata-en.md | §1 |
| 2 | Subtitle | 1.0 App 信息 → 副标题 | (同上) | §2 |
| 3 | Category | 1.0 App 信息 → 类别 | (同上) | §3 |
| 4 | Promotional Text | 1.0 版本信息 → 宣传文本 | (同上) | §4 |
| 5 | Description | 1.0 版本信息 → 描述 | (同上) | §5 |
| 6 | Keywords | 1.0 版本信息 → 关键词 | (同上) | §6 |
| 7 | Support URL | 1.0 App 信息 → 支持 URL | (同上) | §7 |
| 8 | Marketing URL | 1.0 App 信息 → 营销 URL | (同上) | §8 |
| 9 | Privacy Policy URL | 1.0 App 信息 → 隐私政策 URL | (同上) | §9 |
| 10 | Copyright | 1.0 App 信息 → 版权 | (同上) | §10 |
| 11 | Release Notes | 1.0 版本信息 → 此版本的新增内容 | (同上) | §11 |
| 12 | Age Rating | 1.0 App 信息 → 年龄分级 | (同上) | §12 |
| 13 | App Privacy | 1.0 App 信息 → App 隐私 | (同上) | §13 |
| 14 | Pricing & Availability | 1.0 App 信息 → 价格与可用性 | (同上) | §14 |

**总字段数**：14 个（任务要求 11 个核心字段 + 3 个附加：Age Rating / App Privacy / Pricing）

---

## 2. 使用方法（3 步）

### Step 1 · 打开 App Store Connect
- https://appstoreconnect.apple.com
- 创建 App（如未创建）：平台 macOS · 名称 映话 · Bundle ID `com.yinghua.zzw4257.cn` · SKU `YINGHUA-MAC-001`

### Step 2 · 复制字段
- 打开 `metadata-zh-Hans.md` 和 `metadata-en.md`
- 按 §1-§14 顺序复制到 App Store Connect 对应输入框
- 字符限制字段（Promotional Text / Subtitle / Keywords / Description）会实时显示剩余字符数

### Step 3 · 上传视觉资产
- App Icon：[`../C10_vector-icon/`](../C10_vector-icon/) 01 MINIMAL · 1024×1024 PNG
- 截图：[`../C23_app-store-screenshots/`](../C23_app-store-screenshots/) 5 张 · 1280×800 / 1440×900
- Build：Xcode 26 archive → App Store Connect 上传

---

## 3. 字符限制自检（Char Limit Audit · 2026-08-24 实测）

| 字段 | 限制 | zh-Hans 实测 | en-US 实测 | 通过？ |
|------|------|--------------|------------|--------|
| App Name | 30 | 2 | 7 | ✓ |
| Subtitle | 30 | 15 | 27 | ✓ |
| Promotional Text | 170 | 165 | 154 | ✓ |
| Description | 4000 | 1258 | 2462 | ✓ |
| Keywords | 100 | 41 | 73 | ✓ |
| Release Notes | 4000 | 173 | 401 | ✓ |

**关键修订记录**：
- 英文 Subtitle 从 48 字符压到 27 字符（删除 "and interview"，精简为 "Local-first meetings on Mac"）
- 英文 Promotional Text 从 247 字符压到 154 字符（删除 4 段标签括号，简化动词短语）
- 两处修订后所有字段全部通过 Apple 字符限制

---

## 4. 双语言覆盖（Bilingual Coverage · 13 字段 × 2 locale = 26 项）

| # | 字段 | zh-Hans | en-US |
|---|------|---------|-------|
| 1 | App Name | ✓ (2 字符) | ✓ (7 字符) |
| 2 | Subtitle | ✓ (15 字符) | ✓ (27 字符) |
| 3 | Category | ✓ | ✓ |
| 4 | Promotional Text | ✓ (165 字符) | ✓ (154 字符) |
| 5 | Description | ✓ (1258 字符) | ✓ (2462 字符) |
| 6 | Keywords | ✓ (41 字符) | ✓ (73 字符) |
| 7 | Support URL | ✓ (URL 通用) | ✓ |
| 8 | Marketing URL | ✓ (URL 通用) | ✓ |
| 9 | Privacy Policy URL | ✓ (URL 通用) | ✓ |
| 10 | Copyright | ✓ (通用) | ✓ |
| 11 | Release Notes | ✓ (173 字符) | ✓ (401 字符) |
| 12 | Age Rating | ✓ (4+) | ✓ (4+) |
| 13 | App Privacy | ✓ | ✓ (英文表头) |
| 14 | Pricing | ✓ | ✓ (英文表头) |

**全 13 字段 × 2 locale = 26 项全覆盖。**

---

## 5. 品牌一致性自检（Brand Consistency Audit）

### 5.1 调性主轴（设计 doc §1.2）
- ✅ Apple 克制（描述用 • bullet，不用花哨排版）
- ✅ 极光紫作 accent（描述中提到「紫青品牌色」）
- ✅ 暖白主文字
- ✅ 中文优先（zh-Hans 是 primary locale）
- ✅ 不 cyberpunk / 不 SaaS 套路

### 5.2 禁词清单（设计 doc §7 #6 + C27 §1.3 反例）
- ❌ 赋能：未使用
- ❌ 洞察：未使用
- ❌ 革新：未使用
- ❌ 颠覆：未使用
- ❌ 极致：未使用
- ❌ 完美：未使用
- ❌ 革命性：未使用
- ❌ 全局掌控：未使用
- ❌ 效率提升：未使用（用「8 秒出总结」具体数字代替）
- ❌ AI 驱动：未使用（用「AI 总结」中性表达代替）
- ❌ 重塑：未使用

### 5.3 emoji 自检
- ❌ 🎙 / 📝 / 🤖 / 🔐 / 🎯：全部未使用（功能列表用 • 代替）
- ❌ 🎉：v0.1.0 release notes 改用「映话首发」文字代替
- **全文档 0 个 emoji**

### 5.4 4 价值观（设计 doc §1.3 + C27 §1.3）
- ✅ 本地优先：Description + App Privacy 多次强调
- ✅ 用户主权（BYOK）：Description + Subtitle + Keywords 覆盖
- ✅ 透明：Description 明确技术栈（ScreenCaptureKit / SpeechAnalyzer / Keychain）
- ✅ 安静：全文档无 hype 词汇；用具体动词（录制/转录/总结）

---

## 6. 字符验证脚本（Char Validation Script）

如需重新验证 char 数，运行：

```bash
cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/design/_exploration/C30_app-store-metadata

python3 -c "
import re
for f in ['metadata-zh-Hans.md', 'metadata-en.md']:
    txt = open(f).read()
    print(f'=== {f} ===')
    # App Name (between 1. App Name header and next ##)
    for field in ['App Name', 'Subtitle', 'Promotional Text', 'Keywords']:
        m = re.search(rf'(?:^|\n)## .*?{field}.*?\n```\n(.+?)\n```', txt, re.DOTALL)
        if m:
            content = m.group(1)
            print(f'  {field}: {len(content)} chars | content = {content[:50]}...')
"
```

实际本次手算已验证（见 metadata-zh-Hans.md / metadata-en.md 顶部）。

---

## 7. 待办（Open TODOs）

- [ ] **法律实体**：「Yinghua Inc.」是占位，真实提交前需注册 Delaware C-Corp 或等同实体
- [ ] **域名**：yinghua.zzw4257.cn 域名需真实持有（如果只是 mock，需先购买）
- [ ] **support.html / privacy.html**：C29 落地页 + C31 privacy 页必须实际部署上线
- [ ] **App Icon 替换**：确认 C13 Xcode 工程 `AppIcon.appiconset` 已替换为 C10 01 MINIMAL
- [ ] **截图再 review**：5 张 C23 截图提交前再人工 review（menu bar / Dock / 时钟一致性）
- [ ] **IAP 配置**：Pro / Team 价格档需在 App Store Connect → 内购项目单独配置（不在本 metadata 范围）
- [ ] **更多 locale**：v0.2.0 加 ja-JP / ko-KR

---

## 8. 提交 Checklist（Submission Day）

```markdown
- [ ] App Store Connect 账号已登录
- [ ] App Record 已创建（macOS · 映话 · com.yinghua.zzw4257.cn）
- [ ] 13 个字段已按本 README §1 对应表填入 zh-Hans + en-US
- [ ] 字符限制全部通过（见 §3 表）
- [ ] App Icon 1024×1024 已上传（C10 01 MINIMAL）
- [ ] 5 张截图已上传（C23）
- [ ] App Privacy 问卷已答完（13 个数据类全填）
- [ ] 年龄分级问卷已答完（4+）
- [ ] Build 已 archive 并通过 App Store Connect 处理
- [ ] Build 已绑定到 1.0 版本
- [ ] 出口合规已勾选
- [ ] 提交审核
- [ ] 等邮件通知（24-48h）
- [ ] 审核通过后手动 release
```

---

## 9. 相关依赖

- **品牌守则**：[`../C27_brand-guidelines/brand-guidelines__260824.md`](../C27_brand-guidelines/brand-guidelines__260824.md) §1.1 身份 / §1.2 调性 / §1.3 价值观
- **设计文档**：[`../../design-doc.md`](../../design-doc.md) §1 身份 / §13 Round 4 状态
- **定价 3 tier**：[`../C25_investor-deck-full/prompts/07-business-model.txt`](../C25_investor-deck-full/prompts/07-business-model.txt)
- **App Icon**：[`../C10_vector-icon/`](../C10_vector-icon/) 01 MINIMAL
- **截图**：[`../C23_app-store-screenshots/`](../C23_app-store-screenshots/) 5 张

---

## 10. 文件版本

| 版本 | 日期 | 改动 |
|------|------|------|
| v0.1.0 | 2026-08-24 | C30 首发：4 文件全 shippable |

---

**C30 完成。** 13 字段 × 2 locale + 提交 checklist + 决策记录 + 自检脚本 + 待办清单。提交人可按 §1 对应表 + §3 字符验证 + §8 checklist 顺序完成 v0.1.0 首发。
