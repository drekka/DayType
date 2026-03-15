import DayType
import SwiftUI

/// A scrolling calendar grid with single-day or date-range selection.
///
/// Displays weeks as rows of 7 ``DayCell``s in an infinitely scrolling vertical layout.
/// Months are lazy-loaded as the user scrolls. On Mac Catalyst, pointer hover provides
/// live preview of the moving endpoint during selection.
public struct CalendarGrid: View {

    public enum Mode {
        case single
        case range
    }

    private let mode: Mode
    @Binding private var start: Day
    @Binding private var end: Day
    @Binding private var scrollTarget: Day?
    private let cellSize: CGFloat
    private let requestedVisibleRows: Int?

    /// All loaded week data. Pre-generated with a large backward buffer on first appear,
    /// extended forward on demand, and extended backward via ScrollView replacement when needed.
    @State private var calendar: CalendarDays = [:]

    /// Tracks the current selection gesture phase for range mode.
    @State private var selectionMode: SelectionMode = .idle

    /// The day under the pointer during a range selection gesture (Mac Catalyst live preview).
    @State private var hoverDay: Day?

    /// The week-start `Day` currently at the top of the scroll view.
    /// Bound to `scrollPosition(id:)` — drives year labels, edge detection, and haptic feedback.
    @State private var visibleWeek: Day?

    /// Guards backward extension. While `true`, the spinner overlay is shown and
    /// `onChange(of: visibleWeek)` is suppressed to prevent cascading loads.
    @State private var isExtending = false

    /// Identity token for the ScrollView. Changing this forces SwiftUI to destroy and recreate the
    /// ScrollView, which is the only reliable way to prepend data — inserting items above the viewport
    /// in a live `LazyVStack` with `scrollPosition(id:)` causes unrecoverable position jumps.
    @State private var scrollViewID = UUID()

    /// Fallback row count when `requestedVisibleRows` is nil, measured from available space.
    @State private var measuredVisibleRows = 6

    private var visibleRows: Int {
        requestedVisibleRows ?? measuredVisibleRows
    }

    // MARK: - Initialisers

    /// Creates a calendar grid for selecting a single date.
    ///
    /// - Parameters:
    ///   - selection: Binding to the selected day.
    ///   - cellSize: Width and height of each day cell. Defaults to `56`.
    ///   - visibleRows: Fixed number of visible week rows. When `nil`, the grid measures available space.
    ///   - scrollTo: Optional binding to programmatically scroll to a specific day. Set to a `Day` value
    ///     to animate the scroll, then the binding is automatically reset to `nil`.
    public init(selection: Binding<Day>, cellSize: CGFloat = 56, visibleRows: Int? = nil, scrollTo: Binding<Day?> = .constant(nil)) {
        mode = .single
        _start = selection
        _end = .constant(.init())
        _scrollTarget = scrollTo
        self.cellSize = cellSize
        requestedVisibleRows = visibleRows
    }

    /// Creates a calendar grid for selecting a date range.
    ///
    /// - Parameters:
    ///   - start: Binding to the range start day.
    ///   - end: Binding to the range end day.
    ///   - cellSize: Width and height of each day cell. Defaults to `56`.
    ///   - visibleRows: Fixed number of visible week rows. When `nil`, the grid measures available space.
    ///   - scrollTo: Optional binding to programmatically scroll to a specific day. Set to a `Day` value
    ///     to animate the scroll, then the binding is automatically reset to `nil`.
    public init(start: Binding<Day>, end: Binding<Day>, cellSize: CGFloat = 56, visibleRows: Int? = nil, scrollTo: Binding<Day?> = .constant(nil)) {
        mode = .range
        _start = start
        _end = end
        _scrollTarget = scrollTo
        self.cellSize = cellSize
        requestedVisibleRows = visibleRows
    }

    // MARK: - Body

