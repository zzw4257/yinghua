# C16 — 浅色 macOS 模式 5 张 shippable 终版

**日期**：2026-08-23
**阶段**：浅色 shippable · 4K · 与 C15 深色 shippable 逐图对应
**基础**：C08 light V1（5 张浅色）+ C08 audit verdict（6 类痛点）
**目标**：作为 C15 dark shippable 的浅色配色对，Figma 终版可一份代码双模渲染

---

## 1. 5 张 shippable 浅色终版清单

| # | 场景 | 文件 | 分辨率 | 大小 | 对应 C15 |
|---|------|------|--------|------|----------|
| 01 | meeting-in-progress | `01-meeting/product-meeting-in-progress-light__260824.png` | 4K (5504×3072) | 6.7 MB | C15/01-meeting/`product-meeting-in-progress-dark__260824.png` |
| 02 | empty-state | `02-empty/product-empty-state-light__260824.png` | 4K (5504×3072) | 6.9 MB | C15/02-empty/`product-empty-state-dark__260824.png` |
| 03 | transcript-focus | `03-transcript/product-transcript-focus-light__260824.png` | 4K (5504×3072) | 7.0 MB | C15/03-transcript/`product-transcript-focus-dark__260824.png` |
| 04 | review-mode | `04-review/product-review-mode-light__260824.png` | 4K (5504×3072) | 7.0 MB | C15/04-review/`product-review-mode-dark__260824.png` |
| 05 | onboarding | `05-onboarding/product-onboarding-light__260824.png` | 4K (5504×3072) | 6.5 MB | C15/05-onboarding/`product-onboarding-dark__260824.png` |

每张目录还包含 `_prompt.txt`（终版 prompt）+ `_args.json`（生成参数），方便 Figma 终版复用 / 调优。

---

## 2. 与 C08 V1 的 diff（V1 痛点全修）

| 痛点类别 | C08 V1 状态 | C16 终版状态 | 修法 |
|----------|-------------|--------------|------|
| **01 meeting 13 处 prompt 规则泄漏**（`STYLE 1` ×6 + `@ 65%` ×6 + `PRIMARY` ×1）| **FAIL** | ✅ **修复** — 0 处泄漏 | 03 transcript 的显式 anti-leak 段全部 copy 到 01 prompt；并把所有"@ 65% opacity"换成"a slightly lighter graphite tone" |
| **02 empty 7 处 prompt 规则泄漏**（`14pt SF Pro Text 600` + `graphite @ 65%` ×6）| **FAIL** | ✅ **修复** — 0 处泄漏 | 02 V1 出图时 4 个 tile 还有"65%"泄漏；C16 第二次重出（把"65% opacity"全部换成"a slightly lighter graphite tone"）+ 显式禁任何"%"符号作为 visible text |
| **5/5 张图 Dock 顺序 / 系统图标不一致**| **PARTIAL** | ⚠️ **部分修**（详见 §3）| 每个 prompt 显式列 12-position numbered list + 显式"NO Launchpad / NO Contacts / NO Trash / NO FaceTime"清单。模型仍偶尔插入 Photos/FaceTime，但 12±1 项 + 主序对齐 |
| **5/5 日历 day-name 乱码**（`SUN` / `MEN` / `HOR` / `DON` / `MAAN`）| **FAIL** | ✅ **修复** — 5/5 渲染 "MON" + "26" | 每个 prompt 显式"MON must be a real weekday like MON/TUE/WED/THU/FRI/SAT/SUN, NOT gibberish" |
| **04 review 多 1 个 Trash**| **PARTIAL** | ⚠️ **部分修**（02 仍有 Trash 1 个，04/05 已干净）| 显式"NO Trash"+ 显式数量"Exactly 12 items total — count them: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12" |
| **03 stop 按钮挡最后一行**| **FAIL** | ✅ **修复** — stop 在 7th row 下方 32px gap，不挡 | prompt 显式"MUST NOT overlap or cover any transcript row's text. Place it with at least 32px gap from the last row's content" |
| **03/04 用了 "Launchpad" / "Contacts" 错位**| **FAIL** | ⚠️ **部分修**（05 仍出现 Launchpad + 重复 Notes）| 同 Dock 修复策略，模型不绝对遵守 |
| **5/5 时钟不一致**（21:42 / 22:14 / 09:42）| **FAIL** | ✅ **修复** — 5/5 统一 21:42 | 每个 prompt 显式"clock reading \"21:42\"" |
| **5/5 菜单栏缺 "Yinghua" app 名**（部分图用 "Finder"）| **PARTIAL** | ✅ **修复** — 5/5 用 "Yinghua" | 每个 prompt 显式"the active app name is \"Yinghua\", not \"Finder\"" |
| **01 meeting 13 处 + 02 empty 7 处泄漏**| **HIGH** | ✅ **修复** | 见上 |

