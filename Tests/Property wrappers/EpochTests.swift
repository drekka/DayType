import DayType
import Foundation
import Testing

private struct EpochContainer: Codable {
    @Epoch.Milliseconds var milliseconds: Day
    @Epoch.Seconds var seconds: Day
}

private struct EpochOptionalContainer: Codable {
    @Epoch.Milliseconds var milliseconds: Day?
    @Epoch.Seconds var seconds: Day?
}

private struct EpochOptionalNullContainer: Codable {
    @Epoch.Milliseconds.Nullable var milliseconds: Day?
    @Epoch.Seconds.Nullable var seconds: Day?
}

extension PropertyWrapperSuites {

    @Suite("@Epoch")
    struct EpochTests {

        @Test("Decoding epochs")
        func decoding() throws {
            let json = #"{"milliseconds": 1328251182123, "seconds": 1328251182}"#
            let result = try JSONDecoder().decode(EpochContainer.self, from: json.data(using: .utf8)!)
            let expectedDay = Day(2012, 02, 03)
            #expect(result.milliseconds == expectedDay)
            #expect(result.seconds == expectedDay)
        }

        @Test("Decoding optional epochs")
        func decodingOptional() throws {
            let json = #"{"milliseconds": 1328251182123, "seconds": 1328251182}"#
            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            let expectedDay = Day(2012, 02, 03)
            #expect(result.milliseconds == expectedDay)
            #expect(result.seconds == expectedDay)
        }

        @Test("Decoding missing epochs")
        func decodingMissingOptional() throws {
            let json = #"{}"#
            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.milliseconds == nil)
            #expect(result.seconds == nil)
        }

        @Test("Decoding null epochs")
        func decodingNullOptional() throws {
            let json = #"{"milliseconds": null, "seconds": null}"#
            let result = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
            #expect(result.milliseconds == nil)
            #expect(result.seconds == nil)
        }

        @Test("Decoding invalid epochs")
        func decodingInvalidEpochs() throws {
            do {
                let json = #"{"milliseconds": "xxx"}"#
                _ = try JSONDecoder().decode(EpochOptionalContainer.self, from: json.data(using: .utf8)!)
                Issue.record("Error not thrown")
            } catch DecodingError.dataCorrupted(let context) {
                #expect(context.codingPath.map(\.stringValue) == ["milliseconds"])
                #expect(context.debugDescription == "Unable to read a Day value, expected an epoch.")
            } catch {
                Issue.record("Unexpected error: \(error)")
            }
        }

        @Test("Epoch encoding")
        func encodingEpochs() throws {
            let day = Day(2012, 02, 03)
            let instance = EpochContainer(milliseconds: day, seconds: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"milliseconds":1328187600000,"seconds":1328187600}"#)
        }

        @Test("Optional epoch encoding")
        func optionalEncodingEpochs() throws {
            let day = Day(2012, 02, 03)
            let instance = EpochOptionalContainer(milliseconds: day, seconds: day)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"milliseconds":1328187600000,"seconds":1328187600}"#)
        }

        @Test("Optional epoch encoding nil")
        func optionalEncodingEpochsWithNil() throws {
            let instance = EpochOptionalContainer(milliseconds: nil, seconds: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{}"#)
        }

        @Test("Optional epoch encoding nil -> null")
        func optionalEncodingEpochsWithNilToNull() throws {
            let instance = EpochOptionalNullContainer(milliseconds: nil, seconds: nil)
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.withoutEscapingSlashes, .sortedKeys]
            let result = try encoder.encode(instance)
            let json = String(data: result, encoding: .utf8)!
            #expect(json == #"{"milliseconds":null,"seconds":null}"#)
        }
    }
}
