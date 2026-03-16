import Foundation
import DayTypeMacros

@EpochPropertyWrapper(typeName: "Milliseconds", milliseconds: true)
@EpochPropertyWrapper(typeName: "Seconds", milliseconds: false)
public enum Epoch<DayType> where DayType: EpochCodable {}

@DecodeMissingEpoch(type: Epoch<Day?>.Milliseconds.self)
@DecodeMissingEpoch(type: Epoch<Day?>.Seconds.self)
extension KeyedDecodingContainer {}

@EncodeMissingEpoch(type: Epoch<Day?>.Milliseconds.self)
@EncodeMissingEpoch(type: Epoch<Day?>.Seconds.self)
extension KeyedEncodingContainer {}