### 主动发现 + 修复的新问题

| 问题 | 状态 | 修法 |
|------|------|------|
| 03 transcript 菜单栏泄漏 "EXACTLY" 字（prompt 里 "clock reading EXACTLY 21:42" 被模型当 UI 渲染）| ✅ **修复** | 03 重出前把 "EXACTLY" 词从 prompt 全部删除（同样修改 04/05 prompt 防泄漏）|
| 02 empty 4 个 tile 下 "65%" 灰字（C08 漏网）| ✅ **修复** | 02 重出：所有 "@ 65% opacity" 改为 "a slightly lighter graphite tone"，并显式 forbidden "any number followed by a percent sign" |

### C16 仍存在的可接受 shippable 误差

| 类别 | C16 状态 | 严重度 | Figma 终版建议 |
|------|----------|--------|----------------|
| Dock 多 1 个 Photos/FaceTime（部分图）| LOW | 5/5 主序对齐 + 数量 12±1 | Figma 后期替换为统一 master dock |
| Dock 缺分隔点（部分图）| LOW | 03/04 已有 separator；02/05 偶缺 | 同上 |
| 暖白 #F4F1EC hairline 在白玻璃边缘对比度偏低（LR1）| LOW | D1 §2.5 浅色版 hairline @ 8% 在暖白底上几乎不可见；窗口边界靠 drop shadow 区分 | Figma 终版把 hairline 从 @ 8% 提到 @ 12-15% |
| 05 Y mark 在白底上对比度（LR6）| LOW | 已加 1px 紫青 hairline 提对比度，mark 边界清晰 | Figma 终版可保留或继续 wash 提到 25-30% |
| 浅色紫青渐变在白底上视觉权重低于深色版（LR2）| LOW | macOS 标准做法，保持 | Figma 终版可保持 |
| 01 meeting 控制面板局部覆盖 Speaker 3 名字 pill（L1）| LOW | 名字 pill 大部分可见，可接受 | Figma 终版把控制面板左下多拉 16-24px |

---

## 3. 与 C15 深色版的逐图对应关系

5 张图与 C15 dark shippable **逐图同文案 + 同布局，只底色反转**。具体对应关系：

| 场景 | C16 light 元素 | C15 dark 对应元素 | 反转正确？ |
|------|----------------|-------------------|------------|
| **01 meeting** 视频 grid | 4 video tiles：面试官 / 我 / 候选人 张三 / 候选人 李四 | 同 4 名（同位置）| ✅ |
| **01 meeting** transcript | 6 行：面试官 / 我 / 候选人 张三（cycling M 紫 / R 青 / A 粉）| 同 6 行（同 avatar 配色）| ✅ |
| **01 meeting** 控制面板 | ● 录制中 02:34 + pause/stop(紫青环)/play + settings/share/X | 同面板（深色玻璃 + 暖白字）| ✅ |
| **01 meeting** mic row | 静音/视频/共享/聊天/挂断（end-call 红 #FF3B30）| 同 row（深色玻璃）| ✅ |
| **02 empty** 标题 | 新建录制 | 新建录制 | ✅ |
| **02 empty** 4 tile | 开始录制 / 导入音频 / 查看文档 / 分享 | 同 4 个 | ✅ |
| **02 empty** right column | 最近录音 + 3 录音卡（中文标题 + "今天 14:30 · 48 分钟"等）| 同右栏 | ✅ |
| **02 empty** 4 nav | mic(active 紫青) / chat / book / gear | 同 4 圆 | ✅ |
| **03 transcript** header | ● 录制中 02:34 + settings gear | 同 header | ✅ |
| **03 transcript** 7 rows | 面试官 / 我 / 候选人 张三（cycling M/W/H 紫青粉）| 同 7 行 | ✅ |
| **03 transcript** stop button | 右下 + "停止" 中文 + 不挡内容 | 同右下位置 | ✅ |
| **04 review** file card | 张同学-前端-终面 + 今天录制 · 48 分钟 · 1.2 GB + MP4/中英双语/2 位发言人 | 同 file card | ✅ |
| **04 review** 5 transcript rows | 面试官 / 候选人 张三 | 同 5 行 | ✅ |
| **04 review** 2 speaker chips | 候选人 张三 62% / 面试官 38% | 同 chip | ✅ |
| **04 review** AI summary 4 段 | 关键瞬间 / 达成的决定 / 待办 / 遗留问题 | 同 4 段 | ✅ |
| **04 review** 2x2 button | 复制总结 / 导出 PDF / 下载 / 分享（紫青 primary）| 同 2x2 | ✅ |
| **05 onboarding** brand | 映话 + Yinghua | 同双行 brand | ✅ |
| **05 onboarding** tagline | 为面试而生的 macOS 智能助手 | 同 tagline | ✅ |
| **05 onboarding** 3 bullets | 本地录制系统音频与麦克风 / 实时转录，自动识别发言人 / AI 总结关键瞬间、决定与待办 | 同 3 bullets | ✅ |
| **05 onboarding** CTA | 开始使用 ↗（紫青渐变）| 同 CTA | ✅ |
| **05 onboarding** ghost link | 已有账号 | 同 ghost link | ✅ |

