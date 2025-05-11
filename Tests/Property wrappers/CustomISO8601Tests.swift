//import DayType
//import Foundation
//import Testing
//
//private struct ISO8601CustomContainer<Configurator>: Codable where Configurator: CustomISO8601Configurator {
//    @CustomISO8601<Day, Configurator> var d1: Day
//    init(d1: Day) {
//        self.d1 = d1
//    }
//}
//
//private struct ISO8601CustomOptionalContainer<Configurator>: Codable where Configurator: CustomISO8601Configurator {
//    @CustomISO8601<Day?, Configurator> var d1: Day?
//    init(d1: Day?) {
//        self.d1 = d1
//    }
//}
//
//extension PropertyWrapperSuites {
//    
//    @Suite("@CustomISO8601")
//    struct CustomISO8601Tests {
//
//        @Test("Sans Timezone decoding")
//        func sansTimeZoneDecoding() throws {
//            let json = #"{"d1": "2012-02-02T13:33:23"}"#
//            let result = try JSONDecoder().decode(ISO8601CustomContainer<ISO8601Configuration.SansTimeZone>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 03))
//        }
//
//        @Test("Local timezone decoding")
//        func sansTimeZoneToLocalTimeZoneDecoding() throws {
//            enum SansTimeZoneToMelbourneTimeZone: CustomISO8601Configurator {
//                static func configure(formatter: ISO8601DateFormatter) {
//                    formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
//                    formatter.formatOptions.remove(.withTimeZone)
//                }
//            }
//            let json = #"{"d1": "2012-02-02T13:33:23"}"#
//            let result = try JSONDecoder().decode(ISO8601CustomContainer<SansTimeZoneToMelbourneTimeZone>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 02))
//        }
//
//        @Test("Floating to a different timezone decoding")
//        func timeZoneOverridingDateTimeZoneDecoding() throws {
//            enum BrazilToMelbourneTimeZone: CustomISO8601Configurator {
//                static func configure(formatter: ISO8601DateFormatter) {
//                    formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
//                }
//            }
//            let json = #"{"d1": "2012-02-02T13:33:23-03:00"}"#
//            let result = try JSONDecoder().decode(ISO8601CustomContainer<BrazilToMelbourneTimeZone>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 03))
//        }
//
//        @Test("Numeric iSO8601 decoding")
//        func minimalFormatDecoding() throws {
//            enum MinimalFormat: CustomISO8601Configurator {
//                static func configure(formatter: ISO8601DateFormatter) {
//                    formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
//                    formatter.formatOptions.insert(.withSpaceBetweenDateAndTime)
//                    formatter.formatOptions.subtract([.withTimeZone, .withColonSeparatorInTime, .withDashSeparatorInDate])
//                }
//            }
//            let json = #"{"d1": "20120202 133323"}"#
//            let result = try JSONDecoder().decode(ISO8601CustomContainer<MinimalFormat>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 02))
//        }
//
//        @Test("Optional sans timezone decoding")
//        func optionalSansTimeZoneDecoding() throws {
//            let json = #"{"d1": "2012-02-02T13:33:23"}"#
//            let result = try JSONDecoder().decode(ISO8601CustomOptionalContainer<ISO8601Configuration.SansTimeZone>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == Day(2012, 02, 03))
//        }
//
//        @Test("Sans timezone decoding of nil")
//        func optionalSansTimeZoneWithNilDecoding() throws {
//            let json = #"{"d1":null}"#
//            let result = try JSONDecoder().decode(ISO8601CustomOptionalContainer<ISO8601Configuration.SansTimeZone>.self, from: json.data(using: .utf8)!)
//            #expect(result.d1 == nil)
//        }
//
//        @Test("Custom ISO8601 encoding")
//        func encodingISO8601() throws {
//            let instance = ISO8601CustomContainer<ISO8601Configuration.SansTimeZone>(d1: Day(2012, 02, 03))
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":"2012-02-02T13:00:00"}"#)
//        }
//
//        @Test("Optional Custom ISO8601 encoding")
//        func encodingToOptional() throws {
//            let instance = ISO8601CustomOptionalContainer<ISO8601Configuration.SansTimeZone>(d1: Day(2012, 02, 03))
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":"2012-02-02T13:00:00"}"#)
//        }
//
//        @Test("Optional Custom ISO8601 encoding of nil")
//        func testEncodingNil() throws {
//            let instance = ISO8601CustomOptionalContainer<ISO8601Configuration.SansTimeZone>(d1: nil)
//            let result = try JSONEncoder().encode(instance)
//            #expect(String(data: result, encoding: .utf8) == #"{"d1":null}"#)
//        }
//    }
//}
