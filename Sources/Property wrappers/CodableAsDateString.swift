//
//  CustomISO8601Day.swift
//
//
//  Created by Derek Clarkson on 9/1/2024.
//

import Foundation

/// Identifies a ``Day`` property that reads and writes from date strings using a configured ``DateFormatter``.
@propertyWrapper
public struct CodableAsDateString<T, Configurator>: Codable where T: DateStringCodable, Configurator: DateStringConfigurator {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        wrappedValue = try T(dateDecoder: decoder, configurator: Configurator.self)
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(dateEncoder: encoder, configurator: Configurator.self)
    }
}
