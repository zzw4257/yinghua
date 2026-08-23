# 映话 · Pricing A/B Test Setup

> **版本**：v1.0 · 2026-08-24
> **负责人**：Marketing 团队
> **目的**：测 3 种 pricing 方案对 **Free → Pro 升级率**（primary KPI）的影响
> **状态**：设计稿就绪 · 待配置 amplitude / Mixpanel funnel + Stripe A/B routing

---

## 0. TL;DR（一页摘要）

| 字段 | 值 |
|------|------|
| **目标** | 找出 Free → Pro 升级率最高的 pricing 方案 |
| **变体** | A (baseline 3 tier) · B (2 tier 简化) · C (14-day trial 驱动) |
| **KPI primary** | Free → Pro 升级率（30 天窗口） |
| **KPI secondary** | Free 注册率 · 试用→付费率 · 30 天留存 · LTV/ARPU |
| **流量分配** | 50% A / 25% B / 25% C（A 是 baseline，需更多数据精度） |
| **最小样本量** | 每臂 3,000 unique visitor（每变体）|
| **运行时长** | 至少 14 天（覆盖 2 个完整工作周 + 1 个周末周期）|
| **决策方法** | 贝叶斯 Beta-Binomial 为主，频率派 95% CI 作为 sanity check |
| **显著性阈值** | 升级率相对提升 ≥ 30%（B 或 C 胜出 A）且 95% CI 不跨 0 |
| **回滚机制** | 单变体表现差于 A &gt; 10% 时立即停止该变体 |

---

## 1. 假设（4 条）

| ID | 假设 | 来源 | 通过的判定 |
|----|------|------|------------|
| **H1** | Free 翻倍（5 → 10）让升级率上升 | B 档：试用充分后，用户感知产品价值更高 | B 升级率 ≥ A × 1.30 |
| **H2** | $29 Pro 比 $19 Pro 提升 ARPU，即使转化率下降 | B 档：单价提升 ≥ 50% 抵消转化损失 | B 收入 / 访客 ≥ A × 1.10 |
| **H3** | 14 天无摩擦试用能显著提升升级率 | C 档：让用户先用后付，决策质量高 | C 升级率 ≥ A × 1.50 |
| **H4** | Team $39 降价提升 3 人+ 团队转化 | C 档：降低团队决策门槛 | C Team 注册率 ≥ A × 1.40 |

**主假设**：H3（C trial-driven）可能胜出。次要假设：H1（B 简化）次之。**反假设**：H2 成立但 H1 不成立（升级率下降幅度 &gt; 50%），说明 $19 是用户心理价位。

---

## 2. 变体定义（Variant Specs）

### Variant A — Baseline (3 tier · 当前方案)
- 5 场 / 月 Free
- Pro $19 / 月（BYOK）
- Team $49 / 席位 / 月
- 营销文案：见 `pricing-page-A__260824.html`

### Variant B — Simplified (2 tier)
- **10 场 / 月** Free（翻倍）
- Pro **$29 / 月**（+53%）
- Team tier 显示 "Coming soon · 2026 Q4"
- 营销文案：见 `pricing-page-B__260824.html`

### Variant C — Trial-driven (4 tier)
- 顶部 banner: "14 天全功能试用 · 不绑卡" + 倒计时器
- Free 试用 14 天（全功能解锁）
- 试用结束自动降级到 Free **3 场 / 月**（比 A 更克制）
- Pro $19 / 月（与 A 同价）
- Team **$39 / 席位 / 月**（-20%）
- "试用结束会发生什么" 4 步说明
- 营销文案：见 `pricing-page-C__260824.html`

---

## 3. 流量分配（Traffic Split）

### 3.1 推荐方案：50% / 25% / 25%

```
┌──────────────────────────────────────────────────┐
│  Total traffic to /pricing                       │
│  ┌──────────┬─────────┬─────────┐                │
│  │   50%    │   25%   │   25%   │                │
│  │    A     │    B    │    C    │                │
│  │ baseline │simplify │ trial   │                │
│  └──────────┴─────────┴─────────┘                │
└──────────────────────────────────────────────────┘
```

