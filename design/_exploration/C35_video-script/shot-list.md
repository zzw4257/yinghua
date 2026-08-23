# 映话 Demo Video — Shot List（镜头列表 + 资产引用）

> **版本**：v1.0 · 2026-08-23
> **用途**：视频制作团队的具体镜头指示（Premiere / Final Cut / DaVinci Resolve 都能读）
> **格式**：表格 + 资产路径 + 制作方式
> **总镜头数**：7 主体镜头 + 1 水印轨 = 8 个可执行镜头
> **总时长**：30.0s

---

## 1. 镜头总览

| 镜头 # | 时间码 | 时长 | 类型 | 内容 | 复杂度 | P0 |
|--------|--------|------|------|------|--------|-----|
| 01 | 0:00.0 - 0:03.0 | 3.0s | 静态 + 缓推 | 暗色 aurora 桌面 + Dock + Y icon + 标题 | 低 | ✅ |
| 02 | 0:03.0 - 0:08.0 | 5.0s | 屏幕录制 | 4 人 Zoom grid + 映话控制面板 + REC 启动 | 中 | ✅ |
| 03 | 0:08.0 - 0:14.0 | 6.0s | 屏幕录制 + 微距 | 实时转录滚动 + speaker chips | 中 | ✅ |
| 04 | 0:14.0 - 0:22.0 | 8.0s | 屏幕录制 | review-mode + 4 段折叠展开 | 高 | ✅ |
| 05 | 0:22.0 - 0:27.0 | 5.0s | 屏幕录制 | macOS 设置 + 凭据 + 隐私 | 中 | ✅ |
| 06 | 0:27.0 - 0:30.0 | 3.0s | 静态 | 全黑 + 02 GRADIENT Y logo + CTA | 低 | ✅ |
| 07 | 0:00.0 - 0:30.0 | 30.0s | 独立水印轨 | 02 GRADIENT Y 60×60 右下角 40% opacity | 低 | ⚠️ P1 |
| 08 | 0:00.0 - 0:30.0 | 30.0s | 文字叠加轨 | 5 段屏幕文字（左下角 24pt 暖白）| 低 | ✅ |

---

## 2. 镜头详细规格

### 镜头 01 · 开场 · Aurora 桌面

| 项 | 规格 |
|----|------|
| **时间码** | 0:00.0 - 0:03.0（3.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | Figma 静态 4K PNG（1 张） + After Effects 缓推动效 |
| **运镜** | 0:00.0 - 0:02.0 静止远景 · 0:02.0 - 0:03.0 dolly in 8%（缓推）|
| **背景** | #0A0A0F solid + 5% 紫青 radial gradient（自制）|
| **菜单栏** | 左侧 `Yinghua` 14pt + `File Edit View Window Help` 12pt · 右侧 `21:42` 时钟 14pt |
| **Dock** | 12 项（C15 §6.2 顺序）：Finder / Launchpad / Safari / Messages / Mail / Maps / Photos / FaceTime / Calendar / Notes / Reminders / **Yinghua** |
| **Y icon** | C10 `icon-01-minimal-256__260823.png` · Dock 第 12 位 · 实际显示 80×80px |
| **中央大字** | "映话" 80pt 暖白 #F4F1EC · fade-in 600ms（0:00.0-0:00.6）|
| **副标题** | "为面试而生的 macOS 智能助手" 32pt 次白 #B57BFF-50% · delay 400ms fade-in 600ms（0:00.4-0:01.0）|
| **字体** | Noto Serif SC 600（中文，design-doc §2.2）|
| **资产引用** | `design/_exploration/C10_vector-icon/icon-01-minimal-256__260823.png`<br>`design/design-tokens.json` color.brand.* |
| **状态** | 待制作（P0 静态资产 Figma 制作）|

---

### 镜头 02 · 第 1 段 · 系统级录制

