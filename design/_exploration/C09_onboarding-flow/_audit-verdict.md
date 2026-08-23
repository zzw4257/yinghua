# C09 Onboarding 后 2 屏 — 独立审计 verdict

**审计人**：verifier（独立）
**日期**：2026-08-23
**审计依据**：D1 `design/design-doc.md` + C06 屏 1 (`C06_product-v3/05-onboarding/product-onboarding-v3__260822.png`) 视觉基准
**审计对象**：
- `C09_onboarding-flow/02-permission/onboarding-02-permission__260823.jpg`
- `C09_onboarding-flow/03-byok/onboarding-03-byok__260823.jpg`

---

## 0. 评分标准速记

| 标记 | 含义 |
|------|------|
| ✅ PASS | 完全符合 D1 规则，渲染清晰、无明显瑕疵 |
| ⚠️ PARTIAL | 局部问题（Figma 后期可修），不影响产品级使用 |
| ❌ FAIL | 严重违反 D1 / 主体崩塌 / 出现 user 明确禁止的反模式 |
| ➖ n/a | 当前屏无此元素 |

---

## 1. 10 项 × 2 张图 检查表

| # | 检查项 | D1 规则 | 02 permission | 03 byok |
|---|--------|---------|---------------|---------|
| 1 | **3-dot 进度指示器** | 屏 2 dot 2 active、屏 3 dot 3 active；位置在窗口顶部；active dot 有紫色光晕 | ✅ **PASS** — 顶部居中，dot 1=8px 实心紫，dot 2=12px 实心紫+明显紫色光晕，dot 3=8px 空心灰，三点连线细紫 | ✅ **PASS** — 顶部居中，dot 1/2 都是 8px 实心紫，dot 3=12px 实心紫+明显紫色光晕。连线比屏 2 更紫（D1 §2.1 #8A5BFF 更接近）|
| 2 | **菜单栏 + Apple logo + 4 menu + 时钟** | §6.1 明确要求 "Apple + app 名（'Finder' 或 'Yinghua'）+ 4 menu" | ⚠️ **PARTIAL** — Apple + File/Edit/View/Window/Help（4 menu） + 状态图标 + 时钟 09:42，但**缺 app 名**（同 C06 N1 老问题）。视觉风格、时区与其他 2 屏一致 | ⚠️ **PARTIAL** — 同屏 2 一样缺 app 名 |
| 3 | **Dock 11 系统 + 分隔点 + Y** | §6.2 严格锁定 12 项顺序 | ⚠️ **PARTIAL** — 有 10 系统 + 1 小竖线分隔 + Y（有 Y 下方 magenta 圆点 = running 状态），但 **第 5 位是 Contacts（皮面地址簿）而非 Notes**（同 C06 5 号位老问题）；**日历顶部红色文字 "NEN" 乱码**（同 C06 "ПАН" 老问题，应该是 "26" 或 day name 渲染错位）。Y 位置 ✓ | ⚠️ **PARTIAL** — 10 系统 + 分隔 + Y，但 **第 5 位是 Photos（彩虹花瓣 pinwheel）代替 Notes**；**日历顶部 "MEM" 红色乱码**（同屏 2 "NEN" 是同一类问题）|
| 4 | **暗色玻璃 vibrancy 窗口 + 14px 圆角** | §2.5, §6.3 | ✅ **PASS** — 深色 glass 底 + 极光 wash 上叠，14px 圆角明显，traffic lights 红/黄/绿在左上角 | ✅ **PASS** — 同上 |
| 5 | **Primary 按钮紫青渐变** | §4.1 紫 `#B57BFF` → 青 `#2DD4BF` 对角渐变 | ✅ **PASS** — "Continue" 紫青对角渐变，无 arrow icon（与 spec 一致），文字白 | ✅ **PASS** — "Finish setup" 紫青对角渐变，**正确显示 50% opacity disabled 态**（浅紫/浅青，文字灰白可读），无 arrow icon |
| 6 | **Secondary 按钮** | §4.1 玻璃 + 1px 8% 白边 | ➖ n/a（屏 2 只有 primary + ghost link）| ✅ **PASS** — "Test connection" 是玻璃 + 1px 8% 白边 ghost-style 按钮，匹配 §4.1 |
| 7 | **Ghost link 透明 + hover 下划线** | §4.1 静默灰 + hover 显示下划线 | ✅ **PASS** — "Skip for now" 静默灰 12pt 无下划线（静态截图无 hover）| ✅ **PASS** — "I'll do this later" 静默灰 12pt 无下划线 |
| 8 | **Pill / 状态标签颜色** | §2.1 语义色 绿 `#34C759` / 灰 / 紫 `#8A5BFF` | ✅ **PASS** — 3 张卡片 pill 颜色完全正确：Microphone="Granted" 绿底+绿字；Screen="Pending" 灰底+灰字；Notifications="Optional" 灰底+灰字 | ✅ **PASS** — 测试中状态条：左侧 3px 灰色 accent bar + spinner 旋转图标 + "Testing connection..." 文字，符合 transient state 语义 |
| 9 | **极光壁纸（深空 + 紫青）** | §2.1 deep purple → teal/cyan + 星点 | ✅ **PASS** — 桌面左紫右青、星空点、aurora ribbon 流动，亮度/色调与 C06 5 高度一致 | ✅ **PASS** — 同上 |
| 10 | **无 prompt 规则泄漏 + 无品牌名作为 icon** | §7 "AI" 字样禁烧图；C06/C07 教训 | ✅ **PASS** — 屏 2 没有 "AI" 字母、没有 "14pt regular" / "600 15pt" 等字号描述泄漏；没有用品牌名作 icon | ❌ **FAIL（HIGH）** — **Anthropic provider card icon 是黑色方块 + 白色 "AI" 字母**。这同时违反 D1 §3.4（"任何带'AI'字样烧图的 icon 变体"）和 §7（"'AI' 字样烧进 icon / hero"），且是 user 在本任务里明确要求核对的反模式。Custom card 的 icon 渲染为 "node" 文字（小写 n/o/d/e），不是几何 mark（README 标 V1-P3-3 低，但实际违反 §7 spirit 之一） |

