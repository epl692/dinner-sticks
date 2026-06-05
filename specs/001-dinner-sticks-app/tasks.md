# Tasks: Dinner Sticks App

**Input**: Design documents from `specs/001-dinner-sticks-app/`

**Prerequisites**: plan.md ✅ | spec.md ✅ | research.md ✅ | data-model.md ✅ | contracts/ui-contract.md ✅ | quickstart.md ✅

**Tests**: Included — constitution principle III (Test-First Development) is NON-NEGOTIABLE. Tests MUST be written and confirmed to FAIL (Red) before any implementation begins.

**Organization**: Tasks are grouped by user story to enable independent implementation and testing of each story.

## Format: `[ID] [P?] [Story?] Description`

- **[P]**: Can run in parallel (different files, no shared dependencies)
- **[Story]**: Which user story this task belongs to (US1–US5)
- File paths follow the Flutter project layout defined in plan.md

---

## Phase 1: Setup (Shared Infrastructure)

**Purpose**: Flutter project creation and dev environment. No user story work until Phase 2 is complete.

- [X] T001 Initialize Flutter project: `flutter create dinner_sticks --org com.dinnersticks --platforms ios,android` at repository root — ran inside devcontainer; android/ and ios/ platform directories generated
- [X] T002 Add all dependencies to pubspec.yaml: runtime (`isar`, `isar_flutter_libs`, `flutter_riverpod`, `riverpod_annotation`, `uuid`); dev (`isar_generator`, `riverpod_generator`, `build_runner`, `flutter_test`, `mockito`, `integration_test`, `very_good_analysis`, `coverage`)
- [X] T003 [P] Configure lint rules in analysis_options.yaml using `very_good_analysis` ruleset
- [X] T004 [P] Create .devcontainer/Dockerfile: base `ghcr.io/cirruslabs/flutter:stable`, install Android SDK platform-34 + build-tools-34, expose ports for adb
- [X] T005 [P] Create .devcontainer/docker-compose.yml: mount project root into /workspace, set working directory
- [X] T006 Create full directory skeleton: `lib/domain/{entities,repositories,usecases/{pool,stick,bin}}`, `lib/data/{models,datasources,repositories}`, `lib/presentation/{screens/{home,pool_management,weekly_selection,pool_switcher},widgets,providers}`, `test/{domain/{entities,usecases},data/repositories}`, `integration_test/`

---

## Phase 2: Foundational (Blocking Prerequisites)

**Purpose**: Domain entities, repository interface, Isar models, and app scaffold that ALL user stories depend on.

**⚠️ CRITICAL**: No user story work can begin until this phase is complete.

- [ ] T007 Create Pool entity in lib/domain/entities/pool.dart (fields: `externalId`, `name`, `createdAt`; value equality on `externalId`; const constructor; copyWith)
- [ ] T008 [P] Create Stick entity in lib/domain/entities/stick.dart (fields: `externalId`, `poolId`, `name`, `createdAt`; value equality on `externalId`; copyWith)
- [ ] T009 [P] Create WeeklyBin entity in lib/domain/entities/weekly_bin.dart (fields: `poolId`, `stickIds: List<String>`, `doneStickIds: List<String>`, `createdAt`, `updatedAt`; copyWith for immutable updates)
- [ ] T010 Create SelectionSession class in lib/domain/entities/selection_session.dart (transient only; fields: `poolId`, `drawnStickIds`, `discardedStickIds`, `availableStickIds`; methods: `discard(stickId)`, `drawNext()`)
- [ ] T011 Create typed domain failures in lib/domain/failures.dart (sealed class `Failure`; subtypes: `DuplicateNameFailure`, `PoolNotFoundFailure`, `StickNotFoundFailure`, `InsufficientSticksFailure`, `NoReplacementAvailableFailure`)
- [ ] T012 Create abstract PoolRepository interface in lib/domain/repositories/pool_repository.dart (full interface from contracts/ui-contract.md: watchAllPools, createPool, renamePool, deletePool, watchSticks, addStick, editStick, deleteStick, getWeeklyBin, watchWeeklyBin, confirmSelection, replaceBinStick, removeBinStick, markStickDone)
- [ ] T013 Create PoolModel in lib/data/models/pool_model.dart (`@collection`; `@Index(unique: true, caseSensitive: false)` on `name`; `toEntity()` and `fromEntity()` mappers)
- [ ] T014 [P] Create StickModel in lib/data/models/stick_model.dart (`@collection`; composite `@Index(unique: true, caseSensitive: false)` on `[poolId, name]`; mappers)
- [ ] T015 [P] Create WeeklyBinModel in lib/data/models/weekly_bin_model.dart (`@collection`; `@Index(unique: true)` on `poolId`; mappers)
- [ ] T016 Run `dart run build_runner build --delete-conflicting-outputs` to generate `*.g.dart` Isar schema + Riverpod provider files; commit all generated files
- [ ] T017 Create IsarLocalDataSource in lib/data/datasources/isar_local_datasource.dart (open Isar with `[PoolModelSchema, StickModelSchema, WeeklyBinModelSchema]`; expose `isar` instance; handle first-launch seed of empty "Dinner" pool)
- [ ] T018 Create `isarProvider` FutureProvider in lib/presentation/providers/isar_provider.dart (async-opens Isar; used by all repository providers)
- [ ] T019 Wire ProviderScope + MaterialApp in lib/main.dart (Riverpod root; router stub with `/` → HomeScreen placeholder; theme scaffold)

