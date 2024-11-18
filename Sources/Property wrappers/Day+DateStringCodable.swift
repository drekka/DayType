import Foundation

/// Protocol that allows us to abstract the differences between ``Day`` and ``Day?``.
///
/// By using this protocols for property wrappers we can reduce the number of wrappers needed because
/// it erases the optional aspect of the values.
public protocol DateStringCodable {
    init(dateDecoder decoder: Decoder, configurator: (some DateStringConfigurator).Type) throws
    func encode(dateEncoder encoder: Encoder, configurator: (some DateStringConfigurator).Type) throws
}

extension Day: DateStringCodable {

    public init(dateDecoder decoder: Decoder, configurator: (some DateStringConfigurator).Type) throws {

        let container = try decoder.singleValueContainer()
        let formatter = DateFormatter()
        configurator.configure(formatter: formatter)

        guard let dateString = try? container.decode(String.self),
              let date = formatter.date(from: dateString) else {
            let context = DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to read the date string.")
            throw DecodingError.dataCorrupted(context)
        }

        self = Day(date: date)
    }

    public func encode(dateEncoder encoder: Encoder, configurator: (some DateStringConfigurator).Type) throws {
        var container = encoder.singleValueContainer()
        let formatter = DateFormatter()
        configurator.configure(formatter: formatter)
        try container.encode(formatter.string(from: date()))
    }
}

/// `Day?` support which mostly just handles `nil` before calling the main ``Day`` codable code.
extension Day?: DateStringCodable {

    public init(dateDecoder decoder: Decoder, configurator: (some DateStringConfigurator).Type) throws {
        let container = try decoder.singleValueContainer()
        self = container.decodeNil() ? nil : try Day(dateDecoder: decoder, configurator: configurator)
    }

    public func encode(dateEncoder encoder: Encoder, configurator: (some DateStringConfigurator).Type) throws {
        if let self {
            try self.encode(dateEncoder: encoder, configurator: configurator)
        } else {
            var container = encoder.singleValueContainer()
            try container.encodeNil()
        }
    }
}
