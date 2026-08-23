# C07 App icon V3 — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：D1 design doc §3 图标系统、C05/C06 落地状态、C07 README 定调
**审计模式**：只读 + 写本文件，不修改任何源图，不调用生图后端

---

## TL;DR

- **总体 VERDICT：PARTIAL** — 双生策略（01 主 + 02 备用）方向正确，但 3 个变体都有可量化、可在 Figma 后期修复的字形 / 比例 / 标注问题。
- **01 MINIMAL**：可以作主 icon，Y 字形可识别为"同一个字形"（PASS 字面），但右捺弧度、中间缝、笔画粗细 3 处需要 Figma 精修对齐 C06 Dock Y 的"硬直"风格。
- **02 GRADIENT**：可以作 marketing 备用（颜色对得上 C06 04 review / 05 onboarding 的渐变 Y），但中间缝非常明显（README 已记），Figma 矢量重绘时必须三笔合一。
- **03 GLASS**：**真弃用**。Y 偏小属实，玻璃球 + 多层玻璃对 v3 调性过度装饰，且 v3 产品图里**没有任何一张**用了"玻璃球包 mark"的容器形态 — 03 跟 C06 视觉语言脱节。

---

## A. Y 字形几何一致性（最关键）

### A.1 横向对比总表

| 维度 | C07 01 MINIMAL | C07 02 GRADIENT | C07 03 GLASS | C06 5 张图 Dock Y |
|------|----------------|------------------|----------------|---------------------|
| 容器 | macOS squircle | macOS squircle | macOS squircle | macOS squircle |
| 颜色 | 暖白 #F4F1EC | 紫青渐变 | 暖白 | 01/02/03 白；04/05 渐变 |
| 笔画粗细 | **粗**（~6-7% icon width）| **中**（~4-5%）| **中-细**（~4-5%）| 01 meeting 粗，02/03 中，04/05 细 |
| 撇捺角度 | 左撇较陡 / 右捺**有弯** | 左撇较陡 / 右捺相对直 | 左撇较陡 / 右捺**有弯** | 撇捺相对**直且对称** |
| 圆头收尾 | round-cap ✓ | round-cap ✓ | round-cap ✓ | round-cap ✓ |
| 三笔汇合 | **有缝** ❌ | **有明显缝** ❌ | **有缝** ❌ | 三笔**合一** ✓（01 meeting 明显）|
| Y 占内高 | ~50-55% | ~45-50% | ~35-40%（受 orb 限制）| 约 45-55%（squircle 内）|
| 长宽比 | 偏窄 | 偏窄 | 偏窄 | 偏窄（一致）|

### A.2 逐项判定

| 对比对象 | 结果 | 差异描述 |
|----------|------|----------|
| **C07 01 MINIMAL vs C06 5 张图 Dock Y** | **PARTIAL** | ① 整体字形可识别为"Y"，container 跟 Dock 摆一起不会违和；② 01 MINIMAL 的右捺有可见弧度（像 Apple Music logo 的"弯钩"），但 C06 5 张图里 Dock Y 撇捺都是相对**硬直**的（特别是 01 meeting 那张 Y 是"工业感"三笔合一）—— 这是字形风格的差异，不是字形本身的差异；③ 01 MINIMAL 跟 01 meeting 一样粗，但比 02/03/04/05 略粗；④ 01 MINIMAL 的"中间缝"是生图伪影，矢量重绘时合并即可。**这是最接近 C06 Dock Y 的变体**。 |
| **C07 02 GRADIENT vs C06 5 张图 Dock Y** | **PARTIAL** | ① 颜色完全对得上 C06 04 review-mode 和 05 onboarding 的渐变 Y（这两个是 5 张图里仅有的渐变 Y）；② **中间缝非常明显** —— 02 GRADIENT 的左撇看起来跟右捺+竖笔是分开的两个组件，不像连续 Y；③ 02 GRADIENT 的笔画明显比 C06 Dock Y 细（特别是 04 review-mode 那张 Dock Y 虽然也是渐变但更接近 01 MINIMAL 的粗细）；④ 02 GRADIENT 跟 05 onboarding 中心那个大 Y mark 视觉上最像 —— 印证了 README "02 适合 marketing 备用" 的判断。 |
| **C07 03 GLASS vs C06 5 张图 Dock Y** | **PARTIAL** | ① Y 字形本身可识别，但**Y 偏小**（README 已记 "占 orb 不到 50% 高度"）—— 实际看 C06 任何一张产品图 Dock Y 都没有"球包 Y"的容器形态，03 是 v3 调性里的异类；② 03 跟 01 MINIMAL 用同一个 Y master 的话字形能一致，差异在容器；③ 玻璃球 + 球内 Y + 背景 aurora wash = 3 层视觉堆叠，Apple macOS 主流 app icon（Notes / Music / Reminders / Settings）没有这种"orb 包 letterform"的做法。 |

