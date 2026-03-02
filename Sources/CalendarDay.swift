import Foundation

/// A day within a calendar month grid, bundling the ``Day`` with its pre-computed ``DayComponents``.
public struct CalendarDay {
    public let day: Day
    public let dayComponents: DayComponents
}
