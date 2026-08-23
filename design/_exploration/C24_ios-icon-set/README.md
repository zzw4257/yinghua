# C24 — 映话 iOS App Icon 套件

> **状态**：done · 2026-08-24
> **上游**：C10 `vector-icon/`（macOS 矢量 master） + C07 `_audit-verdict.md`（6 项修复） + Apple HIG 2025 "App Icon"
> **下游**：映话 iOS companion app（Xcode asset catalog 直接 import） + 任何 iOS 渠道 marketing 出海

## TL;DR

iOS 跟 macOS **共享同一个 Y master**（path `d` 字符级一致），只在容器比例上微调（22.37% iOS vs 22.4% macOS）以匹配 Apple 平台规范。**24 个营销 PNG**（01 + 02 × 12 尺寸）+ **37 个 Xcode-ready PNG**（12 default + 12 dark + 12 tinted + 1 marketing 1024）配完整 `Contents.json`（3 态 × 12 尺寸 = 36 entries），可直接拖进 Xcode `Assets.xcassets`。

---

## 1. 交付物清单

### 1.1 SVG master × 3（root）

| 文件 | 用途 | 描述 |
|------|------|------|
| `icon-ios-01-minimal__260824.svg` | 主 app icon (default + dark) | 1024×1024 squircle 22.37% 圆角 (rx=229.069) · `#0A0A0F` 底 · `#F4F1EC` 暖白 Y · V+stem 拓扑 |
| `icon-ios-02-gradient__260824.svg` | Marketing / social | 同 squircle · 同 Y master · Y 填充 `#B57BFF → #8A5BFF → #2DD4BF` 135° 渐变 · 15% 紫青 wash |
| `icon-ios-tinted__260824.svg` | iOS 18 Tinted mode | **透明背景** + 单色 `#FFFFFF` Y（系统应用 tint 颜色）· 与 01/02 同 Y master |

### 1.2 iOS PNG 12 尺寸 × 3 变体 = 36 PNG（root + appiconset）

**12 个 iOS 18 尺寸**（per Apple HIG 2025 / App Icon）：

| 物理像素 | Apple 角色 | 映射 (idiom, size, scale) |
|----------|------------|----------------------------|
| 1024×1024 | App Store marketing | universal, 1024×1024 |
| 180×180 | iPhone 60pt @3x | iphone, 60×60, 3x |
| 167×167 | iPad Pro 12.9" 83.5pt @2x | ipad, 83.5×83.5, 2x |
| 152×152 | iPad 76pt @2x | ipad, 76×76, 2x |
| 120×120 | iPhone 60pt @2x | iphone, 60×60, 2x |
| 87×87 | iPhone Settings 29pt @3x | iphone, 29×29, 3x |
| 80×80 | iPhone Spotlight 40pt @2x | iphone, 40×40, 2x |
| 76×76 | iPad 76pt @1x | ipad, 76×76, 1x |
| 60×60 | iPhone 60pt @1x | iphone, 60×60, 1x |
| 58×58 | iPhone Settings 29pt @2x | iphone, 29×29, 2x |
| 40×40 | iPhone Spotlight 40pt @1x | iphone, 40×40, 1x |
| 29×29 | iPhone Settings 29pt @1x | iphone, 29×29, 1x |

### 1.3 文件分布

**C24 根目录（24 个营销 PNG + 12 个 tinted + 3 个 SVG）**：

```
C24_ios-icon-set/
├── icon-ios-01-minimal__260824.svg        # Y master · 黑底暖白 Y
├── icon-ios-02-gradient__260824.svg       # Y master · 紫青渐变 + wash
├── icon-ios-tinted__260824.svg            # 单色 Y · 透明背景
│
├── icon-ios-01-minimal-{1024,180,167,152,120,87,80,76,60,58,40,29}__260824.png  (12 files)
├── icon-ios-02-gradient-{1024,180,...,29}__260824.png  (12 files)
└── icon-ios-tinted-{1024,180,...,29}__260824.png  (12 files · 透明背景)
```

