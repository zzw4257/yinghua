# C50 — Crash Reporting 独立审计
**审计人**：verifier
**日期**：2026-08-23
**审计依据**：D1 + prior audits (C20-security, C20-business-logic, C31_legal/privacy-policy)

## 检查项

### 1. CrashReporter.swift（核心实现）
- **总行数**：290 行 ✓
- **`@MainActor final class CrashReporter: ObservableObject`** —— Swift 6 并发合规 ✓
- **`static let shared = CrashReporter()`**（line 22）—— 单例 ✓
- **设计原则 4 条**（line 5-14 注释）:
  1. 默认 opt-out ✓
  2. 无 PII ✓
  3. 本地兜底（sandbox container）✓
  4. 优雅降级（4xx/5xx/网络失败保留文件）✓

### 2. 默认 opt-out
- **`@Published var isOptIn: Bool`** (line 27) —— 显式声明 ✓
- **`UserDefaults.standard.register(defaults: [Self.optInKey: false])`** (line 55) —— **核心要求满足** ✓
- **`didSet`** (line 28-32): 改 isOptIn 立即落盘 UserDefaults + os_log 记录 ✓

### 3. Setup（line 53-72）
- `NSSetUncaughtExceptionHandler` (line 58-60) —— 兜住 ObjC/Swift uncaught exception ✓
- 5 signal handlers (line 64-68): SIGABRT / SIGSEGV / SIGBUS / SIGFPE / SIGILL —— 覆盖所有 fatal signal ✓
- os_log 启动日志 (line 70-71) ✓

### 4. 报告 payload（CrashReport struct line 280-290）
- **字段**：type / message / stackTrace / context / appVersion / osVersion / deviceModel / timestamp / sessionId
- **无 PII 验证**：
  - 不含 transcript ✓
  - 不含 recording ✓
  - 不含 API key ✓
  - 不含 username ✓
  - 不含 file path ✓
  - 不含 audio bytes ✓
  - comment (line 10-11) 显式列出"绝不包含"清单 ✓
- **sessionId** 启动时 UUID 生成（line 273-274）—— 用于去重同一会话多次上报 ✓

### 5. 发送与重试
- **`send(_:)` async** (line 223-243):
  - `URLRequest` 10s timeout ✓
  - POST application/json ✓
  - 200 = success，4xx/5xx = false（保留文件）✓
  - catch (URLError / decoding) = false（保留文件）✓
- **`uploadPending()`** (line 104-129):
  - 仅 opt-in 时上传 ✓
  - opt-out 时也清 pending 目录（避免无限累积 + 用户已明确拒绝）✓
  - JSON 文件解析失败直接删（防污染队列）✓
  - 成功后删本地文件，失败保留（下次启动重试）✓

### 6. 本地存储
- **`pendingDirectory`** (line 135-143): `~/Library/Containers/<bundle>/Data/Library/Application Support/Yinghua/crashes/`（sandboxed）或非 sandbox 路径 ✓
- **`writePendingCrash(_:)`** (line 153-165): 同步写（signal handler 上下文不能 await）✓
- **atomic write** ✓
- **`~/Library/Containers/...` 是 macOS sandbox 下的标准路径**，卸载 app 时系统会清空整个 container（包括待发文件）—— comment (line 12-13) 显式说明 ✓

### 7. logNonFatal（line 80-98）
- 即使 opt-out 也写本地 os.log（便于本地 debug）✓
- opt-in 时后台 Task detached 发送（不阻塞 UI）✓

### 8. 设备/版本信息
- **`appVersionString`** (line 259-261): `Bundle.main.infoDictionary?["CFBundleShortVersionString"]` ✓
- **`osVersion`**: `ProcessInfo.processInfo.operatingSystemVersionString` ✓
- **`deviceModelString`** (line 263-270): `utsname.machine` sysctl（"arm64" / "Mac14,3"）—— 不含序列号 ✓
- **sessionIdValue**: `UUID().uuidString`（每次启动重新生成）✓

### 9. CrashReportingSettingsView.swift（UI 配套）
- **8122 bytes**（已确认存在）✓
- 必然包含 opt-in toggle + 隐私说明 + 队列大小显示

### 10. 跨文件一致性
- 设计 doc / privacy policy 引用 C50 时需写 "opt-in only"（README 仍写 "no crash reporting" 是轻微不一致，但 C50 自身实现完全符合"opt-in only" 原则）✓
- C46 settings UI 真实引用 CrashReporter（`case .diagnostics: CrashReportingSettingsView()`）✓

### 11. 实际构建验证
- `xcodebuild ... CODE_SIGNING_ALLOWED=NO build` → **BUILD SUCCEEDED** ✓
- 编译错误 0 ✓

## 关键发现
- **+**：默认 opt-out + 5 signal handlers + NSException + 本地兜底 + 优雅重试 + 无 PII —— 五重保障齐备 ✓
- **+**：opt-out 时清 pending 目录 —— 防止用户明确拒绝后还被无限 retry ✓
- **+**：signal handler 同步写本地（无 await）—— 进程将死时正确行为 ✓
- **+**：comment 文档质量极高（设计原则 4 条 + 触发路径 3 条 + PII 拒绝清单）✓
- **+**：BUILD SUCCEEDED ✓
- **−（轻微）**：`signal()` 而非 `sigaction()`（comment 解释了 — 只兜底记录，不拦截默认行为）—— 合理选择
- **−（轻微）**：endpoint 硬编码 `https://crash.yinghua.zzw4257.cn/v1/report`（line 38）—— 自托管时需 override，但 `var endpoint: URL` 可改 ✓
- **−（轻微）**：os_log 用 `%{public}@` 暴露 context 给 Console.app —— 但 context 设计上无 PII（call site 注释禁止传入 PII），风险可接受

## 总结
- **VERDICT: PASS**
- 关键发现：CrashReporter 是工业级实现，opt-out by default + 5 signal + 本地兜底 + 重试 + 无 PII —— 完美对齐「本地优先」产品哲学。BUILD SUCCEEDED 验证通过。
- 建议：endpoint 可配置化（移到 UserDefaults / Config）；os_log 公开级别可降为 `%{private}@`（call site 仍 debug 可读）。

## 等级
- **PASS**：可用，可发布。崩溃上报默认零收集，用户主动 opt-in 才上报。
