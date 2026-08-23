# C09 Onboarding Flow — 3 屏流

> 映话 (Yinghua) macOS AI 会议助手 — 首次启动 3 屏 onboarding 流。
> Round 2 / C09 探索。本轮出屏 2（权限申请）和屏 3（BYOK 配置），屏 1（欢迎页）已在 C06 v3 终版出过。

---

## 1. 三屏流清单

| 屏 | 文件 | 状态 | 出图轮次 |
|----|------|------|----------|
| **屏 1 — Welcome** | `../C06_product-v3/05-onboarding/product-onboarding-v3__260822.png` | ✅ C06 v3 终版 | C06 |
| **屏 2 — Permission Request** | `02-permission/onboarding-02-permission__260823.jpg` | ✅ C09 V1 | C09（本轮） |
| **屏 3 — BYOK / API Key** | `03-byok/onboarding-03-byok__260823.jpg` | ✅ C09 V1 | C09（本轮） |

---

## 2. 屏 2：Permission Request（权限申请）

### 2.1 文件
- `02-permission/onboarding-02-permission__260823.jpg`（2.4 MB，2752x1536）
- 配套 prompt：`02-permission/_prompt.txt`

### 2.2 字段说明

| 字段 | 值 | 说明 |
|------|----|------|
| **窗口标题区** | "Grant access"（heading 26pt 600）<br>"Yinghua needs a few macOS permissions to record and transcribe your meetings."（14pt 400 muted） | 屏 1 → 屏 2 的过渡标题 |
| **3 个权限卡片** | 垂直排列，~72px 高 / 12px 圆角 / 玻璃 + 1px 8% 白边 | 见下方卡片结构 |
| **底部 CTA** | "Continue"（紫青渐变，~360x44px / 12px 圆角） | 单一主操作 |
| **底部 ghost link** | "Skip for now"（12pt muted gray） | 次要链接 |

### 2.3 卡片结构

每张权限卡 = `[32x32 icon] [bold 标题 + 一行说明] [status pill]`

| # | 标题 | 说明 | 状态 pill | 备注 |
|---|------|------|-----------|------|
| 1 | **Microphone** | "Record system audio + mic for live transcription." | 🟢 **Granted**（绿底 #34C759 @ 20% + 绿字） | 必填 / 已开 — 示例状态 |
| 2 | **Screen & System Audio** | "Capture audio from apps and meetings on your screen." | ⚪ **Pending**（灰底 + 灰字） | 必填 / 待开 |
| 3 | **Notifications** | "Get a gentle reminder when a meeting ends." | ⚪ **Optional**（灰底 + 灰字） | 可选 / 待开 |

**图标**（左侧 32x32 玻璃方块）：
- Microphone → SF Symbol `mic.fill`
- Screen & System Audio → SF Symbol `rectangle.fill.badge.record`（带录制点的矩形）
- Notifications → SF Symbol `bell.fill`

### 2.4 进度指示器
- 位置：窗口内容区**顶部**（~32px below title bar），3 点 + 连线水平居中
- 状态：dot 1（已开）= 8px 实心紫 / dot 2（当前）= 12px 实心紫 + 紫色光晕 / dot 3（待开）= 8px 灰空心

---

## 3. 屏 3：BYOK / API Key Configuration

### 3.1 文件
- `03-byok/onboarding-03-byok__260823.jpg`（2.4 MB，2752x1536）
- 配套 prompt：`03-byok/_prompt.txt`

### 3.2 字段说明

