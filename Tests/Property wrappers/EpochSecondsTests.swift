import DayType
import Foundation
import Testing

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

extension PropertyWrapperSuites {

    @Suite("@EpochSeconds")
    struct EpochSecondsTests {

        @Test("Decoding")
        func decoding() throws {
            let json = #"{"d1": 1328251182}"#
            let result = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
            #expect(result.d1 == Day(2012, 02, 03))
        }

        @Test("Decoding an invalid value")
        func decodingWithInvalidValue() throws {
            do {
                let json = #"{"d1": "2012-02-03T10:33:23+11:00"}"#
                _ = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
                Issue.record("Error not thrown")
            } catch DecodingError.dataCorrupted(let context) {
                #expect(context.codingPath.last?.stringValue == "d1")
                #expect(context.debugDescription == "Unable to read a Day value, expected an epoch.")
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }

        @Test("Decoding an optional")
        func decodingOptional() throws {
            let json = #"{"d1": 1328251182}"#
            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.d1 == Day(2012, 02, 03))
        }

        @Test("Decoding an optional with a nil")
        func decodingWithNil() throws {
            let json = #"{"d1": null}"#
            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.d1 == nil)
        }

        @Test("Decoding an optional when value is missing")
        func missingValue() throws {
            do {
                let json = #"{}"#
                _ = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
                Issue.record("Error not thrown")
            } catch DecodingError.keyNotFound(let key, _) {
                #expect(key.stringValue == "d1")
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }

        @Test("Encoding epoch seconds")
        func encoding() throws {
            let instance = EpochContainer(d1: Day(2012, 02, 03))
            let result = try JSONEncoder().encode(instance)
            #expect(String(data: result, encoding: .utf8) == #"{"d1":1328187600}"#)
        }

        @Test("Encoding when optional")
        func encodingOptional() throws {
            let instance = EpochOptionalContainer(d1: Day(2012, 02, 03))
            let result = try JSONEncoder().encode(instance)
            #expect(String(data: result, encoding: .utf8) == #"{"d1":1328187600}"#)
        }

        @Test("Encoding when ooptional and nil value")
        func encodingOptionalWithNil() throws {
            let instance = EpochOptionalContainer(d1: nil)
            let result = try JSONEncoder().encode(instance)
            #expect(String(data: result, encoding: .utf8) == #"{"d1":null}"#)
        }
    }
}
