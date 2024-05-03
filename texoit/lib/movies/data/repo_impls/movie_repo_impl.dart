import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

class MovieRepoImpl implements MovieRepo {
  final MovieDataSource _dataSource;

  MovieRepoImpl({MovieDataSource? dataSource}) : _dataSource = dataSource ?? di.get<MovieDataSource>()!;

  @override
  Future<Result<Failure, MaxMinPrizes>> getMaxMinWin() async {
    try {
      final response = await _dataSource.getMaxMinWin();
      if (response.isErr) {
        return Err(response.err);
      }
      final maxMinPrizes = response.ok.result;
      return Ok(maxMinPrizes.toEntity());
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, List<Movie>>> getMoviesByYear(MovieByYearRequest request) async {
    try {
      final response = await _dataSource.getMoviesByYear(request);
      if (response.isErr) {
        return Err(response.err);
      }
      final movies = response.ok.result;
      return Ok(movies.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, PaginatedList<Movie>>> getPaginatedMovies(PaginatedMovieRequest request) async {
    try {
      final response = await _dataSource.getPaginatedMovies(request);
      if (response.isErr) {
        return Err(response.err);
      }
      final PaginatedList<Movie> paginatedMovies =
          response.ok.copyWith<Movie>(items: response.ok.items.map((e) => e.toEntity()).toList());
      return Ok(paginatedMovies);
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, List<StudioWinner>>> getWinnersByStudios() async {
    try {
      final response = await _dataSource.getWinnersByStudios();
      if (response.isErr) {
        return Err(response.err);
      }

      return Ok(response.ok.result.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, List<YearWinner>>> getYearsWithMultipleWinners() async {
    try {
      final response = await _dataSource.getYearsWithMultipleWinners();
      if (response.isErr) {
        return Err(response.err);
      }
      final winners = response.ok.result;
      return Ok(winners.map((e) => e.toEntity()).toList());
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }
}
