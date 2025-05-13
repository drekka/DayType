import DayType
import Foundation
import Testing

private struct ISO8601Container: Codable {
    @ISO8601.Default var iso8601: Day
    @ISO8601.SansTimezone var iso8601SansTimezone: Day
}

private struct ISO8601OptionalContainer: Codable {
    @ISO8601.Default var iso8601: Day?
    @ISO8601.SansTimezone var iso8601SansTimezone: Day?
}

private struct ISO8601OptionalNullContainer: Codable {
    @ISO8601.Default.Nullable var iso8601: Day?
    @ISO8601.SansTimezone.Nullable var iso8601SansTimezone: Day?
}

extension PropertyWrapperSuites {

    @Suite("@ISO8601")
    struct ISO8601Tests {

        @Test("Decoding strings")
        func decodingDates() throws {
            let json = #"{"iso8601": "2012-02-01T12:00:00Z+12:00", "iso8601SansTimezone": "2012-02-01T12:00:00"}"#
            let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
            let expectedDate = Day(2012, 02, 01)
            #expect(result.iso8601 == expectedDate)
            #expect(result.iso8601SansTimezone == expectedDate)
        }

        @Test("Optional string decoding")
        func decodingOptionalDates() throws {
            let json = #"{"iso8601": "2012-02-01T12:00:00Z+12:00", "iso8601SansTimezone": "2012-02-01T12:00:00"}"#
            let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
            let expectedDate = Day(2012, 02, 01)
            #expect(result.iso8601 == expectedDate)
            #expect(result.iso8601SansTimezone == expectedDate)
        }

        @Test("Optional nil decoding")
        func decodingOptionalNilDates() throws {
            let json = #"{"ios8601": null, "iso8691SansTimezone": null}"#
            let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.iso8601 == nil)
            #expect(result.iso8601SansTimezone == nil)
        }

        @Test("Optional missing decoding")
        func decodingOptionalMissingDates() throws {
            let json = #"{}"#
            let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.iso8601 == nil)
            #expect(result.iso8601SansTimezone == nil)
        }

        @Test("Invalid ISO8691 string decoding throws an error")
        func decodingInvalidDateThrows() throws {
            do {
                let json = #"{"iso8601": "xxx4 5 ass3"}"#
                _ = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
                Issue.record("Error not thrown")
            } catch DecodingError.dataCorrupted(let context) {
                #expect(context.codingPath.map(\.stringValue) == ["iso8601"])
                #expect(context.debugDescription == "Unable to read the date string.")
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }

        @Test("String encoding")
        func encodingDateStrings() throws {
            let day = Day(2012, 02, 01)
            let instance = ISO8601Container(iso8601: day, iso8601SansTimezone: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            let expectedJSON = #"{"iso8601":"\#(expectedISO8601Date())","iso8601SansTimezone":"\#(expectedISO8601SansDate())"}"#
            #expect(json == expectedJSON)
        }

        @Test("Optional string encoding")
        func encodingOptionalDateStrings() throws {
            let day = Day(2012, 02, 01)
            let instance = ISO8601OptionalContainer(iso8601: day, iso8601SansTimezone: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            let expectedJSON = #"{"iso8601":"\#(expectedISO8601Date())","iso8601SansTimezone":"\#(expectedISO8601SansDate())"}"#
            #expect(json == expectedJSON)
        }

        @Test("Optional encoding nil")
        func encodingOptionalDateStringsWithNil() throws {
            let instance = ISO8601OptionalContainer(iso8601: nil, iso8601SansTimezone: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == "{}")
        }

        @Test("Optional encoding nil -> null")
        func encodingOptionalDateStringsWithNilToNull() throws {
            let instance = ISO8601OptionalNullContainer(iso8601: nil, iso8601SansTimezone: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"iso8601":null,"iso8601SansTimezone":null}"#)
        }

        func expectedISO8601Date() -> String {
            let today = DateComponents(calendar: .current, timeZone: .current, year: 2012, month: 2, day: 1)
            let formatter = ISO8601DateFormatter()
            return formatter.string(from: today.date!)
        }

        func expectedISO8601SansDate() -> String {
            let today = DateComponents(calendar: .current, timeZone: .current, year: 2012, month: 2, day: 1)
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions.remove(.withTimeZone)
            return formatter.string(from: today.date!)
        }
    }
}
