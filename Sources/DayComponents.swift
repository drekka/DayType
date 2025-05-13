import Foundation

/// Similar to Swift's ``DateComponents`` in that it contains the individual components of a ``Day``.
public struct DayComponents {

    public let year: Int
    public let month: Int
    public let day: Int

    public init(year: Int, month: Int, day: Int) {
        self.year = year
        self.month = month
        self.day = day
    }
}
