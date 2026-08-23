import Foundation
import Observation

/// 录制状态机（与 macOS 端 AppState.recording 保持一致）
enum RecordingState: Equatable {
    case idle
    case recording(startedAt: Date)
    case paused(elapsed: TimeInterval)
    case stopped

    var isActive: Bool {
        if case .recording = self { return true }
        return false
    }

    var elapsed: TimeInterval {
        switch self {
        case .recording(let startedAt):
            return Date().timeIntervalSince(startedAt)
        case .paused(let elapsed):
            return elapsed
        case .idle, .stopped:
            return 0
        }
    }
}

/// iOS 端全局 app 状态（@Observable，iOS 17+ Observation framework）
@Observable
@MainActor
final class iOSAppState {
    /// 4 个 tab 状态
    var selectedTab: AppTab = .library

    /// 录制状态
    var recording: RecordingState = .idle

    /// 当前录制中的 speakers（v0.1：固定 4 人占位）
    var speakers: [Speaker] = iOSAppState.fourSpeakers

    /// 当前录制 transcript
    var transcriptLines: [TranscriptLine] = TranscriptLine.demo

    /// 当前 review 的 meeting summary
    var summary: MeetingSummary = .preview

    /// Library 列表
    var library: [LibraryItem] = LibraryItem.demo

    /// 录制控制
    func startRecording() {
        guard !recording.isActive else { return }
        recording = .recording(startedAt: Date())
    }

    func pauseRecording() {
        if case .recording(let startedAt) = recording {
            recording = .paused(elapsed: Date().timeIntervalSince(startedAt))
        }
    }

    func resumeRecording() {
        if case .paused(let elapsed) = recording {
            recording = .recording(startedAt: Date().addingTimeInterval(-elapsed))
        }
    }

    func stopRecording() {
        recording = .stopped
    }

    // MARK: - 占位数据

    /// 录制中 4 个 speaker（占位）
    static let fourSpeakers: [Speaker] = [
        Speaker(id: "interviewer", name: "面试官", color: .purple, isLocal: false),
        Speaker(id: "me",         name: "我",     color: .teal,   isLocal: true),
        Speaker(id: "peer1",      name: "同事 A", color: .pink,   isLocal: false),
        Speaker(id: "peer2",      name: "同事 B", color: .warmWhite, isLocal: false),
    ]
}

// MARK: - Tab

/// iOS 端 4 个 tab
enum AppTab: String, Hashable, CaseIterable, Identifiable {
    case library
    case record
    case settings
    case about

    var id: String { rawValue }

    var title: String {
        switch self {
        case .library:  return "Library"
        case .record:   return "Record"
        case .settings: return "Settings"
        case .about:    return "About"
        }
    }

    var systemImage: String {
        switch self {
        case .library:  return "rectangle.stack.fill"
        case .record:   return "record.circle"
        case .settings: return "gearshape.fill"
        case .about:    return "info.circle.fill"
        }
    }
}