**Checkpoint**: Project builds and runs with an empty placeholder screen. All entities, interfaces, and Isar models are in place. No user story logic yet.

---

## Phase 3: User Story 1 — Build a Meal Pool (Priority: P1) 🎯 MVP

**Goal**: User can add, edit, and delete meal ideas (sticks) in the default Dinner pool. All sticks persist across app restarts.

**Independent Test**: Add 3 sticks, edit one, delete one, force-quit and reopen app → 2 sticks remain with correct names. No weekly selection needed.

### Tests — Write FIRST, confirm FAIL before implementing (Red)

- [ ] T020 [P] [US1] Write failing unit tests for Stick name validation in test/domain/entities/stick_test.dart (empty name rejected; name trimmed; equality by externalId)
- [ ] T021 [P] [US1] Write failing unit tests for AddStick use-case in test/domain/usecases/add_stick_test.dart (success path; duplicate name → `DuplicateNameFailure`; empty name → error; mock PoolRepository via mockito)
- [ ] T022 [P] [US1] Write failing unit tests for EditStick use-case in test/domain/usecases/edit_stick_test.dart (success; rename to duplicate → `DuplicateNameFailure`; stick not found → `StickNotFoundFailure`)
- [ ] T023 [P] [US1] Write failing unit tests for DeleteStick use-case in test/domain/usecases/delete_stick_test.dart (success; stick in bin stays in bin after delete; stick not found → `StickNotFoundFailure`)
- [ ] T024 [P] [US1] Write failing repository tests for stick CRUD in test/data/repositories/pool_repository_impl_us1_test.dart (addStick persists, editStick updates, deleteStick removes; duplicate name throws; uses in-memory Isar via `Isar.open` in test setup)
- [ ] T025 [US1] Write failing integration test for US1 user journey in integration_test/us1_pool_management_test.dart (add 3 sticks, edit one, delete one, verify 2 remain, restart and verify persistence)

### Implementation (Green → Refactor)

- [ ] T026 [US1] Implement AddStick use-case in lib/domain/usecases/stick/add_stick.dart (trim name; check empty; call `repository.addStick`; duplicate failure propagated)
- [ ] T027 [P] [US1] Implement EditStick use-case in lib/domain/usecases/stick/edit_stick.dart
- [ ] T028 [P] [US1] Implement DeleteStick use-case in lib/domain/usecases/stick/delete_stick.dart
- [ ] T029 [US1] Implement PoolRepositoryImpl stick + pool CRUD in lib/data/repositories/pool_repository_impl.dart: `addStick` (enforce case-insensitive unique within pool → `DuplicateNameFailure`), `editStick`, `deleteStick`, `watchSticks`, `watchAllPools`, first-launch "Dinner" pool seed via `IsarLocalDataSource`
- [ ] T030 [P] [US1] Create pool/stick Riverpod providers in lib/presentation/providers/pool_providers.dart: `allPoolsProvider` (StreamProvider), `activePoolIdProvider` (StateProvider, defaults to Dinner pool), `activePoolProvider`, `poolSticksProvider(poolId)`
- [ ] T031 [US1] Create PoolManagementScreen in lib/presentation/screens/pool_management/pool_management_screen.dart (alphabetical stick list; FAB to add; tap stick → edit/delete sheet; inline duplicate warning; 48dp touch targets; Semantics labels per contracts/ui-contract.md)
- [ ] T032 [US1] Create StickEditorSheet widget in lib/presentation/widgets/stick_editor_sheet.dart (TextField with inline error text for duplicate/empty; confirm/cancel actions)

