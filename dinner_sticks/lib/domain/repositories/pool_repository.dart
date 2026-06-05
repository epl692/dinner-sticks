import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';

/// Abstract interface for all pool, stick, and weekly-bin persistence
/// operations.
///
/// Implementations live in the data layer; the domain layer depends only on
/// this interface, keeping it free of framework and storage concerns.
///
/// All `Future<T>` methods throw typed failures from `domain/failures.dart`
/// (e.g. [DuplicateNameFailure], [PoolNotFoundFailure]).
abstract class PoolRepository {
  // ---------------------------------------------------------------------------
  // Pools
  // ---------------------------------------------------------------------------

  /// Emits the full list of pools whenever any pool is added, renamed,
  /// or deleted.
  Stream<List<Pool>> watchAllPools();

  /// Creates a new pool with the given [name].
  ///
  /// Throws [DuplicateNameFailure] if a pool with the same name already exists
  /// (case-insensitive).
  Future<Pool> createPool(String name);

  /// Renames the pool identified by [poolId] to [newName].
  ///
  /// Throws [DuplicateNameFailure] if another pool has [newName].
  /// Throws [PoolNotFoundFailure] if no pool with [poolId] exists.
  Future<Pool> renamePool(String poolId, String newName);

  /// Deletes the pool identified by [poolId].
  ///
  /// If this is the last pool, a new "Dinner" pool is auto-created within the
  /// same transaction before the deletion completes.
  ///
  /// Throws [PoolNotFoundFailure] if no pool with [poolId] exists.
  Future<void> deletePool(String poolId);

  // ---------------------------------------------------------------------------
  // Sticks
  // ---------------------------------------------------------------------------

  /// Emits the list of sticks for [poolId] whenever any stick in that pool
  /// changes.
  Stream<List<Stick>> watchSticks(String poolId);

  /// Adds a new stick with the given [name] to pool [poolId].
  ///
  /// Throws [DuplicateNameFailure] if a stick with the same name already
  /// exists in this pool (case-insensitive).
  /// Throws [PoolNotFoundFailure] if no pool with [poolId] exists.
  Future<Stick> addStick(String poolId, String name);

  /// Renames the stick identified by [stickId] to [newName].
  ///
  /// Throws [DuplicateNameFailure] if a stick with [newName] already exists
  /// in the same pool.
  /// Throws [StickNotFoundFailure] if no stick with [stickId] exists.
  Future<Stick> editStick(String stickId, String newName);

  /// Deletes the stick identified by [stickId].
  ///
  /// If the stick is currently in a weekly bin, it is NOT removed from the bin
  /// — the bin retains the stale reference until the user removes or marks it
  /// done.
  ///
  /// Throws [StickNotFoundFailure] if no stick with [stickId] exists.
  Future<void> deleteStick(String stickId);

  // ---------------------------------------------------------------------------
  // Weekly Bin
  // ---------------------------------------------------------------------------

  /// Returns the current weekly bin for [poolId], or `null` if none exists.
  Future<WeeklyBin?> getWeeklyBin(String poolId);

  /// Emits the current weekly bin for [poolId] whenever it changes.
  ///
  /// Emits `null` when no bin exists.
  Stream<WeeklyBin?> watchWeeklyBin(String poolId);

  /// Saves [stickIds] as the weekly bin for [poolId], replacing any existing
  /// bin.
  ///
  /// Throws [InsufficientSticksFailure] if [stickIds] is empty.
  Future<WeeklyBin> confirmSelection(String poolId, List<String> stickIds);

  /// Replaces [oldStickId] in the bin with [newStickId].
  ///
  /// Throws [StickNotFoundFailure] if [oldStickId] is not in the bin.
  Future<WeeklyBin> replaceBinStick(
    String poolId,
    String oldStickId,
    String newStickId,
  );

  /// Removes [stickId] from the bin without deleting it from the pool.
  ///
  /// Throws [StickNotFoundFailure] if [stickId] is not in the bin.
  Future<WeeklyBin> removeBinStick(String poolId, String stickId);

  /// Marks [stickId] as done: removes it from `stickIds` and adds it to
  /// `doneStickIds` atomically.
  ///
  /// Throws [StickNotFoundFailure] if [stickId] is not in the bin.
  Future<WeeklyBin> markStickDone(String poolId, String stickId);
}
