# B1 · 图片生产管线

> 用途：定义映话 (Yìnghuà) 的所有静态视觉资产（原型图、icon、营销插画）用什么模型、怎么批量、怎么保持风格一致、崩了怎么兜底。

## 工具矩阵（实测后填）

| 工具 | 调用方式 | 强项 | 弱项 | 映话适配度 |
|---|---|---|---|---|
| `connector__matrix__generate_image` (matrix) | `mcode-tools connector call` | 中文 UI 文字渲染 / 整体氛围 / 玻璃感 | 严格 prompt 复现 / 微调 | ⭐⭐⭐⭐⭐ 默认主力 |
| MiniMax H3 image（via h3-prompt-writing） | skill | 高质感插画 / 渐变 / 电影感 | 中文文字常崩 | ⭐⭐⭐⭐ 备选 |
| RightCode `rightcode-image-2` | skill | icon / 简单几何 / 强对比 | 不擅长氛围图 | ⭐⭐⭐ icon 专用 |
| Meijier `meijier-imagegen` | skill | 写实 / 产品图 | 调性控制弱 | ⭐⭐ |
| RightCodes `rightcodes-imagegen` | skill | 同上 | 同上 | ⭐⭐ |
| Flux Pro（via matrix 或其他） | TBD | 强 prompt 复现 | 中文 UI 不如 matrix | ⭐⭐⭐ |
| DALL-E 3 / 4（via matrix） | TBD | 文字渲染 | 调性偏主流 | ⭐⭐ |

> **真实能力测试**（首轮 C1 时执行）：
> 5 个测试 prompt × 5 个工具 = 25 张图，筛出"中文 UI 渲染最好"的工具作为默认。

## 调用范式

```bash
# 工具：matrix
mcode-tools connector call connector__matrix__generate_image --args '{
  "requests": [
    {
      "prompt": "...",
      "aspect_ratio": "16:9",
      "resolution": "2K",
      "output_file": "c01_hero_direction_01.png"
    }
  ]
}'
# → 返回 success_items[].node_id 和 file_name
# → 调 get_asset_url <node_id> 拿短时 URL
```

## 风格一致性

### 锚定手段

- **Master prompt block**（每轮 C 开头写一份，整个 round 共用）：
  ```
  style: "Minimal dark cosmic UI. Near-black background (#0A0A12) with subtle
  starfield noise. Aurora purple accent (#7B3FE4) gradient to light purple
  (#B57AFF). Frosted glass panels (NSVisualEffectView material .hudWindow
  with subtle 8% purple tint). Typography: Inter Display Bold for display,
  Noto Serif SC Bold for Chinese, JetBrains Mono for data. No logos. No
  marketing copy. High contrast, no gradients that wash out the glass."
  ```
- **每张图的 prompt** = master block + 单独描述
- **negative prompt**（如支持）："no text artifacts, no blurry faces, no watermarks, no logos, no bright neon green, no garish yellow"

### 复现（一致性）

- 同一 round 内：固定 master block
- 跨 round 收敛：每轮选中的方向，把它的 master block 升级为新一版
- 长期：design doc 里的 master block 写死为最终版

## 失败兜底

| 失败类型 | 兜底方案 |
|---|---|
| 中文 UI 文字崩 | 1) 改 prompt 强调 "no Chinese text on UI"；2) 后期 PS / 截图合成加中文 |
| 玻璃质感出不来 | 1) 改 prompt 强调 "frosted glass with .hudWindow material"；2) 改用 HTML + backdrop-filter 兜底 |
| 极光紫偏蓝/偏粉 | 1) 改 prompt 强调 hex #7B3FE4；2) 后期 Figma/截图调色 |
| 比例不对 | aspect_ratio 直接重设 |
| 内容不对 | 重写 prompt；保留上一版作为"废稿"入 archive |
| 整批失败 | 切工具 / 降级到截图合成 + 多模态描述 |

## 复用 / 模板

- 每个 C 轮的 5 个候选 prompt 写完后存 `design/_exploration/Cxx_*/prompts.md`（可复用 / 可对比）
- 选中的候选 prompt 升级为"该 round 的 master prompt"，下次再用到时直接继承
- 跨 round 收敛：design doc 里存"final master prompt"作为后续所有资产的锚

## 资源配额

- 5 个工具 × 5 个 prompt = 25 张图（实测）
- 每 C 轮：3-5 个候选 × 1-2 张 = 5-10 张
- 总计（C1-C16 跑完）：约 100-150 张图
- 视频不在这份规范内（见 B2）

## 不在本规范内

- 视频生成（见 B2）
- 文案 / 字体（见 B5 / D2 design token）
- 实际写代码时怎么引用（见 B6）
