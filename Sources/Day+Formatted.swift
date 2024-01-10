//
//  Day+Formatted.swift
//  
//
//  Created by Derek Clarkson on 6/12/2023.
//

import Foundation

public extension Day {

    /// Converts `self` to its textual representation that contains the date parts.
    ///
    /// The exact format depends on the user's preferences, however this is done using the ``Date.formatted(style:)``
    /// function so all the logic is the same except the time component is omitted.
    ///
    /// - Parameters:
    ///   - day: The style for describing the day. This makes used of the ``Date.FormatStyle.Date`` options.
    /// - Returns: A `String` describing `self`.
    func formatted(_ day: Date.FormatStyle.DateStyle = .abbreviated) -> String {
        date().formatted(date: day, time: .omitted)
    }
}
