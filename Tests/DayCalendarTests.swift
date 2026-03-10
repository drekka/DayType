import DayType
import Foundation
import OrderedCollections
import Testing

@Suite("Day calendar month")
struct DayCalendarTests {

    // MARK: - Structure

    @Test("All rows have 7 elements")
    func rowLengths() throws {
        let month = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        for week in month.values {
            #expect(week.count == 7)
        }
    }

    @Test("Keys are first day of each week")
    func keysAreWeekStarts() throws {
        let month = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        for (key, week) in month {
            // Key should match the first element's day.
            #expect(key == week[0].day)
            #expect(key.weekday == .monday)
        }
    }

    // MARK: - Monday start

    @Test("March 2026 starting Monday")
    func march2026MondayStart() throws {
        // March 2026: 1st is a Sunday, 31st is a Tuesday.
        // Monday-start grid should begin on Mon 23 Feb.
        let month = try Day(2026, 3, 1).calendarMonth(startingOn: .monday)
        let weeks = Array(month.values)

        // First row starts Mon 23 Feb
        #expect(try month.keys.first == Day(2026, 2, 23))
        #expect(weeks[0][0].dayComponents.month == 2)

        // Sunday 1 March is the last day of the first row
        #expect(weeks[0][6].dayComponents.month == 3)
        #expect(weeks[0][6].dayComponents.dayOfMonth == 1)

        // Last row should contain March 31 (Tuesday) and end on Sunday 5 April
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].dayComponents.month == 4)
        #expect(lastWeek[6].dayComponents.dayOfMonth == 5)

        // Key verification
        #expect(try month.keys.first == Day(2026, 2, 23))
    }

    // MARK: - Sunday start

    @Test("March 2026 starting Sunday")
    func march2026SundayStart() throws {
        // March 2026: 1st is a Sunday.
        // Sunday-start grid should begin on Sun 1 March itself.
        let month = try Day(2026, 3, 15).calendarMonth(startingOn: .sunday)
        let weeks = Array(month.values)

        // First day is Sunday 1 March
        #expect(try month.keys.first == Day(2026, 3, 1))
        #expect(weeks[0][0].dayComponents.month == 3)

        // Last row ends on Saturday 4 April
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].dayComponents.month == 4)
        #expect(lastWeek[6].dayComponents.dayOfMonth == 4)
    }

    // MARK: - February leap year

    @Test("February 2024 leap year starting Monday")
    func february2024LeapYear() throws {
        // Feb 2024: 1st is a Thursday, 29th is a Thursday (leap year).
        let month = try Day(2024, 2, 14).calendarMonth(startingOn: .monday)
        let weeks = Array(month.values)

        // First row starts Mon 29 Jan
        #expect(try month.keys.first == Day(2024, 1, 29))

        // Should contain Feb 29
        let allDays = month.values.flatMap { $0 }
        #expect(allDays.contains { $0.dayComponents.month == 2 && $0.dayComponents.dayOfMonth == 29 })

        // Last row ends on Sunday 3 March
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].dayComponents.month == 3)
        #expect(lastWeek[6].dayComponents.dayOfMonth == 3)
    }

    // MARK: - Day properties populated

    @Test("Calendar days contain correct properties")
    func calendarDayProperties() throws {
        let month = try Day(2026, 3, 1).calendarMonth(startingOn: .monday)
        let march15 = month.values.flatMap { $0 }.first { $0.dayComponents.month == 3 && $0.dayComponents.dayOfMonth == 15 }!
        #expect(march15.dayComponents.year == 2026)
        #expect(march15.dayComponents.month == 3)
        #expect(march15.dayComponents.dayOfMonth == 15)
        #expect(try march15.day == Day(2026, 3, 15))
    }

    // MARK: - Month starting on the start-of-week day

    @Test("June 2026 starts on Monday with Monday start")
    func june2026MondayStart() throws {
        // June 2026: 1st is a Monday.
        // Grid should start on June 1 itself.
        let month = try Day(2026, 6, 15).calendarMonth(startingOn: .monday)
        #expect(try month.keys.first == Day(2026, 6, 1))
    }

    // MARK: - Static convenience

    @Test("Static calendarMonth delegates to instance method")
    func staticCalendarMonth() throws {
        let fromStatic = try Day.calendarMonth(containing: Day(2026, 3, 15), startingOn: .monday)
        let fromInstance = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        #expect(fromStatic.count == fromInstance.count)
        #expect(fromStatic.keys.first == fromInstance.keys.first)
    }

    // MARK: - Merging calendar months

    @Test("Merging consecutive months deduplicates boundary week")
    func mergeConsecutiveMonths() throws {
        let march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = try Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        let merged = march + april

        #expect(merged.count == march.count + april.count - 1)
    }

    @Test("Merging non-adjacent months keeps all weeks")
    func mergeNonAdjacentMonths() throws {
        let jan = try Day(2026, 1, 15).calendarMonth(startingOn: .monday)
        let march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let merged = jan + march

        #expect(merged.count == jan.count + march.count)
    }

    @Test("Merging duplicate month does not change count")
    func mergeSameMonth() throws {
        let march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = try Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        let calendar = march + april
        let merged = calendar + march

        #expect(merged.count == calendar.count)
    }

    @Test("+= deduplicates boundary week")
    func plusEqualsDeduplicates() throws {
        var march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = try Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        let expectedCount = march.count + april.count - 1
        march += april

        #expect(march.count == expectedCount)
    }

    @Test("+= duplicate month does not change count")
    func plusEqualsSameMonth() throws {
        let march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = try Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        var calendar = march + april
        let expectedCount = calendar.count
        calendar += march

        #expect(calendar.count == expectedCount)
    }
}
