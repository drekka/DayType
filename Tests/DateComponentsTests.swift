//
//  File.swift
//  
//
//  Created by Derek Clarkson on 12/2/2022.
//

import DayType
import XCTest
import Nimble

class DateComponentsTests: XCTestCase {
    
    func testShortCutInitializer() {
        let components = DateComponents(2001, 11, 5, time: 14, 35, 2)
        expect(components.year) == 2001
        expect(components.month) == 11
        expect(components.day) == 5
        expect(components.hour) == 14
        expect(components.minute) == 35
        expect(components.second) == 2
    }
    
}
