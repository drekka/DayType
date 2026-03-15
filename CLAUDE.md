# DayType

Swift package providing a `Day` type for date-as-day handling without time/timezone complexity, plus a `DayTypeUI` product for SwiftUI calendar components.

## Build & Test

```bash
xcodebuild -scheme DayType -destination 'platform=macOS,variant=Mac Catalyst' build 2>&1 | xcbeautify
xcodebuild -scheme DayType -destination 'platform=macOS,variant=Mac Catalyst' test 2>&1 | xcbeautify
```

## Products

- **`DayType`** — core API library (target: `DayType`, sources: `Sources/api/`)
- **`DayTypeMacros`** — property wrapper macros (targets: `DayTypeMacros` + `DayTypeMacroImplementations`, sources: `Sources/macros/`)
- **`DayTypeUI`** — SwiftUI calendar components (target: `DayTypeUI`, sources: `Sources/ui/`)

## Architecture

### Core API (`DayType`)

- **`Day`** — core type with single stored property `daysSince1970: Int`. Uses Hinnant date algorithms for high-performance date math. The `init(year:month:day:)` is throwing — validates month (1–12) and day (1–daysInMonth) ranges, throwing `DayError` on invalid inputs
- **`DayComponents`** — struct containing `year`, `month`, `dayOfMonth` properties (Equatable, Hashable). Accessed via `Day.dayComponents` computed property (Hinnant reverse algorithm). Kept as computed to avoid SwiftData struct decomposition issues
- **`DayError`** — error enum with `.monthOutOfRange(month:)` and `.dayOutOfRange(day:month:year:)` cases
- **`Weekday`** — enum representing day of the week (Sun=0 through Sat=6), raw values match Hinnant's `weekday_from_days`
- **`CalendarDay`** — struct combining a `Day` with its pre-computed `DayComponents` (Hashable, Equatable, Identifiable), used as calendar grid entries
- **`CalendarDays`** — typealias for `OrderedDictionary<Day, [CalendarDay]>` (from `swift-collections`), keys are week-start days, values are `CalendarDay` arrays; `+`/`+=` operators merge months with boundary-week deduplication and sort by key to maintain chronological order
- **`StartOfWeek`** — enum (`.sunday`, `.monday`) controlling which day begins calendar weeks
- **Property wrappers** — `@DayString`, `@Epoch`, `@ISO8601` for decoding server date formats, generated via Swift macros

### UI Components (`DayTypeUI`)

- **`DayCell`** — single calendar day cell view with 6 highlight states (`none`, `range`, `rangeStart`, `rangeEnd`, `selectedStart`, `selectedEnd`), pulsing animation for selected endpoints, month label on day 1, even/odd month tinting, and `onTapped` callback
- **`CalendarGrid`** — scrolling calendar grid with single-day and date-range selection modes:
  - Layout: `ScrollViewReader` → `ScrollView` → `LazyVStack` → `ForEach` week rows → `HStack` of 7 `DayCell`s
  - Infinite scrolling: lazy-loads ±6 months when edge rows appear
  - Selection state machine: `idle` → `newSelection`/`adjustingStart`/`adjustingEnd` → `idle`
  - Mac Catalyst: `.onContinuousHover` provides live preview of moving endpoint during selection
  - Touch devices: tap-only selection (no drag gestures — they conflict with scroll)
  - Scroll-to-start on appear via `ScrollViewReader.scrollTo()`
- **`CalendarPicker`** — reference code from Worldly project, kept for now

## Key Patterns

- All date math is GMT-based; timezone adjustments only at `Date` conversion boundaries
- Hinnant algorithms used instead of Foundation `Calendar` for performance (see http://howardhinnant.github.io/date_algorithms.html)
- `day(byAdding:value:)` uses truncating modular arithmetic for `.month` and `.year` (clamping day to end of shorter months), and direct `daysSince1970` arithmetic for `.day`
- Static helpers: `Day.isLeapYear(_:)`, `Day.daysInMonth(_:year:)`, `Day.daysInYear(_:)`
- Extensions on `Day` for distinct feature areas: `Day+Weekday`, `Day+Calendar`, `Day+Operations`, `Day+Functions`, `Day+Conversions`, `Day+Formatted`
- Conformance files in `Sources/api/Conformance/` (Codable, Comparable, Equatable, Hashable, Stridable)
- Property wrappers in `Sources/api/Property wrappers/` with macro-generated implementations in `Sources/macros/`
- `CalendarDays` merge operators always sort by key after merging — `OrderedDictionary` maintains insertion order, not sorted order, so explicit sorting is required for chronological guarantees
- Tests use Apple's `Testing` framework (`@Suite`, `@Test`, `#expect`)

## File Organisation

- `Sources/api/` — DayType core API
- `Sources/ui/` — DayTypeUI SwiftUI components
- `Sources/macros/` — macro declarations (`Module/`) and implementations (`Implementations/`)
- `Tests/api/` — DayType tests
- `Tests/ui/` — DayTypeUI tests
- One primary type per file
- Extension files named `Day+Feature.swift`
- Top-level types (`Weekday`, `StartOfWeek`) get their own files
