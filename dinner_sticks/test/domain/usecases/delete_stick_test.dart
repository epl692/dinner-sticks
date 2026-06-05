import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/stick/delete_stick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'delete_stick_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late DeleteStick useCase;

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = DeleteStick(repository: mockRepo);
  });

  test('delegates to repository', () async {
    when(mockRepo.deleteStick('stick-1')).thenAnswer((_) async {});

    await useCase(stickId: 'stick-1');

    verify(mockRepo.deleteStick('stick-1')).called(1);
  });

  test('propagates StickNotFoundFailure from repository', () async {
    when(mockRepo.deleteStick('bad-id'))
        .thenThrow(const StickNotFoundFailure('bad-id'));

    await expectLater(
      useCase(stickId: 'bad-id'),
      throwsA(isA<StickNotFoundFailure>()),
    );
  });
}
