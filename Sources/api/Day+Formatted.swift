import Foundation

public extension Day {

    /// Converts `self` to its textual representation that contains the date parts.
    ///
    /// The exact format depends on the user's preferences, however this is done using the ``Date.formatted(style:)``
    /// function so all the logic is the same except the time component is omitted.
    ///
    /// - Parameters:
    ///   - day: The style for describing the day. This makes used of the ``Date.FormatStyle.Date`` options.
    /// - Returns: A `String` describing `self`.
    func formatted(_ day: Date.FormatStyle.DateStyle = .abbreviated) -> String {
        date().formatted(date: day, time: .omitted)
    }

    /// Converts `self` to its textual representation using a custom `Date.FormatStyle`.
    ///
    /// Use this when the fixed presets in ``formatted(_:)-swift.method`` can't express the wanted format, e.g. day
    /// + month with no year: `.dateTime.day().month(.abbreviated)`.
    ///
    /// - Parameters:
    ///   - style: The `Date.FormatStyle` describing how to render `self`.
    /// - Returns: A `String` describing `self`.
    func formatted(_ style: Date.FormatStyle) -> String {
        date().formatted(style)
    }
}
