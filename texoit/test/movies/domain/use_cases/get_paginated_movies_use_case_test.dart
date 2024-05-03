import 'package:client/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';
import 'package:texoit/movies/domain/use_cases/get_paginated_movies_use_case.dart';

import '../../../core/test_setup.dart';
import 'get_movies_by_year_use_case_test.dart';

void main() {
  final MovieRepo repo = MockMovieRepoImpl();
  final GetPaginatedMoviesUseCase useCase = GetPaginatedMoviesUseCase(repo: repo);

  group('GetPaginatedMoviesUseCase', () {
    setUpAll(() async {
      await testSetup();
      registerFallbackValue(PaginatedMovieRequest.empty());
    });

    group('err', () {
      test('should return err when repo gets err', () async {
        // arrange
        when(() => repo.getPaginatedMovies(any())).thenAnswer((_) async => const Err(ServerFailure(message: 'error')));
        // act
        final response = await useCase.call(PaginatedMovieRequest.empty());
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });

      test('should return specific error on specific failure', () async {
        // arrange
        const failure = ServerFailure(message: 'Specific error');
        when(() => repo.getPaginatedMovies(any())).thenAnswer((_) async => const Err(failure));
        // act
        final response = await useCase.call(PaginatedMovieRequest.empty());
        // assert
        expect(response, isA<Err>());
        expect(response.err, equals(failure));
      });
    });

    group('Ok', () {
      test('should call getPaginatedMovies only once', () async {
        // arrange
        final request = PaginatedMovieRequest.empty();
        when(() => repo.getPaginatedMovies(request)).thenAnswer((_) async => Ok(PaginatedList.empty()));
        // act
        await useCase.call(request);
        // assert
        verify(() => repo.getPaginatedMovies(request)).called(1);
      });

      test('should return Ok when repo gets Ok', () async {
        // arrange
        when(() => repo.getPaginatedMovies(any())).thenAnswer((_) async => Ok(PaginatedList.empty()));
        // act
        final response = await useCase.call(PaginatedMovieRequest.empty());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<PaginatedList<Movie>>());
        expect(response.ok.items, isEmpty);
      });

      test('should return a paginated list of movies when repo gets Ok', () async {
        // arrange
        when(() => repo.getPaginatedMovies(any())).thenAnswer((_) async =>
            Ok(PaginatedList(items: [Movie.empty(), Movie.empty()], page: 1, total: 2, pageSize: 2, totalPages: 1)));
        // act
        final response = await useCase.call(PaginatedMovieRequest.empty());
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<PaginatedList<Movie>>());
        expect(response.ok.items, isNotEmpty);
        expect(response.ok.items[0], isA<Movie>());
      });
    });
  });
}
