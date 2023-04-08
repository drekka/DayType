//
// Copyright © Derek Clarkson. All rights reserved.
//

import Foundation

/// Representation of a day.
public struct Day {

    static let secondsInHour = 60 * 60
    static let secondsInDay = secondsInHour * 24

    public let daysSince1970: Int

    /// Default initialiser.
    ///
    /// - daysSince1970: Same as ``Date``'s ``timeIntervalSince1970`` except expressed as the number of days.
    public init(daysSince1970: Int) {
        self.daysSince1970 = daysSince1970
    }

    /// Initialiser matching that in ``Date``.
    ///
    /// - timeIntervalSince1970: A ``TimeInterval`` representing the number of seconds since 1970. To obtain the number of days
    /// all the time components will be truncated.
    public init(timeIntervalSince1970: TimeInterval) {
        daysSince1970 = Int((timeIntervalSince1970 / Double(Day.secondsInDay)).rounded(.down))
    }

    public init(
}
