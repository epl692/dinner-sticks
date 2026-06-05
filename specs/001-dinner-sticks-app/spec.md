# Feature Specification: Dinner Sticks App

**Feature Branch**: `001-dinner-sticks-app`

**Created**: 2026-06-04

**Status**: Draft

**Input**: User description: "Dinner Sticks is a mobile app where ideas for dinners are placed on
virtual popsicle sticks, and a default of 5 are selected for a week from a pool of entered dinner
ideas. Multiple pools should be available, such as 'Breakfast', 'Lunch', and 'Dinner'. Dinner
should be the default, and others should be add-able. Once the weeks sticks are selected, they
should be stored until the user discards them. During the random selection process, sticks should
be discardable, and later on as well, with the option to either remove or replace them with
another random stick. After selection, or when there are more than 0 sticks available the default
home screen of the app should allow for a stick to be selected from the 'bin' of sticks, either
at random, or by manual picking. The list of available sticks and all possible sticks should
persist between sessions."

## User Scenarios & Testing *(mandatory)*

### User Story 1 - Build a Meal Pool (Priority: P1)

A user opens the app for the first time and wants to add their family's favorite dinners to the
Dinner pool. They navigate to pool management, find the default "Dinner" pool already waiting,
and start entering meal ideas one by one — each idea becoming a virtual popsicle stick. They can
also edit or delete sticks they've already entered.

**Why this priority**: Without meal ideas in a pool, no other feature works. Building and
managing the pool is the prerequisite for every other story.

**Independent Test**: Can be fully tested by adding, editing, and removing sticks in the Dinner
pool and confirming they appear, update, and disappear correctly — no weekly selection needed.

**Acceptance Scenarios**:

1. **Given** the app is freshly installed, **When** the user opens pool management, **Then** a
   "Dinner" pool is present and empty, ready for input.
2. **Given** the user is on the pool screen, **When** they type a meal name and confirm, **Then**
   a new stick appears in the pool immediately.
3. **Given** a stick exists in the pool, **When** the user selects it and chooses "Edit", **Then**
   they can rename it and the change is saved immediately.
4. **Given** a stick exists in the pool, **When** the user deletes it, **Then** it is permanently
   removed from the pool and will not appear in future selections.
5. **Given** the user has added sticks and closes the app, **When** they reopen the app, **Then**
   all sticks are still present in the pool with no data loss.

---

### User Story 2 - Select This Week's Sticks (Priority: P1)

A user has a pool with at least 5 dinner ideas and wants to plan their week. They trigger weekly
selection, and the app randomly draws 5 sticks from the pool. As each stick is revealed, the user
can discard it (sending it back to the pool) to draw a replacement. Once satisfied, they confirm
and the weekly bin is saved.

**Why this priority**: This is the core value proposition — turning a pool of ideas into a
concrete weekly plan. Without it the app delivers no value beyond a note-taking tool.

**Independent Test**: Can be tested by populating a pool, triggering selection, discarding sticks
mid-draw, confirming, and verifying the resulting bin persists through an app restart.

**Acceptance Scenarios**:

1. **Given** a pool has 5 or more sticks, **When** the user triggers "Select this week", **Then**
   5 sticks are drawn at random and presented for review.
2. **Given** a stick is shown during selection, **When** the user discards it, **Then** a
   different stick is drawn in its place (the discarded stick is NOT deleted from the pool and
   MUST NOT be redrawn for the remainder of this selection session).
3. **Given** a pool has fewer sticks than 5, **When** the user triggers weekly selection, **Then**
   all available sticks are selected and the user is informed of the reduced count.
4. **Given** the user confirms the drawn sticks, **Then** the bin is saved and persists between
   sessions.
5. **Given** a weekly bin already exists, **When** the user starts a new weekly selection, **Then**
   the app asks for confirmation before replacing the existing bin.

---

### User Story 3 - Pick Tonight's Meal from the Bin (Priority: P1)

A user opens the app on a weeknight. The home screen shows the weekly bin. They tap "Random" to
let the app pick a stick for them, or scroll and tap a specific stick to choose manually. The
selected meal is displayed. Later, once they've made that meal, they mark the stick as done,
removing it from the bin.

**Why this priority**: This is the highest-frequency daily interaction. It is what makes the app
useful on an ongoing basis once the weekly plan is set.

**Independent Test**: Testable by pre-populating a bin, verifying the home screen shows it,
triggering both random and manual selection, and marking sticks as done.

**Acceptance Scenarios**:

1. **Given** the bin has 1 or more sticks, **When** the user opens the app, **Then** the home
   screen shows the bin's sticks as the primary content.
2. **Given** the home screen is displayed, **When** the user taps "Random pick", **Then** one
   stick is highlighted at random from the remaining bin sticks.
