import 'package:dinner_sticks/domain/entities/pool.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024);

  final pool = Pool(
    externalId: 'p1',
    name: 'Dinner',
    createdAt: createdAt,
  );

  group('Pool equality', () {
    test('equal when externalIds match regardless of name', () {
      final other = Pool(
        externalId: 'p1',
        name: 'Different',
        createdAt: DateTime(2025),
      );
      expect(pool, equals(other));
    });

    test('not equal when externalIds differ', () {
      final other = Pool(
        externalId: 'p2',
        name: 'Dinner',
        createdAt: createdAt,
      );
      expect(pool, isNot(equals(other)));
    });

    test('identical reference equals itself', () {
      expect(pool, equals(pool));
    });

    test('hashCode matches for equal pools', () {
      final other = Pool(externalId: 'p1', name: 'X', createdAt: createdAt);
      expect(pool.hashCode, equals(other.hashCode));
    });

    test('not equal to non-Pool object', () {
      // ignore: unrelated_type_equality_checks
      expect(pool == 'p1', isFalse);
    });
  });

  group('Pool copyWith', () {
    test('returns copy with replaced externalId', () {
      final copy = pool.copyWith(externalId: 'p2');
      expect(copy.externalId, 'p2');
      expect(copy.name, 'Dinner');
    });

    test('returns copy with replaced name', () {
      final copy = pool.copyWith(name: 'Lunch');
      expect(copy.name, 'Lunch');
      expect(copy.externalId, 'p1');
    });

    test('returns copy with replaced createdAt', () {
      final newDate = DateTime(2025);
      final copy = pool.copyWith(createdAt: newDate);
      expect(copy.createdAt, newDate);
    });

    test('returns identical values when no args supplied', () {
      final copy = pool.copyWith();
      expect(copy.externalId, pool.externalId);
      expect(copy.name, pool.name);
      expect(copy.createdAt, pool.createdAt);
    });
  });

  test('toString contains externalId and name', () {
    expect(pool.toString(), contains('p1'));
    expect(pool.toString(), contains('Dinner'));
  });
}
