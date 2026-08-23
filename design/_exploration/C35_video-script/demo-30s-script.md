# 映话 Demo Video — 30s Product Demo 完整脚本

> **版本**：v1.0 · 2026-08-23
> **目标**：Apple Keynote 风格 30s 产品 demo（克制 / 安静 / 真实使用场景）
> **受众**：视频制作团队（Premiere / Final Cut / DaVinci Resolve 都能读）
> **总时长**：30.0s 精确到帧 @ 30fps
> **画幅**：16:9 · 1920×1080（4K 母版 3840×2160，1080p 交付）
> **核心调性**：Apple Keynote · ambient 电子乐 · 真实用户场景 · 零堆词

---

## 0. 一句话

> 映话让一场 48 分钟的会议，5 秒变成 4 段。边开会、边记录。会议结束就走人。

---

## 1. 制作总览

### 1.1 风格定位

| 维度 | 标准 |
|------|------|
| **调性** | Apple Keynote 风格（克制 / 安静 / 真实使用场景）|
| **节奏** | 5 段切换，每段 4-8s，无快速 cut |
| **音乐** | ambient pad 起 → typing 节奏 → spring 弹跳 → tone shift 隐私段 → resolve chord 收 |
| **字体** | 屏幕文字：Inter Display（中文混排 Noto Serif SC），标题 64-96pt，正文 24-32pt |
| **品牌色** | 主色 #B57BFF 紫 → #2DD4BF 青 渐变（design-doc §2.1）|
| **录制红** | #FF3B30（仅在 REC 红点用，不滥用）|
| **背景** | 暗色 #0A0A0F（design-doc §2.1 近黑）+ aurora 紫青 wash 5% |
| **CTA 文字** | 暖白 #F4F1EC（design-doc §2.1）|
| **水印** | 全程右下角 02 GRADIENT Y logo @ 60px / 40% opacity |

### 1.2 不要做

- ❌ 不堆词：每屏 ≤ 1 行文字叠加，total on-screen words < 30
- ❌ 不用"赋能/智能/效率/AI 驱动/一键"等 SaaS 营销词
- ❌ 不用 pie / donut / gauge / radar / Bento 框
- ❌ 不用 cyberpunk 紫青霓虹（紫青仅作 accent）
- ❌ 不用声画错位的 pop sound effects（仅 ambient + UI 真实声音）
- ❌ 不用假数据 / mock 渐变占位
- ❌ 不用任何 yinghua.com / .app / .ai 真实域名（视频里用 "yinghua.zzw4257.cn" 即可）

### 1.3 全程声音轨道

| 层 | 描述 | 音量 | 持续 |
|----|------|------|------|
| 音乐床 | ambient pad + 轻电子（参考 Ólafur Arnalds / Nils Frahm）| -12 LUFS | 0:00-0:30 |
| UI 真实声 | 点击 / 弹窗 / 折叠段展开（来自 macOS Big Sur+ 系统声）| -18 LUFS | 按需 |
| 旁白 | 中文 / 英文二选一 | -6 LUFS | 0:03-0:27（仅在需要时）|

> **建议**：第一版只做**无旁白版**（纯视觉 + 音乐 + UI 真实声）。中文 / 英文旁白作"有旁白变体"，可分别投放国内 / 海外渠道。

---

## 2. 精确时间线（30.0s · 精确到 0.1s · 30fps）

### [0:00.0 - 0:03.0] 开场 · Aurora 桌面（3.0s）

| 项 | 内容 |
|----|------|
| 画面 | 暗色 aurora 桌面（紫青微光 wash），Dock 12 项，Y icon 静止 |
| 文字叠加 | 中央 80pt 暖白 "映话"（fade-in 600ms ease-out）<br>下方 32pt 次白 "为面试而生的 macOS 智能助手"（delay 400ms fade-in 600ms）|
| 镜头 | 静止远景 → 0:02.0 缓推（dolly in 8%）到 Dock |
| 音乐 | ambient pad 起（0:00.0 -12 LUFS）|
| 真实声 | 0:01.0 一次极轻的 macOS 启动"咚"（系统声）|

**资产引用**：
- 桌面背景：自制（5% 紫青 radial gradient + #0A0A0F 底）
- Dock 12 项：按 C15 §6.2 锁定顺序（Finder / Launchpad / Safari / Messages / Mail / Maps / Photos / FaceTime / Calendar / Notes / Reminders / Yinghua Y icon）
- Y icon：`_exploration/C10_vector-icon/icon-01-minimal-256__260823.png`

**End frame @ 0:03.0**：Y icon 在 Dock 中央位置，已 pulse 一次。

---

### [0:03.0 - 0:08.0] 第 1 段 · 系统级录制（5.0s）

