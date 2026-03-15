import DayType
import SwiftUI

/// A calendar date picker dialog wrapping ``CalendarGrid``.
///
/// Displays a title, date header showing the current selection,
/// an embedded ``CalendarGrid`` for scrollable date selection,
/// and a summary footer in range mode.
public struct CalendarPicker: View {

    private let title: String
    private let mode: CalendarGrid.Mode
    @Binding private var start: Day
    @Binding private var end: Day
    @State private var scrollTarget: Day?

    // MARK: - Initialisers

    /// Creates a calendar picker for selecting a single date.
    ///
    /// - Parameters:
    ///   - title: Title displayed at the top of the picker.
    ///   - selection: Binding to the selected day. Tapping the displayed date scrolls back to it.
    public init(title: String, selection: Binding<Day>) {
        self.title = title
        mode = .single
        _start = selection
        _end = .constant(.init())
    }

    /// Creates a calendar picker for selecting a date range.
    ///
    /// Displays a "From ... to ..." header with tappable dates that scroll the grid,
    /// and a days/nights summary below the header.
    ///
    /// - Parameters:
    ///   - title: Title displayed at the top of the picker.
    ///   - start: Binding to the range start day.
    ///   - end: Binding to the range end day.
    public init(title: String, start: Binding<Day>, end: Binding<Day>) {
        self.title = title
        mode = .range
        _start = start
        _end = end
    }

    public var body: some View {
        VStack(spacing: 0) {
            titleBar
            dateHeader
            if mode == .range {
                summaryLabel
            }
            grid
                .padding(.top, 8)
        }
        .padding()
    }

    // MARK: - Title bar

    private var titleBar: some View {
        Text(title)
            .font(.headline)
            .frame(maxWidth: .infinity)
            .padding(.bottom, 12)
    }

    // MARK: - Date header

    @ViewBuilder
    private var dateHeader: some View {
        if mode == .range {
            rangeDateHeader
        } else {
            singleDateHeader
        }
    }

    private var singleDateHeader: some View {
        Button {
            scrollTarget = start
        } label: {
            Text(start.formatted())
                .font(.title3)
                .foregroundStyle(Color.accentColor)
        }
        .buttonStyle(.plain)
    }

    private var rangeDateHeader: some View {
        HStack(spacing: 4) {
            Text("From")
                .foregroundStyle(.primary)
            Button {
                scrollTarget = start
            } label: {
                Text(start.formatted())
                    .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)

            Text("to")
                .foregroundStyle(.primary)
            Button {
                scrollTarget = end
            } label: {
                Text(end.formatted())
                    .foregroundStyle(Color.accentColor)
            }
            .buttonStyle(.plain)
        }
        .font(.title3)
    }

    // MARK: - Calendar grid

    @ViewBuilder
    private var grid: some View {
        switch mode {
        case .single:
            CalendarGrid(selection: $start, visibleRows: 6, scrollTo: $scrollTarget)
        case .range:
            CalendarGrid(start: $start, end: $end, visibleRows: 6, scrollTo: $scrollTarget)
        }
    }

    // MARK: - Summary

    private var summaryLabel: some View {
        let totalDays = end - start + 1
        let nights = max(0, totalDays - 1)
        return Text("\(totalDays) days, \(nights) nights")
            .font(.caption)
            .foregroundStyle(.secondary)
            .padding(.top, 2)
    }
}

// MARK: - Previews

#Preview("Single selection", traits: .sizeThatFitsLayout) {
    @Previewable @State var selected = Day()

    CalendarPicker(title: "Select Date", selection: $selected)
        .padding()
        .border(.gray)
}

#Preview("Range selection", traits: .sizeThatFitsLayout) {
    @Previewable @State var start = Day()
    @Previewable @State var end = Day() + 7

    CalendarPicker(title: "Select Range", start: $start, end: $end)
        .padding()
        .border(.gray)
}
