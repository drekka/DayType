![Calendar](media/Calendar.png)
# DayType

_An API for dates and nothing else. No Calendars, no timezones, no hours, minutes or seconds. **Just dates!**._

Sure swift provides excellent date support with it's `Date`, `Calendar`, `TimeZone` and related types. But there's a catch - they're all designed to work with a specific point in time. And that's not always how people think. We never say "Hey, it's Dave's birthday on the 29th of August at 2:14 am AEST". We simply say the "… 29th of August." and everyone knows what we mean. But Apple's point in time based APIs can't handle that generalisation and that means we as developers have to strip or set time components, convert between timezones and do a whole lot of messing about. All of which is easy to get wrong and just unnecessary.

This is where `DayType` steps in.

## Installation

`DayType` is a SPM package only. So install it as you would install any other package.

# Introducing Day

DayType provides simplify date handling through a single type called `Day`.

A `Day` is a representation of a 'day' as people think of it. A 24 hours period, independent of timezones and without hours, minutes, seconds or milliseconds.

## Initialisers

A `Day` has a number of convenience initialisers. Most of which are self explanatory and similar to Swift's `Date`:

```swift
init()                                                        // Today using the default calendar and timezone.
init(daysSince1970: DayInterval)                              // Based on the number of whole days since 1970.
init(timeIntervalSince1970: TimeInterval)                     // Based on Apple's `TimeInterval`. 
init(date: Date, usingCalendar calendar: Calendar = .current) // Based on a `Date` with an optional calendar.
init(components: DayComponents)                               // From `DayComponents`.
init(year: Int, month: Int, day: Int)                         // From year, month and day values.
init(_ year: Int, _ month: Int, _ day: Int)                   // Same but a convenient short form.
```
## Properties

```swift
var daysSince1970: Int { get }
```
Literally the number of days since Swift's base date of 00:00:00 UTC on 1 January 1970. Note this is the number of whole days, dropping any spare hours, minutes or seconds.

> Note: Effectively the number of days produced if you used Apple's API like this:
> ```swift
> let fromDate = Calendar.current.startOfDay(for: Date(timeIntervalSince1970: 0))
> let toDate = Calendar.current.startOfDay(for: Date())
> let numberOfDays = Calendar.current.dateComponents([.day], from: fromDate, to: toDate).day!
> ```

## Mathematical operators

`Day` has a number of mathematical operators for manipulating days:

```swift

// Adding days
let day = Day(2000,1,1) + 5 // -> 2000-01-06 
day += 5                    // -> 2000-01-11 

// Subtracting days
let day = Day(2000,1,1) - 10 // -> 1999-12-21 
day -= 5                     // -> 1999-12-16

// Obtaining a duration in days
Day(2000,1,10) - Day(2000,1,5) // -> 5 days duration. 
```

## Functions

```swift
func date(inCalendar calendar: Calendar = .current, timeZone: TimeZone? = nil) -> Date
```

Using the passed `Calendar` and `TimeZone` this function coverts a `Day` to a Swift `Date` with the time components being set to `00:00` (midnight).

```swift
func day(byAdding component: Day.Component, value: Int) -> Day
```

Adds any number of years, months or days to a `Day` and returns a new `day`. This is convenient for doing things like producing a sequence of dates for the same day on each month. 

```swift
func formatted(_ day: Date.FormatStyle.DateStyle = .abbreviated) -> String
```

Uses Apple's `Date.formatted(date:time:)` function to format the day into a `String` using the formatting specified in `Date.FormatStyle.DateStyle`.

# DayComponents

Similar to how `Date` has `DateComponents` representing the individual parts of a date and time, `Day` has `DayComponents` which contain the day's year, month and day. Mostly this is a convenience thing for accessing particular values in a `Day`.

# Protocol conformance

## Codable

`Day` encodes and decodes to an `Int` representing the number of days since 1 January 1970. This value is also available via the `.daysSince1970` property. 

## Equatable

`Day` values can be compared for equality:

```swift
Day(2001,2,3) == Day(2001,2,3) // true
```

## Comparable

being `Comparable` enables a number of operators: `>`, `<`, `>=` and `<=` which can then be used to compare days.

## Hashable

Allows `Day` values to be used as dictionary key in in a set.

## Stridable

`Stridable` enables looping through days and the `stride(from:to:by:)` function:

```swift
for day in Day(2000,1,1) ... Day(2000,1,5) {
    // Do something with the 1st, 2nd, 3rd, 4th and 5th.
}

for day in Day(2000,1,1) ..< Day(2000,1,5) {
    // Do something with the 1st, 2nd, 3rd and 4th.
}

for day in stride(from: Day(2000,1,1), to: Day(2000,1,5), by: 2) {
    // Do something with the 1st and 3rd.
}
```

# Property wrappers

Having `Codable` support is useful for internal use, but when reading data from other sources DayType supports a variety of date styles using `Codable` property wrappers.

> Note: All of DayType's property wrappers can read and write both `Day` and optional `Day?` values.

### `@DayString.DMY`, `@DayString.MDY` & `@DayString.YMD`

These property wrappers are designed to encode and decode dates in the `dd/mm/yyyy`, `mm/dd/yyyy` and `yyyy/mm/dd` formats. For example:

```swift
struct MyData {
    @DayString.DMY var dmyDay: Day          // "31/04/2025"
    @DayString.MDY var mdyDay: Day          // "04/31/2025"
    @DayString.YMD var ymdOptionalDay: Day? // "2025/04/31"
}
```

### `@Epoch.seconds` & `@Epoch.milliseconds`

These encode and decode days as [epoch timestamps](https://www.epochconverter.com). For example:

```swift
struct MyData {
    @Epoch.Seconds var optionalSeconds: Day?  // 1746059246
    @Epoch.Milliseconds var milliseconds: Day // 1746059246123
}
```

### `@ISO8601.Default` and `@ISO8601.SansTimezone`

And finally these property wrappers encode and decode standard ISO8061 date strings.

```swift
struct MyData {
    @ISO8601.Default var iso8601: Day                    // "2025-04-31T12:01:00Z+12:00"
    @ISO8601.SansTimezone var OptionalSansTimezone: Day? // "2025-04-31T12:01:00" 
}
```

## Encoding and decoding nulls

By default all of DayType's property wrappers can handle decoding where a key is missing or has a `null` value. For example:

```swift
struct MyData {
    @DayString.DMY var dmy: Day?
}
```

Will decode a `null` value as a `nil`:

```json
{
    "dmy": null
}
```

And a missing key also as a `nil`:

```swift
{}
```     

By default when encoding, DayType will drop keys for `nil` values. In other words, producing `{}` as per the above example.

However some APIs require `null` values and in order to support those DayType provides has some additional property wrappers which write `null` values instead of dropping the keys. For example:

```swift
struct MyData {
    @DayString.DMY.Nullable var dmy: Day?
    @Epoch.Seconds.Nullable var seconds: Day?
    @ISO8601.Default.Nullable var iso8601: Day?
}
```

Writes:

```json
{
   "dmy": null,
   "seconds": null,
   "iso8601": null
}
```

# References and thanks

* Can't thank [Howard Hinnant](http://howardhinnant.github.io) enough. Using his math instead of Apple's APIs produced a significant speed boost when converting to and from years, months and days. 

# Future additions

Obviously there are a large number of useful functions that can be added to this API, many of which could come from various other calculations on [http://howardhinnant.github.io/date_algorithms.html#weekday_from_days](). However I plan to add these as it becomes clear they will provide a useful addition rather than re-implementing a large number of functions that may not be needed. 

Please feel free to drop a request for anything you'd like added.
