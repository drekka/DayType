@testable import DayType
import Nimble
import XCTest

final class DayTests: XCTestCase {

    private var utcDate: Date!
    private var localDate: Date!

    private let melbourne = TimeZone(identifier: "Australia/Melbourne")!
    private let utc = TimeZone(identifier: "UTC")!
    private let pst = TimeZone(identifier: "PST")!

    override func setUp() {
        // These two dates are the same point in time, even though the dates are different.
        let utcComponents = DateComponents(2001, 2, 3, time: 18, timeZone: TimeZone(secondsFromGMT: 0)!)
        let localComponents = DateComponents(2001, 2, 4, time: 4, timeZone: TimeZone(secondsFromGMT: 60 * 60 * 10)!)
        utcDate = Calendar.current.date(from: utcComponents)!
        localDate = Calendar.current.date(from: localComponents)!
    }

    func testInit() {

        let day = Day()
        let dayComponents = DayComponents(day: day)

        let today = Date()
        let todayComponents = Calendar.current.dateComponents(in: TimeZone(secondsFromGMT: 0)!, from: today)

        expect(dayComponents.year) == todayComponents.year
        expect(dayComponents.month) == todayComponents.month
        expect(dayComponents.day) == todayComponents.day
    }

    func testInitWithDate() {

        expect(self.utcDate.timeIntervalSince1970) == localDate.timeIntervalSince1970

        let utcDay = Day(date: utcDate)
        let localDay = Day(date: localDate)

        expect(utcDay.dayIntervalSince1970) == localDay.dayIntervalSince1970
    }

    func testInitWithTimeIntervalSince1970() {

        let utcDay = Day(timeIntervalSince1970: utcDate.timeIntervalSince1970)
        let localDay = Day(timeIntervalSince1970: localDate.timeIntervalSince1970)

        expect(utcDay.dayIntervalSince1970) == localDay.dayIntervalSince1970
    }

    func testInitWithDayIntervalSince1970() {
        let day = Day(dayIntervalSince1970: 12345)
        expect(day.dayIntervalSince1970) == 12345
    }

    func testYearMonthDayShortForm() {
        let day = Day(2001, 2, 3, inTimeZone: melbourne)
        expect(day.dayIntervalSince1970) == 11355
    }

    func testYearMonthDay() {
        let day = Day(year: 2001, month: 2, day: 3, inTimeZone: melbourne)
        expect(day.dayIntervalSince1970) == 11355
    }

    func testYearMonthDayTimeForwardZoneCheck() {
        let melbourne = Day(year: 2001, month: 2, day: 3, inTimeZone: melbourne)
        let utc = Day(year: 2001, month: 2, day: 2, inTimeZone: utc)
        expect(utc.dayIntervalSince1970) == melbourne.dayIntervalSince1970
    }

    func testComparable() {
        let a = Day(year: 2000, month: 01, day: 15)
        let b = Day(year: 2000, month: 01, day: 16)
        let c = Day(year: 2000, month: 01, day: 17)
        expect(a < b) == true
        expect(b < c) == true
        expect(c > b) == true
    }
}
