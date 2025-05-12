import DayTypeMacros
import Foundation

/// Identifies a ``Day`` property that reads and writes from day strings using a formatter.

@DayStringPropertyWrapper(name: "DMY", formatter: DayFormatters.dmy)
@DayStringPropertyWrapper(name: "MDY", formatter: DayFormatters.mdy)
@DayStringPropertyWrapper(name: "YMD", formatter: DayFormatters.ymd)
public enum DayString<DayType> where DayType: DayStringCodable {}

@DecodeMissingString(type: DayString<Day?>.DMY.self)
@DecodeMissingString(type: DayString<Day?>.MDY.self)
@DecodeMissingString(type: DayString<Day?>.YMD.self)
extension KeyedDecodingContainer {}

@EncodeMissingString(type: DayString<Day?>.DMY.self)
@EncodeMissingString(type: DayString<Day?>.MDY.self)
@EncodeMissingString(type: DayString<Day?>.YMD.self)
extension KeyedEncodingContainer {}
