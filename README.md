![Calendar](media/Calendar.png)
# DayType

_An API for dates and nothing else. No Calendars, no timezones, no hours, minutes or seconds. **Just dates!**._

Sure swift provides excellent date support with it's `Date`, `Calendar`, `TimeZone` and related types. But there's a catch - they're all designed to work with a specific point in time. And that's not always how people think, and sometimes not even what we get from a server. 

For example we never refer to a person's birthday as being a specific point in time. We don't say "Hey, it's Dave's birthday on the 29th of August at 2:14 am AEST". We simply say the 29th of August and everyone knows what we mean. But Apple's time APIs don't have that generalisation. And that means a whole lot of coding for developers whenever we need to deal in just days'. All sorts of code stripping times, adjusting for time zones, and comparing sanitized dates. All of which is easy to get wrong if you haven't done a lot of it.

So this is where `DayType` steps it. Basically it provides simplify date handling through a `Day` type which is a representation of a 24 hours period independant of any timezone and without hours, minutes, seconds or milliseconds. In other word a date as people think of it, and that can make your code considerably simpler.

## Installation

`DayType` is a SPM package only. So install it as you would install any other package.

# Introducing Day

DayType's common type is `Day` and the DayType package has all sorts of code to read, create and manipulate these `Day` types. Most of which is modelled off Apple's APIs so that as much as possible it will seem familiar.  

## Initialisers

A `Day` has a number of convenience initialisers. Most of which are self explanatory and similar to Swift's `Date`:

```swift
init()                                                           // Creates a `Day` based on the current time.
init(daysSince1970: DayInterval)                                 // Creates a `Day` using the number of days since 1970.
init(timeIntervalSince1970: TimeInterval)                        // Creates a `Day` from a `TimeInterval`. 
init(date: Date, usingCalendar calendar: Calendar = .current)    // Creates a `Day` from a `Date` with an optional calendar.
init(components: DayComponents)                                  // Creates a `Day` from `DayComponents`.
init(_ year: Int, _ month: Int, _ day: Int)                      // Creates a `Day` from individual year, month and day values. Short form.
init(year: Int, month: Int, day: Int)                            // Creates a `Day` from individual year, month and day values.
```
## Properties

### var daysSince1970: Int { get }

Literally the number of days since Swift's base date of 00:00:00 UTC on 1 January 1970. Note this is the number of whole days, dropping any spare seconds.

> Note this effective matches the number of days produced by this API code:
> ```swift
> let fromDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 0))
> let toDate = Calendar.current.startOfDay(for: Date())
> let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
> ```

## Mathematical operators

`Day` has a number of mathematical operators for adding and subtracting days from a `Day`:

```swift

// Adding days
let day = Day(2000,1,1) + 5 // -> 2000-01-06 
day += 5 // -> 2000-01-11 

// Subtracting days
let day = Day(2000,1,1) - 10 // -> 1999-12-21 
day -= 5 // -> 1999-12-16

// Obtaining a duration in days
Day(2000,1,10) - Day(2000,1,5) // -> 5 days duration. 
```

## Functions

### func date(inCalendar calendar: Calendar = .current, timeZone: TimeZone? = nil) -> Date

Using the passed `Calendar` and `TimeZone` this function coverts a `Day` to a Swift `Date` with the time components being set to `00:00` (midnight).

### func day(byAdding component: Day.Component, value: Int) -> Day

Adds any number of years, months or days to a `Day` and returns a new `day`. This is convenient for doing things like producing a sequence of dates for the same day on each month. 

### func formatted(_ day: Date.FormatStyle.DateStyle = .abbreviated) -> String

Uses Apple's `Date.formatted(date:time:)` function to format the day into a `String` using the formatting specified in `Date.FormatStyle.DateStyle`.

# DayComponents

Similar to how `Date` has `DateComponents` representing the individual parts of a date and time, `Day` has `DayComponents` which contain the day's year, month and day. 

# Protocol conformance

## Codable

