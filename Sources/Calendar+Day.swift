//
//  File.swift
//
//
//  Created by Derek Clarkson on 14/2/2022.
//

import Foundation

public extension Calendar {
    
    func day(fromComponents components: DayComponents) -> Day? {
        
        let calendar = components.calendar ?? self
        let timeZone = components.timeZone ?? timeZone
        
        guard let year = components.year,
              let month = components.month,
              let day = components.dayOfMonth else {
            return nil
        }
        
        return Day(year: <#T##Int#>, month: <#T##Int#>, day: <#T##Int#>, inTimeZone: <#T##TimeZone#>)
        
        
    }

    func dayComponents(from day: Day) -> DayComponents {
        dayComponents(inTimeZone: timeZone, from: day)
    }

    func dayComponents(inTimeZone timeZone: TimeZone, from day: Day) -> DayComponents {
        switch identifier {
        case .gregorian:
            return gregorianDayComponents(from: day)
        default:
        }
        
        if self.identifier === Identifier.gregorian
        
    }
}

extension Calendar {
    
    func gregorianDayComponents(from day: Day) -> DayComponents {

        // Map back to 01/03/0000
        let daysSinceEra0 = day.dayIntervalSince1970 + 719_468

            // Add a day of the time zone is positive.
            + timeZone.secondsFromGMT() > 0 ? 1 : 0

        // Ge the era
        let era = (daysSinceEra0 >= 0 ? daysSinceEra0 : daysSinceEra0 - 146_096) / 146_097

        // Get the number of days we are into the current era.
        let dayOfEra = daysSinceEra0 - era * 146_097

        // Year of era
        let yearOfEra = (dayOfEra - dayOfEra / 1460 + dayOfEra / 36524 - dayOfEra / 146_096) / 365

        // Work out the day of the year
        let dayOfYear = dayOfEra - (365 * yearOfEra + yearOfEra / 4 - yearOfEra / 100)

        // Month
        let offsetMonth = (5 * dayOfYear + 2) / 153
        let month = offsetMonth + (offsetMonth < 10 ? 3 : -9)

        // Year
        let offsetYear = yearOfEra + era * 400
        let year = offsetYear + (month <= 2 ? 1 : 0)

        // Day
        let day = dayOfYear - (153 * offsetMonth + 2) / 5 + 1

        // Finally generate the components
        return DayComponents(calendar: self,
                             timeZone: timeZone,
                             year: year,
                             month: month,
                             dayOfMonth: day)
    }
}
