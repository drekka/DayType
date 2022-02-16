import Foundation

public typealias DayInterval = Int

/// Represents a day as opposed to the point in time that Swift's core ``Date`` represents.
///
/// Because a day is a period rather than a specific point in time, instances are not easily translated to and from ``Date`` as a day can be plus or minus 1 day depending on the timezone of the date. Therefore when converting a ``Date`` to a ``Day`` the internal number of seconds since 1970 is used to calculate the number of days. Then when generating a ``Date`` from a ``Day``, the ``TimeZone`` as well as the hours, minutes and seconds are needed in order to calculate the final amount of seconds since 1970 used to build the  ``Date``.
///
/// The math in this class is based on the math presented in great detail here [http://howardhinnant.github.io/date_algorithms.html]()
public struct Day {

    /// The number of days since 01/01/1970 UTC.
    public let dayIntervalSince1970: Int

    /// Creates a ``Day`` based on a specific date.
    ///
    /// - parameter date: The date to base the day on. Defaults to today.
    public init(date: Date = Date()) {
        self.init(timeIntervalSince1970: date.timeIntervalSince1970)
    }

    /// Creates a ``Day`` instance which refers to the UTC date of the passed timestamp.
    ///
    /// In creating the day, any hours, minutes and seconds will be truncated and lost.
    ///
    /// - parameter interval: The number of seconds that has passed from 1970-01-01 00:00:00 UTC.
    public init(timeIntervalSince1970 interval: TimeInterval) {
        dayIntervalSince1970 = Int(interval) / (24 * 60 * 60)
    }

    /// Creates a `Day` instance set with the number of days since 1970-10-01.
    ///
    /// This is UTC based.
    public init(dayIntervalSince1970 interval: DayInterval) {
        dayIntervalSince1970 = interval
    }

    /// Shortcut initializer that routes to ``init(year:month:day:inTimeZone:)``.
    public init(_ year: Int, _ month: Int, _ day: Int, inTimeZone timeZone: TimeZone = .current) {
        self.init(year: year, month: month, day: day, inTimeZone: timeZone)
    }

    /// Creates a ``Day`` using the passed year,month and day.
    ///
    /// This calculates the ``dayIntervalSince1970``.
    ///
    /// Note that this ``Day`` is Epoch based. ie. UTC. Also note that the passed values are rolling. So for example, passing a day of 45 for a month that has 30 days, will produce a date that is the 15th of the next month.
    ///
    /// - parameter timeZone: Defaults to the current timezone.
    /// - parameter year: The year.
    /// - parameter month: The month.
    /// - parameter day: The day number.
    public init(year: Int, month: Int, day: Int, inTimeZone timeZone: TimeZone = .current) {

        // Shift year back one if month is before March.
        // By basing a year from Mar 1 we can assume that Feb 28/29 is the last day of the preceeding year. This makes leap year's easier to deal with.
        let offsetYear = year - (month <= 2 ? 1 : 0)

        // Eras repeat every 400 years which makes long distances easy to calculate. This rounds down.
        let era = Int((offsetYear >= 0 ? offsetYear : offsetYear - 399) / 400)

        let yearOfEra = offsetYear - era * 400

        // Get the month index adjusted to start at Mar
        let offsetMonthIndex = month + (month > 2 ? -3 : 9)

        // Calc days from Mar 1 to first day of month.
        let wholeMonthDaysSinceOffset = (153 * offsetMonthIndex + 2) / 5
        let dayOfYearIndex = wholeMonthDaysSinceOffset + day - 1

        // Now combine the era and days.
        // 365 per year + extra day per leap year, minus 1 day per hundred years, plus day index of year.
        let dayOfEra = yearOfEra * 365
            + yearOfEra / 4
            - yearOfEra / 100
            + dayOfYearIndex

        // Era * days in era + days in current error - 1970
        let daysSince1970 = era * 146_097 + dayOfEra - 719_468
            // and subtract a day if the time zone is postive.
            - (timeZone.secondsFromGMT() > 0 ? 1 : 0)

        self.init(dayIntervalSince1970: daysSince1970)
    }
}

extension Day: Equatable {}

extension Day: Comparable {
    public static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.dayIntervalSince1970 < rhs.dayIntervalSince1970
    }
}
