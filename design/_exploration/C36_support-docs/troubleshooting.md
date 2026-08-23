# 映话 Troubleshooting

> 8 个最高频问题 · 每个 诊断步骤 → 修法 · 引用实际代码路径
> 来源：映话 C29 `/support/troubleshooting` 页面母本。

---

## 01. 录音只录到我 / 录不到对方

**症状**：控制面板显示 REC 红点 ✅，但回放只有自己声音，没有会议对方。

**根因**：屏幕录制权限（`NSScreenCaptureUsageDescription`）没开。这是录系统音频的**前提**——只开麦克风权限，映话只能录 mic。

**诊断**：
1. 打开 **系统设置 → 隐私与安全性 → 屏幕录制**
2. 翻列表找「映话」—— 找到看 toggle 是不是 ✅ 蓝
3. 如果完全没看到映话：说明从未触发过授权弹窗（点过一次「拒绝」/ 装 app 后从没尝试录系统音频）

**修法**：
- 找到但关着 → 打开 toggle → **完全退出映话**（⌘Q，**不是关窗口**）→ 重新打开
- 完全没找到 → 控制面板点 🔊 system audio toggle，会重新触发系统弹窗；弹窗里点「打开系统设置」授权，再 ⌘Q 重启映话

> 引用：`code/Yinghua/.../Audio/AudioCaptureService.swift:228-233`（`CGPreflightScreenCaptureAccess` 检查）

> **重要**：macOS 限制——屏幕录制权限授权后，**必须**重启映话才生效，不是开关 toggle 就完事。
>
> 设计约束来源：`design/design-doc.md` v2.0 §9.3「本地优先」+ §9.1「屏幕录制 entitlement」。

---

## 02. 转录全是乱码 / 不出文字

**症状**：REC 红点正常，转录面板一直空，或者出来一堆乱字符 / 韩文 / emoji。

**根因**：macOS 26 `SpeechAnalyzer` 没准备好中文（或英文）模型。模型是懒加载——首次用某 locale 才会下载。

**诊断**：
1. **系统设置 → 通用 → 语言与地区 → 偏好语言**，确认「简体中文」或「English」在列表里（不是只放「中文（香港）」之类的次要 locale）
2. 打开 **活动监视器**，搜 `Speech` —— 如果有 `speechtranscriptiond` 进程在跑且占 CPU，说明模型在加载
3. 第一次加载时控制面板可能弹「SpeechAnalyzer 准备中…」小 toast

**修法**：
- 加系统语言：系统设置 → 通用 → 语言与地区 → 「+」加 Simplified Chinese 或 English
- 触发模型下载：控制面板点一次「试录 5 秒」—— 首次会触发 `AssetInventory.assetInstallationRequest`，约 500MB 下载（取决于 locale），几分钟
- 下载完会存到 `~/Library/AssetsV2/`（系统管，用户别动）

> 引用：`code/Yinghua/.../Transcription/TranscriptionService.swift:194-208`（`ensureModuleReady` + `downloadAndInstall`）

> **不要**在下载中拔网线，否则 model 会半残。下次启动还会重新触发。

---

## 03. AI 总结报 "Invalid key"

**症状**：点「生成 AI 总结」后弹红色错误条 `Invalid key` 或 `401 Unauthorized`。

**诊断**（按顺序查）：
1. **设置 → API → Test connection** —— 单独测一遍 key + endpoint 连通性
2. 看 key 前缀：
   - OpenAI 官方：以 `sk-` 开头（例：`sk-proj-...`）
   - Anthropic 官方：以 `sk-ant-` 开头（例：`sk-ant-api03-...`）
   - Custom（自部署 / 第三方）：**没有固定前缀**，看你的代理服务
3. 看 provider 选对没：
   - key 是 `sk-...` 但 provider 选了 Anthropic → 必报 invalid
   - key 是 `sk-ant-...` 但 provider 选了 OpenAI → 必报 invalid
4. 余额：Anthropic / OpenAI 控制台看 credit balance 不是 0

**修法**：
- 改 provider：设置 → API → Provider 下拉
- 改 key：清空输入框，重新粘贴（**注意**前后空格——粘贴自 1Password 经常带不可见字符）
- 用「Show」按钮肉眼检查一遍

> 引用：`code/Yinghua/.../API/SummaryService.swift:32-49`（`Config.resolve` 校验） + `code/Yinghua/.../API/APIProvider.swift:60-66`（鉴权 scheme 区分 bearer vs x-api-key）

---

## 04. 录制无声

**症状**：录了 30 分钟，回放发现 .caf 文件里只有静音（或 RMS 永远接近 0）。

**诊断**：
1. **系统设置 → 声音 → 输入** —— 看输入设备选对没（别选到不存在的蓝牙耳机）
2. 控制面板 VU 表 —— 说话时 mic toggle 旁的 bar 应该跳，不跳 = mic 没拾音
3. 控制面板录音中 toggle 状态：🎙️ + 🔊 **两个都得开**（或至少一个）
4. 看下控制面板右上角有没有红色 ⚠️ 提示 —— `AudioCaptureError.lastError` 会有具体信息