**`AppIcon.appiconset/`（37 个 Xcode-ready PNG + Contents.json）**：

```
C24_ios-icon-set/AppIcon.appiconset/
├── Contents.json                    # 36 entries (3 态 × 12 尺寸)
│
├── icon-ios-default-{1024,180,...,29}.png   (12 files · 用于 default + light mode)
├── icon-ios-dark-{1024,180,...,29}.png      (12 files · 用于 dark mode)
├── icon-ios-tinted-{1024,180,...,29}.png    (12 files · 用于 tinted mode · 透明背景)
└── icon-ios-marketing-1024.png              (1 file · 02 GRADIENT 1024 备用 · 不在 Contents.json)
```

**总计**：

- **3 SVG masters** (root)
- **36 营销 PNG** in root (12 尺寸 × 3 变体: 01 MINIMAL + 02 GRADIENT + tinted)
- **37 Xcode-ready PNG** in `AppIcon.appiconset/` (12 default + 12 dark + 12 tinted + 1 marketing 1024)
- **1 `Contents.json`** (3 appearances × 12 sizes = 36 entries)
- **1 README.md**

= **3 SVG + 73 PNG + 1 Contents.json + 1 README = 78 files**

---

## 2. iOS vs macOS icon 差异（关键设计决策）

| 维度 | macOS（C10）| iOS（C24）| 为什么 |
|------|------------|------------|--------|
| **容器比例** | 22.4% squircle (rx=229.376) | **22.37% squircle** (rx=229.069) | Apple HIG 2025 明确：iOS 用 continuous rounded rect 22.37%，macOS Big Sur+ 用 superellipse 22.4% |
| **Y 几何** | `M 372 256 L 512 416 L 652 256 M 512 416 L 512 768` | **100% 字符级一致** | Cross-platform brand 一致性：同一个 Y、同一个字形、同一个跨平台 master |
| **笔触** | stroke-width=58 · round-cap · round-join | **完全一致** | C07 audit 修复 #1 #2 #3 #4 全部继承 |
| **多状态** | 单态（macOS 26+ 系统不强制多态）| **三态**：default · dark · tinted | iOS 18 自动适配（light/dark mode + 2025 新增 tinted mode）|
| **透明层** | 不需要（squircle 始终是 100% 不透明容器）| tinted mode 需要**透明背景 + 单色 Y** | iOS 系统提取 alpha mask 并应用 tint 颜色 |
| **1024 master 用途** | App Store + 系统 icon 全部从 1024 派生 | App Store + iPhone Home Screen 同一文件 | iOS 18+ 强制要求 1024 主图作为 iPhone 6.7"/6.9" Display Zoom 渲染源 |
| **尺寸** | 6 尺寸（1024/256/128/64/32/16）· macOS 桌面需求 | **12 尺寸**（1024/180/167/152/120/87/80/76/60/58/40/29）· iOS 设备矩阵 | iPad Pro 83.5pt @2x + Spotlight/Settings/Notification 多角色细分 |

**关键不变量**：
- ✅ Y 几何 100% 共享（path `d` 属性 diff 验证字符级一致 — 见 §5）
- ✅ stroke-width = 58，5.66% of 1024
- ✅ 配色完全一致（#0A0A0F 底 / #F4F1EC Y / 紫青渐变 #B57BFF → #8A5BFF → #2DD4BF）
- ✅ C07 audit 6 项修复 0 引入新问题

---

## 3. 三态设计（iOS 18 新增 tinted mode）

### 3.1 Default（默认 / light mode）
- 渲染：`#0A0A0F` 底 + `#F4F1EC` Y（跟 macOS 01 MINIMAL 视觉一致）
- 用户看到：黑色 squircle 上的暖白 Y
- 适用：日常 Home Screen、Spotlight、Settings、Notification

