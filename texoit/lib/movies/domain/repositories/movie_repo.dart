import 'package:client/result.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

abstract class MovieRepo {
  Future<Result<Failure, PaginatedList<Movie>>> getPaginatedMovies(PaginatedMovieRequest request);
  Future<Result<Failure, List<Movie>>> getMoviesByYear(MovieByYearRequest request);
  Future<Result<Failure, List<YearWinner>>> getYearsWithMultipleWinners();
  Future<Result<Failure, List<StudioWinner>>> getWinnersByStudios();
  Future<Result<Failure, MaxMinPrizes>> getMaxMinWin();
}
