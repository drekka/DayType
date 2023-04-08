//
// Copyright © Derek Clarkson. All rights reserved.
//

import DayType
import Foundation
import Nimble
import XCTest

class DayTests: XCTestCase {

    // MARK: - Initialisers

    func testInitDaysSince1970() {
        let day = Day(daysSince1970: 19455)
        expect(day.daysSince1970) == 19455
    }

    func testInitTimeIntervalSince1970() {
        let day1 = Day(daysSince1970: 19455)
        let day2 = Day(timeIntervalSince1970: 1_680_954_742)
        expect(day1.daysSince1970) == day2.daysSince1970
    }

    
}
