import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol EpochCodable {
    init(epochDecoder decoder: Decoder, factor: Double) throws
    func encode(epochEncoder encoder: Encoder, factor: Double) throws
}

extension Day: EpochCodable {

    public init(epochDecoder decoder: Decoder, factor: Double) throws {
        let container = try decoder.singleValueContainer()
        guard let epochTime = try? container.decode(TimeInterval.self) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected an epoch.")
            throw DecodingError.dataCorrupted(context)
        }
        self = Day(date: Date(timeIntervalSince1970: epochTime / factor))
    }

    public func encode(epochEncoder encoder: Encoder, factor: Double) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date().timeIntervalSince1970 * factor)
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: EpochCodable {

    public init(epochDecoder decoder: Decoder, factor: Double) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(epochDecoder: decoder, factor: factor)
    }

    public func encode(epochEncoder encoder: Encoder, factor: Double) throws {
        if let self {
            try self.encode(epochEncoder: encoder, factor: factor)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
