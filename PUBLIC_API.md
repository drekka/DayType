# DayType — Public API Reference

> This document is the authoritative reference for AI assistants integrating DayType. It covers every public type, property, method, and key behaviour. Read this before writing any code that imports `DayType`, `DayTypeMacros`, or `DayTypeUI`.

---

## What DayType is

`Day` represents a calendar date as a 24-hour period, independent of any timezone or time of day. It is **not** a point in time — it is the generalisation that people mean when they say "the 29th of August". No hours, minutes, seconds, or timezone complexity.

Internally stored as `daysSince1970: Int` (whole days since 1 Jan 1970 UTC). All date math uses Hinnant algorithms for performance — Foundation's `Calendar` is used only when converting to/from `Date`.

---

## Package products

| Product | Import | What it contains |
|---------|--------|-----------------|
| `DayType` | `import DayType` | Core `Day` type, `DayComponents`, `Weekday`, `CalendarDay`, `CalendarDays`, `DayError` |
| `DayTypeMacros` | `import DayTypeMacros` | Property wrapper macros (usually used indirectly via the wrappers below) |
| `DayTypeUI` | `import DayTypeUI` | SwiftUI components: `CalendarGrid`, `CalendarPicker` |

---

## Quick-start

```swift
import DayType

// Create days
let today = Day()                          // today
let today = Day.today                      // same thing
let birthday = try Day(1990, 8, 29)        // 29 Aug 1990
let xmas = try Day(year: 2026, month: 12, day: 25)

// Arithmetic
let nextWeek = today + 7
let yesterday = today - 1
let nights = checkOut - checkIn           // Int: number of days between

// Components
let comps = birthday.dayComponents        // DayComponents(year: 1990, month: 8, dayOfMonth: 29)
let weekday = birthday.weekday            // Weekday.wednesday

// Convert back to Foundation
let date = birthday.date()                // Date at midnight in .current calendar
let formatted = birthday.formatted()      // e.g. "Aug 29, 1990"
```

---

## Core type: `Day`

```swift
public struct Day: Codable, Equatable, Comparable, Hashable, Strideable
```

### Stored property

```swift
public let daysSince1970: Int
```

