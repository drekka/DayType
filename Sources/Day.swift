//
// Copyright © Derek Clarkson. All rights reserved.
//

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

    private static let daysInEra = 146_097
    private static let negativeEraAdjustment = 146_096
    private static let unixTimeShift = 719_468

    public let daysSince1970: Int

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
        // This drops any partial seconds before calculating using ints which will drop any fractional results.
        self.init(date: Date(timeIntervalSince1970: timeIntervalSince1970))
    }

    /// Initializer that accepts a known date and calendar.
    ///
    /// The calendar and it's timezone is them used to extract the year, month and day values before passing to the
    /// ``init(date:usingCalendar:)`` initializer. Other components such as the time components will be ignoreed, or effectively
    /// dropped.
    ///
    /// - parameter date: The date to read.
    /// - parameter calendar: The calender which will be used to extract the date components.
    public init(date: Date, usingCalendar calendar: Calendar = .current) {
        let components = calendar.dateComponents([.year, .month, .day], from: date)
        self.init(year: components.year!, month: components.month!, day: components.day!)
    }

    /// Constructs a day using a passed ``DayComponents``.
    ///
    /// - parameter components: The components to construct the day from.
    public init(components: DayComponents) {
        self.init(year: components.year, month: components.month, day: components.day)
    }

    /// Conveniant wrpapper for ``init(year:month:day:)`` that drops the argument names.
    ///
    /// - parameter year: The year in the passed timezone.
    /// - parameter month: The month in the passed timezone.
    /// - parameter day: The day number in the passed timezone.
    public init(_ year: Int, _ month: Int, _ day: Int) {
        self.init(year: year, month: month, day: day)
    }

    /// Creates a ``Day`` using the passed year,month and day.
    ///
    /// This calculates the ``dayIntervalSince1970``.
    ///
    /// Note that this ``Day`` is Epoch based. ie. UTC. Also note that the passed values are rolling. So for example, passing a day of 45 for a month that has 30 days, will produce a date that is the 15th of the next month.
    ///
    /// The math here has been sourced from the very detailed formulas defined here: [http://howardhinnant.github.io/date_algorithms.html]()
    ///
    /// - parameter year: The year in the passed timezone.
    /// - parameter month: The month in the passed timezone.
    /// - parameter day: The day number in the passed timezone.
    public init(year: Int, month: Int, day: Int) {

        // Note: These calculations made use of the way Ints round fractional parts down.

        // The nature of calendars is that there is no such thing as year zero. Only year 1 AD or BC.
        let year = year == 0 ? 1 : year

        // Adjust the year when the month is Jan or Feb to make the leap day the last day of the year.
        let adjustedYear = month <= 2 ? year - 1 : year

        // Calculate the era, adjusting for negative values.
        let era = (adjustedYear >= 0 ? adjustedYear : adjustedYear - 399) / 400

        let yearOfEra = adjustedYear - era * 400 // Range: 0 -> 399
        let dayOfYear = (153 * (month > 2 ? month - 3 : month + 9) + 2) / 5 + day - 1 // Range: 0 -> 365

        // Calculate the day of the era adjusting for leap years and centuries.
        let dayOfEra = yearOfEra * 365 + yearOfEra / 4 - yearOfEra / 100 + dayOfYear // Range: 0 -> 146096

        daysSince1970 = era * Day.daysInEra + dayOfEra - Day.unixTimeShift
    }

    /// Returns the day components.
    public func dayComponents() -> DayComponents {

        // Shift the epoch from 1970-01-01 to 0000-03-01
        let daysSinceZero = daysSince1970 + Day.unixTimeShift

        // Recalcate the era allowing for negative dates.
        let era = (daysSinceZero >= 0 ? daysSinceZero : daysSinceZero - Day.negativeEraAdjustment) / Day.daysInEra

        let dayOfEra = daysSinceZero - era * Day.daysInEra // Range: 0-> 146096

        // This accounts for the variations in numbers of days during the early parts of an era. See doco for details.
        let yearOfEra = (dayOfEra - dayOfEra / 1460 + dayOfEra / 36524 - dayOfEra / 146_096) / 365 // Range: 0 -> 399

        let year = yearOfEra + era * 400

        // Calculate the day of the error accounting for leap years and centuries.
        let dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra / 4 - yearOfEra / 100) // Range: 0 -> 365

        // Now get the month based on the first month being March.
        let baseMonth = (5 * dayOfYear + 2) / 153 // Range: 0 -> 11

        // And finally get the day and month.
        let day = dayOfYear - (153 * baseMonth + 2) / 5 + 1 // Range: 1 -> 31
        let month = baseMonth < 10 ? baseMonth + 3 : baseMonth - 9 // Range: 1 -> 12

        return DayComponents(year: month <= 2 ? year + 1 : year, month: month, day: day)
    }
}
