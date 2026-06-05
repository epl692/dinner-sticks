import 'package:dinner_sticks/data/models/pool_model.dart';
import 'package:dinner_sticks/data/models/stick_model.dart';
import 'package:dinner_sticks/data/models/weekly_bin_model.dart';
import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

/// Isar-backed implementation of [PoolRepository].
class PoolRepositoryImpl implements PoolRepository {
  /// Creates a [PoolRepositoryImpl] backed by [_isar].
  const PoolRepositoryImpl(this._isar);

  final Isar _isar;

  // ---------------------------------------------------------------------------
  // Pools
  // ---------------------------------------------------------------------------

  @override
  Stream<List<Pool>> watchAllPools() {
    return _isar.poolModels
        .where()
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Pool> createPool(String name) async {
    final existing = await _isar.poolModels.getByName(name);
    if (existing != null) throw DuplicateNameFailure(name);

    final model = PoolModel.fromEntity(
      Pool(
        externalId: const Uuid().v4(),
        name: name,
        createdAt: DateTime.now(),
      ),
    );
    await _isar.writeTxn(() => _isar.poolModels.put(model));
    return model.toEntity();
  }

  @override
  Future<Pool> renamePool(String poolId, String newName) async {
    final model = await _isar.poolModels
        .filter()
        .externalIdEqualTo(poolId)
        .findFirst();
    if (model == null) throw PoolNotFoundFailure(poolId);

    final duplicate = await _isar.poolModels.getByName(newName);
    if (duplicate != null && duplicate.externalId != poolId) {
      throw DuplicateNameFailure(newName);
    }

    model.name = newName;
    await _isar.writeTxn(() => _isar.poolModels.put(model));
    return model.toEntity();
  }

  @override
  Future<void> deletePool(String poolId) async {
    final model = await _isar.poolModels
        .filter()
        .externalIdEqualTo(poolId)
        .findFirst();
    if (model == null) throw PoolNotFoundFailure(poolId);

    final count = await _isar.poolModels.count();
    await _isar.writeTxn(() async {
      await _isar.poolModels.delete(model.id);
      if (count == 1) {
        await _isar.poolModels.put(
          PoolModel.fromEntity(
            Pool(
              externalId: const Uuid().v4(),
              name: 'Dinner',
              createdAt: DateTime.now(),
            ),
          ),
        );
      }
    });
  }

  // ---------------------------------------------------------------------------
  // Sticks
  // ---------------------------------------------------------------------------

  @override
  Stream<List<Stick>> watchSticks(String poolId) {
    return _isar.stickModels
        .filter()
        .poolIdEqualTo(poolId)
        .watch(fireImmediately: true)
        .map((models) => models.map((m) => m.toEntity()).toList());
  }

  @override
  Future<Stick> addStick(String poolId, String name) async {
    final existing = await _isar.stickModels.getByPoolIdName(poolId, name);
    if (existing != null) throw DuplicateNameFailure(name);

    final model = StickModel.fromEntity(
      Stick(
        externalId: const Uuid().v4(),
        poolId: poolId,
        name: name,
        createdAt: DateTime.now(),
      ),
    );
    await _isar.writeTxn(() => _isar.stickModels.put(model));
    return model.toEntity();
  }

  @override
  Future<Stick> editStick(String stickId, String newName) async {
    final model = await _isar.stickModels
        .filter()
        .externalIdEqualTo(stickId)
        .findFirst();
    if (model == null) throw StickNotFoundFailure(stickId);

    final duplicate =
        await _isar.stickModels.getByPoolIdName(model.poolId, newName);
    if (duplicate != null && duplicate.externalId != stickId) {
      throw DuplicateNameFailure(newName);
    }

    model.name = newName;
    await _isar.writeTxn(() => _isar.stickModels.put(model));
    return model.toEntity();
  }

  @override
  Future<void> deleteStick(String stickId) async {
    final model = await _isar.stickModels
        .filter()
        .externalIdEqualTo(stickId)
        .findFirst();
    if (model == null) throw StickNotFoundFailure(stickId);

    await _isar.writeTxn(() => _isar.stickModels.delete(model.id));
  }

  // ---------------------------------------------------------------------------
  // Weekly Bin
  // ---------------------------------------------------------------------------

  @override
  Future<WeeklyBin?> getWeeklyBin(String poolId) async {
    final model = await _isar.weeklyBinModels.getByPoolId(poolId);
    return model?.toEntity();
  }

  @override
  Stream<WeeklyBin?> watchWeeklyBin(String poolId) {
    return _isar.weeklyBinModels
        .filter()
        .poolIdEqualTo(poolId)
        .watch(fireImmediately: true)
        .map((models) => models.isEmpty ? null : models.first.toEntity());
  }

  @override
  Future<WeeklyBin> confirmSelection(
    String poolId,
    List<String> stickIds,
  ) async {
    if (stickIds.isEmpty) throw const InsufficientSticksFailure();
    final now = DateTime.now();

    final existing = await _isar.weeklyBinModels.getByPoolId(poolId);
    final WeeklyBinModel model;
    if (existing != null) {
      existing
        ..stickIds = List<String>.from(stickIds)
        ..doneStickIds = []
        ..updatedAt = now;
      model = existing;
    } else {
      model = WeeklyBinModel.fromEntity(
        WeeklyBin(
          poolId: poolId,
          stickIds: stickIds,
          doneStickIds: const [],
          createdAt: now,
          updatedAt: now,
        ),
      );
    }
    await _isar.writeTxn(() => _isar.weeklyBinModels.put(model));
    return model.toEntity();
  }

  @override
  Future<WeeklyBin> replaceBinStick(
    String poolId,
    String oldStickId,
    String newStickId,
  ) async {
    final model = await _isar.weeklyBinModels.getByPoolId(poolId);
    if (model == null || !model.stickIds.contains(oldStickId)) {
      throw StickNotFoundFailure(oldStickId);
    }

    model
      ..stickIds = model.stickIds
          .map((id) => id == oldStickId ? newStickId : id)
          .toList()
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.weeklyBinModels.put(model));
    return model.toEntity();
  }

  @override
  Future<WeeklyBin> removeBinStick(String poolId, String stickId) async {
    final model = await _isar.weeklyBinModels.getByPoolId(poolId);
    if (model == null || !model.stickIds.contains(stickId)) {
      throw StickNotFoundFailure(stickId);
    }

    model
      ..stickIds = model.stickIds.where((id) => id != stickId).toList()
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.weeklyBinModels.put(model));
    return model.toEntity();
  }

  @override
  Future<WeeklyBin> markStickDone(String poolId, String stickId) async {
    final model = await _isar.weeklyBinModels.getByPoolId(poolId);
    if (model == null) throw StickNotFoundFailure(stickId);
    if (model.doneStickIds.contains(stickId)) return model.toEntity();
    if (!model.stickIds.contains(stickId)) throw StickNotFoundFailure(stickId);

    model
      ..stickIds = model.stickIds.where((id) => id != stickId).toList()
      ..doneStickIds = [...model.doneStickIds, stickId]
      ..updatedAt = DateTime.now();
    await _isar.writeTxn(() => _isar.weeklyBinModels.put(model));
    return model.toEntity();
  }
}
