//import DayType
//import Foundation
//import Testing
//
//private struct EpochContainer: Codable {
//    @EpochMilliseconds var d1: Day
//    init(d1: Day) {
//        self.d1 = d1
//    }
//}
//
//private struct EpochOptionalContainer: Codable {
//    @EpochMilliseconds var d1: Day?
//    init(d1: Day?) {
//        self.d1 = d1
//    }
//}
//
//extension PropertyWrapperSuites {
//
//    @Suite("@EpochMilliseconds")
//    struct EpochMillisecondsTests {
//
//        @Test("Decoding")
//        func decoding() throws {
//            let json = #"{"d1": 1328251182123}"#
//            let result = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 03))
//        }
//
//        @Test("Decoding an invalid value")
//        func decodingInvalidValue() throws {
//            do {
//                let json = #"{"d1": "2012-02-03T10:33:23.123+11:00"}"#
//                _ = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
//                Issue.record("Error not thrown")
//            } catch DecodingError.dataCorrupted(let context) {
//                #expect(context.codingPath.last?.stringValue == "d1")
//                #expect(context.debugDescription == "Unable to read a Day value, expected an epoch.")
//            } catch {
//                Issue.record("Unexpected error: \(error)")
//            }
//        }
//
//        @Test("Optional decoding")
//        func optionalDecoding() throws {
//            let json = #"{"d1": 1328251182123}"#
//            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 03))
//        }
//
//        @Test("Optional decoding nil")
//        func decodingNil() throws {
//            let json = #"{"d1": null}"#
//            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == nil)
//        }
//
//        @Test("Optional decoding with a missing value")
//        func decodingWithMissingValue() throws {
//            do {
//                let json = #"{}"#
//                _ = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
//                Issue.record("Error not thrown")
//            } catch DecodingError.keyNotFound(let key, _) {
//                #expect(key.stringValue == "d1")
//            } catch {
//                Issue.record("Unexpected error: \(error)")
//            }
//        }
//
//        @Test("Encoding")
//        func encoding() throws {
//            let instance = EpochContainer(d1: Day(2012, 02, 03))
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":1328187600000}"#)
//        }
//
//        @Test("Optional encoding")
//        func encodingOptional() throws {
//            let instance = EpochOptionalContainer(d1: Day(2012, 02, 03))
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":1328187600000}"#)
//        }
//
//        @Test("Optional encoding with a nil")
//        func encodingNil() throws {
//            let instance = EpochOptionalContainer(d1: nil)
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":null}"#)
//        }
//    }
//}