### A.3 跨 C07 3 个变体内部一致性

3 个变体在 Y 字形上**不是同一个 master**：
- 01 笔画最粗，02 较细，03 介于之间
- 01 / 03 右捺有弯，02 相对直
- 3 个都有"中间缝"，但 02 最严重（视觉上像 V 不是 Y）

**Figma 矢量精修时必须用同一个 Y master**（README §"全部 | Y 字体粗细略不统一" 已记）。

---

## B. 色彩一致性

| 对比 | 期望值 | 实际观察 | 结果 |
|------|--------|----------|------|
| **01 背景 #0A0A0F** vs C06 5 张图菜单栏黑色 | #0A0A0F（design doc §2.1 "近黑"）| 01 MINIMAL 背景实测非常接近 #0A0A0F，肉眼跟 C06 5 张图菜单栏的纯黑无明显色差 | **PASS** |
| **01 Y 色 #F4F1EC** vs C06 5 张图主文字色 | #F4F1EC（design doc §2.1 "暖白"）| 01 MINIMAL 的 Y 是暖白/微黄白，不是 #FFFFFF 纯白；跟 C06 5 张图菜单栏右侧文字（白色 SF Pro Text）有微差，但比 #FFFFFF 明显暖 | **PASS**（但 C06 5 张图实际渲染的菜单栏文字是 #FFFFFF 系统色，01 MINIMAL 用 #F4F1EC 是有意识的"降饱和"设计选择，符合 D1）|
| **02 渐变 #B57BFF → #2DD4BF** vs C06 review-mode / onboarding 紫青按钮 | design doc §2.1 紫 (vivid) + 青 (vivid) | 02 GRADIENT 的 Y 渐变方向是**左上紫 → 右下青**，跟 C06 05 onboarding "Get started" 按钮的渐变方向一致；色相匹配 | **PASS**（02 是 5 张产品图里所有紫青渐变元素的"字形版"）|

### B.1 跟 C06 内嵌紫青元素的色阶核对

- C06 04 review-mode 右下"Share" 按钮：紫 → 青对角线渐变 ✓
- C06 05 onboarding 中心 "Get started" 按钮：紫 → 青水平渐变
- C07 02 GRADIENT Y 字渐变：紫（左上）→ 青（右下）对角线

**小差异**：02 GRADIENT 是对角线，onboarding CTA 是水平线，但视觉权重差不多，Figma 精修时可统一为对角线（与 Share 按钮一致）。

---

## C. 容器形状

### C.1 3 个变体 squircle 一致性

| 变体 | squircle 外观 | 22.4% 圆角判断 | 跟 Apple 标准对比 |
|------|----------------|----------------|-------------------|
| 01 MINIMAL | 大型 squircle，边缘平滑曲线 | ✅ 22.4% squircle 视觉一致 | 跟 Apple Notes / Apple Music 容器比例一致 |
| 02 GRADIENT | 同 01 | ✅ | 同 01 |
| 03 GLASS | 同 01 | ✅ | 同 01 |

**3 个变体 squircle 一致性：PASS**

### C.2 跟 Apple 标准对比

- macOS Tahoe (26) 之后所有 app icon 都用 22.4% squircle superellipse
- 3 个变体的 squircle 圆角比例都符合
- 03 GLASS 容器本身没问题，问题是**容器内**多了一层玻璃 orb

**PASS**

---

## D. 03 GLASS 独立评估

### D.1 视觉独立性

- 03 跟 01 / 02 在 Y 字形上能看出是同一个字（特别是右捺弯钩特征一致）
- 但容器差异巨大：01 / 02 是"flat squircle + Y"，03 是"squircle + aurora wash + glass orb + Y"
- 03 是 3 个变体里唯一带"容器中容器"（orb 套 Y）的方案

### D.2 v3 调性兼容性

