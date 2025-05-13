import Foundation

extension Day: Strideable {

    public func distance(to other: Day) -> Int {
        other.daysSince1970 - daysSince1970
    }

    public func advanced(by n: Int) -> Day {
        self + n
    }
}
