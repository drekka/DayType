import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol ISO8601Codable {
    init(iso8601Decoder decoder: Decoder, configurator: (some CustomISO8601Configurator).Type) throws
    func encode(iso8601Encoder encoder: Encoder, configurator: (some CustomISO8601Configurator).Type) throws
}

/// Adds ``DayCodable`` to ``Day``.
extension Day: ISO8601Codable {

    public init(iso8601Decoder decoder: Decoder, configurator: (some CustomISO8601Configurator).Type) throws {

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

    public func encode(iso8601Encoder encoder: Encoder, configurator: (some CustomISO8601Configurator).Type) throws {
        let writer = ISO8601DateFormatter()
        configurator.configure(formatter: writer)
        let iso8601String = writer.string(from: date())
        var container = encoder.singleValueContainer()
        try container.encode(iso8601String)
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: ISO8601Codable {

    public init(iso8601Decoder decoder: Decoder, configurator: (some CustomISO8601Configurator).Type) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(iso8601Decoder: decoder, configurator: configurator)
    }

    public func encode(iso8601Encoder encoder: Encoder, configurator: (some CustomISO8601Configurator).Type) throws {
        if let self {
            try self.encode(iso8601Encoder: encoder, configurator: configurator)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}

