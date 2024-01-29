//
//  DayCodableTests.swift
//
//
//  Created by Derek Clarkson on 9/12/2023.
//

import DayType
import Nimble
import XCTest

// MARK: - ISO8601 Decoding

private struct DateStringContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @CodableAsDateString<Day, Configurator> var d1: Day
    init(d1: Day) {
        self.d1 = d1
    }
}

private struct DateStringOptionalContainer<Configurator>: Codable where Configurator: DateStringConfigurator {
    @CodableAsDateString<Day?, Configurator> var d1: Day?
    init(d1: Day?) {
        self.d1 = d1
    }
}

class CodableAsDateStringTests: XCTestCase {

    func testDecodingISO8601DateString() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(DateStringContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAustralianDateStrings() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(DateStringContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAmericanDateStrings() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(DateStringContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }
}

class CodableAsDateStroingOptionalTests: XCTestCase {

    func testDecodingISO8601DateString() throws {
        let json = #"{"d1": "2012-02-01"}"#
        let result = try JSONDecoder().decode(DateStringOptionalContainer<DateStringConfig.ISO>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAustralianDateStrings() throws {
        let json = #"{"d1": "01/02/2012"}"#
        let result = try JSONDecoder().decode(DateStringOptionalContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingAmericanDateStrings() throws {
        let json = #"{"d1": "02/01/2012"}"#
        let result = try JSONDecoder().decode(DateStringOptionalContainer<DateStringConfig.MDY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 01)
    }

    func testDecodingNilAustralianDateStrings() throws {
        let json = #"{"d1": null}"#
        let result = try JSONDecoder().decode(DateStringOptionalContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == nil
    }

    func testDecodingInvalidAustralianDateStringsThrows() throws {

        let json = #"{"d1": "xxx"}"#
        let decoder = JSONDecoder()
        expect(try decoder.decode(DateStringOptionalContainer<DateStringConfig.DMY>.self, from: json.data(using: .utf8)!))
            .to(throwError { error in
                guard case DecodingError.dataCorrupted(let context) = error else {
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
        let instance = DateStringContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"01/02/2012"}"#
    }
}

class CodableAsDateStringOptionalTests: XCTestCase {

    func testEncoding() throws {
        let instance = DateStringOptionalContainer<DateStringConfig.DMY>(d1: Day(2012, 02, 01))
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"01/02/2012"}"#
    }

    func testEncodingNil() throws {
        let instance = DateStringOptionalContainer<DateStringConfig.DMY>(d1: nil)
        let encoder = JSONEncoder()
        encoder.outputFormatting = .withoutEscapingSlashes
        let result = try encoder.encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
