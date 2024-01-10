//
// Copyright © Derek Clarkson. All rights reserved.
//

import DayType
import Foundation
import Nimble
import XCTest

class DayTests: XCTestCase {

    // MARK: - Initialisers

    func testInit() {
        let day = Day()
        expect(day.daysSince1970) > 0
    }

    func testInitDaysSince1970() {
        let day = Day(daysSince1970: 19455)
        expect(day.daysSince1970) == 19455
    }

    func testInitTimeIntervalSince1970() {
        let day = Day(timeIntervalSince1970: 1_680_954_742)
        expect(day.daysSince1970) == 19455
    }

    func testInitComponents() {
        let day = Day(components: DayComponents(year: 2023, month: 4, day: 8))
        expect(day.daysSince1970) == 19455
    }

    func testInitShortForm() {
        let day = Day(2023, 4, 8)
        expect(day.daysSince1970) == 19455
    }

    func testDateToDayToDayComponents() {

        let baseDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        for offset in 0 ..< 1_000_000 {

            let expectedDate = Calendar.current.date(byAdding: .day, value: offset, to: baseDate)!

            let day = Day(date: expectedDate)
            let dayComponents = day.dayComponents()

            let expectedDateComponents = Calendar.current.dateComponents([.year, .month, .day], from: expectedDate)
            guard dayComponents.year == expectedDateComponents.year,
                  dayComponents.month == expectedDateComponents.month,
                  dayComponents.day == expectedDateComponents.day else {
                print("Date components: \(expectedDateComponents)")
                print("Day components : \(dayComponents)")
                fail("Day from date and back to date failed")
                break
            }
        }
    }
}