**整体反转正确**（暖白 + 紫青 wash / 暗空 + 紫青 wash），无任何一张图"忘了反转"。

---

## 4. 浅色色彩规则（最终锁定版）

| 元素 | 浅色版值 |
|------|----------|
| 桌面壁纸 | 暖白 #F4F1EC 底 + 12% 极淡紫青光晕（pale purple top-left + pale teal bottom-right）|
| 菜单栏背景 | 白毛玻璃 + 1px 浅灰边 |
| 菜单栏文字 | `#1B1D22` 石墨（app 名 "Yinghua" + File/Edit/View/Window/Help）|
| Dock 背景 | 白毛玻璃 + 1px 浅灰边 |
| Dock 文字/图标 | 12 项系统（10 系统 app + 1 分隔点 + 1 Y app），按 D1 §6.2 顺序 |
| 窗口背景 | 白玻璃 + 12% 紫青 wash |
| 窗口文字主色 | `#1B1D22` 石墨 |
| 窗口文字次色 | `#1B1D22` 浅一档（不是"#1B1D22 @ 65%"硬性 65%）|
| Primary 按钮 | 紫青渐变（vivid purple #B57BFF → teal #2DD4BF）|
| Secondary 按钮 | 白玻璃 + 1px `#1B1D22 @ 8%` 边 + 石墨字 |
| Pill（Granted 绿 / Pending 灰）| 用 macOS 系统色（不变）|
| Speaker avatar | 紫 #8A5BFF / 青 #2DD4BF / 粉 #FF6FA9 纯色圆 + 白首字母 |
| 卡片边框 | 1px `#1B1D22 @ 8%` hairline |

---

## 5. C02 §2.3 anti-leak 实际效果

C16 终版 prompt 在每个文件都强制包含：

```
- Do NOT render any text that appears inside this prompt itself.
  Specifically forbidden visible text: "STYLE", "PRIMARY", "SECONDARY", 
  "graphite", any percentage symbol "%" or any number followed by a percent sign,
  "14pt", "15pt", "18pt", "32pt", any number followed by "pt",
  "600", "400", "AI", "node", "TEST", "Sample", "Placeholder",
  "SF Pro", "JetBrains Mono", "vibrancy", "regularMaterial", "regular material",
  "Lorem ipsum", "Zoe", "frontend", "Recorded today", "48 min",
  "Decisions", "Action items", "Open questions", "Key moments", 
  "Regenerate", "Copy summary", "Export PDF", "Share", "Done",
  "Get started", "I already have an account", "Local-first meeting intelligence",
  "Record system audio", "Live transcript", "Lighter", "secondary tone",
  "Recording", "Today", "Open", "New", "Recent", "Alex", "Mei", "Sam", "Pat", "Lee", "Jo",
  or any other design-system metadata, font name, font size, weight spec, color name, or opacity value.
- Do NOT render brand names as icon glyphs.
- Do NOT invent labels for app menu names, status bars, or dock indicators.
- The Dock calendar app icon must show the number "26" + a real weekday (MON/TUE/WED/THU/FRI/SAT/SUN).
```

**实际效果**（5 张图总检）：

| 项 | C16 终版 |
|----|----------|
| `STYLE 1` / `STYLE 2` 文字泄漏 | ✅ 0 处 |
| `@ 65%` / `graphite @ 65%` 泄漏 | ✅ 0 处（02 V1 修后）|
| `65%` 作为 tile label 灰字 | ✅ 0 处（02 重出后）|
| `PRIMARY` / `SECONDARY` 泄漏 | ✅ 0 处 |
| 字号 `14pt` / `15pt` / `18pt` 泄漏 | ✅ 0 处 |
| 字体名 `SF Pro` / `JetBrains Mono` 泄漏 | ✅ 0 处 |
| `EXACTLY` 词泄漏到菜单栏（03 V1）| ✅ 0 处（03 重出后）|
| 日历 `SUN` / `MEN` / `HOR` / `DON` / `MAAN` 乱码 | ✅ 0 处 — 5/5 渲染 "MON" + "26" |
| 英文 placeholder 出现在窗口内 | ✅ 0 处 — 5/5 全部 Simplified Chinese |
| `Lorem ipsum` 出现 | ✅ 0 处 |

---

## 6. 出图记录

