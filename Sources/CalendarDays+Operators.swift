import OrderedCollections

public extension OrderedDictionary where Key == Day, Value == [Day] {

    /// Merges two calendar month dictionaries, maintaining chronological order.
    ///
    /// Overlapping weeks (which occur at month boundaries) are naturally deduplicated
    /// because the key (the first ``Day`` of the week) already exists.
    /// When both dictionaries contain the same key, the left-hand side's entry is kept.
    ///
    /// - returns: A merged ``CalendarDays`` in chronological order.
    static func + (lhs: Self, rhs: Self) -> Self {
        lhs.merging(rhs) { current, _ in current }
    }

    /// Merges two calendar month dictionaries, maintaining chronological order.
    ///
    /// Overlapping weeks (which occur at month boundaries) are naturally deduplicated
    /// because the key (the first ``Day`` of the week) already exists.
    /// When both dictionaries contain the same key, the left-hand side's entry is kept.
    static func += (lhs: inout Self, rhs: Self) {
        lhs = lhs.merging(rhs) { current, _ in current }
    }
}
