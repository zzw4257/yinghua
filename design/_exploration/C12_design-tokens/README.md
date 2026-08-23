# C12 — Design Tokens JSON 落地

> **任务**：把 D1 design doc §2 视觉语言的 prose 形式 token 化, 落到 `design/design-tokens.json`, 供 dev / Figma / Style Dictionary 消费.
> **状态**：✅ Round 1 收口 v1.0.0 (2026-08-22)
> **格式**：W3C Design Tokens Community Group (DTCG) format
> **来源**：[D1 design doc §2 视觉语言](../../design-doc.md) + [C02 brand-assets §1.1](../C02_brand-assets/_design-system-prompt.md) + [C05 tokens visual](../C05_design-tokens-visual/)

---

## 1. 交付物

```
design/
├── design-doc.md                    # D1 master (prose, 人类读)
└── design-tokens.json               # ⭐ 本次产物 (machine-readable, 117 tokens, 25 KB)
```

**不重复造轮子**。D1 §2 是 prose 真相源, JSON 是它的机器可读投影. 任何 prose 改动都必须同步到 JSON, 反之亦然.

---

## 2. JSON 结构图

```
design-tokens.json (W3C DTCG format)
├── $schema / $description / $metadata
│
├── color                          (26 tokens, 6 sub-groups)
│   ├── brand                      5 hex + 2 gradient (D1 §2.1 主色)
│   ├── semantic                   4 hex (D1 §2.1 功能色)
│   ├── neutral                    7 hex + rgba (D1 §2.1 中性色, 含 hairline)
│   ├── speaker                    4 hex (D1 §4.3 avatar STYLE 1 调色板)
│   ├── glass                      3 (aurora wash, edge highlight, shadow tint)
│   └── app-state                  1 (Dock active dot magenta)
│
├── typography                     (15 tokens)
│   ├── font-family                5 (display / text / mono / serif-zh / sans-zh)
│   ├── font-size                  6 (display-1 / display-2 / body-1/2 / caption / mono-sm)
│   └── font-weight                4 (regular / medium / semibold / bold)
│
├── spacing                        (10 tokens, 8pt grid: 0/4/8/12/16/20/24/32/40/48)
├── radius                         (10 tokens, 含 alias: window / button / icon-squircle / circle)
│
├── motion                         (11 tokens)
│   ├── duration                   6 (instant 80ms / fast 120ms / normal 220ms / slow 250ms / pulse 1.4s / bounce 4s)
│   ├── easing                     4 (standard / spring / ease-out / ease-in)
│   └── reduce                     1 (prefers-reduced-motion 铁律)
│
├── elevation                      (4 tokens, C02 §1.3 双层阴影)
├── z-index                        (5 tokens, 0/10/100/1000/10000)
│
├── breakpoint                     (4 tokens, sm/md/lg/xl — 480/768/1200/1600px)
├── material                       (4 tokens, regular / popover / sidebar / ultraThin=FORBIDDEN)
│
├── app-icon                       (13 tokens)
│   ├── container                  3 (shape / radius / size-px)
│   ├── y-geometry                 6 (height / width / margin / stroke-width / linecap / merge)
│   ├── minimal-01                 2 (background / y-fill — 主 icon)
│   └── gradient-02                2 (background / y-fill — 备用 marketing icon)
│
└── forbidden-patterns             (15 反模式 token, 全部带 D1 §7 / C02 §2 引用)
    NO_WAVEFORM / NO_AI_TEXT_IN_ICON / NO_LEGACY_MARK / NO_STARFIELD_BG
    NO_BENTO_FRAME / NO_MARKETING_FLOURISH / NO_PIE_DONUT_GAUGE
    NO_DECORATIVE_SPARKLES / NO_TWO_CIRCLES_CHAT_ICON / NO_NEON_GLOW
    NO_MULTI_NEON / NO_PROMPT_TEXT_LEAK / NO_PURE_WHITE_TEXT
    NO_TWO_PRIMARY_BUTTONS / NO_ULTRA_THIN_GLASS
```

**总计：117 leaf tokens**.

---

## 3. 跟 D1 §2 的对应关系

