import Foundation

/// Contains the year, month, and day-of-month components of a ``Day``.
///
/// Similar to Foundation's ``DateComponents`` but limited to the date components relevant to a ``Day``.
public struct DayComponents {

    public let year: Int
    public let month: Int
    public let dayOfMonth: Int

    public init(year: Int, month: Int, dayOfMonth: Int) {
        self.year = year
        self.month = month
        self.dayOfMonth = dayOfMonth
    }

    public func day() throws -> Day {
        try Day(self)
    }
}

extension DayComponents: Equatable, Hashable {}