**为什么不平均 33/33/33？**
- A 是 baseline，需要更多样本以提高统计精度（衡量 B/C 相对 A 的 lift）
- B/C 是实验性方案，25% 各自足够在 2 周内拿到 3,000+ 用户
- 若 A 数据精度不够，B/C 的相对提升会被噪声淹没

### 3.2 实施方式

**Cloudflare Workers**（推荐）：

```js
// worker.js — /pricing 路由分流
export default {
  async fetch(req) {
    const url = new URL(req.url);
    if (url.pathname !== '/pricing') {
      return fetch(req);
    }

    // Cookie 锁定（保证用户始终看到同一变体）
    const cookie = req.headers.get('cookie') || '';
    let variant = cookie.match(/yh_ab=([ABC])/)?.[1];

    if (!variant) {
      const r = Math.random();
      variant = r < 0.5 ? 'A' : (r < 0.75 ? 'B' : 'C');
    }

    // 持久化 cookie（30 天）
    const target = `${url.origin}/pricing-${variant.toLowerCase()}${url.search}`;
    const res = await fetch(target, { headers: req.headers });
    res.headers.append('Set-Cookie', `yh_ab=${variant}; Path=/; Max-Age=2592000; SameSite=Lax`);
    return res;
  }
};
```

**兜底方案**（无 Worker）：在 `index.html` 加 JS 检测 `localStorage.yh_ab`，未设置则按 50/25/25 分配并 redirect。

### 3.3 锁定规则（重要）

- ✅ 同一用户 30 天内始终看到同一变体（cookie + localStorage 双写）
- ✅ 已订阅用户（任何 tier）**不参与 A/B 分流**，始终看到 A（grandfathering）
- ✅ 中国大陆 + 港澳台地区使用独立 cookie key（`yh_ab_cn`），防止海外结论污染

---

## 4. KPI 体系（Metrics）

### 4.1 Primary KPI

**Free → Pro 升级率**（30 天窗口）：

```
Free → Pro 升级率 = (30 天内 Free → Pro 升级数) / (期内 Free 注册总数)
```

- 跟踪：amplitude funnel `pricing_view → signup → 30d_pro_upgrade`
- 排除：14 天内通过 trial 直接转 Pro 的用户（属 C 专属 funnel）
- 归因窗口：用户首次访问 pricing 页 → 30 天内的升级

### 4.2 Secondary KPIs

| KPI | 公式 | 目标 | 来源 |
|-----|------|------|------|
| Free 注册率 | `signup / pricing_view` | ≥ 8% | amplitude |
| 试用→付费率 (C only) | `trial_to_paid / trial_start` | ≥ 25% | amplitude + Stripe |
| 30 天留存 | `d30_return / signup` | ≥ 40% | amplitude |
| ARPU (30 天) | `total_revenue / active_user` | ≥ $1.50 | Stripe |
| LTV 估算 | `ARPU / monthly_churn` | ≥ $30 (12 月) | cohort analysis |
| Time to upgrade | `upgrade_at - signup_at` 中位数 | ≤ 7 天 | amplitude |
| Pricing page bounce | `bounce / pricing_view` | ≤ 45% | GA4 |

### 4.3 Guardrail Metrics（反向指标 · 越低越好）

| Guardrail | 阈值 | 触发动作 |
|-----------|------|----------|
| 7 天 churn rate | ≤ 8% | 超过 → 立即停止该变体 |
| Support tickets / user | ≤ 0.05 | 超过 → 检查 onboarding |
| Refund rate | ≤ 3% | 超过 → 检查 trial→paid 误导 |
| 14 天 trial 二次注册率 | ≤ 5% | 超过 → trial 太短 |

---

## 5. 最小样本量（Sample Size · 2026-08-24 估算）

### 5.1 假设输入

| 参数 | 值 | 来源 |
|------|------|------|
| Baseline 升级率 (A) | 5.0% | 历史 30 天平均 |
| MDE (最小可检测效应) | 1.5%（绝对）/ 30%（相对） | marketing OKR |
| Power (1 − β) | 0.80 | 标准 |
| Significance α (双侧) | 0.05 | 标准 |
| 流量分配 | 50/25/25 | §3.1 |
| 预期日均 PV to /pricing | ~600 | 流量预估 |

### 5.2 计算结果

