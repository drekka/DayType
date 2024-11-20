import DayType
import Foundation
import Testing

@Suite("Day Stridable tests")
struct DayStrideableTests {

    @Test("In a for loop with an open range")
    func testForEachOpenRange() {
        var days: [Day] = []
        for day in Day(2000, 1, 1) ... Day(2000, 1, 5) {
            days.append(day)
        }
        #expect(days == [Day(2000, 1, 1), Day(2000, 1, 2), Day(2000, 1, 3), Day(2000, 1, 4), Day(2000, 1, 5)])
    }

    @Test("In a for loop with a half open range")
    func testForEachHalfOpenRange() {
        var days: [Day] = []
        for day in Day(2000, 1, 1) ..< Day(2000, 1, 5) {
            days.append(day)
        }
        #expect(days == [Day(2000, 1, 1), Day(2000, 1, 2), Day(2000, 1, 3), Day(2000, 1, 4)])
    }

    @Test("With the stride function")
    func testForEachViaStrideFunction() {
        var days: [Day] = []
        for day in stride(from: Day(2000, 1, 1), to: Day(2000, 1, 5), by: 2) {
            days.append(day)
        }
        #expect(days == [Day(2000, 1, 1), Day(2000, 1, 3)])
    }

    func testDistanceTo() {
        #expect(Day(2020, 3, 6).distance(to: Day(2020, 3, 12)) == 6)
    }
}
