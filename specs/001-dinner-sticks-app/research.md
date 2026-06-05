# Research: Dinner Sticks App

**Phase**: 0 | **Branch**: `001-dinner-sticks-app` | **Date**: 2026-06-05

---

## Decision 1: Framework — Flutter

**Decision**: Use Flutter (Dart) as the cross-platform mobile framework.

**Rationale**:
- AOT-compiled to native code: reliably hits 60fps and <2s cold start on 2019 mid-range hardware; React Native's JS bridge introduces overhead that requires active tuning to achieve the same targets.
- First-class `Semantics` widget layer maps directly to platform accessibility APIs (TalkBack, VoiceOver), satisfying the WCAG 2.1 AA constitution requirement with less ceremony than React Native's grafted `accessibilityProps`.
- Unified testing ecosystem (`test`, `flutter_test`, `integration_test`, `mockito`) covers all four test layers (unit, widget, integration, E2E) from one toolchain; React Native splits across Jest, RNTL, and Detox.
- Clean Architecture maps cleanly to Dart packages; layer boundaries can be enforced at the Dart package level.
- Official Docker images (`cirrusci/flutter` / community images) give a reproducible Android dev container; iOS compilation still requires macOS (GitHub Actions `macos-latest` runner for CI).

**Alternatives considered**:
- React Native: Larger community, TypeScript familiarity, but bridge overhead, split testing stack, and weaker accessibility defaults make it the inferior choice for this constitution.
- Kotlin Multiplatform Mobile: Shares business logic but requires separate UIs per platform — rules itself out for a solo-developer cross-platform app.

---

## Decision 2: Local Persistence — Isar

**Decision**: Use [Isar](https://isar.dev) as the local database.

**Rationale**:
- Isar is a Flutter-native, type-safe, reactive NoSQL database with full ACID transaction support. For a three-entity model (Pool, Stick, WeeklyBin) with referential constraints (bin references stick by ID), ACID guarantees prevent partial-write corruption during weekly bin confirmation.
- Isar generates strongly-typed accessor code from annotations, eliminating string-based query errors.
- Built-in reactive `Stream` support integrates directly with Riverpod `StreamProvider`, enabling the presentation layer to react to data changes without extra plumbing.
- Zero external native dependencies (compiled into the app); no native build scripts to maintain in the Docker container.
- Schema migrations are supported; the data model can evolve in future versions.

**Alternatives considered**:
- Hive: Simpler API, but no ACID transactions and no typed schema enforcement — risky for bin/stick referential integrity.
- SQLite (`sqflite`): Fully relational, but requires manual schema migrations and hand-written SQL; unnecessary complexity for a 3-entity model.
- SharedPreferences / MMKV: Key-value only; cannot efficiently model pool-to-stick or bin-to-stick relationships.

---

## Decision 3: State Management — Riverpod 2.x

**Decision**: Use [Riverpod 2.x](https://riverpod.dev) (`flutter_riverpod` + `riverpod_annotation`) for state management.

**Rationale**:
- Riverpod's `AsyncNotifierProvider` and `StreamProvider` are DI-friendly and testable in isolation without `BuildContext`, satisfying Clean Architecture's requirement that domain use-cases be decoupled from the UI framework.
- Providers are defined globally but scoped by the DI graph; easy to override in tests with mock repositories.
- `riverpod_annotation` + code generation reduces boilerplate while keeping providers type-safe.
- `ProviderObserver` allows easy state logging during development.

**Alternatives considered**:
- Bloc: Mature and widely used, but significantly more verbose (events, states, cubits); overhead not justified for this app's modest state surface.
- GetX: Couples presentation and logic too tightly; violates Clean Architecture layer separation.
- Provider (the package): Superceded by Riverpod; inferior testability.

---

## Decision 4: Testing Stack

**Decision**: `flutter_test` + `test` + `mockito` + `integration_test` + `very_good_analysis` lint ruleset.

| Layer | Tool | Scope |
|-------|------|-------|
| Unit | `test` | Domain entities, use-cases, pure logic |
| Repository | `test` + `mockito` | Data layer against mock datasources |
| Widget | `flutter_test` | Individual UI widgets in isolation |
| Integration | `integration_test` | P1 flows on emulator/device with real Isar |
| E2E | `integration_test` | Full user journeys (add → select → pick) |

Coverage target: ≥80% for `domain/` and `data/` (enforced by CI with `flutter test --coverage`).

**Alternatives considered**: Patrol (E2E) — useful for native interactions but adds complexity; defer to post-v1 if needed.

---

## Decision 5: Docker Dev Container (Android)

**Decision**: Provide a `.devcontainer/Dockerfile` with Flutter SDK + Android SDK for Android development and testing. iOS builds run on GitHub Actions `macos-latest`.

**Rationale**:
- The Flutter Android toolchain (Dart SDK, Android SDK, `flutter` CLI) is fully Linux-compatible and works inside Docker.
- A dev container ensures every contributor uses identical SDK versions, eliminating "works on my machine" issues.
- iOS compilation requires a macOS host and cannot be containerized; this is a fundamental Apple toolchain constraint, not a workaround.
- GitHub Actions provides `macos-latest` runners; iOS CI builds are handled there.

**Dev container contents**: `ghcr.io/cirruslabs/flutter` base image (or `instrumentisto/flutter`), Android SDK platform + build-tools pinned to versions matching `android/app/build.gradle`, `adb` for emulator interaction.

**Alternatives considered**: Gitpod / Codespaces — viable but heavier; a simple Dockerfile is more portable and doesn't require a cloud IDE.

---

## Resolved NEEDS CLARIFICATION

| Item | Resolution |
|------|-----------|
| Language/Version | Dart 3.x (Flutter 3.x stable) |
| Primary Dependencies | `isar`, `isar_flutter_libs`, `flutter_riverpod`, `riverpod_annotation` |
| Storage | Isar (local, embedded, ACID) |
| Testing | `flutter_test`, `test`, `mockito`, `integration_test` |
| Target Platform | iOS 16+ and Android API 24+ (Flutter stable minimum) |
| Project Type | mobile-app (cross-platform Flutter) |
| Performance Goals | 60fps animations, <2s cold start on 2019 mid-range (Snapdragon 665 class) |
| Constraints | Offline-only, single device, no auth, WCAG 2.1 AA |
| Scale/Scope | Single user, ≤10 pools, ≤500 sticks total |