**方法**：两比例 Z-test + Bonferroni 校正（3 个 pairwise 对比，α_adjusted = 0.05 / 3 = 0.0167）

```
n_per_arm = (z_α/2 + z_β)² × [p1(1-p1) + p2(1-p2)] / (p1 - p2)²
          = (2.394 + 0.842)² × [0.05×0.95 + 0.065×0.935] / 0.015²
          ≈ 3,000 unique visitors per arm
```

**结论**：
- 每变体需 3,000 unique visitor
- A 占 50%：6,000 unique（充足）
- B/C 各 25%：3,000 unique（刚好达标）
- 总计：12,000 unique visitor
- 按 600/天：约 **20 天**

### 5.3 时间表

| 周 | 时间 | 累计访客（变体）| 状态 |
|---|------|----------------|------|
| W1 D1-3 | Day 1-3 | A: 900 · B: 450 · C: 450 | ramp-up，不看结论 |
| W1 D4-7 | Day 4-7 | A: 1,800 · B: 900 · C: 900 | 看 30-day funnel 太早 |
| W2 | Day 8-14 | A: 3,600 · B: 1,800 · C: 1,800 | 早期 B/C 数据可看，但 30-day window 未满 |
| W3 | Day 15-21 | A: 5,400 · B: 2,700 · C: 2,700 | 30-day window 出现首批完成用户 |
| W4 D1-3 | Day 22-24 | A: 6,000 · B: 3,000 · C: 3,000 | **达最小样本量**，可做频率派分析 |
| W4 D4-7 | Day 25-28 | A: 6,600 · B: 3,300 · C: 3,300 | 30-day 全量数据可用，**正式分析** |

**总时长**：28 天（4 周）。**绝对最短**：14 天（但只能用早期数据 + 贝叶斯先验）。

---

## 6. 分析方法（Statistical Method）

### 6.1 主方法：贝叶斯 Beta-Binomial

**为什么选贝叶斯**：
- 允许早期停止（day 3-5 看到强证据即可停止失败变体）
- 输出的是「B 优于 A 的概率」，比 p-value 更适合业务决策
- 三臂比较直接（不需要 pairwise + Bonferroni）

**模型**：

```python
# PyMC / Stan / 手写
# 升级数 ~ Binomial(n=visitors, p=variant_conversion_rate)
# p ~ Beta(alpha=1, beta=1)  # 无信息先验

with pm.Model() as model:
    p_A = pm.Beta('p_A', alpha=1, beta=1)
    p_B = pm.Beta('p_B', alpha=1, beta=1)
    p_C = pm.Beta('p_C', alpha=1, beta=1)

    obs_A = pm.Binomial('obs_A', n=visitors_A, p=p_A, observed=upgrades_A)
    obs_B = pm.Binomial('obs_B', n=visitors_B, p=p_B, observed=upgrades_B)
    obs_C = pm.Binomial('obs_C', n=visitors_C, p=p_C, observed=upgrades_C)

    # 直接概率
    prob_B_better_A = pm.math.gt(p_B, p_A * 1.30)  # 30% 相对提升
    prob_C_better_A = pm.math.gt(p_C, p_A * 1.30)

    trace = pm.sample(2000, tune=1000)
```

**输出**：
- `P(p_B > p_A × 1.30)` = 71.2% → 决策"继续观察"
- `P(p_B > p_A × 1.30)` = 96.5% → 决策"B 显著胜出"
- `P(p_C > p_A × 1.30)` = 12.1% → 决策"C 已落败，可提前停止"

### 6.2 Sanity Check：频率派

```python
from statsmodels.stats.proportion import proportions_ztest

# A vs B
count = [upgrades_A, upgrades_B]
nobs = [visitors_A, visitors_B]
z, p = proportions_ztest(count, nobs, alternative='two-sided')

# 95% CI
ci_low, ci_high = proportion_confint(upgrades_B, visitors_B, alpha=0.05)
# 若 CI 跨 0 或 p > 0.0167 (Bonferroni) → 不显著
```

### 6.3 决策矩阵