**Checkpoint**: User Story 1 fully functional. Can add/edit/delete sticks; data survives restart. All T020–T025 tests pass.

---

## Phase 4: User Story 2 — Select This Week's Sticks (Priority: P1)

**Goal**: User draws up to 5 random sticks from the pool, can discard and redraw mid-session (discarded sticks excluded from re-draw), then confirms to save the weekly bin.

**Independent Test**: Populate a pool with 7 sticks, trigger selection, discard 2, confirm → bin has 5 unique sticks, none are the discarded ones, bin persists on restart.

### Tests — Write FIRST, confirm FAIL (Red)

- [ ] T033 [P] [US2] Write failing unit tests for SelectionSession logic in test/domain/entities/selection_session_test.dart (discard moves stick out of drawn into discarded; discarded stick never re-drawn; draw from empty available → null; reduced count when pool has <5 sticks)
- [ ] T034 [P] [US2] Write failing unit tests for ConfirmWeeklySelection use-case in test/domain/usecases/confirm_weekly_selection_test.dart (saves bin with correct stickIds; replaces existing bin atomically; zero-sticks pool → `InsufficientSticksFailure`)
- [ ] T035 [US2] Write failing integration test for US2 in integration_test/us2_weekly_selection_test.dart (pool of 7, draw 5, discard 2, confirm, restart, verify bin has 5 non-discarded sticks, verify discarded sticks still in pool)

### Implementation (Green → Refactor)

- [ ] T036 [US2] Implement ConfirmWeeklySelection use-case in lib/domain/usecases/bin/confirm_weekly_selection.dart (validates stickIds non-empty; calls `repository.confirmSelection`)
- [ ] T037 [US2] Implement PoolRepositoryImpl.confirmSelection and watchWeeklyBin and getWeeklyBin in lib/data/repositories/pool_repository_impl.dart (confirmSelection uses Isar write transaction; overwrites existing WeeklyBinModel for poolId)
- [ ] T038 [P] [US2] Create bin Riverpod providers in lib/presentation/providers/bin_providers.dart: `weeklyBinProvider(poolId)` (StreamProvider), `selectionSessionProvider` (StateNotifierProvider; drives in-memory SelectionSession)
- [ ] T039 [US2] Create WeeklySelectionScreen in lib/presentation/screens/weekly_selection/weekly_selection_screen.dart (auto-draw up to 5 on enter; draw-stack UI showing each stick; discard button per stick; confirm/cancel; reduced-count notice when <5; empty-pool guard navigates to PoolManagementScreen; existing-bin confirmation dialog)

**Checkpoint**: User Story 2 fully functional. Selection, discard/redraw, and bin persistence all work. T033–T035 pass. US1 unaffected.

---

## Phase 5: User Story 3 — Pick Tonight's Meal from the Bin (Priority: P1)

**Goal**: Home screen shows this week's bin. User can random-pick or tap a specific stick. Marking a stick Done removes it from the bin (not the pool). Empty bin shows CTA.

**Independent Test**: Pre-populate a bin with 3 sticks, open app → all 3 shown on home. Tap "Random" → one highlighted. Tap "Done" → 2 remain. Tap stick manually → it is highlighted. Mark all done → empty-bin prompt shown.

### Tests — Write FIRST, confirm FAIL (Red)

