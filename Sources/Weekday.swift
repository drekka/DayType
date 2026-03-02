import Foundation

/// Represents a day of the week.
///
/// Raw values match the Hinnant `weekday_from_days` algorithm output (0 = Sunday, 6 = Saturday).
public enum Weekday: Int, CaseIterable, Sendable {
    case sunday = 0
    case monday = 1
    case tuesday = 2
    case wednesday = 3
    case thursday = 4
    case friday = 5
    case saturday = 6
}

/// The day that begins each week in a calendar grid.
public enum StartOfWeek: Sendable {
    case sunday
    case monday

    var weekday: Weekday {
        switch self {
        case .sunday: .sunday
        case .monday: .monday
        }
    }
}
