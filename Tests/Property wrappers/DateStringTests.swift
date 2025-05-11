import DayType
import Foundation
import Testing

private struct DayContainer: Codable {
    @DayString.DMY var dmy: Day
    @DayString.MDY var mdy: Day
    @DayString.YMD var ymd: Day
}

private struct OptionalDayContainer: Codable {
    @DayString.DMY var dmy: Day?
    @DayString.MDY var mdy: Day?
    @DayString.YMD var ymd: Day?
}

private struct OptionalNilContainer: Codable {
    @DayString.DMY var dmy: Day?
    @DayString.MDY var mdy: Day?
    @DayString.YMD var ymd: Day?
}

private struct OptionalNullContainer: Codable {
    @DayString.DMY.WritesNulls var dmy: Day?
    @DayString.MDY.WritesNulls var mdy: Day?
    @DayString.YMD.WritesNulls var ymd: Day?
}

extension PropertyWrapperSuites {

    @Suite("@DayString")
    struct DateStringTests {

        @Test("Decoding date strings")
        func decodingDates() throws {
            let json = #"{"dmy": "01/02/2012", "mdy": "02/01/2012", "ymd": "2012-02-01"}"#
            let result = try JSONDecoder().decode(DayContainer.self, from: json.data(using: .utf8)!)
            let expectedDate = Day(2012, 02, 01)
            #expect(result.dmy == expectedDate)
            #expect(result.mdy == expectedDate)
            #expect(result.ymd == expectedDate)
        }

        @Test("Optional date string decoding")
        func decodingOptionalDates() throws {
            let json = #"{"dmy": "01/02/2012", "mdy": "02/01/2012", "ymd": "2012-02-01"}"#
            let result = try JSONDecoder().decode(OptionalDayContainer.self, from: json.data(using: .utf8)!)
            let expectedDate = Day(2012, 02, 01)
            #expect(result.dmy == expectedDate)
            #expect(result.mdy == expectedDate)
            #expect(result.ymd == expectedDate)
        }

        @Test("Optional nil decoding")
        func decodingOptionalNilDates() throws {
            let json = #"{"dmy": null, "mdy": null, "ymd": null}"#
            let result = try JSONDecoder().decode(OptionalDayContainer.self, from: json.data(using: .utf8)!)
            #expect(result.dmy == nil)
            #expect(result.mdy == nil)
            #expect(result.ymd == nil)
        }

        @Test("Optional missing decoding")
        func decodingOptionalMissingDates() throws {
            let json = #"{}"#
            let result = try JSONDecoder().decode(OptionalDayContainer.self, from: json.data(using: .utf8)!)
            #expect(result.dmy == nil)
            #expect(result.mdy == nil)
            #expect(result.ymd == nil)
        }

        @Test("Invalid date string decoding throws an error")
        func decodingInvalidDateThrows() throws {
            do {
                let json = #"{"dmy": "xxx"}"#
                _ = try JSONDecoder().decode(OptionalDayContainer.self, from: json.data(using: .utf8)!)
                Issue.record("Error not thrown")
            } catch DecodingError.dataCorrupted(let context) {
                #expect(context.codingPath.map(\.stringValue) == ["dmy"])
                #expect(context.debugDescription == "Unable to read the date string.")
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }

        @Test("Date string encoding")
        func encodingDateStrings() throws {
            let day = Day(2012, 02, 01)
            let instance = DayContainer(dmy: day, mdy: day, ymd: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"dmy":"01/02/2012","mdy":"02/01/2012","ymd":"2012-02-01"}"#)
        }

        @Test("Optional date string encoding")
        func encodingOptionalDateStrings() throws {
            let day = Day(2012, 02, 01)
            let instance = OptionalDayContainer(dmy: day, mdy: day, ymd: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"dmy":"01/02/2012","mdy":"02/01/2012","ymd":"2012-02-01"}"#)
        }

        @Test("Optional date encoding nil")
        func encodingOptionalDateStringsWithNil() throws {
            let instance = OptionalDayContainer(dmy: nil, mdy: nil, ymd: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .withoutEscapingSlashes
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == "{}")
        }

        @Test("Optional date encoding nil -> null")
        func encodingOptionalDateStringsWithNilToNull() throws {
            let instance = OptionalNullContainer(dmy: nil, mdy: nil, ymd: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"dmy":null,"mdy":null,"ymd":null}"#)
        }
    }
}
