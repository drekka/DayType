import Foundation

public extension Day {

    /// Returns a ``Date`` using the passed calendar and timezone.
    ///
    /// - parameter calendar: The calendar to create the date in. Defaults to `.current`.
    /// - parameter timeZone: The ``TimeZone`` to use when converting. If `nil`, the time zone of the calendar will be used.
    func date(inCalendar calendar: Calendar = .current,
              timeZone: TimeZone? = nil) -> Date {
        let dayComponents = dayComponents()
        let dateComponents = DateComponents(calendar: calendar,
                                            timeZone: timeZone,
                                            year: dayComponents.year,
                                            month: dayComponents.month,
                                            day: dayComponents.day)
        return dateComponents.date!
    }
}
