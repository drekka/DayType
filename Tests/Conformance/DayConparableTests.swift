import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

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
