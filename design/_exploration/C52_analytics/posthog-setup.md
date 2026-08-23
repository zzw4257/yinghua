# 映话 PostHog 集成指南

> 任务 ID：C52 · 最后更新 2026-08-23

## 0. 一句话

映话在 marketing website（3 语言）+ macOS app 里用 **PostHog 自托管**（`ph.yinghua.zzw4257.cn`）做 event-based analytics。**不用 cookie banner、不收集 PII、不收集 IP 明文、不录屏、默认 opt-in**。所有数据由我们控制，user 可以导出 / 删除。

## 1. 为什么选 PostHog（不是 GA4 / Mixpanel / Plausible）

| 维度 | PostHog 自托管 | GA4 | Mixpanel | Plausible |
|------|---------------|-----|----------|-----------|
| 开源 | ✅ MIT | ❌ | ❌ | ✅ AGPL |
| 自托管 | ✅ 官方支持 | ❌ | ❌ | ❌（仅 self-host 商业版）|
| GDPR / CCPA | ✅（自托管 = 不出欧盟）| ⚠️ 跨境 | ⚠️ 跨境 | ✅ |
| **不用 cookie banner** | ✅（无 cookie）| ❌ | ❌ | ✅ |
| Event-based | ✅ | ✅ | ✅ | ❌（仅 pageview）|
| Funnel / Cohort / Feature flag | ✅ 内置 | ⚠️ 需 GA360 | ✅ | ❌ |
| Pricing | **免费**（自托管）| 免费但有数据采集 | $833+/月 | $9/月起 |
| 中文社区 | ✅ | ✅ | ⚠️ | ❌ |

**关键决策**：

- **Cookie 豁免**：PostHog 用 `localStorage` 存 distinct_id（不算 GDPR 下的 cookie / 跟踪技术），但**为了安全**，我们在 init 的时候 `disable_persistence: false` + 在 privacy page 写明「你可以在 DNT / 浏览器设置里 opt-out」。
- **数据归属**：`ph.yinghua.zzw4257.cn` 部署在映话自己控制的服务器（建议 EU / 美国），数据不出我们的合规边界，CCPA / GDPR 双重安全。
- **可审计**：PostHog 全部代码 Apache 2.0 / MIT，self-host = 100% 可 audit。
- **macOS app 支持**：PostHog 官方提供 iOS / macOS Swift SDK，跟 C50 已有 CrashReporter 平行存在（`crash.yinghua.zzw4257.cn` vs `ph.yinghua.zzw4257.cn`）。

## 2. Cloud vs Self-host 决策

```
你是映话创始团队 / 工程师？        是 ──→ Self-host (推荐)
                                    │
你是 marketing 团队无 ops？         是 ──→ PostHog Cloud (us.posthog.com)
                                    │
                                    ↓
                              法律要求数据不出境？ ──→ Self-host（自托管 = 出境控制）
                              需要 audit？          ──→ Self-host
                              只是看 pageview？     ──→ Cloud / Plausible 即可
```

**映话选择：Self-host**

理由：

1. **品牌承诺**：映话 marketing hero 第一句是「为面试而生的 macOS 智能助手 · 本地优先、克制、可靠」。如果 analytics 用 Cloud，相当于把用户行为上传到第三方服务器，跟 brand-guidelines §1.3 价值观 #1「本地优先」冲突。
2. **法律安全**：映话用户有 EU / 美国 / 中国三地，自托管 = 数据归属清晰，CCPA / GDPR / 中国《个人信息保护法》三重合规。
3. **成本**：开源版免费，event 数量无上限。
4. **可控**：可以关掉自动 features、关 session recording、自定义 retention / PII scrub。

## 3. 数据流

```
┌────────────────────┐                                    ┌──────────────────┐
│  Marketing Site    │                                    │  PostHog         │
│  (browser)         │  ── HTTPS POST /decide?ip=1 ──→    │  (ph.yinghua.zzw4257.cn)│
│                    │  ── HTTPS POST /e/ (events) ────→  │                  │
│  - $pageview       │                                    │  ClickHouse DB   │
│  - cta_clicked     │                                    │  (EU/US region)  │
│  - pricing_variant │                                    │                  │
│  - signup_started  │                                    │  - 30 天后自动    │
└────────────────────┘                                    │    匿名化 IP      │
                                                          │  - 不卖数据      │
┌────────────────────┐                                    │  - GDPR / CCPA   │
│  macOS App         │  ── HTTPS POST /e/ ────────────→  │  - export /      │
│  (Swift SDK)       │                                    │    delete API    │
│  - app_open        │                                    │                  │
│  - recording_*     │                                    └──────────────────┘
│  - summary_*       │                                            │
│  - error_logged    │                                            │
└────────────────────┘                                             ↓
                                                          user 可以访问
                                                          ph.yinghua.zzw4257.cn
                                                          导出自己的 event
                                                          （我的活动）→ delete
```

