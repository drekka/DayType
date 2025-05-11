import DayTypeMacros
import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol DayStringCodable {
    static func decode(from decoder: Decoder, formatter: DateFormatter) throws -> Self
    func encode(into encoder: Encoder, formatter: DateFormatter, writeNulls: Bool) throws
}

extension Day: DayStringCodable {

    public static func decode(from decoder: Decoder, formatter: DateFormatter) throws -> Day {
        let container = try decoder.singleValueContainer()
        guard let dateString = try? container.decode(String.self),
              let date = formatter.date(from: dateString) else {
            let context = DecodingError.Context(codingPath: container.codingPath, debugDescription: "Unable to read the date string.")
            throw DecodingError.dataCorrupted(context)
        }
        return Day(date: date)
    }

    public func encode(into encoder: Encoder, formatter: DateFormatter, writeNulls _: Bool) throws {
        var container = encoder.singleValueContainer()
        try container.encode(formatter.string(from: date()))
    }
}

/// `Day?` support which mostly just handles `nil`.
extension Day?: DayStringCodable {
    public static func decode(from decoder: Decoder, formatter: DateFormatter) throws -> Day? {
        let container = try decoder.singleValueContainer()
        return container.decodeNil() ? nil : try Day.decode(from: decoder, formatter: formatter)
    }

    public func encode(into encoder: Encoder, formatter: DateFormatter, writeNulls: Bool) throws {
        if let self {
            try self.encode(into: encoder, formatter: formatter, writeNulls: writeNulls)
        } else if writeNulls {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
