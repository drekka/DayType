![Calendar](media/Calendar.png)
# DayType

(A friendly API for working with dates without the time of day)

Developers regularly need to refer to a date without needing to know a specific point in time. For example, a person's date of birth is often needed, but not the exact time they were born. The same goes for many other things. The dates of a person's leave, religious holidays, sales, festivals, etc.

Swift provides the excellent `Date`, `Calendar` and `TimeZone` types for details with specific points in time. But when it comes to the generalisation that is a date they can become a lot harder to work with. As a result developers often find themselves stripping the time components from Swift's `Date` to try and make them work as dates. Add in the complexities of time zone calculations and this can become quite fragile and prone to bugs. 

`DayType` sets out to address these issues by providing `Day` which represents a general 24 hours period instead of a specific point in time. ie. no hours, minutes, etc. This allows date code to be simpler because it no longer needs to sanitise time components and removes the angst of accidental bugs as well as making date based calculations simpler.

## Installation

`DayType` is a SPM package.

# Creating a Day

`Day` has a number of convenience initialisers which are pretty self explanatory and mostly similar to Swift's `Date`:

```swift
init()
init(daysSince1970: DayInterval)
init(timeIntervalSince1970: TimeInterval)
init(date: Date, usingCalendar calendar: Calendar = .current)
init(components: DayComponents)
init(_ year: Int, _ month: Int, _ day: Int)
init(year: Int, month: Int, day: Int) 
```

# Codable

`Day` is fully `Codable`. 

The actual value it reads and write is an `Int` representing the number of days since 1970 and you can access it via the `.daysSince1970` property. 

# Properties

## .daysSince1970

Literally the number of days since Swift's base date of 00:00:00 UTC on 1 January 1970. 

_Note that will match the number of days produced by:_

```swift
let fromDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 0))
let toDate = Calendar.current.startOfDay(for: Date())
let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
```

# Property wrappers 

`Day`'s internal value isn't something that external APIs are typically aware of. So to support the typical values that external APIs tend to use `DayType` provides a variety of property wrappers implementing `Codable` to automatically handle the conversions. 

_Note: All of these wrappers support both `Day` and `Day?` properties through the use of the `DayCodable` protocol which is applied to both. Technically this protocol could be added to other types to make then covertable to `Day`._

## @EpochDay

Converts [epoch timestamps](https://www.epochconverter.com) to `Day`. For example the JSON data structure:

```json
{
  "dob":856616400
}
```

Can be read by:

```swift
struct MyType: Codable {
  @EpochDay var dob: Day // or Day?
}
```

## @ISO8601Day

Converts [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) date strings to `Day`. For example:

```json
{
  "dob": "1997-02-22T13:00:00+11:00"
}
```

Can be read by:

```swift
struct MyType: Codable {
  @ISO8601Day var dob: Day // or Day?
}
```

## @CustomISO8601Day<T, Configurator>

Where `T: DayCodable` and `Configurator: ISO8601Configurator`. 

Internally `DayType` uses an `ISO8601DateFormatter` to read and write [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) strings. As there are a variety of ISO8601 formats, this property wrapper allows you to pre-configure the formatter before it processes the string.

For example:

```json
{
  "dob": "20120202 133323"
}
```

Can be read by:

```swift
enum MinimalFormat: ISO8601Configurator {
    static func configure(formatter: ISO8601DateFormatter) {
        formatter.timeZone = TimeZone(secondsFromGMT: 11 * 60 * 60)
        formatter.formatOptions.insert(.withSpaceBetweenDateAndTime)
        formatter.formatOptions.subtract([.withTimeZone, .withColonSeparatorInTime, .withDashSeparatorInDate])    }
}

struct MyType: Codable {
  @CustomISO8601Day<Day, MinimalFormat> var dob: Day
  // or ...
  @CustomISO8601Day<Day?, MinimalFormat> var dob: Day?
}
```

The `ISO8601Configurator` protocol specifies only a single function which is  `static`. That function is used to configure the formatter used to read and write the date strings. 

# Manipulating Day types

## Operators

There are a variety of functions that can be performed on `Day` types. `Day` has `+`, `-`, `+=` and `-=` operators which can be used to add or subtract a number of days from a day.

For example:

```swift
let day = Day(2000,1,1) + 5 // -> 2000-01-06 
let day = Day(2000,1,1) - 10 // -> 1999-12-21 

let day = Day(2000,1,1)
day += 5 // -> 2000-01-06 

let day = Day(2000,1,1)
day -= 5 // -> 1999-12-21
```

In addition you can also subtract one day from another to get the duration between them.

```swift
Day(2000,1,10) - Day(2000,1,5) // -> 5 days duration. 
```

# DayComponents

Similar to the way `Date` has a matching `DateComponents`, `Day` has a matching `DayComponents`. In this case mostly as a convenient wrapper for passing the individual values for a year, month and day. 

# Other Day functions

## .date(inCalendar:timeZone:) -> Date

Using a passed `Calendar` and `TimeZone`, this function coverts a `Day` to a Swift `Date` with the `Day`'s year, month and day, and a time of `00:00` (midnight). With no arguments this function uses the current calendar and time zone.

## .formatted(_:) -> String

Wrapping `Date.formatted(date:time:)` this function formats a day using the standard formatting specified by the `Date.FormatStyle.DateStyle` styles. The time component of `Date.formatted(date:time:)` is omitted.

# References and thanks

* Can't thank [Howard Hinnant](http://howardhinnant.github.io) enough. Using his math instead of Apple's APIs produced a significant speed boost when converting to and from years, months and days.  
* Quick thank you to the guys behind the excellent [Nimble test assertion framework](https://github.com/Quick/Nimble).

# Future additions

Obviously there are a large number of useful functions that can be added to this API, many of which could come from various other calculations on [http://howardhinnant.github.io/date_algorithms.html#weekday_from_days](). However I plan to add these as it becomes clear they will provide a useful addition rather than re-implementing a large number of functions that may not ben needed. 

So please feel free to drop a request for thing you'd like added.