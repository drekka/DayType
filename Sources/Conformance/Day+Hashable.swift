import Foundation

extension Day: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(daysSince1970)
    }
}