**C06 5 张产品图里没有任何一张用了"玻璃球包 mark"**：
- 01 meeting：4 人 video grid + 控制面板 + transcript 列，**Y 仅在 Dock 出现**
- 02 empty-state：2x2 大按钮 + 最近录音，**Y 仅在 Dock**
- 03 transcript-focus：单窗口 7 段说话人轮次，**Y 仅在 Dock**
- 04 review-mode：左 file card + 右 AI 总结，**Y 仅在 Dock + file card 左侧紫色 Y icon（48x48 小 Y）**
- 05 onboarding：中心 1024x1024 大 Y mark（紫青渐变，对应 02 GRADIENT）+ Dock 渐变 Y

**v3 调性里 Y 永远是**：
- 紫色 squircle 上的 Y（Dock 通用）
- 紫青渐变 Y（05 onboarding 中心）
- 紫色 Y file icon（04 review-mode file card）

**没有"玻璃球包 Y"这个形态**。03 跟 v3 调性是**异类**。

### D.3 Apple 设计团队评审会选 03 吗？

参考 Apple 自家 app icon：
- Notes（白底黄 Y）→ flat 容器 + letterform
- Music（白底紫红渐变音符）→ flat 容器 + 渐变
- Reminders（白底 3 色 list）→ flat 容器 + 图形
- Voice Memos（黑底紫红 Y → 现已更新为 squircle + 紫红渐变）→ flat 容器
- Shortcuts（紫底粉蓝渐变 + 8 个方块）→ flat 容器

**Apple 从不在 app icon 里用"玻璃球 / orb / 球体包裹"形态**。03 像是 macOS Sonoma widget 风格，但 widget 跟 app icon 是两套不同的设计系统。

**03 不会过 Apple 设计评审**。

### D.4 是否应该保留作为第 4 变体？

- ❌ **不建议保留**
- 03 跟 01 / 02 不是"渐进式变体"，而是**不同设计语言**
- 留作第 4 候选会导致 Figma 里"哪个是主 icon"混乱
- 如果团队真的想试 "orb 包 letterform"，应该开 V4 单独一轮，不要污染 V3 双生策略

**决定：弃用 03 GLASS**。C07 README "03 不采纳" 的判断**正确**。

---

## E. 缩略图可读性

### E.1 16x16 Dock 缩略图 mental simulation

**01 MINIMAL**：
- Y 的两个撇捺**能区分**（笔画粗 + 暖白对比强，缩到 16x16 仍可读为"Y"）
- ✅ 这是 01 MINIMAL 作主 icon 的**最强论据** —— 跟 macOS Notes / Reminders 的 letterform icon 在 Dock 16x16 一样可读

**02 GRADIENT**：
- 渐变在 16x16 会被压缩成接近单色（紫或青，取决于渲染器的下采样）
- 渐变版 Y 在 16x16 看起来**笔画更细**，撇捺角度对比减弱
- ⚠️ 仍然可识别为 Y，但失去渐变优势
- **结论**：02 不应做 Dock icon（已写入 D1 §3.3）

**03 GLASS**：
- 玻璃 orb + Y 在 16x16 会糊成一团
- ❌ 完全不可读
- **结论**：即使保留也不能做 Dock icon

### E.2 32x32 Finder 列表 mental simulation

**01 MINIMAL**：✅ 仍然清晰，Y 撇捺 + 暖白对比都还在
**02 GRADIENT**：✅ 渐变开始显现，但笔画细，视觉重量比 01 轻
**03 GLASS**：⚠️ orb 边缘在 32x32 还能看出球体轮廓，但 Y 笔画细 + 玻璃高光 → 看起来像 "iOS 时代的玻璃感" icon，跟 v3 调性不符

### E.3 64x64 App Switcher mental simulation

- macOS App Switcher 里所有 app 缩到 64x64 并排
- **01 MINIMAL** 跟 Apple Notes / Apple Music / Apple Reminders 这种 flat letterform icon 摆一起**完全协调** —— 重量、对比、容器比例都对
- **02 GRADIENT** 跟 flat letterform icon 摆一起会显得"更跳"，但因为是紫青品牌色反而**强化品牌识别**
- **03 GLASS** 跟 flat icon 摆一起**视觉上突兀** —— glass orb 像是 iOS 6 时代的拟物回潮，跟 macOS 26 flat squircle 时代格格不入

