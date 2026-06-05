import 'dart:math';

/// Tracks the in-progress weekly draw for a single pool.
///
/// This is a transient, in-memory object — it is never persisted. If the app
/// is force-closed before [drawnStickIds] are confirmed, the previous
/// WeeklyBin (if any) is unchanged.
class SelectionSession {
  /// Creates a [SelectionSession] for [poolId] with the given
  /// [availableStickIds] as the initial draw pool.
  SelectionSession({
    required this.poolId,
    required List<String> availableStickIds,
  })  : drawnStickIds = [],
        discardedStickIds = {},
        _availableStickIds = List<String>.from(availableStickIds),
        _random = Random();

  /// The pool being selected from.
  final String poolId;

  /// Sticks currently drawn (up to 5).
  final List<String> drawnStickIds;

  /// Sticks discarded this session; never eligible for re-draw.
  final Set<String> discardedStickIds;

  final List<String> _availableStickIds;
  final Random _random;

  /// Remaining eligible sticks (original pool minus drawn and discarded).
  List<String> get availableStickIds => List.unmodifiable(_availableStickIds);

  /// Moves [stickId] from [drawnStickIds] into [discardedStickIds].
  ///
  /// Has no effect if [stickId] is not currently in [drawnStickIds].
  void discard(String stickId) {
    drawnStickIds.remove(stickId);
    discardedStickIds.add(stickId);
  }

  /// Draws one stick at random from [availableStickIds] and adds it to
  /// [drawnStickIds].
  ///
  /// Returns the drawn stick's externalId, or `null` if no sticks remain.
  String? drawNext() {
    if (_availableStickIds.isEmpty) return null;
    final index = _random.nextInt(_availableStickIds.length);
    final stickId = _availableStickIds.removeAt(index);
    drawnStickIds.add(stickId);
    return stickId;
  }
}
