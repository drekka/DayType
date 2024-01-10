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

private enum SansTimeZone: ISO8601Configurator {
    static func configure(formatter: ISO8601DateFormatter) {
        formatter.formatOptions.remove(.withTimeZone)
    }
}

private struct ISO8601Container: Codable {
    @CustomISO8601Day<Day, SansTimeZone> var d1: Day
    init(d1: Day) {
        self.d1 = d1
    }
}

private struct ISO8601OptionalContainer: Codable {
    @CustomISO8601Day<Day?, SansTimeZone> var d1: Day?
    init(d1: Day?) {
        self.d1 = d1
    }
}

class CustomISO8601DayDecodingTests: XCTestCase {

    func testDecodingSansTimeZone() throws {
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingSansTimeZoneToTimeZone() throws {
        enum SansTimeZoneToMelbourneTimeZone: ISO8601Configurator {
            static func configure(formatter: ISO8601DateFormatter) {
                formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
                formatter.formatOptions.remove(.withTimeZone)
            }
        }
        struct ISO8601Container: Codable { @CustomISO8601Day<Day, SansTimeZoneToMelbourneTimeZone> var d1: Day }
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 02)
    }

    func testDecodingWithTimeZoneOverridesDateTimeZone() throws {
        enum BrazilToMelbourneTimeZone: ISO8601Configurator {
            static func configure(formatter: ISO8601DateFormatter) {
                formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
            }
        }
        struct ISO8601Container: Codable { @CustomISO8601Day<Day, BrazilToMelbourneTimeZone> var d1: Day }
        let json = #"{"d1": "2012-02-02T13:33:23-03:00"}"#
        let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }
}

class CustomISO8601OptionalDayDecodingTests: XCTestCase {

    func testDecodingSansTimeZone() throws {
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingSansTimeZoneWithNil() throws {
        let json = #"{"d1":null}"#
        let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1).to(beNil())
    }
}

class ISO8601CustomDayEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601Container(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00"}"#
    }
}

class CustomISO8601OptionalDayEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601OptionalContainer(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00"}"#
    }

    func testEncodingNil() throws {
        let instance = ISO8601OptionalContainer(d1: nil)
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
