import Foundation

extension Day: Comparable {
    public static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.daysSince1970 < rhs.daysSince1970
    }
}
