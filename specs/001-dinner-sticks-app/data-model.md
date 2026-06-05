# Data Model: Dinner Sticks App

**Phase**: 1 | **Branch**: `001-dinner-sticks-app` | **Date**: 2026-06-05

All entities are stored in Isar (local, embedded, ACID-transactional). No cloud or network layer exists.

---

## Entities

### Pool

Represents a named collection of meal ideas (sticks) with an optional active weekly bin.

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | `Id` (Isar auto-int) | PK, auto-assigned |
| `externalId` | `String` | UUID v4, unique, immutable after creation |
| `name` | `String` | Non-empty; unique across all Pool records (case-insensitive) |
| `createdAt` | `DateTime` | Set at creation; immutable |

**Business rules**:
- At least one Pool must always exist. If the last Pool is deleted, a new "Dinner" Pool is auto-created before the deletion completes (within the same Isar transaction).
- Pool names are unique case-insensitively (`"dinner"` and `"Dinner"` are the same name).
- Default Pool on first launch: `{ name: "Dinner" }`.

**Relationships**:
- One Pool → many Sticks (via `Stick.poolId`)
- One Pool → zero or one WeeklyBin (via `WeeklyBin.poolId`)

---

### Stick

A single meal idea belonging to one Pool. Can be referenced in that Pool's WeeklyBin.

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | `Id` (Isar auto-int) | PK, auto-assigned |
| `externalId` | `String` | UUID v4, unique, immutable after creation |
| `poolId` | `String` | FK → `Pool.externalId`; non-null |
| `name` | `String` | Non-empty; unique within the same Pool (case-insensitive) |
| `createdAt` | `DateTime` | Set at creation; immutable |

**Business rules**:
- Stick names are unique case-insensitively within the same Pool.
- Deleting a Stick that is currently referenced in the Pool's WeeklyBin does NOT remove it from the bin — the bin retains the stale reference until the user removes or marks it done. The Stick is no longer eligible for future random draws.
- A Stick cannot appear in the WeeklyBin more than once at any given time.

**State**:
- `in_pool`: exists in Pool, not in WeeklyBin
- `in_bin`: exists in Pool AND referenced in WeeklyBin (not done)
- `done_in_bin`: referenced in WeeklyBin with `doneStickIds` membership (pending removal)

---

### WeeklyBin

The set of Sticks selected for the current week within a Pool. There is at most one active WeeklyBin per Pool.

| Field | Type | Constraints |
|-------|------|-------------|
| `id` | `Id` (Isar auto-int) | PK, auto-assigned |
| `poolId` | `String` | FK → `Pool.externalId`; unique (one bin per pool) |
| `stickIds` | `List<String>` | Ordered list of `Stick.externalId`; may contain stale references (see Stick deletion rules) |
| `doneStickIds` | `List<String>` | Subset of `stickIds`; sticks marked as done |
| `createdAt` | `DateTime` | When this bin was confirmed |
| `updatedAt` | `DateTime` | Last modification time |

**Business rules**:
- Replacing an existing WeeklyBin requires explicit user confirmation.
- `stickIds` may have fewer than 5 entries if the Pool had fewer than 5 Sticks at selection time.
- `doneStickIds` is always a subset of `stickIds`.
- Removing a Stick from the bin (`FR-012`) removes it from `stickIds` (and `doneStickIds` if present) but does NOT delete it from the Pool.
- Marking a Stick done (`FR-016`) adds it to `doneStickIds` and removes it from `stickIds` atomically.

---

## Transient State (In-Memory Only)

These structures exist only during the weekly selection flow and are discarded if the app is closed before confirmation.

### SelectionSession

Tracks the in-progress weekly draw. Not persisted.

| Field | Type | Notes |
|-------|------|-------|
| `poolId` | `String` | Which pool is being selected from |
| `drawnStickIds` | `List<String>` | Sticks currently drawn (up to 5) |
| `discardedStickIds` | `Set<String>` | Sticks discarded this session; excluded from all further draws |
| `availableStickIds` | `List<String>` | Remaining eligible sticks (pool − drawn − discarded) |

**Business rules**:
- A discarded Stick is moved from `drawnStickIds` to `discardedStickIds` and is never re-eligible within this session.
- If `availableStickIds` is empty and the user tries to discard, the app informs the user that all eligible sticks have been used and they must confirm the current set or cancel.
- If the app is force-closed, `SelectionSession` is discarded; the previous WeeklyBin (if any) is unchanged.

---

## Entity Relationships

```
Pool ─────────────────────── Stick
 │  (1 pool : N sticks)       │
 │                             │
 └──── WeeklyBin ─────────────┘
       (references Sticks by externalId,
        does NOT own them)
```

---

## Validation Rules Summary

| Entity | Field | Rule |
|--------|-------|------|
| Pool | `name` | Non-empty; unique case-insensitively across all Pools |
| Pool | (delete) | Auto-create "Dinner" pool if last pool deleted |
| Stick | `name` | Non-empty; unique case-insensitively within same Pool |
| WeeklyBin | `stickIds` | Max length = Pool.sticks.count; min = 1 (all-empty bins are deleted) |
| WeeklyBin | `doneStickIds` | Must be a subset of `stickIds` |
| SelectionSession | `drawnStickIds` | Max 5; no element in `discardedStickIds` |

---

## Storage Schema (Isar Collections)

```dart
// domain/entities — plain Dart classes (no Isar annotations)
class Pool     { String externalId; String name; DateTime createdAt; }
class Stick    { String externalId; String poolId; String name; DateTime createdAt; }
class WeeklyBin {
  String poolId;
  List<String> stickIds;
  List<String> doneStickIds;
  DateTime createdAt;
  DateTime updatedAt;
}

// data/models — Isar-annotated models (data layer only)
@collection class PoolModel     { ... }
@collection class StickModel    { ... }
@collection class WeeklyBinModel { ... }
```

Isar `@Index` annotations:
- `PoolModel.name` — `@Index(unique: true, caseSensitive: false)`
- `StickModel.poolId` — `@Index()`
- `StickModel.name` + `poolId` — composite `@Index(unique: true, caseSensitive: false)`
- `WeeklyBinModel.poolId` — `@Index(unique: true)`
