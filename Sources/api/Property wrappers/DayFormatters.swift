import Foundation

enum DayFormatters {

    public static let dmy = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        return formatter
    }()

    public static let mdy = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy"
        return formatter
    }()

    public static let ymd = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }()

    public static let iso8601 = ISO8601DateFormatter()

    public static let iso8601SansTimezone = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions.remove(.withTimeZone)
        return formatter
    }()
}
