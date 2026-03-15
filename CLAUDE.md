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

- No internal padding on any component — consuming views decide their own spacing
- **`DayCell`** (internal) — single calendar day cell with 6 highlight states (`none`, `range`, `rangeStart`, `rangeEnd`, `selectedStart`, `selectedEnd`), pulsing animation for selected endpoints, month label on day 1, even/odd month tinting, and `onTapped` callback
- **`CalendarGrid`** — scrolling calendar grid with single-day and date-range selection modes:
  - Layout: `ScrollView` → `LazyVStack` → `ForEach` week rows → `HStack` of 7 `DayCell`s
  - Scroll position tracked via `scrollPosition(id: $visibleWeek)` with `.scrollTargetBehavior(.viewAligned)` for snap-to-row
  - Explicit `.frame(height: cellSize)` on each row so LazyVStack knows unrealized row heights
  - Pre-generates 10 years backward + 1 year forward on init; appends forward on demand
  - **Backward extension**: inserting items above the viewport in a live LazyVStack with `scrollPosition(id:)` causes unrecoverable position jumps — workaround is to show a spinner overlay, merge new data, then force a new ScrollView via `.id(scrollViewID)` so SwiftUI creates a fresh instance positioned at the trigger week
  - Year labels (top-leading, bottom-trailing) derived from `visibleWeek`
  - Programmatic scroll-to-day via optional `scrollTo: Binding<Day?>`
  - Haptic feedback on scroll snap via `.sensoryFeedback(.selection, trigger: visibleWeek)`
  - Selection state machine: `idle` → `newSelection`/`adjustingStart`/`adjustingEnd` → `idle`
  - Mac Catalyst: `.onContinuousHover` provides live preview of moving endpoint during selection
  - Touch devices: tap-only selection (no drag gestures — they conflict with scroll)
  - Self-sizing: width always `7 * cellSize`; height from optional `visibleRows` parameter or measured from available space via GeometryReader
- **`CalendarPicker`** — thin wrapper around `CalendarGrid` with title, tappable date header (scrolls grid to tapped date), and days/nights summary for range mode

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
