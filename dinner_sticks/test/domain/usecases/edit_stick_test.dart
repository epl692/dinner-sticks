import 'package:dinner_sticks/domain/entities/stick.dart';
import 'package:dinner_sticks/domain/failures.dart';
import 'package:dinner_sticks/domain/repositories/pool_repository.dart';
import 'package:dinner_sticks/domain/usecases/stick/edit_stick.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'edit_stick_test.mocks.dart';

@GenerateMocks([PoolRepository])
void main() {
  late MockPoolRepository mockRepo;
  late EditStick useCase;

  final createdAt = DateTime(2024);

  setUp(() {
    mockRepo = MockPoolRepository();
    useCase = EditStick(repository: mockRepo);
  });

  test('calls repository with trimmed name', () async {
    final expected = Stick(
      externalId: 'stick-1',
      poolId: 'pool-1',
      name: 'Pizza',
      createdAt: createdAt,
    );
    when(mockRepo.editStick('stick-1', 'Pizza'))
        .thenAnswer((_) async => expected);

    final result = await useCase(stickId: 'stick-1', newName: '  Pizza  ');

    expect(result, expected);
    verify(mockRepo.editStick('stick-1', 'Pizza')).called(1);
  });

  test('throws ArgumentError for empty name', () async {
    await expectLater(
      useCase(stickId: 'stick-1', newName: ''),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('throws ArgumentError for whitespace-only name', () async {
    await expectLater(
      useCase(stickId: 'stick-1', newName: '   '),
      throwsA(isA<ArgumentError>()),
    );
    verifyZeroInteractions(mockRepo);
  });

  test('propagates DuplicateNameFailure from repository', () async {
    when(mockRepo.editStick('stick-1', 'Pizza'))
        .thenThrow(const DuplicateNameFailure('Pizza'));

    await expectLater(
      useCase(stickId: 'stick-1', newName: 'Pizza'),
      throwsA(isA<DuplicateNameFailure>()),
    );
  });

  test('propagates StickNotFoundFailure from repository', () async {
    when(mockRepo.editStick('bad-id', 'Pizza'))
        .thenThrow(const StickNotFoundFailure('bad-id'));

    await expectLater(
      useCase(stickId: 'bad-id', newName: 'Pizza'),
      throwsA(isA<StickNotFoundFailure>()),
    );
  });
}
