//
//  DayOperationsTests.swift
//
//
//  Created by Derek Clarkson on 12/12/2023.
//

import DayType
import Nimble
import XCTest

class DayOperationTests: XCTestCase {

    func testPlus() {
        expect((Day(daysSince1970: 19445) + 5).daysSince1970) == 19450
    }

    func testMinus() {
        expect((Day(daysSince1970: 19445) - 5).daysSince1970) == 19440
    }

    func testInplacePlus() {
        var day = Day(daysSince1970: 19445)
        day += 5
        expect(day.daysSince1970) == 19450
    }

    func testInplaceMinus() {
        var day = Day(daysSince1970: 19445)
        day -= 5
        expect(day.daysSince1970) == 19440
    }

    func testDayDiff() {
        expect(Day(2020, 3, 12) - Day(2020, 3, 6)) == 6
    }
}
