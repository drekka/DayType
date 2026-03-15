import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Suite("Comparable")
    struct DayComparableTests {

        @Test(">")
        func greaterThan() throws {
            #expect(try (Day(2020, 3, 12) > Day(2020, 3, 11)) == true)
            #expect(try (Day(2020, 3, 12) > Day(2020, 3, 12)) == false)
            #expect(try (Day(2020, 3, 12) > Day(2020, 3, 13)) == false)
        }

        @Test(">=")
        func greaterThanEquals() throws {
            #expect(try (Day(2020, 3, 12) >= Day(2020, 3, 11)) == true)
            #expect(try (Day(2020, 3, 12) >= Day(2020, 3, 12)) == true)
            #expect(try (Day(2020, 3, 12) >= Day(2020, 3, 13)) == false)
        }

        @Test("<")
        func lessThan() throws {
            #expect(try (Day(2020, 3, 12) < Day(2020, 3, 11)) == false)
            #expect(try (Day(2020, 3, 12) < Day(2020, 3, 12)) == false)
            #expect(try (Day(2020, 3, 12) < Day(2020, 3, 13)) == true)
        }

        @Test("<=")
        func lessThanEquals() throws {
            #expect(try (Day(2020, 3, 12) <= Day(2020, 3, 11)) == false)
            #expect(try (Day(2020, 3, 12) <= Day(2020, 3, 12)) == true)
            #expect(try (Day(2020, 3, 12) <= Day(2020, 3, 13)) == true)
        }
    }
}
