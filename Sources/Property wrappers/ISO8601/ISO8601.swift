import Foundation
import DayTypeMacros

public enum ISO8601<DayType> where DayType: ISO8601Codable {
    #ios8601CodablePropertyWrapper(typeName: "Default", formatter: DayFormatters.iso8601)
    #ios8601CodablePropertyWrapper(typeName: "SansTimezone", formatter: DayFormatters.iso8601SansTimezone)
}
