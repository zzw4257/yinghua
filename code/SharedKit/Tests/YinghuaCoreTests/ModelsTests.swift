import XCTest
@testable import YinghuaCore

final class ModelsTests: XCTestCase {
    func testSpeakerStableColor() {
        let id = "test-speaker-1"
        let a = SpeakerColor.assign(for: id)
        let b = SpeakerColor.assign(for: id)
        XCTAssertEqual(a, b, "同 id 必须映射到同颜色")
    }

    func testTranscriptLineTimecode() {
        let line = TranscriptLine(
            speakerId: "me",
            speakerName: "我",
            timestamp: 125,
            text: "hello"
        )
        XCTAssertEqual(line.timecode, "02:05")
    }

    func testMeetingSummaryEmpty() {
        let s = MeetingSummary.empty
        XCTAssertTrue(s.keyMoments.isEmpty)
        XCTAssertTrue(s.decisions.isEmpty)
        XCTAssertTrue(s.actionItems.isEmpty)
        XCTAssertTrue(s.openQuestions.isEmpty)
    }

    func testLibraryItemDurationLabel() {
        let item = LibraryItem(
            title: "测试",
            recordedAt: Date(),
            durationSeconds: 48 * 60,
            speakers: [],
            summary: .empty
        )
        XCTAssertEqual(item.durationLabel, "48 min")

        let long = LibraryItem(
            title: "测试",
            recordedAt: Date(),
            durationSeconds: 3725,
            speakers: [],
            summary: .empty
        )
        XCTAssertEqual(long.durationLabel, "1h 2m")
    }

    func testAPIProviderDisplayName() {
        XCTAssertEqual(APIProvider.openai.displayName, "OpenAI")
        XCTAssertEqual(APIProvider.anthropic.displayName, "Anthropic")
        XCTAssertTrue(APIProvider.custom.displayName.contains("自定义"))
    }
}
