import Foundation

extension Day: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(daysSince1970)
    }
}

extension Day: Equatable {
    public static func == (lhs: Day, rhs: Day) -> Bool {
        lhs.daysSince1970 == rhs.daysSince1970
    }
}

extension Day: Comparable {
    public static func < (lhs: Day, rhs: Day) -> Bool {
        lhs.daysSince1970 < rhs.daysSince1970
    }
}
