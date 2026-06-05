import 'package:dinner_sticks/domain/failures.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('DuplicateNameFailure', () {
    test('implements Exception', () {
      expect(const DuplicateNameFailure('Pasta'), isA<Exception>());
    });

    test('toString contains the name', () {
      const f = DuplicateNameFailure('Pasta');
      expect(f.toString(), contains('Pasta'));
    });

    test('exposes the name field', () {
      const f = DuplicateNameFailure('Pizza');
      expect(f.name, 'Pizza');
    });
  });

  group('PoolNotFoundFailure', () {
    test('implements Exception', () {
      expect(const PoolNotFoundFailure('p1'), isA<Exception>());
    });

    test('toString contains the poolId', () {
      const f = PoolNotFoundFailure('pool-abc');
      expect(f.toString(), contains('pool-abc'));
    });

    test('exposes the poolId field', () {
      const f = PoolNotFoundFailure('p-1');
      expect(f.poolId, 'p-1');
    });
  });

  group('StickNotFoundFailure', () {
    test('implements Exception', () {
      expect(const StickNotFoundFailure('s1'), isA<Exception>());
    });

    test('toString contains the stickId', () {
      const f = StickNotFoundFailure('stick-xyz');
      expect(f.toString(), contains('stick-xyz'));
    });

    test('exposes the stickId field', () {
      const f = StickNotFoundFailure('s-1');
      expect(f.stickId, 's-1');
    });
  });

  group('InsufficientSticksFailure', () {
    test('implements Exception', () {
      expect(const InsufficientSticksFailure(), isA<Exception>());
    });

    test('toString is descriptive', () {
      const f = InsufficientSticksFailure();
      expect(f.toString(), isNotEmpty);
      expect(f.toString(), contains('Insufficient'));
    });
  });

  group('NoReplacementAvailableFailure', () {
    test('implements Exception', () {
      expect(const NoReplacementAvailableFailure(), isA<Exception>());
    });

    test('toString is descriptive', () {
      const f = NoReplacementAvailableFailure();
      expect(f.toString(), isNotEmpty);
      expect(f.toString(), contains('Replacement'));
    });
  });
}
