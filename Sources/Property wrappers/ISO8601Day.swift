//
//  ISO8601Day.swift
//
//
//  Created by Derek Clarkson on 9/1/2024.
//

import Foundation

/// Identifies a ``Day`` property that reads and writes from an ISO8601 formatted string.
@propertyWrapper
public struct ISO8601Day<T>: Codable where T: DayCodable {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        wrappedValue = try T(iso8601Decoder: decoder, configurator: ISO8601DefaultConfigurator.self)
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(iso8601Encoder: encoder, configurator: ISO8601DefaultConfigurator.self)
    }
}
