import 'package:dependency_injection/dependency_injection.dart';
import 'package:dependency_injection/dependency_injection_impl.dart';
import 'package:get/get.dart';
import 'package:izlogging/izlogging.dart';
import 'package:texoit/core/data/texoit_client.dart';
import 'package:texoit/movies/controller/movies_controller.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source.dart';
import 'package:texoit/movies/data/data_sources/movie_data_source_impl.dart';
import 'package:texoit/movies/data/repo_impls/movie_repo_impl.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/use_cases/get_max_min_intervals_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_movies_by_year_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_paginated_movies_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_winners_by_studios_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_years_with_multiple_winners_use_case.dart';

class MoviesBinding implements Bindings {
  @override
  void dependencies() {
    di = DependencyInjectionImpl();
    log = IzLogProvider('texoit');
    final TexoItClient client = TexoItClient();
    di.put<TexoItClient>(client);
    final MovieDataSource movieDataSource = MovieDataSourceImpl();
    final MovieRepo movieRepo = MovieRepoImpl(dataSource: movieDataSource);

    final GetYearsWithMultipleWinners getWinnersByYearsUseCase = GetYearsWithMultipleWinners(repo: movieRepo);
    final GetWinnersByStudioUseCase getWinnersByStudioUseCase = GetWinnersByStudioUseCase(repo: movieRepo);
    final GetMoviesByYearUseCase getMoviesByYearUseCase = GetMoviesByYearUseCase(repo: movieRepo);
    final GetMaxMinIntervalsUseCase getMaxMinIntervalsUseCase = GetMaxMinIntervalsUseCase(repo: movieRepo);
    final GetPaginatedMoviesUseCase getPaginatedMoviesUseCase = GetPaginatedMoviesUseCase(repo: movieRepo);
    di.lazyPut<MoviesController>(() => MoviesController(
          getWinnersByYearsUseCase: getWinnersByYearsUseCase,
          getWinnersByStudioUseCase: getWinnersByStudioUseCase,
          getMoviesByYearUseCase: getMoviesByYearUseCase,
          getMaxMinIntervalsUseCase: getMaxMinIntervalsUseCase,
          getPaginatedMoviesUseCase: getPaginatedMoviesUseCase,
        ));
  }
}
