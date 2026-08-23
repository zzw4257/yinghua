import AVFoundation

/// 跨 actor 传递 AVAudioPCMBuffer 的 Sendable 包装
///
/// **为什么需要这个 wrapper？**
/// `AVAudioPCMBuffer` 是 CoreAudio 的引用类型，本质是 ARC 管理的 C 对象。
/// Apple 尚未把它标成 `Sendable`，所以 Swift 6 严格并发下跨 actor 传递
/// (`AsyncStream<AVAudioPCMBuffer>.Continuation.yield` / `AsyncStream` element)
/// 会直接编译失败。
///
/// 我们保证 buffer 的所有权在同一时刻只属于一个 actor（写入方立即移交，接收方独占使用），
/// 行为是安全的；所以用 `@unchecked Sendable` 自证。
///
/// 与 macOS 端 `AudioCaptureService.SendableAudioBuffer` 对应（同一份语义，移到 iOS app 私有命名空间）。
struct SendableAudioBuffer: @unchecked Sendable {
    let buffer: AVAudioPCMBuffer
}
