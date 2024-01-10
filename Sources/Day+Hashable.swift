//
//  Day+Hashable.swift
//
//
//  Created by Derek Clarkson on 10/1/2024.
//

import Foundation

extension Day: Hashable {

    public func hash(into hasher: inout Hasher) {
        hasher.combine(daysSince1970)
    }
}
