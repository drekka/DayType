import DayType
import Testing

@Suite("Day init validation")
struct DayRollingTests {

    // MARK: - Valid boundaries

    @Test("Valid month boundaries")
    func validMonthBoundaries() throws {
        _ = try Day(2026, 1, 1)
        _ = try Day(2026, 12, 31)
    }

    @Test("Feb 29 in leap year is valid")
    func feb29InLeapYear() throws {
        let components = try Day(2024, 2, 29).dayComponents
        #expect(components.year == 2024)
        #expect(components.month == 2)
        #expect(components.dayOfMonth == 29)
    }

    @Test("Feb 28 in non-leap year is valid")
    func feb28InNonLeapYear() throws {
        let components = try Day(2026, 2, 28).dayComponents
        #expect(components.dayOfMonth == 28)
    }

    @Test("Day 31 in 31-day months")
    func day31InLongMonths() throws {
        for month in [1, 3, 5, 7, 8, 10, 12] {
            _ = try Day(2026, month, 31)
        }
    }

    @Test("Day 30 in 30-day months")
    func day30InShortMonths() throws {
        for month in [4, 6, 9, 11] {
            _ = try Day(2026, month, 30)
        }
    }

    // MARK: - Invalid month

    @Test("Month 0 throws monthOutOfRange")
    func month0Throws() {
        #expect {
            try Day(2026, 0, 1)
        } throws: { error in
            error as? DayError == .monthOutOfRange(month: 0)
        }
    }

    @Test("Month 13 throws monthOutOfRange")
    func month13Throws() {
        #expect {
            try Day(2026, 13, 1)
        } throws: { error in
            error as? DayError == .monthOutOfRange(month: 13)
        }
    }

    @Test("Negative month throws monthOutOfRange")
    func negativeMonthThrows() {
        #expect {
            try Day(2026, -5, 1)
        } throws: { error in
            error as? DayError == .monthOutOfRange(month: -5)
        }
    }

    // MARK: - Invalid day

    @Test("Day 0 throws dayOutOfRange")
    func day0Throws() {
        #expect {
            try Day(2026, 3, 0)
        } throws: { error in
            error as? DayError == .dayOutOfRange(day: 0, month: 3, year: 2026)
        }
    }

    @Test("Day 32 in January throws dayOutOfRange")
    func day32InJanuaryThrows() {
        #expect {
            try Day(2026, 1, 32)
        } throws: { error in
            error as? DayError == .dayOutOfRange(day: 32, month: 1, year: 2026)
        }
    }

    @Test("Day 31 in 30-day month throws dayOutOfRange")
    func day31In30DayMonthThrows() {
        #expect {
            try Day(2026, 4, 31)
        } throws: { error in
            error as? DayError == .dayOutOfRange(day: 31, month: 4, year: 2026)
        }
    }

    @Test("Feb 29 in non-leap year throws dayOutOfRange")
    func feb29InNonLeapYearThrows() {
        #expect {
            try Day(2026, 2, 29)
        } throws: { error in
            error as? DayError == .dayOutOfRange(day: 29, month: 2, year: 2026)
        }
    }

    @Test("Negative day throws dayOutOfRange")
    func negativeDayThrows() {
        #expect {
            try Day(2026, 3, -1)
        } throws: { error in
            error as? DayError == .dayOutOfRange(day: -1, month: 3, year: 2026)
        }
    }

    // MARK: - Helpers

    @Test("Leap year detection")
    func leapYearDetection() {
        #expect(Day.isLeapYear(2000) == true) // Divisible by 400
        #expect(Day.isLeapYear(1900) == false) // Century, not divisible by 400
        #expect(Day.isLeapYear(2024) == true) // Divisible by 4
        #expect(Day.isLeapYear(2025) == false) // Not divisible by 4
    }

    @Test("Days in month")
    func daysInMonthValues() {
        #expect(Day.daysInMonth(1, year: 2026) == 31)
        #expect(Day.daysInMonth(2, year: 2026) == 28)
        #expect(Day.daysInMonth(2, year: 2024) == 29)
        #expect(Day.daysInMonth(4, year: 2026) == 30)
        #expect(Day.daysInMonth(12, year: 2026) == 31)
    }

    @Test("Days in year")
    func daysInYearValues() {
        #expect(Day.daysInYear(2024) == 366)
        #expect(Day.daysInYear(2025) == 365)
        #expect(Day.daysInYear(1900) == 365)
        #expect(Day.daysInYear(2000) == 366)
    }
}
