![Calendar](media/Calendar.png)
# DayType

_An API for dates and nothing else. No Calendars, timezones, hours, minutes or seconds. Just dates._

Swift provides excellent date support through it's `Date`, `Calendar`, `TimeZone` and other types. However there's a catch, they're all designed to work with specific points in time. Not the generalisations that people often use. 

For example, you cannot just refer to a person's birthday date without anchoring it to a specific time. In a specific timezone. But people don't consider that and they often don't even know. Just referring to the date in whatever timezone they are in. The same goes for a variety of other dates. Employment leave, religious holidays, retail sales, festivals, etc. All often referred to by date only.

As a result developers often find themselves stripping the time and timezone components from Swift's `Date`. Often with mixed results as there are a number of complexities to consider when coercing a point in time to a generalisation. Especially when considering time zones and often questionable input from external sources.

`DayType` provides simplify date handling through a new type called `Day`. That being a representation of a 24 hours period which is indenpendant of any timezone and not anchored to a specific point in time. ie. there's no hours, minutes, timezones, etc. This allows date code to be simpler because as a developer you no longer needs to sanitise or adjust time components. which alleviates the angst of accidental bugs as well as making the code considerably simpler.

## Installation

`DayType` is a SPM package only.

# Day

The common type you'll use is `Day`. 

## Initialisers

`Day` has a number of convenience initialisers which are pretty self explanatory and similar to Swift's `Date` initialisers:

```swift
init()
init(daysSince1970: DayInterval)
init(timeIntervalSince1970: TimeInterval)
init(date: Date, usingCalendar calendar: Calendar = .current)
init(components: DayComponents)
init(_ year: Int, _ month: Int, _ day: Int)
init(year: Int, month: Int, day: Int) 
```
## Properties

### .daysSince1970

Literally the number of days since Swift's base date of 00:00:00 UTC on 1 January 1970. 

_Note that matches the number of days produced by this Apple API based code:_

```swift
let fromDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 0))
let toDate = Calendar.current.startOfDay(for: Date())
let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
```

# Property wrappers 

DayType's property wrappers are designed to address the mostly commonly seen issues when coding and decoding data from external sources. 

_Note: Whilst all of these wrappers support both `Day` and `Day?` properties through the use of the `DayCodable` protocol, it's also technically possible to apply this protocol to other types to make them convertible to a `Day`._

## @EpochSeconds

