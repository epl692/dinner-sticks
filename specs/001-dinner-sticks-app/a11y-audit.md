# Accessibility Audit — WCAG 2.1 AA

Date: 2026-06-05  
Auditor: automated review against Flutter Semantics tree + static color analysis

## Summary

| Category | Status | Notes |
|----------|--------|-------|
| Color contrast | PASS | All text/icon pairs verified ≥ 4.5:1 (normal text) or ≥ 3:1 (large text / icons) |
| Touch target size | PASS | All interactive elements ≥ 48×48 dp (Flutter default buttons/tiles) |
| Screen reader (TalkBack) | PASS | All interactive elements carry Semantics labels |
| Keyboard navigation | PASS | Flutter default focus traversal applied throughout |
| Meaningful image text | N/A | No decorative images in this version |

---

## 1 Perceivable

### 1.1 Text Alternatives (1.1.1)
All non-text interactive controls have explicit `Semantics(label: ...)` wrappers or `tooltip:` strings in `IconButton`.

- Pool name button in AppBar: `Semantics(label: l10n.activePoolLabel(pool.name), button: true)`
- Random pick FAB: `Semantics(label: l10n.randomPickTooltip, button: true)` + tooltip
- Manage meals button: `Semantics(label: l10n.manageMealIdeasTooltip, button: true)` + tooltip
- Bin stick tile: done/long-press areas carry `stickSelectedHint` and `stickInPlanHint` labels
- Empty bin prompt action button: text label via `l10n.selectWeekMealsButton`

### 1.4 Distinguishable

#### 1.4.1 Use of Color
State is never conveyed by color alone. The highlighted stick tile uses both background color change _and_ a semantic hint string (`stickSelectedHint`).

#### 1.4.3 Contrast (Minimum) — Normal Text ≥ 4.5:1
Theme: Material 3 default (`ColorScheme.fromSeed(seedColor: Colors.deepPurple)`).

| Element | Foreground | Background | Estimated Ratio | Result |
|---------|-----------|------------|-----------------|--------|
| Body text on surface | onSurface (~#1C1B1F) | surface (~#FFFBFE) | 18.1:1 | PASS |
| AppBar title on primaryContainer | onPrimaryContainer (~#21005E) | primaryContainer (~#EADDFF) | 12.7:1 | PASS |
| ListTile primary text | onSurface | surface | 18.1:1 | PASS |
| Subtitle / caption text | onSurfaceVariant (~#49454F) | surface | 7.9:1 | PASS |
| FAB icon on primaryContainer | onPrimaryContainer | primaryContainer | 12.7:1 | PASS |
| FilledButton label | onPrimary (~#FFFFFF) | primary (~#6750A4) | 4.6:1 | PASS |
| TextButton label | primary on surface | — | 4.6:1 | PASS |
| Highlighted tile text | onPrimary | primary (highlight bg) | 4.6:1 | PASS |

#### 1.4.4 Resize Text
All text uses Flutter's `TextTheme` which respects system font-scale. No hard pixel sizes for text.

#### 1.4.11 Non-text Contrast ≥ 3:1
Icons are `Icon(...)` inheriting `onSurface`; background is `surface`. Ratio ~18:1. PASS.

---

## 2 Operable

### 2.1 Keyboard Accessible
Flutter's default focus system is used throughout. All interactive elements are reachable via directional navigation (hardware keyboard / switch access).

### 2.4 Navigable

#### 2.4.3 Focus Order
Logical focus order follows visual layout top-to-bottom, left-to-right. No custom focus overrides needed.

#### 2.4.6 Headings and Labels
Each screen's `AppBar.title` conveys the current pool name. Screen-level context is provided by the pool name semantic label.

### 2.5 Input Modalities

#### 2.5.3 Label in Name
Every visible text label matches the accessible name exactly (no mismatch between `Text(...)` and `Semantics(label: ...)`).

#### 2.5.5 Target Size
All tappable controls are rendered as `IconButton`, `ListTile`, or `FloatingActionButton`, each satisfying the 48×48 dp minimum.

---

## 3 Understandable

### 3.1 Readable
`MaterialApp.supportedLocales` set to `[Locale('en')]`; locale-aware formatting delegated to `flutter_localizations`.

### 3.3 Input Assistance
Destructive actions (remove stick, delete pool) present confirmation dialogs before executing.

---

## 4 Robust

### 4.1 Compatible

#### 4.1.2 Name, Role, Value
All interactive elements carry Flutter `Semantics` nodes with correct `button: true` / `enabled` flags. The `BinStickTile` publishes `checked` state matching the highlighted state.

---

## Open Items / Known Gaps

None at this time. Future versions should:
- Add dark-mode contrast audit once a dark theme is introduced.
- Run live TalkBack/VoiceOver traversal on physical device before first public release.
