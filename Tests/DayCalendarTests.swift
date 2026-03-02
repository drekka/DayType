import DayType
import Foundation
import OrderedCollections
import Testing

@Suite("Day calendar month")
struct DayCalendarTests {

    // MARK: - Structure

    @Test("All rows have 7 elements")
    func rowLengths() {
        let month = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        for week in month.values {
            #expect(week.count == 7)
        }
    }

    @Test("Keys are first day of each week")
    func keysAreWeekStarts() {
        let month = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        for (key, week) in month {
            #expect(key == week[0].day)
            #expect(key.weekday == .monday)
        }
    }

    // MARK: - Monday start

    @Test("March 2026 starting Monday")
    func march2026MondayStart() {
        // March 2026: 1st is a Sunday, 31st is a Tuesday.
        // Monday-start grid should begin on Mon 23 Feb.
        let month = Day(2026, 3, 1).calendarMonth(startingOn: .monday)
        let weeks = Array(month.values)

        // First row starts Mon 23 Feb
        #expect(weeks[0][0].day == Day(2026, 2, 23))
        #expect(weeks[0][0].dayComponents.month == 2)

        // Sunday 1 March is the last day of the first row
        #expect(weeks[0][6].day == Day(2026, 3, 1))

        // Last row should contain March 31 (Tuesday) and end on Sunday 5 April
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].day == Day(2026, 4, 5))
        #expect(lastWeek[6].dayComponents.month == 4)

        // Key verification
        #expect(month.keys.first == Day(2026, 2, 23))
    }

    // MARK: - Sunday start

    @Test("March 2026 starting Sunday")
    func march2026SundayStart() {
        // March 2026: 1st is a Sunday.
        // Sunday-start grid should begin on Sun 1 March itself.
        let month = Day(2026, 3, 15).calendarMonth(startingOn: .sunday)
        let weeks = Array(month.values)

        // First day is Sunday 1 March
        #expect(weeks[0][0].day == Day(2026, 3, 1))
        #expect(weeks[0][0].dayComponents.month == 3)

        // Last row ends on Saturday 4 April
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].day == Day(2026, 4, 4))
    }

    // MARK: - February leap year

    @Test("February 2024 leap year starting Monday")
    func february2024LeapYear() {
        // Feb 2024: 1st is a Thursday, 29th is a Thursday (leap year).
        let month = Day(2024, 2, 14).calendarMonth(startingOn: .monday)
        let weeks = Array(month.values)

        // First row starts Mon 29 Jan
        #expect(weeks[0][0].day == Day(2024, 1, 29))

        // Should contain Feb 29
        let allDays = month.values.flatMap { $0 }
        #expect(allDays.contains { $0.day == Day(2024, 2, 29) })

        // Last row ends on Sunday 3 March
        let lastWeek = weeks[weeks.count - 1]
        #expect(lastWeek[6].day == Day(2024, 3, 3))
    }

    // MARK: - DayComponents populated

    @Test("CalendarDay contains correct components")
    func calendarDayComponents() {
        let month = Day(2026, 3, 1).calendarMonth(startingOn: .monday)
        let march15 = month.values.flatMap { $0 }.first { $0.day == Day(2026, 3, 15) }!
        #expect(march15.dayComponents.year == 2026)
        #expect(march15.dayComponents.month == 3)
        #expect(march15.dayComponents.day == 15)
    }

    // MARK: - Month starting on the start-of-week day

    @Test("June 2026 starts on Monday with Monday start")
    func june2026MondayStart() {
        // June 2026: 1st is a Monday.
        // Grid should start on June 1 itself.
        let month = Day(2026, 6, 15).calendarMonth(startingOn: .monday)
        #expect(month.keys.first == Day(2026, 6, 1))
    }

    // MARK: - Static convenience

    @Test("Static calendarMonth delegates to instance method")
    func staticCalendarMonth() {
        let fromStatic = Day.calendarMonth(containing: Day(2026, 3, 15), startingOn: .monday)
        let fromInstance = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        #expect(fromStatic.count == fromInstance.count)
        #expect(fromStatic.keys.first == fromInstance.keys.first)
    }

    // MARK: - Merging calendar months

    @Test("Merging consecutive months deduplicates boundary week")
    func mergeConsecutiveMonths() {
        let march = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        let merged = march + april

        // March and April share the week starting Mon 30 March.
        // Merged count should be the sum minus the shared week.
        #expect(merged.count == march.count + april.count - 1)
        #expect(merged.keys.first == march.keys.first)
        #expect(merged.keys.last == april.keys.last)
    }

    @Test("Merging non-adjacent months keeps all weeks")
    func mergeNonAdjacentMonths() {
        let jan = Day(2026, 1, 15).calendarMonth(startingOn: .monday)
        let march = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let merged = jan + march

        #expect(merged.count == jan.count + march.count)
    }

    @Test("Merging preserves chronological order")
    func mergePreservesOrder() {
        let march = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let april = Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        let merged = march + april

        let keys = Array(merged.keys)
        for i in 1 ..< keys.count {
            #expect(keys[i] > keys[i - 1])
        }
    }

    @Test("Merging same month produces identical result")
    func mergeSameMonth() {
        let month = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let merged = month + month

        #expect(merged.count == month.count)
    }

    // MARK: - Merging with a Day

    @Test("Merging with a Day adds that month")
    func mergeDayAddsMonth() {
        let march = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let merged = march + Day(2026, 4, 15)

        let april = Day(2026, 4, 15).calendarMonth(startingOn: .monday)
        #expect(merged.count == march.count + april.count - 1)
        #expect(merged.keys.last == april.keys.last)
    }

    @Test("Merging with a Day infers start of week")
    func mergeDayInfersStartOfWeek() {
        let march = Day(2026, 3, 15).calendarMonth(startingOn: .monday)
        let merged = march + Day(2026, 4, 15)

        // All keys should be Mondays since the lhs started on Monday
        for key in merged.keys {
            #expect(key.weekday == .monday)
        }
    }
}