### 3.2 Dark（dark mode）
- 渲染：**跟 default 完全相同**（#0A0A0F + #F4F1EC）
- 设计决策：本 squircle 设计已经 near-black + 暖白 Y，在 light/dark 模式下视觉一致
- 适用：dark mode 设备（自动切换，不需额外适配）
- iOS 18 仍要求单独 `dark` appearance entry（系统按设备 appearance 切换）

### 3.3 Tinted（iOS 18 新增 · 系统单色渲染）
- 渲染：**单色 `#FFFFFF` Y on 透明背景**（无 squircle 容器）
- 系统行为：iOS 18 提取 alpha mask，应用系统 tint 颜色（用户可自定义）
- 文件名约定：`icon-ios-tinted-{size}.png`，`hasAlpha=yes`（验证通过）
- 适用：用户在 iOS 18 启用 tinted icon mode 时自动应用
- 设计权衡：tinted 是"形状 only"，颜色由系统决定 → 我们的 Y silhouette 必须能独立站立。我们的 Y 是单一连通笔触（V+stem 拓扑），即使被单色渲染仍能识别为"Y" ✅

### 3.4 Marketing（独立 reference，不在 asset catalog）
- 渲染：`#0A0A0F` 底 + 紫青渐变 Y + 15% aurora wash
- 文件：`icon-ios-marketing-1024.png`（仅 1024，02 GRADIENT 全套在 root）
- 用途：App Store promotional、Twitter profile (1:1)、Landing hero、Product Hunt
- **不在 Contents.json**（Xcode 不需要 marketing 变体）

---

## 4. 与 C10 macOS master 的几何一致性

### 4.1 Y master 100% 共享（diff 验证）

```bash
$ grep -oE 'd="M 372 256[^"]*"' C10/icon-01-minimal__260823.svg
d="M 372 256 L 512 416 L 652 256 M 512 416 L 512 768"

$ grep -oE 'd="M 372 256[^"]*"' C24/icon-ios-01-minimal__260824.svg
d="M 372 256 L 512 416 L 652 256 M 512 416 L 512 768"
```

✅ **字符级一致**（包括空格、字母大小写）。iOS / macOS / Web / Print 任何场景渲染 Y 都是同一个 silhouette。

### 4.2 squircle 比例差异（22.37% vs 22.4%）

```python
>>> 1024 * 0.2237
229.0688     # iOS squircle rx (22.37%)
>>> 1024 * 0.224
229.376      # macOS squircle rx (22.4%)
>>> 229.376 - 229.069
0.307        # 0.03% 视觉差 = 1024 主图 0.31 像素差距
```

**0.31 像素差在 1024 主图不可见**。iOS 强制 22.37% 是为了 Xcode 资产目录验证和 App Store 提交预览的合规性。

### 4.3 V+stem 拓扑保持

| 段 | 起点 | 终点 | 角色 |
|----|------|------|------|
| Subpath A 第 1 段 | `(372, 256)` | `(512, 416)` | 左撇（直，round-cap 收尾）|
| Subpath A 第 2 段 | `(512, 416)` | `(652, 256)` | 右捺（直，无弯钩）|
| Subpath B | `(512, 416)` | `(512, 768)` | 中竖（直，round-cap 收尾）|

三段几何端点汇聚在 `(512, 416)`，round join + round cap 完美重叠，**零接缝**。C07 audit #1 修复完整继承到 iOS 端。

---

## 5. C07 audit 6 项修复对照（iOS 端 0 引入新问题）

