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
        // Feb 3, 2001 + 55 months = Sep 3, 2005
        #expect(try Day(2001, 2, 3).day(byAdding: .month, value: 55) == Day(2005, 9, 3))
    }

    @Test("Subtracting days")
    func subtractingDays() throws {
        #expect(try Day(2026, 3, 15).day(byAdding: .day, value: -10) == Day(2026, 3, 5))
    }

    @Test("Subtracting months")
    func subtractingMonths() throws {
        #expect(try Day(2026, 3, 15).day(byAdding: .month, value: -1) == Day(2026, 2, 15))
        #expect(try Day(2026, 3, 15).day(byAdding: .month, value: -3) == Day(2025, 12, 15))
    }

    @Test("Subtracting years")
    func subtractingYears() throws {
        #expect(try Day(2026, 3, 15).day(byAdding: .year, value: -1) == Day(2025, 3, 15))
    }

    @Test("Adding months across year boundary")
    func monthsCrossingYearBoundary() throws {
        #expect(try Day(2025, 11, 15).day(byAdding: .month, value: 3) == Day(2026, 2, 15))
    }

    // MARK: - Day clamping

    @Test("Adding month clamps day to end of shorter month")
    func monthClampingForward() throws {
        // Jan 31 + 1 month = Feb 28 (non-leap year)
        #expect(try Day(2026, 1, 31).day(byAdding: .month, value: 1) == Day(2026, 2, 28))
        // Jan 31 + 1 month = Feb 29 (leap year)
        #expect(try Day(2024, 1, 31).day(byAdding: .month, value: 1) == Day(2024, 2, 29))
        // Jan 31 + 3 months = Apr 30
        #expect(try Day(2026, 1, 31).day(byAdding: .month, value: 3) == Day(2026, 4, 30))
        // Aug 31 + 1 month = Sep 30
        #expect(try Day(2026, 8, 31).day(byAdding: .month, value: 1) == Day(2026, 9, 30))
    }

    @Test("Subtracting month clamps day to end of shorter month")
    func monthClampingBackward() throws {
        // Mar 31 - 1 month = Feb 28 (non-leap year)
        #expect(try Day(2026, 3, 31).day(byAdding: .month, value: -1) == Day(2026, 2, 28))
        // Mar 31 - 1 month = Feb 29 (leap year)
        #expect(try Day(2024, 3, 31).day(byAdding: .month, value: -1) == Day(2024, 2, 29))
        // Dec 31 - 1 month = Nov 30
        #expect(try Day(2026, 12, 31).day(byAdding: .month, value: -1) == Day(2026, 11, 30))
    }

    @Test("Adding year clamps Feb 29 to Feb 28 in non-leap year")
    func yearClampingLeapDay() throws {
        // Feb 29 + 1 year = Feb 28 (2025 is not a leap year)
        #expect(try Day(2024, 2, 29).day(byAdding: .year, value: 1) == Day(2025, 2, 28))
        // Feb 29 - 1 year = Feb 28 (2023 is not a leap year)
        #expect(try Day(2024, 2, 29).day(byAdding: .year, value: -1) == Day(2023, 2, 28))
        // Feb 29 + 4 years = Feb 29 (2028 is a leap year)
        #expect(try Day(2024, 2, 29).day(byAdding: .year, value: 4) == Day(2028, 2, 29))
    }

    @Test("Adding year preserves date when no clamping needed")
    func yearNoClamping() throws {
        #expect(try Day(2024, 3, 1).day(byAdding: .year, value: 1) == Day(2025, 3, 1))
        #expect(try Day(2025, 3, 1).day(byAdding: .year, value: 1) == Day(2026, 3, 1))
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
