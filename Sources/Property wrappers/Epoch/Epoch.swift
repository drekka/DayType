import Foundation
import DayTypeMacros

public enum Epoch<DayType> where DayType: EpochCodable {
    #epochCodablePropertyWrapper(typeName: "Milliseconds", milliseconds: true)
    #epochCodablePropertyWrapper(typeName: "Seconds", milliseconds: false)
}
