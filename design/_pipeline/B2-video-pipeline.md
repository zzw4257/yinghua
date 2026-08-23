# B2 · 视频生产管线

> 用途：定义映话 (Yìnghuà) 的所有动态视觉资产（hero loop、动效研究、玻璃质感研究、隐身 demo）用什么模型、prompt 怎么写、怎么拿到能用的输出。

## 工具矩阵

| 工具 | 调用方式 | 强项 | 弱项 | 映话适配度 |
|---|---|---|---|---|
| MiniMax H3 (`matrix__submit_video_generation`) | `mcode-tools connector call` | 高质量 / 同步原生音轨 / 4-15s / 768P & 2K / t2v + i2v + 3 参考图 | 消耗账号 credits | ⭐⭐⭐⭐⭐ 默认主力 |
| MiniMax Hailuo-2.3 | 同上 | 便宜 / Token Plan 适用 / t2v + i2v / 6-10s | 无声 / 1080P 仅 6s | ⭐⭐⭐ 备选 |
| Omni Video Production (skill) | skill | 长视频 / 编辑能力 / 配音 | 中文 prompt 一般 | ⭐⭐⭐ |
| Muapi Director (skill) | skill | 多镜头编排 | prompt 学习成本高 | ⭐⭐⭐ |
| Video Shotcraft (skill) | skill | 镜头 + 声音设计 | prompt 学习成本高 | ⭐⭐⭐ |
| Remotion (本期作为编排工具) | npm | React-based motion graphics / 2.5D 运镜 | 需要前端环境 | ⭐⭐⭐⭐ 编排 / mock |
| video-creater / write-h3-prompts (skill) | skill | 写 H3 prompt | 仅 prompt 模板 | ⭐⭐⭐⭐ |

## 调用范式

### H3 视频（首选）

```bash
mcode-tools connector call connector__matrix__submit_video_generation --args '{
  "model": "MiniMax-H3",
  "prompt": "...",
  "duration": 8
}'
# → 返回 task_id
# → 轮询 matrix_query_video_generation 直到完成
# → 完成后拿 node_id → get_asset_url 拿 URL
```

### H3 关键参数

- `model`: "MiniMax-H3"（质量） / "MiniMax-Hailuo-2.3"（便宜）
- `duration`: 4-15s（H3）
- `resolution`: 768P / 2K（H3） / 768P / 1080P（Hailuo-2.3）
- `prompt`: text-to-video 描述
- `input_urls`（i2v）: 首帧图 + 末帧图（C 轮的静态候选图可作为 i2v 起点）
- `multimodal_references`（H3）: 最多 3 张参考图（风格 / 物体 / 人物）

## Prompt 模板

### 动效研究类

```
[Subject] slowly emerges from [dark background], with [motion quality].
[Cinematography description] (camera angle, lens, lighting).
Atmosphere: [aurora purple gradient, frosted glass surfaces, deep cosmic black].
Style: minimal macOS 26 UI motion study, high clarity, 60fps.
Duration: 5-8 seconds.
```

### 玻璃质感类

```
[Frosted glass panel] with .hudWindow material and subtle purple tint.
[Light source] from top-left, casting 1px highlight on edge.
Behind the panel, [subtle motion of UI elements].
Style: macOS 26 native, professional motion design, no marketing copy.
```

### 隐身 demo 类

```
Split-screen comparison:
Left side: screen share view of [meeting app] (Zoom/Feishu), no overlay visible.
Right side: user view of the same scene, with [floating glass overlay] containing
realtime transcript and Copilot suggestions.
Style: clean product demo, macOS 26 native, high clarity.
Duration: 8-10 seconds.
```

### Hero loop 类

```
Center of frame: [aurora purple orb / glass panel / city silhouette],
slowly [rotating / floating / breathing].
Background: deep cosmic black with subtle starfield.
Lighting: purple rim light from above.
Style: premium SaaS hero, macOS 26 native, 60fps, no logos.
Duration: 8-10 seconds, loopable.
```

## 失败兜底

| 失败 | 兜底 |
|---|---|
| H3 消耗 credits 太多 | 切 Hailuo-2.3（便宜） |
| 视频 1 次不达预期 | 调 prompt 重跑；保留上一版入 archive |
| 视频完全崩（人物变形 / 场景错乱） | 1) 切工具；2) 用 Remotion + 静态候选图做 motion graphic |
| 比例 / 时长不对 | 改参数重跑 |
| 没声音 | H3 默认有音轨；Hailuo-2.3 无声，用 `matrix__synthesize_speech` 补 |

## Remotion 作为编排工具

- 当多模态视频失败 / 不达预期时，Remotion 兜底
- 把 C 轮的 5 个静态候选图作为帧，做 motion graphic
- 优点：完全可控 / 像素级精度
- 缺点：开发成本

## 复用 / 模板

- 每个 C 轮的 5 个候选 video prompt 存 `design/_exploration/Cxx_*/video-prompts.md`
- 选中的 video prompt 升级为该 round master
- 跨 round：design doc 存 "final master video prompt"

## 资源配额

- C 轮每轮：3-5 个候选 × 5-10s = 15-50s 视频
- 总计（C1-C16 跑完）：约 5-15 分钟视频
- 预算：H3 credits 视账号额度；尽量用 i2v（便宜）+ 静态候选图

## 不在本规范内

- 静态图（见 B1）
- TTS / 配音（本期不需；H3 自带音轨）
- 写代码时怎么引用（见 B6）
