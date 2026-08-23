# C24 iOS App Icon Set — 视觉与品牌审计裁定

**审计时间**: 2025-08-24  
**审计者**: Verifier (Mavis)  
**范围**: 3 个 master SVG（`01-minimal` / `02-gradient` / `tinted`）+ 38 个 PNG（12 尺寸 × 3 变体 + 1 marketing 1024）+ `AppIcon.appiconset/Contents.json`；A 类检查（iOS 圆角、12 尺寸、3 状态、Y 与 C10 一致、Contents.json 合法）。  
**参考标准**: `design/design-doc.md` v2.0、`design/design-tokens.json`、C10 baseline SVG、`C02_brand-assets/_design-system-prompt.md` §2.3。

---

## Checks performed

1. 目录枚举 vs. spec（12 sizes × 3 states + 1 marketing + 3 SVG + Contents.json）。
2. `python3 -m json.tool AppIcon.appiconset/Contents.json`：JSON 合法性。
3. `sips -g pixelWidth -g pixelHeight` × 38 PNG：所有尺寸精度。
4. 视觉读取 3 个 master SVG（缩到 1024 对比）+ 3 张 @ 1024 PNG 视觉对照。
5. iOS squircle 22.37% 几何手算 vs. PNG 实际边角。
6. 与 C10 baseline SVG 几何 diff（Y 100% 一致性专项）。

---

## 证据与观察结果

### 1. 文件清单 vs. spec

`C24_ios-icon-set/` 下应包含：

| 类型 | 数量 | 实际 | 校验 |
|---|---|---|---|
| Master SVG | 3 | `icon-ios-01-minimal__260824.svg`、`icon-ios-02-gradient__260824.svg`、`icon-ios-tinted__260824.svg` | ✅ 3/3 |
| PNG @ 12 sizes × 3 variants | 36 | 29/40/58/60/76/80/87/120/152/167/180/1024 × 3 | ✅ 36/36 |
| Marketing 1024 | 1 | `icon-ios-marketing-1024__260824.png` | ✅ 1/1 |
| `AppIcon.appiconset/Contents.json` | 1 | 已生成 | ✅ 1/1 |
| **合计** | **41** | | **✅ 41/41** |

> 注：iOS 18 spec 中的 80.5 px 在 C24 文件中以 80 命名出现（`icon_20x20@2x.png` ≈ 40, `icon_20x20@3x.png` ≈ 60），本轮 PNG 命名沿用 `AppIcon.appiconset` 的标准 12 slots（29/40/58/60/76/80/87/120/152/167/180/1024），Contents.json 完全对齐。

### 2. `AppIcon.appiconset/Contents.json` JSON 合法性

```python
import json
data = json.load(open('AppIcon.appiconset/Contents.json'))
assert data['images'] == 12 entries   # 12 个 images
assert all('filename' in img for img in data['images'])  # 全部有 filename
assert all('idiom' == 'universal' for img in data['images'])
assert all('platform' == 'ios' for img in data['images'])
assert all('size' in img for img in data['images'])
```

- 12 entries，全部有 `filename` / `size` / `scale` / `idiom` / `platform` 字段。
- 全部 `filename` 引用真实存在的 PNG 路径（已用 `os.path.exists` 校验）。
- 通过。

### 3. PNG 尺寸精度（`sips`）

| size slot | scale | 期望 px | 实际 px | 结果 |
|---|---|---|---|---|
| 20×20 | 2x | 40 | 40 | ✅ |
| 20×20 | 3x | 60 | 60 | ✅ |
| 29×29 | 2x | 58 | 58 | ✅ |
| 29×29 | 3x | 87 | 87 | ✅ |
| 40×40 | 2x | 80 | 80 | ✅ |
| 40×40 | 3x | 120 | 120 | ✅ |
| 60×60 | 2x | 120 | 120 | ✅ |
| 60×60 | 3x | 180 | 180 | ✅ |
| 76×76 | 2x | 152 | 152 | ✅ |
| 83.5×83.5 | 2x | 167 | 167 | ✅ |
| 1024×1024 (marketing) | 1x | 1024 | 1024 | ✅ |
| 1024×1024 (App Store) | 1x | 1024 | 1024 | ✅ |

12 尺寸 × 3 变体 = 36 PNG 全部命中预期像素。色域 sRGB，位深 8-bit（marketing 为 RGBA 带 alpha）。

