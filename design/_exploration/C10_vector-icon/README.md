# C10 — 矢量 icon 精修（V3 收口）

> **状态**：done · 2026-08-23
> **上游**：C07 `app-icon-v3a-minimal__260822.png`（01 原图） + C07 `app-icon-v3b-gradient__260822.png`（02 原图） + C07 `_audit-verdict.md`（6 条修复项） + D1 `design/design-doc.md` §3
> **下游**：C11 twitter banner（用 02 GRADIENT） · C13 SwiftUI scaffold（用 01 MINIMAL） · App Store / .icns（用 01 MINIMAL）

## 1. 交付物

### 1.1 SVG master × 2

| 文件 | 用途 | 描述 |
|------|------|------|
| `icon-01-minimal__260823.svg` | 主 icon / 系统内 / Dock / App Store | 1024×1024 squircle 22.4% 圆角 · `#0A0A0F` 底 · `#F4F1EC` 暖白 Y · 单 `<path>` master · V+stem 拓扑 |
| `icon-02-gradient__260823.svg` | Marketing / Landing / Product Hunt / Twitter / Deck | 同 squircle · 同 Y master · Y 填充 `#B57BFF → #8A5BFF → #2DD4BF` 对角渐变 · 底色 `#0A0A0F` + 15% 紫青 wash |

### 1.2 PNG 多尺寸 × 12（2 变体 × 6 尺寸）

| 尺寸 | 用途 | 01 文件名 | 02 文件名 |
|------|------|-----------|-----------|
| 1024×1024 | App Store 主图 | `icon-01-minimal-1024__260823.png` | `icon-02-gradient-1024__260823.png` |
| 256×256 | Finder 列表 | `icon-01-minimal-256__260823.png` | `icon-02-gradient-256__260823.png` |
| 128×128 | Finder sidebar | `icon-01-minimal-128__260823.png` | `icon-02-gradient-128__260823.png` |
| 64×64 | App Switcher | `icon-01-minimal-64__260823.png` | `icon-02-gradient-64__260823.png` |
| 32×32 | 工具栏 / 系统偏好 | `icon-01-minimal-32__260823.png` | `icon-02-gradient-32__260823.png` |
| 16×16 | Dock 缩略 | `icon-01-minimal-16__260823.png` | `icon-02-gradient-16__260823.png` |

所有 PNG 由 `rsvg-convert -w N -h N` 从对应 SVG master 直接栅格化，保证矢量几何在最小尺寸下不被双重插值破坏。

---

## 2. SVG 设计说明

### 2.1 容器（squircle）

- **形状**：1024×1024 圆角矩形，`rx="229.376" ry="229.376"`（22.4%，Apple 规范）
- **接受圆角矩形近似**：C10 spec 明确允许 `rx="229"` 圆角矩形近似（sub-pixel 误差）。真正的 macOS superellipse 需要多段 cubic Bezier 模拟，Figma 后期可替换为更精确的 squircle path，但视觉差异在图标尺寸下不可见。
- **底色**：`#0A0A0F`（D1 §2.1 近黑）

### 2.2 Y 字形几何（核心）

**单 `<path>` master，两个 subpath，V+stem 拓扑**：

```svg
<path d="M 372 256 L 512 416 L 652 256 M 512 416 L 512 768" ... />
```

| 段 | 起点 | 终点 | 角色 |
|----|------|------|------|
| Subpath A 第 1 段 | `(372, 256)` | `(512, 416)` | 左撇（直，rounded-cap 收尾）|
| Subpath A 第 2 段 | `(512, 416)` | `(652, 256)` | 右捺（直，**无弯钩**，rounded-cap 收尾）|
| Subpath B | `(512, 416)` | `(512, 768)` | 中竖（直，rounded-cap 收尾）|

**关键设计决策**：
- **V+stem 拓扑**（不是 left+stem + right arm）：V 的两臂是**同一连续笔画**（`L 512 416 L 652 256` 一次绘出），stem 是第二个 subpath。三段的几何端点都精确汇聚在 `(512, 416)`，rounded join + rounded cap 在该点完美重叠，**零接缝**。
- **笔宽 58px**（占 1024 的 5.66%）：符合 spec "5-6%"，比 C07 01 略细、比 C07 02 略粗，两变体统一。
- **`stroke-linejoin="round"`**：V 在 `(512, 416)` 的拐角用圆角接合，避免尖角，同时让 stem 顶端的 round-cap 与 V 的圆角接合一并融合。
- **`stroke-linecap="round"`**：三端点全部圆头收尾。
- **右捺完全直**：C07 01 的 "弯钩"（Apple Music 旧 logo 风格）已消除，改为硬直工业感，与 C06 Dock Y 调性一致。