### 逐图小计

- **02 permission**：8 PASS / 2 PARTIAL（菜单栏缺 app 名、Dock 第 5 位错） + 0 FAIL → **PARTIAL**
- **03 byok**：8 PASS / 2 PARTIAL（菜单栏缺 app 名、Dock 第 5 位错） + 1 FAIL（Anthropic "AI" 字母） → **PARTIAL → FAIL 边界**

---

## 2. 跨屏一致性（与 C06 屏 1 对比）

| # | 检查项 | 结果 | 证据 |
|---|--------|------|------|
| 11 | **3 屏窗口宽度 / 圆角 / 材质一致** | ⚠️ **PARTIAL** | 3 屏都是 14px 圆角、dark glass + aurora wash 材质 ✓；但窗口宽度不一致：屏 1 ~620px（最窄，因 3 bullet 单列）、屏 2 ~770px、屏 3 ~990px（最宽，因 3 provider 横向排列）。这是**合理的内容驱动自适应**而非错误，但严格说"宽度不固定"对 onboarding 流程的视觉连续性有影响。屏 2/3 之间的宽度差尤为明显 |
| 12 | **3 屏品牌色 / 字体 / 玻璃感一致** | ✅ **PASS** | 3 屏紫青渐变 CTA 一致；都使用 SF Pro Display 600 标题（屏 1 32pt / 屏 2-3 26pt，符合 README 解释的品牌首屏 vs 后续屏字号差）；正文都是 SF Pro Text 400/500；玻璃感（70% 暗 wash + aurora tint）一致；暖白 `#F4F1EC` 主文字色一致；`#8A5BFF` 紫色 focus ring 颜色一致 |
| 13 | **3 屏菜单栏 / Dock 一致** | ⚠️ **PARTIAL** | **菜单栏**：3 屏完全一致（Apple + 4 menu + 状态图标 + 09:42），时区统一（之前 C06 N10 提到的 05 时区 09:42 vs 其他 21:42 差异已通过统一到 09:42 修复）。**Dock**：3 屏都有 10 系统 + 分隔 + Y 的大致结构，但**第 5 位都是错的**（屏 1 = Contacts、屏 2 = Contacts、屏 3 = Photos）— 模型顽固地不能在 Dock 第 5 位放正确的 Notes。Y 都在第 12 位（分隔之后）✓，Y 下方 magenta dot 都在 ✓ |

