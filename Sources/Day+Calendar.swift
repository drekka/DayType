import Foundation
@_exported import OrderedCollections

/// An ordered dictionary mapping the first ``Day`` of each week to its 7-element ``CalendarDay`` array.
public typealias CalendarDays = OrderedDictionary<Day, [CalendarDay]>

public extension Day {

    /// Returns a calendar month grid for the month containing this day.
    ///
    /// The returned ``CalendarDays`` maps each week's starting ``Day`` to an array of 7 ``CalendarDay`` values.
    /// The first and last weeks may include days from the previous or next month
    /// to fill out complete weeks.
    ///
    /// - parameter startOfWeek: The day that begins each row. Defaults to `.sunday`.
    /// - returns: A ``CalendarDays`` ordered dictionary of weeks.
    func calendarMonth(startingOn startOfWeek: StartOfWeek = .sunday) -> CalendarDays {

        let components = dayComponents()

        // First and last days of the target month.
        let firstOfMonth = Day(components.year, components.month, 1)
        let firstOfNextMonth = Day(components.year, components.month + 1, 1)
        let lastOfMonth = firstOfNextMonth - 1

        // Calculate how many days to step back from the 1st to reach the start-of-week day.
        let firstWeekday = firstOfMonth.weekday
        let offset = (firstWeekday.rawValue - startOfWeek.weekday.rawValue + 7) % 7
        let gridStart = firstOfMonth - offset

        // Build weeks until we've passed the last day of the month.
        var result: CalendarDays = [:]
        var cursor = gridStart
        repeat {
            let weekStart = cursor
            var week: [CalendarDay] = []
            for _ in 0 ..< 7 {
                week.append(CalendarDay(day: cursor, dayComponents: cursor.dayComponents()))
                cursor = cursor + 1
            }
            result[weekStart] = week
        } while cursor <= lastOfMonth

        return result
    }

    /// Returns a calendar month grid for the month containing `day`.
    ///
    /// Convenience static function that delegates to the instance method.
    ///
    /// - parameter day: The day whose month to generate. Defaults to ``today``.
    /// - parameter startOfWeek: The day that begins each row. Defaults to `.sunday`.
    /// - returns: A ``CalendarDays`` ordered dictionary of weeks.
    static func calendarMonth(containing day: Day = .today, startingOn startOfWeek: StartOfWeek = .sunday) -> CalendarDays {
        day.calendarMonth(startingOn: startOfWeek)
    }
}
