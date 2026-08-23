import Foundation
import os.log
import os.signpost

/// 映话 Crash Reporter —— **默认零收集**，用户可显式 opt-in 上传 crash report。
///
/// 设计原则（与 `design/_exploration/C31_legal/privacy-policy.md` §3.2 + 任务书一致）：
/// 1. **默认 opt-out**：`isOptIn` 初值 `false`，不向远端发送任何东西。
/// 2. **无 PII**：report 只含 type / message / stack trace / appVersion / osVersion / deviceModel / sessionId；
///    **绝不**包含 transcript、recording、API key、用户名、文件路径、音频字节。
/// 3. **本地兜底**：即使 opt-out 也把 fatal crash 写到 `~/Library/Containers/<bundle>/Data/Library/Application Support/Yinghua/crashes/`，
///    下次启动时 `uploadPending()` 会在用户已 opt-in 时才发送。这是 macOS sandbox 下的标准路径，
///    卸载 app 时系统会清空整个 container，包括这些待发文件。
/// 4. **优雅降级**：网络失败 / 4xx / 5xx → 文件保留，下次重试；endpoint 不可达时静默不打扰用户。
///
/// 触发路径：
/// - `setup()`：在 `YinghuaApp.init` 调用一次，注册 uncaughtException + signal handlers。
/// - `logNonFatal()`：service 层在 catch 块主动上报（SummaryService 等）。
/// - `uploadPending()`：`MainWindow.task` 在启动时调用，把上次未发的 fatal 上报出去。
@MainActor
final class CrashReporter: ObservableObject {
    static let shared = CrashReporter()

    // MARK: - Public state

    /// 用户的 opt-in 选择。改写即落盘 `UserDefaults`，handler 在下次写文件时会读到最新值。
    @Published var isOptIn: Bool = UserDefaults.standard.bool(forKey: CrashReporter.optInKey) {
        didSet {
            UserDefaults.standard.set(isOptIn, forKey: CrashReporter.optInKey)
            os_log("Crash reporting opt-in changed to %{public}@",
                   log: crashLog, type: .info, isOptIn ? "true" : "false")
        }
    }

    // MARK: - Configuration

    /// 远端 endpoint。可在测试或自托管时覆盖。
    var endpoint: URL = URL(string: "https://crash.yinghua.zzw4257.cn/v1/report")!

    // MARK: - Private

    private let crashLog = OSLog(subsystem: "app.yinghua.Yinghua", category: "crash")
    private static let optInKey = "yinghua.crash.optIn"

    private init() {}

    // MARK: - Setup

    /// 在 `YinghuaApp.init` 调用一次。
    /// - 写默认值到 `UserDefaults`（opt-out）
    /// - 注册 uncaughtException handler
    /// - 注册 fatal signal handler（SIGABRT / SIGSEGV / SIGBUS / SIGFPE / SIGILL）
    func setup() {
        // 默认值：opt-out
        UserDefaults.standard.register(defaults: [Self.optInKey: false])

        // Uncaught ObjC/Swift exception handler —— 在抛出线程同步运行
        NSSetUncaughtExceptionHandler { exception in
            CrashReporter.handleUncaughtException(exception)
        }

        // Fatal signal handlers —— 进程将死，只能做最保守的事情
        // 用 signal() 而非 sigaction() 是因为我们只想要兜底记录，不需要拦截默认行为
        signal(SIGABRT) { _ in CrashReporter.handleSignal("SIGABRT") }
        signal(SIGSEGV) { _ in CrashReporter.handleSignal("SIGSEGV") }
        signal(SIGBUS)  { _ in CrashReporter.handleSignal("SIGBUS") }
        signal(SIGFPE)  { _ in CrashReporter.handleSignal("SIGFPE") }
        signal(SIGILL)  { _ in CrashReporter.handleSignal("SIGILL") }

        os_log("CrashReporter initialized (opt-in=%{public}@)",
               log: crashLog, type: .info, isOptIn ? "true" : "false")
    }

    // MARK: - Non-fatal reporting (from catch blocks)

    /// 上报一个非致命错误。仅在 opt-in 时发送；否则仅写本地 os.log。
    /// - Parameters:
    ///   - error: 任意 Error
    ///   - context: 业务上下文（如 "function": "generateSummary"）；**禁止**传入 PII
    func logNonFatal(_ error: Error, context: [String: String] = [:]) {
        // 即使 opt-out 也要写本地 log，便于本地 debug
        os_log("non-fatal error: %{public}@ context=%{public}@",
               log: crashLog, type: .error,
               error.localizedDescription, context.description)

        guard isOptIn else { return }

        let report = makeReport(
            type: "non_fatal",
            message: error.localizedDescription,
            stackTrace: Thread.callStackSymbols.joined(separator: "\n"),
            context: context
        )

        Task.detached(priority: .background) {
            _ = await CrashReporter.shared.send(report)
        }
    }

    // MARK: - Pending upload (called on app launch)

    /// 启动时把上次未发的 fatal crash 上报。**只在 opt-in 时才发送**。
    /// 成功上传后删除本地文件；失败保留，下一次启动重试。
    func uploadPending() async {
        guard isOptIn else {
            // opt-out 时也清掉旧 pending 文件（避免无限累积，且用户已经明确拒绝）
            deletePendingDirectory()
            return
        }

        let dir = pendingDirectory
        guard let files = try? FileManager.default.contentsOfDirectory(
            at: dir, includingPropertiesForKeys: [.creationDateKey]
        ) else { return }

        for file in files where file.pathExtension == "json" {
            guard let data = try? Data(contentsOf: file),
                  let report = try? Self.decoder.decode(CrashReport.self, from: data)
            else {
                // 解析失败的文件直接删掉（防止污染队列）
                try? FileManager.default.removeItem(at: file)
                continue
            }
            let success = await send(report)
            if success {
                try? FileManager.default.removeItem(at: file)
            }
        }
    }

