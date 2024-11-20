import DayType
import Foundation
import Testing

@Test("Day formatted() matches Date formatted strings")
func formatted() {

    let day = Day(2000, 2, 1)
    let date = DateComponents(calendar: .current, year: 2000, month: 2, day: 1).date!

    #expect(day.formatted() == date.formatted(date: .abbreviated, time: .omitted))
    #expect(day.formatted(.abbreviated) == date.formatted(date: .abbreviated, time: .omitted))
    #expect(day.formatted(.complete) == date.formatted(date: .complete, time: .omitted))
    #expect(day.formatted(.long) == date.formatted(date: .long, time: .omitted))
    #expect(day.formatted(.numeric) == date.formatted(date: .numeric, time: .omitted))
}
