import Foundation
import AVFoundation
import AppKit
import UserNotifications
import Speech

/// 3 类权限状态
enum PermissionState: Equatable, Hashable {
    case unknown      // 未检查
    case granted      // 已授权
    case denied       // 被拒绝（用户或系统策略）
    case pending      // 系统弹窗等用户操作
    case optional     // 业务上可选（即使没权限也不阻塞）

    var displayText: String {
        switch self {
        case .unknown:  return "未检查"
        case .granted:  return "已授权"
        case .denied:   return "已拒绝"
        case .pending:  return "等待授权"
        case .optional: return "不需要"
        }
    }

    var pillColor: (background: NSColor, foreground: NSColor) {
        switch self {
        case .granted:
            return (NSColor.systemGreen.withAlphaComponent(0.18), NSColor.systemGreen)
        case .denied:
            return (NSColor.systemRed.withAlphaComponent(0.18), NSColor.systemRed)
        case .pending:
            return (NSColor.systemOrange.withAlphaComponent(0.18), NSColor.systemOrange)
        case .unknown, .optional:
            return (NSColor.gray.withAlphaComponent(0.18), NSColor.secondaryLabelColor)
        }
    }
}

enum PermissionKind: String, CaseIterable, Identifiable, Hashable {
    case microphone
    case screenRecording
    case speechRecognition
    case notifications

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .microphone:         return "麦克风"
        case .screenRecording:    return "屏幕录制（系统音频）"
        case .speechRecognition:  return "语音识别"
        case .notifications:      return "通知"
        }
    }

    var detail: String {
        switch self {
        case .microphone:
            return "录制本地发言（你说话的声音）"
        case .screenRecording:
            return "录制系统音频（来自 Zoom、Meet 等会议应用的声音）"
        case .speechRecognition:
            return "实时转录你说的和别人说的话"
        case .notifications:
            return "录制结束后通过通知提醒你"
        }
    }

    var symbol: String {
        switch self {
        case .microphone:         return "mic.fill"
        case .screenRecording:    return "rectangle.dashed"
        case .speechRecognition:  return "waveform"
        case .notifications:      return "bell.fill"
        }
    }
}

/// 权限检查 + 申请服务
@MainActor
final class PermissionService: ObservableObject {
    // MARK: - Published

    @Published private(set) var microphone: PermissionState = .unknown
    @Published private(set) var screenRecording: PermissionState = .unknown
    @Published private(set) var speechRecognition: PermissionState = .unknown
    @Published private(set) var notifications: PermissionState = .optional

    // MARK: - 公共

    /// 一次性检查所有权限
    func checkAll() async {
        await checkMicrophone()
        checkScreenRecording()
        await checkSpeechRecognition()
        await checkNotifications()
    }

    // MARK: - 麦克风

    @discardableResult
    func checkMicrophone() async -> PermissionState {
        let status = AVCaptureDevice.authorizationStatus(for: .audio)
        let state: PermissionState
        switch status {
        case .authorized:
            state = .granted
        case .denied, .restricted:
            state = .denied
        case .notDetermined:
            state = .unknown
        @unknown default:
            state = .unknown
        }
        microphone = state
        return state
    }

    @discardableResult
    func requestMicrophone() async -> Bool {
        microphone = .pending
        let granted = await AVCaptureDevice.requestAccess(for: .audio)
        microphone = granted ? .granted : .denied
        return granted
    }

    // MARK: - 屏幕录制

    /// 屏幕录制权限（macOS 11+）—— `CGPreflightScreenCaptureAccess` 返回 false 时
    /// 说明系统还没授权；调 `CGRequestScreenCaptureAccess` 弹系统弹窗。
    /// 注意：用户授权是异步的（弹窗后需要重启 app 才能完全生效），CGRequestScreenCaptureAccess
    /// 只是触发弹窗，不返回结果。
    @discardableResult
    func checkScreenRecording() -> PermissionState {
        let granted = CGPreflightScreenCaptureAccess()
        screenRecording = granted ? .granted : .denied
        return screenRecording
    }

    /// 触发系统弹窗（异步，不返回结果）
    func requestScreenRecording() {
        screenRecording = .pending
        _ = CGRequestScreenCaptureAccess()
    }

    // MARK: - 语音识别

    @discardableResult
    func checkSpeechRecognition() async -> PermissionState {
        let status = SFSpeechRecognizer.authorizationStatus()
        let state: PermissionState
        switch status {
        case .authorized:
            state = .granted
        case .denied, .restricted:
            state = .denied
        case .notDetermined:
            state = .unknown
        @unknown default:
            state = .unknown
        }
        speechRecognition = state
        return state
    }

    @discardableResult
    func requestSpeechRecognition() async -> Bool {
        speechRecognition = .pending
        let granted: Bool = await withCheckedContinuation { cont in
            SFSpeechRecognizer.requestAuthorization { auth in
                cont.resume(returning: auth == .authorized)
            }
        }
        speechRecognition = granted ? .granted : .denied
        return granted
    }

    // MARK: - 通知

    @discardableResult
    func checkNotifications() async -> PermissionState {
        let center = UNUserNotificationCenter.current()
        let settings = await center.notificationSettings()
        let state: PermissionState
        switch settings.authorizationStatus {
        case .authorized, .provisional, .ephemeral:
            state = .granted
        case .denied:
            state = .denied
        case .notDetermined:
            state = .unknown
        @unknown default:
            state = .unknown
        }
        notifications = state
        return state
    }

    @discardableResult
    func requestNotifications() async -> Bool {
        notifications = .pending
        let center = UNUserNotificationCenter.current()
        do {
            let granted = try await center.requestAuthorization(options: [.alert, .sound, .badge])
            notifications = granted ? .granted : .denied
            return granted
        } catch {
            notifications = .denied
            return false
        }
    }

    // MARK: - 跳系统设置

    /// 打开 System Settings 到对应权限页
    /// - microphone → `x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone`
    /// - screenRecording → `x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture`
    /// - speechRecognition → `x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition`
    /// - notifications → `x-apple.systempreferences:com.apple.preference.notifications`
    func openSystemSettings(for kind: PermissionKind) {
        let urlString: String
        switch kind {
        case .microphone:
            urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_Microphone"
        case .screenRecording:
            urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_ScreenCapture"
        case .speechRecognition:
            urlString = "x-apple.systempreferences:com.apple.preference.security?Privacy_SpeechRecognition"
        case .notifications:
            urlString = "x-apple.systempreferences:com.apple.preference.notifications"
        }
        if let url = URL(string: urlString) {
            NSWorkspace.shared.open(url)
        }
    }

    // MARK: - 便捷查询

    func state(for kind: PermissionKind) -> PermissionState {
        switch kind {
        case .microphone:        return microphone
        case .screenRecording:   return screenRecording
        case .speechRecognition: return speechRecognition
        case .notifications:     return notifications
        }
    }
}

// MARK: - 给 PermissionService 重新设置 state 的辅助（用于外部 service 完成授权后回写）

extension PermissionService {
    /// 内部使用：AudioCaptureService 完成 mic 申请后回写
    func setMicrophone(_ state: PermissionState) {
        microphone = state
    }

    /// 内部使用：AudioCaptureService 完成 screen recording 申请后回写
    func setScreenRecording(_ state: PermissionState) {
        screenRecording = state
    }
}
