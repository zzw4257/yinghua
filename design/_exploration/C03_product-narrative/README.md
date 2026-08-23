# 映话 Brand Assets V2 — 产品叙事套件（C03）

> C03 是对 C02 产品套件的彻底重构：从"塞组件"改为"讲叙事"。5 张产品图构成 **"用户使用映话的一天"** 完整故事线，加上 1 张 App icon V2 优化。

---

## 核心改进（针对 C02 反馈）

用户反馈："产品套件稍微虚了一点，组件不应该硬挤在一起，转录应该独立成屏，需要层次感。"

**C03 的三个核心原则**（已写入 `_design-system-prompt.md` 1.0 节）：

1. **4 层视觉层次强制**：L1 桌面 → L2 上下文（虚化）→ L3 映话主控（清晰）→ L4 浮层（半透明）
2. **主窗口只做一件事**：录音 / 转录 / 总结 / 知识库 各自独立，不在一个窗口里塞 5 个组件
3. **浮层是有理由才出现**：转录屏覆盖在会议视频上方，因为用户需要边开会边看

---

## 套件结构

```
C03_product-narrative/
├── README.md                              # 本文件
├── 01-empty-state/                         # 场景 1：待机
│   └── product-empty-state__260822.jpg
├── 02-meeting-in-progress/                 # 场景 2：会议中（4 层）
│   └── product-meeting-in-progress__260822.jpg
├── 03-transcript-focus/                    # 场景 3：专注转录
│   └── product-transcript-focus__260822.jpg
├── 04-review-mode/                         # 场景 4：复盘
│   └── product-review-mode__260822.jpg
├── 05-onboarding/                          # 场景 5：首次启动
│   └── product-onboarding-welcome__260822.jpg
```

加上对 C02 品牌套件的 V2 更新：

```
C02_brand-assets/03-brand/
├── brand-app-icon-showcase__260822.jpg    # V1（参考用）
└── brand-app-icon-v2__260822.jpg          # V2 终版 ✅
```

---

## 5 个场景（用户使用映话的一天）

### 场景 1：待机 (`product-empty-state`)
- **使用时机**：刚打开映话，没有会议进行
- **形态**：左侧 4 个圆形 icon（录音 / 问映话 / 知识库 / 设置）+ 主区 2×2 大方块按钮（开始录音 / 向映话提问 / 浏览知识库 / 导入音频文件）+ 右侧最近录音列表
- **设计参考**：腾讯会议 / Zoom Workplace 的空状态
- **调性**：克制、入口明确、不堆组件

### 场景 2：会议中 (`product-meeting-in-progress`) ⭐ 核心
- **使用时机**：用户正在某个视频会议里，希望映话实时记录
- **4 层层次**：
  - L1：极光 + 星空桌面
  - L2：**虚化的 Zoom-style 4 个视频方块**（背景会议）
  - L3：**清晰玻璃的映话主控**（左下角，克制小窗口）— 录音红点 + 青色波形 + 停止按钮
  - L4：**半透明转录浮层**（右侧独立大卡）— speaker 圆点 + 8-10 条对话
- **关键细节**：右上角"静音指示"小徽章 — 暗示系统音频不会被录进来

### 场景 3：专注转录 (`product-transcript-focus`)
- **使用时机**：用户只想专心看转录，不要会议视频干扰
- **形态**：单一 800×600 居中大窗口，70%×80% 屏幕占比，半透明
- **内容**：顶部 header（波形 + 录音点 + 实时波形）+ 8-10 条 speaker 对话 + 右下角 stop 浮按钮
- **调性**：meditative、专注、零干扰

### 场景 4：复盘 (`product-review-mode`) ⭐ 关键创新
- **使用时机**：会后用户写复盘笔记，需要交叉参考
- **4 层层次**：
  - L1：极光桌面
  - L2：**Notion-like 文档**（左半边，复盘笔记）
  - L3：**Yinghua AI 总结面板**（中间垂直玻璃卡）— 4 个 collapsible sections
    - Decisions Made（展开）
    - Action Items（折叠，2 个 checkbox）
    - Open Questions（折叠）
    - Key Quotes（折叠）
  - L4：**参考文件 mini 面板**（右下角，PDF 文件卡）
