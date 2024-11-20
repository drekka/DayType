import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Test("Day custom string convertable")
    func description() {
        let date = DateComponents(calendar: .current, year: 2001, month: 2, day: 3).date!
        #expect(Day(2001, 2, 3).description == date.formatted(date: .abbreviated, time: .omitted))
    }
}
