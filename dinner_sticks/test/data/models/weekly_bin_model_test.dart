import 'package:dinner_sticks/data/models/weekly_bin_model.dart';
import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024);
  final updatedAt = DateTime(2024, 1, 15);

  final entity = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s1', 's2', 's3'],
    doneStickIds: const ['s1'],
    createdAt: createdAt,
    updatedAt: updatedAt,
  );

  group('WeeklyBinModel.fromEntity', () {
    test('sets all fields from entity', () {
      final model = WeeklyBinModel.fromEntity(entity);

      expect(model.poolId, 'pool-1');
      expect(model.stickIds, ['s1', 's2', 's3']);
      expect(model.doneStickIds, ['s1']);
      expect(model.createdAt, createdAt);
      expect(model.updatedAt, updatedAt);
    });

    test('creates independent copy of stickIds list', () {
      final model = WeeklyBinModel.fromEntity(entity);
      model.stickIds.add('s4');

      expect(entity.stickIds, hasLength(3));
    });
  });

  group('WeeklyBinModel.toEntity', () {
    test('converts model to entity with matching fields', () {
      final model = WeeklyBinModel.fromEntity(entity);
      final result = model.toEntity();

      expect(result.poolId, entity.poolId);
      expect(result.stickIds, entity.stickIds);
      expect(result.doneStickIds, entity.doneStickIds);
      expect(result.createdAt, entity.createdAt);
      expect(result.updatedAt, entity.updatedAt);
    });

    test('round-trip preserves all fields', () {
      final model = WeeklyBinModel.fromEntity(entity);
      final roundTripped = model.toEntity();

      expect(roundTripped, equals(entity));
    });

    test('creates independent copy of stickIds list', () {
      final model = WeeklyBinModel.fromEntity(entity);
      final result = model.toEntity();

      model.stickIds.add('s99');
      expect(result.stickIds, hasLength(3));
    });
  });
}
