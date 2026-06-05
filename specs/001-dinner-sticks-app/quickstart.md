# Quickstart: Dinner Sticks App

**Branch**: `001-dinner-sticks-app` | **Updated**: 2026-06-05

---

## Prerequisites

| Tool | Version | Notes |
|------|---------|-------|
| Flutter SDK | 3.x stable | Install via [flutter.dev](https://flutter.dev/docs/get-started/install) |
| Dart | 3.x (bundled with Flutter) | |
| Android Studio | Latest stable | For Android SDK + emulator |
| Xcode | 15+ | macOS only; for iOS simulator |
| Docker | 24+ | For reproducible Android dev container |

---

## Option A: Docker Dev Container (Recommended for Android)

The project ships a `.devcontainer/` config that bundles Flutter, Dart, and the Android SDK in a reproducible Linux container. This is the preferred setup.

```bash
# Open in VS Code with Dev Containers extension
code .
# → VS Code prompt: "Reopen in Container" → accept

# Or use the CLI directly:
docker compose -f .devcontainer/docker-compose.yml up -d
docker compose exec app bash
```

Once inside the container:
```bash
flutter pub get
flutter test                          # run unit + widget tests
flutter test integration_test/        # run integration tests (requires emulator)
```

> **iOS note**: iOS compilation requires a macOS host and cannot run inside Docker. Use the native setup below for iOS work, or rely on GitHub Actions CI (`macos-latest` runner) for iOS builds and tests.

---

## Option B: Native Setup

```bash
# 1. Install Flutter SDK and verify
flutter doctor -v

# 2. Install dependencies
flutter pub get

# 3. Run code generation (Isar + Riverpod annotations)
dart run build_runner build --delete-conflicting-outputs

# 4. Run all tests
flutter test

# 5. Run on a connected device or simulator
flutter run
```

---

## Running Tests

```bash
# Unit + widget tests
flutter test

# With coverage report
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html

# Integration tests (requires running emulator or device)
flutter test integration_test/app_test.dart -d <device-id>

# List available devices
flutter devices
```

Coverage must not fall below 80% for `lib/domain/` and `lib/data/` (enforced in CI).

---

## Project Structure

```
lib/
├── domain/           # Business logic — pure Dart, no framework deps
│   ├── entities/     # Pool, Stick, WeeklyBin
│   ├── repositories/ # Abstract interfaces (PoolRepository)
│   └── usecases/     # One class per operation
├── data/             # Isar implementations
│   ├── models/       # @collection annotated Isar models
│   ├── datasources/  # IsarLocalDataSource
│   └── repositories/ # PoolRepositoryImpl
├── presentation/     # Flutter UI
│   ├── screens/      # HomeScreen, PoolManagementScreen, WeeklySelectionScreen
│   ├── widgets/      # StickCard, BinStickTile, etc.
│   └── providers/    # Riverpod providers
└── main.dart

test/
├── domain/           # Unit tests for entities and use-cases
└── data/             # Repository tests with mock datasource

integration_test/     # P1 user journey tests
```

---

## Code Generation

Isar schema code and Riverpod provider annotations require build_runner:

```bash
# One-time generation
dart run build_runner build --delete-conflicting-outputs

# Watch mode during development
dart run build_runner watch --delete-conflicting-outputs
```

Generated files (`*.g.dart`, `*.isar.dart`) are committed to source control.

---

## Dependency Highlights

| Package | Purpose |
|---------|---------|
| `isar` + `isar_flutter_libs` | Local database (ACID, reactive) |
| `isar_generator` | Code generation for Isar schemas |
| `flutter_riverpod` | State management + DI |
| `riverpod_annotation` + `riverpod_generator` | Provider code generation |
| `uuid` | UUID v4 for `externalId` fields |
| `flutter_test` | Widget + unit tests (dev) |
| `mockito` + `build_runner` | Mock generation (dev) |
| `integration_test` | E2E tests (dev) |
| `very_good_analysis` | Lint ruleset (dev) |

---

## CI/CD

- **Android**: Docker-based build on Linux runner
- **iOS**: `macos-latest` GitHub Actions runner
- **Gates**: lint → type-check → unit tests → integration tests → coverage check (≥80%)
- **Release builds**: Signed exclusively by CI (no manual store uploads)
