//
//  Day+Codable.swift
//
//
//  Created by Derek Clarkson on 9/12/2023.
//

import Foundation

/// Encoding and decding stores the internal number of days since 1970 value.
///
/// This is because readind and writing ISO1806 strings, or epoch values would involve a conversion
/// from the generalisation that is a day to the specific point in time that are those formats.
/// So it seemed unwise to enforce any particular one for ``Codable`` conformance.

extension Day: Codable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        daysSince1970 = try container.decode(Int.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(daysSince1970)
    }
}