| 项 | 内容 |
|----|------|
| 画面 | cut to 屏幕录制：Zoom meeting 4 人 grid（占屏 70%）+ 映话控制面板浮窗（右下 30%，半透明玻璃） |
| 文字叠加 | 左下角 24pt 暖白 "系统级录制"（fade-in 400ms @ 0:04.0）|
| 镜头 | 屏幕录制全程，无切 |
| 动作 | 0:05.0 鼠标移到映话面板 → 0:05.5 点击 REC → 0:05.6 REC 红点 pulse 一次 → 0:06.0 计时 02:34 开始滚动 |
| 音乐 | ambient pad 持续，0:05.5 短 bass drop 配合 REC（-8 LUFS，0.4s）|
| 真实声 | 0:05.5 macOS 录音启动"嘟"（系统声）+ 0:06.0 起静音人声（用户在开会）|

**资产引用**：
- Zoom grid：可自制（4 个 placeholder 视频 tile，每 tile 一段 ambient 微动）
- 映话控制面板：参考 C15 `_exploration/C15_dark-shippable/design/01-meeting/product-meeting-in-progress__260824.jpg` 复刻录屏
- REC 红点 + 计时器：自制 SwiftUI prototype（`code/Yinghua/` C13 已 BUILD SUCCEEDED）

**End frame @ 0:08.0**：4 人 grid 维持，映话面板显示"录制中 02:39"。

---

### [0:08.0 - 0:14.0] 第 2 段 · 实时转录（6.0s）

| 项 | 内容 |
|----|------|
| 画面 | cut to 转录窗口：7 行 transcript（缩放后 3-4 行可见），左侧 speaker chips M（紫）/ W（青）/ Z（粉） |
| 文字叠加 | 左下角 24pt 暖白 "实时转录 · 自动分说话人"（fade-in 400ms @ 0:09.0）|
| 镜头 | 屏幕录制，0:11.0 缓推（dolly in 5%）到当前说话人头像 |
| 动作 | 0:08.5 第 1 行 fade-in → 0:10.0 第 2 行 fade-in（speaker M）→ 0:12.0 第 3 行 fade-in（speaker W）→ 0:13.0 第 4 行 fade-in（speaker M）|
| 音乐 | ambient pad 持续，叠加一层极轻的 typing 节奏（-20 LUFS）|
| 真实声 | 0:09.0 起静音会议人声（2 个说话人快速交替，模拟 4 人讨论但只突出 2 人）|

**转录文本示例**（7 行滚动，仅前 4 行进入画面）：

```
[00:12]  面试官 M:    嗯，那我们就开始吧。先请你简单介绍一下你自己。
[00:34]  我:           好的面试官。我叫张同学，本科浙大计算机，今年大四。
[01:02]  面试官 M:    好，那讲一下你最有意思的一个项目。
[01:15]  我:           好的，是上学期做的一个端到端 ML 系统。
[01:48]  面试官 W:    等等，能具体讲讲推理优化那块怎么做的吗？
[02:21]  我:           行，我们用了一种 kernel fusion 的方法……
[02:54]  面试官 M:    嗯，这个有意思。继续。
```

**资产引用**：
- 转录屏：参考 C15 `_exploration/C15_dark-shippable/design/03-transcript/product-transcript-focus__260824.jpg` 录屏
- speaker chips：紫 #B57BFF / 青 #2DD4BF / 粉 #E63FB8（design-doc §2.1）

**End frame @ 0:14.0**：transcript 第 4 行高亮（speaker M 紫头像 active）。

---

### [0:14.0 - 0:22.0] 第 3 段 · AI 总结（8.0s · 核心段）

| 项 | 内容 |
|----|------|
| 画面 | cut to review-mode 窗口：左 file card + 右 4 折叠段（关键瞬间 / 达成的决定 / 待办 / 遗留问题） |
| 文字叠加 | 左下角 24pt 暖白 "AI 总结 · 48 分钟 5 秒"（fade-in 400ms @ 0:15.0）|
| 镜头 | 屏幕录制，0:18.0 微推（dolly in 5%）到 4 段区域 |
| 动作 | 0:15.5 4 段第 1 段（关键瞬间）展开（spring 220ms）→ 0:17.0 第 2 段（达成的决定）展开 → 0:19.0 第 3 段（待办）展开 → 0:20.5 第 4 段（遗留问题）展开 |
| 音乐 | ambient pad 持续，每段展开时一个 short click 配 spring 弹跳（-16 LUFS）|
| 真实声 | 0:14.5 一次 macOS 文件打开"哒"声 |

**4 段展开内容**（中文，**真实 demo 数据** — 用一个 mock 面试场景）：

