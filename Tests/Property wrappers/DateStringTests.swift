//import DayType
//import Foundation
//import Testing
//
//private struct DayContainer<Configuration>: Codable where Configuration: DayStringConfiguration {
//    @DayString<Day, Configuration> var d1: Day
//}
//
//private struct OptionalDayContainer<Configuration>: Codable where Configuration: DayStringConfiguration {
//    @DayString<Day?, Configuration> var d1: Day?
//}
//
//extension PropertyWrapperSuites {
//
//    @Suite("@DayString")
//    struct DateStringTests {
//
//        @Test("ISO8601 date decoding")
//        func decodingAnISO8601Date() throws {
//            let json = #"{"d1": "2012-02-01"}"#
//            let result = try JSONDecoder().decode(DayContainer<DayString.ISO>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("DMY date decoding")
//        func decodingADMYDate() throws {
//            let json = #"{"d1": "01/02/2012"}"#
//            let result = try JSONDecoder().decode(DayContainer<DayString.DMY>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("MDY date decoding")
//        func decodingAMDYDate() throws {
//            let json = #"{"d1": "02/01/2012"}"#
//            let result = try JSONDecoder().decode(DayContainer<DayString.MDY>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("Optional ISO8601 date decoding")
//        func decodingAnIOptionalISO8601Date() throws {
//            let json = #"{"d1": "2012-02-01"}"#
//            let result = try JSONDecoder().decode(OptionalDayContainer<DayString.ISO>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("DMY date")
//        func decodingAnOptionalDMYDate() throws {
//            let json = #"{"d1": "01/02/2012"}"#
//            let result = try JSONDecoder().decode(OptionalDayContainer<DayString.DMY>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("MDY date decoding")
//        func decodingAnOptionalMDYDate() throws {
//            let json = #"{"d1": "02/01/2012"}"#
//            let result = try JSONDecoder().decode(OptionalDayContainer<DayString.MDY>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 01))
//        }
//
//        @Test("Nil date decoding")
//        func decodingANilDate() throws {
//            let json = #"{"d1": null}"#
//            let result = try JSONDecoder().decode(OptionalDayContainer<DayString.DMY>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == nil)
//        }
//
//        @Test("Invalid date decoding throws an error")
//        func decodingInvalidDateThrows() throws {
//            do {
//                let json = #"{"d1": "xxx"}"#
//                _ = try JSONDecoder().decode(OptionalDayContainer<DayString.DMY>.self, from: json.data(using: .utf8)!)
//                Issue.record("Error not thrown")
//            } catch DecodingError.dataCorrupted(let context) {
//                #expect(context.codingPath.map(\.stringValue) == ["d1"])
//                #expect(context.debugDescription == "Unable to read the date string.")
//            } catch {
//                Issue.record("Unexpected error: \(error)")
//            }
//        }
//
//        @Test("DMY date encoding")
//        func encodingDateString() throws {
//            let instance = DayContainer<DayString.DMY>(d1: Day(2012, 02, 01))
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .withoutEscapingSlashes
//            let result = try encoder.encode(instance)
//            #expect(String(data: result, encoding: .utf8)! == #"{"d1":"01/02/2012"}"#)
//        }
//
//        @Test("Optional DMY date encoding")
//        func encodingOptionalDateString() throws {
//            let instance = OptionalDayContainer<DayString.DMY>(d1: Day(2012, 02, 01))
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .withoutEscapingSlashes
//            let result = try encoder.encode(instance)
//            #expect(String(data: result, encoding: .utf8)! == #"{"d1":"01/02/2012"}"#)
//        }
//
//        @Test("Optional DMY date encoding from a nil")
//        func encodingOptionalDateStringWithNil() throws {
//            let instance = OptionalDayContainer<DayString.DMY>(d1: nil)
//            let encoder = JSONEncoder()
//            encoder.outputFormatting = .withoutEscapingSlashes
//            let result = try encoder.encode(instance)
//            #expect(String(data: result, encoding: .utf8)! == #"{"d1":null}"#)
//        }
//    }
//}