- [ ] T041 [P] [US3] Write failing unit tests for MarkStickDone use-case in test/domain/usecases/mark_stick_done_test.dart (atomic: removes from stickIds, adds to doneStickIds; stick not in bin → `StickNotFoundFailure`; already done is idempotent)
- [ ] T042 [P] [US3] Write failing widget tests for HomeScreen in test/domain/usecases/home_screen_test.dart (bin sticks rendered; random-pick button highlights a stick; manual tap highlights correct stick; done button triggers MarkStickDone; empty bin renders EmptyBinPrompt)
- [ ] T043 [US3] Write failing integration test for US3 in integration_test/us3_pick_tonight_test.dart (pre-populated bin, random pick, manual pick, mark done, all-done → empty bin state shown)

### Implementation (Green → Refactor)

- [ ] T044 [US3] Implement MarkStickDone use-case in lib/domain/usecases/bin/mark_stick_done.dart (atomically removes stickId from stickIds and adds to doneStickIds; calls repository)
- [ ] T045 [US3] Implement PoolRepositoryImpl.markStickDone in lib/data/repositories/pool_repository_impl.dart (Isar write transaction; update WeeklyBinModel stickIds + doneStickIds)
- [ ] T046 [P] [US3] Create binSticksProvider(poolId) in lib/presentation/providers/bin_providers.dart (derives non-done active sticks by joining weeklyBinProvider + poolSticksProvider; handles stale stickId references gracefully)
- [ ] T047 [US3] Create HomeScreen in lib/presentation/screens/home/home_screen.dart (bin list as primary content; "Random pick" FAB; tap-to-highlight stick; Done button on highlighted stick; empty-bin prompt CTA → WeeklySelectionScreen; pool name chip header; semantic labels per contracts/ui-contract.md)
- [ ] T048 [P] [US3] Create BinStickTile widget in lib/presentation/widgets/bin_stick_tile.dart (stick name; tap handler; highlighted visual state; Done button; 48dp touch target; Semantics label from ui-contract)
- [ ] T049 [P] [US3] Create EmptyBinPrompt widget in lib/presentation/widgets/empty_bin_prompt.dart (shown when bin is null or all sticks done; CTA button navigates to WeeklySelectionScreen)

**Checkpoint**: All three P1 user stories complete. Full end-to-end flow (add ideas → select week → pick tonight) works. T041–T043 pass. US1 + US2 unaffected.

---

## Phase 6: User Story 4 — Adjust the Bin After Selection (Priority: P2)

**Goal**: User can long-press a bin stick to replace it (random or manual pick from pool) or remove it. Replaced/removed stick stays in the pool.

**Independent Test**: Set up a bin with 3 sticks. Replace one via random → a different stick now in the bin. Replace one via manual pick → exact chosen stick in bin. Remove one → count decreases; stick still in pool.

### Tests — Write FIRST, confirm FAIL (Red)

- [ ] T050 [P] [US4] Write failing unit tests for ReplaceBinStick use-case in test/domain/usecases/replace_bin_stick_test.dart (random mode picks from pool-not-in-bin; pick mode places specific stick; all pool sticks already in bin → `NoReplacementAvailableFailure`)
- [ ] T051 [P] [US4] Write failing unit tests for RemoveBinStick use-case in test/domain/usecases/remove_bin_stick_test.dart (success removes from bin; stick remains accessible in pool; stick not in bin → `StickNotFoundFailure`)
- [ ] T052 [US4] Write failing integration test for US4 in integration_test/us4_bin_adjustment_test.dart (replace random, replace pick, remove; verify pool unaffected after all operations)

### Implementation (Green → Refactor)

- [ ] T053 [US4] Implement ReplaceBinStick use-case in lib/domain/usecases/bin/replace_bin_stick.dart (random mode: picks random from pool sticks not already in bin; pick mode: validates target not already in bin; no eligible sticks → `NoReplacementAvailableFailure`)
- [ ] T054 [P] [US4] Implement RemoveBinStick use-case in lib/domain/usecases/bin/remove_bin_stick.dart
- [ ] T055 [US4] Implement PoolRepositoryImpl.replaceBinStick and removeBinStick in lib/data/repositories/pool_repository_impl.dart (both within Isar write transactions)
- [ ] T056 [US4] Add long-press interaction to BinStickTile in lib/presentation/widgets/bin_stick_tile.dart (long-press opens action sheet: "Replace" → sub-sheet with Random/Pick One options; "Remove" with confirmation; PickOneSheet lists pool sticks not currently in bin)

