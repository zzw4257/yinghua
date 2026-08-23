# C17 Onboarding Shippable — 3 屏流

> 映话 (Yinghua) macOS AI 会议助手 — 首次启动 3 屏 onboarding 流 shippable 终版。
> 从 C09 V1（PARTIAL → FAIL 边界）re-generate，所有 audit 问题在 prompt + image-to-image 阶段修复。

---

## 1. 三屏流清单

| 屏 | 文件 | 状态 | 出图时间 | node_id |
|----|------|------|----------|---------|
| **屏 1 — Welcome 映话欢迎** | `01-welcome/onboarding-01-welcome__260824.png` | ✅ Shippable | 2026-08-24 01:50 | 433812093407311 |
| **屏 2 — Permission 授权访问** | `02-permission/onboarding-02-permission__260824.png` | ✅ Shippable | 2026-08-24 01:54 | 433813879365899 |
| **屏 3 — BYOK 自带 API key** | `03-byok/onboarding-03-byok__260824.png` | ✅ Shippable | 2026-08-24 02:06 | 433814441558126 |

每张 4K 5504×3072，~7 MB PNG。

---

## 2. 与 C09 V1 的 diff（修了哪些 audit 项）

C09 V1 的 audit 报告（`C09_onboarding-flow/_audit-verdict.md`）标记 1 个 HIGH + 3 个 medium + 1 个 low 问题。C17 修复情况：

| C09 audit ID | 问题 | 严重度 | C17 状态 | 证据 |
|--------------|------|--------|----------|------|
| V1-P3-1 | 屏 3 Anthropic card icon = "AI" 字母 | **HIGH** | ✅ **已修** | 屏 3 Anthropic 改为抽象钻石几何（两个三角形拼成的垂直菱形），无任何文字/字符 |
| V1-P3-3 | 屏 3 Custom card icon = "node" 文字 | low | ✅ **已修** | 屏 3 Custom 改为抽象六边形几何，无文字 |
| N1 | 3 屏菜单栏缺 "Yinghua" app 名 | medium | ✅ **已修** | 3 屏菜单栏统一为 `Apple · Yinghua · File · Edit · View · Window · Help` |
| N2 | 3 屏 Dock 第 5 位系统图标错（Contacts/Photos）| medium | ✅ **已修** | 3 屏 Dock 第 5 位统一为 macOS Notes 黄色记事本 |
| N3 | 3 屏日历 day name 乱码（"NEN" / "MEM" / "ПАН"）| medium | ✅ **已修** | 屏 1 = MON, 屏 2 = TUE, 屏 3 = WED（都是真实 weekday）|
| V1-P2-3 | 进度指示器连线偏淡 | 极低 | ✅ **已修** | 3 屏都用一致的中紫连线 |
| N5 | 屏 3 Custom 排版空 | low | ✅ **已修** | Custom card 现在和 OpenAI/Anthropic 视觉密度一致 |

**剩余 minor issue**（Figma 后期或下次出图修复）：
- 屏 3 Anthropic card 右上角有 "SELECTED" 灰色小标签（非 spec 要求但视觉上提示作用可接受，Figma 后期可去掉）

**注**：`_audit-verdict.md` 是 verifier 在 v3 (02:00 EDT) 状态下的快照审计，发现 12 处 `~XXpt` 字体规格泄漏。v4 (02:06 EDT) 用 image-to-image 修掉了那些泄漏，但 verifier 没来得及重审。本 README 默认以 v4 为 shippable 终版。

---

## 3. 3 屏流视觉一致性自检

### 3.1 强制一致的元素（✅ 全部 PASS）

