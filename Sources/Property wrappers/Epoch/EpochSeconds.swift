import Foundation

/// Identifies a ``Day`` property that reads and writes from an epoch time value expressed in seconds.
@propertyWrapper
public struct EpochSeconds<T>: Codable where T: EpochCodable {

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
