import DayTypeMacros
import Foundation

@ISO8601PropertyWrapper(name: "Default", formatter: DayFormatters.iso8601)
@ISO8601PropertyWrapper(name: "SansTimezone", formatter: DayFormatters.iso8601SansTimezone)
public enum ISO8601<DayType> where DayType: ISO8601Codable {}

@DecodeMissingString(type: ISO8601<Day?>.Default.self)
@DecodeMissingString(type: ISO8601<Day?>.SansTimezone.self)
extension KeyedDecodingContainer {}

@EncodeMissingString(type: ISO8601<Day?>.Default.self)
@EncodeMissingString(type: ISO8601<Day?>.SansTimezone.self)
extension KeyedEncodingContainer {}
