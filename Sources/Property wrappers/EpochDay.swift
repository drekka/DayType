//
//  EpochDay.swift
//
//
//  Created by Derek Clarkson on 9/1/2024.
//

import Foundation

/// Identifies a ``Day`` property that reads and writes from an epoch time value.
@propertyWrapper
public struct EpochDay<T>: Codable where T: EpochCodable {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        wrappedValue = try T(epochDecoder: decoder)
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(epochEncoder: encoder)
    }
}
