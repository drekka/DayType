# DayType

DayType allows you to deal with dates in Swift without the time and time zone overheads that come with Swifrt's `Date` type.

Software often needs to deal with dates. For example, a date of birth or the day someone started a job. This is how people think. Whilst a lot of things need to be specified down to the second or even finer, humans often only think and refer to something in terms of the relevant date. 

The problem though is that Swift's `Date` type refers to a specific point in time, not a generalised date. So it forces you to deal with hours, minutes and seconds every time you want to perform any date related functionality regardless of whether they're relevant or not. Even when doing something as simply as comparing two dates to see if they are the same. You have to write code to ignore the time elements micro-seconds and then make sure you use the same time zone and calendar. This disconnect between the concept of a date as we think of it and Swift's point in time `Date` can cause a whole range of problems any time we need to compare, calculate or otherwise manipulate them.

DayType addresses this issue by using all the same math behind Swift's `Date`, but only to the resolution of a single day. It does this by introducing a new `Day` type. It would make more sense to call it `Date` but that would get confusing so it's called `Day`. `Calendar` and `TimeZone` are still used when dealing with `Day` types, but only when converting to or from things like epoch times and Swift's `Date` type. Pure `Day` related functionality neither needs or uses these types.