```
1. ▾ 关键瞬间                              [紫 sparkle icon]
   · 00:12 开场自我介绍（候选人浙大 CS 大四）
   · 01:15 详细讲 ML 端到端项目
   · 01:48 面试官追问推理优化细节
   · 02:21 候选人讲 kernel fusion 方法

2. ▾ 达成的决定                            [青 check icon]
   · 进入下一轮技术面（48 小时内通知）
   · 候选人需在面试后 24h 内提交 ML 系统的 GitHub 链接

3. ▾ 待办                                  [粉 bullet icon]
   · 面试官 W — 48 小时内发下一轮通知
   · 张同学 — 24h 内提交 GitHub + 1 页技术总结
   · HR — 把 4 段总结同步给面试官 W

4. ▾ 遗留问题                              [暖白 question icon]
   · 候选人硕士方向是读研还是工作？
   · 候选人期望的城市和薪资范围？
```

**资产引用**：
- review-mode：参考 C15 `_exploration/C15_dark-shippable/design/04-review/product-review-mode__260824.jpg` 录屏
- 4 段折叠动效：spring 220ms 配 cubic-bezier(0.16, 1, 0.3, 1)
- 紫 / 青 / 粉 / 暖白 icon：design-doc §4.6 锁定

**End frame @ 0:22.0**：4 段全部展开，第 3 段（待办）当前高亮，文件大小 "48:05" 显示在 file card。

---

### [0:22.0 - 0:27.0] 第 4 段 · 隐私强调（5.0s）

| 项 | 内容 |
|----|------|
| 画面 | cut to macOS 系统设置窗口：左边栏"映话"（高亮）→ 主区域 "通用" 标签 → 切到 "凭据" 标签 |
| 文字叠加 | 左下角 24pt 暖白 "本地优先 · BYOK"（fade-in 400ms @ 0:23.0）<br>0:25.5 切到 "100% 本地 · 零上传 · 你的数据你的 Mac"（fade-in 400ms）|
| 镜头 | 屏幕录制，0:25.0 微推（dolly in 3%）到 API key 输入框 |
| 动作 | 0:22.5 点"凭据"标签 → 0:24.0 显示 API key 字段（masked ●●●●●●●●●）→ 0:24.5 字段下方小字 "Keychain 加密 · 本机存储" → 0:25.5 切到"隐私"标签 |
| 音乐 | ambient pad → 0:23.0 一次 tone shift（降半音，更克制）|
| 真实声 | 0:22.5 / 0:25.5 各一次 tab 切换"哒"声 |

**设置窗口内容示例**：

```
映话 · 设置
┌────────────────────────────────────────┐
│  通用  录音  转录  AI  凭据  隐私  关于  │  ← 顶部 tab bar
├────────────────────────────────────────┤
│                                        │
│  API 密钥                              │
│  OpenAI · sk-●●●●●●●●●●●●●●●●●     │
│  [已加密 · 存储于 macOS Keychain]      │
│                                        │
│  Anthropic · sk-ant-●●●●●●●●●●●●  │
│  [已加密 · 存储于 macOS Keychain]      │
│                                        │
└────────────────────────────────────────┘
```

**切到"隐私"标签**（0:25.5）：

```
  隐私
  ┌────────────────────────────────────┐
  │  ☑ 100% 本地处理（系统音频 + 麦克风）│
  │  ☑ 零上传（音频文件永不离开 Mac）   │
  │  ☑ BYOK 模式（API key 本机加密）   │
  │  ☑ 转录本地缓存 30 天后自动清除     │
  └────────────────────────────────────┘
```

**End frame @ 0:27.0**：设置窗口停留 0.3s 静音，让观众读隐私 4 条 checkbox。

---

### [0:27.0 - 0:30.0] 结尾 · CTA（3.0s）

| 项 | 内容 |
|----|------|
| 画面 | cut to 全黑 #0A0A0F → 0:27.5 Dock Y icon 跳一下（pulse）→ 0:28.0 中央 02 GRADIENT Y logo 1024 出现（fade-in 800ms scale 0.92 → 1.0） |
| 文字叠加 | 中央下方 64pt 暖白 "映话 · 免费下载 ↗"（fade-in 600ms @ 0:28.0）<br>再下方 32pt 次白 "yinghua.zzw4257.cn"（fade-in 400ms @ 0:28.8）|
| 镜头 | 静止，无推拉 |
| 音乐 | ambient pad 持续到 0:28.5 → 0:28.5 一次 resolve chord（小三和弦，温暖收尾）→ 0:30.0 fade out |
| 真实声 | 0:27.5 Y icon 跳动一次"叮"声（macOS bounce 提示声）|

**资产引用**：
- Y logo 1024：`_exploration/C10_vector-icon/icon-02-gradient-1024__260823.png`
- 全黑底：`#0A0A0F` solid（design-doc §2.1）

**End frame @ 0:30.0**：logo + 文字静止 0.5s 留白 → cut black。

---

## 3. 总时长分配

