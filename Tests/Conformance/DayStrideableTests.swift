import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Suite("Stridable")
    struct DayStrideableTests {

        @Test("In a for loop with an open range")
        func forEachOpenRange() throws {
            var days: [Day] = []
            for day in try Day(2000, 1, 1) ... Day(2000, 1, 5) {
                days.append(day)
            }
            #expect(try days == [Day(2000, 1, 1), Day(2000, 1, 2), Day(2000, 1, 3), Day(2000, 1, 4), Day(2000, 1, 5)])
        }

        @Test("In a for loop with a half open range")
        func forEachHalfOpenRange() throws {
            var days: [Day] = []
            for day in try Day(2000, 1, 1) ..< Day(2000, 1, 5) {
                days.append(day)
            }
            #expect(try days == [Day(2000, 1, 1), Day(2000, 1, 2), Day(2000, 1, 3), Day(2000, 1, 4)])
        }

        @Test("With the stride function")
        func forEachViaStrideFunction() throws {
            var days: [Day] = []
            for day in stride(from: try Day(2000, 1, 1), to: try Day(2000, 1, 5), by: 2) {
                days.append(day)
            }
            #expect(try days == [Day(2000, 1, 1), Day(2000, 1, 3)])
        }

        @Test("Distance function")
        func distanceTo() throws {
            #expect(try Day(2020, 3, 6).distance(to: Day(2020, 3, 12)) == 6)
        }
    }
}