The sole stored value. Whole days since 1 Jan 1970 UTC. Use this when sorting `Day` values in SwiftData `@Query` — see the [SwiftData note](#swiftdata).

### Static helpers

```swift
public static var today: Day                               // Day representing today
public static func isLeapYear(_ year: Int) -> Bool
public static func daysInMonth(_ month: Int, year: Int) -> Int
public static func daysInYear(_ year: Int) -> Int
```

### Initialisers

| Init | Throws | Notes |
|------|--------|-------|
| `init()` | no | Today's date |
| `init(daysSince1970: DayInterval)` | no | Raw days-since-epoch value |
| `init(timeIntervalSince1970: TimeInterval)` | no | Truncates to whole days |
| `init(date: Date, usingCalendar calendar: Calendar = .current)` | no | Extracts year/month/day from the `Date` using the given calendar |
| `init(_ dayComponents: DayComponents) throws` | yes | Validates ranges |
| `init(_ year: Int, _ month: Int, _ day: Int) throws` | yes | Short-form; validates ranges |
| `init(year: Int, month: Int, day: Int) throws` | yes | Named params; validates ranges |

**Validation:** month must be 1–12; day must be 1–`daysInMonth`. Throws `DayError` otherwise.

```swift
let d = try Day(2026, 13, 1)  // throws DayError.monthOutOfRange(month: 13)
let d = try Day(2026, 2, 30)  // throws DayError.dayOutOfRange(day: 30, month: 2, year: 2026)
```

### Computed properties

```swift
public var dayComponents: DayComponents   // year, month, dayOfMonth — computed via Hinnant algorithm
public var weekday: Weekday               // .sunday … .saturday
```

### Arithmetic operators

```swift
Day + Int  -> Day    // add days
Day - Int  -> Day    // subtract days
Day - Day  -> Int    // difference in days (can be negative)
Day += Int           // mutating add
Day -= Int           // mutating subtract
```

### Instance methods

```swift
// Add years, months, or days with month-end clamping
func day(byAdding component: Day.Component, value: Int) -> Day
```

`Day.Component` cases: `.year`, `.month`, `.day`.

Month-end clamping: `try Day(2026, 1, 31).day(byAdding: .month, value: 1)` → `2026-02-28` (not an error).

```swift
// Convert to Foundation Date
func date(inCalendar calendar: Calendar = .current, timeZone: TimeZone? = nil) -> Date

// Format as a localised date string
func formatted(_ day: Date.FormatStyle.DateStyle = .abbreviated) -> String
```

### Calendar grid generation

```swift
// Instance method — month containing this day
func calendarMonth(startingOn startOfWeek: StartOfWeek = .sunday) -> CalendarDays

// Static convenience
static func calendarMonth(containing day: Day = .today, startingOn startOfWeek: StartOfWeek = .sunday) -> CalendarDays
```

Returns a `CalendarDays` (see below) covering the full month. The first and last week rows may include padding days from adjacent months to complete 7-day rows.

### Strideable

`Day` is `Strideable`, so you can use it in ranges and `stride`:

```swift
for day in try Day(2026, 1, 1) ... Day(2026, 1, 5) { … }   // closed range, 5 days
for day in try Day(2026, 1, 1) ..< Day(2026, 1, 5) { … }   // half-open, 4 days
for day in stride(from: try Day(2026, 1, 1), to: try Day(2026, 1, 10), by: 2) { … }
```

### Codable

Encodes and decodes as a single `Int` (`daysSince1970`). Not an ISO string — use the property wrappers below when a specific wire format is needed.

---

## `DayComponents`

```swift
public struct DayComponents: Equatable, Hashable
```

A simple snapshot of year, month, and day-of-month.

```swift
public let year: Int
public let month: Int
public let dayOfMonth: Int

public init(year: Int, month: Int, dayOfMonth: Int)
public func day() throws -> Day   // converts back to Day; throws DayError if invalid
```

Obtain from `Day.dayComponents`. Do not compute `Day` from components in a tight loop — prefer `Day` arithmetic instead.

---

## `DayError`

```swift
public enum DayError: Error, Equatable {
    case monthOutOfRange(month: Int)
    case dayOutOfRange(day: Int, month: Int, year: Int)
}
```

Thrown by any `Day` initialiser that accepts year/month/day components. Conforms to `Equatable` for use in test assertions.

---

## `Weekday`

```swift
public enum Weekday: Int, CaseIterable, Sendable {
    case sunday    = 0
    case monday    = 1
    case tuesday   = 2
    case wednesday = 3
    case thursday  = 4
    case friday    = 5
    case saturday  = 6
}
```

Raw values match Hinnant's `weekday_from_days` output. Obtained via `day.weekday`.

---

## `StartOfWeek`

```swift
public enum StartOfWeek: Sendable {
    case sunday
    case monday
}
```

Controls which column is first in calendar grid rows. Passed to `calendarMonth(startingOn:)`.

---

## `CalendarDay`

```swift
public struct CalendarDay: Hashable, Equatable, Identifiable
```

A single cell in a calendar grid, pairing a `Day` with its pre-computed `DayComponents`.

```swift
public let day: Day
public let dayComponents: DayComponents
public var id: Day { day }

public init(day: Day)
```

---

## `CalendarDays`

```swift
public typealias CalendarDays = OrderedDictionary<Day, [CalendarDay]>
```

The data structure for calendar UI. Keys are the week-start `Day` (Sunday or Monday, depending on `startOfWeek`). Values are 7-element `[CalendarDay]` arrays for that week, in order.

**Key invariant:** `OrderedDictionary` maintains insertion order, **not** sorted order. The merge operators below explicitly sort by key to guarantee chronological order after every merge.

### Merge operators

```swift
CalendarDays + CalendarDays  -> CalendarDays    // merge, deduplicate boundary weeks, sort
CalendarDays += CalendarDays                    // mutating merge
```

When two dictionaries share a key (boundary weeks overlap between months), the **left-hand side** entry is kept.

```swift
let march = try Day(2026, 3, 15).calendarMonth(startingOn: .monday)
let april = try Day(2026, 4, 2).calendarMonth(startingOn: .monday)
let twoMonths = march + april
```

---

## `DayInterval`

```swift
public typealias DayInterval = Int
```

Alias used in `Day.init(daysSince1970:)` for readability.

---

## Property wrappers (server date decoding)

All wrappers support both `Day` and `Day?`. On decode, missing JSON keys and `null` values both map to `nil` for optional properties. On encode, `nil` values skip the key by default — use the `.Nullable` variant to write explicit `null`.

### `@DayString`

Decodes/encodes slash-separated date strings.

| Wrapper | Wire format |
|---------|-------------|
| `@DayString.DMY` | `"30/04/2025"` |
| `@DayString.MDY` | `"04/30/2025"` |
| `@DayString.YMD` | `"2025-04-30"` |

```swift
struct MyData: Codable {
    @DayString.DMY var arrival: Day
    @DayString.YMD var departure: Day?
}
```

### `@Epoch`

Decodes/encodes Unix timestamps.

| Wrapper | Wire format |
|---------|-------------|
| `@Epoch.Seconds` | `1746059246` |
| `@Epoch.Milliseconds` | `1746059246123` |

```swift
struct MyData: Codable {
    @Epoch.Seconds var eventDate: Day
    @Epoch.Milliseconds var updatedAt: Day?
}
```

### `@ISO8601`

Decodes/encodes ISO 8601 datetime strings. Time component is stripped; only the date part is kept.

| Wrapper | Wire format |
|---------|-------------|
| `@ISO8601.Default` | `"2025-04-30T12:01:00Z"` |
| `@ISO8601.SansTimezone` | `"2025-04-30T12:01:00"` |

```swift
struct MyData: Codable {
    @ISO8601.Default var createdAt: Day
    @ISO8601.SansTimezone var updatedAt: Day?
}
```

### Writing explicit `null` on encode

Append `.Nullable` to any wrapper to encode `nil` as `null` instead of omitting the key:

```swift
struct MyData: Codable {
    @DayString.DMY.Nullable var dmy: Day?       // encodes as { "dmy": null }
    @Epoch.Seconds.Nullable var seconds: Day?   // encodes as { "seconds": null }
    @ISO8601.Default.Nullable var iso: Day?     // encodes as { "iso": null }
}
```

---

## SwiftData

`Day` works as a SwiftData `@Model` property. However, `@Query` sort descriptors using a `Day` key path fail because SwiftData flattens the struct and loses the property name. Use `daysSince1970` explicitly:

```swift
// WRONG — SwiftData can't resolve the key path
@Query(sort: \Holiday.startDate) var holidays: [Holiday]

// CORRECT
@Query(sort: \Holiday.startDate.daysSince1970) var holidays: [Holiday]
```

---

## UI components (`DayTypeUI`)

```swift
import DayTypeUI   // also re-exports DayType
```

No internal padding on any component — the consuming view decides all padding and spacing.

### `CalendarGrid`

```swift
public struct CalendarGrid: View
```

An infinitely-scrolling calendar grid. Renders weeks as 7-cell rows. Supports single-day and date-range selection. Pre-generates 10 years of history and 1 year forward; extends lazily as the user scrolls.

**Width** is always `7 * cellSize`. **Height** is either `visibleRows * cellSize` (when `visibleRows` is set) or measured from available space.

**Selection model (range mode):**
- Tap any day outside the selection → starts a new selection from that day.
- Tap the start or end date → enters adjust mode for that endpoint.
- Tap a second time → commits the endpoint.
- On Mac Catalyst, pointer hover previews the moving endpoint live.

```swift
public enum Mode {
    case single
    case range
}
```

**Single-day init:**

```swift
public init(
    selection: Binding<Day>,
    cellSize: CGFloat = 56,
    visibleRows: Int? = nil,
    scrollTo: Binding<Day?> = .constant(nil)
)
```

**Range init:**

```swift
public init(
    start: Binding<Day>,
    end: Binding<Day>,
    cellSize: CGFloat = 56,
    visibleRows: Int? = nil,
    scrollTo: Binding<Day?> = .constant(nil)
)
```

| Parameter | Notes |
|-----------|-------|
| `selection` / `start` / `end` | Two-way bindings. The grid writes the selected day(s) back immediately on each tap. |
| `cellSize` | Square size of each day cell in points. Default `56`. |
| `visibleRows` | Fixed row count. When `nil`, the grid measures its container height and fills it. |
| `scrollTo` | Set to a `Day` to programmatically animate-scroll to that day. The grid resets the binding to `nil` after scrolling. |

**Example:**

```swift
@State private var selected = Day.today
@State private var scrollTarget: Day? = nil

CalendarGrid(selection: $selected, visibleRows: 6, scrollTo: $scrollTarget)
    .padding()

// Programmatic scroll
Button("Go to today") { scrollTarget = .today }
```

---

### `CalendarPicker`

```swift
public struct CalendarPicker: View
```

A higher-level wrapper around `CalendarGrid` that adds:
- An optional title label.
- A tappable date header (single mode: the selected date; range mode: "From [date] to [date]"). Tapping a date scrolls the grid back to it.
- A days/nights summary label below the header (range mode only).

Always renders `CalendarGrid` with `visibleRows: 6`.

**Single-day init:**

```swift
public init(title: String? = nil, selection: Binding<Day>)
```

**Range init:**

```swift
public init(title: String? = nil, start: Binding<Day>, end: Binding<Day>)
```

**Example:**

```swift
@State private var checkIn = Day.today
@State private var checkOut = Day.today + 7

CalendarPicker(title: "Select dates", start: $checkIn, end: $checkOut)
    .padding()
    .presentationDetents([.medium, .large])
```

---

## Key invariants

- **`Day` is timezone-free.** There are no timezone semantics stored on a `Day`. Conversion to `Date` via `.date(inCalendar:timeZone:)` is the only place timezones enter — and that's the caller's responsibility.
- **Throwing inits validate eagerly.** Pass invalid month/day values and you get a `DayError` immediately, not a corrupted value.
- **`day(byAdding:)` clamps, never throws.** Adding months or years to a day at month-end silently clamps (Jan 31 + 1 month = Feb 28). For `.day` arithmetic, use the `+`/`-` operators instead — they're equivalent and clearer.
- **`CalendarDays` must be sorted after merging.** The `+`/`+=` operators do this automatically. If you build a `CalendarDays` dictionary by hand (e.g. with direct dictionary subscript), call `.sort { $0.key < $1.key }` before use.
- **`CalendarGrid` width is fixed.** The view always frames itself at `7 * cellSize`. If you need a specific width, set `cellSize` accordingly — don't constrain the grid externally.
- **Codable encodes as `Int`, not a string.** A `Day` round-tripped through `JSONEncoder`/`JSONDecoder` uses its `daysSince1970` integer value. If your server sends a string or timestamp, use the property wrappers.
