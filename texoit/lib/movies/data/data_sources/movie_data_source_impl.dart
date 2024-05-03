import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:serialization/json.dart';
import 'package:texoit/core/data/data_structure/api_response.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/texoit_client.dart';
import 'package:texoit/core/extensions/dio_extension.dart';
import 'package:texoit/movies/data/models/max_min_prize_model.dart';
import 'package:texoit/movies/data/models/movie_model.dart';
import 'package:texoit/movies/data/models/studio_winner_model.dart';
import 'package:texoit/movies/data/models/year_winner_model.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

import 'movie_data_source.dart';

class MovieDataSourceImpl implements MovieDataSource {
  final TexoItClient client;

  MovieDataSourceImpl({TexoItClient? client}) : client = client ?? di.get<TexoItClient>()!;

  @override
  Future<Result<Failure, PaginatedList<MovieModel>>> getPaginatedMovies(
    PaginatedMovieRequest request,
  ) async {
    try {
      final response = await client.dio.getSafe(
        "/backend-java/api/movies",
        queryParameters: request.toJson(),
      );
      if (response.isErr) {
        return Err(ServerFailure(exception: response.err, message: response.err.toString()));
      } else {
        final movies = ApiListResponse<MovieModel>.fromJson(
          Json(response.ok.data),
          (data) => MovieModel.fromJson(data),
        );
        return Ok(PaginatedList(
          items: movies.result,
          total: movies.itemCount ?? 0,
          page: request.pageRequest.page,
          pageSize: request.pageRequest.pageSize,
          totalPages: movies.pageCount ?? -1,
        ));
      }
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, ApiListResponse<MovieModel>>> getMoviesByYear(MovieByYearRequest request) async {
    try {
      final response = await client.dio.getSafe(
        "/backend-java/api/movies",
        queryParameters: request.toJson(),
      );
      if (response.isErr) {
        return Err(ServerFailure(exception: response.err, message: response.err.toString()));
      } else {
        return Ok(ApiListResponse<MovieModel>.fromJsonList(
          response.ok.data.map<Json>((e) => Json(e)).toList(),
          (data) => MovieModel.fromJson(data),
        ));
      }
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, ApiResponse<MaxMinPrizesModel>>> getMaxMinWin() async {
    try {
      final response = await client.dio.getSafe(
        "/backend-java/api/movies",
        queryParameters: {'projection': 'max-min-win-interval-for-producers'},
      );

      if (response.isErr) {
        return Err(ServerFailure(exception: response.err, message: response.err.toString()));
      } else {
        return Ok(ApiResponse.fromJson(
          Json(response.ok.data),
          (data) => MaxMinPrizesModel.fromJson(data),
        ));
      }
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, ApiListResponse<StudioWinnerModel>>> getWinnersByStudios() async {
    try {
      final response = await client.dio.getSafe(
        "/backend-java/api/movies",
        queryParameters: {'projection': 'studios-with-win-count'},
      );

      if (response.isErr) {
        return Err(ServerFailure(exception: response.err, message: response.err.toString()));
      } else {
        return Ok(ApiListResponse.fromJsonList(
          response.ok.data['studios'].map<Json>((e) => Json(e)).toList(),
          (data) => StudioWinnerModel.fromJson(data),
        ));
      }
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }

  @override
  Future<Result<Failure, ApiListResponse<YearWinnerModel>>> getYearsWithMultipleWinners() async {
    try {
      final response = await client.dio.getSafe(
        "/backend-java/api/movies",
        queryParameters: {'projection': 'years-with-multiple-winners'},
      );

      if (response.isErr) {
        return Err(ServerFailure(exception: response.err, message: response.err.toString()));
      } else {
        return Ok(ApiListResponse.fromJsonList(
          response.ok.data['years']?.map<Json>((e) => Json(e)).toList() ?? [],
          (data) => YearWinnerModel.fromJson(data),
        ));
      }
    } on Exception catch (e) {
      return Err(ServerFailure(exception: e, message: e.toString()));
    }
  }
}