**Checkpoint**: User Story 4 complete. Bin adjustment works. T050–T052 pass. P1 stories unaffected.

---

## Phase 7: User Story 5 — Manage Multiple Meal Pools (Priority: P3)

**Goal**: User can create additional named pools (e.g., "Breakfast"), populate them, and run independent weekly selections. Each pool has its own bin. Home screen allows pool switching.

**Independent Test**: Create "Breakfast" pool, add 5 sticks, run selection → Breakfast has its own bin. Switch back to Dinner pool → Dinner bin unchanged. Delete Breakfast pool → Dinner pool and bin intact.

### Tests — Write FIRST, confirm FAIL (Red)

- [ ] T057 [P] [US5] Write failing unit tests for CreatePool use-case in test/domain/usecases/create_pool_test.dart (success; duplicate name → `DuplicateNameFailure`; empty name → error)
- [ ] T058 [P] [US5] Write failing unit tests for RenamePool and DeletePool use-cases in test/domain/usecases/pool_lifecycle_test.dart (rename duplicate check; deletePool auto-creates "Dinner" pool when deleting last pool in same transaction)
- [ ] T059 [US5] Write failing integration test for US5 in integration_test/us5_multiple_pools_test.dart (create Breakfast pool, populate, run selection, verify Breakfast bin independent of Dinner bin; switch pools on home screen)

### Implementation (Green → Refactor)

- [ ] T060 [US5] Implement CreatePool use-case in lib/domain/usecases/pool/create_pool.dart (trim name; case-insensitive duplicate check → `DuplicateNameFailure`)
- [ ] T061 [P] [US5] Implement RenamePool use-case in lib/domain/usecases/pool/rename_pool.dart (case-insensitive duplicate check across all pools)
- [ ] T062 [P] [US5] Implement DeletePool use-case in lib/domain/usecases/pool/delete_pool.dart (delegates to repository; repository handles auto-create-Dinner)
- [ ] T063 [US5] Implement PoolRepositoryImpl.createPool, renamePool, deletePool in lib/data/repositories/pool_repository_impl.dart (deletePool: if deleting last pool, create new empty "Dinner" pool in same Isar write transaction before deleting)
- [ ] T064 [US5] Create PoolSwitcherScreen in lib/presentation/screens/pool_switcher/pool_switcher_screen.dart (list all pools; active pool highlighted; tap to switch; "Add pool" action with name input; 48dp targets; Semantics labels)

**Checkpoint**: User Story 5 complete. Multi-pool use is fully functional. T057–T059 pass. All prior stories unaffected.

---

## Phase 8: Polish & Cross-Cutting Concerns

**Purpose**: Accessibility, localization readiness, CI/CD, and performance — affects all user stories.

- [ ] T065 [P] Externalize all user-visible strings to lib/l10n/app_en.arb (ARB format; configure `flutter_localizations` + `intl` in pubspec.yaml; replace all hard-coded string literals in lib/presentation/)
- [ ] T066 [P] Accessibility audit: verify every interactive element in lib/presentation/ carries a Semantics label matching contracts/ui-contract.md; add missing `Semantics` wrappers; verify minimum 48×48dp touch targets with `debugCheckHasFlutterBinding` tool
- [ ] T067 [P] WCAG 2.1 AA color contrast audit: verify all foreground/background color pairs meet 4.5:1 (body text) and 3:1 (UI components); document results in specs/001-dinner-sticks-app/a11y-audit.md
- [ ] T068 Set up GitHub Actions CI pipeline in .github/workflows/ci.yml: steps → `flutter pub get` → `dart run build_runner build` → `flutter analyze` → `flutter test` → `flutter test integration_test/ -d emulator-5554` → `flutter test --coverage` with lcov ≥80% gate for lib/domain/ and lib/data/
- [ ] T069 [P] Set up GitHub Actions iOS workflow in .github/workflows/ci-ios.yml (`macos-latest` runner; `flutter build ios --release --no-codesign`)
- [ ] T070 Run `flutter test --coverage` locally; verify lib/domain/ and lib/data/ coverage ≥80%; write additional unit tests for any uncovered paths
- [ ] T071 Profile cold start on Android emulator API 29: run `flutter run --profile`, measure time-to-interactive; verify <2s; document result in specs/001-dinner-sticks-app/perf-notes.md

