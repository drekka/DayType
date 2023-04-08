# DayType

Software often has to deal with dates. Sometimes we get them as what is commonly called ['Epoch' time](https://en.wikipedia.org/wiki/Unix_time). That is, milli or micro-seconds since 1 Jan 1970. Sometimes it's one of the many [ISO8601 text representations](https://en.wikipedia.org/wiki/ISO_8601) of time. Sometimes with a timezone value, sometimes without. Sometimes it's an old legacy string from an old legacy server. Sometimes it's just a date without time or timezone. In other words there's a bazillion ways we can end up having to understand a date and time.

And Apple hasn't made it easy. 

Firstly by providing only one type to represent a point in time, then calling it `Date`. As humans think of it, a 'date' is a 24 hour period that (depending on timezone) which then 'floats' within a 48 hour period depending on the timezone. Apple's `Date` is a specific point in time, not a period of time, and is measured in seconds since January 1 1970. This means that it represents the same point regardless of any timezone. Which is why Apple's APIs require a `Calendar` to use a `Timezone` in order to convert a `Date` into a human readable form. Because people think in terms of time in their timezone, not as a point in time for the whole planet. 

For example, using the [Epoch time](https://www.epochconverter.com) (which is what Apple is doing) of 1680217800 seconds since January 1 1970, we can calculate that it is Thursday, 30 March 2023 11:10:00 PM in the GMT timezone, and Friday, 31 March 2023 10:10:00 AM in a GMT+11:00 DST timezone.

So Apple's `Date` is great for working with specific points in time, but rubbish when dealing with just dates. Sure there's a heap of functions for converting across timezones, extracting date values, measuring days between, etc. But in every case it's using specific points in time and if you are only interested in a date, not the hours and minutes, etc, then you'll find yourself having to do all sorts of stuff just to make sure that the hours,minutes and timezones don't get in the way. Mostly zeroing out time components of a date before doing any form of date related calculation.

It's a pain.

Which is why I've written DayType, to make dealing with dates easy by handling all the complex stuff for you. 

DayType introduces a new type called `Day`. I would have called it `Date` but that would clash with Apple's implementation and just confuse things. So it's called `Day` because it represents a day, without reference to any specific timezone and without any time elements. So when you want to calendar up something for the 17th August or whatever, you don't have to worry about which timezone your in or what time of day.
