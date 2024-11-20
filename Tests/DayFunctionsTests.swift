import DayType
import Foundation
import Testing

@Suite("Day functions")
struct DayFunctionsTests {

    @Test("Adding days")
    func addingDays() {
        #expect(Day(2001, 2, 3).day(byAdding: .day, value: 3) == Day(2001, 2, 6))
        #expect(Day(2001, 2, 3).day(byAdding: .month, value: 3) == Day(2001, 5, 3))
        #expect(Day(2001, 2, 3).day(byAdding: .year, value: 3) == Day(2004, 2, 3))
    }

    @Test("Adding and rolling days")
    func rollingDays() {
        #expect(Day(2001, 2, 3).day(byAdding: .day, value: 55) == Day(2001, 3, 30))
        #expect(Day(2001, 2, 3).day(byAdding: .month, value: 55) == Day(2005, 9, 10))
    }
}
