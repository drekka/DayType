import DayType
import Foundation
import Testing

@Suite("Day")
struct DayTests {

    // MARK: - Initialisers

    @Test("Init")
    func testInit() {
        #expect(Day().daysSince1970 > 0)
    }

    @Test("Init with days since 1970")
    func initDaysSince1970() {
        #expect(Day(daysSince1970: 19455).daysSince1970 == 19455)
    }

    @Test("Init with time interval since 1970")
    func initTimeIntervalSince1970() {
        #expect(Day(timeIntervalSince1970: 1_680_954_742).daysSince1970 == 19455)
    }

    @Test("Init with time interval since 1970 time truncations")
    func initTimeIntervalSince1970TruncationCheck() {
        #expect(Day(timeIntervalSince1970: 24 * 60 * 60 - 1).daysSince1970 == 0)
        #expect(Day(timeIntervalSince1970: 24 * 60 * 60 + 0).daysSince1970 == 1)
        #expect(Day(timeIntervalSince1970: 24 * 60 * 60 + 1).daysSince1970 == 1)
    }

    @Test("Init with components")
    func initComponents() {
        #expect(Day(components: DayComponents(year: 2023, month: 4, day: 8)).daysSince1970 == 19455)
    }

    @Test("Init with short form components")
    func initShortForm() {
        #expect(Day(2023, 4, 8).daysSince1970 == 19455)
    }

    @Test("Check Day vs Date math")
    func dateToDayToDayComponents() {
        let baseDate = Calendar.current.date(from: DateComponents(year: 1900, month: 1, day: 1))!
        for offset in 0 ..< 1_000_000 {
            let expectedDate = Calendar.current.date(byAdding: .day, value: offset, to: baseDate)!
            let day = Day(date: expectedDate)
            guard matches(day: day, date: expectedDate) else {
                break
            }
        }
    }

    private func matches(day: Day, date: Date, sourceLocation: Testing.SourceLocation = #_sourceLocation) -> Bool {

        let dayComponents = day.dayComponents()
        let dateComponents = Calendar.current.dateComponents([.year, .month, .day], from: date)

        guard dayComponents.year == dateComponents.year,
              dayComponents.month == dateComponents.month,
              dayComponents.day == dateComponents.day else {
            print("Date components: \(dateComponents)")
            print("Day components : \(dayComponents)")
            Issue.record("Day from date and back to date failed", sourceLocation: sourceLocation)
            return false
        }
        return true
    }
}
