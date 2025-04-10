import DayTypeMacros
import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol ISO8601Codable {
    static func decode(using decoder: Decoder, formatter: ISO8601DateFormatter) throws -> Self
    func encode(using encoder: Encoder, formatter: ISO8601DateFormatter) throws
}

extension Day: ISO8601Codable {

    public static func decode(using decoder: Decoder, formatter: ISO8601DateFormatter) throws -> Day {
        let container = try decoder.singleValueContainer()
        guard let iso8601String = try? container.decode(String.self),
              let date = formatter.date(from: iso8601String) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read a Day value, expected a valid ISO8601 string.")
            throw DecodingError.dataCorrupted(context)
        }
        return Day(date: date)
    }

    public func encode(using encoder: Encoder, formatter: ISO8601DateFormatter) throws {
        var container = encoder.singleValueContainer()
        try container.encode(formatter.string(from: date()))
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
@OptionalDayCodable(argumentName: "formatter", argumentType: ISO8601DateFormatter.self)
extension Day?: ISO8601Codable {}
