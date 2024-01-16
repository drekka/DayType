//
//  Day+CustomStringConvertable.swift
//  
//
//  Created by Derek Clarkson on 15/1/2024.
//

import Foundation

extension Day: CustomStringConvertible {
    public var description: String {
        self.formatted()
    }
}
