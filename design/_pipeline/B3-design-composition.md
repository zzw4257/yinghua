# B3 · 设计稿编排工具

> 用途：定义映话 (Yìnghuà) 的设计稿怎么从"多模态生成的零散资产"拼装成"可看的设计稿"。

## 工具矩阵

| 工具 | 用途 | 强项 | 弱项 | 映话适配度 |
|---|---|---|---|---|
| Figma MCP | 高保真原型 / 矢量编辑 | 矢量 / 团队协作 / 标注 | 需要账号 | ⭐⭐⭐⭐ 有账号时首选 |
| 截图合成 (Preview / Photoshop) | 把多张资产叠成一张 | 快速 / 不需账号 | 不可改 / 不可动 | ⭐⭐⭐⭐ 兜底 |
| HTML prototype (visual-page skill) | 可点击原型 | 真交互 / 像素级 | 写代码 | ⭐⭐⭐⭐ 复杂场景 |
| Figma-Light（不用 Figma） | 简单展示 | 免费 | 功能弱 | ⭐⭐ |
| Apple Keynote / Figma Slides | 演示文稿 | 简单 | 不适合屏幕展示 | ⭐⭐ |

## 工作流

### 路线 A：有 Figma 账号

```
1. B1 生成的候选图导入 Figma 作为参考
2. 在 Figma 里重画（不要直接用生成图作为最终稿）
3. 用 Figma 的 component + variant 做组件库
4. design doc 引用 Figma 链接
```

### 路线 B：没 Figma 账号（默认）

```
1. B1 生成的候选图作为参考（候选 1-2 张）
2. 截图合成：用 macOS 预览 / Preview.app / Photoshop 把多张候选叠成 1 张"设计稿"（标注设计意图）
3. 写一份 design / exploration / Cxx / "design-rationale.md" 解释每张图代表什么
4. 用 visual-page skill 做关键屏幕的 HTML prototype（如果需要交互）
5. design doc 引用这些图 + 解释
```

### 路线 C：混合

```
营销 / 品牌类资产 → 路线 B（截图合成）
应用内屏幕 → 路线 A（Figma 重画）或 visual-page（HTML prototype）
动效研究 → 路线 B（视频截帧）
```

## 视觉参考（`design/_reference/commercial/`）

| 资产 | 来源 | 用途 |
|---|---|---|
| Fathom landing 截图 | fathom.ai | 暗色宇宙 + AI 聊天灵感 |
| Fathom copy corpus | fathom.ai | 文案语调参考 |
| Hedy landing 截图 | hedy.ai | 实时建议卡片灵感 |
| Final Round AI 截图 | finalroundai.com | 玻璃悬浮 + 草坪蓝天对比 |
| LockedIn 截图 | lockedinai.com | 功能矩阵参考 |
| Interview Coder 截图 | interviewcoder.co | 隐身 / 不可见设计参考 |
| 飞书会议官网 | feishu.cn | 国内会议软件调性 |
| 腾讯会议官网 | meeting.tencent.com | 国内会议软件调性 |

> 商业产品仅截不下载资产；视觉风格 / 文案可以截，设计稿要重画。

## 协作 / 评审

- 候选图生成 → 写"design rationale" → 用户挑 → 深挖
- 每轮结束记"我们学到了什么"（一段话）
- 跨轮收敛：design doc 里有"最终定调"章节

## 不在本规范内

- 多模态生图本身（见 B1）
- 视频（见 B2）
- 资产版本管理（见 B4）
- 资产-代码绑定（见 B6）
