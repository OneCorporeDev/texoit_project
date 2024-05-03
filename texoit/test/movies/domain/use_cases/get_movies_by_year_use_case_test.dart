import 'package:client/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/data/repo_impls/movie_repo_impl.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/use_cases/get_movies_by_year_use_case.dart';

import '../../../core/test_setup.dart';

class MockMovieRepoImpl extends Mock implements MovieRepoImpl {}

void main() {
  final MovieRepo repo = MockMovieRepoImpl();
  final GetMoviesByYearUseCase useCase = GetMoviesByYearUseCase(repo: repo);
  group('GetMoviesByYearUseCase', () {
    setUpAll(() async {
      await testSetup();
      registerFallbackValue(MovieByYearRequest.empty());
    });
    // group of test of method method
    group('err', () {
      test('should return err when repo gets err', () async {
        // arrange
        when(() => repo.getMoviesByYear(any())).thenAnswer((_) async => const Err(ServerFailure(message: 'error')));
        // act
        final response = await useCase.call(MovieByYearRequest.empty());
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });
      test('should return specific error on specific failure', () async {
        // arrange
        const failure = ServerFailure(message: 'Specific error');
        when(() => repo.getMoviesByYear(any())).thenAnswer((_) async => const Err(failure));
        // act
        final response = await useCase.call(MovieByYearRequest.empty());
        // assert
        expect(response, isA<Err>());
        expect(response.err, equals(failure));
      });
    });
    group('Ok', () {
      test('should call getMoviesByYear only once', () async {
        // arrange
        final request = MovieByYearRequest(year: 2022);
        when(() => repo.getMoviesByYear(request)).thenAnswer((_) async => const Ok([]));
        // act
        await useCase.call(request);
        // assert
        verify(() => repo.getMoviesByYear(request)).called(1);
      });
      test('should return Ok when repo gets Ok', () async {
        // arrange
        when(() => repo.getMoviesByYear(any())).thenAnswer((_) async => const Ok([]));
        // act
        final response = await useCase.call(MovieByYearRequest.empty());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List>());
        expect(response.ok, isEmpty);
      });

      test('should return a list of movies when repo gets Ok', () async {
        // arrange
        when(() => repo.getMoviesByYear(any())).thenAnswer((_) async => Ok([Movie.empty(), Movie.empty()]));
        // act
        final response = await useCase.call(MovieByYearRequest.empty());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<List>());
        expect(response.ok, isNotEmpty);
        expect(response.ok[0], isA<Movie>());
      });
    });
  });
}
