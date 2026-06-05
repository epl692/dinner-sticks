# UI Contract: Dinner Sticks App

**Phase**: 1 | **Branch**: `001-dinner-sticks-app` | **Date**: 2026-06-05

This document defines the contracts between the presentation layer and the domain layer: what data each screen requires (inputs from domain), what actions each screen triggers (outputs to domain), and the navigation contract.

---

## Navigation Contract

```
HomeScreen  ──── (navigate to pool management) ────► PoolManagementScreen
            ──── (navigate to selection flow)  ────► WeeklySelectionScreen
            ──── (navigate to pool switcher)   ────► PoolSwitcherScreen  [P3]

PoolManagementScreen ◄──────────────────────────────────────────────────────
  └── (inline) StickEditorSheet (add / edit a stick)

WeeklySelectionScreen ─── (confirm) ──► HomeScreen
                      ─── (cancel)  ──► HomeScreen

PoolSwitcherScreen ─── (select pool) ──► HomeScreen (with new active pool)
```

All navigation is push/pop; no deep links in v1.

---

## Screen Contracts

### HomeScreen

The primary screen; shown whenever the active pool has ≥1 stick in its bin.

**Domain inputs** (read via Riverpod providers):
| Data | Provider | Notes |
|------|----------|-------|
| `activePool: Pool` | `activePoolProvider` | Currently selected pool |
| `bin: WeeklyBin?` | `weeklyBinProvider(poolId)` | Null when no bin exists |
| `binSticks: List<Stick>` | `binSticksProvider(poolId)` | Sticks in bin, excluding done |

**User actions → domain use-cases**:
| Action | Use-case | Notes |
|--------|----------|-------|
| Tap "Random pick" | `PickRandomBinStick` | Returns a highlighted `Stick`; does NOT mark done |
| Tap specific stick | `SelectStickFromBin` | Returns that `Stick` as highlighted |
| Tap "Done" on highlighted stick | `MarkStickDone` | Moves stick from bin |
| Long-press stick → "Replace" | `ReplaceBinStick(mode: random\|pick)` | Opens inline sheet for pick mode |
| Long-press stick → "Remove" | `RemoveBinStick` | Removes from bin, not pool |
| Tap "Start new week" | navigate → `WeeklySelectionScreen` | Guarded: confirm if bin exists |
| Tap pool name chip | navigate → `PoolSwitcherScreen` | P3 |

**Empty state** (bin is null or all sticks done):
- Show prompt: "No meals planned this week" + CTA to "Select this week's meals"
- CTA navigates to `WeeklySelectionScreen`

---

### PoolManagementScreen

Manages the sticks in a single pool. Accessible from HomeScreen.

**Domain inputs**:
| Data | Provider | Notes |
|------|----------|-------|
| `activePool: Pool` | `activePoolProvider` | |
| `sticks: List<Stick>` | `poolSticksProvider(poolId)` | All sticks for this pool, sorted by name |
| `allPools: List<Pool>` | `allPoolsProvider` | For pool switcher header |

**User actions → domain use-cases**:
| Action | Use-case | Notes |
|--------|----------|-------|
| Tap "+" → enter name → confirm | `AddStick` | Inline duplicate validation |
| Tap stick → "Edit" → rename | `EditStick` | Inline duplicate validation |
| Tap stick → "Delete" | `DeleteStick` | Stick removed from pool |
| Tap pool name → rename | `RenamePool` | Inline duplicate validation |
| Tap "Delete pool" | `DeletePool` | Confirmation dialog; auto-creates "Dinner" if last |
| Tap "Add pool" | `CreatePool` | Navigates to same screen with new pool active |

**Validation feedback** (inline, not modal):
- Duplicate name: show inline error below input field
- Empty name: show inline error on confirm attempt

---

### WeeklySelectionScreen

Drives the weekly draw flow. Transient `SelectionSession` state lives here (in-memory only).

**Domain inputs**:
| Data | Provider | Notes |
|------|----------|-------|
| `activePool: Pool` | `activePoolProvider` | |
| `poolSticks: List<Stick>` | `poolSticksProvider(poolId)` | Source pool for draws |
| `existingBin: WeeklyBin?` | `weeklyBinProvider(poolId)` | Checked before replacing |

**Local (in-screen) state** — NOT a domain provider:
| State | Type | Notes |
|-------|------|-------|
| `session` | `SelectionSession` | Tracks drawn/discarded/available |
| `phase` | `SelectionPhase` | `drawing \| reviewing \| confirming` |

**User actions**:
| Action | Outcome |
|--------|---------|
| Enter screen | Auto-draw up to 5 sticks; show reduced-count notice if <5 available |
| Tap "Discard" on drawn stick | Move to discarded set; auto-draw replacement if available |
| Tap "Confirm" | Call `ConfirmWeeklySelection(stickIds)` → saves bin; navigate to Home |
| Tap "Cancel" / back | Discard session; previous bin unchanged; navigate to Home |

**Guard**: if `existingBin != null` and user taps "Start new week" on Home, show confirmation dialog before navigating here.

**Empty pool guard**: if pool has 0 sticks, navigate to `PoolManagementScreen` with a banner: "Add meal ideas before selecting a week."

---

### PoolSwitcherScreen *(P3)*

Allows switching the active pool.

**Domain inputs**:
| Data | Provider | Notes |
|------|----------|-------|
| `allPools: List<Pool>` | `allPoolsProvider` | |
| `activePool: Pool` | `activePoolProvider` | Highlighted |

**User actions → domain use-cases**:
| Action | Use-case |
|--------|----------|
| Tap pool | `SetActivePool(poolId)` |
| Tap "+" → enter name | `CreatePool` |

---

## Domain Repository Interface Contract

```dart
abstract class PoolRepository {
  // Pools
  Stream<List<Pool>> watchAllPools();
  Future<Pool> createPool(String name);
  Future<Pool> renamePool(String poolId, String newName);
  Future<void> deletePool(String poolId); // auto-creates Dinner if last

  // Sticks
  Stream<List<Stick>> watchSticks(String poolId);
  Future<Stick> addStick(String poolId, String name);
  Future<Stick> editStick(String stickId, String newName);
  Future<void> deleteStick(String stickId);

  // Weekly Bin
  Future<WeeklyBin?> getWeeklyBin(String poolId);
  Stream<WeeklyBin?> watchWeeklyBin(String poolId);
  Future<WeeklyBin> confirmSelection(String poolId, List<String> stickIds);
  Future<WeeklyBin> replaceBinStick(String poolId, String oldStickId, String newStickId);
  Future<WeeklyBin> removeBinStick(String poolId, String stickId);
  Future<WeeklyBin> markStickDone(String poolId, String stickId);
}
```

All `Future<T>` methods throw typed failures from `domain/failures.dart` (e.g., `DuplicateNameFailure`, `PoolNotFoundFailure`, `StickNotFoundFailure`). Callers in the presentation layer handle failures via Riverpod's `AsyncValue.error`.

---

## Accessibility Contract

| Element | Required semantic label |
|---------|------------------------|
| "Random pick" button | `"Pick a random meal from this week's plan"` |
| Stick list item | `"${stick.name}, meal idea"` |
| Bin stick item | `"${stick.name}"` + state hint: `"in this week's plan"` or `"done"` |
| "Done" action | `"Mark ${stick.name} as done and remove from this week's plan"` |
| "Discard" action (selection) | `"Discard ${stick.name} and draw a replacement"` |
| Pool name chip | `"Active pool: ${pool.name}. Tap to switch."` |

All touch targets: minimum 48×48dp. Semantic labels are required even when icon-only buttons are used.