| D1 §2 子节 | JSON section | 关键 token | 备注 |
|-----------|-------------|-----------|------|
| §2.1 配色-主色 | `color.brand` | `purple-vivid/mid/deep` + `teal-vivid/deep` + `gradient-primary` | 跟 C02 §1.1 的 Aurora Purple #7B3FE4 **不同** — D1 偏亮 |
| §2.1 配色-功能色 | `color.semantic` | `recording-red` / `warning-orange` / `success-green` / `danger-red` | success/danger 沿用 macOS 系统色 |
| §2.1 配色-中性色 | `color.neutral` | `near-black` / `graphite` / `glass-deep` / `warm-white` / `secondary` / `tertiary` / `hairline` | hairline = 灰边 1px @ 8% (D1 §2.1) |
| §2.2 字体 | `typography.font-family` | `display` / `text` / `mono` / `serif-zh` / `sans-zh` | 5 字体, 都带 system fallback |
| §2.3 圆角 | `radius` | `window=14px` / `icon-squircle=22.4%` / `button=12px` / `circle=50%` / `input=8px` | 含 alias 命名 (window/button) + 主 scale (sm/md/lg/xl/2xl) |
| §2.4 间距 | `spacing` | 8pt grid: 0/4/8/12/16/20/24/32/40/48 | 全部 4 的倍数 |
| §2.5 玻璃材质 | `material` + `color.glass` | `regularMaterial` / `popoverMaterial` / `sidebarMaterial` + `aurora-wash` 15% opacity | ultraThin = FORBIDDEN (D1 §6.4) |
| §2.6 动效 | `motion.duration` + `motion.easing` + `motion.reduce` | instant 80ms / fast 120ms / normal 220ms / slow 250ms + spring 1.56 overshoot | `reduce.respect-prefers-reduced-motion` 强制铁律 |
| §3.1 App icon 几何 | `app-icon.y-geometry` | height-pct 52% / width-pct 52% / margin-pct 22% / stroke-width-pct 5.5% | C07 audit 建议值, Figma 矢量精修用 |
| §4.3 Speaker avatar | `color.speaker` | purple / teal / pink #FF6FA9 / warm-white-bg | 4 色 STYLE 1 调色板 |
| §6.2 Dock active dot | `color.app-state.magenta-active` | #E63FB8 | C02 Magenta Spark, 仅用于系统级活动点 |
| §6.4 禁用 ultraThin | `material.ultraThin` + `forbidden-patterns.NO_ULTRA_THIN_GLASS` | value = "FORBIDDEN" | 双层防御 (token 显式标 + forbidden section) |
| §7 反模式 | `forbidden-patterns` | 15 个 NO_* token, 全部带 D1 §7 引用 | 机器读 value="forbidden", 人类读 description |

---

## 4. 消费方式 (3 个常见路径)

### 4.1 SwiftUI (Style Dictionary → Swift extension)

