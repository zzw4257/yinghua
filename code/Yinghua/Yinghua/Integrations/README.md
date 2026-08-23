# 映话 · 第三方集成 (C49)

会议结束后，把 AI 总结自动推送到 Notion / Slack / 自定义 Webhook。所有凭据走 macOS Keychain，映话不会把 key 上传到任何中转服务器。

## 集成的 3 个 provider

| Provider | 用途 | 凭据 | 推送协议 |
|----------|------|------|----------|
| **Notion** | 写入 Notion database（每场会议一个 page）| Internal Integration Token + Database ID | Notion Pages API (`POST /v1/pages`)，Notion-Version `2022-06-28` |
| **Slack** | 推送到 Slack 频道 | Incoming Webhook URL | Slack Block Kit (`POST hooks.slack.com`) |
| **Custom Webhook** | 推送到任意 HTTPS 端点 | Endpoint URL（必填）+ HMAC 共享密钥（可选） | 通用 JSON POST，HMAC-SHA256 签名 |

---

## 配置步骤

### 1. Notion

1. 打开 [Notion My Integrations](https://www.notion.so/profile/integrations) → New integration
2. Capabilities 勾选 "Insert content" + "Update content"
3. 复制 **Internal Integration Token**（`secret_…`）填到 Settings → 集成 → Notion
4. 在 Notion 里准备一个 database，properties 至少含：
   - `Name` (title) — 映话写会议名
   - `Date` (date) — 映话写录制时间
   - `Key Moments` (number) — 可选，映话写关键瞬间条数
   - `Action Items` (number) — 可选，映话写待办条数
5. 在 database 页面右上角 `···` → Connections → 把刚才的 integration 加进去
6. 复制 database id（URL 里 `notion.so/<workspace>/<db_id>?v=...` 的 32 位那段；带不带 dash 都行）填到 Settings

**测试**：点 Settings → 集成 → Notion → 测试推送，会在 database 里创建一个标题为「映话 · Test Push」的 page。

### 2. Slack

1. 打开 [Slack Apps](https://api.slack.com/apps) → Create New App → From scratch
2. 选目标 workspace，名字比如 "映话"
3. 左栏 → Incoming Webhooks → Activate Incoming Webhooks → Add New Webhook to Workspace
4. 选目标 channel（比如 `#meetings`），授权后复制 Webhook URL
5. 把 URL 填到 Settings → 集成 → Slack

**安全**：映话强制校验 Webhook URL 必须指向 `hooks.slack.com`，避免用户误填第三方 endpoint 被劫持。

### 3. Custom Webhook

1. 准备一个 HTTPS endpoint（`http://` 一律拒绝）
2. 把 URL 填到 Settings → 集成 → Custom Webhook
3. （强烈建议）填一个 HMAC 共享密钥 → 映话会用它对 body 算 HMAC-SHA256，写到 `X-Yinghua-Signature` header
4. 接收端用相同密钥 + 原始 body 验签（见下方「接收端验证」）

---

## 接收端验证（Custom Webhook）

**Headers（映话自动加）**：
- `Content-Type: application/json`
- `X-Yinghua-Event: yinghua.summary.created`
- `X-Yinghua-Timestamp: <unix_millis>`（接收端可对比当前时间，>5min 视为回放）
- `X-Yinghua-Signature: sha256=<hex>`（仅在 secret 非空时存在）
- `User-Agent: yinghua-summary/1.0`

**Body**（示例）：
```json
{
  "event": "yinghua.summary.created",
  "fileName": "张三-前端-终面",
  "recordedAt": "2026-08-23T14:30:00Z",
  "summary": {
    "keyMoments": ["..."],
    "decisions": ["..."],
    "actionItems": ["..."],
    "openQuestions": ["..."]
  }
}
```

**Node.js 验签示例**：
```js
import crypto from 'node:crypto';

const SECRET = process.env.YINGHUA_SECRET; // 和 Settings 里填的一样
const rawBody = await req.text();
const received = req.headers.get('X-Yinghua-Signature')?.replace('sha256=', '');
const expected = crypto.createHmac('sha256', SECRET).update(rawBody).digest('hex');

if (!crypto.timingSafeEqual(Buffer.from(received), Buffer.from(expected))) {
  return new Response('bad signature', { status: 401 });
}
```

**Cloudflare Workers 验签示例**：
```ts
const SECRET = env.YINGHUA_SECRET;
const raw = await request.text();
const receivedSig = request.headers.get('X-Yinghua-Signature')?.replace('sha256=', '');
const key = await crypto.subtle.importKey(
  'raw', new TextEncoder().encode(SECRET),
  { name: 'HMAC', hash: 'SHA-256' }, false, ['sign']
);
const sigBuf = await crypto.subtle.sign('HMAC', key, new TextEncoder().encode(raw));
const expected = Array.from(new Uint8Array(sigBuf))
  .map(b => b.toString(16).padStart(2, '0')).join('');

if (receivedSig !== expected) return new Response('bad signature', { status: 401 });
```

---

## 隐私承诺

- **API key / Webhook URL / Secret 全部走 macOS Keychain**（service: `com.yinghua.apikey`）
- **不上传**：映话没有任何中转服务器，AI 总结生成完直接 POST 到你配的目标
- **不发送音频**：只发 4 段结构化文本（keyMoments / decisions / actionItems / openQuestions）
- **HTTPS 强制**：所有 endpoint 必须 `https://`，否则 `IntegrationError.insecureEndpoint` 拒绝
- **App Sandbox + Hardened Runtime** 已开
- **网络出口**：所有推送请求走 `URLSession.shared`，继承 App 的 `com.apple.security.network.client` entitlement

---

## 故障排查

| 现象 | 原因 | 解决 |
|------|------|------|
| 测试推送失败：`notConfigured: API key` | 没填 token | 在 Settings → 集成 → Notion 填入 Internal Integration Token |
| Notion 推送返回 401 | Token 失效或被撤销 | 重新生成 integration token |
| Notion 推送返回 404 | database id 错 / integration 没被加到 database | 1) 重新复制 database id 2) database 页面 → `···` → Connections → 加 integration |
| Notion 推送返回 400 `body validation failed` | database 缺 properties | 给 database 加 `Name (title)` + `Date (date)` + `Key Moments (number)` + `Action Items (number)` |
| Slack 推送返回 403 | webhook 被 workspace 禁用 | 重新激活 Incoming Webhook |
| Slack 推送返回 404 | webhook URL 错 | 重新走 Incoming Webhooks 配置流程 |
| Custom Webhook 推送返回 `insecureEndpoint` | URL 是 http:// | 改成 https:// |
| Custom Webhook 推送成功但接收端 401 | secret 不一致 | 对照 Settings → Custom Webhook 和接收端的 `YINGHUA_SECRET` |
| 启用 toggle 开了但没看到推送 | 启用的 provider 没配凭据 | 看 Settings 卡片右侧 pill：「未配置」表示缺凭据 |
| 推送静默无反应 | 没启用任何 provider | 至少打开 1 个 toggle |