| # | 严重度 | 修复项 | C10 处理 | C24 iOS 端 | 证据 |
|---|--------|--------|----------|-------------|------|
| 1 | **【高】** | Y 中间缝必须修（三笔合一）| ✅ V+stem 拓扑 | ✅ 继承 — 字符级 diff 验证 | `diff` 验证 3 个 SVG 的 path `d` 完全一致 |
| 2 | **【高】** | 3 变体用同一 Y master | ✅ 仅改 fill | ✅ 继承 — tinted 用单色 stroke，geometry 一致 | 3 个 SVG 共享 path `d` |
| 3 | **【中】** | 01 MINIMAL 右捺改直 | ✅ 硬直无弯钩 | ✅ 继承 | path `M 512 416 L 652 256` 直线 |
| 4 | **【中】** | 01/02 笔画粗细统一 5-6% | ✅ stroke-width=58 (5.66%) | ✅ 继承 | SVG 源码 `stroke-width="58"` × 3 |
| 5 | **【中】** | 03 GLASS 弃用 | ✅ 不生成 | ✅ 不生成 | C24 目录无 `icon-ios-03-*` 文件 |
| 6 | **【低】** | 对比图 prompt 泄漏删除 | ✅ 不做对比图 | ✅ 不做对比图 | C24 目录无 comparison 文件 |

**6 条全过，0 引入新问题。**

---

## 6. Apple 设计规范引用

### 6.1 iOS HIG 2025 · App Icon