| 贝叶斯 `P(p_X > p_A × 1.30)` | 频率派 p-value | 决策 |
|------------------------------|----------------|------|
| ≥ 95% | < 0.0167 | **胜出**，可提前停止其他变体并全量 |
| 80% - 95% | 0.01 - 0.05 | **倾向胜出**，继续跑到 day 28 |
| 50% - 80% | 0.05 - 0.20 | **平局**，看 secondary KPI |
| 20% - 50% | 0.20 - 0.50 | **倾向落败**，观察 guardrail |
| < 20% | > 0.50 | **落败**，停止该变体 |

---

## 7. 决策标准（Decision Criteria · 2026-09-21 复盘）

### 7.1 胜出条件（任一满足即可全量 rollout）

1. **主 KPI**：变体升级率 ≥ A × 1.30 **且** 95% CI 不跨 0
2. **收入**：变体 ARPU ≥ A × 1.10（即使升级率下降，单价提升可弥补）
3. **体验**：变体 guardrail 全部在阈值内

### 7.2 落败条件（任一满足即停止该变体）

1. 主 KPI 升级率 < A × 0.70（即下降 30%+）
2. Guardrail 7-day churn > 12%
3. Refund rate > 5%
4. Bounce rate 上升 > 20% 相对 A

### 7.3 复盘模板

```markdown
## Pricing A/B Test · 复盘 [日期]

### 跑测周期
- 启动：2026-XX-XX
- 结束：2026-XX-XX
- 时长：N 天

### 流量数据
| 变体 | UV | Signup | Upgrade | 升级率 | 95% CI | vs A |
|------|----|----|---------|--------|--------|------|
| A    | X  | Y    | Z       | p_A%   | [a, b] | —    |
| B    | X  | Y    | Z       | p_B%   | [a, b] | +X%  |
| C    | X  | Y    | Z       | p_C%   | [a, b] | +X%  |

### 贝叶斯结论
- P(p_B > p_A × 1.30) = X%
- P(p_C > p_A × 1.30) = X%

### 频率派结论
- A vs B: z = X, p = X
- A vs C: z = X, p = X

### Guardrail
- 7-day churn: A X% / B X% / C X% ✓
- Refund: A X% / B X% / C X% ✓
- Bounce: A X% / B X% / C X% ✓

### 决策
[选择胜出变体 / 维持 A / 重新设计]

### 下一步
1. [ ] 全量 rollout 到胜出变体
2. [ ] 更新 C30 metadata 文案
3. [ ] 更新 C29 marketing pricing.html
4. [ ] 通知 engineering 配置生产环境
```

---

## 8. 实施清单（Pre-launch Checklist）

### 8.1 Engineering（实施前 1 周）

- [ ] 配置 Cloudflare Worker / Vercel Edge 分流（50/25/25）
- [ ] amplitude 事件埋点：`pricing_view · signup · trial_start · upgrade · churn`
- [ ] Stripe 接入 3 种变体的 price_id（A: `price_baseline_*` / B: `price_simplified_*` / C: `price_trial_*`）
- [ ] 14 天 trial 在 C 档自动降级逻辑（已在 C16 shippable 阶段实现，需 verify）
- [ ] 锁定 cookie + localStorage 双写
- [ ] 已订阅用户排除逻辑

### 8.2 Marketing（实施前 3 天）

- [ ] A/B 跑测公告给全公司（@all in #marketing）
- [ ] 客服 team 培训（用户问"为什么我看到的定价和别人不一样"）
- [ ] App Store / 落地页 / Twitter bio 文案暂不更新（避免污染）
- [ ] 准备复盘 PPT 模板

### 8.3 Analytics（实施前 1 天）

- [ ] amplitude funnel 配置 3 个变体独立项目
- [ ] GA4 自定义维度 `ab_variant` 透传
- [ ] Looker dashboard 模板（`pricing_ab_test_v1`）
- [ ] 报警规则：guardrail 触发 → Slack #pricing-ab-test

### 8.4 法律 / 隐私

- [ ] 确认 14 天 trial 不违反 Apple App Store 政策（**重点**：Apple 允许 14 天免费试用无需 IAP，但 App Store 内订阅必须走 IAP）
- [ ] 已订阅用户 grandfathering 写入 Terms of Service
- [ ] GDPR / CCPA：cookie 锁定需用户首次访问时告知（用现有 cookie banner）

---

