import DayType
import SwiftUI

/// A single calendar day cell for use in grid layouts.
struct DayCell: View {

    /// Visual state of the cell.
    enum Highlight {
        case none
        case range
        case rangeStart
        case rangeEnd
        case selectedStart
        case selectedEnd
    }

    private let calendarDay: CalendarDay
    private let highlight: Highlight
    private let size: CGFloat
    private let onTapped: ((CalendarDay) -> Void)?

    init(_ calendarDay: CalendarDay, highlight: Highlight = .none, size: CGFloat = 56, onTapped: ((CalendarDay) -> Void)? = nil) {
        self.calendarDay = calendarDay
        self.highlight = highlight
        self.size = size
        self.onTapped = onTapped
    }

    var body: some View {
        let components = calendarDay.dayComponents
        let monthParity = components.month % 2 == 0
        let textColor: Color = monthParity ? .secondary : .primary

        Text("\(components.dayOfMonth)")
            .font(.title3.weight(.light))
            .foregroundStyle(highlight == .selectedStart || highlight == .selectedEnd || highlight == .rangeStart || highlight == .rangeEnd ? .white : textColor)
            .frame(width: size, height: size)
            .overlay(alignment: .topLeading) {
                if components.dayOfMonth == 1 {
                    Text(Calendar.current.monthSymbols[components.month - 1])
                        .font(.caption)
                        .foregroundStyle(textColor)
                        .fixedSize()
                        .padding(.top, 2)
                        .padding(.leading, 2)
                }
            }
            .background { highlightBackground }
            .background {
                if monthParity {
                    Rectangle().fill(textColor.opacity(0.1))
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                onTapped?(calendarDay)
            }
    }

    // MARK: - Highlight background

    @ViewBuilder
    private var highlightBackground: some View {
        switch highlight {
        case .selectedStart, .selectedEnd:
            PulsingCircle()
                .padding(4)
        case .rangeStart, .rangeEnd:
            Circle()
                .fill(Color.accentColor)
                .padding(4)
        case .range:
            Circle()
                .fill(Color.accentColor.opacity(0.1))
                .padding(4)
        case .none:
            EmptyView()
        }
    }
}

// MARK: - Pulsing circle

private struct PulsingCircle: View {
    @State private var pulsing = false
    var body: some View {
        Circle()
            .fill(Color.accentColor)
            .opacity(pulsing ? 0.5 : 1.0)
            .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: pulsing)
            .onAppear {
                pulsing.toggle()
            }
    }
}

// MARK: - Previews

#Preview("States", traits: .sizeThatFitsLayout) {
    let days = try! [
        CalendarDay(day: Day(2026, 3, 10)),
        CalendarDay(day: Day(2026, 3, 11)),
        CalendarDay(day: Day(2026, 3, 12)),
        CalendarDay(day: Day(2026, 3, 13)),
        CalendarDay(day: Day(2026, 3, 14)),
        CalendarDay(day: Day(2026, 3, 15)),
    ]
    VStack(alignment: .leading, spacing: 0) {
        row("none", DayCell(days[0], highlight: .none))
        row("rangeStart", DayCell(days[1], highlight: .rangeStart))
        row("rangeEnd", DayCell(days[2], highlight: .rangeEnd))
        row("range", DayCell(days[3], highlight: .range))
        row("selectedStart", DayCell(days[4], highlight: .selectedStart))
        row("selectedEnd", DayCell(days[5], highlight: .selectedEnd))
    }
    .padding()
}

#Preview("Month boundary", traits: .sizeThatFitsLayout) {
    let days = try! [
        CalendarDay(day: Day(2026, 2, 28)),
        CalendarDay(day: Day(2026, 3, 1)),
        CalendarDay(day: Day(2026, 3, 2)),
    ]
    VStack(alignment: .leading, spacing: 0) {
        row("even month", DayCell(days[0]))
        row("1st of month", DayCell(days[1]))
        row("odd month", DayCell(days[2]))
    }
    .padding()
}

private func row(_ label: String, _ cell: DayCell) -> some View {
    HStack {
        Text(label)
            .font(.caption)
            .foregroundStyle(.secondary)
            .frame(width: 80, alignment: .trailing)
        cell
    }
}