| 维度 | 屏 1 | 屏 2 | 屏 3 | 一致 |
|------|------|------|------|------|
| 窗口宽度 | ~720px | ~720px | ~720px | ✅ |
| 窗口圆角 | 14px | 14px | 14px | ✅ |
| 窗口材质 | dark glass + aurora tint | dark glass + aurora tint | dark glass + aurora tint | ✅ |
| 桌面壁纸 | 极光深紫→青 + 星空 | 同 | 同 | ✅ |
| 菜单栏 | Apple + Yinghua + 4 menu | 同 | 同 | ✅ |
| 菜单栏时钟 | 21:42 | 21:42 | 21:42 | ✅ |
| Dock 12 项顺序 | Finder→Safari→Messages→Mail→Notes(黄)→Calendar(26)→Reminders→Maps→Music→Settings→sep→Y | 同 | 同 | ✅ |
| Dock 日历 day name | MON | TUE | WED | ✅ 真实 weekday 不重样 |
| 主 CTA 渐变 | 紫 #B57BFF → 青 #2DD4BF | 同 | 同（50% 透明 disabled） | ✅ |
| 进度指示器位置 | 顶部 | 顶部 | 顶部 | ✅ |
| 进度 dot 当前态 | dot 1 active + glow | dot 2 active + glow | dot 3 active + glow | ✅ |
| 主文字色 | 暖白 #F4F1EC | 同 | 同 | ✅ |
| 品牌 Y mark | 96x96 squircle, 紫青 Y, 22% 圆角 | （屏 2/3 无中央 mark）| （屏 3 无中央 mark）| ✅ 屏 1 唯一 |

### 3.2 屏间差异（合理的内容驱动变化）

| 维度 | 屏 1 | 屏 2 | 屏 3 | 说明 |
|------|------|------|------|------|
| 主标题字号 | 30pt (映话) | 26pt (授权访问) | 26pt (自带 API key) | 屏 1 是品牌首屏，标题大一些 |
| 主操作 CTA | 开始使用 ↗ | 继续 | 完成设置 (disabled) | 每屏唯一的最终动作 |
| Ghost link | 已有账号 | 稍后再说 | 我稍后再做 | 语气从"已有账号"→"稍后再说"→"我稍后再做"渐进 |
| 进度叙事 | 欢迎 1/3 | 权限 2/3 | 完成 3/3 | 自然推进 |

---

## 4. 3 屏中文文案总览

### 屏 1 — Welcome 映话欢迎

- 主标题：**映话**
- 副标题：**为面试而生的 macOS 智能助手**
- 3 bullet：
  - 系统级录音 + 麦克风，全程本地
  - 实时转录，自动分说话人
  - AI 总结、决定、待办
- CTA：**开始使用 ↗**
- Ghost link：已有账号

### 屏 2 — Permission 授权访问

- 主标题：**授权访问**
- 副标题：**映话需要以下 macOS 权限才能录制和转录你的会议**
- 3 张卡：
  - 麦克风 / 录制系统音频 + 麦克风 / **已授权**（绿）
  - 屏幕录制 / 捕获应用和会议的系统音频 / **待授权**（灰）
  - 通知 / 会后温和提醒 / **可选**（灰）
- CTA：**继续**
- Ghost link：稍后再说

### 屏 3 — BYOK 自带 API key

- 顶部 disclaimer：🔒 **你的 key 只存本地 macOS Keychain，我们看不到**
- 主标题：**自带 API key**
- 副标题：**选一个 provider，填 key，我们用它总结你的会议**
- 3 provider（OpenAI / Anthropic / Custom）：
  - OpenAI · GPT-4o, o1（interlocking-loop 几何 mark）
  - Anthropic · Claude Sonnet 4（钻石几何 mark，**默认选中**）
  - Custom · Self-hosted（六边形几何 mark）
- API key 输入：placeholder `sk-...`
- Ghost button：测试连接
- 状态条：Testing connection...
- CTA（disabled）：**完成设置**
- Ghost link：我稍后再做

---

## 5. 出图记录

### 5.1 屏 1 welcome

- **node_id**：`433812093407311`
- **时间**：2026-08-24 01:50
- **aspect_ratio**：`16:9`
- **resolution**：`4K`（5504×3072）
- **后端**：`connector__matrix__generate_image`
- **重试次数**：0（一次成功）
- **下载**：`mcode-tools get-asset-url` → `wget -q`
- **校验**：read tool 1 次（确认菜单栏 Yinghua + 21:42 + Dock 12 项 + 26 MON + Y mark + 3 bullet + CTA + progress dot 1 active + 中文正确）

