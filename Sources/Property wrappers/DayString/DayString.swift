import DayTypeMacros
import Foundation

/// Identifies a ``Day`` property that reads and writes from day strings using a formatter.

@DayStringBuiltin(name: "DMY", formatter: DayFormatters.dmy)
@DayStringBuiltin(name: "MDY", formatter: DayFormatters.mdy)
@DayStringBuiltin(name: "YMD", formatter: DayFormatters.ymd)
public enum DayString<DayType> where DayType: DayStringCodable {}

@DecodeMissing(type: DayString<Day?>.DMY.self)
@DecodeMissing(type: DayString<Day?>.MDY.self)
@DecodeMissing(type: DayString<Day?>.YMD.self)
extension KeyedDecodingContainer {}

@EncodeMissing(type: DayString<Day?>.DMY.self)
@EncodeMissing(type: DayString<Day?>.MDY.self)
@EncodeMissing(type: DayString<Day?>.YMD.self)
extension KeyedEncodingContainer {}