3. **Given** the home screen is displayed, **When** the user taps a specific stick, **Then** that
   stick is shown as the selected meal.
4. **Given** a stick has been picked, **When** the user marks it as "Done", **Then** it is
   removed from the bin but remains in the pool for future weeks.
5. **Given** the bin is empty (all sticks done or none selected), **When** the user opens the app,
   **Then** they are prompted to start a new weekly selection or add ideas to the pool.

---

### User Story 4 - Adjust the Bin After Selection (Priority: P2)

A user has a weekly bin but wants to swap a meal they no longer feel like making. They long-press
a stick in the bin and choose "Replace" — the app offers two paths: draw a fresh random stick
from the pool, or browse the pool and pick a specific stick to place in the bin. This second path
covers the case where a family member has requested a particular meal. Or the user chooses
"Remove" to simply drop the stick from the bin without a replacement.

**Why this priority**: Plans change. Bin adjustment is important for real-world use but is
secondary to the core P1 planning and daily-pick flows.

**Independent Test**: Testable by setting up a bin, replacing a stick via random draw and
verifying a new stick appears, replacing via manual pick and verifying the exact chosen stick
appears, and removing a stick and verifying the count decreases.

**Acceptance Scenarios**:

1. **Given** a stick is in the bin, **When** the user selects "Replace", **Then** they are
   offered the choice of "Random" or "Pick one" replacement.
2. **Given** the user chooses "Random" replacement, **Then** a randomly drawn stick from the
   same pool takes its place in the bin.
3. **Given** the user chooses "Pick one" replacement, **Then** the app displays a list of all
   pool sticks not currently in the bin, and the user taps one to place it in the bin.
4. **Given** a stick is in the bin, **When** the user selects "Remove", **Then** the stick
   leaves the bin but remains available in the pool for future draws.
5. **Given** the pool has no sticks that aren't already in the bin, **When** the user tries to
   "Replace", **Then** they are informed no replacement is available and the stick is unchanged.

---

### User Story 5 - Manage Multiple Meal Pools (Priority: P3)

A user wants to plan breakfasts separately from dinners. They create a new "Breakfast" pool,
add ideas to it, and run an independent weekly selection. Each pool has its own sticks and its
own bin. The user can switch between pools on the home screen.

**Why this priority**: Useful for multi-meal planning households but the app is fully functional
with just the default Dinner pool. This is a capability expansion, not a core need.

**Independent Test**: Testable by creating a "Breakfast" pool, populating it, running selection,
and verifying the Breakfast bin is independent of the Dinner pool and its bin.

**Acceptance Scenarios**:

1. **Given** the user is in pool management, **When** they create a new pool with a unique name,
   **Then** the pool appears alongside "Dinner" in the pool list.
2. **Given** multiple pools exist, **When** the user selects a non-default pool and runs weekly
   selection, **Then** sticks are drawn from that pool into its own independent bin.
3. **Given** multiple pools exist, **When** the user is on the home screen, **Then** they can
   switch between pools to view each pool's current bin independently.

---

### Edge Cases

- What happens when a user tries to add or rename a stick to a name already in the pool? The
  app displays an inline duplicate warning and blocks saving until the name is unique.
- What happens when so many sticks have been discarded mid-session that no eligible sticks remain
  for a replacement draw? The app informs the user all remaining sticks have been discarded this
  session; they must confirm the current set or cancel and restart selection.
- What happens when a pool is empty and the user triggers weekly selection? The user is informed
  the pool is empty and directed to add ideas before selecting.
- What happens when "Replace" is triggered but every pool stick is already in the bin? The user
  is notified no new sticks are available and must add more ideas or remove existing bin entries.
- What happens if the app is force-closed mid-selection before the user confirms? The partial
  selection is discarded on next launch; the previous bin (if any) is unchanged.
- What happens if the user deletes the last pool? A new empty "Dinner" pool is automatically
  created, and the app navigates to it.
- What happens if a stick currently in the bin is deleted from the pool? The stick remains in the
  bin until the user removes or marks it done, but it no longer appears in the pool or future
  random draws.
- What happens when all bin sticks are marked done and the user attempts "Random pick"? The
  random pick option is disabled/hidden and the empty-bin prompt is shown.

## Requirements *(mandatory)*

### Functional Requirements

- **FR-001**: The app MUST provide a "Dinner" pool on first launch, pre-created and empty.
- **FR-001a**: Users MUST be able to rename any pool, including the default "Dinner" pool.
- **FR-001b**: Users MUST be able to delete any pool; if the last pool is deleted, the app MUST
  automatically create a new empty "Dinner" pool to ensure at least one pool always exists.