---

## 文件清单

| 类型 | 路径 | 作用 |
|------|------|------|
| 新建 | `code/Yinghua/Yinghua/Integrations/IntegrationProvider.swift` | 3 个 provider 的 enum（displayName / icon / keychain 前缀） |
| 新建 | `code/Yinghua/Yinghua/Integrations/IntegrationsManager.swift` | 总线：并发 fan-out + 错误聚合 + 测活 |
| 新建 | `code/Yinghua/Yinghua/Integrations/IntegrationError.swift` | 推送错误（4 个 case） |
| 新建 | `code/Yinghua/Yinghua/Integrations/NotionIntegration.swift` | Notion Pages API 推送 |
| 新建 | `code/Yinghua/Yinghua/Integrations/SlackIntegration.swift` | Slack Incoming Webhook + Block Kit |
| 新建 | `code/Yinghua/Yinghua/Integrations/WebhookIntegration.swift` | 通用 JSON + HMAC-SHA256 签名 |
| 新建 | `code/Yinghua/Yinghua/Views/Settings/IntegrationsSettingsView.swift` | Settings 集成 tab（3 卡 + toggle + 测试推送） |
| 新建 | `code/Yinghua/Yinghua/Integrations/README.md` | 本文件 |
| 修改 | `code/Yinghua/Yinghua/Models/AppState.swift` | 加 `integrationsManager` 持有；`generateSummary()` 完成后 fan-out |
| 修改 | `code/Yinghua/Yinghua/Views/Settings/SettingsView.swift` | 加 `.integrations` case + 渲染分支；窗口加高 640→640 宽度 640→700 容纳 5 个 tab |
| 修改 | `code/Yinghua/Yinghua/API/KeychainService.swift` | `saveString / loadString / deleteItem` 三个底层 helper 从 `private` 提升为 `internal`，让集成模块可写自己的 account |
