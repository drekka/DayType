import DayType
import Foundation
import Testing

extension ProtocolConformanceSuites {

    @Suite("Day is Codable")
    struct DayCodableTests {

        private struct DummyType: Codable {
            let abc: Day
        }

        @Test("Decoding")
        func decoding() throws {

            let json = """
            {
                "abc": 19455
            }
            """

            let decoder = JSONDecoder()
            let day = try decoder.decode(DummyType.self, from: json.data(using: .utf8)!)
            #expect(day.abc.daysSince1970 == 19455)
        }

        @Test("Encoding")
        func encoding() throws {
            let obj = DummyType(abc: Day(daysSince1970: 19455))
            let encoder = JSONEncoder()
            let encoded = try #require(String(data: encoder.encode(obj), encoding: .utf8))
            #expect(encoded == #"{"abc":19455}"#)
        }
    }
}
