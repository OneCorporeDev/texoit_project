import 'package:client/result.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:texoit/core/data/data_structure/api_response.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source_impl.dart';
import 'package:texoit/movies/data/models/max_min_prize_model.dart';
import 'package:texoit/movies/data/repo_impls/movie_repo_impl.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';

import '../../../core/test_setup.dart';

class MockMovieDataSourceImpl extends Mock implements MovieDataSourceImpl {}

void main() {
  final MovieDataSource dataSource = MockMovieDataSourceImpl();
  final MovieRepo movieRepo = MovieRepoImpl(dataSource: dataSource);
  group('MovieRepoImpl', () {
    setUpAll(() async {
      await testSetup();
    });
    // group of test of method method
    group('getMaxMinWin', () {
      test('should return err when dataSource gets err', () async {
        // arrange
        when(() => dataSource.getMaxMinWin()).thenAnswer((_) async => const Err(ServerFailure(message: 'error')));
        // act
        final response = await movieRepo.getMaxMinWin();
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });

      test('should return err when dataSource gets ok<model> but exception is thrown', () async {
        // arrange
        when(() => dataSource.getMaxMinWin()).thenThrow(Exception());
        // act
        final response = await movieRepo.getMaxMinWin();
        // assert
        expect(response, isA<Err>());
        expect(response.err, isA<ServerFailure>());
      });

      test('should return ok<entity> when dataSource gets ok<model>', () async {
        // arrange
        when(() => dataSource.getMaxMinWin())
            .thenAnswer((_) async => Ok(ApiResponse(result: MaxMinPrizesModel.empty())));
        // act
        final response = await movieRepo.getMaxMinWin();
        // assert
        expect(response, isA<Ok>());
        expect(response.ok, isA<MaxMinPrizes>());
      });
    });
  });
}
