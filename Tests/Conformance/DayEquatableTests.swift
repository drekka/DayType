import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Test("Equatable")
    func equals() throws {
        #expect(try Day(2020, 3, 12) == Day(2020, 3, 12))
        #expect(try Day(2020, 3, 12) != Day(2001, 1, 5))
    }
}