- **Apple Developer Documentation**：[App Icons](https://developer.apple.com/design/human-interface-guidelines/app-icons)
- **关键规范**：
  - 1024×1024 PNG (App Store + iOS 18+ marketing)
  - 22.37% continuous corner radius (iOS standard)
  - iOS 18+ 多态：default · dark · tinted
  - 不允许 alpha 通道（除非 tinted 变体）
  - 不允许文字 · 真实品牌 mark · flat squircle（不要拟物 / 玻璃球）

### 6.2 Apple Design Resources

- **iOS 18 App Icon Templates**：[Apple Design Resources - iOS](https://developer.apple.com/design/resources/)
- 提供官方 .psd / .sketch / .fig 模板，22.37% 圆角已设置

### 6.3 tinted mode（iOS 18 新增）

- **Apple Newsroom**：[iOS 18 introduces customizable app icons and tinted appearance](https://www.apple.com/newsroom/2024/06/...)
- **机制**：用户提供 tinted 变体（单色前景 + 透明背景），系统提取 alpha mask 并应用 tint
- **最佳实践**：tinted 变体 silhouette 必须能独立识别为品牌（不能依赖颜色）

---

## 7. Xcode Assets.xcassets 集成步骤

### 7.1 直接 import 整个 appiconset

```bash
# 在 Xcode 项目根目录
cp -R C24_ios-icon-set/AppIcon.appiconset YourApp/Assets.xcassets/
```

或者在 Xcode UI：
1. 打开 `Assets.xcassets`
2. 右键 → New App Icon Set
3. 命名为 `AppIcon` (跟代码 `AppIcon` build setting 匹配)
4. 把 37 个 PNG 拖进去，Xcode 会按 Contents.json 自动归类

### 7.2 验证

```bash
# 1. JSON 解析
python3 -c "import json; print(len(json.load(open('AppIcon.appiconset/Contents.json'))['images']), 'entries')"

# 2. 所有引用文件存在
python3 -c "
import json, os
data = json.load(open('AppIcon.appiconset/Contents.json'))
missing = [e['filename'] for e in data['images'] if not os.path.exists(f\"AppIcon.appiconset/{e['filename']}\")]
print('Missing:', missing or 'none')
"

# 3. 维度核对
for f in AppIcon.appiconset/icon-ios-*.png; do
  sips -g pixelWidth "$f" 2>/dev/null | awk -F: '/pixelWidth/{gsub(/ /,"",$2); print FILENAME, $2}'
done
```

### 7.3 iOS 18 build setting 验证

在 Xcode → Build Settings 确认：
- `ASSETCATALOG_COMPILER_APPICON_NAME = AppIcon`
- `ASSETCATALOG_COMPILER_ALTERNATIVE_APPICON_NAMES = `（留空，除非有 alt icon）
- `IPHONEOS_DEPLOYMENT_TARGET = 18.0` 或更高（tinted mode 需 iOS 18+）

---

## 8. 出图记录

```
环境：macOS · librsvg (rsvg-convert on PATH) · Python 3.12
工具：rsvg-convert -w N -h N -b "#0A0A0F" input.svg → output.png
     rsvg-convert -w N -h N -b none          input.svg → output.png  (for tinted, transparent bg)

执行时间：2026-08-24 02:14 - 02:25 (11 分钟)

栅格化命令（01 MINIMAL / 02 GRADIENT / TINTED × 12 尺寸）:
  SIZES="1024 180 167 152 120 87 80 76 60 58 40 29"
  for s in $SIZES; do
    rsvg-convert -w $s -h $s -b "#0A0A0F" icon-ios-01-minimal__260824.svg  -o icon-ios-01-minimal-${s}__260824.png
    rsvg-convert -w $s -h $s -b "#0A0A0F" icon-ios-02-gradient__260824.svg -o icon-ios-02-gradient-${s}__260824.png
    rsvg-convert -w $s -h $s -b none         icon-ios-tinted__260824.svg      -o icon-ios-tinted-${s}__260824.png
  done

验证 (sips + python PIL):
  36/36 appiconset PNGs: 维度正确
  36/36 root PNGs: 维度正确
  Tinted PNGs: hasAlpha=yes ✅ (透明背景，iOS 提取 alpha mask)
  Default/Dark PNGs: hasAlpha=no ✅ (solid bg，iOS 直接合成)
  Y 颜色 (244, 241, 236) = #F4F1EC ✅ (warm white per design tokens)
  Bg 颜色 (10, 10, 15)   = #0A0A0F ✅ (near-black per design tokens)
  Y path d: 字符级 diff vs C10 master ✅ (iOS/macOS 100% 共享)
  squircle rx: 229.069 (iOS 22.37%) vs C10 229.376 (macOS 22.4%) ✅
```

---

## 9. 使用建议（per Apple HIG 2025 + C07 §3.3 合并）

| 场景 | 用 | 备注 |
|------|----|------|
| **iOS Xcode app icon (default)** | AppIcon.appiconset · default | Xcode 引用 `AppIcon.appiconset` 的 default appearance |
| **iOS Xcode app icon (dark mode)** | AppIcon.appiconset · dark | 系统自动切换，无需代码 |
| **iOS Xcode app icon (tinted mode)** | AppIcon.appiconset · tinted | iOS 18+ 用户启用 tinted 后系统自动应用 |
| **App Store 主图** | `icon-ios-01-minimal-1024__260824.png` | Apple 审核偏好 flat squircle + letterform（C07 §E.1）|
| **App Store 营销图** | `icon-ios-marketing-1024.png` 或 02 GRADIENT 1024 | 紫青品牌色，social 出海 |
| **Landing hero (iOS app 下载页)** | 02 GRADIENT 1024 | 跟 macOS Landing hero 视觉一致 |
| **Twitter profile (1:1)** | 02 GRADIENT 1024 | 参考 C11 |
| **Product Hunt 缩略 (240×240)** | 02 GRADIENT 1024 | 渐变在小尺寸仍可见 |
| **Press kit 下载** | 整套 24 PNG (root) | 提供 web 团队 / 媒体 |

---

## 10. 后续可优化项（非本轮范围）

- **真 iOS superellipse path**：当前用 `<rect rx="229.069">` 近似；Figma 后期可替换为多段 cubic Bezier 的真 continuous rounded rect（视觉差异 < 1px @ 1024）
- **1px 白色 6% 边缘高光**（可选）：D1 §3.1 已记，C10 未实现；Figma 后期可加
- **0.5px 暗色内描边**（可选）：增强 squircle 边界感
- **Notification 20pt icon**（iOS 18 通知中心）：当前 12 尺寸不含 20×20 / 40×40 @2x / 60×60 @3x，可加（Y 在 20×20 仍可识别）
- **Apple Watch icon**（如未来要支持 watchOS）：需要 1024 + 48 派生，本轮范围外
- **Alt Icon B**（如未来要做 alt icon）：需要完整独立 36 PNG 套，本轮不交付

---

**完成时间**：2026-08-24 02:25
**作者**：yinghua-design-system (worker agent)
**license**：映话内部使用
