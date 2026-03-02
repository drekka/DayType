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
        lhs.merging(rhs) { current, _ in current }
    }

    /// Merges the calendar month containing `day` into this calendar.
    ///
    /// The ``StartOfWeek`` is inferred from the existing keys' weekday.
    /// Overlapping boundary weeks are deduplicated as with the dictionary merge.
    ///
    /// - returns: A merged ``CalendarDays`` in chronological order.
    static func + (lhs: Self, rhs: Day) -> Self {
        guard let firstKey = lhs.keys.first else {
            return rhs.calendarMonth()
        }
        let startOfWeek: StartOfWeek = firstKey.weekday == .monday ? .monday : .sunday
        return lhs + rhs.calendarMonth(startingOn: startOfWeek)
    }
}
