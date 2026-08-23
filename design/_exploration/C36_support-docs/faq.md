# 映话 FAQ

> 10 个最常见用户问题。每个 100-200 字 · 真实用户视角 · 没有营销词。
> 来源：映话 C29 marketing website `/support` 页面内容母本。

---

## 01. 映话支持哪些 macOS 版本？

映话需要 **macOS 26 Tahoe 或更新**，且只能在 **Apple Silicon**（M1 / M2 / M3 / M4 及更新）上跑。

为什么是 26？因为我们重度依赖 macOS 26 才有的 `SpeechAnalyzer` + `SpeechTranscriber` on-device 引擎。Intel Mac 用不了——官方放弃支持，App Store 会按机器架构屏蔽下载。

> 系统要求会跟 C30 app-store-metadata 完全对齐。如果你不确定自己 Mac 是什么芯片：点左上角  → 关于本机，看芯片那一行。

---

## 02. 映话是云端 AI 还是本地 AI？

**转录 100% 本地**。录音走 macOS 26 的 `SpeechAnalyzer` 引擎，原始音频和文字一行都不上传。

**AI 总结走你自带 key 的云端**。我们不跑 AI 推理——你输入自己的 Anthropic 或 OpenAI key，映话把 transcript 文本（不带音频）发到你 key 绑定的服务器，拿到 JSON 总结回填。

所以架构是：**本地转录 + BYOK 云端总结**。你的音频没离开 Mac，但总结这一步是云端 LLM 完成。

---

## 03. 我的 API key 安全吗？

存进 **macOS Keychain**（系统钥匙串），用 `kSecClassGenericPassword` 隔离（service = `com.yinghua.apikey`）。

**映话技术上**看不到**你的 key**：
- 不写文件（沙盒限制 + 我们没写这个逻辑）
- 不上传（代码里没有 key → 我们的服务器的路径）
- 不打印到日志（无 telemetry）

你卸载映话时，Keychain 里的条目会留着；要彻底删，**系统设置 → 密码**（macOS 15+ 改叫「密码」）里搜 `com.yinghua.apikey` 删掉。

参考：C31 隐私政策 §3.2 凭据存储。

---

## 04. 可以离线用吗？

**录制和转录可以完全离线**。这俩是纯本地流程——断网不影响。

**AI 总结需要联网**。但只是 HTTPS 调用 Anthropic / OpenAI，文本是 transcript（不带音频）。

具体场景：
- 飞机上录会议 ✅ —— 完整转录，结束回到酒店联网再生成总结
- 地铁里没网 ✅ —— 实时转录照常
- 弱网总结 ⚠️ —— 60 秒超时（`SummaryService.Config.requestTimeout = 60`），会报 `networkError`，可重试

---

## 05. 录音文件存哪里？

默认在 `~/Library/Application Support/Yinghua/recordings/`，文件名是 `rec-<unix_timestamp>.caf`（16kHz mono float32）。

**30 天后自动清理**（C13 `storage.transcript-retention-days = 30`，v2.0 token 化的硬约束）。30 天后只留 transcript 文本 + summary JSON，音频原文删。

要立刻删：控制面板右键 → Delete，或在 Finder 里手动删整个 `recordings/` 目录。

要永久保存：设置 → 存储 → 「永久保留录音」开关（Pro 功能）。

---

## 06. 录制的音频会被上传吗？

**永不。** 三个层面保证：

1. **代码层**：`AudioCaptureService` 的 buffer 只写本地 `AVAudioFile`，没有任何上传路径（搜 `upload` 关键字，0 命中）。
2. **网络层**：映话发起的网络请求只有两个——`api.openai.com` 和 `api.anthropic.com`（+ 你自配的 custom endpoint）。这俩请求的 body 里只有 transcript 文本，**没有音频字段**。
3. **沙箱层**：App Sandbox 默认禁止任意网络出口。要发包必须 entitlement 显式开。映话 entitlements 只允许 `api.openai.com` / `api.anthropic.com` 这俩 host。

如果你是逆向工程师 / 安全研究员：所有 HTTPS 请求都能在 Charles / Proxyman 里抓到，欢迎审计。

---

## 07. 映话支持哪些会议平台？

**所有能输出系统音频的 app**。因为映话用 `ScreenCaptureKit` 捕获系统音频流（不是 hook 某个特定 app）。

实测过的：
- Zoom / Google Meet / Microsoft Teams / Cisco Webex
- FaceTime / WhatsApp / Telegram / 微信（Mac 版）
- 任何浏览器（Chrome / Safari / Arc / Brave）里的 Web 会议
- 本地视频播放器（VLC / IINA / QuickTime）—— 用于回放录好的课程
- 任何 web app

只要系统有声音出来，映话就能录到。如果对方说话没声音——先查对方麦克风权限，别怀疑映话。

---

## 08. 可以录系统音频 + 麦克风同时吗？

可以。这是映话的核心能力，不是 add-on。

技术实现：
- **系统音频**：`ScreenCaptureKit` `SCStream` 捕获整个 display 的 audio mix（`excludesCurrentProcessAudio = true` 防自录）
- **麦克风**：`AVAudioEngine.inputNode` tap
- **混音**：两个流都转换到 16kHz mono float32 后写进同一个 `AVAudioFile`
- **说话人标记**：简化策略——mic 输入标 `[我]`，system audio 标 `[远端]`。v0.3 会接完整 speaker diarization。

控制面板的两个 toggle：🎙️ mic on/off + 🔊 system audio on/off。可以单独关 mic（线下会议不想录自己），但一般不单独关 system audio。

---

## 09. 说话人识别准确率？

映话用 macOS 26 `SpeechAnalyzer` 自带的 speaker diarization（v0.2 升级）。准确率取决于场景：

- **2 人对话**：95%+ —— 日常一对一通话几乎零错
- **3-4 人会议**：90%+ —— 偶尔会切错人，但切错窗口 < 2 秒，肉眼可读出来
- **5+ 人圆桌**：70%-80% —— 多人抢话时容易乱，开麦频次低的人尤其容易标错
- **嘈杂咖啡馆**：掉到 60% —— 不是映话的问题，是任何 ASR 都难

我们 v0.3 会加说话人手动重命名（已经标错的手动改），v0.4 上 LLM 后处理修正。

---

## 10. 如果 AI 总结错了？

**编辑 transcript → 重新生成总结**。这是 Pro 功能，但 v0.1 免费试用 30 天。

操作路径：会议结束 → Review 模式 → 直接改 transcript 文字（说话人标签也可改）→ 点「Regenerate」按钮 → 新总结覆盖旧的。

更进一步的 Pro 玩法：**自定义 system prompt**。设置 → AI 总结 → 「System prompt override」，你写自己的指令模板（比如「按 OKR 维度输出」「用 markdown 表格」「忽略寒暄部分」），映话会按你的 prompt 生成。

不满意时：点总结页底部的 👎 反馈按钮，把 transcript + 输出发给 support@yinghua.app，我们手动复盘迭代 prompt。

---

*没找到答案？见 [contact.md](./contact.md) · 引用 C30 / C31 / code/Yinghua/* 实际实现