---

## 3. V1 已知问题验证（README §5 + 主动发现）

### 3.1 README 列出的 V1 issue（逐条核对）

| # | 位置 | README 描述 | 是否真在图里 | 严重度 | 证据 / 备注 |
|---|------|-------------|--------------|--------|-------------|
| V1-P2-1 | 屏 2 Dock | Dock 多了 1 个图标（多出 Contacts）| ✅ **部分真在图里** | low | 不是"多了 1 个"，是**第 5 位错放 Contacts（皮面地址簿）代替 Notes（黄色记事本）**。Dock 总数 12 项不变（10 + 分隔 + Y），但 5 号位系统图标错。修复方法：Figma 用 macOS Notes 真实图标替换 |
| V1-P2-2 | 屏 2 Dock | Mail / Messages 顺序与 C05 ref-02 颠倒 | ❌ **不在图里** | n/a | 实际位置 3=Messages（绿气泡）、4=Mail（蓝信封），**与 D1 §6.2 锁定顺序完全一致**。README 这条记录的是早期版本，当前 V1 已经修正 |
| V1-P2-3 | 屏 2 进度条 | 进度指示器连线颜色偏淡 | ✅ **真在图里** | 极低 | 屏 2 三点之间的连线是非常淡的灰紫色，屏 3 三点连线是更明显的中紫（接近 #8A5BFF）。屏 2 连线应统一到屏 3 的强度 |
| V1-P3-1 | 屏 3 Anthropic card | icon 用了 "AI" 字母 | ✅ **真在图里** | **HIGH** | 黑色方块 + 白色 "AI" 字母**清晰可见**，位置在中间 provider 卡的左上 28x28 squircle。**这是 user 在本任务里明确要求核对的反模式**——D1 §3.4 / §7 都明令禁止 |
| V1-P3-2 | 屏 3 Dock | Notes 被替换为 Photos（多 1 个）| ✅ **真在图里** | low | 屏 3 第 5 位是 macOS Photos 图标（彩色花瓣 pinwheel），不是 Notes。**注意** Photos 本身就是 macOS 系统 app（不在 D1 §6.2 锁定的 10 系统图标列表里），所以这违反了 D1 Dock 锁定 |
| V1-P3-3 | 屏 3 Custom card | icon 渲染为 "node" 文字 | ✅ **真在图里** | low | Custom provider 的 28x28 squircle 里有"node"小写白色文字（n/o/d/e 四个字符 + 一个小齿轮点缀）。spec 要求"abstract node / endpoint icon（white）"，模型把"node"当作 icon 内容渲染。Figma 必做：替换为简单节点 + 圆点几何 mark |
| V1-P3-4 | 屏 3 菜单栏 | 顶部比屏 2 略亮 | ❌ **看不出来** | 极低 | 两图菜单栏亮度差异不显著，可能被 jpg 压缩盖住。**不再作为独立 issue 追踪** |

### 3.2 **主动发现的新问题**（README 未列）

