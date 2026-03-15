import Foundation

public extension Day {

    /// The day of the week.
    ///
    /// Uses the Hinnant `weekday_from_days` algorithm sourced from
    /// [http://howardhinnant.github.io/date_algorithms.html](http://howardhinnant.github.io/date_algorithms.html#weekday_from_days).
    var weekday: Weekday {
        let z = daysSince1970
        return Weekday(rawValue: z >= -4 ? (z + 4) % 7 : (z + 5) % 7 + 6)!
    }
}