    // MARK: - Private: file I/O

    /// `~/Library/Containers/<bundle>/Data/Library/Application Support/Yinghua/crashes/`
    /// (sandboxed) or `~/Library/Application Support/Yinghua/crashes/` (non-sandboxed)
    fileprivate var pendingDirectory: URL {
        let base = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        )[0].appendingPathComponent("Yinghua/crashes", isDirectory: true)
        try? FileManager.default.createDirectory(
            at: base, withIntermediateDirectories: true
        )
        return base
    }

    private func deletePendingDirectory() {
        let dir = pendingDirectory
        // 只清我们自己的目录，不动父目录
        if let files = try? FileManager.default.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil) {
            for f in files { try? FileManager.default.removeItem(at: f) }
        }
    }

    private static func writePendingCrash(_ report: CrashReport) {
        // 同步写，handler 上下文里不能 await
        let base = FileManager.default.urls(
            for: .applicationSupportDirectory, in: .userDomainMask
        )[0].appendingPathComponent("Yinghua/crashes", isDirectory: true)
        try? FileManager.default.createDirectory(
            at: base, withIntermediateDirectories: true
        )
        let file = base.appendingPathComponent("\(UUID().uuidString).json")
        if let data = try? Self.encoder.encode(report) {
            try? data.write(to: file, options: .atomic)
        }
    }

    // MARK: - Private: handlers (called from non-isolated contexts)

    private static func handleUncaughtException(_ exception: NSException) {
        let report = CrashReport(
            type: "uncaught_exception",
            message: exception.reason ?? exception.name.rawValue,
            stackTrace: exception.callStackSymbols.joined(separator: "\n"),
            context: [
                "name": exception.name.rawValue,
            ],
            appVersion: appVersionString,
            osVersion: ProcessInfo.processInfo.operatingSystemVersionString,
            deviceModel: deviceModelString,
            timestamp: Date(),
            sessionId: sessionId()
        )
        writePendingCrash(report)
    }

    private static func handleSignal(_ name: String) {
        let report = CrashReport(
            type: "signal",
            message: name,
            stackTrace: Thread.callStackSymbols.joined(separator: "\n"),
            context: [:],
            appVersion: appVersionString,
            osVersion: ProcessInfo.processInfo.operatingSystemVersionString,
            deviceModel: deviceModelString,
            timestamp: Date(),
            sessionId: sessionId()
        )
        writePendingCrash(report)
        // Signal handler 必须尽快返回；进程将死，不需要清理
    }

    // MARK: - Private: helpers

    private func makeReport(
        type: String,
        message: String,
        stackTrace: String,
        context: [String: String]
    ) -> CrashReport {
        CrashReport(
            type: type,
            message: message,
            stackTrace: stackTrace,
            context: context,
            appVersion: Self.appVersionString,
            osVersion: ProcessInfo.processInfo.operatingSystemVersionString,
            deviceModel: Self.deviceModelString,
            timestamp: Date(),
            sessionId: Self.sessionId()
        )
    }

    private func send(_ report: CrashReport) async -> Bool {
        do {
            var request = URLRequest(url: endpoint, timeoutInterval: 10)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.setValue("application/json", forHTTPHeaderField: "Accept")
            request.httpBody = try Self.encoder.encode(report)
            let (_, response) = try await URLSession.shared.data(for: request)
            let ok = (response as? HTTPURLResponse)?.statusCode == 200
            if !ok {
                os_log("crash report upload failed: status=%d",
                       log: crashLog, type: .error,
                       (response as? HTTPURLResponse)?.statusCode ?? -1)
            }
            return ok
        } catch {
            os_log("crash report upload error: %{public}@",
                   log: crashLog, type: .error, error.localizedDescription)
            return false
        }
    }

    // MARK: - Static helpers

    private static let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private static let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    private static var appVersionString: String {
        (Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String) ?? "0.1.0"
    }

    private static var deviceModelString: String {
        var sysinfo = utsname()
        uname(&sysinfo)
        let model = withUnsafeBytes(of: &sysinfo.machine) { ptr in
            String(cString: ptr.baseAddress!.assumingMemoryBound(to: CChar.self))
        }
        return model.isEmpty ? "Mac" : model
    }

    /// 每次启动重新生成；用于去重同一会话的多次上报。
    private static let sessionIdValue: String = UUID().uuidString
    private static func sessionId() -> String { sessionIdValue }
}

// MARK: - Report payload

/// 远端接收的 crash report 格式。**字段都是必要的 debug 上下文，无 PII**。
struct CrashReport: Codable, Sendable {
    let type: String           // "uncaught_exception" | "signal" | "non_fatal"
    let message: String        // exception reason / signal name / error description
    let stackTrace: String     // call stack symbols
    let context: [String: String]  // 业务 tag（function/provider），**禁止 PII**
    let appVersion: String
    let osVersion: String
    let deviceModel: String    // sysctl utsname.machine，如 "arm64" / "Mac14,3"
    let timestamp: Date
    let sessionId: String      // 启动时生成的 UUID
}
