import 'package:client/result.dart';
import 'package:texoit/core/data/data_structure/api_response.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/movies/data/models/max_min_prize_model.dart';
import 'package:texoit/movies/data/models/movie_model.dart';
import 'package:texoit/movies/data/models/studio_winner_model.dart';
import 'package:texoit/movies/data/models/year_winner_model.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

abstract class MovieDataSource {
  Future<Result<Failure, PaginatedList<MovieModel>>> getPaginatedMovies(PaginatedMovieRequest request);
  Future<Result<Failure, ApiListResponse<MovieModel>>> getMoviesByYear(MovieByYearRequest request);
  Future<Result<Failure, ApiListResponse<YearWinnerModel>>> getYearsWithMultipleWinners();
  Future<Result<Failure, ApiListResponse<StudioWinnerModel>>> getWinnersByStudios();
  Future<Result<Failure, ApiResponse<MaxMinPrizesModel>>> getMaxMinWin();
}
