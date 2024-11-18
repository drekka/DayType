import DayType
import Nimble
import XCTest

private struct ISO8601Container: Codable {

    @ISO8601 var d1: Day
    init(d1: Day) {
        self.d1 = d1
    }
}

private struct ISO8601OptionalContainer: Codable {
    @ISO8601 var d1: Day?
    init(d1: Day?) {
        self.d1 = d1
    }
}

class ISO8601Tests: XCTestCase {

    func testDecoding() throws {
        let json = #"{"d1": "2012-02-03T10:33:23+11:00"}"#
        let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingWithDefaultGMT() throws {
        let json = #"{"d1": "2012-02-02T13:33:23Z"}"#
        let result = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingWithInvalidStringDate() throws {
        do {
            let json = #"{"d1": "xxxx"}"#
            _ = try JSONDecoder().decode(ISO8601Container.self, from: json.data(using: .utf8)!)
            fail("Error not thrown")
        } catch DecodingError.dataCorrupted(let context) {
            expect(context.debugDescription) == "Unable to read a Day value, expected a valid ISO8601 string."
            expect(context.codingPath.last?.stringValue) == "d1"
        }
    }
}

class ISO8601OptionalTests: XCTestCase {

    func testDecoding() throws {
        let json = #"{"d1": "2012-02-03T10:33:23+11:00"}"#
        let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingWithNil() throws {
        let json = #"{"d1": null}"#
        let result = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1).to(beNil())
    }

    func testDecodingWithMissingValue() throws {
        do {
            let json = #"{}"#
            _ = try JSONDecoder().decode(ISO8601OptionalContainer.self, from: json.data(using: .utf8)!)
            fail("Error not thrown")
        } catch DecodingError.keyNotFound(let key, _) {
            expect(key.stringValue) == "d1"
        }
    }
}

class ISO8601DayEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601Container(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00Z"}"#
    }
}

class ISO8601OptionalDayEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = ISO8601OptionalContainer(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":"2012-02-02T13:00:00Z"}"#
    }

    func testEncodingNil() throws {
        let instance = ISO8601OptionalContainer(d1: nil)
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