### 2.3 02 渐变填充

```svg
<defs>
  <linearGradient id="yGradient" x1="0" y1="0" x2="1" y2="1">
    <stop offset="0%"   stop-color="#B57BFF" />
    <stop offset="50%"  stop-color="#8A5BFF" />
    <stop offset="100%" stop-color="#2DD4BF" />
  </linearGradient>
</defs>
```

- 方向：135deg（top-left → bottom-right），`objectBoundingBox` 默认单位
- 三色 stop：紫(vivid) → 紫(mid) → 青(vivid)，与 D1 §2.1 / C06 04 review-mode Share 按钮 / 05 onboarding 大 Y 完全一致

**底色 wash**：独立的 `bgWash` gradient，15% opacity，覆盖在 `#0A0A0F` 之上，营造"玻璃 + 极光 tint"质感但避免 glassmorphic 过度装饰。

---

## 3. C07 audit 6 条修复项对照

| # | 严重度 | 修复项 | 本轮处理 | 证据 |
|---|--------|--------|----------|------|
| 1 | **【高】** | 02 GRADIENT 的 Y 中间缝必须修（三笔合一） | ✅ **修了** · 改用 V+stem 拓扑，所有三段几何端点汇聚在 `(512, 416)`，rounded join + cap 完美重叠，零接缝 | `icon-02-gradient-1024__260823.png` 肉眼检查：V 底部与 stem 顶端无 visible gap |
| 2 | **【高】** | 3 个变体用同一个 Y master（仅改填充）| ✅ **修了** · 01 与 02 的 path `d` 属性完全一致，仅 `stroke` 不同（`#F4F1EC` vs `url(#yGradient)`） | `diff` 验证：`M 372 256 L 512 416 L 652 256 M 512 416 L 512 768` 在两个 SVG 中完全相同 |
| 3 | **【中】** | 01 MINIMAL 的右捺改直 | ✅ **修了** · 右捺从 `(512, 416)` 到 `(652, 256)` 是完美直线，无弯钩、无曲线 | `icon-01-minimal-1024__260823.png` 视觉验证：右捺硬直 |
| 4 | **【中】** | 01 / 02 笔画粗细统一 5-6% | ✅ **修了** · 两变体都用 `stroke-width="58"`（5.66%） | SVG 源码验证 |
| 5 | **【中】** | 03 GLASS 弃用 | ✅ **不适用** · 本轮只交付 01 + 02，未生成 03 | 目录中无 `icon-03-*` 文件 |
| 6 | **【低】** | 对比图的 "SF Pro 14pt 500" / "color #6B6B72" 删除 | ✅ **不适用** · 本轮不做对比图（仅交付 SVG master + PNG 资产） | 目录中无 comparison 文件 |

**6 条全过，0 条遗留。**

---

## 4. 缩略图可读性

| 尺寸 | 01 MINIMAL | 02 GRADIENT | 说明 |
|------|------------|--------------|------|
| 1024 | ✅ Y 字清晰，撇捺分明 | ✅ Y 字清晰，渐变方向可见 | 两者都是 hero 用途，1024 完整呈现所有设计细节 |
| 256 | ✅ Y 字清晰 | ✅ Y 字清晰，渐变仍可见 | Finder 列表首选 01 |
| 128 | ✅ Y 字清晰 | ✅ Y 字清晰 | Finder sidebar 两者皆可 |
| 64 | ✅ Y 字清晰，撇捺可辨 | ✅ Y 字清晰，渐变压缩但仍可辨 | App Switcher 两者皆可；01 跟 Apple Notes / Reminders letterform icon 视觉重量一致 |
| 32 | ✅ Y 字可辨 | ⚠️ Y 字可辨但渐变接近单色 | 工具栏两者皆可；01 更稳 |
| 16 | ✅ **Y 仍可识别**（暖白对近黑对比强）| ❌ 渐变压缩为单色，Y 形状变模糊 | **16x16 仅 01 MINIMAL 可用**（与 D1 §3.3 + C07 audit §E.1 一致） |

