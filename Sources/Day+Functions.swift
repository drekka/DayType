import Foundation

public extension Day {

    /// Returns a new ``Day`` by adding the specified value to the given component.
    ///
    /// For `.day`, the value is added directly to the underlying ``daysSince1970``.
    /// For `.month`, the function walks forward or backward month by month, summing the actual number of days in each month traversed.
    /// For `.year`, it walks year by year, summing actual days per year (accounting for leap years).
    ///
    /// - parameter component: The component to adjust (`.year`, `.month`, or `.day`).
    /// - parameter value: The number of units to add (negative values subtract).
    /// - returns: The adjusted ``Day``.
    func day(byAdding component: Day.Component, value: Int) -> Day {

        switch component {

        case .day:
            return Day(daysSince1970: daysSince1970 + value)

        case .month:
            var totalDays = 0
            var currentYear = year
            var currentMonth = month

            if value >= 0 {
                for _ in 0 ..< value {
                    totalDays += Day.daysInMonth(currentMonth, year: currentYear)
                    currentMonth += 1
                    if currentMonth > 12 { currentMonth = 1; currentYear += 1 }
                }
            } else {
                for _ in 0 ..< -value {
                    currentMonth -= 1
                    if currentMonth < 1 { currentMonth = 12; currentYear -= 1 }
                    totalDays += Day.daysInMonth(currentMonth, year: currentYear)
                }
            }

            return Day(daysSince1970: daysSince1970 + (value >= 0 ? totalDays : -totalDays))

        case .year:
            var totalDays = 0

            if value >= 0 {
                for i in 0 ..< value {
                    totalDays += Day.daysInYear(year + i)
                }
            } else {
                for i in 0 ..< -value {
                    totalDays += Day.daysInYear(year - 1 - i)
                }
            }

            return Day(daysSince1970: daysSince1970 + (value >= 0 ? totalDays : -totalDays))
        }
    }
}