| 项 | 规格 |
|----|------|
| **时间码** | 0:03.0 - 0:08.0（5.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | 屏幕录制（SwiftUI prototype 录屏） + After Effects 文字叠加 |
| **运镜** | 屏幕录制全程，无推拉 |
| **画面** | 上 70%：Zoom meeting 4 人 grid（mock 视频 tile）<br>右下 30%：映话控制面板浮窗（半透明玻璃）|
| **Zoom grid 4 tile** | 面试官 M（紫头像） / 面试官 W（青头像） / 我（暖白头像） / 张同学（粉头像）|
| **映话控制面板** | 顶部"● 录制中  02:34"（REC 红点 #FF3B30 + 计时器）<br>中部 3 transport（暂停/停止/静音）<br>底部 2 secondary（设置/关闭）|
| **REC 启动动效** | 0:05.5 点击 REC → 0:05.6 红点 pulse（scale 1.0→1.15→1.0，0.8s）|
| **计时器** | 0:06.0 起从 02:34 开始滚动 |
| **文字叠加** | 左下角 24pt 暖白 "系统级录制"（fade-in 400ms @ 0:04.0）|
| **字体** | Inter Display 600（英文/数字）|
| **资产引用** | `design/_exploration/C15_dark-shippable/design/01-meeting/product-meeting-in-progress__260824.jpg`<br>`code/Yinghua/`（SwiftUI BUILD SUCCEEDED，可录屏）|
| **状态** | 待制作（P0 屏幕录制）|

---

### 镜头 03 · 第 2 段 · 实时转录

| 项 | 规格 |
|----|------|
| **时间码** | 0:08.0 - 0:14.0（6.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | 屏幕录制（SwiftUI prototype 录屏） + After Effects 文字叠加 + 微距缓推 |
| **运镜** | 0:08.0 - 0:11.0 屏幕录制 · 0:11.0 - 0:14.0 dolly in 5% 缓推到当前说话人头像 |
| **画面** | 单窗口 transcript（占满屏幕）：7 行滚动（仅前 4 行进入画面）|
| **顶部 status** | "实时转录  ● 录制中  02:39" + 静音按钮 + 停止按钮 |
| **speaker chips** | 紫 #B57BFF（M）/ 青 #2DD4BF（W）/ 暖白 #F4F1EC（我）/ 粉 #E63FB8（Z）|
| **transcript 文本** | 见 demo-30s-script.md §2.2（7 行 mock 面试内容）|
| **行 fade-in 节奏** | 0:08.5 / 0:10.0 / 0:12.0 / 0:13.0 各 fade-in 1 行（200ms cubic-bezier(0.16, 1, 0.3, 1)）|
| **文字叠加** | 左下角 24pt 暖白 "实时转录 · 自动分说话人"（fade-in 400ms @ 0:09.0）|
| **资产引用** | `design/_exploration/C15_dark-shippable/design/03-transcript/product-transcript-focus__260824.jpg` |
| **状态** | 待制作（P0 屏幕录制）|

---

### 镜头 04 · 第 3 段 · AI 总结（核心段）

