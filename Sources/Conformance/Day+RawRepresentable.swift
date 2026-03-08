import Foundation

/// `RawRepresentable` conformance using `daysSince1970` as the raw value.
///
/// This is required for SwiftData compatibility. Without it, SwiftData decomposes `Day`
/// into its internal stored property (`daysSince1970`) and uses that as the column name
/// instead of the model's property name. Conforming to `RawRepresentable` tells SwiftData
/// to treat `Day` as a single scalar value, producing correctly named columns
/// (e.g. `ZSTARTDATE`) and enabling keypath-based queries like `@Query(sort: \.startDate)`.
extension Day: RawRepresentable {

    public init?(rawValue: Int) {
        self.init(daysSince1970: rawValue)
    }

    public var rawValue: Int { daysSince1970 }
}