- **创新点**：**可折叠/展开 sections 展示动态感** + **标志性小文件暗示"在 macOS 工作"**

### 场景 5：首次启动 (`product-onboarding-welcome`)
- **使用时机**：用户第一次安装映话
- **形态**：居中 800×600 极简窗口，大量负空间
- **内容**：中央品牌 mark（对话波形）+ tagline placeholder + 单一 CTA 按钮（"开始第一次录音"）+ 右下角 keyboard shortcut hint 卡
- **调性**：meditative、premium、quiet welcome

---

## 与 C02 套件的对比

| 维度 | C02（V1） | C03（V2） |
|---|---|---|
| 布局哲学 | 塞组件 | 主窗口只做一件事 |
| 信息密度 | 高（5 个组件同窗） | 中（1-2 个核心 + 浮层） |
| 层次感 | 弱（基本是 2 层） | 强（4 层强制） |
| 转录屏 | 与 AI 建议挤一起 | 独立成屏 |
| 复盘模式 | 静态 | 4 个 collapsible sections |
| 真实 macOS 感 | 一般 | 强（参考腾讯会议空状态） |
| 调性匹配 | 90% | 95%（与 marketing hero 同源） |

---

## App icon V2 vs V1

| 维度 | V1 | V2 |
|---|---|---|
| 中央图形 | 两个散乱 speech bubble | 两个**对称镜像** speech bubble（更"对话"概念） |
| 渐变控制 | 偏均匀 | 加 radial highlight 增加深度感 |
| 背景 | 纯黑 | 纯黑（✅ 无星空） |
| 图形比例 | 偏大 | ~60%（偏小，可微调） |
| Dock 上下文 | 3 尺寸展示 | 64×64 单尺寸展示（更克制） |

**V2 终版**。V1 保留为参考对照。

---

## 已知 V1 接受 / V2 修复

1. **生图模型中文乱码**（"Eisl first recording" 等错别字）— 必须 Figma 后期替换为正确中文
2. **桌面壁纸星空元素**（部分图）— V2 修复 prompt 强化"NO stars NO galaxy"，但部分图仍出现，已在 02 修复
3. **App icon V2 中央图形偏小**— V3 可加大到 70-75% icon 内部
4. **人物头像位置**：02 视频方块里模型画了模糊真实人脸，与 prompt "abstract blurred silhouettes" 略有偏差，但效果可以接受（看起来就是 Zoom 视频）

---

## 下一轮可探索方向（C04+）

1. **产品套件 V3**：把 02 视频方块换为更抽象的几何块（不画人脸），星空底彻底去掉
2. **Twitter 3:1 banner**：用 Figma 裁切 marketing-landing-hero 制作（生图后端不支持 3:1）
3. **Icon V3**：加大中央图形 + 尝试 3-4 个不同抽象路径（对话流 / 声音的"映" / 镜像 / 波形与文字组合）
4. **Onboarding V2**：3 屏流（欢迎 → 第一次录音引导 → 第一次看总结）
5. **深色 vs 浅色**：现在全是深色，可探索 macOS 浅色模式下的视觉
6. **macOS App 图标上下文展示**：在 Finder / Launchpad / Mail / Spotlight 多种上下文展示 app icon

---

## 文件清单

```
C03_product-narrative/
├── 01-empty-state/product-empty-state__260822.jpg           (1.97 MB)
├── 02-meeting-in-progress/product-meeting-in-progress__260822.jpg  (1.91 MB) ⭐
├── 03-transcript-focus/product-transcript-focus__260822.jpg (1.87 MB)
├── 04-review-mode/product-review-mode__260822.jpg           (1.86 MB) ⭐
└── 05-onboarding/product-onboarding-welcome__260822.jpg     (1.85 MB)

C02_brand-assets/03-brand/brand-app-icon-v2__260822.jpg    (1.75 MB) ⭐
```
