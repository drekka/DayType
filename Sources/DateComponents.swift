//
//  File.swift
//
//
//  Created by Derek Clarkson on 5/2/2022.
//

import Foundation

/// Useful additional functions.
public extension DateComponents {

    /// Shortcut initializer designed for the most common situations where individual components are being passed.
    ///
    /// This initializer is optimized for coding. So all the arguments can be passed in a logical order without requiring the argument names. However this also assumes that all the preceeding arguments will also be passed. ie. you cannot pass just a day without the month and year. The shortest for of this being `DateComponents(2001, 1, 1)` The longest being `DateComponents(calendar, timezone, 2001, 1, 1, time: 14, 25, 30)`
    init(_ year: Int,
         _ month: Int,
         _ day: Int,
         time hours: Int = 0,
         _ minutes: Int = 0,
         _ seconds: Int = 0,
         inCalendar calendar: Calendar = .current,
         timeZone: TimeZone = .current) {
        self.init(calendar: calendar, timeZone: timeZone, year: year, month: month, day: day, hour: hours, minute: minutes, second: seconds)
    }
}
