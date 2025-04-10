import Foundation
import DayTypeMacros

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol EpochCodable {
    static func decode(using decoder: Decoder, milliseconds: Bool) throws -> Self
    func encode(using encoder: Encoder, milliseconds: Bool) throws
}

extension Day: EpochCodable {

    public static func decode(using decoder: Decoder, milliseconds: Bool) throws -> Day {
        let container = try decoder.singleValueContainer()
        guard let epochTime = try? container.decode(TimeInterval.self) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected an epoch.")
            throw DecodingError.dataCorrupted(context)
        }
        return Day(date: Date(timeIntervalSince1970: epochTime / (milliseconds ? 1000 : 1)))
    }

    public func encode(using encoder: Encoder, milliseconds: Bool) throws {
        var container = encoder.singleValueContainer()
        try container.encode(date().timeIntervalSince1970 * (milliseconds ? 1000 : 1))
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
@OptionalDayCodable(argumentName: "milliseconds", argumentType: Bool.self)
extension Day?: EpochCodable {}
