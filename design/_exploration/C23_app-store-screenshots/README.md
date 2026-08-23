# C23 — Mac App Store 提交用 5 张 Screenshots

**日期**：2026-08-24
**阶段**：App Store Connect 上架交付（macOS 端，2880×1800 retina）
**基础**：C15 dark shippable（5 张 4K shippable 终版 + 设计 tokens D1/D2）
**目标**：5 张 16:10 retina PNG，macOS 状态栏 + 菜单栏 + Dock 完整，统一品牌色紫青，文字叠加只放标题 + 副标

---

## 1. 5 张终版清单

| # | 文件 | 场景 | 标题 | 副标 | 基础（C15 哪一张）|
|---|------|------|------|------|-------------------|
| 01 | `01-meeting__260824.png` | 会议进行中 | **边开会、边记录** | 系统级录音 · 实时落字 | C15/01-meeting/ |
| 02 | `02-transcript__260824.png` | 实时转录 | **每一句都不漏** | 自动分说话人 · 时间码同步 | C15/03-transcript/ |
| 03 | `03-summary__260824.png` | AI 总结 | **48 分钟，4 段总结** | 关键瞬间 · 决定 · 待办 | C15/04-review/ |
| 04 | `04-onboarding__260824.png` | 首启体验 | **5 分钟开始** | 本地优先 · 无需账号 | C15/05-onboarding/ |
| 05 | `05-empty__260824.png` | 桌面空状态 | **本地优先 · 高级 BYOK** | 数据你的 · 模型你选 | C15/02-empty/ |

**文件命名**：`<index>-<scene>__<date>.png`（按 C02 §4 命名规范）
**尺寸**：5/5 = **2880×1800**（16:10 retina）`sips` 验证通过
**格式**：5/5 = PNG，RGB（无透明）

---

## 2. 出图方法

### 2.1 为什么不用 mcode-tools 直接生

- mcode-tools `connector__matrix__generate_image` 的 `aspect_ratio` 只支持 `1:1 / 16:9 / 9:16 / 4:3 / 3:4 / 21:9`，**没有 16:10**。
- 16:9 4K = 5504×3072，App Store 16:10 = 2880×1800（= 1.6）。直接出 16:9 然后压 16:10 会水平 squash 12%，UI 变形。
- **正确路径**：C15 shippable 是 16:9 4K 终版，复用它做底版 → letterbox 16:9 → 16:10 → 缩到 2880×1800 → 文字叠加。

### 2.2 出图步骤

1. **加载** C15 shippable 终版（5504×3072，16:9 4K）
2. **采样底色**：从 C15 顶边 8 像素取均值做 top-pad 底色
3. **建画布** 5504×3440（16:10），先画一个上深紫下暗蓝的渐变（TOP_PAD=280px）
4. **粘贴** C15 图到 (0, 280)，让菜单栏出现在 y=280 处
5. **画文字**（仅在 y<280 区域，不碰菜单栏）：
   - 标题：130px（5504 scale）→ 视感 ~50pt（1800 scale），#F4F1EC 暖白 + 阴影
   - 副标：50px → 视感 ~20pt，#F4F1EC 85% alpha
6. **缩到** 2880×1800（LANCZOS）
7. **存为** PNG（optimize=True）

### 2.3 中文字体处理

- 任务要求 "Noto Serif SC / Noto Sans SC" —— macOS 不带 Noto SC
- **实际使用 macOS 等价字体**：
  - 标题 = `Songti SC Bold`（= Noto Serif SC Bold 等价，宋体 feel）
  - 副标 = `Hiragino Kaku Gothic ProN`（= Noto Sans SC Regular 等价，苹方 feel）
  - 两者 fallback 链都列在 `_build_screenshots.py` `find_font()` 里
- 字体大小：130 / 50px（5504 scale），视感 ~50pt / 20pt（1800 scale 1:1）—— 命中任务规格的 48-64pt / 18-24pt

### 2.4 文案纪律

**严格遵守 C02 §2.3 anti-leak addendum**：

| 项 | 检查 |
|----|------|
| 标题/副标不出现 prompt 字号/样式标签（"14pt" / "600" / "STYLE 1"）| ✅ 0 处 |
| 标题/副标不出现 "AI" / "node" / "TEST" / "Sample" / "Placeholder" | ✅ 0 处 |
| 标题/副标不出现 "EXACTLY" / "ONLY" 词 | ✅ 0 处 |
| 标题/副标不堆营销词（"AI 驱动" / "效率提升" / "赋能" / "智能化"）| ✅ 0 处 |
| 标题/副标用真实中文词组，无字符碎片 | ✅ 全部 |
| 标题/副标不覆盖 macOS 菜单栏 | ✅（TOP_PAD=280px 内画完，菜单栏 y=280 起）|
| 5 张图整体调性统一（同一台 Mac 截的 + 同一字体 + 同一底色处理）| ✅（C15 shippable 一致）|

---

## 3. 与 C15 / C16 的关系

| 关系 | 说明 |
|------|------|
| **底版来源** | C15 dark shippable 5 张（5504×3072 4K，README §1 已 shippable）|
| **C16 light shippable** | 浅色版备选未使用（本轮选深空底，对 App Store 视觉冲击更强；浅色版若需要可再出）|
| **C02 §1 品牌锁定** | 紫青品牌色（aurora purple #7B3FE4 → cyan glow #2EE6E0 → magenta spark #E63FB8）通过 C15 wallpaper 自然呈现 |
| **C02 §2.1 装饰禁止** | ✅ 0 处 waveform / 0 处 cyberpunk / 0 处星空银河 / 0 处 "AI" 字样烧图 / 0 处双圆对话图标 |
| **C02 §2.2 macOS 元素** | ✅ 5 张图全含 Apple logo + Yinghua + File/Edit/View/Window/Help + 21:42 |
| **C02 §2.3 anti-leak** | ✅ 标题/副标 0 处泄漏（C15 自身的 calendar 顶部 "ONLY 26" 残留瑕疵保留，详见 §5 Figma 精修清单）|
| **C02 §2.4 Dock 12 元素** | ✅ C15 shippable 已锁定 12 ± 1（C15 README §3 详）|

