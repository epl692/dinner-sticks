import 'package:dinner_sticks/domain/entities/selection_session.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SelectionSession', () {
    test('discard moves stickId from drawnStickIds to discardedStickIds', () {
      final session = SelectionSession(
        poolId: 'pool-1',
        availableStickIds: ['a', 'b', 'c', 'd', 'e'],
      );
      for (var i = 0; i < 5; i++) {
        session.drawNext();
      }
      final drawn = session.drawnStickIds.first;

      session.discard(drawn);

      expect(session.drawnStickIds, isNot(contains(drawn)));
      expect(session.discardedStickIds, contains(drawn));
    });

    test('discarded stickId is never returned by subsequent drawNext calls',
        () {
      final session = SelectionSession(
        poolId: 'pool-1',
        availableStickIds: ['a', 'b', 'c', 'd', 'e', 'f'],
      );
      for (var i = 0; i < 5; i++) {
        session.drawNext();
      }
      final discardedId = session.drawnStickIds.first;

      session.discard(discardedId);
      final next = session.drawNext();

      expect(next, isNotNull);
      expect(next, isNot(equals(discardedId)));
      expect(session.availableStickIds, isEmpty);
    });

    test('drawNext returns null when no sticks available', () {
      final session = SelectionSession(
        poolId: 'pool-1',
        availableStickIds: [],
      );

      expect(session.drawNext(), isNull);
    });

    test('pool with fewer than 5 sticks only draws available count', () {
      final session = SelectionSession(
        poolId: 'pool-1',
        availableStickIds: ['a', 'b', 'c'],
      );

      for (var i = 0; i < 3; i++) {
        session.drawNext();
      }

      expect(session.drawnStickIds.length, 3);
      expect(session.drawNext(), isNull);
    });
  });
}
