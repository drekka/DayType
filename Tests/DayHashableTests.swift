//
//  DayHashableTests.swift
//
//
//  Created by Derek Clarkson on 10/1/2024.
//

import Nimble
import XCTest
import DayType

class DayHasableTests: XCTestCase {

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
