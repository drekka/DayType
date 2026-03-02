import DayType
import Foundation
import Testing

@Suite("Day weekday")
struct DayWeekdayTests {

    @Test("1970-01-01 is a Thursday")
    func epoch() {
        #expect(Day(1970, 1, 1).weekday == .thursday)
    }

    @Test("Known weekdays")
    func knownDates() {
        #expect(Day(2026, 3, 2).weekday == .monday)
        #expect(Day(2026, 3, 3).weekday == .tuesday)
        #expect(Day(2026, 3, 4).weekday == .wednesday)
        #expect(Day(2026, 3, 5).weekday == .thursday)
        #expect(Day(2026, 3, 6).weekday == .friday)
        #expect(Day(2026, 3, 7).weekday == .saturday)
        #expect(Day(2026, 3, 8).weekday == .sunday)
    }

    @Test("Dates before epoch")
    func preEpoch() {
        // 1969-12-31 was a Wednesday
        #expect(Day(1969, 12, 31).weekday == .wednesday)
        // 1900-01-01 was a Monday
        #expect(Day(1900, 1, 1).weekday == .monday)
    }
}
