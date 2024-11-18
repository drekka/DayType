import DayType
import Nimble
import XCTest

private struct EpochContainer: Codable {
    @EpochSeconds var d1: Day
    init(d1: Day) {
        self.d1 = d1
    }
}

private struct EpochOptionalContainer: Codable {
    @EpochSeconds var d1: Day?
    init(d1: Day?) {
        self.d1 = d1
    }
}

class EpochSecondsDecodingTests: XCTestCase {

    func testDecoding() throws {
        let json = #"{"d1": 1328251182}"#
        let result = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingWithInvalidValue() throws {
        do {
            let json = #"{"d1": "2012-02-03T10:33:23+11:00"}"#
            _ = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
            fail("Error not thrown")
        } catch DecodingError.dataCorrupted(let context) {
            expect(context.codingPath.last?.stringValue) == "d1"
            expect(context.debugDescription) == "Unable to read a Day value, expected an epoch."
        }
    }

}

class CodableAsEpochSecondsDecodiongOptionalTests: XCTestCase {

    func testDecoding() throws {
        let json = #"{"d1": 1328251182}"#
        let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1) == Day(2012, 02, 03)
    }

    func testDecodingWithNil() throws {
        let json = #"{"d1": null}"#
        let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
        expect(result.d1).to(beNil())
    }

    func testDecodingWithMissingValue() throws {
        do {
            let json = #"{}"#
            _ = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            fail("Error not thrown")
        } catch DecodingError.keyNotFound(let key, _) {
            expect(key.stringValue) == "d1"
        }
    }
}

class CodableAsEpochSecondsEncodingTests: XCTestCase {

    func testEncoding() throws {
        let instance = EpochContainer(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":1328187600}"#
    }
}

class CodableAsEpochSecondsEncodingOptionalTests: XCTestCase {

    func testEncoding() throws {
        let instance = EpochOptionalContainer(d1: Day(2012, 02, 03))
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":1328187600}"#
    }

    func testEncodingNil() throws {
        let instance = EpochOptionalContainer(d1: nil)
        let result = try JSONEncoder().encode(instance)
        expect(String(data: result, encoding: .utf8)!) == #"{"d1":null}"#
    }
}