Converts [epoch timestamps](https://www.epochconverter.com) to `Day`. For example the JSON data structure:

```json
{
  "dob":856616400
}
```

Can be read by:

```swift
struct MyType: Codable {
  @EpochSeconds var dob: Day // or Day?
}
```

## @EpochMilliseconds

Essentially the same as `@EpochSeconds` but expects the epoch time to be in millisecond [epoch timestamps](https://www.epochconverter.com).

```json
{
  "dob":856616400123
}
```

Can be read by:

```swift
struct MyType: Codable {
  @EpochMilliseconds var dob: Day // or Day?
}
```

## @ISO8601

Converts [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) date strings to `Day`.

```json
{
  "dob": "1997-02-22T13:00:00+11:00"
}
```

Can be read by:

```swift
struct MyType: Codable {
  @ISO8601 var dob: Day // or Day?
}
```

## @CustomISO8601<T, Configurator>

Where `T: DayCodable` and `Configurator: ISO8601Configurator`. 

Internally `DayType` uses an `ISO8601DateFormatter` to read and write [ISO8601](https://en.wikipedia.org/wiki/ISO_8601) strings. As there are a variety of ISO8601 formats, this property wrapper allows you to pre-configure the formatter before it processes the string.

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
  @CustomISO8601<Day, MinimalFormat> var dob: Day
  // or ...
  @CustomISO8601<Day?, MinimalFormat> var dob: Day?
}
```

The property wrapper is configured trough a `ISO8601Configurator` protocol instance. There's only one function so implementing the protocol is pretty easy.

_Note that because Swift does not current support specifying a default type for a generic argument, `@CustomISO8601<T, Configurator>` requires you to specify the `DayCodable` type (`Day` or `Day?`) which must match the type of the property._

### Supplied ISO8601 configurators

#### ISO8601Config.Default

This configurator does not change the formatter. It's main purpose is to support the `@ISO8601` property wrapper.

#### ISO8601Config.SansTimeZone

This configurator is for the common situation where the ISO8601 string does not have the time zone specified. For example `"1997-02-22T13:00:00"`.

## @DateString<T, Configurator>

Where `T: DayCodable` and `Configurator: DateStringConfigurator`. 

This property wrapper handles dates stored as strings. It makes use of a custom configurator to specify the format of the date string with a number of common formats supplied.

```json
{
  "dob": "2012-12-02"
}
```

Can be read by:

```swift
struct MyType: Codable {
  @DateString<Day, DateStringConfig.DMY> var dob: Day
  // or ...
  @DateString<Day?, DateStringConfig.DMY> var dob: Day?
}
```

The `DateStringConfigurator` protocol specifies only a single function which is  `static`. That function is used to configure the formatter used to read and write the date strings. 


_Note: Because Swift does not current support specifying a default type for a generic argument, `@DateString<T, Configurator>` requires you to specify the `DayCodable` type (`Day` or `Day?`)._

### Supplied date string configurators

#### DateStringConfig.ISO

Reads date strings that follow the ISO8601 format but don't have any time components. ie. `2012-12-01'

#### DateStringConfig.DMY

Reads date strings using the `dd/MM/yyyy` date format. ie. `01/12/2012'

#### DateStringConfig.MDY

Reads date strings using the `MM/dd/yyyy` date format. ie. `12/01/2012'

# Manipulating Day types

`Day` has also been extended to support a variety of functions and operators. it has `+`, `-`, `+=` and `-=` operators which can be used to add or subtract a number of days from a day.

```swift
let day = Day(2000,1,1) + 5 // -> 2000-01-06 
let day = Day(2000,1,1) - 10 // -> 1999-12-21 

let day = Day(2000,1,1)
day += 5 // -> 2000-01-06 

let day = Day(2000,1,1)
day -= 5 // -> 1999-12-21
```

And you can subtract one day from another to get the duration between them.

```swift
Day(2000,1,10) - Day(2000,1,5) // -> 5 days duration. 
```

## Functions

### .date(inCalendar:timeZone:) -> Date

Using a passed `Calendar` and `TimeZone`, this function coverts a `Day` to a Swift `Date` with the `Day`'s year, month and day, and a time of `00:00` (midnight). With no arguments this function uses the current calendar and time zone.

### .day(byAdding:, value:) -> Day

Lets you add any number of years, months or days to a `Day` and get a new `day` back. This is convenient for doing things like producing a sequence of dates for the same day on each month. 

### .formatted(_:) -> String

Wrapping `Date.formatted(date:time:)` this function formats a day using the standard formatting specified by the `Date.FormatStyle.DateStyle` styles. The time component of `Date.formatted(date:time:)` is omitted.

# DayComponents

Similar to the way `Date` has a matching `DateComponents`, `Day` has a matching `DayComponents`. In this case mostly as a convenient wrapper for passing the individual values for a year, month and day. 

# Protocol conformance

## Codable

`Day` is fully `Codable`. 

It's base value is an `Int` representing the number of days since 1 January 1970 which can accessed via the `.daysSince1970` property. 


## Equatable

`Day` is `Equatable` so 

```swift
Day(2001,2,3) == Day(2001,2,3) // true
```

## Comparable

`Day` is `Comparable` which lets you use all the comparable operators to compare dates. ie. `>`, `<`, `>=` and `<=`. 

## Hashable

`Day` is `Hashable` so it can be used as dictionary keys and in sets.

## Stridable

`Day` is `Stridable` which means you can use it in for loops as well as with the `stride(from:to:by:)` function.

```swift
for day in Day(2000,1,1)...Day(2000,1,5) {
    /// do something with the 1st, 2nd, 3rd, 4th and 5th.
}

for day in Day(2000,1,1)..<Day(2000,1,5) {
    /// do something with the 1st, 2nd, 3rd and 4th.
}

for day in stride(from: Day(2000,1,1), to: Day(2000,1,5), by: 2) {
    /// do something with the 1st and 3rd.
}
```

# References and thanks

* Can't thank [Howard Hinnant](http://howardhinnant.github.io) enough. Using his math instead of Apple's APIs produced a significant speed boost when converting to and from years, months and days.  
* A second thanks to the guys behind the excellent [Nimble test assertion framework](https://github.com/Quick/Nimble) which I prefer over Apple's XCTest asserts. Sorry Apple. 

# Future additions

Obviously there are a large number of useful functions that can be added to this API, many of which could come from various other calculations on [http://howardhinnant.github.io/date_algorithms.html#weekday_from_days](). However I plan to add these as it becomes clear they will provide a useful addition rather than re-implementing a large number of functions that may not ben needed. 

Please feel free to drop a request for any thing you'd like added.
