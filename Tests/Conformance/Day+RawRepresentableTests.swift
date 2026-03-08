import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Test("RawRepresentable init from rawValue")
    func rawRepresentableInit() throws {
        let day = try Day(2026, 3, 8)
        let restored = Day(rawValue: day.daysSince1970)
        #expect(restored == day)
    }

    @Test("RawRepresentable rawValue matches daysSince1970")
    func rawRepresentableRawValue() throws {
        let day = try Day(2026, 3, 8)
        #expect(day.rawValue == day.daysSince1970)
    }

    @Test("RawRepresentable round trip")
    func rawRepresentableRoundTrip() throws {
        let day = try Day(2024, 2, 29)
        let rawValue = day.rawValue
        let restored = Day(rawValue: rawValue)
        #expect(restored == day)
        #expect(restored?.dayComponents.dayOfMonth == 29)
    }

    @Test("RawRepresentable with negative daysSince1970")
    func rawRepresentableNegative() {
        let day = Day(daysSince1970: -1)
        let restored = Day(rawValue: day.rawValue)
        #expect(restored == day)
        #expect(restored?.dayComponents.year == 1969)
    }

    @Test("RawRepresentable epoch zero")
    func rawRepresentableEpochZero() {
        let day = Day(rawValue: 0)
        #expect(day?.daysSince1970 == 0)
        #expect(day?.dayComponents.year == 1970)
        #expect(day?.dayComponents.month == 1)
        #expect(day?.dayComponents.dayOfMonth == 1)
    }
}
