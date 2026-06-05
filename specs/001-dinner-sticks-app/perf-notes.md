# Performance Notes — Cold Start Profiling

Date: 2026-06-05  
Environment: Docker devcontainer (Linux x86_64), no physical device or Android emulator available

## Methodology

Full `flutter run --profile` profiling requires a connected device or running emulator.
Neither was available in this environment. Notes below capture:
1. Static analysis of the startup path.
2. Theoretical estimates based on the app's dependency graph.
3. Recommendations for profiling when a device is available.

---

## Static Startup Path Analysis

```
main() → runApp(ProviderScope(child: MaterialApp(...)))
  ├── Riverpod ProviderScope initialises lazily — no blocking work at startup
  ├── MaterialApp localization delegates registered (flutter_localizations, intl)
  └── HomeScreen rendered
        └── activePoolProvider (FutureProvider)
              └── poolRepositoryProvider (FutureProvider)
                    └── Isar.open([PoolModelSchema, StickModelSchema, WeeklyBinModelSchema])
                          └── libisar.so loaded via dart:ffi (first open ~100–300 ms estimate)
```

### Key Observations

| Step | Estimated Cost | Notes |
|------|---------------|-------|
| Dart VM + Flutter engine init | ~300–600 ms | Platform-dependent; engine is pre-warmed on Android |
| `Isar.open(...)` (first call) | ~50–150 ms | Loads native lib, creates/opens DB file |
| `activePoolProvider` resolution | ~5–20 ms | Single Isar query for all pools |
| `weeklyBinProvider` stream setup | ~1–5 ms | Isar watch subscription, no blocking |
| First frame render | ~5–15 ms | Simple list or `EmptyBinPrompt` |

### Total Estimated Time-to-Interactive
~400–800 ms on a mid-range Android device (API 29+).

This is well within the 1-second perceptible-delay threshold for most users.

---

## Splash Screen / Loading State

While `activePoolProvider` is loading, `HomeScreen` renders a `CircularProgressIndicator` centred on a `Scaffold`. No blank white frame is shown, so there is no perceived jank at startup.

---

## Recommendations for Live Profiling

When a physical device or emulator becomes available:

```bash
# Profile build (disable Dart AOT asserts, enable timeline)
flutter run --profile

# Then in DevTools (opened automatically):
# 1. Performance tab → Record → launch app
# 2. Look for "Isar.open" frame spike in UI thread timeline
# 3. Target: first meaningful frame < 1 s on mid-range device
```

Key metrics to capture:
- **Time to first frame** (Flutter DevTools > Performance > Frame chart)
- **Time to interactive** (after Isar resolves and list/prompt is painted)
- **Isar.open duration** (visible as async gap in CPU profiler)

---

## Potential Optimisations (if profiling reveals issues)

1. **Isar lazy init**: `poolRepositoryProvider` already uses `FutureProvider`, so the DB opens on demand, not at app start. No change needed.
2. **Splash screen**: Add a native Android splash screen via `flutter_native_splash` to hide the engine init period if startup feel is poor on low-end devices.
3. **Isolate for Isar open**: If `Isar.open` blocks the UI thread noticeably, move it to a background isolate via `compute()`. Currently not needed based on estimates.
