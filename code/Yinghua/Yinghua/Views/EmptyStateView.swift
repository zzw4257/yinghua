import SwiftUI

/// C06/02 empty-state
/// - 左侧 4 圆形 nav icon（首项 mic 带 magenta active dot）
/// - 中央 2x2 大方块（"快速开始"4 个场景）
/// - 右侧最近录音 3 行
struct EmptyStateView: View {
    @Environment(AppState.self) private var state

    var body: some View {
        @Bindable var state = state

        HStack(spacing: 0) {
            leftRail
                .frame(width: 80)
                .padding(.vertical, Tokens.Spacing.xl)
            Divider().background(Tokens.Color.hairline)
            centerGrid
                .frame(maxWidth: .infinity)
            Divider().background(Tokens.Color.hairline)
            rightRecent
                .frame(width: 320)
                .padding(.vertical, Tokens.Spacing.xl)
                .padding(.horizontal, Tokens.Spacing.lg)
        }
    }

    // MARK: - 左侧 4 圆形 nav

    private var leftRail: some View {
        VStack(spacing: Tokens.Spacing.lg) {
            ForEach(Array(navItems.enumerated()), id: \.offset) { idx, item in
                railButton(item: item, isActive: idx == 0)
            }
        }
    }

    private func railButton(item: RailItem, isActive: Bool) -> some View {
        ZStack(alignment: .bottomTrailing) {
            ZStack {
                Circle()
                    .fill(.regularMaterial)
                    .overlay(Circle().stroke(Tokens.Color.hairline, lineWidth: 1))
                Image(systemName: item.symbol)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
            .frame(width: 44, height: 44)

            if isActive {
                Circle()
                    .fill(Tokens.Color.pink)
                    .frame(width: 8, height: 8)
                    .overlay(Circle().stroke(Tokens.Color.nearBlack, lineWidth: 1.5))
                    .offset(x: 2, y: 2)
            }
        }
    }

    // MARK: - 中央 2x2

    private var centerGrid: some View {
        VStack(spacing: Tokens.Spacing.xl) {
            VStack(spacing: 8) {
                Text("映话")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
                Text("准备录制一场新会议")
                    .font(.system(size: 14))
                    .foregroundStyle(Tokens.Color.tertiaryText)
            }
            .padding(.top, Tokens.Spacing.xxxl)

            LazyVGrid(
                columns: [GridItem(.flexible(), spacing: Tokens.Spacing.lg),
                          GridItem(.flexible(), spacing: Tokens.Spacing.lg)],
                spacing: Tokens.Spacing.lg
            ) {
                quickTile(symbol: "mic.fill",        title: "立即录制",   tint: Tokens.Color.purpleVivid) {
                    state.startRecording()
                }
                quickTile(symbol: "rectangle.dashed", title: "导入音频",   tint: Tokens.Color.tealVivid) {
                    // 触发文件选择
                }
                quickTile(symbol: "text.bubble",      title: "纯转录",     tint: Tokens.Color.pink) {
                    state.startRecording()
                }
                quickTile(symbol: "wand.and.stars",   title: "AI 总结",    tint: Tokens.Color.purpleVivid.opacity(0.7)) {
                    // 触发 paste transcript
                }
            }
            .padding(.horizontal, Tokens.Spacing.xxxl)

            Spacer()
        }
    }

    private func quickTile(symbol: String, title: String, tint: Color, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            VStack(alignment: .leading, spacing: Tokens.Spacing.lg) {
                Image(systemName: symbol)
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(tint)
                Text(title)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundStyle(Tokens.Color.warmWhite)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(Tokens.Spacing.lg)
            .aspectRatio(1.5, contentMode: .fit)
            .background(.regularMaterial)
            .overlay(
                RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge, style: .continuous)
                    .stroke(Tokens.Color.hairline, lineWidth: 1)
            )
            .clipShape(RoundedRectangle(cornerRadius: Tokens.Radius.cardLarge, style: .continuous))
        }
        .buttonStyle(.plain)
    }

    // MARK: - 右侧最近录音

    private var rightRecent: some View {
        VStack(alignment: .leading, spacing: Tokens.Spacing.md) {
            Text("最近")
                .font(.system(size: 12, weight: .semibold))
                .tracking(1)
                .foregroundStyle(Tokens.Color.tertiaryText)

            ForEach(MeetingRecord.recentDemo) { record in
                RecentRow(record: record)
            }

            Spacer()
        }
    }

    // MARK: - 数据

    private struct RailItem {
        let symbol: String
    }

    private var navItems: [RailItem] {
        [
            RailItem(symbol: "mic.fill"),
            RailItem(symbol: "rectangle.dashed"),
            RailItem(symbol: "text.bubble"),
            RailItem(symbol: "wand.and.stars"),
        ]
    }
}

private struct RecentRow: View {
    let record: MeetingRecord

    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(record.title)
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(Tokens.Color.warmWhite)
                .lineLimit(1)
            Text(record.subtitle)
                .font(.system(size: 11))
                .foregroundStyle(Tokens.Color.tertiaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
        .padding(.horizontal, 10)
        .background(
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .fill(Tokens.Color.warmWhite.opacity(0.04))
        )
    }
}

extension MeetingRecord {
    static let recentDemo: [MeetingRecord] = [
        MeetingRecord(
            id: UUID(),
            title: "张三-前端-终面",
            recordedAt: Date(),
            durationSeconds: 48 * 60,
            fileSizeMB: 1.2 * 1024,
            speakers: [],
            languages: ["MP4", "中英双语", "2 位发言人"],
            transcriptLines: [],
            summary: .empty
        ),
        MeetingRecord(
            id: UUID(),
            title: "产品周会 · Q3 OKR 复盘",
            recordedAt: Date().addingTimeInterval(-3600 * 6),
            durationSeconds: 72 * 60,
            fileSizeMB: 1.8 * 1024,
            speakers: [],
            languages: ["MP4", "中文", "5 位发言人"],
            transcriptLines: [],
            summary: .empty
        ),
        MeetingRecord(
            id: UUID(),
            title: "PhD 套磁 · Prof. Jia",
            recordedAt: Date().addingTimeInterval(-3600 * 24 * 2),
            durationSeconds: 18 * 60,
            fileSizeMB: 380,
            speakers: [],
            languages: ["MP4", "英文", "1 位发言人"],
            transcriptLines: [],
            summary: .empty
        ),
    ]

    var subtitle: String {
        let hours = Int(durationSeconds) / 3600
        let mins  = (Int(durationSeconds) % 3600) / 60
        let duration = hours > 0 ? "\(hours) 小时 \(mins) 分钟" : "\(mins) 分钟"
        return "今天录制 · \(duration) · \(String(format: "%.1f", fileSizeMB / 1024)) GB"
    }
}

#Preview("EmptyState") {
    EmptyStateView()
        .environment(AppState())
        .frame(width: 1200, height: 800)
        .background(Tokens.Color.nearBlack)
}
