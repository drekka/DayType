import OrderedCollections

public extension OrderedDictionary where Key == Day, Value == [CalendarDay] {

    /// Merges two calendar month dictionaries, maintaining chronological order.
    ///
    /// Overlapping weeks (which occur at month boundaries) are naturally deduplicated
    /// because the key (the first ``Day`` of the week) already exists.
    /// When both dictionaries contain the same key, the left-hand side's entry is kept.
    ///
    /// - returns: A merged ``CalendarDays`` in chronological order.
    static func + (lhs: Self, rhs: Self) -> Self {
        var result = lhs.merging(rhs) { current, _ in current }
        result.sort { $0.key < $1.key }
        return result
    }

    /// Merges two calendar month dictionaries, maintaining chronological order.
    ///
    /// Overlapping weeks (which occur at month boundaries) are naturally deduplicated
    /// because the key (the first ``Day`` of the week) already exists.
    /// When both dictionaries contain the same key, the left-hand side's entry is kept.
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs + rhs
    }
}