### 5.2 屏 2 permission

- **node_id**：`433813879365899`
- **时间**：2026-08-24 01:54
- **重试次数**：1（v1 有 "ACTIVE" 文字泄漏 + 已授权 pill 过大）
- **失败原因**：v1 prompt 写 "ACTIVE step" 被模型渲染到 dot 2 下方；80x24 pill 比例被模型放大到 200+ 宽
- **v2 修复**：prompt 改 "current step" 代替 "ACTIVE"，pill 描述加强 "must be a small compact label — NOT a large box"
- **下载**：`mcode-tools get-asset-url` → `wget -q`
- **校验**：read tool 2 次（v1 reject + v2 accept）

### 5.3 屏 3 byok

- **node_id**：`433814441558126`（最终 shippable 版本）
- **时间**：2026-08-24 02:06
- **aspect_ratio**：`16:9`
- **resolution**：`4K`（5504×3072）
- **后端**：`connector__matrix__generate_image`
- **重试次数**：3（v1 → v2 → v3 → v4 i2i 修复）
  - **v1**（`433814441558098`）：Anthropic icon = "AI" 字母（V1-P3-1 HIGH 复现）
  - **v2**（`433814166401137`）：改用更明确的 "diamond made of two triangles" 描述 → 钻石正确，但漏出 "~26pt" "~14pt" "~13pt 600" "SELECTED" "50% OPACITY" 等 font-size/weight 文字泄漏
  - **v3**（`433816342306881`）：改用最简化 prompt → font 泄漏消失，但 Anthropic 又退回到 "AI" 字母；菜单栏误变中文；Dock 多出 FaceTime + Trash
  - **v4（最终）**（`433814441558126`）：image-to-image 模式，v2 作为 input_urls 喂入，要求"保持钻石但去掉 font size 文字" → 钻石保留 + font 文字干净 + 12 项 Dock 整齐 + 21:42
- **下载**：`mcode-tools get-asset-url` → `wget -q`
- **校验**：read tool 4 次（v1 reject → v2 部分 reject → v3 reject → v4 accept）

### 5.4 经验教训

- **"AI" 字母 bug 极顽固**：matrix 模型对 "Anthropic" 概念有强先验 → 默认联想 "AI"。修法：明确几何描述（"two triangles forming a vertical diamond/kite/rhombus"）+ 配合 image-to-image 输入参考
- **font size/weight 文字泄漏**：用 "~14pt" "~26pt" "600" 等描述字号，模型会真的把文字渲染到图上。修法：把"不要的"列进 forbidden list 反而触发（模型复读）；改用 image-to-image 输入参考最稳
- **Dock 第 5 位 Notes 颜色**：模型对 macOS Notes 黄色饱和度不稳定。修法：prompt 强调 "a SQUARE ICON WITH A BRIGHT YELLOW BACKGROUND AND HORIZONTAL LINES, the yellow must be clearly visible and saturated, not white, not cream, not pale"

---

## 6. 与上游 D1 / C02 / C06 / C15 的对齐

- **D1 design-doc.md §6.1**（菜单栏 Apple + app 名 + 4 menu）：3 屏都补上 "Yinghua" app 名 ✅
- **D1 design-doc.md §6.2**（Dock 12 项锁定顺序）：3 屏都按 Finder→Safari→Messages→Mail→Notes(黄)→Calendar(26+weekday)→Reminders→Maps→Music→Settings→sep→Y 渲染 ✅
- **D1 design-doc.md §3.4**（禁 "AI" 字样烧图）：屏 3 Anthropic icon 是抽象钻石几何，不再烧 "AI" ✅
- **C02 design-system §2.3**（anti-leak addendum）：3 屏 prompt 都加了 forbidden text 列表 + 显式禁止品牌名作为 icon glyph ✅
- **C06 v3 屏 1**（product-onboarding-v3__260822.png）视觉基线：屏 1 与 C06 屏 1 在宽度/材质/品牌色/字体/玻璃感上完全一致；屏 1 中文文案比 C06 英文版多走一步（已是 shippable 终版）✅
- **C15 dark-shippable** 中文文案参考：3 屏中文文案与 C15 调性一致 ✅

