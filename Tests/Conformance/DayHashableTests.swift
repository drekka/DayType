import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Test("Hashable")
    func hashable() {
        var days: Set = [Day(2020, 01, 11), Day(2020, 01, 12)]

        #expect(days.contains(Day(2020, 01, 13)) == false)
        #expect(days.contains(Day(2020, 01, 12)) == true)

        // Modify and try again.
        days.insert(Day(2020, 01, 13))
        #expect(days.count == 3)
        #expect(days.contains(Day(2020, 01, 13)) == true)
        #expect(days.contains(Day(2020, 01, 12)) == true)

        // Duplicate check.
        days.insert(Day(2020, 01, 11))
        #expect(days.count == 3)
    }
}
