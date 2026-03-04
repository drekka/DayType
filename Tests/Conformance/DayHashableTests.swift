import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Test("Hashable")
    func hashable() throws {
        var days: Set = [try Day(2020, 01, 11), try Day(2020, 01, 12)]

        #expect(try days.contains(Day(2020, 01, 13)) == false)
        #expect(try days.contains(Day(2020, 01, 12)) == true)

        // Modify and try again.
        try days.insert(Day(2020, 01, 13))
        #expect(days.count == 3)
        #expect(try days.contains(Day(2020, 01, 13)) == true)
        #expect(try days.contains(Day(2020, 01, 12)) == true)

        // Duplicate check.
        try days.insert(Day(2020, 01, 11))
        #expect(days.count == 3)
    }
}