| 段 | 时长 | 占比 | 备注 |
|----|------|------|------|
| 开场 | 3.0s | 10% | Aurora 桌面 + Y icon |
| 系统级录制 | 5.0s | 17% | REC 红点 + 计时 |
| 实时转录 | 6.0s | 20% | transcript 滚动 |
| AI 总结 | 8.0s | 27% | 4 段展开（核心段）|
| 隐私强调 | 5.0s | 17% | 设置 + 隐私 4 条 |
| CTA | 3.0s | 10% | logo + 下载 |
| **合计** | **30.0s** | **100%** | — |

---

## 4. 文字叠加总字数

| 段 | 文字 | 字数 |
|----|------|------|
| 开场 | "映话" + "为面试而生的 macOS 智能助手" | 1 + 13 = 14 |
| 第 1 段 | "系统级录制" | 5 |
| 第 2 段 | "实时转录 · 自动分说话人" | 10 |
| 第 3 段 | "AI 总结 · 48 分钟 5 秒" | 10（数字占 7 字）|
| 第 4 段 | "本地优先 · BYOK" + "100% 本地 · 零上传 · 你的数据你的 Mac" | 7 + 16 = 23 |
| 结尾 | "映话 · 免费下载 ↗" + "yinghua.zzw4257.cn" | 8 + 11 = 19 |
| **合计** | — | **79 字 + 11 字符** |

> Apple 风格标准：30s demo 屏幕文字 < 100 字。✅ 79 字合格。

---

## 5. 制作清单（交付物）

| # | 资产 | 制作方式 | 优先级 |
|---|------|----------|--------|
| 1 | 暗色 aurora 桌面（30s 4K 静态）| Figma 制作 3840×2160 PNG | P0 |
| 2 | Zoom 4 人 grid mock 视频（5s）| Final Cut 制作 4 个 ambient 视频 tile 循环 | P0 |
| 3 | 映话控制面板录屏（5s）| SwiftUI 录屏（`code/Yinghua/` 编译版）| P0 |
| 4 | transcript 录屏（6s）| SwiftUI 录屏（7 行滚动）| P0 |
| 5 | review-mode 录屏（8s）| SwiftUI 录屏（4 段展开）| P0 |
| 6 | 设置窗口录屏（5s）| macOS 系统设置录屏（mock 映话 tab）| P0 |
| 7 | Y logo 1024 PNG | C10 已有 `_exploration/C10_vector-icon/icon-02-gradient-1024__260823.png` | P0 |
| 8 | Y icon 256 PNG（Dock 用）| C10 已有 `icon-01-minimal-256__260823.png` | P0 |
| 9 | ambient pad 音乐（30s）| 找 royalty-free（Epidemic Sound / Artlist）| P0 |
| 10 | macOS 系统声包 | 系统自带录：启动 / 点击 / 弹窗 / bounce | P1 |
| 11 | 文字叠加动效 | After Effects 模板（fade-in 400-800ms ease-out）| P1 |
| 12 | Y watermark | 全程右下角 alpha 40% 60px | P1 |

---

## 6. 验收 checklist

- [ ] 30s 总时长精确（±0.3s）
- [ ] 5 段切换顺滑（cross-dissolve 200ms，无 hard cut）
- [ ] 屏幕文字 ≤ 100 字（实际 79）
- [ ] 品牌色一致：紫 #B57BFF + 青 #2DD4BF + 暖白 #F4F1EC + 近黑 #0A0A0F
- [ ] 录制红 #FF3B30 仅在 REC 红点用一次
- [ ] 4 段 AI 总结展开动效：spring 220ms cubic-bezier(0.16, 1, 0.3, 1)
- [ ] Y logo 02 GRADIENT 仅在结尾用，Dock 用 01 MINIMAL
- [ ] 音乐 fade out 自然（0:28.5-0:30.0）
- [ ] 无任何"赋能/智能/AI 驱动"等营销词
- [ ] 无 pie / donut / gauge / radar / Bento
- [ ] 4K 母版 3840×2160（1080p 交付）
- [ ] 字幕 / 配音 / 旁白 三轨独立（可分别静音/替换）
- [ ] 静音版（纯音乐 + UI 真实声）作为保底版本

---

## 7. 输出格式

- **母版**：4K 3840×2160 · ProRes 422 HQ · 30fps
- **交付版**：1080p H.264 12Mbps · 30fps · MP4
- **音乐轨**：WAV 48kHz 24bit 独立导出
- **旁白轨**：WAV 48kHz 24bit 独立导出（中 / 英 各一轨）
- **UI 真实声轨**：WAV 48kHz 24bit 独立导出
- **总文件大小**：1080p ≈ 45MB · 4K 母版 ≈ 12GB
- **命名**：`yinghua-demo-30s_4k__260823.mov` / `yinghua-demo-30s_1080p__260823.mp4`