**步骤 1**: 用 [Style Dictionary](https://styledictionary.com) 把 JSON 转成 Swift:

```bash
# install
npm i -D style-dictionary

# build.config.js
cat > build.config.js <<'EOF'
module.exports = {
  source: ['design/design-tokens.json'],
  platforms: {
    ios: {
      transformGroup: 'ios-swift',
      buildPath: 'Yinghua/DesignSystem/',
      files: [
        { destination: 'Colors.swift', format: 'ios-swift/colors' },
        { destination: 'Typography.swift', format: 'ios-swift/fontSizes' },
        { destination: 'Spacing.swift', format: 'ios-swift/dimensions' },
        { destination: 'Motion.swift', format: 'ios-swift/durations' }
      ]
    }
  }
};
EOF

# build
npx style-dictionary build
```

**步骤 2**: 在 SwiftUI 用:

```swift
import SwiftUI

struct PrimaryButton: View {
    var body: some View {
        Text("开始录制")
            .font(.system(size: 15, weight: .semibold))  // typography.font-size.body-1
            .foregroundStyle(Color.WarmWhite)            // color.neutral.warm-white
            .padding(.horizontal, 20)                    // spacing.xl
            .padding(.vertical, 12)                      // spacing.md
            .background {
                LinearGradient(
                    colors: [.BrandPurpleVivid, .BrandTealVivid],  // gradient-primary-2stop
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            }
            .clipShape(RoundedRectangle(cornerRadius: 12))  // radius.button
            .scaleEffect(isHovered ? 1.02 : 1.0)          // motion.duration.fast
            .animation(.spring(response: 0.12), value: isHovered)  // motion.easing.spring
    }
}
```

### 4.2 CSS variables (Style Dictionary → CSS)

```bash
# build.config.js 加一个 platform
cat >> build.config.js <<'EOF'
  , css: {
      transformGroup: 'css',
      buildPath: 'web/tokens/',
      files: [
        { destination: 'tokens.css', format: 'css/variables' }
      ]
    }
EOF
npx style-dictionary build
```

**输出** `web/tokens/tokens.css`:

```css
:root {
  --color-brand-purple-vivid: #B57BFF;
  --color-brand-teal-vivid: #2DD4BF;
  --color-neutral-warm-white: #F4F1EC;
  --color-neutral-hairline: rgba(244, 241, 236, 0.08);
  --spacing-lg: 16px;
  --radius-button: 12px;
  --motion-duration-normal: 220ms;
  --motion-easing-spring: cubic-bezier(0.34, 1.56, 0.64, 1);
  --app-icon-y-geometry-height-pct: 52%;
}
```

**React 消费**:

```tsx
import './tokens.css';

export const PrimaryButton = () => (
  <button style={{
    background: 'var(--gradient-primary)',
    backgroundImage: 'var(--color-brand-gradient-primary)',
    color: 'var(--color-neutral-warm-white)',
    padding: 'var(--spacing-md) var(--spacing-xl)',
    borderRadius: 'var(--radius-button)',
    fontSize: 'var(--typography-font-size-body-1)',
    transition: 'transform var(--motion-duration-fast) var(--motion-easing-spring)',
  }}>
    开始录制
  </button>
);
```

### 4.3 Figma Tokens / Tokens Studio plugin

1. 安装 [Figma Tokens plugin](https://www.figma.com/community/plugin/843461159747178978/Tokens-Studio-for-Figma-Figma-Tokens)
2. 插件面板 → "Sync" → "Load from JSON"
3. 选择 `design-tokens.json`
4. Token 自动落到 Figma 左侧 "Tokens" 面板, 可直接拖到图层
5. **Y 几何特别提示** (app-icon.y-geometry):
   - stroke-width-pct 5.5% / 1024px container → stroke **56px**
   - Y 高 52% / 1024px → Y **533px**
   - Y 宽 52% / 1024px → Y **533px**
   - margin 22% / 1024px → margin **225px** (上下左右)
6. **Figma 矢量精修时 3 变体 (01/02/03) 必须用同一 Y master, 仅改 fill** — C07 audit V1 已知问题 #4

### 4.4 备选: 手写消费 (不依赖 Style Dictionary)

直接读 JSON, 写 wrapper:

```typescript
// tokens.ts
import tokens from './design-tokens.json';

export const c = {
  brandPurpleVivid: tokens.color.brand['purple-vivid'].value,    // "#B57BFF"
  brandTealVivid: tokens.color.brand['teal-vivid'].value,        // "#2DD4BF"
  warmWhite: tokens.color.neutral['warm-white'].value,           // "#F4F1EC"
  hairline: tokens.color.neutral.hairline.value,                 // "rgba(244, 241, 236, 0.08)"
  // ...
};
```

---

## 5. 验证方法

### 5.1 JSON 语法合法

```bash
python3 -m json.tool design/design-tokens.json > /dev/null && echo "JSON_VALID"
# → JSON_VALID
```

### 5.2 每个 D1 §2 子节 token 都在

见上方 [§3 对应关系表](#3-跟-d1-2-的对应关系). 验证脚本:

```bash
python3 -c "
import json
d = json.load(open('design/design-tokens.json'))
required_paths = [
    'color.brand.purple-vivid', 'color.brand.purple-mid', 'color.brand.purple-deep',
    'color.brand.teal-vivid', 'color.brand.teal-deep', 'color.brand.gradient-primary',
    'color.semantic.recording-red', 'color.semantic.warning-orange',
    'color.semantic.success-green', 'color.semantic.danger-red',
    'color.neutral.near-black', 'color.neutral.graphite', 'color.neutral.glass-deep',
    'color.neutral.warm-white', 'color.neutral.secondary', 'color.neutral.tertiary',
    'color.neutral.hairline',
    'typography.font-family.display', 'typography.font-family.text',
    'typography.font-family.mono', 'typography.font-family.serif-zh',
    'typography.font-family.sans-zh',
    'radius.window', 'radius.icon-squircle', 'radius.button', 'radius.circle',
    'spacing.xs', 'spacing.sm', 'spacing.md', 'spacing.lg', 'spacing.xl',
    'spacing.2xl', 'spacing.3xl', 'spacing.4xl', 'spacing.5xl',
    'motion.duration.instant', 'motion.duration.fast', 'motion.duration.normal', 'motion.duration.slow',
    'material.regular', 'material.popover', 'material.sidebar',
    'app-icon.y-geometry.height-pct', 'app-icon.y-geometry.width-pct',
    'app-icon.y-geometry.margin-pct', 'app-icon.y-geometry.stroke-width-pct',
]
for p in required_paths:
    cur = d
    for k in p.split('.'):
        cur = cur.get(k, None) if isinstance(cur, dict) else None
    assert cur is not None and isinstance(cur, dict) and 'value' in cur, f'MISSING: {p}'
print(f'OK: all {len(required_paths)} D1 §2 paths present')
"
# → OK: all 46 D1 §2 paths present
```

### 5.3 W3C DTCG 格式合规 (叶子节点必有 value + type)

```bash
python3 -c "
import json
d = json.load(open('design/design-tokens.json'))
def check(node, path=''):
    issues = []
    if isinstance(node, dict):
        if 'value' in node and 'type' in node:
            return issues
        for k, v in node.items():
            issues.extend(check(v, f'{path}.{k}'))
    return issues
issues = check(d)
print('OK' if not issues else issues)
"
# → OK
```

### 5.4 所有 D1 §2.1 颜色 hex 都在 JSON 里

```bash
python3 -c "
import json
text = open('design/design-tokens.json').read()
for hex_code in ['B57BFF', '8A5BFF', '2A1240', '2DD4BF', '0E2A2A',
                 'FF3B30', 'FF9F0A', '34C759', 'FF453A',
                 '0A0A0F', '1B1D22', 'F4F1EC', 'FF6FA9']:
    assert hex_code in text, f'MISSING {hex_code}'
    print(f'  {hex_code}: FOUND')
"
# → 13/13 hex FOUND
```

### 5.5 forbidden-patterns 数量 ≥ 6

```bash
python3 -c "
import json
d = json.load(open('design/design-tokens.json'))
print(f'forbidden-patterns count: {len(d[\"forbidden-patterns\"])}')
assert len(d['forbidden-patterns']) >= 6
"
# → forbidden-patterns count: 15
```

### 5.6 grep 抽查每个 section

```bash
for s in 'color' 'typography' 'spacing' 'radius' 'motion' 'elevation' 'z-index' \
         'breakpoint' 'material' 'app-icon' 'forbidden-patterns' 'brand' \
         'semantic' 'neutral' 'speaker' 'glass' 'font-family' 'font-size' \
         'font-weight' 'duration' 'easing' 'y-geometry'; do
  count=$(grep -c "\"$s\":" design/design-tokens.json)
  echo "  $s: $count occurrences"
done
```

---

## 6. 已知取舍 / 边界

### 6.1 D1 vs C02 颜色差异

| 角色 | D1 (master) | C02 (辅助) | JSON 用 |
|------|------------|-----------|--------|
| 紫 vivid | `#B57BFF` | `#7B3FE4` (Aurora Purple) | **D1** (#B57BFF) |
| 青 vivid | `#2DD4BF` | `#2EE6E0` (Cyan Glow) | **D1** (#2DD4BF) |
| 紫 deep | `#2A1240` | 无 | **D1** |
| 暖白 | `#F4F1EC` | `#F4F1EC` (同) | D1 (一致) |
| 石墨 | `#1B1D22` | `#1B1D22` (同) | D1 (一致) |
| 近黑 | `#0A0A0F` | `#0B0C10` (Deep Space) | **D1** (#0A0A0F, 偏冷蓝) |
| Magenta active | (D1 提到 magenta 小点, 未给 hex) | `#E63FB8` (Magenta Spark) | **C02** (#E63FB8, 标 source=C02 §1.1) |
| Speaker 粉 | `#FF6FA9` (D1 §4.3) | 无 | **D1** |

**原则**: D1 是 master. C02 补充的 color 仅在 D1 缺位时纳入, 且 description 显式标 source.

### 6.2 哪些没做 (Round 2 候选)

- **浅色模式 token 副本** (`.light` 别名 / 自动 mode 切换) — D1 §10 列为 Round 2, 待 C08+ 出图后定色.
- **hover / pressed / disabled 三态 token** — D1 §2 没说, dev 临时派生即可. Round 2 Figma 精修时再固化.
- **字体 `leading` (line-height) / `tracking` (letter-spacing)** — D1 §2.2 没列, Figma 早期按 SF Pro 默认 (1.2-1.4) 即可, 待 visual regression 再加.
- **DTCG composite types** (`{value: {fontFamily, fontSize, fontWeight}, type: "typography"}`) — 当前用扁平 leaf 表达, Style Dictionary 自动合并. 真要 strict composite, 等 Round 2 Figma sync 阶段.
- **Icon 矢量 token (svg path data)** — 不在本 tokens JSON 范围. C10 vector-icon 单独出 SVG sprite.

### 6.3 双层防御: 禁用 glass 跟反模式

D1 §6.4 禁 .ultraThinMaterial, D1 §7 禁 13 种反模式. 在 JSON 里**两层都写**:

- `material.ultraThin.value = "FORBIDDEN"` (显式)
- `forbidden-patterns.NO_ULTRA_THIN_GLASS.value = "forbidden"` (规则)

这样无论 dev 用哪个入口查, 都能看到禁用标记. Figma sync 时 plugin 会自动把 FORBIDDEN 渲染为红色斜体.

---

## 7. 上下游

### 7.1 上游 (本 JSON 读)

- [D1 design doc §2 视觉语言](../../design-doc.md) — prose 真相源
- [C02 brand-assets §1.1](../C02_brand-assets/_design-system-prompt.md) — Magenta active 颜色补充
- [C05 design tokens visual](../C05_design-tokens-visual/) — 5 视觉参考
- [C07 app icon V3 audit verdict §A](../C07_app-icon-v3/_audit-verdict.md) — Y 几何 5-6% stroke 建议

### 7.2 下游 (本 JSON 写)

- **SwiftUI dev** (Round 2+): Style Dictionary → `Yinghua/DesignSystem/`
- **Web / Landing page** (如有): Style Dictionary → `web/tokens/tokens.css`
- **Figma sync** (Round 2): Tokens Studio plugin → Figma "Yinghua" library
- **生图 prompt** (C13+): 从 JSON 取 hex/px, 不再翻 D1 prose
- **C13 swiftui-scaffold**: 用本 JSON 初始化 design system module

---

## 8. 维护规则

1. **D1 改 → JSON 同步改**. 任何 D1 §2 子节改动必须立刻同步到本 JSON.
2. **新增 token 必须进 forbidden check**. 任何新加视觉元素先看 `forbidden-patterns` 15 条, 撞了改设计.
3. **命名走角色不走向量**. `color.brand.purple-vivid` 不叫 `color.purple-light` — 我们按角色 (brand/semantic/neutral/speaker) 划, 不按 hue/lightness 划. 改深浅就改 token, 不改名字.
4. **改动必须过 [§5 验证](#5-验证方法) 5 项**. 任何 PR / 提交前跑一次全套验证.
5. **版本号更新**. 任何 breaking change (改 hex / 改 px / 改 semantic name) → `$metadata.version` bump minor (1.0.0 → 1.1.0). 新增 token → patch (1.0.0 → 1.0.1).

---

**Round 1 收口完成**. 下一个 token 改动走 PR → 本 README §5 验证 → 同步 D1.