| 字段 | 值 | 说明 |
|------|----|------|
| **顶部 disclaimer 条** | 🔒 + "Your key is stored locally in macOS Keychain. We never see it." | 玻璃条 / 1px 边 / lock icon + 12pt muted |
| **窗口标题区** | "Bring your own key"（heading 26pt 600）<br>"Choose a provider and paste your API key. We use it to summarize your meetings."（14pt 400 muted） | 屏 2 → 屏 3 的过渡标题 |
| **段 1 — Provider 选择** | "PROVIDER" section label + 3 卡片横排（OpenAI / Anthropic / Custom） | 见下方 provider 表 |
| **段 2 — API Key 输入** | "API KEY" section label + 1 input + eye toggle + "Test connection" ghost | input 暗玻璃 8px 圆角 + placeholder `sk-••••••••••••` |
| **段 3 — Status 提示** | 状态条：spinner + "Testing connection..."（左有 3px 灰 accent bar） | 当前渲染为 testing 中间态 |
| **底部 CTA** | "Finish setup"（紫青渐变，**50% opacity 禁用态**） | 单一主操作（disabled） |
| **底部 ghost link** | "I'll do this later"（12pt muted gray） | 次要链接 |

### 3.3 Provider 卡片表

| # | Provider | Tagline | 状态 |
|---|----------|---------|------|
| 1 | **OpenAI** | "GPT-4o, o1" | 未选（1px 白边 8%） |
| 2 | **Anthropic** ⭐ | "Claude Sonnet 4" | **已选**（1.5px 紫边 #8A5BFF + 浅紫 wash） |
| 3 | **Custom** | "Self-hosted" | 未选（1px 白边 8%） |

每张 = `[28x28 icon] [name 13pt 600] [tagline 10pt muted]`

### 3.4 进度指示器
- 位置：窗口内容区**顶部**（同屏 2）
- 状态：dot 1 = 8px 实心紫（已开） / dot 2 = 8px 实心紫（已开） / dot 3 = 12px 实心紫 + 光晕（**当前**）

---

## 4. 与 C06 屏 1 的视觉一致性检查

| 维度 | 屏 1 (C06 v3) | 屏 2 (C09) | 屏 3 (C09) | 一致性 |
|------|---------------|------------|------------|--------|
| 窗口宽度 | ~55% 桌面宽 | ~55% 桌面宽 | ~55% 桌面宽 | ✅ |
| 窗口高宽比 | ~3:4（taller） | ~3:4 | ~3:4 | ✅ |
| 窗口圆角 | 14px | 14px | 14px | ✅ |
| 窗口材质 | dark glass + aurora tint | dark glass + aurora tint | dark glass + aurora tint | ✅ |
| Traffic lights | 红/黄/绿 左上 | 红/黄/绿 左上 | 红/黄/绿 左上 | ✅ |
| 桌面壁纸 | 极光深紫→青 + 星空 | 极光深紫→青 + 星空 | 极光深紫→青 + 星空 | ✅ |
| 菜单栏 | Apple + File/Edit/View/Window/Help + 状态图标 + 09:42 | 同 | 同 | ✅ |
| Dock | 11 系统图标 + 分隔点 + Y（见 V1 已知问题） | 同（+1 偏差） | 同（+1 偏差） | ⚠️ |
| 主按钮渐变 | 紫 → 青 | 紫 → 青 | 紫 → 青 | ✅ |
| 主按钮圆角 | 12px | 12px | 12px | ✅ |
| 进度指示器 | 3-dot 底部，点 1 紫 | 3-dot **顶部**，点 2 紫 | 3-dot **顶部**，点 3 紫 | ⚠️ 位置不同（屏 1 底 / 屏 2-3 顶） |
| 标题字体 | SF Pro Display 600 ~32pt | SF Pro Display 600 ~26pt | SF Pro Display 600 ~26pt | ⚠️ 屏 1 字号更大（因屏 1 是品牌首屏） |

**说明**：屏 1 的 progress 指示器在**底部**（C06 终版效果），屏 2/3 改到**顶部**（更符合 macOS Setup Assistant 惯例）。这是 C09 有意设计，屏 1 保留 v3 终版不动。

---

## 5. V1 已知问题

### 5.1 屏 2 已知问题