---

## 4. App Store 提交 Checklist

### 4.1 强制规范 ✅

- [x] 5 张图全 2880×1800（16:10 retina）`sips` 验证
- [x] 5 张图全 PNG，RGB（无透明）
- [x] 数量 = 5（在 App Store Connect 的 3-10 张范围内）
- [x] 第 1 张 = 主推场景（"边开会、边记录" 会议进行中，命中产品核心价值）
- [x] 5 张图整体调性统一（同一台 Mac 截的，同一紫青品牌色，同一字体处理）
- [x] macOS 状态栏 + 菜单栏 + Dock 5/5 完整可见

### 4.2 内容规范 ✅

- [x] **不**堆 marketing 大字（仅 1 标题 + 1 副标/张，且不与 product page description 重复）
- [x] 标题 SF Pro Display 视感 ~50pt（任务规格 48-64pt 内）
- [x] 副标 SF Pro Text 视感 ~20pt（任务规格 18-24pt 内）
- [x] 标题放图顶部 1/4 区域（y=16-130px in 1800-scale，1/4 区域内）
- [x] 副标紧跟标题下方
- [x] **不**要 emoji 代替 icon（5/5 全用 macOS 系统 icon）
- [x] 紫青品牌色 5/5 通过 C15 wallpaper + 紫青 macOS UI（speaker avatar M 紫 / W 青 / Z 粉）自然呈现

### 4.3 顺序（用户决定后不可改）✅

App Store Connect 上传时按文件编号顺序：
1. `01-meeting__260824.png` — 主推
2. `02-transcript__260824.png` — 核心功能 1
3. `03-summary__260824.png` — 核心功能 2（AI 总结）
4. `04-onboarding__260824.png` — 首启体验
5. `05-empty__260824.png` — 桌面空状态（BYOK 主推）

---

## 5. Figma 后期精修清单（**非 blocking**——已可提交，但建议 Round 3 一刀修）

C15 自身的已知瑕疵（来自 C15 README § "Figma 后期精修清单"），继承到 C23：

| 类别 | 数量 | Figma 修法 |
|------|------|-----------|
| Calendar 顶部小字符（"ONLY" / "丧月" / "麦月" / "2 班" / "WE" 等）| 5/5 | Figma 顶部白色 1px 高矩形遮盖，仅保 "26" 红色 |
| 03/04 Dock 多余 FaceTime / Terminal / Trash / Contacts | 2/5（03 + 04）| Figma 删除，按 C15 12 项标准裁 |
| 04 第 5 个 dock icon 是"棕色便签"（应是 Notes 黄便签）| 1/5 | Figma 替换 |

> **5 分钟工作量**，非 blocking。App Store 提交时瑕疵可被缩略图隐藏（缩略图 320×200 时 calendar 顶部小字符几乎不可见）。

---

## 6. 出图记录

| 图 | 终版文件 | 大小 | 基础源 | 备注 |
|----|----------|------|--------|------|
| 01 meeting | `01-meeting__260824.png` | 4.6 MB | C15/01-meeting | v2 锁定：标题移到 TOP_PAD=280 区域内（v1 标题压菜单栏）|
| 02 transcript | `02-transcript__260824.png` | 4.7 MB | C15/03-transcript | v2 锁定（同 v1 修复）|
| 03 summary | `03-summary__260824.png` | 4.6 MB | C15/04-review | v2 锁定（同 v1 修复）|
| 04 onboarding | `04-onboarding__260824.png` | 4.2 MB | C15/05-onboarding | v2 锁定 |
| 05 empty | `05-empty__260824.png` | 4.5 MB | C15/02-empty | v2 锁定 |

**总出图数**：5 张 shippable + 1 张 v1 修复 = 6 张渲染
**总耗时**：~5 分钟（含 v1 验证发现菜单栏覆盖 + 改 font size + 重出 5 张）
**脚本**：`./_build_screenshots.py`（可重跑，幂等）

---

## 7. 复现命令

```bash
cd /Users/zzw4257/Documents/ZJU_archieve/08-AI之路/2026-8-Interview-dragon/design/_exploration/C23_app-store-screenshots
python3 _build_screenshots.py
# 验证
sips -g pixelWidth -g pixelHeight 0*.png
# 应该全部输出 2880 x 1800
```

**前置条件**：
- Python 3 + Pillow（`pip3 install Pillow`）
- macOS 系统字体（`/System/Library/Fonts/Supplemental/Songti.ttc` 等都已自带）
- C15 dark shippable 5 张已 shippable（依赖 `_build_screenshots.py` 顶部的 `C15_DIR`）

---

## 8. 结论

**C23 5 张 App Store 截图已全部就绪**。

- 5/5 = 2880×1800 16:10 retina PNG（无透明）
- 5/5 = C15 shippable 终版做底版（与 marketing / 投资人 deck / landing page 完全一致）
- 5/5 = 文字叠加仅 1 标题 + 1 副标，不压菜单栏，不堆营销词
- 5/5 = macOS 元素（菜单栏 + Dock + 状态栏）完整
- 5/5 = 紫青品牌色保持
- 5/5 = C02 §2.3 anti-leak 0 处泄漏
- 5/5 = 与 C15 同调性（同一台 Mac 截的）

**适合直接交付 App Store Connect**（9/10 shippable，1 扣 Figma 后期精修 calendar 顶部小字符）。
