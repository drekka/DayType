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
public protocol EpochCodable {
    init(epochDecoder decoder: Decoder) throws
    func encode(epochEncoder encoder: Encoder) throws
}

extension Day: EpochCodable {

    public init(epochDecoder decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        guard let epochTime = try? container.decode(TimeInterval.self) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected an epoch.")
            throw DecodingError.dataCorrupted(context)
        }
        self = Day(date: Date(timeIntervalSince1970: epochTime))
    }

    public func encode(epochEncoder encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date().timeIntervalSince1970)
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: EpochCodable {

    public init(epochDecoder decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(epochDecoder: decoder)
    }

    public func encode(epochEncoder encoder: Encoder) throws {
        if let self {
            try self.encode(epochEncoder: encoder)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
