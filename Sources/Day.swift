import Foundation

/// Simple alias to help code readability.
public typealias DayInterval = Int

/// Representation of a day.
///
/// Date's are often used in software without reference to any particular time of day or timezone. In other words they
/// represent a period of time rather than a specific point in time as Foundation's ``Date`` does. ``Day`` is an implementation
/// of this concept which allows developers to avoid all the peripheral boilerplate code necessary when mapping a ``Date`` to the
/// generalisation that is a day.
///
/// Internally this is handled as the number of whole days since 1 Jan 1970 in a
/// similar fashion to how Apple's ``Date`` works. The raw calculations coming from the excellant work done [HERE](http://howardhinnant.github.io/date_algorithms.html#weekday_from_days).
/// All days being based on GMT. Then when converting to/from various timezones the appropriate number of seconds are added/removed to ensure that the
/// day is consistent for that timezone.
public struct Day {

    /// Used by functions to modify days.
    public enum Component {
        case year
        case month
        case day
    }

    public let daysSince1970: Int

    /// The year, month, and day-of-month components of this day, computed using Hinnant's civil_from_days algorithm.
    public var dayComponents: DayComponents {

        // Shift the epoch from 1970-01-01 to 0000-03-01.
        let daysSinceZero = daysSince1970 + 719_468

        // Calculate the era, adjusting for negative dates.
        let era = (daysSinceZero >= 0 ? daysSinceZero : daysSinceZero - 146_096) / 146_097

        let dayOfEra = daysSinceZero - era * 146_097 // Range: 0 -> 146096

        // Accounts for the variations in numbers of days during the early parts of an era.
        let yearOfEra = (dayOfEra - dayOfEra / 1460 + dayOfEra / 36524 - dayOfEra / 146_096) / 365 // Range: 0 -> 399

        let computedYear = yearOfEra + era * 400

        // Calculate the day of the year accounting for leap years and centuries.
        let dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra / 4 - yearOfEra / 100) // Range: 0 -> 365

        // Get the month based on March being month 0.
        let baseMonth = (5 * dayOfYear + 2) / 153 // Range: 0 -> 11

        // Calculate the day and month, shifting back to Jan = 1.
        let day = dayOfYear - (153 * baseMonth + 2) / 5 + 1 // Range: 1 -> 31
        let month = baseMonth < 10 ? baseMonth + 3 : baseMonth - 9 // Range: 1 -> 12

        // Adjust the year for Jan/Feb (which were at the end of the shifted year).
        let year = month <= 2 ? computedYear + 1 : computedYear

        return DayComponents(year: year, month: month, dayOfMonth: day)
    }

    // MARK: - Date helpers

    /// Returns `true` if the given year is a leap year.
    public static func isLeapYear(_ year: Int) -> Bool {
        year % 4 == 0 && (year % 100 != 0 || year % 400 == 0)
    }

    /// Returns the number of days in the given month and year.
    public static func daysInMonth(_ month: Int, year: Int) -> Int {
        switch month {
        case 1, 3, 5, 7, 8, 10, 12: 31
        case 4, 6, 9, 11: 30
        case 2: isLeapYear(year) ? 29 : 28
        default: fatalError("Invalid month: \(month)")
        }
    }

    /// Returns the number of days in the given year (365 or 366).
    public static func daysInYear(_ year: Int) -> Int {
        isLeapYear(year) ? 366 : 365
    }

    /// Returns a `Day` representing today.
    public static var today: Day { Day() }

    // MARK: - Initialisers

    /// Simplest initialiser that generates a day based on today's
    /// date.
    public init() {
        self.init(timeIntervalSince1970: Date.now.timeIntervalSince1970)
    }

    /// Initialiser accepting number of days.
    ///
    /// - daysSince1970: Same as ``Date``'s ``timeIntervalSince1970`` except expressed as the number of days.
    public init(daysSince1970: DayInterval) {
        self.daysSince1970 = daysSince1970
    }

    /// Initialiser matching that provided by ``Date``.
    ///
    /// - timeIntervalSince1970: A ``TimeInterval`` representing the number of seconds since 1970. To obtain the number of days
    /// all the time components will be truncated.
    public init(timeIntervalSince1970: TimeInterval) {
        self.init(daysSince1970: Int(timeIntervalSince1970) / (24 * 60 * 60))
    }

    /// Initializer that accepts a known date and calendar.
    ///
    /// The calendar and it's timezone is them used to extract the year, month and day values before passing to the
    /// ``init(date:usingCalendar:)`` initializer. Time components will be ignored.
    ///
    /// - parameter date: The date to read.
    /// - parameter calendar: The calender which will be used to extract the date components.
    public init(date: Date, usingCalendar calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        // Calendar always returns valid components, so try! is safe.
        try! self.init(year: components.year!, month: components.month!, day: components.day!)
    }

    /// Creates a ``Day`` from a ``DayComponents`` value.
    ///
    /// - parameter dayComponents: The components to use.
    /// - throws: ``DayError`` if month or day is out of range.
    public init(_ dayComponents: DayComponents) throws {
        try self.init(year: dayComponents.year, month: dayComponents.month, day: dayComponents.dayOfMonth)
    }

    /// Convenience wrapper for ``init(year:month:day:)`` that drops the argument names.
    ///
    /// - parameter year: The year.
    /// - parameter month: The month (1–12).
    /// - parameter day: The day (1–daysInMonth).
    /// - throws: ``DayError`` if month or day is out of range.
    public init(_ year: Int, _ month: Int, _ day: Int) throws {
        try self.init(year: year, month: month, day: day)
    }

    /// Creates a ``Day`` using the passed year, month and day.
    ///
    /// This calculates the ``daysSince1970`` value using Hinnant date algorithms.
    ///
    /// Note that this ``Day`` is Epoch based (UTC).
    ///
    /// The math here has been sourced from the very detailed formulas defined at [http://howardhinnant.github.io/date_algorithms.html](http://howardhinnant.github.io/date_algorithms.html)
    ///
    /// - parameter year: The year.
    /// - parameter month: The month (1–12).
    /// - parameter day: The day (1–daysInMonth).
    /// - throws: ``DayError`` if month or day is out of range.
    public init(year: Int, month: Int, day: Int) throws {

        guard (1 ... 12).contains(month) else {
            throw DayError.monthOutOfRange(month: month)
        }

        // Adjust year zero before validating the day range.
        let validatedYear = year == 0 ? 1 : year
        let maxDay = Day.daysInMonth(month, year: validatedYear)
        guard (1 ... maxDay).contains(day) else {
            throw DayError.dayOutOfRange(day: day, month: month, year: year)
        }

        // Hinnant's days_from_civil algorithm.

        // Adjust the year when the month is Jan or Feb to make the leap day the last day of the year.
        let adjustedYear = month <= 2 ? validatedYear - 1 : validatedYear

        // Calculate the era, adjusting for negative values.
        let era = (adjustedYear >= 0 ? adjustedYear : adjustedYear - 399) / 400

        let yearOfEra = adjustedYear - era * 400 // Range: 0 -> 399
        let dayOfYear = (153 * (month > 2 ? month - 3 : month + 9) + 2) / 5 + day - 1 // Range: 0 -> 365

        // Calculate the day of the era adjusting for leap years and centuries.
        let dayOfEra = yearOfEra * 365 + yearOfEra / 4 - yearOfEra / 100 + dayOfYear // Range: 0 -> 146096

        daysSince1970 = era * 146_097 + dayOfEra - 719_468
    }
}