| 项 | 规格 |
|----|------|
| **时间码** | 0:14.0 - 0:22.0（8.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | 屏幕录制（SwiftUI prototype 录屏） + After Effects 文字叠加 + 微距缓推 + spring 动效 |
| **运镜** | 0:14.0 - 0:18.0 屏幕录制 · 0:18.0 - 0:22.0 dolly in 5% 缓推到 4 段区域 |
| **画面** | 左 file card（30%宽） + 右 AI 总结 4 折叠段（70%宽）|
| **file card** | 文件名 `张同学_终面.m4a` · 时长 `48:05` · 日期 `2026-08-23`<br>3 按钮：▶ 播放 / ↗ 分享 / ⤓ 导出 |
| **4 折叠段图标** | 关键瞬间 [紫 #B57BFF] / 达成的决定 [青 #2DD4BF] / 待办 [粉 #E63FB8] / 遗留问题 [暖白 #F4F1EC] |
| **4 段内容** | 见 demo-30s-script.md §2.4（mock 面试数据）|
| **4 段展开时序** | 0:15.5 / 0:17.0 / 0:19.0 / 0:20.5（spring 220ms cubic-bezier(0.16, 1, 0.3, 1)）|
| **文字叠加** | 左下角 24pt 暖白 "AI 总结 · 48 分钟 5 秒"（fade-in 400ms @ 0:15.0）|
| **资产引用** | `design/_exploration/C15_dark-shippable/design/04-review/product-review-mode__260824.jpg` |
| **状态** | 待制作（P0 屏幕录制 + 4 段 spring 动效）|

---

### 镜头 05 · 第 4 段 · 隐私强调

| 项 | 规格 |
|----|------|
| **时间码** | 0:22.0 - 0:27.0（5.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | 屏幕录制（macOS 系统设置 + mock 映话 tab） + After Effects 文字叠加 + 微距缓推 |
| **运镜** | 0:22.0 - 0:25.0 屏幕录制 · 0:25.0 - 0:27.0 dolly in 3% 缓推到 API key 输入框 |
| **画面** | macOS 系统设置窗口：左边栏"映话"高亮 + 主区域 6 tab 顶部（通用/录音/转录/AI/凭据/隐私/关于）|
| **Tab 内容** | 0:22.5 切到"凭据"标签 → 显示 2 个 API key 字段（masked）<br>0:25.5 切到"隐私"标签 → 显示 4 条 checkbox |
| **API key 字段** | OpenAI: `sk-●●●●●●●●●●●●●●●●●`<br>Anthropic: `sk-ant-●●●●●●●●●●●●`<br>下方小字: "[已加密 · 存储于 macOS Keychain]" |
| **隐私 4 条** | ☑ 100% 本地处理（系统音频 + 麦克风）<br>☑ 零上传（音频文件永不离开 Mac）<br>☑ BYOK 模式（API key 本机加密）<br>☑ 转录本地缓存 30 天后自动清除 |
| **文字叠加** | 左下角 24pt 暖白 "本地优先 · BYOK"（fade-in 400ms @ 0:23.0）<br>0:25.5 切到 "100% 本地 · 零上传 · 你的数据你的 Mac"（fade-in 400ms）|
| **资产引用** | macOS 系统设置窗口 mock（自制 Figma 资产）|
| **状态** | 待制作（P0 屏幕录制）|

---

### 镜头 06 · 结尾 · CTA

| 项 | 规格 |
|----|------|
| **时间码** | 0:27.0 - 0:30.0（3.0s）|
| **画幅** | 16:9 · 1920×1080（4K 母版 3840×2160）|
| **帧率** | 30fps |
| **制作方式** | After Effects 合成（全黑 + Y logo 缩放）|
| **运镜** | 静止全程 |
| **背景** | 0:27.0 - 0:30.0 全黑 #0A0A0F |
| **Dock Y icon** | 0:27.5 在 Dock 位置跳一下（pulse scale 1.0→1.15→1.0，0.4s）<br>（可省略，Y icon 仅作开场呼应）|
| **Y logo** | 0:28.0 02 GRADIENT Y logo 1024 居中（实际显示 240×240px）<br>fade-in 800ms + scale 0.92→1.0（spring cubic-bezier(0.16, 1, 0.3, 1)）|
| **CTA 文字** | "映话 · 免费下载 ↗" 64pt 暖白 #F4F1EC（fade-in 600ms @ 0:28.0）<br>"yinghua.zzw4257.cn" 32pt 次白（fade-in 400ms @ 0:28.8）|
| **字体** | Noto Serif SC 600（中文 "映话"） · Inter Display 600（"yinghua.zzw4257.cn"）|
| **↗ 符号** | U+2197 NORTH EAST ARROW · 用 Inter Display 默认 glyph |
| **资产引用** | `design/_exploration/C10_vector-icon/icon-02-gradient-1024__260823.png`（缩到 240×240px 显示） |
| **状态** | 待制作（P0 静态合成）|

---

### 镜头 07 · 全程 Y Watermark

| 项 | 规格 |
|----|------|
| **时间码** | 0:00.0 - 0:30.0（30.0s 独立轨）|
| **画幅** | 60×60px（4K 母版 120×120px）|
| **帧率** | 30fps（静态）|
| **位置** | 右下角 · 距右 32px / 距下 32px（4K 距右/下 64px）|
| **opacity** | 40% |
| **资产** | `design/_exploration/C10_vector-icon/icon-02-gradient-64__260823.png` |
| **动效** | 无（纯静态）|
| **优先级** | P1（建议保留作为品牌签名，但非 blocking）|
| **状态** | 可省略（**待定**）|

---

### 镜头 08 · 全程文字叠加轨

| 段 | 时间码 | 文字 | 字体 / 字号 / 颜色 | 动效 |
|----|--------|------|-------------------|------|
| 开场 | 0:00.0 - 0:03.0 | "映话" + "为面试而生的 macOS 智能助手" | Noto Serif SC 600 · 80pt + 32pt · #F4F1EC + #B57BFF-50% | 中央 · fade-in 600ms |
| 第 1 段 | 0:04.0 - 0:08.0 | "系统级录制" | Inter Display 600 · 24pt · #F4F1EC | 左下 · fade-in 400ms |
| 第 2 段 | 0:09.0 - 0:14.0 | "实时转录 · 自动分说话人" | Inter Display 600 · 24pt · #F4F1EC | 左下 · fade-in 400ms |
| 第 3 段 | 0:15.0 - 0:22.0 | "AI 总结 · 48 分钟 5 秒" | Inter Display 600 · 24pt · #F4F1EC | 左下 · fade-in 400ms |
| 第 4 段 | 0:23.0 - 0:25.5 | "本地优先 · BYOK" | Inter Display 600 · 24pt · #F4F1EC | 左下 · fade-in 400ms |
| 第 4 段 | 0:25.5 - 0:27.0 | "100% 本地 · 零上传 · 你的数据你的 Mac" | Noto Serif SC 600 · 24pt · #F4F1EC | 左下 · fade-in 400ms |
| 结尾 | 0:28.0 - 0:30.0 | "映话 · 免费下载 ↗" + "yinghua.zzw4257.cn" | Noto Serif SC 600 + Inter Display 600 · 64pt + 32pt · #F4F1EC + 次白 | 中央 · fade-in 600/400ms |

**文字轨总字数**：79 字 + 11 字符（远低于 Apple 标准的 100 字 / 30s）|

---

## 3. 资产总览（按来源分类）

### 3.1 已有资产（直接引用）

| 资产 | 路径 | 用途 |
|------|------|------|
| Y icon 16px | `_exploration/C10_vector-icon/icon-01-minimal-16__260823.png` | （备用）Dock 缩略 |
| Y icon 32px | `_exploration/C10_vector-icon/icon-01-minimal-32__260823.png` | （备用）|
| Y icon 64px | `_exploration/C10_vector-icon/icon-01-minimal-64__260823.png` | 镜头 07 水印 |
| Y icon 128px | `_exploration/C10_vector-icon/icon-01-minimal-128__260823.png` | （备用）|
| Y icon 256px | `_exploration/C10_vector-icon/icon-01-minimal-256__260823.png` | 镜头 01 Dock |
| Y icon 1024px | `_exploration/C10_vector-icon/icon-01-minimal-1024__260823.png` | （备用）|
| Y logo 64px gradient | `_exploration/C10_vector-icon/icon-02-gradient-64__260823.png` | （备用）|
| Y logo 256px gradient | `_exploration/C10_vector-icon/icon-02-gradient-256__260823.png` | （备用）|
| Y logo 1024px gradient | `_exploration/C10_vector-icon/icon-02-gradient-1024__260823.png` | **镜头 06 CTA** |
| 01 meeting 静态 | `_exploration/C15_dark-shippable/design/01-meeting/product-meeting-in-progress__260824.jpg` | 镜头 02 复刻参考 |
| 02 empty 静态 | `_exploration/C15_dark-shippable/design/02-empty/product-empty-state__260824.jpg` | （未使用）|
| 03 transcript 静态 | `_exploration/C15_dark-shippable/design/03-transcript/product-transcript-focus__260824.jpg` | **镜头 03 复刻参考** |
| 04 review 静态 | `_exploration/C15_dark-shippable/design/04-review/product-review-mode__260824.jpg` | **镜头 04 复刻参考** |
| 05 onboarding 静态 | `_exploration/C15_dark-shippable/design/05-onboarding/product-onboarding__260824.png` | （未使用）|
| 设计 token | `design/design-tokens.json` | 配色 / 字号 / 字体引用 |
| 设计语言 | `design/design-doc.md` | 视觉规范 / 4 段图标配色 / 4 段内容 |

### 3.2 待制作资产（视频团队 P0 制作）

| # | 资产 | 制作方式 | 工具 | 时长 | 复杂度 |
|---|------|----------|------|------|--------|
| A1 | 暗色 aurora 桌面（4K 静态）| Figma 制作 3840×2160 PNG（5% 紫青 radial gradient + Dock 12 项）| Figma / Sketch | — | 低 |
| A2 | Zoom 4 人 grid mock（视频）| Final Cut 制作 4 个 ambient 视频 tile 循环（4 段不同 audio waveform 微动）| Final Cut Pro | 5s | 中 |
| A3 | 映话控制面板录屏（视频）| SwiftUI 启动 `code/Yinghua/`（C13 BUILD SUCCEEDED）实际录屏 | QuickTime | 5s | 中 |
| A4 | transcript 录屏（视频）| SwiftUI 录屏（7 行 mock 文本滚动）| QuickTime | 6s | 中 |
| A5 | review-mode 录屏（视频）| SwiftUI 录屏（4 段 spring 展开）| QuickTime | 8s | 高 |
| A6 | macOS 设置窗口录屏（视频）| macOS 系统设置录屏 + mock 映话 tab（凭据 / 隐私）| QuickTime | 5s | 中 |
| A7 | 30s 完整合成（视频）| After Effects 合成 8 镜头 + 文字 + 水印 + 音乐 | After Effects | 30s | 高 |
| A8 | ambient pad 音乐（30s）| royalty-free 库下载 | Epidemic Sound / Artlist | 30s | 低 |
| A9 | UI 真实声包 | 系统自带录：启动 / 点击 / 弹窗 / bounce / 录音启动 | QuickTime | — | 低 |
| A10 | 中文版配音（30s）| 录音棚录制（见 voiceover-script.md §5）| Pro Tools | 30s | 中 |
| A11 | 英文版配音（30s）| 录音棚录制 | Pro Tools | 30s | 中 |
| A12 | 5s teaser 中文版（视频）| After Effects 合成（暗场 + 逐字 + logo）| After Effects | 5s | 中 |
| A13 | 5s teaser 英文版（视频）| After Effects 合成 | After Effects | 5s | 中 |
| A14 | heartbeat 音效 | royalty-free 库下载 | Epidemic Sound | 0.4s | 低 |
| A15 | resolve chord 音效 | royalty-free 库下载 | Epidemic Sound | 1.5s | 低 |

### 3.3 资产制作顺序建议

```
第 1 周（核心资产）:
  A1 → A3 → A4 → A5 → A6 → A7 → A8 → A10 → A11

第 2 周（teaser 变体）:
  A12 → A13 → A14 → A15

第 3 周（QA + 母版）:
  全部合入 + Figma 后期精修 + 4K 母版导出
```

---

## 4. 时间轴速查表

| 时间 | 镜头 | 关键事件 | 真实声 | 音乐 |
|------|------|---------|--------|------|
| 0:00.0 | 01 | cut to 暗色 aurora 桌面 | — | ambient pad 起 |
| 0:00.0 | 01 | "映话" fade-in | — | — |
| 0:00.4 | 01 | "为面试而生的…" fade-in | — | — |
| 0:01.0 | 01 | macOS 启动"咚" | 启动"咚" | — |
| 0:02.0 | 01 | dolly in 8% | — | — |
| 0:03.0 | 01→02 | cut to Zoom 屏 | — | — |
| 0:04.0 | 02 | "系统级录制" fade-in | — | — |
| 0:05.0 | 02 | 鼠标移到 REC 按钮 | — | — |
| 0:05.5 | 02 | 点击 REC | 录音启动"嘟" | bass drop |
| 0:05.6 | 02 | REC 红点 pulse | — | — |
| 0:06.0 | 02 | 计时器 02:34 开始滚动 | 静音会议人声起 | — |
| 0:08.0 | 02→03 | cut to transcript 屏 | — | typing 节奏叠加 |
| 0:08.5 | 03 | 第 1 行 fade-in | — | — |
| 0:09.0 | 03 | "实时转录 · 自动分说话人" fade-in | — | — |
| 0:10.0 | 03 | 第 2 行 fade-in（speaker M）| — | — |
| 0:11.0 | 03 | dolly in 5% 到头像 | — | — |
| 0:12.0 | 03 | 第 3 行 fade-in（speaker W）| — | — |
| 0:13.0 | 03 | 第 4 行 fade-in（speaker M）| — | — |
| 0:14.0 | 03→04 | cut to review-mode 屏 | — | — |
| 0:14.5 | 04 | macOS 文件打开"哒" | 文件打开声 | — |
| 0:15.0 | 04 | "AI 总结 · 48 分钟 5 秒" fade-in | — | — |
| 0:15.5 | 04 | 第 1 段（关键瞬间）展开 | click | — |
| 0:17.0 | 04 | 第 2 段（达成的决定）展开 | click | — |
| 0:18.0 | 04 | dolly in 5% 到 4 段区域 | — | — |
| 0:19.0 | 04 | 第 3 段（待办）展开 | click | — |
| 0:20.5 | 04 | 第 4 段（遗留问题）展开 | click | — |
| 0:22.0 | 04→05 | cut to 设置屏 | — | tone shift（降半音）|
| 0:22.5 | 05 | 切"凭据"标签 | tab 切换"哒" | — |
| 0:23.0 | 05 | "本地优先 · BYOK" fade-in | — | — |
| 0:24.0 | 05 | API key 字段显示（masked）| — | — |
| 0:24.5 | 05 | "Keychain 加密"小字显示 | — | — |
| 0:25.0 | 05 | dolly in 3% 到 API key 框 | — | — |
| 0:25.5 | 05 | 切"隐私"标签 | tab 切换"哒" | — |
| 0:25.5 | 05 | "100% 本地 · 零上传 · 你的数据你的 Mac" fade-in | — | — |
| 0:27.0 | 05→06 | cut to 全黑 | — | — |
| 0:27.5 | 06 | Dock Y icon 跳一下 | bounce "叮" | — |
| 0:28.0 | 06 | Y logo fade-in 800ms | — | — |
| 0:28.0 | 06 | "映话 · 免费下载 ↗" fade-in | — | — |
| 0:28.5 | 06 | — | — | resolve chord |
| 0:28.8 | 06 | "yinghua.zzw4257.cn" fade-in | — | — |
| 0:30.0 | 06 | cut black · fade out | — | fade out |

---

## 5. 验收 checklist（shot list 层面）

- [ ] 7 主体镜头 + 1 水印 + 1 文字轨 = 9 可执行轨
- [ ] 全部时间码精确到 0.1s
- [ ] 全部资产引用可追溯到 C10 / C15 / design-doc / design-tokens
- [ ] 文字叠加位置一致（左下角 24pt 暖白）
- [ ] 字体一致（Noto Serif SC 600 / Inter Display 600）
- [ ] 品牌色一致（紫 #B57BFF + 青 #2DD4BF + 暖白 #F4F1EC + 近黑 #0A0A0F + 录制红 #FF3B30）
- [ ] 真实声位置明确（点击 / 弹窗 / bounce / tab 切换 / 文件打开 / 录音启动）
- [ ] 音乐节拍位置明确（ambient pad / bass drop / typing / click / tone shift / resolve chord）
- [ ] 4 段 AI 总结展开顺序正确
- [ ] 隐私 4 条 checkbox 顺序正确
- [ ] 结尾 CTA 文字正确
- [ ] 无任何"赋能/智能/AI 驱动"等营销词
- [ ] 无 pie / donut / gauge / radar / Bento
- [ ] 4K 母版 + 1080p 交付版双输出
- [ ] 母版 / 交付版 / 音乐轨 / 配音轨 4 个独立文件
