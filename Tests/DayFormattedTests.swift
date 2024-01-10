//
//  DayFormattedTests.swift
//
//
//  Created by Derek Clarkson on 7/12/2023.
//

import DayType
import Nimble
import XCTest

class DayFormattedTests: XCTestCase {

    func testFormatted() {
        let day = Day(2000, 2, 1)
        expect(day.formatted()) == "1 Feb 2000"
        expect(day.formatted(.abbreviated)) == "1 Feb 2000"
        expect(day.formatted(.complete)) == "Tuesday, 1 February 2000"
        expect(day.formatted(.long)) == "1 February 2000"
        expect(day.formatted(.numeric)) == "1/2/2000"
    }
}
