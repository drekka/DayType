# Future Feature Suggestions

Ideas for extending DayType, roughly prioritised.

## High value, low effort

### Relative queries
One-liner computed properties on `Day`:
- `.isToday`, `.isPast`, `.isFuture`
- `.isYesterday`, `.isTomorrow`

### Period boundaries
Computed properties and methods on `Day`:
- `.startOfMonth`, `.endOfMonth`
- `.startOfYear`, `.endOfYear`
- `.startOfWeek(startingOn:)`, `.endOfWeek(startingOn:)`

### Weekday navigation
Methods on `Day`:
- `.next(_ weekday: Weekday)` — next occurrence of a given weekday
- `.previous(_ weekday: Weekday)` — previous occurrence
- `includingToday:` parameter variant — return self if already that weekday

## Medium value, medium effort

### Day range helpers
Leverage `Strideable` conformance but add convenience:
- `Day.allDays(inMonth:year:)` — all days in a given month
- `Day.allDays(inYear:)` — all days in a given year

### Nth weekday of month
- `Day.nthWeekday(_ n: Int, _ weekday: Weekday, inMonth: Int, year: Int)` — e.g. second Tuesday of March 2026
- Common for recurring event schedules

### Named difference methods
- `day.daysUntil(_ other: Day)` / `day.daysSince(_ other: Day)`
- Subtraction operator already works, but named methods read better in business logic

## Nice to have

### Business day support
- `.nextBusinessDay` / `.previousBusinessDay`
- `.addingBusinessDays(_ count: Int)`
- Weekends only — public holidays are locale-dependent and out of scope

### Quarter support
- `.quarter` computed property (1-4)
- `.startOfQuarter`, `.endOfQuarter`
