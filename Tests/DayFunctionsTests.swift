//
//  DayFunctionsTests.swift
//
//
//  Created by Derek Clarkson on 16/1/2024.
//

import DayType
import Nimble
import XCTest

class DayFunctionsTests: XCTestCase {

    func testDayByAdding() {
        expect(Day(2001, 2, 3).day(byAdding: .day, value: 3)) == Day(2001, 2, 6)
        expect(Day(2001, 2, 3).day(byAdding: .month, value: 3)) == Day(2001, 5, 3)
        expect(Day(2001, 2, 3).day(byAdding: .year, value: 3)) == Day(2004, 2, 3)
    }

    func testDayByAddingRolling() {
        expect(Day(2001, 2, 3).day(byAdding: .day, value: 55)) == Day(2001, 3, 30)
        expect(Day(2001, 2, 3).day(byAdding: .month, value: 55)) == Day(2005, 9, 10)
    }
}