| # | 位置 | 新问题 | 严重度 | 说明 |
|---|------|--------|--------|------|
| N1 | 02 / 03 / 01 (屏 1) | **菜单栏缺 app 名** | medium | 3 屏菜单栏只有 Apple + 4 menu + 状态图标 + 时钟，缺 "Finder" 或 "Yinghua"。D1 §6.1 明确要求 6 项结构。**根因是 C06 5 和 C09 2/3 的 prompt 都把 "Apple + app name + 4 menu" 错误写成 "Apple + 4 menu"**，C09 没修正 C06 留下的问题。Figma 后期必须补"Finder"或"Yinghua"app 名 |
| N2 | 02 / 03 | **Dock 第 5 位系统图标错（不是 Notes）** | medium | 屏 2 = Contacts（皮面），屏 3 = Photos（彩虹花瓣）。两者都不是 D1 §6.2 锁定的 Notes（黄色记事本）。**模型对 macOS Notes 图标的视觉记忆极不稳定**。Figma 必做：从 C05 ref-02 截图裁切 5 号位，固定贴入 3 屏 |
| N3 | 02 / 03 | **日历顶部日名（day name）渲染为乱码** | medium | 屏 2 日历顶部红色 "NEN"，屏 3 日历顶部红色 "MEM"。位置在 "26" 之上，应该是 day name（Mon/Tue/Wed 等）。D1 §6.2 明确要求 "Calendar (white page + '26')"，但 spec 没说明 day name 应显示什么。**模型在没有明确 day name 的情况下生成了乱码字符**。Figma 后期建议：删除 day name，只保留 "26"，或用真 SF Pro 字体渲染 day name |
| N4 | 03 | **Custom provider card 整张背景被紫色 wash 染** | low | 屏 3 Custom card 整体有淡淡的紫色背景（不只 active 的 Anthropic card 有），看起来"Custom 也是 selected"的视觉错觉。仔细看 Custom card 没有紫色边框（只 Anthropic 有），但背景 wash 几乎和 Anthropic 一样深。Figma 检查：只让 active card 有 wash，未选 card 保持中性玻璃 |
| N5 | 03 | **Custom provider 标题排版换行** | low | Custom 卡片下"Custom" 标题与"Self-hosted" tagline 间距合理，但 OpenAI/Anthropic 的 tagline 是连排的。视觉上 Custom card 比另两个看起来更"空"。属次要排版问题 |
| N6 | 02 | **Screen & System Audio 卡片描述换行成 2 行** | low | 描述"Capture audio from apps and meetings on your screen." 在卡片宽度下断成 2 行（"apps and meetings on your" / "screen."），其他两张卡都是单行。视觉上稍微不齐，但属可接受范围。Figma 后期可微调卡片宽度或缩短文案 |
| N7 | 02 / 03 | **进度指示器右侧（dot 3）空心灰圆很淡** | 极低 | 屏 2 dot 3、屏 3 dot 1/2 的 8px 灰空心圆描边非常淡（8% 白左右），在深色背景上几乎看不见。Figma 后期可加深到 15-20% 灰 |
| N8 | 03 | **API key 输入框左边的 key icon 偏小** | 极低 | 16px 的 key SF Symbol 在 48px 高的输入框里显得偏小（左上角对齐）。可接受 |
| N9 | 02 | **Y Dock icon 下方 magenta dot 位置偏右** | 极低 | 在 02 屏的 Y app icon 下方，magenta dot 位置比屏 1/3 略偏右（可能和"running indicator"设计意图一致）。无关紧要 |
| N10 | 03 | **"Test connection" 按钮宽度比 spec 的 120px 略大** | 极低 | 实际渲染约 140-150px。无关紧要 |
| N11 | 03 | **"Anthropic / Claude Sonnet 4" tagline 写法正确** | n/a | 实际看到的 tagline 为 "Claude Sonnet 4"，写法正确。README 担心模型可能渲染成 "Claude Sonnet 四"，**实际没发生**。不再作为 issue |

---

## 4. 屏 1 → 屏 2 → 屏 3 视觉连贯性分析

### 4.1 一致之处（做得好的）

| 维度 | 3 屏表现 | 评价 |
|------|----------|------|
| 桌面壁纸 | 3 屏都是 deep purple → teal/cyan aurora + 星空点 | ✅ 同一台 Mac 截的图 |
| 窗口材质 | 3 屏都是 70% opacity dark glass + aurora wash + 14px 圆角 | ✅ |
| Traffic lights | 3 屏红/黄/绿都在窗口左上角 | ✅ |
| 菜单栏 | 3 屏都是 Apple + 4 menu + 状态图标 + 09:42（时区统一！）| ✅（C06 N10 修好了）|
| 主按钮渐变 | 3 屏都是紫 `#B57BFF` → 青 `#2DD4BF` 对角 | ✅ |
| 文字色 | 3 屏都是 `#F4F1EC` 暖白（不用纯白）| ✅ |
| Ghost link 风格 | 3 屏都是静默灰 12pt 无下划线 | ✅ |
| Pill 状态语义色 | 屏 1 无 pill、屏 2 绿/灰 pill、屏 3 灰 accent + spinner | ✅ 语义色使用正确 |
| 进度指示器 step 叙事 | 屏 1 dot 1 → 屏 2 dot 2 → 屏 3 dot 3 的 active 顺序 | ✅ 流程叙事正确 |

### 4.2 不一致之处（需要正视）

