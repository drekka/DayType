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
}

class DayEquatableTests: XCTestCase {

    func testEquals() {
        expect(Day(2020, 3, 12) == Day(2020, 3, 12)) == true
        expect(Day(2020, 3, 12) == Day(2001, 1, 5)) == false
    }

    func testNotEquals() {
        expect(Day(2020, 3, 12) != Day(2001, 1, 5)) == true
        expect(Day(2020, 3, 12) != Day(2020, 3, 12)) == false
    }
}

class DayComparableTests: XCTestCase {

    func testGreaterThan() {
        expect(Day(2020, 3, 12) > Day(2020, 3, 11)) == true
        expect(Day(2020, 3, 12) > Day(2020, 3, 12)) == false
        expect(Day(2020, 3, 12) > Day(2020, 3, 13)) == false
    }

    func testGreaterThanEquals() {
        expect(Day(2020, 3, 12) >= Day(2020, 3, 11)) == true
        expect(Day(2020, 3, 12) >= Day(2020, 3, 12)) == true
        expect(Day(2020, 3, 12) >= Day(2020, 3, 13)) == false
    }

    func testLessThan() {
        expect(Day(2020, 3, 12) < Day(2020, 3, 11)) == false
        expect(Day(2020, 3, 12) < Day(2020, 3, 12)) == false
        expect(Day(2020, 3, 12) < Day(2020, 3, 13)) == true
    }

    func testLessThanEquals() {
        expect(Day(2020, 3, 12) <= Day(2020, 3, 11)) == false
        expect(Day(2020, 3, 12) <= Day(2020, 3, 12)) == true
        expect(Day(2020, 3, 12) <= Day(2020, 3, 13)) == true
    }

}
