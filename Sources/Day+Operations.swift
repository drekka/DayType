//
//  Day+Operations.swift
//
//
//  Created by Derek Clarkson on 11/12/2023.
//

import Foundation

public extension Day {

    static func + (lhs: Self, rhs: Int) -> Self {
        Day(daysSince1970: lhs.daysSince1970 + rhs)
    }

    static func - (lhs: Self, rhs: Int) -> Self {
        Day(daysSince1970: lhs.daysSince1970 - rhs)
    }

    static func += (lhs: inout Self, rhs: Int) {
        lhs = Day(daysSince1970: lhs.daysSince1970 + rhs)
    }

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