| 维度 | 屏 1 | 屏 2 | 屏 3 | 影响 |
|------|------|------|------|------|
| **进度指示器位置** | 窗口底部（dot 1）| 窗口**顶部**（dot 2）| 窗口**顶部**（dot 3）| README 解释为有意设计（屏 1 是 v3 终版保留、2/3 跟随 macOS Setup Assistant 惯例）。**接受这个解释**。Figma 阶段可以统一为顶部（更符合 macOS 现代 onboarding），但不需要重出图 |
| **窗口宽度** | ~620px（最窄）| ~770px | ~990px（最宽）| 3 屏宽度不一致，但属于"内容驱动自适应"，屏 3 因 3 provider 横排 + input 横向需要更宽。**可接受**，但若严格统一 onboarding 流视觉节奏，屏 1 偏窄，屏 3 偏宽，屏 2 居中——刚好是渐进式扩展，反而给"进入更多内容"的隐喻 |
| **品牌 Y mark** | 屏 1 中央 96x96 squircle = 02 GRADIENT（紫青渐变 Y）| 无中央 mark | 无中央 mark | 屏 1 Y mark 错风格（C06 N3 高严重度）已记，屏 2/3 不再展开 mark 因此不受影响 |
| **窗口高度** | ~800px | ~920px | ~920px | 屏 2/3 一致，屏 1 矮一点（因为内容少）。可接受 |

### 4.3 整体连贯性评估

**3 屏形成了完整 onboarding 体验**：
- 屏 1（welcome + Get started）→ 屏 2（Grant access + 3 张权限卡）→ 屏 3（BYOK + 3 个 provider + API key）
- 进度 dot 1 → 2 → 3 正确推进叙事
- 视觉语言（颜色、字体、玻璃、渐变、状态语义色）全部一致
- 3 屏都遵循"单一主 CTA + 单一 ghost link"模式（§4.1 铁律）
- **3 屏流已经可用**，只缺 Figma 后期修一批细节

---

## 5. 总结

### 总体 VERDICT: **PARTIAL**（接近 FAIL 边界）

**判定理由**：
- 10 项 × 2 张 = 20 个判定点中，PASS ≈ 16 / PARTIAL ≈ 3 / FAIL ≈ 1。
- 1 个 FAIL 是 **屏 3 Anthropic "AI" 字母 icon**，这是 D1 §3.4 + §7 都明令禁止的反模式，且 user 在本任务里明确要求核对。
- 3 项 PARTIAL 跨屏共享：菜单栏缺 app 名、Dock 第 5 位系统图标错、dock 日历顶部 day name 乱码——都是 C06 5 留下的老问题，C09 没解决。
- 主体没有崩塌：3 屏流视觉语言一致、aurora 桌面、玻璃窗口、3-dot 进度、CTA 渐变、状态 pill 语义色、3 provider 横向布局——这些全部 PASS。
- **不需要重出图**。所有问题在 Figma 后期可一次性修：1 处 icon 替换（Anthropic "AI" → 真 Anthropic diamond mark）+ 3 处文字补充（菜单栏 app 名 × 3 屏）+ Dock 第 5 位系统图标统一替换 + 日历 day name 替换或删除。

### 最严重的 3 个问题（按"影响品牌严肃度"排序）

1. **【HIGH】屏 3 Anthropic provider card icon = "AI" 字母**（V1-P3-1）
   - 位置：屏 3 中间 provider card 左上 28x28 squircle
   - 现状：黑色方块 + 白色 "AI" 字母
   - D1 规则：§3.4 "任何带'AI'字样烧图的 icon 变体" 明文禁止；§7 "❌ 'AI' 字样烧进 icon / hero" 也是反模式
   - 修法：**Figma 必做**——用真 Anthropic brand mark（白色 chevron / 钻石几何）替换。Anthropic 官方 mark 是"A"形的 chevron 钻石，不是字母 "A" + "I"
   - 用户原话强调：Anthropic 不能用 "AI" 字母

2. **【MEDIUM】3 屏菜单栏缺 app 名**（N1）
   - 位置：3 屏菜单栏 Apple logo 右侧，应有 "Finder" 或 "Yinghua" app 名
   - 现状：直接是 "File Edit View Window Help"
   - D1 规则：§6.1 明确要求 6 项结构（Apple + app 名 + 4 menu）
   - 根因：C06 5 prompt 漏写 app 名，C09 2/3 prompt 复制了 C06 错误
   - 修法：Figma 后期在 Apple logo 右侧插入 "Yinghua"（onboarding 流程应该显示自家 app 名）

