import DayType
import Foundation
import Testing

@Suite("Day functions")
struct DayFunctionsTests {

    @Test("Adding days")
    func addingDays() throws {
        #expect(try Day(2001, 2, 3).day(byAdding: .day, value: 3) == Day(2001, 2, 6))
        #expect(try Day(2001, 2, 3).day(byAdding: .month, value: 3) == Day(2001, 5, 3))
        #expect(try Day(2001, 2, 3).day(byAdding: .year, value: 3) == Day(2004, 2, 3))
    }

    @Test("Adding days with large day value")
    func addingLargeDayValue() throws {
        // Feb 3 + 55 days = March 30 (Feb has 28 days in 2001)
        #expect(try Day(2001, 2, 3).day(byAdding: .day, value: 55) == Day(2001, 3, 30))
    }

    @Test("Adding months with large value")
    func addingLargeMonthValue() throws {
        // Feb 3, 2001 + 55 months = Sep 3, 2005 (exact day-count arithmetic)
        #expect(try Day(2001, 2, 3).day(byAdding: .month, value: 55) == Day(2005, 9, 3))
    }

    @Test("Subtracting days")
    func subtractingDays() throws {
        #expect(try Day(2026, 3, 15).day(byAdding: .day, value: -10) == Day(2026, 3, 5))
    }

    @Test("Subtracting months")
    func subtractingMonths() throws {
        // March 15 - 1 month: subtract Feb's 28 days = Feb 15
        #expect(try Day(2026, 3, 15).day(byAdding: .month, value: -1) == Day(2026, 2, 15))
        // March 15 - 3 months: subtract Feb(28) + Jan(31) + Dec(31) = 90 days
        #expect(try Day(2026, 3, 15).day(byAdding: .month, value: -3) == Day(2025, 12, 15))
    }

    @Test("Subtracting years")
    func subtractingYears() throws {
        #expect(try Day(2026, 3, 15).day(byAdding: .year, value: -1) == Day(2025, 3, 15))
    }

    @Test("Adding months across year boundary")
    func monthsCrossingYearBoundary() throws {
        // Nov 15 + 3 months: Nov(30) + Dec(31) + Jan(31) = 92 days → Feb 15
        #expect(try Day(2025, 11, 15).day(byAdding: .month, value: 3) == Day(2026, 2, 15))
    }

    @Test("Adding year crossing leap year")
    func yearCrossingLeapYear() throws {
        // 2024 is a leap year (366 days). Adding from March overshoots by 1 because
        // Feb 29 was before our start date but is still counted in the year's total.
        #expect(try Day(2024, 3, 1).day(byAdding: .year, value: 1) == Day(2025, 3, 2))
        // 2025 is not a leap year (365 days) — lands exactly on same date
        #expect(try Day(2025, 3, 1).day(byAdding: .year, value: 1) == Day(2026, 3, 1))
        // Starting from Jan 1 of a leap year, full 366 days lands on Jan 1 next year
        #expect(try Day(2024, 1, 1).day(byAdding: .year, value: 1) == Day(2025, 1, 1))
    }

    @Test("Adding zero does nothing")
    func addingZero() throws {
        let day = try Day(2026, 3, 15)
        #expect(day.day(byAdding: .day, value: 0) == day)
        #expect(day.day(byAdding: .month, value: 0) == day)
        #expect(day.day(byAdding: .year, value: 0) == day)
    }
}
