import Foundation
import Observation
import YinghuaCore

/// iOS 端 AI 总结服务（C44 · v0.1 stub）
///
/// **v0.1 策略**
/// - iOS 端不直接调用 LLM API（v0.1 范围之外）
/// - iOS 端只暴露 `summaryFromTranscript` 协议，让 views 可以调用
/// - 实际 v0.1 返回 `.preview` 占位；future v0.2 走 macOS app 共享总结服务
///
/// **v0.2 计划**
/// - 通过 Bonjour / iCloud / 共享 Sheet 把 transcript + 音频文件传到 macOS app
/// - macOS app 走 `SummaryService` 出总结，AirDrop / 通用剪贴板回 iOS
@MainActor
@Observable
final class iOSSummaryService {
    /// 是否正在生成总结
    private(set) var isGenerating: Bool = false

    /// 最近一次错误
    var lastError: SummaryError?

    /// 内部：是否启用 macOS 协同总结（v0.2 标志；v0.1 始终为 false）
    let macCollabEnabled: Bool = false

    /// 由 transcript 产生 AI 总结（v0.1 stub · 返回占位）
    /// - Parameter lines: 转录行
    /// - Returns: AI 总结
    func summaryFromTranscript(_ lines: [TranscriptLine]) async throws -> MeetingSummary {
        guard !lines.isEmpty else {
            return .empty
        }
        isGenerating = true
        defer { isGenerating = false }
        // 模拟网络延迟（演示用）
        try? await Task.sleep(nanoseconds: 300_000_000)
        return .preview
    }
}

/// 总结错误
enum SummaryError: LocalizedError {
    case macCollabUnavailable
    case transcriptEmpty

    var errorDescription: String? {
        switch self {
        case .macCollabUnavailable:
            return "macOS 协同总结服务未启用。"
        case .transcriptEmpty:
            return "转录内容为空，无法生成总结。"
        }
    }
}
