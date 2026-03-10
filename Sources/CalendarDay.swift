/// A calendar entry combining a ``Day`` with its pre-computed ``DayComponents``.
///
/// Used in ``CalendarDays`` to represent individual cells in a calendar grid,
/// giving consumers direct access to both the ``Day`` and its year/month/day breakdown.
public struct CalendarDay {

    public let day: Day
    public let dayComponents: DayComponents

    public init(day: Day) {
        self.day = day
        self.dayComponents = day.dayComponents
    }
}