    public var body: some View {
        VStack(spacing: 4) {
            Text(topYear)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(calendar.keys), id: \.self) { weekStart in
                        weekRow(calendar[weekStart]!)
                            // Explicit height so LazyVStack knows the size of unrealized rows.
                            // Without this, offset calculations break when content changes.
                            .frame(height: cellSize)
                            .id(weekStart)
                    }
                }
                .scrollTargetLayout()
            }
            // Changing scrollViewID forces a fresh ScrollView — the only safe way to extend backward.
            // See extendBackward(from:) for details.
            .id(scrollViewID)
            .scrollTargetBehavior(.viewAligned)
            .scrollPosition(id: $visibleWeek, anchor: .top)
            .frame(height: requestedVisibleRows.map { CGFloat($0) * cellSize })
            .background {
                if requestedVisibleRows == nil {
                    GeometryReader { geo in
                        Color.clear
                            .onChange(of: geo.size.height, initial: true) { _, height in
                                measuredVisibleRows = max(1, Int(height / cellSize))
                            }
                    }
                }
            }

            Text(bottomYear)
                .font(.title2)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .trailing)
        }
        .overlay {
            if isExtending {
                ZStack {
                    Color(.systemBackground).opacity(0.6)
                    ProgressView()
                        .controlSize(.large)
                }
            }
        }
        .onAppear {
            if calendar.isEmpty {
                calendar = Self.generateCalendar(around: start)
                visibleWeek = weekKey(for: start)
            }
        }
        .onChange(of: visibleWeek) { _, newWeek in
            guard let newWeek, !isExtending else { return }
            loadMoreIfNeeded(visibleWeek: newWeek)
        }
        .onChange(of: scrollTarget) { _, target in
            guard let target else { return }
            withAnimation {
                visibleWeek = weekKey(for: target)
            }
            scrollTarget = nil
        }
        .sensoryFeedback(.selection, trigger: visibleWeek)
        .frame(width: 7 * cellSize)
    }

    // MARK: - Week row

    private func weekRow(_ week: [CalendarDay]) -> some View {
        HStack(spacing: 0) {
            ForEach(week) { calendarDay in
                DayCell(calendarDay, highlight: highlight(for: calendarDay), size: cellSize) { tapped in
                    handleTap(tapped)
                }
                .onContinuousHover { phase in
                    switch phase {
                    case .active:
                        if selectionMode != .idle {
                            hoverDay = calendarDay.day
                        }
                    case .ended:
                        if hoverDay == calendarDay.day {
                            hoverDay = nil
                        }
                    }
                }
            }
        }
    }

    // MARK: - Highlight computation

    private func highlight(for calendarDay: CalendarDay) -> DayCell.Highlight {
        let day = calendarDay.day

        guard mode == .range else {
            return day == start ? .rangeStart : .none
        }

        let (effectiveStart, effectiveEnd, movingEndpoint) = effectiveRange()

        guard effectiveStart <= effectiveEnd else {
            // Single-point selection (start == end, no hover)
            if day == effectiveStart {
                return selectionMode == .idle ? .rangeStart : .selectedStart
            }
            return .none
        }

        if day == effectiveStart, day == effectiveEnd {
            return selectionMode == .idle ? .rangeStart : .selectedStart
        }

        if day == effectiveStart {
            return movingEndpoint == .start ? .selectedStart : .rangeStart
        }

        if day == effectiveEnd {
            return movingEndpoint == .end ? .selectedEnd : .rangeEnd
        }

        if day > effectiveStart, day < effectiveEnd {
            return .range
        }

        return .none
    }

    /// Returns the effective range incorporating hover preview, and which endpoint is moving.
    private func effectiveRange() -> (start: Day, end: Day, moving: Endpoint?) {
        let preview = hoverDay

        switch selectionMode {
        case .idle:
            return (min(start, end), max(start, end), nil)

        case .newSelection:
            let effectiveEnd = preview ?? start
            let lo = min(start, effectiveEnd)
            let hi = max(start, effectiveEnd)
            return (lo, hi, lo == start ? .end : .start)

        case .adjustingStart:
            let effectiveStart = preview ?? start
            let lo = min(effectiveStart, end)
            let hi = max(effectiveStart, end)
            return (lo, hi, lo == effectiveStart ? .start : .end)

        case .adjustingEnd:
            let effectiveEnd = preview ?? end
            let lo = min(start, effectiveEnd)
            let hi = max(start, effectiveEnd)
            return (lo, hi, hi == effectiveEnd ? .end : .start)
        }
    }

    // MARK: - Tap handling

    private func handleTap(_ calendarDay: CalendarDay) {
        let day = calendarDay.day

        guard mode == .range else {
            start = day
            return
        }

        switch selectionMode {
        case .idle:
            if day == start {
                selectionMode = .adjustingStart
            } else if day == end {
                selectionMode = .adjustingEnd
            } else {
                start = day
                end = day
                selectionMode = .newSelection
            }

        case .newSelection:
            end = day
            normaliseRange()
            selectionMode = .idle
            hoverDay = nil

        case .adjustingStart:
            start = day
            normaliseRange()
            selectionMode = .idle
            hoverDay = nil

        case .adjustingEnd:
            end = day
            normaliseRange()
            selectionMode = .idle
            hoverDay = nil
        }
    }

    /// Ensures start <= end, swapping if needed.
    private func normaliseRange() {
        if start > end {
            swap(&start, &end)
        }
    }

    // MARK: - Year labels

    private var topYear: String {
        guard let visibleWeek else { return "" }
        return String(visibleWeek.dayComponents.year)
    }

    private var bottomYear: String {
        guard let visibleWeek else { return "" }
        let keys = Array(calendar.keys)
        guard let topIndex = keys.firstIndex(of: visibleWeek) else { return "" }
        let bottomIndex = min(keys.count - 1, topIndex + visibleRows - 1)
        return String((keys[bottomIndex] + 6).dayComponents.year)
    }

    // MARK: - Scroll target resolution

    private func weekKey(for day: Day) -> Day? {
        calendar.keys.last { $0 <= day }
    }

    // MARK: - Calendar loading

    /// Checks whether the visible week is near the edge of loaded data and extends if needed.
    ///
    /// - **Forward (append)**: Safe to do in-place — new content appears below the viewport
    ///   so `scrollPosition(id:)` is unaffected.
    /// - **Backward (prepend)**: Inserting items above the viewport in a live `LazyVStack` causes
    ///   `scrollPosition(id:)` to report wrong values, cascading into runaway loading. Instead,
    ///   we show a spinner, rebuild the data, and replace the ScrollView entirely via `scrollViewID`.
    private func loadMoreIfNeeded(visibleWeek: Day) {
        let keys = calendar.keys
        guard let index = keys.firstIndex(of: visibleWeek) else { return }

        let threshold = visibleRows + 2

        if index < threshold {
            extendBackward(from: visibleWeek)
        }

        if index >= keys.count - threshold, let last = keys.last {
            let lastDay = calendar[last]!.last!.day
            var additions: CalendarDays = [:]
            for offset in 1 ... 12 {
                additions = additions + lastDay.day(byAdding: .month, value: offset).calendarMonth()
            }
            calendar += additions
        }
    }

    /// Extends the calendar 10 years backward by rebuilding the data and replacing the ScrollView.
    ///
    /// SwiftUI's `scrollPosition(id:)` cannot maintain a stable position when items are inserted
    /// before the current viewport in a `LazyVStack` — it misestimates content offsets for
    /// unrealized rows, causing the scroll position to jump and trigger cascading loads.
    ///
    /// The workaround: show a spinner overlay (blocking further `onChange` triggers via `isExtending`),
    /// merge new data into `calendar`, then assign a new `scrollViewID` to force SwiftUI to destroy
    /// the old ScrollView and create a fresh one that reads `visibleWeek` as its initial position.
    private func extendBackward(from triggerWeek: Day) {
        guard !isExtending else { return }
        isExtending = true

        Task { @MainActor in
            guard let firstKey = calendar.keys.first else {
                isExtending = false
                return
            }

            var additions: CalendarDays = [:]
            for offset in -120 ... -1 {
                additions = additions + firstKey.day(byAdding: .month, value: offset).calendarMonth()
            }
            calendar = additions + calendar

            // Position the new ScrollView at the week that triggered the extension
            visibleWeek = triggerWeek
            scrollViewID = UUID()

            // Brief delay for SwiftUI to create and position the new ScrollView
            try? await Task.sleep(for: .milliseconds(300))
            isExtending = false

            // Simulate continued scroll momentum by animating a few rows backward
            let keys = Array(calendar.keys)
            if let index = keys.firstIndex(of: triggerWeek) {
                let targetIndex = max(0, index - 4)
                withAnimation(.easeOut(duration: 0.3)) {
                    visibleWeek = keys[targetIndex]
                }
            }
        }
    }

    /// Pre-generates a large calendar range: 10 years backward, 1 year forward.
    /// The generous backward buffer means `extendBackward` is rarely needed.
    private static func generateCalendar(around center: Day) -> CalendarDays {
        var result: CalendarDays = [:]
        for offset in -120 ... 12 {
            result = result + center.day(byAdding: .month, value: offset).calendarMonth()
        }
        return result
    }
}

// MARK: - Internal types

private extension CalendarGrid {

    enum SelectionMode: Equatable {
        case idle
        case newSelection
        case adjustingStart
        case adjustingEnd
    }

    enum Endpoint {
        case start, end
    }

}

// MARK: - Previews

#Preview("Range - fixed rows", traits: .sizeThatFitsLayout) {
    @Previewable @State var start = Day()
    @Previewable @State var end = Day() + 7

    CalendarGrid(start: $start, end: $end, visibleRows: 6)
        .padding()
        .border(.gray)
}

#Preview("Single - fill space", traits: .sizeThatFitsLayout) {
    @Previewable @State var selected = Day()

    CalendarGrid(selection: $selected)
        .padding()
        .border(.gray)
}