- **FR-002**: Users MUST be able to add a meal idea (stick) to any pool by entering a name; the
  app MUST reject duplicate names within the same pool and display an inline warning.
- **FR-003**: Users MUST be able to edit the name of any existing stick in any pool.
- **FR-004**: Users MUST be able to permanently delete a stick from any pool.
- **FR-005**: Users MUST be able to create additional named pools; pool names MUST be unique.
- **FR-006**: Users MUST be able to trigger a weekly random selection for any pool, drawing 5
  sticks by default.
- **FR-007**: During weekly selection, users MUST be able to discard individual drawn sticks to
  receive a replacement draw; discarded sticks MUST NOT be permanently deleted from the pool and
  MUST NOT be eligible for re-draw for the remainder of that selection session.
- **FR-008**: When a pool contains fewer than 5 sticks, the system MUST select all available
  sticks and inform the user of the reduced count.
- **FR-009**: Confirming a weekly selection MUST save the resulting bin and persist it across
  sessions until explicitly cleared or replaced.
- **FR-010**: Starting a new weekly selection when a bin already exists MUST require explicit user
  confirmation before the existing bin is overwritten.
- **FR-011**: Users MUST be able to replace a bin stick at any time after selection via one of
  two paths: (a) a randomly drawn stick from the same pool, or (b) a manually chosen stick
  selected from a list of pool sticks not currently in the bin.
- **FR-012**: Users MUST be able to remove a stick from the bin; removal MUST NOT delete it from
  the pool.
- **FR-013**: The home screen MUST display the active pool's bin as the primary content when the
  bin contains 1 or more sticks.
- **FR-014**: Users MUST be able to trigger a random pick from the bin in one tap.
- **FR-015**: Users MUST be able to manually pick a specific stick from the bin by tapping it.
- **FR-016**: Users MUST be able to mark a bin stick as "Done", removing it from the bin.
- **FR-017**: All pool data (sticks and bins for all pools) MUST persist across app sessions
  without requiring an account or internet connection.
- **FR-018**: Each pool MUST maintain its own independent weekly bin.

### Key Entities

- **Pool**: A named collection of meal ideas. Has a unique name, an unordered list of sticks, and
  zero or one active weekly bin. The "Dinner" pool is created by default.
- **Stick**: A single meal idea belonging to one pool. Has a display name. Can be referenced by
  the pool and simultaneously referenced in that pool's bin.
- **Weekly Bin**: The set of sticks selected for the current week within a pool. Contains an
  ordered list of stick references (not copies) and tracks which sticks have been marked done.
  Persists until cleared or replaced by a new selection.

## Success Criteria *(mandatory)*

### Measurable Outcomes

- **SC-001**: A user can add a new meal idea to a pool in under 30 seconds from any app state.
- **SC-002**: The weekly selection flow (draw, optional discard, confirm) completes in under 60
  seconds for a typical session of 5 sticks.
- **SC-003**: A user can pick tonight's meal from the bin in under 10 seconds from cold app open.
- **SC-004**: All meal ideas and the weekly bin survive an app restart with 100% fidelity (zero
  data loss across all pools).
- **SC-005**: Users can create, populate, and run weekly selection for a second pool without any
  interference with the Dinner pool or its bin.
- **SC-006**: 90% of first-time users complete the full end-to-end flow (add ideas → select week
  → pick tonight's dinner) without needing external instructions.

## Clarifications

### Session 2026-06-04

- Q: What is the target platform? → A: Cross-platform (React Native or Flutter), targeting both iOS and Android from a single codebase.
- Q: Can the default "Dinner" pool be renamed or deleted? → A: Yes to both; if the last remaining pool is deleted, a new "Dinner" pool is automatically created.
- Q: Can two sticks in the same pool share the same name? → A: No; duplicate names are prevented within a pool and the app warns the user on save.
- Q: During weekly selection, can a discarded stick be redrawn as a replacement? → A: No; sticks discarded in the current session are excluded from all subsequent draws in that session.

## Assumptions

- The app serves a single user on a single device; no cloud sync or multi-device support is
  in scope for this version.
- The weekly selection count of 5 is fixed for v1; user-configurable selection counts are out of
  scope.
- Sticks discarded during selection or removed from the bin are NOT deleted from the pool — they
  remain available for future weekly selections.
- Picking a stick from the bin (tonight's meal) does NOT automatically remove it; only an explicit
  "Done" action removes it from the bin.
- A stick can appear in the bin at most once at any given time.
- There is no maximum limit on the number of sticks in a pool for v1.
- Internet connectivity is not required for any feature.
- No user account, login, or authentication is required.
- The app targets both iOS and Android via a single cross-platform codebase (React Native or
  Flutter); native-platform-only features or APIs are avoided where possible.
