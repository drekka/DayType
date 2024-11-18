import DayType
import Foundation
import Testing

private struct DayContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @DateString<Day, Configurator> var d1: Day
}

private struct OptionalDayContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @DateString<Day?, Configurator> var d1: Day?
}


struct DateStringTests {

    @Test("Decoding am ISO8601 string")
    func decodingISO8601DateString() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        #expect(result.d1 == Day(2012, 02, 01))
    }

    func testDecodingAustralianDateStrings() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAmericanDateStrings() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(DayContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }
}

class CodableAsDateStroingOptionalTests: XCTestCase {

    func testDecodingISO8601DateString() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAustralianDateStrings() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAmericanDateStrings() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingNilAustralianDateStrings() throws {
        let json = #"{"d1": null}"#
        let result = try JSONDecoder().decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == nil
    }

    func testDecodingInvalidAustralianDateStringsThrows() throws {

        let json = #"{"d1": "xxx"}"#
        let decoder = JSONDecoder()
        expect(try decoder.decode(OptionalDayContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!))
            .to(throwError { error in
                guard case let DecodingError.dataCorrupted(context) = error else {
                    fail("Incorrect error \(error)")
                    return
                }
                expect(context.codingPath.map { $0.stringValue }) == ["d1"]
                expect(context.debugDescription) == "Unable to read the date string."
            })
    }
}

class CodableAsDateStringEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = DayContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"01/02/2012"}"#
    }
}

class CodableAsDateStringOptionalTests: XCTestCase {

    func testEncoding() throws {
        let instance = OptionalDayContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"01/02/2012"}"#
    }

    func testEncodingNil() throws {
        let instance = OptionalDayContainer<DateStringConfig.DMY>(d1: nil)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