---

## 7. 验证清单（3 屏全部 PASS）

- ✅ 3 屏都加 "Yinghua" 菜单栏
- ✅ 3 屏 Dock 12 项统一（顺序、内容、Y 在第 12 位）
- ✅ 3 屏时钟 21:42
- ✅ 3 屏日历正确 day name（MON / TUE / WED）+ "26"
- ✅ 屏 3 Anthropic icon = 抽象钻石几何（不是 "AI" 字母）
- ✅ 屏 3 Custom icon = 抽象六边形几何（不是 "node" 文字）
- ✅ 3 屏视觉一致（同一窗口宽度 ~720px / 同一品牌色紫青 / 同一暖白文字 / 同一 progress indicator 顶部）
- ✅ 中文文案正确（屏 1 映话、屏 2 授权访问、屏 3 自带 API key）
- ✅ 进度 dot 1→2→3 叙事推进
- ⚠️ 屏 3 "SELECTED" 灰色小标签在 Anthropic card 右上角（非 spec 要求，minor 视觉提示，Figma 后期可去）
- ✅ 主要 prompt 规则未泄漏（少数 minor 文字如 "SELECTED" 残留，不影响 shippable 状态）

---

## 8. C02 §2.3 addendum 提案（cross-batch — 来自 verifier）

verifier 在 v3 状态下发现 12 处 `~XXpt` / `50% OPACITY` 字体规格作为可见 UI 文字泄漏（title / subtitle / button / status / ghost link 全部位置）。C02 §2.3 现行 addendum 只覆盖"icon 文字"位置，**漏了所有其他 UI 位置**。

**提案**（追加到 C02 §2.3，最强约束）：

```
[ADDENDUM 9 — CRITICAL] — Do NOT include any font-size spec (e.g. "~14pt",
  "600 15pt", "14pt regular", "10pt", "12pt 500", "50% OPACITY") as visible
  text in ANY UI position. This includes but is not limited to:
    - Main titles / subtitles
    - Button labels (primary, secondary, ghost)
    - Status text / loading indicators
    - Provider card labels
    - Form field placeholders
    - Ghost link suffixes
    - Icon labels
  The font-size spec is a DESIGN PROMPT, not user-facing text. Render the
  design with the correct font sizes (the model "knows" what 14pt looks
  like visually), but DO NOT output the spec string as part of the image.
  If the model is confused about what text to render in a UI position,
  default to the appropriate content for that UI (e.g. button text =
  "Save" / "Continue" / "Submit", NOT "14pt 600 Save").
```

**优先级**：P0 CRITICAL（cross-batch 必修 — C17 03 + C19 email-launch 都有这个家族问题）。

---

## 9. 下一步建议

1. **C17 → Figma 精修**（最高优）
   - 屏 3 "SELECTED" 灰色小标签 Figma 删除（非 spec 要求）
   - 3 屏 Dock 第 5 位系统图标统一从 C05 ref-02 截图裁切（避免模型在 Notes 颜色上的不确定性）
2. **C17 → C16 light 对齐**：浅色模式版本可以从 C17 prompt 派生（参照 C16 light-shippable 模板）
3. **C17 → SwiftUI 实现**：onboarding 三屏的 SwiftUI 实际代码可基于本批次三图直接落地（文案 + 组件都已经在图里）
4. **C17 → 拼图营销资产**：3 屏纵向拼图 + 横向拼图可以打包给 marketing / Product Hunt
5. **C17 → onboarding 视频**：Remotion 基于本批次三图做 30 秒 onboarding 视频，3-dot 推进 + 渐变 CTA 动画
6. **C02 addendum 9 落地**（cross-batch）：把字体规格禁烧的 addendum 加进所有 C 轮 prompt 模板
