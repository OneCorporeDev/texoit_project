import 'package:client/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/use_cases/get_winners_by_studios_use_case.dart';

import '../../../core/test_setup.dart';
import 'get_movies_by_year_use_case_test.dart';

void main() {
  final MovieRepo repo = MockMovieRepoImpl();
  final GetWinnersByStudioUseCase useCase = GetWinnersByStudioUseCase(repo: repo);

  group('GetWinnersByStudioUseCase', () {
    setUpAll(() async {
      await testSetup();
    });

    group('err', () {
      test('should return err when repo gets err', () async {
        // arrange
        when(() => repo.getWinnersByStudios()).thenAnswer((_) async => const Err(ServerFailure(message: 'error')));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });

      test('should return specific error on specific failure', () async {
        // arrange
        const failure = ServerFailure(message: 'Specific error');
        when(() => repo.getWinnersByStudios()).thenAnswer((_) async => const Err(failure));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Err>());
        expect(response.err, equals(failure));
      });
    });

    group('Ok', () {
      test('should return Ok when repo gets Ok', () async {
        // arrange
        when(() => repo.getWinnersByStudios()).thenAnswer((_) async => const Ok([]));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List<StudioWinner>>());
        expect(response.ok, isEmpty);
      });

      test('should return a list of StudioWinner when repo gets Ok', () async {
        // arrange
        when(() => repo.getWinnersByStudios())
            .thenAnswer((_) async => Ok([StudioWinner.empty(), StudioWinner.empty()]));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List<StudioWinner>>());
        expect(response.ok, isNotEmpty);
        expect(response.ok[0], isA<StudioWinner>());
      });
    });
  });
}