**关键点**：

- **入口唯一**：所有 client 走 `https://ph.yinghua.zzw4257.cn`（DNS A 指向我们控制的服务器，TLS 证书 Let's Encrypt）
- **IP 处理**：PostHog server 收到 IP 后**立即**做 `md5(ip + daily_salt)` 哈希，写库只有 hash。30 天后 server 端 cron 跑匿名化（`ip_hash` 字段 nullify）。
- **不录屏**：`disable_session_recording: true`，`capture_screenviews` 仅在 app 内开启（macOS 端），**网站侧完全不开**。
- **User 控制**：PostHog 的 person profile 支持「forget this user」API，映话在 `privacy.html` 提供"删除我的 analytics 数据"按钮 → 调 `https://ph.yinghua.zzw4257.cn/api/person/<distinct_id>/delete`。

## 4. 5 个核心 Event Schema

### 4.1 `$pageview`（自动 · PostHog 内置）

| 字段 | 类型 | 说明 | 例 |
|------|------|------|-----|
| `$current_url` | string | 当前 URL | `https://yinghua.zzw4257.cn/pricing.html` |
| `$referrer` | string | 上一个页面（去 query） | `https://twitter.com/` |
| `$pathname` | string | URL path | `/pricing.html` |
| `$browser` | string | 浏览器 | `Chrome 128` |
| `$os` | string | 操作系统 | `macOS 26.0` |

> ✅ PostHog SDK `capture_pageview: true` 自动收集。**不收集**：`$ip`（server 端 hash）/ 设备指纹 / `$device_id` 之外的标识符。

### 4.2 `cta_clicked`（手动 · 业务关键）

| 字段 | 类型 | 必填 | 说明 | 例 |
|------|------|------|------|-----|
| `cta_name` | string | ✅ | CTA 标识（见 §5）| `hero_download` |
| `cta_position` | string | ✅ | 页面位置 | `hero` / `nav` / `pricing-card` |
| `cta_destination` | string | ✅ | 跳转目标 | `download.html` |
| `page_path` | string | ✅ | 所在页面 | `/` / `/pricing.html` |
| `variant_id` | string | ❌ | A/B 变体（C43 配合）| `pricing_v2` |

```js
// 在 main.js 末尾
document.addEventListener('DOMContentLoaded', function () {
  document.querySelectorAll('[data-cta]').forEach(function (el) {
    el.addEventListener('click', function () {
      if (window.posthog) {
        posthog.capture('cta_clicked', {
          cta_name: el.getAttribute('data-cta'),
          cta_position: el.getAttribute('data-cta-position') || 'unknown',
          cta_destination: el.getAttribute('href') || '',
          page_path: window.location.pathname,
          variant_id: localStorage.getItem('yinghua-pricing-variant') || 'control'
        });
      }
    });
  });
});
```

### 4.3 `pricing_variant_viewed`（手动 · A/B 配合 C43）

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `variant_id` | string | ✅ | C43 实验变体 ID |
| `plan_tier` | string | ✅ | 用户看的是 Free / Pro / Team |
| `page_path` | string | ✅ | `/pricing.html` |
| `time_on_page_ms` | number | ❌ | 停留时间 |

```js
// 在 pricing.html 加载时
posthog.capture('pricing_variant_viewed', {
  variant_id: localStorage.getItem('yinghua-pricing-variant') || 'control',
  plan_tier: 'pro',  // 滚动到 Pro 卡时更新
  page_path: '/pricing.html'
});
```

### 4.4 `signup_started`（手动 · 转化漏斗顶）

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `provider` | string | ✅ | `email` / `github` / `google` / `apple` |
| `plan` | string | ❌ | 用户选的计划（Free / Pro）|
| `referrer_page` | string | ✅ | 来源页 |

