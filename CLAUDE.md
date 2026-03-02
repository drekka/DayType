# DayType

Swift package providing a `Day` type for date-as-day handling without time/timezone complexity.

## Build & Test

```bash
xcodebuild -scheme DayType -destination 'platform=macOS,variant=Mac Catalyst' build 2>&1 | xcbeautify
xcodebuild -scheme DayType -destination 'platform=macOS,variant=Mac Catalyst' test 2>&1 | xcbeautify
```

## Architecture

- **`Day`** — core type backed by `daysSince1970: Int`, uses Hinnant date algorithms for high-performance year/month/day math
- **`DayComponents`** — simple year/month/day struct (like `DateComponents` but for `Day`)
- **`Weekday`** — enum representing day of the week (Sun=0 through Sat=6), raw values match Hinnant's `weekday_from_days`
- **`CalendarDay`** — bundles a `Day` with pre-computed `DayComponents` for calendar grid use
- **`CalendarDays`** — typealias for `OrderedDictionary<Day, [CalendarDay]>` (from `swift-collections`), keys are week-start days; supports `+` operator to merge months with automatic boundary-week deduplication
- **`StartOfWeek`** — enum (`.sunday`, `.monday`) controlling which day begins calendar weeks
- **Property wrappers** — `@DayString`, `@Epoch`, `@ISO8601` for decoding server date formats, generated via Swift macros

## Key Patterns

- All date math is GMT-based; timezone adjustments only at `Date` conversion boundaries
- Hinnant algorithms used instead of Foundation `Calendar` for performance (see http://howardhinnant.github.io/date_algorithms.html)
- Extensions on `Day` for distinct feature areas: `Day+Weekday`, `Day+Calendar`, `Day+Operations`, `Day+Functions`, `Day+Conversions`, `Day+Formatted`
- Conformance files in `Sources/Conformance/` (Codable, Comparable, Equatable, Hashable, Stridable)
- Property wrappers in `Sources/Property wrappers/` with macro-generated implementations in `Macros/`
- Tests use Apple's `Testing` framework (`@Suite`, `@Test`, `#expect`)

## File Organisation

- One primary type per file
- Extension files named `Day+Feature.swift`
- Top-level types (`Weekday`, `CalendarDay`, `DayComponents`) get their own files in `Sources/`