`Day` is fully `Codable`. 

When encoded or decoded it uses an `Int` representing the number of days since 1 January 1970. This value can also be accessed via the `.daysSince1970` property. 

## Equatable

`Day` is `Equatable` so days can be compared. Ie. 

```swift
Day(2001,2,3) == Day(2001,2,3) // true
```

## Comparable

`Day` is `Comparable` which enables the comparable operators: `>`, `<`, `>=` and `<=` for comparing days.

## Hashable

`Day` is also `Hashable` which allows it to be used as dictionary key in in a set.

## Stridable

`Day` is `Stridable` which means you can use it in for loops as well as with the `stride(from:to:by:)` function. For example:

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

# Property wrappers

DayType also provides a number of property wrappers which implement `Codable`, the intent being to allow easy conversions from all sorts of date formats that are often returned from servers.

All of the supplied property wrappers can read and write both `Day` and optional `Day?` properties and are grouped by the format of the data they expect to encode and decode.

## `@DayString.DMY`, `@DayString.MDY` & `@DayString.YMD`

These property wrappers are designed to encode and decode dates in the `dd/mm/yyyy`, `mm/dd/yyyy` and `yyyy/mm/dd` formats. For example:

```swift
struct MyData {
    @DayString.DMY var dmyDay: Day          // "31/04/2025"
    @DayString.MDY var mdyDay: Day          // "04/31/2025"
    @DayString.YMD var ymdOptionalDay: Day? // "2025/04/31"
}
```

## `@Epoch.seconds` & `@Epoch.milliseconds`

Encodes and decodes days as [epoch timestamps](https://www.epochconverter.com). For example:

```swift
struct MyData {
    @Epoch.Seconds var optionalSeconds: Day?  // 1746059246
    @Epoch.Milliseconds var milliseconds: Day // 1746059246123
}
```

## `@ISO8601.Default` and `@ISO8601.SansTimezone`

Encodes and decodes standard ISO8061 date strings. The only difference is that `@ISO8601.SansTimezone` is as it's name suggests, intended for reading strings written without a timezone value. For example

```swift
struct MyData {
    @ISO8601.Default var iso8601: Day                    // "2025-04-31T12:01:00Z+12:00"
    @ISO8601.SansTimezone var OptionalSansTimezone: Day? // "2025-04-31T12:01:00" 
}
```

## Encoding and decoding nulls

By default all of DayType's property wrappers can handle decoding where the passed value is a `null` or if there is no value at all. For example:

```swift
struct MyData {
    @DayString.DMY var dmy: Day?
}
```

Will read both of these JSONs, setting `dmy` to `nil`:

```json
// Null value.
{
    "dmy": null
}

// Missing value.
{}
```     

When encoding DayType will skip encoding `nil` values (so producing `{}`), however some API require `null` values. In order to handle these APIs DayType provides some nested property wrappers which will write `null` values instead of skipping the keys all together. For example:

```swift
struct MyData {
    @DayString.DMY.Nullable var dmy: Day?
    @Epoch.Seconds.Nullable var seconds: Day?
    @ISO8601.Default.Nullable var iso8601: Day?
}
```

Will write the following JSON which all the properties are `nil`:

```json
{
   "dmy": null,
   "seconds": null,
   "iso8601": null
}
```

# References and thanks

* Can't thank [Howard Hinnant](http://howardhinnant.github.io) enough. Using his math instead of Apple's APIs produced a significant speed boost when converting to and from years, months and days.  
* A second thanks to the guys behind the excellent [Nimble test assertion framework](https://github.com/Quick/Nimble) which I prefer over Apple's XCTest asserts. Sorry Apple. 

# Future additions

Obviously there are a large number of useful functions that can be added to this API, many of which could come from various other calculations on [http://howardhinnant.github.io/date_algorithms.html#weekday_from_days](). However I plan to add these as it becomes clear they will provide a useful addition rather than re-implementing a large number of functions that may not be needed. 

Please feel free to drop a request for anything you'd like added.
