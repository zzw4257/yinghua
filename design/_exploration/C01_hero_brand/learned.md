# C1 — 学到了什么（部分，待 user-pick 后补完）

## ✅ 已观察到

### 1. matrix 在中文 UI 渲染上表现优秀

5 张图中的所有中文（"映话"、"映"、00:01:23 等）都清晰可读，无错字、无字符画。这验证了 B1 假设：**matrix 应是映话的主力图片生成工具**。

### 2. prompt 里的"macOS / dashboard / data flow"等关键词会误触发生成 UI 元素

C 和 D 都出现了 macOS 顶 bar 或 dashboard 元素。**这些不在 prompt 里**——是模型的"创意"。

**改进 master prompt block**：
- 加 "no UI elements, no dashboards, no control bars, no time/battery/WiFi indicators"
- 加 "no chrome, no toolbar, no menu bar"

### 3. 用户 profile 里的"暗色城市"和"极光紫"在 A 和 E 中都有体现，但方向不同

- A：纯黑深空 + 紫光球 = 极简 / 抽象 / 内部
- E：暗色城市 + 紫霓虹 = 叙事 / 场景 / 营销

两条方向可以**并存**——映话不一定只有一个 hero 风格。

### 4. "对话 / 实时"的产品语义在 B（液态金属）里最弱

B 偏"物质 / 工艺"调，不直接呼应映话"实时映射对话"的核心。**B 不作主方向候选**，但 liquid splash 动效可拆到 C14 motion study。

## ⏳ 等用户挑完后补

- 用户挑了哪 1-2 个
- 用户对每个候选的具体反馈（哪些元素要保留 / 哪些要改 / 哪些完全不要）
- 调性（pure cosmic vs 暗色城市 vs 中和）倾向
- 是否需要第三条方向（基于 A + E 的 hybrid）跑 C2

## 对 C2 的预判

C2 调性细化的 3 个 sub-direction 候选可能是：

1. **Pure cosmic（基于 A）**：极简 / 抽象 / 深空
2. **City narrative（基于 E）**：暗色城市 / 紫霓虹 / 营销
3. **Hybrid**：把 A 的紫光球放进 E 的城市天际线，作为"城市夜空中的对话能量"

#3 是值得跑的——它**同时满足用户 profile 的"暗色城市"和当前锁定的"极光紫"**，且视觉上比单独的 A 或 E 更有叙事性。

等用户选完决定。
