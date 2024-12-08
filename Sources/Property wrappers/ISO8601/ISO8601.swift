import Foundation

/// Identifies a ``Day`` property that reads and writes from an ISO8601 formatted string.
@propertyWrapper
public struct ISO8601<T>: Codable where T: ISO8601Codable {

    public var wrappedValue: T

    public init(wrappedValue: T) {
        self.wrappedValue = wrappedValue
    }

    public init(from decoder: Decoder) throws {
        wrappedValue = try T(iso8601Decoder: decoder, configurator: ISO8601Config.Default.self)
    }

    public func encode(to encoder: Encoder) throws {
        try wrappedValue.encode(iso8601Encoder: encoder, configurator: ISO8601Config.Default.self)
    }
}
