/// Errors thrown when constructing a ``Day`` with invalid components.
public enum DayError: Error, Equatable {
    /// The month value was outside the valid range of 1–12.
    case monthOutOfRange(month: Int)
    /// The day value was outside the valid range for the specified month and year.
    case dayOutOfRange(day: Int, month: Int, year: Int)
}