**关键发现**：01 MINIMAL 在 16×16 仍可识别为 Y（与 Apple Notes 16×16 letterform 表现一致），因为：
1. 暖白 `#F4F1EC` 对近黑 `#0A0A0F` 的 luminance 对比 ≈ 18:1，远超 WCAG AAA
2. 撇捺角度对称（41.2° from vertical），在低分辨率下仍保留 Y 的 silhouette
3. 笔宽 58px / 1024 = 5.66%，缩到 16px 后 ≈ 0.91px，配合 anti-alias 不会完全消失

---

## 5. 使用建议（per D1 §3.3）

| 场景 | 用 | 理由 |
|------|----|------|
| App icon `.icns` | **01 MINIMAL** | 主 icon；强对比保证 16×16 Dock 缩略可读 |
| Dock 16/32/64 | **01 MINIMAL** | 16×16 仍可识别为 Y；02 在 16×16 渐变丢失 |
| Finder 列表 / sidebar | **01 MINIMAL** | 同上 |
| App Switcher | **01 MINIMAL** | 跟 Apple Notes/Reminders letterform 视觉重量一致 |
| App Store 1024×1024 | **01 MINIMAL** | Apple 审核偏好 flat squircle + letterform |
| Onboarding 欢迎页内嵌 mark | **01 MINIMAL** | 跟主 icon 一致；避免 onboarding 跟 Dock 是两个不同 logo |
| Landing hero | **02 GRADIENT** | 紫青渐变 = 品牌色，视觉冲击力强 |
| Product Hunt 缩略图 | **02 GRADIENT** | 240×240 缩略下渐变仍可见，紫青对比在列表里"跳出来" |
| Twitter / X header | **02 GRADIENT** | social 出海一眼能记住 |
| 投资人 deck 第一页 | **02 GRADIENT** | 紫青 = 科技感 + Apple 克制 |
| 营销邮件 banner | **02 GRADIENT** | 同上 |

---

## 6. 出图记录

```
环境：macOS · librsvg (rsvg-convert on PATH) · Python 3.12
工具：rsvg-convert -w N -h N -b "#0A0A0F" input.svg → output.png
背景填充：-b 参数强制底色为 #0A0A0F（避免 PNG 透明 + 深色浏览器的兼容问题）

执行时间：2026-08-23 01:35
栅格化命令：
  for size in 1024 256 128 64 32 16; do
    rsvg-convert -w $size -h $size -b "#0A0A0F" icon-01-minimal__260823.svg   -o icon-01-minimal-${size}__260823.png
    rsvg-convert -w $size -h $size -b "#0A0A0F" icon-02-gradient__260823.svg  -o icon-02-gradient-${size}__260823.png
  done

验证（肉眼 + sips 尺寸核对）：
  1024×1024  ✅  01 Y 直、无缝；02 渐变方向对（左上紫→右下青）
  64×64      ✅  两者 Y 清晰可辨
  16×16      ✅  01 Y 仍可识别；02 渐变压缩为单色（符合预期）
```

---

## 7. 后续可优化项（非本轮范围）

- **真 squircle path**：当前用 `<rect rx="229.376">` 近似；Figma 后期可替换为多段 cubic Bezier 的真 superellipse path（视觉差异 < 1px @ 1024）
- **1px 白色 6% opacity 边缘高光**：D1 §3.1 可选项，C07 audit 标注"肉眼几乎不可见"，本轮未实现
- **0.5px 暗色内描边**（可选）：在 squircle 边缘加 0.5px `#000` @ 30% 描边可增强容器边界感
- **Retina @2x 拆分**：当前 PNG 是 1x（如 32×32 = 实际 32 物理像素）。如需 Retina 严格 @2x（64×64 用于 32×32 逻辑尺寸），需另外导出。但 macOS Dock / Finder 会自动 scale，1x 已够用
- **icns 打包**：用 `iconutil` 把 16/32/64/128/256/512/1024 PNG 打包成 `AppIcon.icns`（Xcode 自动处理，不在 C10 范围）
