# C1 redo — 4 张 hero 的位置分工

> 用户决策：4 张都保留。各自有独立用途。

| 版本 | 文件 | 位置 | 用途 | 状态 |
|---|---|---|---|---|
| v2 | `c01_redo_v2_component-heavy.jpg` | 官网主 hero / 落地页 | 告诉用户"映话由什么组成" | ✅ 可用（渐变太花，背景可再克制） |
| v3 | `c01_redo_v3_finalround-centered.jpg` | "看看它怎么工作" 段落 | 展示映话在真实 macOS 桌面跑起来的样子 | ⚠️ 待修（文字乱码，模型抄了 Final Round 文字） |
| v4 | `c01_redo_v4_rich-gradient.jpg` | 营销 hero / 社交分享卡 | 推特 banner、博客头图、Product Hunt 用图 | ⚠️ 待修（右侧组件是英文标签，需中文） |
| v5 | `c01_redo_v5_realistic-product.jpg` | 功能详解页 | 展示对话转录 + 知识库 + AI 建议怎么合在一起 | ⚠️ 待修（转录文字严重乱码 "蠢囊馁镜"） |

## 修复方向

修复 prompt 关键改动：
- ❌ 不许抄任何外部品牌名（Fathom / Final Round / Raycast / DockDoor）
- ❌ 不许出现英文产品文案（除非是 macOS 系统词如 AirDrop、Screen Sharing）
- ✅ 全部 UI 文字必须中文
- ✅ 中文必须使用真实词组，不是字符碎片
- ✅ 5 个标准组件名：录音状态 / 对话转录 / 知识库相关 / AI 建议 / 问映话
- ✅ 真实 macOS 元素：菜单栏（Apple logo + File Edit View...）、窗口三色按钮、Dock（含 映话 图标）
