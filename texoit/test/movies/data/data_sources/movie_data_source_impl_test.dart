import 'package:flutter_test/flutter_test.dart';
import 'package:http_mock_adapter/http_mock_adapter.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source_impl.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

import '../../../core/test_setup.dart';

void main() {
  group('MovieDataSourceImpl - unsuccess', () {
    late MovieDataSourceImpl dataSource;
    late DioAdapter dioAdapter;

    setUpAll(() async {
      final (client, mockDioAdapter) = await testSetup(mocked: true);
      dataSource = MovieDataSourceImpl(client: client);
      dioAdapter = mockDioAdapter!;
    });
    group('getPaginatedMovies', () {
      test('should return ServerFailure when gets server error', () async {
        // arrange
        dioAdapter.onGet(
          '/backend-java/api/movies',
          ((server) => server.reply(500, {'error': 'Internal Server Error'})),
        );
        final request = PaginatedMovieRequest(
          pageRequest: PageRequest.firstPage(),
          winner: true,
          year: 2018,
        );
        // act
        final result = await dataSource.getPaginatedMovies(request);
        // assert
        expect(result.isErr, true);
        expect(result.err.message, contains('DioException [bad response]'));
      });
    });

    group('getMoviesByYear', () {
      test('should return ServerFailure when gets server error', () async {
        // arrange
        dioAdapter.onGet(
          '/backend-java/api/movies',
          ((server) => server.reply(500, {'error': 'Internal Server Error'})),
        );
        const request = MovieByYearRequest(year: 2018, winner: false);
        // act
        final result = await dataSource.getMoviesByYear(request);
        // assert
        expect(result.isErr, true);
        expect(result.err.message, contains('DioException [bad response]'));
      });
    });
  });
  group('MovieDataSourceImpl - success', () {
    late MovieDataSourceImpl dataSource;
    setUpAll(() async {
      final (client, _) = await testSetup();
      dataSource = MovieDataSourceImpl(client: client);
    });
    group('getPaginatedMovies', () {
      test('should return first page of 2018 winners movies', () async {
        // arrange
        final request = PaginatedMovieRequest(
          pageRequest: PageRequest.firstPage(),
          winner: true,
          year: 2018,
        );
        // act
        final result = await dataSource.getPaginatedMovies(request);
        // assert
        expect(result.isOk, true);
        expect(result.ok, isA<PaginatedList>());
        expect(result.ok.items.length, greaterThan(0));
      });
      test('should return first page winners movies', () async {
        // arrange
        final request = PaginatedMovieRequest(
          pageRequest: PageRequest.firstPage(),
          winner: false,
          year: 2018,
        );
        // act
        final result = await dataSource.getPaginatedMovies(request);
        // assert
        expect(result.isOk, true);
        expect(result.ok, isA<PaginatedList>());
        expect(result.ok.items.length, greaterThan(1));
      });
    });

    group('getMoviesByYear', () {
      test('should return all 2018 movies', () async {
        // arrange
        const request = MovieByYearRequest(year: 2018, winner: false);
        // act
        final result = await dataSource.getMoviesByYear(request);
        // assert
        expect(result.isOk, true);
        expect(result.ok.result, isNotEmpty);
        expect(result.ok.result.length, greaterThan(1));
        expect(result.ok.result[0].producers, isNotEmpty);
        expect(result.ok.result[0].studios, isNotEmpty);
        expect(result.ok.result[0].year, equals(2018));
      });
      test('should return only the winner of 2018', () async {
        // arrange
        const request = MovieByYearRequest(year: 2018, winner: true);
        // act
        final result = await dataSource.getMoviesByYear(request);
        // assert
        expect(result.isOk, true);
        expect(result.ok.result, isNotEmpty);
        expect(result.ok.result.length, equals(1));
        expect(result.ok.result[0].year, equals(2018));
      });
      test('should return a empty list for a future year', () async {
        // arrange
        const request = MovieByYearRequest(year: 3000, winner: false);
        // act
        final result = await dataSource.getMoviesByYear(request);
        // assert
        expect(result.isOk, true);
        expect(result.ok.result, isEmpty);
        expect(result.ok.result.length, equals(0));
      });
    });
  });
}
