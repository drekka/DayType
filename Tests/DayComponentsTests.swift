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

}
