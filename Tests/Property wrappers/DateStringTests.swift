import DayType
import Foundation
import Testing

private struct DayContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @DateString<Day, Configurator> var d1: Day
}

private struct OptionalDayContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @DateString<Day?, Configurator> var d1: Day?
}

@Suite("Date string decoding")
struct DateStringDecodingTests {

    @Test("Decoding an ISO8601 date")
    func decodingAnISO8601Date() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding an DMY date")
    func decodingADMYDate() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding an MDY date")
    func decodingAMDYDate() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding an optional ISO8601 date")
    func decodingAnIOptionalISO8601Date() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding an DMY date")
    func decodingAnOptionalDMYDate() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding an MDY date")
    func decodingAnOptionalMDYDate() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    @Test("Decoding a nil date")
    func decodingANilDate() throws {
        let json = #"{"d1": null}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == nil)
    }

    @Test("Decoding an invalid date throws an error")
    func decodingInvalidDateThrows() throws {
        do {
            let json = #"{"d1": "xxx"}"#
            _ = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        } catch DecodingError.dataCorrupted(let context) {
            #expect(context.codingPath.map(\.stringValue) == ["d1"])
            #expect(context.debugDescription == "Unable to read the date string.")
        } catch {
            Issue.record("Unexpected error: \(error)")
        }
    }
}

@Suite("Date string encoding")
class DateStringEncodingTests {

    @Test("Encoding a DMY date")
    func dateEncoding() throws {
        let instance = DayContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        #expect(String(data: result, encoding: .utf8)! == #"{"d1":"01/02/2012"}"#)
    }

    @Test("Encoding an optional DMY date")
    func optionalDateEncoding() throws {
        let instance = OptionalDayContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        #expect(String(data: result, encoding: .utf8)! == #"{"d1":"01/02/2012"}"#)
    }

    @Test("Encoding an optional DMY date from a nil")
    func optionalDateEncodingWithNil() throws {
        let instance = OptionalDayContainer<DateStringConfig.DMY>(d1: nil)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        #expect(String(data: result, encoding: .utf8)! == #"{"d1":null}"#)
    }
}
