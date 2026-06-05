import 'dart:io';
import 'dart:math';

import 'package:dinner_sticks/data/models/pool_model.dart';
import 'package:dinner_sticks/data/models/stick_model.dart';
import 'package:dinner_sticks/data/models/weekly_bin_model.dart';
import 'package:dinner_sticks/data/repositories/pool_repository_impl.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:isar/isar.dart';

void main() {
  late Isar isar;
  late PoolRepositoryImpl repo;
  final rng = Random();

  setUp(() async {
    final tempDir = Directory.systemTemp.createTempSync('isar_bin_test_');
    isar = await Isar.open(
      [PoolModelSchema, StickModelSchema, WeeklyBinModelSchema],
      directory: tempDir.path,
      name: 'test${rng.nextInt(1 << 30)}',
    );
    await isar.writeTxn(() async {
      await isar.poolModels.put(
        PoolModel()
          ..externalId = 'pool-1'
          ..name = 'Dinner'
          ..createdAt = DateTime(2024),
      );
    });
    repo = PoolRepositoryImpl(isar);
  });

  tearDown(() async {
    await isar.close(deleteFromDisk: true);
  });

  // ---------------------------------------------------------------------------
  // Pools
  // ---------------------------------------------------------------------------

  group('createPool', () {
    test('creates and returns a new pool', () async {
      final pool = await repo.createPool('Breakfast');

      expect(pool.name, 'Breakfast');
      expect(pool.externalId, isNotEmpty);

      final model = await isar.poolModels
          .filter()
          .externalIdEqualTo(pool.externalId)
          .findFirst();
      expect(model, isNotNull);
      expect(model!.name, 'Breakfast');
    });

    test('throws DuplicateNameFailure for case-insensitive duplicate',
        () async {
      await expectLater(
        repo.createPool('DINNER'),
        throwsA(isA<DuplicateNameFailure>()),
      );
    });
  });

  group('renamePool', () {
    test('renames pool to new name', () async {
      final renamed = await repo.renamePool('pool-1', 'Family Dinner');

      expect(renamed.name, 'Family Dinner');
      expect(renamed.externalId, 'pool-1');
    });

    test('throws PoolNotFoundFailure for unknown poolId', () async {
      await expectLater(
        repo.renamePool('no-such-pool', 'X'),
        throwsA(isA<PoolNotFoundFailure>()),
      );
    });

    test('throws DuplicateNameFailure when renaming to existing pool name',
        () async {
      await repo.createPool('Lunch');

      await expectLater(
        repo.renamePool('pool-1', 'LUNCH'),
        throwsA(isA<DuplicateNameFailure>()),
      );
    });

    test('allows renaming to same name (case-only change)', () async {
      final renamed = await repo.renamePool('pool-1', 'DINNER');

      expect(renamed.name, 'DINNER');
    });
  });

  group('deletePool', () {
    test('deletes pool when multiple pools exist', () async {
      final lunch = await repo.createPool('Lunch');

      await repo.deletePool(lunch.externalId);

      final model = await isar.poolModels
          .filter()
          .externalIdEqualTo(lunch.externalId)
          .findFirst();
      expect(model, isNull);
    });

    test('throws PoolNotFoundFailure for unknown poolId', () async {
      await expectLater(
        repo.deletePool('no-such-pool'),
        throwsA(isA<PoolNotFoundFailure>()),
      );
    });

    test('auto-creates Dinner pool when deleting the last pool', () async {
      await repo.deletePool('pool-1');

      final pools = await isar.poolModels.where().findAll();
      expect(pools.length, 1);
      expect(pools.first.name, 'Dinner');
    });
  });

  // ---------------------------------------------------------------------------
  // Weekly Bin
  // ---------------------------------------------------------------------------

  group('getWeeklyBin', () {
    test('returns null when no bin exists for the pool', () async {
      final bin = await repo.getWeeklyBin('pool-1');
      expect(bin, isNull);
    });

    test('returns existing bin after confirmSelection', () async {
      await repo.confirmSelection('pool-1', ['s1', 's2']);

      final bin = await repo.getWeeklyBin('pool-1');
      expect(bin, isNotNull);
      expect(bin!.stickIds, containsAll(['s1', 's2']));
    });
  });

  group('watchWeeklyBin', () {
    test('emits null initially when no bin exists', () async {
      final bin = await repo.watchWeeklyBin('pool-1').first;
      expect(bin, isNull);
    });

    test('emits bin after confirmSelection', () async {
      await repo.confirmSelection('pool-1', ['s1']);

      final bin = await repo.watchWeeklyBin('pool-1').first;
      expect(bin, isNotNull);
      expect(bin!.stickIds, ['s1']);
    });
  });

  group('confirmSelection', () {
    test('creates a new bin with correct stickIds', () async {
      final bin = await repo.confirmSelection('pool-1', ['s1', 's2', 's3']);

      expect(bin.poolId, 'pool-1');
      expect(bin.stickIds, ['s1', 's2', 's3']);
      expect(bin.doneStickIds, isEmpty);
    });

    test('replaces an existing bin atomically', () async {
      await repo.confirmSelection('pool-1', ['s1', 's2']);
      final updated = await repo.confirmSelection('pool-1', ['s3', 's4']);

      expect(updated.stickIds, ['s3', 's4']);
      expect(updated.doneStickIds, isEmpty);

      final stored = await repo.getWeeklyBin('pool-1');
      expect(stored!.stickIds, ['s3', 's4']);
    });

    test('throws InsufficientSticksFailure for empty stickIds', () async {
      await expectLater(
        repo.confirmSelection('pool-1', []),
        throwsA(isA<InsufficientSticksFailure>()),
      );
    });
  });

  group('replaceBinStick', () {
    setUp(() async {
      await repo.confirmSelection('pool-1', ['s1', 's2', 's3']);
    });

    test('replaces oldStickId with newStickId in the bin', () async {
      final updated = await repo.replaceBinStick('pool-1', 's1', 's4');

      expect(updated.stickIds, containsAll(['s4', 's2', 's3']));
      expect(updated.stickIds, isNot(contains('s1')));
    });

    test('preserves order of other stickIds', () async {
      final updated = await repo.replaceBinStick('pool-1', 's2', 's9');

      expect(updated.stickIds[0], 's1');
      expect(updated.stickIds[1], 's9');
      expect(updated.stickIds[2], 's3');
    });

    test('throws StickNotFoundFailure when oldStickId not in bin', () async {
      await expectLater(
        repo.replaceBinStick('pool-1', 'no-such', 's4'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });

    test('throws StickNotFoundFailure when no bin exists', () async {
      await expectLater(
        repo.replaceBinStick('pool-2', 's1', 's4'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });
  });

  group('removeBinStick', () {
    setUp(() async {
      await repo.confirmSelection('pool-1', ['s1', 's2', 's3']);
    });

    test('removes stickId from the bin', () async {
      final updated = await repo.removeBinStick('pool-1', 's2');

      expect(updated.stickIds, ['s1', 's3']);
      expect(updated.stickIds, isNot(contains('s2')));
    });

    test('throws StickNotFoundFailure when stickId not in bin', () async {
      await expectLater(
        repo.removeBinStick('pool-1', 'no-such'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });
  });

  group('markStickDone', () {
    setUp(() async {
      await repo.confirmSelection('pool-1', ['s1', 's2', 's3']);
    });

    test('moves stickId from stickIds to doneStickIds', () async {
      final updated = await repo.markStickDone('pool-1', 's1');

      expect(updated.stickIds, isNot(contains('s1')));
      expect(updated.doneStickIds, contains('s1'));
    });

    test('preserves remaining stickIds', () async {
      final updated = await repo.markStickDone('pool-1', 's2');

      expect(updated.stickIds, containsAll(['s1', 's3']));
    });

    test('is idempotent for doneStickIds', () async {
      await repo.markStickDone('pool-1', 's1');
      final updated = await repo.markStickDone('pool-1', 's1');

      expect(updated.doneStickIds.where((id) => id == 's1').length, 1);
    });

    test('throws StickNotFoundFailure when stickId not in bin', () async {
      await expectLater(
        repo.markStickDone('pool-1', 'no-such'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });
  });
}
