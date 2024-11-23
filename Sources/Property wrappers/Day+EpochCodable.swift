import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol EpochCodable {

    /// Decoding with optional milliseconds.
    init(epochDecoder decoder: Decoder, withMilliseconds: Bool) throws

    /// Encoding with optional milliseconds.
    func encode(epochEncoder encoder: Encoder, withMilliseconds milliseconds: Bool) throws
}

/// Providing defaults.
public extension EpochCodable {
    init(epochDecoder decoder: Decoder) throws { try self.init(epochDecoder: decoder, withMilliseconds: false) }
    func encode(epochEncoder encoder: Encoder) throws { try encode(epochEncoder: encoder, withMilliseconds: false) }
}

extension Day: EpochCodable {

    public init(epochDecoder decoder: Decoder, withMilliseconds milliseconds: Bool) throws {
        let container = try decoder.singleValueContainer()
        guard let epochTime = try? container.decode(TimeInterval.self) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected an epoch.")
            throw DecodingError.dataCorrupted(context)
        }
        self = Day(date: Date(timeIntervalSince1970: epochTime / (milliseconds ? 1000 : 1)))
    }

    public func encode(epochEncoder encoder: Encoder, withMilliseconds milliseconds: Bool) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date().timeIntervalSince1970 * (milliseconds ? 1000 : 1))
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: EpochCodable {

    public init(epochDecoder decoder: Decoder, withMilliseconds milliseconds: Bool) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(epochDecoder: decoder, withMilliseconds: milliseconds)
    }

    public func encode(epochEncoder encoder: Encoder, withMilliseconds milliseconds: Bool) throws {
        if let self {
            try self.encode(epochEncoder: encoder, withMilliseconds: milliseconds)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