| # | 问题 | 严重度 | 原因 | 修复方向 |
|---|------|--------|------|----------|
| V1-P2-1 | Dock 多了 1 个图标（多出 Contacts） | 低 | 模型对 C05 ref-02 不完全照搬，多放了 1 个常用 app | Figma 重做 / 切到 SVG 重绘时用 ref-02 真截图 |
| V1-P2-2 | Mail / Messages 顺序与 C05 ref-02 颠倒 | 低 | 同上 | 同上 |
| V1-P2-3 | 进度指示器连线颜色比预期偏淡 | 极低 | 模型渲染器默认 stroke | Figma 时用 #8A5BFF 1px 明确指定 |

### 5.2 屏 3 已知问题

| # | 问题 | 严重度 | 原因 | 修复方向 |
|---|------|--------|------|----------|
| V1-P3-1 | **Anthropic provider card icon 用了 "AI" 字母**（黑色方块上白色 "AI" 字样） | **中** | 模型把 Anthropic 默认联想为 "AI" 文字。重 roll 一次仍出现 "AI" 字样，且重 roll 损失了 "Finish setup" 的 disabled 50% opacity 状态和菜单栏 Apple logo，权衡后保留 v1 | **Figma 必做**：用真正的 Anthropic "A" mark（白色 chevron / 钻石几何）替换 |
| V1-P3-2 | Dock Notes 被替换为 Photos（多 1 个） | 低 | 同屏 2 V1-P2-1 | 同 |
| V1-P3-3 | Custom provider 的 icon 渲染为 "node" 文字（不是几何 mark） | 低 | 模型对 "Custom / self-hosted" 的抽象不够 | Figma 改用简单节点 + 圆点 icon |
| V1-P3-4 | Menu bar 没有完全匹配 C05 ref-01（顶部比屏 2 略亮） | 极低 | 模型对极光壁纸的渐变中心有微差 | Figma 微调即可 |

### 5.3 跨屏已知问题
- 字体文字渲染为**英文 placeholder**，中文版本由 Figma 后期替换
- 屏 2 / 屏 3 都是 2K 16:9 静态截图，**没有动画**（progress 点的 glow / disabled 按钮的 hover 等都是静态表现）
- 屏 1 字号比屏 2/3 更大（品牌首屏强调），屏 2/3 标题统一为 26pt — 这是有意设计

---

## 6. 出图记录

### 6.1 屏 2
- **node_id**：`433797745340563`
- **时间**：2026-08-23 00:52
- **aspect_ratio**：`16:9`
- **resolution**：`2K`
- **后端**：`connector__matrix__generate_image`
- **重试次数**：0（一次成功）
- **下载方式**：`wget --timeout=120 --tries=2`
- **校验**：read tool 1 次（确认 3-dot / 3 卡片 / 状态 pill / CTA / base macOS layer）

### 6.2 屏 3
- **node_id**：`433799188635842`（v1，保留为终版）
- **重试**：1 次 → `433799913603201`（v2 已 trash，因为 v2 损失了 disabled CTA 状态且菜单栏出现 "Yinghua" 文字，不及 v1）
- **v2 决策说明**：v2 仍含 "AI" 字母 icon（模型顽固），且同时损失了"Finish setup" 50% opacity disabled 状态和 Apple logo 菜单栏 → v1 总体更接近 brief，保留 v1
- **时间**：2026-08-23 00:53（v1）/ 00:56（v2 失败重试） / 00:57（v1 恢复）
- **aspect_ratio**：`16:9`
- **resolution**：`2K`
- **后端**：`connector__matrix__generate_image`
- **下载方式**：`wget --timeout=120 --tries=2`
- **校验**：read tool 2 次（v1 + v2 对比）

---

## 7. 下一步建议

1. **C09 → Figma 精修**（最高优）
   - 屏 3 V1-P3-1（Anthropic "AI" 字母 icon）必须 Figma 修
   - 屏 2/3 Dock 11 图标按 C05 ref-02 真截图替换
2. **Round 2 收口**：把 C09 屏 1/2/3 三图并入 design-doc.md 的 §5 产品表面表，填到 4.5 onboarding
3. **C10 候选**：把 onboarding 三屏打包成纵向拼图（marketing 用） + 浅色模式变体