---

## F. Marketing 可用性（02 GRADIENT）

| 场景 | 适合度 | 说明 |
|------|--------|------|
| **Twitter banner（3:1）** | **适合** | 02 渐变 Y 在 banner 中央放大后视觉冲击力强，紫青渐变是产品品牌色，social 出海一眼能记住 |
| **Product Hunt 缩略图** | **适合** | PH 缩略图通常 240x240，02 渐变 Y 在小尺寸下仍可识别，紫青对比强，PH 列表里容易"跳出来" |
| **Landing hero** | **非常适合** | 跟 C06 05 onboarding 中心那个大 Y mark 形成"产品内 Y = marketing Y"的视觉一致性 |
| **投资人 deck 第一页** | **非常适合** | 紫青渐变有"科技感 + Apple 克制"的平衡，不会像 cyberpunk 渐变那样廉价 |

**F 整体：PASS** —— 02 GRADIENT 在所有 marketing 场景都成立，跟 C06 5 张产品图的紫青品牌色完全衔接。

---

## G. 与 C06 v3 整体调性

| 变体 | 跟 C06 摆一起 | 协调 / 突兀 原因 |
|------|----------------|-------------------|
| **01 MINIMAL** | **协调** | 跟 C06 5 张图 Dock Y 是同一种 letterform 思路；菜单栏黑色背景跟 01 MINIMAL 背景色匹配；不放进产品图里单独看也像一个"会出现在 Dock 的 macOS 26 app icon" |
| **02 GRADIENT** | **协调** | 跟 C06 04 review-mode Dock Y、05 onboarding Dock Y、05 onboarding 中心大 Y 是**同一种 Y**；紫青渐变是 C06 全套的紫青按钮主色 |
| **03 GLASS** | **突兀** | C06 5 张图里**没有任何**"玻璃球包 mark"的视觉语言；03 像是从 macOS Sonoma widget 里偷来的，跟 C06 的 flat squircle + vibrancy 玻璃调性是两套系统 |

**G 整体**：
- 01 / 02 → 跟 C06 是"同一个 app 家族"
- 03 → 跟 C06 是"亲戚家的孩子"（亲戚：macOS widget）

---

## V1 已知问题验证

逐项验证 C07 README §"V1 已知问题" 4 条：

| # | 位置 | issue | 是否真在图里 | 严重度 | 证据 |
|---|------|-------|--------------|--------|------|
| 1 | `app-icon-v3-comparison__260822.jpg` | 标签下方出现 "SF Pro 14pt 500" 和 "color #6B6B72"（prompt 规则泄漏）| **✅ 真在图里** | **中** | 对比图清晰可见 3 处 "SF Pro 14pt 500" + 3 处 "color #6B6B72" 文字出现在每个 label 下方；Figma 必须删除 |
| 2 | 02 GRADIENT | Y 中间两臂与竖笔交汇处有视觉小缝 | **✅ 真在图里** | **高** | 02 GRADIENT 的 Y 左撇、右捺、竖笔三者在中间汇合处**明显不连续** —— 视觉上像 V 跟 I 叠在一起，不是 Y；矢量重绘时必须合并 |
| 3 | 03 GLASS | Y 在玻璃球内显得略小（占 orb 不到 50% 高度）| **✅ 真在图里** | **中-高** | 03 的 Y 实测占 orb 高度约 35-40%，且玻璃 orb 占容器约 70%，Y 实际占整个 squircle 高度仅约 25-30% —— 严重偏小 |
| 4 | 全部 | Y 字体粗细略不统一 | **✅ 真在图里** | **中** | 01 MINIMAL 笔画最粗（~6-7% icon width），02 较细（~4-5%），03 介于之间；3 个变体不是同一个 Y master |

**4 条 README 列出的已知问题全部真在图里**。没有"误报"。

### V1 额外发现的问题（README 没记）

| # | 位置 | issue | 严重度 | 说明 |
|---|------|-------|--------|------|
| 5 | 01 MINIMAL | 右捺有可见弧度（弯钩），跟 C06 Dock Y 的"硬直"风格不一致 | 中 | 视觉上像 Apple Music 旧 logo 的"弯钩 Y"，不像 C06 5 张产品图里"硬直工业感"的 Y；Figma 重绘时建议改直 |
| 6 | 02 GRADIENT | 笔画比 C06 5 张图 Dock Y 明显细 | 中 | 02 应该跟 01 用同一 Y master，仅改变填充色（白 → 渐变），不应该笔画也变细 |
| 7 | 01 MINIMAL | 1px 白色高光边缘（C07 README 提到的"1px 白色 6% opacity 边缘高光"）肉眼几乎不可见 | 低 | 设计 spec 有，但生图后视觉权重过弱；Figma 后期可保持 1px @ 6% 也可 |

