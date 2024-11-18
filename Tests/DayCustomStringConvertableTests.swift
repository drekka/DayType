import DayType
import Nimble
import XCTest

class DayCustomStringConvertableTests: XCTestCase {
    func testyDescription() {
        let date = DateComponents(calendar: .current, year: 2001, month: 2, day: 3).date!
        expect(Day(2001, 2, 3).description) == date.formatted(date: .abbreviated, time: .omitted)
    }
}
