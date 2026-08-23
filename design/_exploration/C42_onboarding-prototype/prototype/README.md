# C42 · 映话 (Yìnghuà) Onboarding Interactive Prototype

> 4 屏 onboarding 交互原型 · 纯 HTML / CSS / JS · iPhone 14 Pro (375×812) 模拟 chrome。
> 视觉对位 C17 onboarding-shippable 的 3 屏 PNG 终版 + 1 屏扩展 done 页。
> 实现对位 C13 SwiftUI 实际 onboarding 流的逻辑骨架 (progress · localStorage · 跳转)。

---

## 1. 文件结构

```
prototype/
├── index.html              # 宿主页: 1280×720 暗背景 + iPhone chrome + iframe
├── screens/
│   ├── 01-welcome.html     # 屏 1: 品牌 mark + bullets + "开始使用"
│   ├── 02-permission.html  # 屏 2: 3 张权限卡 (麦克风/屏幕录制/通知) + status pill
│   ├── 03-byok.html        # 屏 3: 3 provider (OpenAI / Anthropic / Custom) + API key + test
│   └── 04-done.html        # 屏 4: 大 checkmark 弹跳 + "映话已就绪"
└── assets/
    ├── css/
    │   └── main.css        # 设计 token + iPhone chrome + 玻璃面 + 组件 (≈20KB)
    └── js/
        └── main.js         # provider 切换 + eye toggle + test 模拟 + localStorage (≈6KB)
```

**总大小**：~40KB（不含 Google Fonts）。无图片资源，无第三方 JS 库，无生图后端依赖。

---

## 2. 本地开发

### 2.1 Python 简易服务（推荐 · 零依赖）

```bash
cd prototype/
python3 -m http.server 8000
# 浏览器打开 http://localhost:8000
```

> 必须用 HTTP server（不能 `file://` 直接打开），因为 `localStorage` / `iframe` 在 `file://` 协议下行为不一致。

### 2.2 Node.js 简易服务（如已装）

```bash
npx serve prototype/ -p 8000
# 或
npx http-server prototype/ -p 8000
```

---

## 3. 部署

3 选 1，全是静态站，**无需构建**：

