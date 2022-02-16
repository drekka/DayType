//
//  File.swift
//
//
//  Created by Derek Clarkson on 27/1/2022.
//

import Foundation

public class DayComponents {

    var calendar: Calendar?
    var timeZone: TimeZone?
    var year: Int?
    var month: Int?
    var dayOfMonth: Int?

    var day: Day? {
        (calendar ?? .current).day(fromComponents: self)
    }

    public init(calendar: Calendar? = nil,
         timeZone: TimeZone? = nil,
         year: Int? = nil,
         month: Int? = nil,
         dayOfMonth: Int? = nil) {
        self.calendar = calendar
        self.timeZone = timeZone
        self.year = year
        self.month = month
        self.dayOfMonth = dayOfMonth
    }

}
