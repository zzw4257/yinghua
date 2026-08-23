# C1 — Hero / 品牌视觉：5 个候选

> 目的：探索"映话"的视觉调性。每张图代表一个**方向**（不是变体），让用户在 5 个方向里挑 1-2 个。

## Master prompt block（每张图共享）

```
Style: minimal dark cosmic UI, macOS 26 native, premium SaaS aesthetic.
Background: near-black #0A0A12 with subtle starfield noise.
Accent: aurora purple gradient from #7B3FE4 (deep) to #B57AFF (light),
used sparingly as a glowing element behind glass.
Material: frosted glass panels with NSVisualEffectView .hudWindow aesthetic,
subtle 8% purple tint, 1px purple edge highlight.
Typography: Inter Display Bold for display, Noto Serif SC for Chinese,
JetBrains Mono for data. No logos, no marketing copy, no watermarks.
Composition: 16:9 hero, centered subject with generous negative space.
```

## 5 个候选

### A. 纯黑宇宙 + 极光紫光球

**代表的方向**：极简 / 深空 / 紫光球作为隐喻（"对话能量 / 转录信号"）

```
[Master block]
Center of frame: a single aurora-purple glowing orb (diameter ~30% of frame
width) hovering in deep black space. The orb has soft volumetric edges,
slightly more intense at the center, fading to black at the rim. Behind the
orb, very subtle starfield noise (low contrast). In the foreground (lower
right), a frosted glass panel ~40% of frame width, slightly tilted, showing
a single line of Chinese caption text in Noto Serif SC: "映话". Below the
orb's glow, a very faint purple rim light on an otherwise invisible surface.
The whole composition feels quiet, cosmic, and slightly mysterious.
Negative space dominates; no other elements.
```

### B. 液态金属紫

**代表的方向**：流动 / 物质感 / 紫金属液体在反光面上

```
[Master block]
Center of frame: a mass of liquid mercury with aurora-purple tint, slowly
frozen mid-splash on a mirror-black surface. The liquid has strong
specular highlights and reflections of invisible purple light sources.
Around the liquid, faint micro-bubbles and droplets float in the dark.
The mirror surface reflects the liquid with high fidelity. In the upper
right, a thin frosted glass strip with one line of white Chinese text:
"映话". No other elements. The mood is "raw material / future tech /
premium craftsmanship".
```

### C. 极光紫光带横切

**代表的方向**：极简几何 / 光带作为"映射" / 干净

```
[Master block]
A single horizontal aurora-purple light band crosses the entire 16:9 frame
at vertical center, width ~6% of frame height, soft glow extending 3x its
thickness. The band has gradient from #7B3FE4 (left) to #B57AFF (right)
with subtle 3D depth. Above the band, a frosted glass rectangular panel
~50% of frame width, showing 3 lines of Chinese caption in Noto Serif SC
(representing a real-time transcript). Below the band, a subtle mirror
reflection of the glass panel, faded. The composition is symmetric and
calm. No other elements.
```

### D. 紫粒子漩涡

**代表的方向**：能量 / 数据流 / 紫粒子涌出又聚拢

```
[Master block]
Center of frame: a swirling vortex of aurora-purple particles, each particle
~2-4 pixels, forming a spiral that emerges from a single bright point at
the center and disperses outward. Density highest at center, falling off
toward the edges. Behind the vortex, a very subtle radial gradient from
deep purple (center) to pure black (edges). At the spiral's center point,
a tiny frosted glass orb containing the single Chinese character "映"
in Noto Serif SC, glowing softly. The motion implied is rotating
counter-clockwise. Composition is centered and symmetric. No other elements.
```

### E. 镜面城市 + 紫霓虹

**代表的方向**：用户 profile 里的"暗色城市 + 数字"调性 / 港式 / 上海 / 未来都市

```
[Master block]
Background: night skyline silhouette of a dense Asian city (Hong Kong /
Shanghai / Tokyo feel), seen from across a harbor. Buildings are pure
black against a deep purple night sky (#1A0F2E). On selected building
edges and windows, scattered aurora-purple neon highlights (#B57AFF)
suggest a city that breathes with the product's accent color. Foreground:
the dark water of the harbor, with subtle reflections of the city's
purple neon lights. In the lower center of frame, a thin frosted glass
panel showing a digital clock in JetBrains Mono: "00:01:23" (purple
digits, glowing). The mood is "your city, your interview, your time".
No other elements.
```

## 评估 checklist

（详见 `_pipeline/B5-asset-evaluation.md`）

- 调性匹配：主色在极光紫范围，底色近黑
- 玻璃质感清晰
- 中文 UI 文字渲染清晰（如果用的话）
- 极光渐变可见
- 整体偏暗
- 隐喻能解释映话的功能（"映射对话" / "实时转录"）
- 看起来像真的产品

## 不预设的

- 这 5 个候选**不是映话最终 hero**——是方向探索
- 用户挑 1-2 个后，下一轮 C2 会基于这 1-2 个细化
- 最终 hero 在 C17 收敛时定
