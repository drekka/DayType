//
//  Day+Stridable.swift
//  
//
//  Created by Derek Clarkson on 15/1/2024.
//

import Foundation

extension Day: Strideable {

    public func distance(to other: Day) -> Int {
        other.daysSince1970 - self.daysSince1970
    }
    
    public func advanced(by n: Int) -> Day {
        self + n
    }
}
