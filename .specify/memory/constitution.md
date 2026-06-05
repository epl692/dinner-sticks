<!--
SYNC IMPACT REPORT
Version change: (none) → 1.0.0
Modified principles: N/A — initial constitution creation
Added sections:
  - Core Principles (I. Mobile-First Design, II. Clean Architecture,
    III. Test-First Development, IV. Performance & Responsiveness,
    V. Accessibility & Inclusion)
  - Quality Standards
  - Development Workflow
  - Governance
Removed sections: N/A
Templates requiring updates:
  ✅ .specify/templates/plan-template.md — Constitution Check placeholder "[Gates determined
     based on constitution file]" correctly defers to this document; no edit required.
  ✅ .specify/templates/spec-template.md — Generic structure aligns with all five principles;
     no mandatory section additions or removals required.
  ✅ .specify/templates/tasks-template.md — Mobile path convention (ios/src/, android/src/)
     already present; Phase structure supports Test-First (tests written before implementation).
  ✅ No commands directory found at .specify/templates/commands/ — nothing to audit.
  ✅ README.md — does not exist yet; no stale references to update.
Follow-up TODOs: None — all placeholders resolved.
-->

# Dinner Sticks Constitution

## Core Principles

### I. Mobile-First Design

Every screen and interaction MUST be designed mobile-first. UI components MUST follow platform
conventions: Material Design 3 for Android, Human Interface Guidelines for iOS. Layouts MUST
render correctly across all supported screen sizes and orientations. Touch targets MUST be at
least 48×48dp. Gestures, visual hierarchy, and navigation patterns MUST reflect the native
platform idiom; desktop-first or web-first patterns are not acceptable defaults.

### II. Clean Architecture

Code MUST be organized into three distinct layers: presentation, domain, and data. No layer may
import from a layer above it. Business logic MUST live in the domain layer, decoupled from any
UI framework or platform SDK. All external dependencies (REST APIs, local storage, device
sensors, analytics) MUST be accessed via repository or service interfaces defined in the domain
layer. This boundary makes the domain independently testable and portable.

### III. Test-First Development (NON-NEGOTIABLE)

Tests MUST be written and confirmed to fail (Red) before any implementation begins. The
Red-Green-Refactor cycle is strictly enforced. Unit tests MUST cover all domain logic. Integration
tests MUST cover repository implementations and API contracts. UI/instrumented tests MUST cover
all P1 user journeys end-to-end. Coverage for the domain and data layers MUST not fall below 80%.
No feature is considered complete until its tests pass in CI.

### IV. Performance & Responsiveness

The app MUST sustain 60 fps during all animations and scroll interactions. Cold-start time MUST
not exceed 2 seconds on a mid-range device (e.g., ~2019-era hardware). All network I/O MUST be
non-blocking, cancellable, and handled off the main thread. Memory usage MUST stay within
platform guidelines; any memory leak is a blocking defect that prevents release. Background work
MUST respect battery and data constraints (e.g., use WorkManager / Background Tasks API
appropriately).

### V. Accessibility & Inclusion

All interactive elements MUST carry semantic labels compatible with platform screen readers
(TalkBack on Android, VoiceOver on iOS). Color contrast MUST meet WCAG 2.1 AA minimums: 4.5:1
for body text, 3:1 for UI components and large text. The UI MUST adapt correctly to the
platform's dynamic text size settings. Accessibility compliance MUST be verified (automated
scan + manual check) before any feature is marked complete.

## Quality Standards

All code MUST pass static analysis (linter and type checker) with zero warnings before a PR is
opened. Dependencies MUST be audited for known security vulnerabilities on every update (e.g.,
`npm audit`, `pod-audit`, Gradle dependency-check, or equivalent). Dead code, commented-out
blocks, and untracked TODO comments MUST NOT be merged to `main`; open a tracked issue instead.
All user-visible string literals MUST be externalized (strings.xml, Localizable.strings, or
equivalent) to maintain localization readiness from day one.

## Development Workflow

Feature branches MUST branch from `main` and follow the naming convention
`###-kebab-case-feature-name` (e.g., `001-user-authentication`). PRs MUST pass all automated
checks — lint, type check, and full test suite — before requesting review. Each PR MUST receive
at least one approval from a team member other than the author. PRs MUST be squash-merged to
preserve a linear, readable history on `main`. Release builds MUST be produced and signed
exclusively by CI/CD pipelines; no manual uploads to app stores are permitted.

## Governance

This constitution supersedes all other project guidelines and practices. Amendments require:
(1) a written rationale documenting the change and its effect on existing code, (2) team
consensus (simple majority approval), and (3) a migration plan if existing code must be updated
to comply. Every PR and design review MUST verify compliance with the Core Principles above.
Any deviation from a principle MUST be explicitly justified in the plan's Complexity Tracking
table before work begins; undocumented violations are grounds for blocking a merge.

Constitution versioning follows semantic rules: MAJOR for principle removal or redefinition,
MINOR for new principle or material guidance addition, PATCH for clarifications or wording
fixes. Compliance is reviewed at the start of each feature cycle.

**Version**: 1.0.0 | **Ratified**: 2026-06-04 | **Last Amended**: 2026-06-04
