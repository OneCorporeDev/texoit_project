import 'package:client/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/use_cases/get_years_with_multiple_winners_use_case.dart';

import '../../../core/test_setup.dart';
import 'get_movies_by_year_use_case_test.dart';

void main() {
  final MovieRepo repo = MockMovieRepoImpl();
  final GetYearsWithMultipleWinners useCase = GetYearsWithMultipleWinners(repo: repo);

  group('GetWinnersByYearsUseCase', () {
    setUpAll(() async {
      await testSetup();
    });

    group('err', () {
      test('should return err when repo gets err', () async {
        // arrange
        when(() => repo.getYearsWithMultipleWinners())
            .thenAnswer((_) async => const Err(ServerFailure(message: 'error')));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });

      test('should return specific error on specific failure', () async {
        // arrange
        const failure = ServerFailure(message: 'Specific error');
        when(() => repo.getYearsWithMultipleWinners()).thenAnswer((_) async => const Err(failure));
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
        when(() => repo.getYearsWithMultipleWinners()).thenAnswer((_) async => const Ok([]));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List<YearWinner>>());
        expect(response.ok, isEmpty);
      });

      test('should return a list of YearWinner when repo gets Ok', () async {
        // arrange
        when(() => repo.getYearsWithMultipleWinners())
            .thenAnswer((_) async => Ok([YearWinner.empty(), YearWinner.empty()]));
        // act
        final response = await useCase.call(NoParams());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List<YearWinner>>());
        expect(response.ok, isNotEmpty);
        expect(response.ok[0], isA<YearWinner>());
      });
    });
  });
}
