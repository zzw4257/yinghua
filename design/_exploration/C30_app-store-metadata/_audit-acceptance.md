# C30 — App Store Metadata · 独立审计

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：Apple App Store Connect 2025 字段规范 + 字符限制（30 / 30 / 170 / 4000 / 100 / 4000）+ design-doc §1 调性 + C27 §1.3 价值观 + design-doc §7 反模式

---

## 检查项

### 1. 字段覆盖（任务要求 11 字段 × 2 locale = 22 项）

C30 README 自报 **14 字段 × 2 locale = 28 项**（11 核心 + 3 附加：Age Rating / App Privacy / Pricing）。**任务要求 11 字段 → 实际覆盖 14 字段，超额完成**。

| # | 字段 | 字符限制 | zh 实测 | en 实测 | 通过？ |
|---|------|----------|---------|---------|--------|
| 1 | App Name | 30 | 2 | 7 | ✅ |
| 2 | Subtitle | 30 | 15 | 27 | ✅ |
| 3 | Category | n/a | Productivity/Developer Tools | Productivity/Developer Tools | ✅ |
| 4 | Promotional Text | 170 | 165 | 154 | ✅ |
| 5 | Description | 4000 | 1258 | 2462 | ✅ |
| 6 | Keywords | 100 | 41 | 73 | ✅ |
| 7 | Support URL | URL | `https://yinghua.zzw4257.cn/support` | 同 | ✅ |
| 8 | Marketing URL | URL | `https://yinghua.zzw4257.cn` | 同 | ✅ |
| 9 | Privacy Policy URL | URL | `https://yinghua.zzw4257.cn/privacy` | 同 | ✅ |
| 10 | Copyright | 短 | `© 2026 Yinghua Inc.` | 同 | ✅ |
| 11 | Release Notes | 4000 | 173 | 401 | ✅ |
| 12 | Age Rating | n/a | 4+ | 4+ | ✅ |
| 13 | App Privacy | table | 6 数据类全填 | 同 | ✅ |
| 14 | Pricing & Availability | n/a | Freemium / 175 region | 同 | ✅ |

**全部字符限制字段通过**，实测字符数均 ≤ 限制（最大余量为 Description：en 1538 字符冗余）

### 2. Apple 政策合规

#### 2.1 禁 emoji 替 icon
- 实测 2 个 metadata 文件 = 0 emoji
- README 自检 §5.3："全文档 0 个 emoji"
- ✅ 合规

#### 2.2 禁营销词
- 实测 grep 命中 = 0 处出现「赋能 / 洞察 / 革新 / 颠覆 / 极致 / 完美 / 革命性 / 全局掌控 / 效率提升 / AI 驱动 / 重塑」
- README §5.2 列出 11 个禁词全数未用
- ✅ 合规

#### 2.3 字符限制（30 / 30 / 170 / 4000 / 100 / 4000）
- 6 个限制字段全数通过（见上表）
- ✅ 合规

#### 2.4 副标题简洁度
- en Subtitle = 27 字符（限制 30，余 3 字符）
- 早期版本 48 字符 → 已压缩到 27（删除 "and interview"）
- ✅ 合规

#### 2.5 营销 URL 与 Privacy URL 一致性
- 3 个 URL 共用根域 `yinghua.zzw4257.cn`，跟 C29 marketing site 一致
- ✅ 合规

#### 2.6 双语言对等
- zh-Hans 14 字段全覆盖
- en-US 14 字段全覆盖
- ✅ 26/26 项全到位

### 3. 调性与品牌一致性（design-doc §1 + C27 §1.3）

- ✅ 本地优先：Description + App Privacy 多次强调
- ✅ 用户主权（BYOK）：3 个 provider + Keychain 详情明确
- ✅ 透明：技术栈（ScreenCaptureKit / SpeechAnalyzer / Keychain）明确写出
- ✅ 安静：全文档无 hype 词汇；用具体动词（录制 / 转录 / 总结 / 8 秒出总结）

### 4. 文件结构

| 文件 | 用途 | 状态 |
|------|------|------|
| `metadata-zh-Hans.md` | 中文 14 字段 | ✅ |
| `metadata-en.md` | 英文 14 字段 | ✅ |
| `app-store-listing.md` | 综合提交 checklist + 决策 | ✅ |
| `README.md` | 字段对应表 + 自检脚本 | ✅ |

### 5. 自检脚本

- README §6 提供 Python char 验证脚本（re-search 抓 `##` 标题到 ` ``` ` 闭包）
- 实测用脚本可正确提取 6 字段（我手算全部一致）
- ✅ 可重复验证

### 6. Submission Checklist

- README §8 列出 13 项 pre-flight checklist
- 含 App Icon / 截图 / Build / TestFlight / 出口合规等关键项
- ✅ 提交人就绪

### 7. 待办透明度

README §7 列出 7 项开放 TODO（法律实体、域名、C29/C31 部署、IAP 配置、更多 locale 等），**不掩盖任何未完成项**。

---

## 风险与发现

| 严重度 | 项 | 说明 |
|--------|----|------|
| MEDIUM | 法律实体占位 | `Yinghua Inc.` 是占位，提交前必须注册真实实体（README 已标 TODO） |
| MEDIUM | 域名 yinghua.zzw4257.cn | README 标 TODO，未确认真实持有；C29 部署也依赖此域 |
| LOW | 13/14 字段对比任务要求 11 字段 | C30 超额完成 3 附加字段（Age Rating / App Privacy / Pricing），不算 defect 但与任务范围有偏差（实际是更好）|
| LOW | Copyright "Yinghua Inc." 与 README "Yinghua Inc. (placeholder)" | 文档内自洽但需要在真实提交时同步替换 |
| LOW | IAP 价格档在 §14 引用 C25 | C25 deck-02-problem 之外未全出，但 Pro/Team 价位是文字描述，不阻塞 metadata 提交 |

---

## 总结

- **VERDICT**: **PASS**
- 关键发现：14 字段 × 2 locale = 28 项全到位、6 字符限制字段全通过、0 emoji、0 营销词、3 URL 根域一致、双语对等、自检脚本可重复、13 项 submission checklist、7 项 TODO 透明
- 建议：注册 Yinghua Inc. 真实法律实体 + 持有 yinghua.zzw4257.cn 域名后方可实际提交

## 等级

- **PASS**：可用
- 满足任务要求全部 5 项（11 字段 × 2 locale / 字符限制 / Apple 政策 emoji 禁 / 营销词禁 / 双语对等）