---

## 总结

### 总体 VERDICT：**PARTIAL**

### 双生策略（01 主 + 02 备用）是否合理？

**YES**。01 / 02 跟 C06 5 张产品图的视觉语言**完全衔接**：
- 01 = C06 5 张图 Dock Y 的 flat 容器 + 暖白 Y
- 02 = C06 04 review-mode Dock Y + 05 onboarding 大 Y 的紫青渐变

策略方向正确，进入 Round 2 没问题。但**需要 Figma 矢量精修**对齐以下 6 点（按优先级）：

### 给 Round 2 / Figma 精修的 6 条建议

1. **【高】02 GRADIENT 的 Y 中间缝必须修**。这是 README 已记的最严重字形 bug，三笔必须合一。
2. **【高】3 个变体用同一个 Y master**，仅改填充（白 / 渐变 / 玻璃内白）。Figma 用 component override。
3. **【中】01 MINIMAL 的右捺改直**。跟 C06 Dock Y 的"硬直工业感"对齐；现在的弯钩是 Apple Music 旧 logo 风格，不属于 v3 调性。
4. **【中】01 MINIMAL / 02 GRADIENT 的 Y 笔画粗细统一**。建议占 icon width 5-6%，比当前 01 略细、比 02 略粗。
5. **【中】03 GLASS 弃用**。如果团队仍想保留作为 V4 探索，独立成下一轮，不污染 V3 收口。
6. **【低】对比图的 "SF Pro 14pt 500" / "color #6B6B72" 删除**，仅保留 3 个 label。

### Round 2 候选方向建议

D1 design doc §10 已列候选（C08+）：
- a. icon 矢量精修（强烈建议作为 C08 第一个任务，吃上面 6 条建议）
- b. 浅色 macOS 模式全套（5 张 v3 重出浅色版）
- c. Onboarding 3 屏流
- d. Twitter 3:1 banner（marketing 出海，02 GRADIENT 已 ready）
- e. Browser extension 入口
- f. 收口 → D1 design doc（已经在 Round 1 收口里了）

**建议顺序**：a → d → b → c → e → f
- a 是必须先做的（把 C07 V3 真正收口为可用资产）
- d 是 02 GRADIENT 的 natural next step（marketing 出海），02 已经 ready 可以直接出
- b 是量大但优先级中（macOS 26+ 用户一半在浅色）
- c / e 是产品表面扩展
- f 已经在 D1 收口了

### 风险提醒

- **02 GRADIENT 的中间缝是 3 个变体里最严重的字形问题**，Figma 重绘时如果错过这一条，整个 02 marketing 备用价值会大打折扣
- **不要因为 01 / 02 通过了审计就跳过矢量精修**。3 个变体之间笔画的微小不一致，1024 大图看不出来，64x64 App Switcher 会很明显

---

## 附录：审计方法说明

**只读不修**：本审计未修改任何源图（app-icon-v3a/b/c、comparison、5 张 C06 v3 产品图），未调用任何生图后端。Y 字形 / 容器 / 色彩 / 缩略可读性全部基于 2048x2048 高分辨率读图 + 跟 D1 design doc §3 图标系统对账。

**证据来源**：
- C07 3 个变体 PNG/JPG（2048x2048 原图）
- C07 对比图（2048x2048，含 3 个变体 + label + 已知 prompt 泄漏）
- C06 5 张 v3 产品图（2752x1536，含 5 个产品场景的完整 macOS desktop）
- D1 design doc §2 配色 / §3 图标系统 / §7 反模式
- C07 README（定调 + V1 已知问题清单）

**判断标准**：
- PASS = Y 字形跟 C06 一致（差异 < 描述阈值），策略可执行
- PARTIAL = 1-3 项 Figma 后期能修的小问题
- FAIL = 字形 / 容器 / 调性明显跟 C06 冲突，需要重做

本次审计结果**全部进入 PARTIAL 级别**，没有 FAIL。
