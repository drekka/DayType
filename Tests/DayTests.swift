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
        expect(Day().daysSince1970) > 0
    }

    func testInitDaysSince1970() {
        expect(Day(daysSince1970: 19455).daysSince1970) == 19455
    }

    func testInitTimeIntervalSince1970() {
        expect(Day(timeIntervalSince1970: 1_680_954_742).daysSince1970) == 19455
    }

    func testInitTimeIntervalSince1970TruncationCheck() {
        expect(Day(timeIntervalSince1970: 24 * 60 * 60 - 1).daysSince1970) == 0
        expect(Day(timeIntervalSince1970: 24 * 60 * 60 + 0).daysSince1970) == 1
        expect(Day(timeIntervalSince1970: 24 * 60 * 60 + 1).daysSince1970) == 1
    }

    func testInitComponents() {
        expect(Day(components: DayComponents(year: 2023, month: 4, day: 8)).daysSince1970) == 19455
    }

    func testInitShortForm() {
        expect(Day(2023, 4, 8).daysSince1970) == 19455
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