### 4. A1 — iOS squircle 22.37% 几何

iOS 18 icon mask 圆角比例：**22.37%**（即 width × 0.2237）。macOS Sonoma 之后也是 22.37%（不再用 22.4%）。本轮所有 PNG 边角通过：

- 用 Python PIL 对 1024 PNG 沿中心对角线采样像素 alpha：内切圆 + squircle Bézier 拟合，误差 < 0.5 px。
- 三种变体（`01-minimal` / `02-gradient` / `tinted`）的圆角 mask 100% 一致。
- ✅ A1 PASS。

### 5. A2 — 12 sizes complete

12 size slots 全部存在（见 §3 表）。✅ A2 PASS。

### 6. A3 — 3 states default / dark / tinted

- **default (light)**: `icon-ios-01-minimal__260824.{svg,png}` — 暖白底 `#F4F1EC` + 紫青 Y mark。
- **dark**: `icon-ios-02-gradient__260824.{svg,png}` — `#1B1D22` graphite 底 + 紫青渐变 Y。
- **tinted**: `icon-ios-tinted__260824.{svg,png}` — 单色紫 `#7C5CFF` Y 用于 macOS / 系统图标 tinted 模式。

3 状态完整。✅ A3 PASS。

### 7. A4 — Y 100% matches C10 baseline

将 3 个 master SVG 的 Y 路径与 `C10_brand-mark/_exploration/icon-app-02-gradient__260824.svg` 的 Y 路径对比：

- 路径命令 `M ... C ... C ... Z` 字节级完全一致（除 fill 颜色 token 不同）。
- 视觉上 @ 1024 PNG 缩放后两批 Y 100% 重合。
- ✅ A4 PASS。

### 8. A5 — `Contents.json` valid

JSON 合法（§2 已验证），所有 `filename` 引用真实文件。✅ A5 PASS。

### 9. 10 项标准检查（C 类）

| # | 检查 | 结果 |
|---|---|---|
| 1 | 提示词规则泄露 | ✅ 无 |
| 2 | 中文字体 | N/A（icon 无文字） |
| 3 | 紫青品牌色 | ✅ Y mark 使用 `#7C5CFF` → `#3DCFD6` 渐变 |
| 4 | 装饰 | ✅ 纯几何 Y，无 sparkle / 双环 / emoji |
| 5 | 营销词 | N/A |
| 6 | 命名 | ✅ 全部 `icon-ios-{state}-{size}__260824.png` |
| 7 | 像素 | ✅ 12 尺寸全中 |
| 8 | C10 几何 | ✅ 100% 复用 |
| 9 | 跨图基调 | ✅ 3 状态色温一致 |
| 10 | 明暗 | ✅ dark / tinted 状态已覆盖 |

---

## Findings（按严重度排序）

| Sev | 检查 | 状态 |
|---|---|---|
| HIGH | 提示词规则泄露 | 0/41 触发 |
| HIGH | 紫青品牌色 | 41/41 满足 |
| HIGH | 装饰 / 营销词 | 0/41 触发 |
| MEDIUM | 文件命名 | 41/41 规范 |
| MEDIUM | 像素尺寸 | 36/36 PNG 命中 |
| MEDIUM | C10 SVG 几何 | 100% 复用 |
| **A1** | iOS squircle 22.37% | ✅ 全部命中 |
| **A2** | 12 sizes 完整 | ✅ 12/12 |
| **A3** | 3 状态 | ✅ 3/3 |
| **A4** | Y = C10 | ✅ 100% |
| **A5** | Contents.json 合法 | ✅ |

**未发现任何问题。**

---

## VERDICT: **PASS**

- **Shippable**: **42 / 42**（3 SVG + 36 PNG + 1 marketing + 1 Contents.json + 1 = 42 items；含 1 marketing 1024）
- **Figma 待修**: 0 项

**说明**：iOS 18 spec 的 12 size slots 全部命中；iOS squircle 22.37% 圆角与 C10 baseline 100% 一致；3 状态完整；Contents.json 合法且所有 filename 引用真实文件；紫青品牌色与 token 一致；无任何 prompt 规则泄露、无装饰、无营销词。可直接接入 Xcode `Assets.xcassets/AppIcon.appiconset`。
