import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final createdAt = DateTime(2024);

  group('Stick', () {
    group('constructor', () {
      test('trims whitespace from name', () {
        final stick = Stick(
          externalId: 'x',
          poolId: 'p',
          name: '  Pasta  ',
          createdAt: createdAt,
        );
        expect(stick.name, 'Pasta');
      });

      test('rejects empty name', () {
        expect(
          () => Stick(
            externalId: 'x',
            poolId: 'p',
            name: '',
            createdAt: createdAt,
          ),
          throwsAssertionError,
        );
      });

      test('rejects whitespace-only name', () {
        expect(
          () => Stick(
            externalId: 'x',
            poolId: 'p',
            name: '   ',
            createdAt: createdAt,
          ),
          throwsAssertionError,
        );
      });

      test('accepts valid name unchanged after trim', () {
        final stick = Stick(
          externalId: 'x',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        expect(stick.name, 'Pasta');
      });
    });

    group('equality', () {
      test('equal when externalIds match', () {
        final a = Stick(
          externalId: 'same',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        final b = Stick(
          externalId: 'same',
          poolId: 'p',
          name: 'Pizza',
          createdAt: createdAt,
        );
        expect(a, equals(b));
      });

      test('not equal when externalIds differ', () {
        final a = Stick(
          externalId: 'a',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        final b = Stick(
          externalId: 'b',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        expect(a, isNot(equals(b)));
      });

      test('hashCode matches for equal sticks', () {
        final a = Stick(
          externalId: 'same',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        final b = Stick(
          externalId: 'same',
          poolId: 'p',
          name: 'Pizza',
          createdAt: createdAt,
        );
        expect(a.hashCode, equals(b.hashCode));
      });
    });

    group('copyWith', () {
      test('returns copy with replaced name', () {
        final original = Stick(
          externalId: 'x',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        final copy = original.copyWith(name: 'Pizza');
        expect(copy.name, 'Pizza');
        expect(copy.externalId, 'x');
        expect(copy.poolId, 'p');
      });

      test('returns copy with all original values when no args', () {
        final original = Stick(
          externalId: 'x',
          poolId: 'p',
          name: 'Pasta',
          createdAt: createdAt,
        );
        final copy = original.copyWith();
        expect(copy.externalId, original.externalId);
        expect(copy.poolId, original.poolId);
        expect(copy.name, original.name);
        expect(copy.createdAt, original.createdAt);
      });
    });
  });
}
