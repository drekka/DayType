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

private struct ISO8601CustomContainer<Configurator>: Codable where Configurator: CustomISO8601Configurator {
    @CustomISO8601<Day, Configurator> var d1: Day
    init(d1: Day) {
        self.d1 = d1
    }
}

private struct ISO8601CustomOptionalContainer<Configurator>: Codable where Configurator: CustomISO8601Configurator {
    @CustomISO8601<Day?, Configurator> var d1: Day?
    init(d1: Day?) {
        self.d1 = d1
    }
}

class CustomISO8601Tests: XCTestCase {

    func testDecodingSansTimeZone() throws {
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601CustomContainer<ISO8601Config.SansTimeZone>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingSansTimeZoneToTimeZone() throws {
        enum SansTimeZoneToMelbourneTimeZone: CustomISO8601Configurator {
            static func configure(formatter: ISO8601DateFormatter) {
                formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
                formatter.formatOptions.remove(.withTimeZone)
            }
        }
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601CustomContainer<SansTimeZoneToMelbourneTimeZone>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 02)
    }

    func testDecodingWithTimeZoneOverridesDateTimeZone() throws {
        enum BrazilToMelbourneTimeZone: CustomISO8601Configurator {
            static func configure(formatter: ISO8601DateFormatter) {
                formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
            }
        }
        let json = #"{"d1": "2012-02-02T13:33:23-03:00"}"#
        let result = try JSONDecoder().decode(ISO8601CustomContainer<BrazilToMelbourneTimeZone>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingMinimalFormat() throws {
        enum MinimalFormat: CustomISO8601Configurator {
            static func configure(formatter: ISO8601DateFormatter) {
                formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
                formatter.formatOptions.insert(.withSpaceBetweenDateAndTime)
                formatter.formatOptions.subtract([.withTimeZone, .withColonSeparatorInTime, .withDashSeparatorInDate])
            }
        }
        let json = #"{"d1": "20120202 133323"}"#
        let result = try JSONDecoder().decode(ISO8601CustomContainer<MinimalFormat>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 02)
    }

}

class CustomISO8601OptionalDayDecodingTests: XCTestCase {

    func testDecodingSansTimeZone() throws {
        let json = #"{"d1": "2012-02-02T13:33:23"}"#
        let result = try JSONDecoder().decode(ISO8601CustomOptionalContainer<ISO8601Config.SansTimeZone>.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingSansTimeZoneWithNil() throws {
        let json = #"{"d1":null}"#
        let result = try JSONDecoder().decode(ISO8601CustomOptionalContainer<ISO8601Config.SansTimeZone>.self, from: json.data(using: .utf8)!)
        expect(result.d1).to(beNil())
    }
}

class CustomISO8601EncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601CustomContainer<ISO8601Config.SansTimeZone>(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00"}"#
    }
}

class CustomISO8601OptionalDayEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601CustomOptionalContainer<ISO8601Config.SansTimeZone>(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00"}"#
    }

    func testEncodingNil() throws {
        let instance = ISO8601CustomOptionalContainer<ISO8601Config.SansTimeZone>(d1: nil)
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
