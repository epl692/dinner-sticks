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
    final tempDir = Directory.systemTemp.createTempSync('isar_test_');
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

  group('addStick', () {
    test('persists stick to Isar', () async {
      final stick = await repo.addStick('pool-1', 'Pasta');

      expect(stick.name, 'Pasta');
      expect(stick.poolId, 'pool-1');

      final model = await isar.stickModels
          .filter()
          .externalIdEqualTo(stick.externalId)
          .findFirst();
      expect(model, isNotNull);
      expect(model!.name, 'Pasta');
    });

    test('throws DuplicateNameFailure for case-insensitive duplicate',
        () async {
      await repo.addStick('pool-1', 'Pasta');

      await expectLater(
        repo.addStick('pool-1', 'PASTA'),
        throwsA(isA<DuplicateNameFailure>()),
      );
    });
  });

  group('editStick', () {
    test('updates stick name in Isar', () async {
      final stick = await repo.addStick('pool-1', 'Pasta');
      final updated = await repo.editStick(stick.externalId, 'Pizza');

      expect(updated.name, 'Pizza');
      expect(updated.externalId, stick.externalId);
    });

    test('throws StickNotFoundFailure for unknown id', () async {
      await expectLater(
        repo.editStick('nonexistent', 'Pizza'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });

    test('throws DuplicateNameFailure when renaming to existing name',
        () async {
      await repo.addStick('pool-1', 'Pasta');
      final other = await repo.addStick('pool-1', 'Pizza');

      await expectLater(
        repo.editStick(other.externalId, 'PASTA'),
        throwsA(isA<DuplicateNameFailure>()),
      );
    });

    test('allows renaming to same name (case-only change)', () async {
      final stick = await repo.addStick('pool-1', 'pasta');
      final updated = await repo.editStick(stick.externalId, 'Pasta');

      expect(updated.name, 'Pasta');
    });
  });

  group('deleteStick', () {
    test('removes stick from Isar', () async {
      final stick = await repo.addStick('pool-1', 'Pasta');
      await repo.deleteStick(stick.externalId);

      final model = await isar.stickModels
          .filter()
          .externalIdEqualTo(stick.externalId)
          .findFirst();
      expect(model, isNull);
    });

    test('throws StickNotFoundFailure for unknown id', () async {
      await expectLater(
        repo.deleteStick('nonexistent'),
        throwsA(isA<StickNotFoundFailure>()),
      );
    });
  });

  group('watchSticks', () {
    test('emits current sticks for pool immediately', () async {
      await repo.addStick('pool-1', 'Pasta');
      await repo.addStick('pool-1', 'Pizza');

      final sticks = await repo.watchSticks('pool-1').first;
      expect(sticks.length, 2);
      expect(sticks.map((s) => s.name), containsAll(['Pasta', 'Pizza']));
    });

    test('emits empty list for pool with no sticks', () async {
      final sticks = await repo.watchSticks('pool-1').first;
      expect(sticks, isEmpty);
    });
  });

  group('watchAllPools', () {
    test('emits seeded Dinner pool immediately', () async {
      final pools = await repo.watchAllPools().first;
      expect(pools.length, 1);
      expect(pools.first.name, 'Dinner');
    });
  });
}