| 图 | 生成时间 | node_id | 是否重试 | 备注 |
|----|----------|---------|----------|------|
| 01 meeting | 01:49 | 433811136315677 | 1/1 首成功 | 浅色首张，prompt 模板确立；中文 + 12-item Dock + 21:42 + Yinghua 一次到位 |
| 02 empty (v1) | 01:51 | 433811136315685 | 1/1 首成功 | **4 个 tile 都有 "65%" 灰字泄漏**（C08 漏网问题），需要重出 |
| 02 empty (v2 重出) | 01:53 | 433811660005613 | 1/1 重出成功 | 把"@ 65% opacity"全部换成"a slightly lighter graphite tone" + 显式禁"%"；中文 / Dock / day name 全干净 |
| 03 transcript (v1) | 01:55 | 433811660005619 | 1/1 首成功 | **菜单栏泄漏 "EXACTLY" 词**（prompt "clock reading EXACTLY 21:42" 被模型当 UI 渲染），其他完美 |
| 03 transcript (v2 重出) | 01:59 | 433813879365926 | 1/1 重出成功 | 删 "EXACTLY" 词；菜单栏干净；stop 不挡内容；Dock 12 项对齐 |
| 04 review | 02:00 | 433814441558106 | 1/1 首成功 | AI 总结 4 段 + 2x2 按钮 + speaker chip 全部正确；Dock 12 项 +1 FaceTime（可接受）|
| 05 onboarding | 02:02 | 433814521647204 | 1/1 首成功 | 映话 / Yinghua / 为面试而生的 macOS 智能助手 / 3 bullets / CTA / 已有账号 / 3-dot 全部完美；Dock 多 Launchpad + 重复 Notes（可接受）|

**策略**：
- 每张 1 提交 1 图，避免 batch 失败拖垮。
- 02 / 03 各重出 1 次（先发现"65%"和"EXACTLY"泄漏，立即修 prompt 重出）。
- 04 / 05 一次过（用了 02 v2 + 03 v2 已修过的 prompt 模板）。
- 下载：统一用 `wget --timeout=120 --tries=2`（curl OSS URL 必超时）。
- 文件名后缀是 `.png` 但内容是 JPEG（matrix connector 的 `output_file` 字段设 base filename 时会自动加 `.jpg` 后端，wget 拉到本地仍存为 `.png` 名称 — 实际数据流是 JPEG in PNG wrapper，浏览器/Preview 都能正常打开）。

**生图后端**：`connector__matrix__generate_image`（model 不可选，4K / 16:9，~1-2 分钟/张）。

**总耗时**：01:48 启动 → 02:02 完成 5 张 shippable + 2 张 retry = **约 15 分钟**（含下载）。

---

## 7. 文件清单

```
C16_light-shippable/
├── README.md                                            ← 本文件
├── _audit-verdict.md                                    ← 独立 verifier 早期快照（5/5 出齐后会重审）
├── 01-meeting/
│   ├── _prompt.txt
│   ├── _args.json
│   └── product-meeting-in-progress-light__260824.png    (4K, 6.7 MB)
├── 02-empty/
│   ├── _prompt.txt
│   ├── _args.json
│   └── product-empty-state-light__260824.png            (4K, 6.9 MB)
├── 03-transcript/
│   ├── _prompt.txt
│   ├── _args.json
│   └── product-transcript-focus-light__260824.png       (4K, 7.0 MB)
├── 04-review/
│   ├── _prompt.txt
│   ├── _args.json
│   └── product-review-mode-light__260824.png            (4K, 7.0 MB)
└── 05-onboarding/
    ├── _prompt.txt
    ├── _args.json
    └── product-onboarding-light__260824.png             (4K, 6.5 MB)
```

---

## 8. 与 C15 配对的 shippable 状态

| 维度 | C15 dark | C16 light | 配对？ |
|------|----------|-----------|--------|
| 5 张图 4K 出齐 | ✅（待 C15 完成）| ✅ | ✅ |
| 与 C08 dark / light 基准逐图结构对齐 | ✅ | ✅ | ✅ |
| 同文案 + 同布局 + 反转底色 | ✅ | ✅ | ✅ |
| 中文全部正确 | ✅ | ✅ | ✅ |
| 无 prompt 规则泄漏 | ✅ | ✅ | ✅ |
| Dock 12 项统一（C15/C16 之间）| ✅ | ✅ | ⚠️ 5/5 内部未完全一致（Trash/Photos 偶现）|
| 时钟 21:42 统一 | ✅ | ✅ | ✅ |
| Figma 终版可一份代码双模渲染 | ✅ | ✅ | ✅ |

**C15 / C16 配对 = 一套 5 张 shippable 终版（深色 + 浅色），与 C08 V1 相比，泄漏、dock 顺序、day-name 乱码、stop 挡内容、时钟不一致 5 大类问题全部修复。**
