import DayType
import Testing

@Suite("CalendarDay")
struct CalendarDayTests {

    // MARK: - Init

    @Test("Pre-computes day components from day")
    func initComponents() throws {
        let calendarDay = try CalendarDay(day: Day(2026, 3, 15))
        #expect(calendarDay.dayComponents.year == 2026)
        #expect(calendarDay.dayComponents.month == 3)
        #expect(calendarDay.dayComponents.dayOfMonth == 15)
    }

    // MARK: - Equatable

    @Test("Equal calendar days are equal")
    func equalCalendarDays() throws {
        let a = try CalendarDay(day: Day(2026, 3, 15))
        let b = try CalendarDay(day: Day(2026, 3, 15))
        #expect(a == b)
    }

    @Test("Different calendar days are not equal")
    func differentCalendarDays() throws {
        let a = try CalendarDay(day: Day(2026, 3, 15))
        let b = try CalendarDay(day: Day(2026, 3, 16))
        #expect(a != b)
    }

    // MARK: - Hashable

    @Test("Equal calendar days produce equal hashes")
    func equalHashes() throws {
        let a = try CalendarDay(day: Day(2026, 3, 15))
        let b = try CalendarDay(day: Day(2026, 3, 15))
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Can be used as Set elements")
    func setMembership() throws {
        let a = try CalendarDay(day: Day(2026, 3, 15))
        let b = try CalendarDay(day: Day(2026, 3, 15))
        let c = try CalendarDay(day: Day(2026, 4, 1))
        let set: Set<CalendarDay> = [a, b, c]
        #expect(set.count == 2)
    }

    // MARK: - Identifiable

    @Test("ID is the day")
    func identifiable() throws {
        let day = try Day(2026, 3, 15)
        let calendarDay = CalendarDay(day: day)
        #expect(calendarDay.id == day)
    }
}
