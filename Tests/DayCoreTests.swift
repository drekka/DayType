import DayType
import Foundation
import Testing

@Suite("Protocol conformance")
struct DayProtocols {

    @Test("Hash")
    func hash() {
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

    @Test("Equatble")
    func equals() {
        #expect(Day(2020, 3, 12) == Day(2020, 3, 12))
        #expect(Day(2020, 3, 12) != Day(2001, 1, 5))
    }

    @Suite("Comparable")
    struct DayComparableTests {

        @Test(">")
        func greaterThan() {
            #expect((Day(2020, 3, 12) > Day(2020, 3, 11)) == true)
            #expect((Day(2020, 3, 12) > Day(2020, 3, 12)) == false)
            #expect((Day(2020, 3, 12) > Day(2020, 3, 13)) == false)
        }

        @Test(">=")
        func greaterThanEquals() {
            #expect((Day(2020, 3, 12) >= Day(2020, 3, 11)) == true)
            #expect((Day(2020, 3, 12) >= Day(2020, 3, 12)) == true)
            #expect((Day(2020, 3, 12) >= Day(2020, 3, 13)) == false)
        }

        @Test("<")
        func lessThan() {
            #expect((Day(2020, 3, 12) < Day(2020, 3, 11)) == false)
            #expect((Day(2020, 3, 12) < Day(2020, 3, 12)) == false)
            #expect((Day(2020, 3, 12) < Day(2020, 3, 13)) == true)
        }

        @Test("<=")
        func lessThanEquals() {
            #expect((Day(2020, 3, 12) <= Day(2020, 3, 11)) == false)
            #expect((Day(2020, 3, 12) <= Day(2020, 3, 12)) == true)
            #expect((Day(2020, 3, 12) <= Day(2020, 3, 13)) == true)
        }
    }
}
