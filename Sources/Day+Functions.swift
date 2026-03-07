import Foundation

public extension Day {

    /// Returns a new ``Day`` by adding the specified value to the given component.
    ///
    /// For `.day`, the value is added directly to the underlying ``daysSince1970``.
    /// For `.month`, the target month is calculated using modular arithmetic and the day
    /// is clamped to the last day of that month (e.g. Jan 31 + 1 month = Feb 28/29).
    /// For `.year`, the year is adjusted directly and the day is clamped to the last day
    /// of the resulting month (e.g. Feb 29 + 1 year in a non-leap year = Feb 28).
    ///
    /// - parameter component: The component to adjust (`.year`, `.month`, or `.day`).
    /// - parameter value: The number of units to add (negative values subtract).
    /// - returns: The adjusted ``Day``.
    func day(byAdding component: Day.Component, value: Int) -> Day {

        switch component {

        case .day:
            return Day(daysSince1970: daysSince1970 + value)

        case .month:
            let components = dayComponents
            let totalMonths = (components.month - 1) + value
            let yearOffset = totalMonths >= 0 ? totalMonths / 12 : (totalMonths - 11) / 12
            let newMonth = totalMonths - yearOffset * 12 + 1
            let newYear = components.year + yearOffset
            let clampedDay = min(components.dayOfMonth, Day.daysInMonth(newMonth, year: newYear))
            // Components are guaranteed valid after clamping.
            return try! Day(newYear, newMonth, clampedDay)

        case .year:
            let components = dayComponents
            let newYear = components.year + value
            let clampedDay = min(components.dayOfMonth, Day.daysInMonth(components.month, year: newYear))
            // Components are guaranteed valid after clamping.
            return try! Day(newYear, components.month, clampedDay)
        }
    }
}