**修法**：
- 99% 情况是 macOS 隐私权限失效 —— ⌘Q 完全退出映话，重开
- 检查输入音量：系统设置 → 声音 → 输入 → 拖输入音量滑块到 80%+
- 蓝牙耳机注意：macOS 14+ 蓝牙音频有 100ms 延迟属正常，不是 bug

> 引用：`code/Yinghua/.../Audio/AudioCaptureService.swift:174-205`（麦克风 tap + 权限流）

---

## 05. macOS 弹窗「映话想要访问麦克风」不显示

**症状**：点 mic toggle，没看到系统弹窗，状态栏直接显示「已拒绝」。

**根因**：以前被拒绝过（点过「不允许」），macOS 不会重弹。

**修法**（手动加）：
1. **系统设置 → 隐私与安全性 → 麦克风**
2. 找「映话」—— 没找到就点窗口左下角 🔒 解锁（可能要输密码）
3. 手动点 `+` 按钮 → 应用程序里选 Yinghua.app
4. toggle 开 → ⌘Q 重启映话

如果「映话」出现在列表里但 toggle 灰：点 🔒 解锁后再开。

> 引用：`code/Yinghua/.../Permissions/PermissionService.swift:118-125`（`requestMicrophone` 走 `AVCaptureDevice.requestAccess`）

> **不要**拖 Yinghua.app 到 /Applications/ 以外的位置——macOS 沙盒按 app 路径做隔离，挪位置相当于「换了个 app」，权限全失效。

---

## 06. Dock 图标不显示

**症状**：映话在跑（菜单栏有图标），但 Dock 没有图标。

**诊断**：
1. 菜单栏右上角有没有 圆形 icon？有 = 映话在跑
2. 系统设置 → 程序坞 → 「在程序坞中显示最近使用的应用」勾上没
3. 是不是全屏 app 在前台？全屏下 Dock 自动隐藏

**修法**：
- 90% 是因为装了 v0.1 之后升了 v0.2：旧进程在 dock 占着，新进程窗口进不Dock
  - ⌘Q 完全退出 → 活动监视器搜 `Yinghua` 确认 0 进程 → 重新打开
- 设置 → 通用 → 「在 Dock 中显示映话」toggle（v0.2 加的——v0.1 默认显示，v0.2 默认隐藏因为是「menu bar 优先」形态）

> 引用：`code/Yinghua/.../YinghuaApp.swift:5 个 scene`（MenuBarExtra vs WindowGroup 优先级）

---

## 07. 屏幕录制权限授权后还是不能录

**症状**：系统设置里 toggle ✅ 蓝了，但映话控制面板的 system audio toggle 一直是「需要权限」。

**根因**：**这是 macOS 的限制，不是映话 bug**。屏幕录制权限授权后，新授权**只在**用户**重启 app** 后生效。

**修法**：
1. ⌘Q 完全退出（确认菜单栏 icon 消失）
2. 重新打开映话（Spotlight 搜「映话」回车）
3. 重新点 system audio toggle —— 现在应该 OK

> 引用：`code/Yinghua/.../Permissions/PermissionService.swift:127-144`（`CGPreflightScreenCaptureAccess` 返回 true 只在重启后）
>
> **设计 doc 注**：这种「授权 → 重启」限制写在 `design/design-doc.md` v2.0 §9.1 实现注意里（dev 参考）。从 UX 角度我们没找到绕过方案——这是 macOS TCC 的硬约束，不是映话的设计选择。

> **不要**用「退出登录」或「重启 Mac」来「解决」—— 那样会触发 macOS 权限缓存全清，下次还要重新授权一次。

---

## 08. 升级到 v0.2 后旧录音打不开

**症状**：v0.1 录的会议在 v0.2 打开是乱码 / 显示「格式不支持」/ 只能播一半。

**根因**：v0.2 改了录音文件结构（从 raw PCM 升级到带 metadata 的 CAF 容器，存储 `speaker-id-mapping` 和 `device-info`）。

**诊断**：
- 控制面板的 v0.1 录音卡：是不是显示「⚠️ 旧版本格式」小角标
- 打开文件：Finder → 选中 .caf → 显式信息 → 看「音频格式」是不是 `Linear PCM, 16-bit, 16 kHz, mono`（v0.1） vs `CAF, 16 kHz, mono, float32`（v0.2）

**修法**：
- 映话**自动迁移** v0.1 文件 —— 启动时扫 `recordings/` 目录，逐个转换
- 转换过程有进度条（在 onboarding 完成后弹的小窗）
- 如果某个文件转换失败：控制面板 → 该会议右上角 ⋯ → 「Convert manually」会跳到具体错误

> 引用：C13 `Models/AppState.swift` 的 v0.1→v0.2 migration 逻辑（v0.1: `rec-<ts>.pcm`，v0.2: `rec-<ts>.caf`）+ C13 `transcript-retention-days = 30`（30 天前的旧文件不迁移，直接归档）

> 30 天前的 v0.1 录音：自动归档到 `~/Library/Application Support/Yinghua/archive/`，不会丢，但需要手动点「Restore」才会进新版本。

---

*没解决？见 [contact.md](./contact.md) · 引用 code/Yinghua/ 实际代码路径*
