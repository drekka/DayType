import Foundation

public extension Day {

    /// Adds the specific value to the current `Day` and returns a new `Day`.
    ///
    /// This is convenient for doing things like generating dates for the same day of each month. Note though that
    /// if the added value would produce an invaid date, the actual `Day` returned contains a valid date produced by
    /// rolling the values through the subsequent days and months. ie. if you do `Day(2001,2,3).day(byAdding: .day, value: 55)` you will get
    ///
    func day(byAdding component: Day.Component, value: Int) -> Day {
        let components = self.dayComponents()
        return Day(components.year + (component == .year ? value : 0), components.month + (component == .month ? value : 0), components.day + (component == .day ? value : 0))
    }


}