3. **【MEDIUM】3 屏 Dock 第 5 位系统图标错**（N2）
   - 位置：Dock 第 5 位（应在 Notes = 黄色记事本）
   - 现状：屏 1 / 屏 2 = Contacts（皮面地址簿），屏 3 = Photos（彩虹花瓣）
   - D1 规则：§6.2 严格锁定 10 系统图标 + Notes 必须在第 5 位
   - 根因：模型对 macOS Notes 图标的视觉记忆极不稳定（同样 prompt 重复 3 次，3 次错法不同）
   - 修法：Figma 从 C05 ref-02 截图裁切第 5 位 Notes 图标，固定贴入 3 屏

### 给 Figma 后期 的建议

| 优先级 | 任务 | 数量 |
|--------|------|------|
| **P0（必须做）** | 屏 3 Anthropic icon 替换为真 Anthropic brand mark（钻石/chevron 几何），**不能是 "AI" 字母** | 1 处 |
| P1（必做） | 3 屏菜单栏插入 "Yinghua" app 名 | 3 处 |
| P1（必做） | 3 屏 Dock 第 5 位统一为 macOS Notes（黄色记事本） | 3 处 |
| P1（必做） | 3 屏 Dock 日历顶部 day name 乱码删除或正确渲染（屏 2 "NEN" / 屏 3 "MEM" / 屏 1 "ПАН"）| 3 处 |
| P2（建议做） | 屏 3 Custom provider icon 替换为简单节点 + 圆点几何 mark | 1 处 |
| P2（建议做） | 屏 3 Custom provider card 背景 wash 减弱（避免和 active Anthropic 卡视觉混淆）| 1 处 |
| P2（建议做） | 屏 2 progress dot 3 空心灰圆描边加深（从 8% 白到 15-20% 灰）| 1 处 |
| P2（建议做） | 屏 2 "Screen & System Audio" 描述断行成 2 行——调宽卡片或缩短文案 | 1 处 |
| **P3（下次 prompt 模板修正）** | "Apple logo + app name 'Yinghua'/'Finder' + 4 menu 'File Edit View Window Help'" 而不是 "Apple + 4 menu" | 1 处 prompt |
| **P3（下次 prompt 模板修正）** | 显式禁止 prompt 规则文字渲染："Do NOT render any text from the prompt itself (e.g. '14pt regular', '600 15pt', 'STYLE 1')" | 1 处 prompt |
| **P3（下次 prompt 模板修正）** | Dock 顺序用"EXACTLY these 12 slots"占位 + 强制 ref-02 截图裁切对齐 | 1 处 prompt |

---

## 6. 给 owner 的回 report

- **VERDICT**：**PARTIAL**（接近 FAIL 边界，但因仅 1 项 FAIL 且其他 3 项 PARTIAL 都是 C06 5 遗留问题，仍给 PARTIAL）
- **3 屏流是否完整可用**：**基本可用**，需要 Figma 后期修 1 项高严重度（Anthropic "AI" 字母）+ 3 项中严重度（菜单栏 app 名 × 3、Dock 第 5 位 × 3、Dock 日历 day name × 3）。**不需要重出图**
- **屏 3 Anthropic "AI" 字母是否真在图里**：**✅ 确认在图里**。黑色方块 + 白色 "AI" 字母清晰可见，位于中间 provider card 左上 28x28 squircle 内。**Figma 修的优先级 = P0（必须做）**——这是 D1 §3.4 + §7 明令禁止的反模式 + user 明确点名要查的项

---

## 7. VERDICT 等级定义回查

- **PASS**：10 项 × 2 张 + 3 项跨屏全部 PASS → **未达**
- **PARTIAL**：1-3 项 FAIL，可 Figma 后期修 → **达到**（1 项 FAIL + 3 项 PARTIAL 跨屏共享）
- **FAIL**：5+ 项 FAIL 或跨屏严重不一致 → **未达**（主体视觉语言一致，3 屏流叙事完整，只是细节未达 PASS）