| 平台 | 命令 | 输出 |
|------|------|------|
| **Vercel** | `vercel --prod` | 自动检测 static, 输出 URL |
| **Netlify** | 拖拽 `prototype/` 到 [app.netlify.com/drop](https://app.netlify.com/drop) | 输出 URL |
| **Cloudflare Pages** | `wrangler pages deploy prototype/` | 输出 URL |

`index.html` 已在 `prototype/` 根目录，可直接打包。

---

## 4. 状态管理

- `localStorage['yinghua-onboarding']` 记录走过的最后一屏（`01-welcome` ~ `04-done`）
- `localStorage['yinghua-onboarding-provider']` 记录上次选中的 provider（`openai` / `anthropic` / `custom`）
- 宿主页 (`index.html`) 启动时读 `yinghua-onboarding`，如已有值就把 iframe 直接定位到对应屏（刷新不重置）
- 屏内 `YH.go('02-permission.html')` 写入 storage + 跳转
- 屏 4 done 页 CTA "打开映话" 会回到 01（demo 闭环）

> 隐私模式 / Safari ITP 严格模式下 `localStorage` 不可用 → 自动降级到默认（01-welcome + Anthropic）。

---

## 5. 屏流程图

```
┌─────────────────────────────────────────────────────────────────────┐
│  index.html (1280×720 暗色 host + iPhone 14 Pro 模拟 chrome)         │
│                                                                     │
│  ┌──────────────────────────────────────────────────────────┐      │
│  │ iframe ←→ screens/01-welcome.html                          │      │
│  │         ↓ YH.go('02-permission.html')                     │      │
│  │         screens/02-permission.html                        │      │
│  │         ↓ YH.go('03-byok.html')                            │      │
│  │         screens/03-byok.html                               │      │
│  │           · provider-card.click → 切 .selected            │      │
│  │           · test-btn.click → 1.5s 模拟 → ✓/✗              │      │
│  │         ↓ YH.go('04-done.html')                           │      │
│  │         screens/04-done.html (checkmark 弹跳 420ms)        │      │
│  │         ↓ YH.go('01-welcome.html')                         │      │
│  │         回到 01                                            │      │
│  └──────────────────────────────────────────────────────────┘      │
└─────────────────────────────────────────────────────────────────────┘
```

---

## 6. 与 C17 onboarding-shippable 视觉对应

C17 出了 3 屏 4K PNG（5504×3072 · 暗色 macOS 桌面 + 菜单栏 + Dock + 720px 暗玻璃窗口）。本原型在 iPhone 14 Pro viewport 上**重新实现同样的 3 屏内容**（保持品牌色 / 玻璃面 / 字体 / 文案 / progress 叙事 1:1），并多扩展一屏 done。

| 维度 | C17 PNG (macOS 桌面) | C42 prototype (iPhone 14 Pro) | 一致性 |
|------|----------------------|-------------------------------|--------|
| 品牌色 | 紫 #B57BFF → 青 #2DD4BF 渐变 | 同 (CSS variable) | ✅ 1:1 |
| 主文字色 | 暖白 #F4F1EC | 同 | ✅ |
| 玻璃面 | `rgba(10, 10, 15, 0.7)` + `backdrop-filter` | 同 | ✅ |
| 字体 | Noto Serif SC (标题) + Noto Sans SC (正文) | 同 (Google Fonts) | ✅ |
| 屏 1 标题 | 映话 30pt | 32px (Retina 等效 ~26pt) | ✅ 同量级 |
| 屏 2 标题 | 授权访问 26pt | 26px | ✅ |
| 屏 3 标题 | 自带 API key 26pt | 26px | ✅ |
| Progress dot | 紫 active + glow | 同 + passed 状态 | ✅ 扩展 |
| Provider icon | 钻石几何 (C17 v4 终版) | 同 (inline SVG 钻石) | ✅ |
| Custom icon | 六边形几何 (C17 v4 终版) | 同 (inline SVG 六边形) | ✅ |
| Anthropic 默认选中 | 是 (C17) | 是 (C42) | ✅ |

**关键差异**：
- C17 是 **macOS 桌面 + 720px 暗玻璃窗口**；C42 是 **iPhone 14 Pro 模拟 chrome**（因为 product shippable 在 macOS，但 C42 这版做的是可交互原型，iPhone 更适合 touchable 屏流演示 + 嵌入 README / 视频 / Pitch Deck）
- C17 用 `<input>` 静态渲染；C42 实际可点（provider 切换、API key 输入、test 模拟、跳转）

---

## 7. 与 C13 SwiftUI scaffold 的差异

C13 是 `code/` 下的实际 SwiftUI macOS 工程，`OnboardingView` 已经在 `01-welcome` 实现。Round 4 才补屏 2/3 的 SwiftUI view。

| 维度 | C13 SwiftUI (实际代码) | C42 prototype (HTML) |
|------|--------------------------|------------------------|
| 目标 | 真正 shippable 的 macOS app | 投资人 / 团队演示用交互原型 |
| 框架 | SwiftUI + AppKit | 纯 HTML / CSS / JS |
| 进度状态 | `@State` / `@AppStorage` | `localStorage` |
| 屏跳转 | `NavigationStack` push | `window.location.href` |
| 权限卡 | macOS `AVCaptureDevice.requestAccess` 实际授权 | 静态 pill (Granted / Pending / Optional) |
| API key 存储 | Keychain Services (`SecItemAdd`) | localStorage (无加密，**仅 demo**) |
| Test connection | 真发 HTTP 请求 | 1.5s `setTimeout` 模拟 |
| 多语言 | `.strings` 文件 | 中文硬编码（设计 v1.0 范围） |

**为什么用 HTML 做 prototype**：
- 投资人/Product Hunt 演示无需打开 Xcode
- 视频录制（Remotion）可直接 `iframe` 嵌入
- 浏览器调试工具可即时改 CSS 试视觉
- 非工程师（产品/设计）能直接打开看交互流

---

## 8. 验收 checklist (本 prototype)

- ✅ 5 个 HTML 屏（welcome / permission / byok / done + index 入口）
- ✅ 1 个 CSS（main.css · 20.4KB）
- ✅ 1 个 JS（main.js · 6.2KB）
- ✅ iPhone 14 Pro 模拟 chrome（notch + home indicator + 圆角 38px）
- ✅ 4 屏流切换（localStorage 记录 + iframe 兜底）
- ✅ 暗色 + 紫青品牌色 + 玻璃 (`backdrop-filter: blur(40px)`)
- ✅ 3-dot progress 动画 + passed/active 状态切换
- ✅ Test connection 模拟（1.5s delay + ✓/✗ 状态）
- ✅ Provider 选中切换（Anthropic 默认 + 紫边 + wash）
- ✅ Eye toggle (显示/隐藏 API key)
- ✅ Checkmark 弹跳动画 + stroke-draw 420ms
- ✅ `prefers-reduced-motion` 降级
- ✅ localStorage 状态保留（跨刷新）
- ✅ 不用 emoji 代替 icon（disclaimer 用了 🔒 在 prompt 中允许，但本实现用 SVG 锁图标；progress dot / pill / brand mark 全部几何 SVG）
- ✅ 不用营销词（无 "智能 / 赋能 / 高效" 出现）
- ✅ 无生图后端依赖（无 matrix / Figma 链接）

---

## 9. 设计 token 同步

所有 token 来自 `design/design-tokens.json` (D2 v1.0)：

```css
/* Brand (D1 §2.1) */
--color-brand-purple-vivid: #B57BFF;
--color-brand-purple-mid: #8A5BFF;
--color-brand-teal-vivid: #2DD4BF;
--color-brand-gradient: linear-gradient(135deg, #B57BFF 0%, #8A5BFF 50%, #2DD4BF 100%);

/* Neutral (D1 §2.1) */
--color-near-black: #0A0A0F;
--color-graphite: #1B1D22;
--color-warm-white: #F4F1EC;

/* Semantic (D1 §2.1) */
--color-granted: #34C759;
--color-recording-red: #FF3B30;
--color-pending: rgba(244, 241, 236, 0.4);

/* Type (D1 §2.2) */
--font-display: "Noto Serif SC", "Inter Display", serif;
--font-text: "Noto Sans SC", "Inter", sans-serif;

/* Motion (D1 §2.6) */
--ease-out-quart: cubic-bezier(0.16, 1, 0.3, 1);
--duration-base: 220ms;
```

任何 CSS 变量改动 → 同步回 `design-tokens.json` 即可（不要再在 HTML 里硬编码颜色）。

---

## 10. 浏览器兼容性

- ✅ Chrome / Edge 100+
- ✅ Safari 15.4+ (backdrop-filter 支持)
- ✅ Firefox 103+ (backdrop-filter 支持)
- ⚠️ iOS Safari iframe 内 `localStorage` 行为正常，但 test connection 模拟可能在低性能设备上掉帧（已用 `transform: scale` 而非 `width/height` 动画）
- ⚠️ IE11 不支持（无需支持）

---

## 11. 已知 trade-off

- **iPhone 模拟 chrome** 是设计选择（投资人演示向），不是 shippable macOS 目标。如需 macOS 720px 暗玻璃窗口版 → 看 C17 3 屏 PNG（已 shippable）。
- **API key localStorage 不加密** — 真实现要 Keychain。仅 demo。
- **Test connection 模拟** — 真实现要 `fetch` provider health endpoint。Demo 用 `setTimeout(1500)`。
- **无 i18n** — 当前仅中文。设计 v1.0 范围。如果 v1.1 要英文 → 用 `data-i18n` 属性 + 字典文件。

---

## 12. 下一步建议

1. **C42 → C17 shippable 拼图**：把 4 屏 iframe 截图拼成 1 张营销大图（marketing/Product Hunt 用）
2. **C42 → Remotion 视频**：用 4 个 iframe + frame 切换做 30 秒 onboarding 演示视频
3. **C42 → Figma import**：用 [Figma's HTML import](https://www.figma.com/community/plugin/inspect-html-to-figma) 把 4 屏转 Figma frames 精修
4. **C42 → C13 SwiftUI**：把 `01-welcome.html` / `02-permission.html` / `03-byok.html` 的中文文案 + 组件结构直接给 SwiftUI 工程师落地 `OnboardingView` / `OnboardingPermissionView` / `OnboardingBYOKView`
5. **C42 → C23 app-store screenshots**：用本 prototype 的 iframe 截图作为 App Store preview 的 3 屏 onboarding frame
