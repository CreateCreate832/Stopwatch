import SwiftUI

struct StopwatchView: View {
    @State private var accumulated: TimeInterval = 0
    @State private var startedAt: Date?
    @State private var isRunning = false

    private var elapsed: TimeInterval {
        accumulated + (startedAt.map { Date().timeIntervalSince($0) } ?? 0)
    }

    var body: some View {
        VStack(spacing: 22) {
            Spacer(minLength: 8)
            TimelineView(.periodic(from: .now, by: 0.01)) { _ in
                Text(timeString(elapsed))
                    .font(.system(size: 48, weight: .light, design: .rounded).monospacedDigit())
                    .foregroundStyle(.primary)
                    .contentTransition(.numericText())
                    .minimumScaleFactor(0.65)
                    .lineLimit(1)
            }
            HStack(spacing: 14) {
                Button("Reset", systemImage: "arrow.counterclockwise") {
                    accumulated = 0
                    startedAt = isRunning ? Date() : nil
                }
                .buttonStyle(.bordered)
                .disabled(elapsed == 0)
                Button(isRunning ? "Pause" : "Start", systemImage: isRunning ? "pause.fill" : "play.fill") {
                    if isRunning {
                        accumulated = elapsed
                        startedAt = nil
                        isRunning = false
                    } else {
                        startedAt = Date()
                        isRunning = true
                    }
                }
                .buttonStyle(.borderedProminent)
                .tint(.accentColor)
            }
            Spacer(minLength: 8)
            Text("⌘7 opens UniveGame")
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(.secondary)
                .padding(.bottom, 8)
        }
        .padding(24)
        .background(.regularMaterial)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    private func timeString(_ interval: TimeInterval) -> String {
        let total = max(0, Int(interval * 100))
        let hundredths = total % 100
        let seconds = (total / 100) % 60
        let minutes = (total / 6_000) % 60
        let hours = total / 360_000
        return String(format: "%02d:%02d:%02d.%02d", hours, minutes, seconds, hundredths)
    }
}
