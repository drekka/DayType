import DayType
import Foundation
import Testing

@Suite("Day operations")
struct DayOperationTests {

    @Test("+")
    func plus() {
        #expect((Day(daysSince1970: 19445) + 5).daysSince1970 == 19450)
    }

    @Test("-")
    func minus() {
        #expect((Day(daysSince1970: 19445 - 5).daysSince1970) == 19440)
    }

    @Test("+=")
    func inplacePlus() {
        var day = Day(daysSince1970: 19445)
        day += 5
        #expect(day.daysSince1970 == 19450)
    }

    @Test("-=")
    func inplaceMinus() {
        var day = Day(daysSince1970: 19445)
        day -= 5
        #expect(day.daysSince1970 == 19440)
    }

    @Test("Diff")
    func dayDiff() {
        #expect(Day(2020, 3, 12) - Day(2020, 3, 6) == 6)
    }
}
