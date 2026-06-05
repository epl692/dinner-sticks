import 'package:dinner_sticks/domain/entities/weekly_bin.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024);

  final bin = WeeklyBin(
    poolId: 'pool-1',
    stickIds: const ['s1', 's2'],
    doneStickIds: const [],
    createdAt: createdAt,
    updatedAt: createdAt,
  );

  group('WeeklyBin equality', () {
    test('equal when poolIds match', () {
      final other = WeeklyBin(
        poolId: 'pool-1',
        stickIds: const ['s3'],
        doneStickIds: const [],
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );
      expect(bin, equals(other));
    });

    test('not equal when poolIds differ', () {
      final other = WeeklyBin(
        poolId: 'pool-2',
        stickIds: const ['s1', 's2'],
        doneStickIds: const [],
        createdAt: createdAt,
        updatedAt: createdAt,
      );
      expect(bin, isNot(equals(other)));
    });

    test('identical reference equals itself', () {
      expect(bin, equals(bin));
    });

    test('hashCode matches for equal bins', () {
      final other = WeeklyBin(
        poolId: 'pool-1',
        stickIds: const [],
        doneStickIds: const [],
        createdAt: DateTime(2025),
        updatedAt: DateTime(2025),
      );
      expect(bin.hashCode, equals(other.hashCode));
    });

    test('not equal to non-WeeklyBin object', () {
      // ignore: unrelated_type_equality_checks
      expect(bin == 'pool-1', isFalse);
    });
  });

  group('WeeklyBin copyWith', () {
    test('returns copy with replaced poolId', () {
      final copy = bin.copyWith(poolId: 'pool-2');
      expect(copy.poolId, 'pool-2');
      expect(copy.stickIds, bin.stickIds);
    });

    test('returns copy with replaced stickIds', () {
      final copy = bin.copyWith(stickIds: ['s3']);
      expect(copy.stickIds, ['s3']);
      expect(copy.poolId, 'pool-1');
    });

    test('returns copy with replaced doneStickIds', () {
      final copy = bin.copyWith(doneStickIds: ['s1']);
      expect(copy.doneStickIds, ['s1']);
    });

    test('returns copy with replaced dates', () {
      final newDate = DateTime(2025);
      final copy = bin.copyWith(createdAt: newDate, updatedAt: newDate);
      expect(copy.createdAt, newDate);
      expect(copy.updatedAt, newDate);
    });

    test('returns identical values when no args supplied', () {
      final copy = bin.copyWith();
      expect(copy.poolId, bin.poolId);
      expect(copy.stickIds, bin.stickIds);
      expect(copy.doneStickIds, bin.doneStickIds);
    });
  });

  test('toString contains poolId and stickIds', () {
    expect(bin.toString(), contains('pool-1'));
    expect(bin.toString(), contains('s1'));
  });
}