```js
// 在 signup form submit 时
posthog.capture('signup_started', {
  provider: 'email',
  plan: 'free',
  referrer_page: document.referrer
});
```

### 4.5 `signup_completed`（手动 · 转化漏斗底）

| 字段 | 类型 | 必填 | 说明 |
|------|------|------|------|
| `provider` | string | ✅ | 同上 |
| `plan` | string | ✅ | 选定计划 |
| `trial_days` | number | ❌ | 试用期（Pro = 14） |
| `duration_ms` | number | ❌ | signup_started → signup_completed 间隔 |

```js
posthog.capture('signup_completed', {
  provider: 'github',
  plan: 'pro',
  trial_days: 14,
  duration_ms: Date.now() - window.__signupStartedAt
});
```

## 5. macOS app 5 个关键 Event

见 `macos-app-integration.md` 详细 schema。摘要：

| Event | 触发点 | 字段 |
|-------|--------|------|
| `app_open` | `applicationDidFinishLaunching` | `app_version`, `os_version`, `is_first_open` |
| `recording_started` | 用户按 REC | `source` (`mic` / `system` / `both`), `language` |
| `recording_stopped` | 用户按 STOP | `duration_seconds`, `speakers_count` |
| `summary_generated` | AI 总结完成 | `duration_seconds`, `provider` (`anthropic` / `openai` / `local`) |
| `error_logged` | C50 `logNonFatal` 路径 | `error_type`, `context`（业务 tag，无 PII）|

## 6. 不收集（明示承诺）

| 不收 | 原因 |
|------|------|
| 录音 / 转录 / 总结内容 | 品牌承诺 = 本地优先 |
| API Key（C50 已 lock）| macOS Keychain 沙箱化 |
| IP 明文 | server 端 hash 后立即丢弃 |
| 设备 ID（persistent）| distinct_id 30 天滚动 |
| Session 录屏 | `disable_session_recording: true` |
| 表单字段值 | signup 字段走 OAuth provider，PostHog 只看 `provider` 不看 email |
| 跨站 fingerprint | `disable_external_toolbar_loading: true` |
| $device_id（macOS 端长期）| Swift SDK 用 `anonymousId` + opt-in 后才升级为 `userId` |

## 7. 部署清单（self-host）

| 组件 | 建议规格 | 备注 |
|------|---------|------|
| PostHog server | 2 vCPU / 4GB / 50GB SSD | 单实例起步 |
| PostgreSQL | 4 vCPU / 8GB / 200GB SSD | ClickHouse + Postgres 双库 |
| ClickHouse | 4 vCPU / 16GB / 500GB SSD | event 存储 |
| Kafka | 2 vCPU / 4GB | 缓冲，可选 |
| 部署方式 | Docker Compose（起步）/ Kubernetes（scale）| 官方 helm chart |
| 域名 | `ph.yinghua.zzw4257.cn` | A 记录 + Let's Encrypt |
| Region | 建议 EU-West（GDPR）/ US-East（CCPA）| 避免亚太（无就近收益）|
| 备份 | Postgres 每日 snapshot + ClickHouse S3 export | 30 天保留 |
| 监控 | Uptime Kuma + 自家 status page | 跟我们 status.yinghua.zzw4257.cn 整合 |

**最小启动资源**：~$30/月（Hetzner / DO），日活 1k 以内足够。

## 8. 配置常量

| Key | 用途 | 谁能拿到 |
|-----|------|---------|
| `phc_yinghua_web_public` | Website project key | 公开（snippet 可见）|
| `phc_yinghua_ios_key` | macOS app key | app bundle，Apple 签名后公开（这是 SDK 限制）|
| `phc_yinghua_server` | Server-side API（export）| 仅 ops team |

**安全注释**：PostHog project key 设计上就是「公开」——它只能用于 ingest event，**不能**用于 read data。read 需要 `personal_api_key`，那个存在 ops 1Password。

## 9. 关联文档

- `marketing-website-integration.md` — C29 / C39 website 6×3 = 18 页 snippet
- `macos-app-integration.md` — Swift SDK + project.yml
- `privacy-cookies-banner.md` — privacy 段三语言
- `dashboard-setup.md` — 4 个 dashboard 配置
- `README.md` — 总览
- 与 C29（website） / C39（i18n） / C50（crash） / C43（A/B） 的引用关系
