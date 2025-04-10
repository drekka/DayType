import Foundation
import DayTypeMacros

/// Identifies a ``Day`` property that reads and writes from day strings using a formatter.
public enum DayString<DayType> where DayType: DayStringCodable {
    #dayStringCodablePropertyWrapper(typeName: "DMY", formatter: DayFormatters.dmy)
    #dayStringCodablePropertyWrapper(typeName: "MDY", formatter: DayFormatters.mdy)
    #dayStringCodablePropertyWrapper(typeName: "YMD", formatter: DayFormatters.ymd)
}

