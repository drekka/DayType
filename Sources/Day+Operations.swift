//
//  Day+Operations.swift
//
//
//  Created by Derek Clarkson on 11/12/2023.
//

import Foundation

public extension Day {

    /// Adds a specific number of days to a date and returns the new date.
    static func + (lhs: Self, rhs: Int) -> Self {
        Day(daysSince1970: lhs.daysSince1970 + rhs)
    }

    /// Subtracts a specific number of days to a date and returns the new date.
    static func - (lhs: Self, rhs: Int) -> Self {
        Day(daysSince1970: lhs.daysSince1970 - rhs)
    }

    /// Subtracts one date from another and returns the difference in days.
    static func - (lhs: Self, rhs: Self) -> Int {
        lhs.daysSince1970 - rhs.daysSince1970
    }

    /// Adds a specific number of days to a date.
    static func += (lhs: inout Self, rhs: Int) {
        lhs = Day(daysSince1970: lhs.daysSince1970 + rhs)
    }

    /// Subtracts a specific number of days to a date.
    static func -= (lhs: inout Self, rhs: Int) {
        lhs = Day(daysSince1970: lhs.daysSince1970 - rhs)
    }
}

extension Day: Equatable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.daysSince1970 == rhs.daysSince1970
    }
}

extension Day: Comparable {
    public static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.daysSince1970 < rhs.daysSince1970
    }
}