## 9. 风险与缓解（Risks）

| 风险 | 概率 | 影响 | 缓解 |
|------|------|------|------|
| **样本量不足** | 中 | 高 | 延长跑到 28 天；或扩大流量到 70/15/15 |
| **季节性偏差** | 中 | 中 | 跑 4 周（覆盖 1 个月完整周期） |
| **A 档用户感受被歧视** | 低 | 中 | 锁定 cookie + 客服统一话术 |
| **C 档 trial 滥用**（一人多账号） | 中 | 中 | device fingerprint + email 验证 |
| **定价变更影响 LTV 计算** | 高 | 高 | 单独 cohort 跟踪 90 天，**不**用 30 天数据做财务预测 |
| **付费墙对 ASO 影响** | 低 | 低 | App Store 评论监控，跑测期间 daily check |
| **Apple 政策风险** | 低 | 高 | 14 天 trial 在 macOS 不强制 IAP，但 iOS 需要；本次仅 macOS 端跑 |

---

## 10. 跑测结束后（Post-test Actions）

### 10.1 胜出变体

1. **Engineering**：
   - 全量 rollout（删除 Worker 分流，所有用户走胜出版本）
   - 删除失败的 price_id（保留 90 天 refund 窗口）
2. **Marketing**：
   - 更新 C29 marketing website `pricing.html`
   - 更新 C30 app store metadata（注意 Apple 字符限制，详见 [C30 README §3](./../C30_app-store-metadata/README.md)）
   - 更新 C19 social templates
3. **Documentation**：
   - 本文件 `ab-test-setup.md` 加 "completed" 章节 + 复盘链接
   - design-doc v2.0 §6 加 1 段定价决策记录
4. **Customer Comms**：
   - 邮件给已订阅用户：价格不变（grandfathering）
   - 公告给"未升级 Free 用户"：新价格（仅 1 次营销 push）

### 10.2 维持 A 档

1. 删除 Worker（保留 fallback 路由）
2. 在 `ab-test-setup.md` 加"失败记录"章节
3. 若 H3（C trial）落败：考虑"trial"作为 Pro 内 feature，**不**作为 funnel
4. 重新设计下个 A/B test 假设（例如：Pro 价格 $19 vs $24 vs $14）

---

## 11. 附录

### 11.1 相关文件

- [`pricing-page-A__260824.html`](./pricing-page-A__260824.html) — 变体 A baseline
- [`pricing-page-B__260824.html`](./pricing-page-B__260824.html) — 变体 B 简化
- [`pricing-page-C__260824.html`](./pricing-page-C__260824.html) — 变体 C trial-driven
- [`README.md`](./README.md) — 目录说明
- [`../C29_marketing-website/website/pricing.html`](../C29_marketing-website/website/pricing.html) — 现有 marketing pricing（A 档同款，已 shippable）
- [`../C30_app-store-metadata/metadata-zh-Hans.md`](../C30_app-store-metadata/metadata-zh-Hans.md) — App Store 文案（同步需重测字符限制）
- [`../design/design-tokens.json`](../design-tokens.json) — 视觉 token（保持品牌色一致）
- [`../C27_brand-guidelines/gtm-plan__260824.md`](../C27_brand-guidelines/gtm-plan__260824.md) §3 定价 — GTM plan 中"贵在 AI 成本"策略源头

### 11.2 术语表

| 术语 | 含义 |
|------|------|
| **Primary KPI** | 唯一用于判定胜出的指标 |
| **Secondary KPI** | 辅助判断，不作为胜出条件 |
| **Guardrail** | 反向指标，超阈值立即停止 |
| **MDE** | Minimum Detectable Effect，最小可检测效应 |
| **Power** | 1 − β，正确拒绝零假设的概率（0.80 标准） |
| **Bonferroni** | 多重比较校正（3 对比 α 调到 0.05/3） |
| **Grandfathering** | 老用户保留旧价，新规则只对新用户生效 |

### 11.3 变更记录

| 版本 | 日期 | 变更 |
|------|------|------|
| v1.0 | 2026-08-24 | 初版 · 3 变体设计 + 流量分配 + 贝叶斯方法 |

---

**最后修订**：2026-08-24 · Worker · C43 pricing A/B test 设计