---

## Dependencies & Execution Order

### Phase Dependencies

- **Setup (Phase 1)**: No dependencies — start immediately
- **Foundational (Phase 2)**: Depends on Phase 1 completion — **blocks all user stories**
- **User Stories (Phases 3–7)**: All depend on Phase 2 completion
  - US1 (P1): No dependency on other stories — first to implement
  - US2 (P1): No dependency on US1 but shares WeeklyBin infrastructure from Phase 2
  - US3 (P1): Depends on US2 having confirmed a bin (integration test needs a bin to exist); logic is independent
  - US4 (P2): Depends on US2 (bin must exist to adjust); builds on BinStickTile from US3
  - US5 (P3): Independent of US2–US4 for pool CRUD; PoolSwitcherScreen requires UI patterns from US3
- **Polish (Phase 8)**: Depends on all desired user stories complete

### Within Each User Story

1. Write tests → confirm FAIL (Red) — mandatory before implementation
2. Domain entities / use-cases → before data layer
3. Data layer (repository impl) → before presentation
4. Presentation (screens / widgets) → last
5. Confirm tests pass (Green), then refactor

### Parallel Opportunities

- Within Phase 2: T007–T009 (entities) run in parallel; T013–T015 (Isar models) run in parallel
- Within each story: test tasks marked [P] run in parallel; model tasks marked [P] run in parallel
- Phases 3–5 (all P1) can overlap on a team: US1 domain ≠ US2 domain ≠ US3 domain (no file conflicts)
- Phase 8: T065, T066, T067, T069 all run in parallel

---

## Parallel Example: User Story 1

```
# Write all failing tests in parallel (different files):
T020 test/domain/entities/stick_test.dart
T021 test/domain/usecases/add_stick_test.dart
T022 test/domain/usecases/edit_stick_test.dart
T023 test/domain/usecases/delete_stick_test.dart
T024 test/data/repositories/pool_repository_impl_us1_test.dart

# Then implement use-cases in parallel (different files):
T026 lib/domain/usecases/stick/add_stick.dart
T027 lib/domain/usecases/stick/edit_stick.dart
T028 lib/domain/usecases/stick/delete_stick.dart

# Then implement presentation components in parallel:
T030 lib/presentation/providers/pool_providers.dart
T032 lib/presentation/widgets/stick_editor_sheet.dart
```

---

## Implementation Strategy

### MVP First (P1 Stories Only — Phases 1–5)

1. Complete Phase 1: Setup
2. Complete Phase 2: Foundational (CRITICAL — blocks everything)
3. Complete Phase 3: US1 (pool + stick management)
4. **STOP and VALIDATE**: `flutter test` + manual smoke test on device
5. Complete Phase 4: US2 (weekly selection)
6. **VALIDATE**: integration test + manual run-through
7. Complete Phase 5: US3 (home screen + nightly pick)
8. **VALIDATE**: full P1 end-to-end flow — this is the shippable MVP

### Incremental Delivery

- After Phase 5: ship MVP (all P1 stories)
- After Phase 6: ship bin-adjustment feature (P2)
- After Phase 7: ship multi-pool feature (P3)
- After Phase 8: ship accessibility + CI hardening pass

---

## Notes

- `[P]` = can run in parallel with other `[P]` tasks in the same phase (different files, no shared in-progress state)
- `[Story]` label maps each task to a specific user story for traceability to spec.md
- Tests must be written and confirmed FAIL before the corresponding implementation task starts (constitution mandate)
- Commit generated files (`*.g.dart`) — do not gitignore them
- Run `build_runner` again after any change to `@collection`, `@riverpod`, or `@GenerateMocks` annotations
- Stop at each phase checkpoint to validate the story independently before proceeding
