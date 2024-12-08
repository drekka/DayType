import Foundation

/// Sets up the ``ISO8601DateFormatter`` used for decoding and encoding date strings.
public protocol CustomISO8601Configurator {

    /// Called when setting up to decode or encode an ISO8601 date string.
    static func configure(formatter: ISO8601DateFormatter)
}

/// Useful common configurations of ISO8601 formatters.
public enum ISO8601Config {

    /// A default implementation that leaves the formatted untouched from it's defaults.
    /// in the default property wrappers.
    public enum Default: CustomISO8601Configurator {
        public static func configure(formatter _: ISO8601DateFormatter) {}
    }

    /// Tells the formatter to ignores timezone values.
    public enum SansTimeZone: CustomISO8601Configurator {
        public static func configure(formatter: ISO8601DateFormatter) {
            formatter.formatOptions.remove(.withTimeZone)
        }
    }
}
