//
//  DayCodable.swift
//
//
//  Created by Derek Clarkson on 9/1/2024.
//

import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol DayCodable {

    init(epochDecoder decoder: Decoder) throws
    init(iso8601Decoder decoder: Decoder, configurator: (some ISO8601Configurator).Type) throws

    func encode(epochEncoder encoder: Encoder) throws
    func encode(iso8601Encoder encoder: Encoder, configurator: (some ISO8601Configurator).Type) throws
}

/// Adds ``DayCodable`` to ``Day``.
extension Day: DayCodable {

    public init(epochDecoder decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let epochTime = try? container.decode(TimeInterval.self) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected an epoch.")
            throw DecodingError.dataCorrupted(context)
        }
        self = Day(date: Date(timeIntervalSince1970: epochTime))
    }

    public init(iso8601Decoder decoder: Decoder, configurator: (some ISO8601Configurator).Type) throws {

        let container = try decoder.singleValueContainer()
        if let iso8601String = try? container.decode(String.self) {
            let reader = ISO8601DateFormatter()
            configurator.configure(formatter: reader)
            if let date = reader.date(from: iso8601String) {
                self.init(date: date)
                return
            }
        }

        let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected a valid ISO8601 string.")
        throw DecodingError.dataCorrupted(context)
    }

    public func encode(epochEncoder encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date().timeIntervalSince1970)
    }

    public func encode(iso8601Encoder encoder: Encoder, configurator: (some ISO8601Configurator).Type) throws {
        let writer = ISO8601DateFormatter()
        configurator.configure(formatter: writer)
        let iso8601String = writer.string(from: date())
        var container = encoder.singleValueContainer()
        try container.encode(iso8601String)
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: DayCodable {

    public init(epochDecoder decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(epochDecoder: decoder)
    }

    public init(iso8601Decoder decoder: Decoder, configurator: (some ISO8601Configurator).Type) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(iso8601Decoder: decoder, configurator: configurator)
    }

    public func encode(epochEncoder encoder: Encoder) throws {
        if let self {
            try self.encode(epochEncoder: encoder)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }

    public func encode(iso8601Encoder encoder: Encoder, configurator: (some ISO8601Configurator).Type) throws {
        if let self {
            try self.encode(iso8601Encoder: encoder, configurator: configurator)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
