import DayType
import Foundation
import Testing

@Suite("Day weekday")
struct DayWeekdayTests {

    @Test("1970-01-01 is a Thursday")
    func epoch() throws {
        #expect(try Day(1970, 1, 1).weekday == .thursday)
    }

    @Test("Known weekdays")
    func knownDates() throws {
        #expect(try Day(2026, 3, 2).weekday == .monday)
        #expect(try Day(2026, 3, 3).weekday == .tuesday)
        #expect(try Day(2026, 3, 4).weekday == .wednesday)
        #expect(try Day(2026, 3, 5).weekday == .thursday)
        #expect(try Day(2026, 3, 6).weekday == .friday)
        #expect(try Day(2026, 3, 7).weekday == .saturday)
        #expect(try Day(2026, 3, 8).weekday == .sunday)
    }

    @Test("Dates before epoch")
    func preEpoch() throws {
        // 1969-12-31 was a Wednesday
        #expect(try Day(1969, 12, 31).weekday == .wednesday)
        // 1900-01-01 was a Monday
        #expect(try Day(1900, 1, 1).weekday == .monday)
    }
}
