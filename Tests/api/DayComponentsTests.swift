import DayType
import Foundation
import OrderedCollections
import Testing

@Suite("Day calendar month")
struct DayComponentsTests {

    // MARK: - Structure

    @Test("Components generation")
    func rowLengths() throws {
        let components = try Day(2026, 3, 15).dayComponents
        #expect(components.year == 2026)
        #expect(components.month == 3)
        #expect(components.dayOfMonth == 15)
    }

    @Test("Components generation and reversion")
    func componentsReversion() throws {
        let originalDay = try Day(2026, 3, 15)
        let components = try Day(2026, 3, 15).dayComponents
        let componentsDay = try components.day()
        #expect(originalDay == componentsDay)
    }

    // MARK: - Equatable

    @Test("Equal components are equal")
    func equalComponents() {
        let a = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        let b = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        #expect(a == b)
    }

    @Test("Different components are not equal")
    func differentComponents() {
        let a = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        let b = DayComponents(year: 2026, month: 3, dayOfMonth: 16)
        #expect(a != b)
    }

    // MARK: - Hashable

    @Test("Equal components produce equal hashes")
    func equalHashes() {
        let a = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        let b = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        #expect(a.hashValue == b.hashValue)
    }

    @Test("Can be used as Set elements")
    func setMembership() {
        let a = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        let b = DayComponents(year: 2026, month: 3, dayOfMonth: 15)
        let c = DayComponents(year: 2026, month: 4, dayOfMonth: 1)
        let set: Set<DayComponents> = [a, b, c]
        #expect(set.count == 2)
    }

}
