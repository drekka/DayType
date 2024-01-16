//
//  DayOperationsTests.swift
//
//
//  Created by Derek Clarkson on 12/12/2023.
//

import DayType
import Nimble
import XCTest

class DayHashableTests: XCTestCase {

    func testHash() {
        var days: Set = [Day(2020, 01, 11), Day(2020, 01, 12)]
        expect(days.contains(Day(2020, 01, 13))) == false
        expect(days.contains(Day(2020, 01, 12))) == true

        // Modify and try again.
        days.insert(Day(2020, 01, 13))
        expect(days.contains(Day(2020, 01, 13))) == true
        expect(days.contains(Day(2020, 01, 12))) == true

        // Duplicate check.
        days.insert(Day(2020, 01, 11))
        expect(days.count) == 3
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
