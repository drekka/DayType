//
//  DayConversionTests.swift
//  
//
//  Created by Derek Clarkson on 6/12/2023.
//

import XCTest
import DayType
import Nimble

class DayConversionTests: XCTestCase {

    func testDateInCalendarCurrent() {
        let day = Day(2000,1,1)
        let date = day.date()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day, .hour], from: date)
        expect(dateComponents.year) == 2000
        expect(dateComponents.month) == 1
        expect(dateComponents.day) == 1
        expect(dateComponents.hour) == 0
    }

    func testDateInTimeZone() {

        let day = Day(2000,1,1)

        // Get the date of the day in the Melbourne time zone.
        let melbourne = TimeZone(secondsFromGMT: 11 * 3600)!
        let melbourneDate = day.date(timeZone: melbourne)

        // Get the date of the day in the GMT time zone.
        let gmt = TimeZone(secondsFromGMT: 0)!
        let gmtDate = day.date(timeZone: gmt)

        // We expect that the two points in time are different.
        expect(melbourneDate.timeIntervalSince1970) != gmtDate.timeIntervalSince1970

        // Check that the Melbourne date is midnight in the Melbourne time zone.
        let melbourneComponentsInMelbourne = Calendar.current.dateComponents(in: melbourne, from: melbourneDate)
        expect(melbourneComponentsInMelbourne.year) == 2000
        expect(melbourneComponentsInMelbourne.month) == 1
        expect(melbourneComponentsInMelbourne.day) == 1
        expect(melbourneComponentsInMelbourne.hour) == 0

        // Check that the GMT date is midnight in the GMT time zone.
        let gmtComponentsInGMT = Calendar.current.dateComponents(in: gmt, from: gmtDate)
        expect(gmtComponentsInGMT.year) == 2000
        expect(gmtComponentsInGMT.month) == 1
        expect(gmtComponentsInGMT.day) == 1
        expect(gmtComponentsInGMT.hour) == 0
    }

}
