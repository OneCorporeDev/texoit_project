import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';
import 'package:texoit/movies/domain/use_cases/get_max_min_intervals_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_movies_by_year_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_paginated_movies_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_winners_by_studios_use_case.dart';
import 'package:texoit/movies/domain/use_cases/get_years_with_multiple_winners_use_case.dart';

class MoviesController extends GetxController {
  final GetYearsWithMultipleWinners getWinnersByYearsUseCase;
  final GetWinnersByStudioUseCase getWinnersByStudioUseCase;
  final GetMoviesByYearUseCase getMoviesByYearUseCase;
  final GetMaxMinIntervalsUseCase getMaxMinIntervalsUseCase;
  final GetPaginatedMoviesUseCase getPaginatedMoviesUseCase;

  RxList<YearWinner> years = <YearWinner>[].obs;
  RxList<StudioWinner> studios = <StudioWinner>[].obs;
  RxList<Movie> movies = <Movie>[].obs;
  Rxn<MaxMinPrizes> maxMinIntervals = Rxn<MaxMinPrizes>();
  Rx<PageRequest> pageRequest = PageRequest.firstPage().obs;
  Rx<PaginatedList<Movie>> paginatedMovies = PaginatedList<Movie>.empty().obs;
  RxInt selectedYear = 2018.obs;

  RxBool winnerFilter = false.obs;

  MoviesController({
    required this.getWinnersByYearsUseCase,
    required this.getWinnersByStudioUseCase,
    required this.getMoviesByYearUseCase,
    required this.getMaxMinIntervalsUseCase,
    required this.getPaginatedMoviesUseCase,
  });

  @override
  void onInit() {
    super.onInit();
    getWinnersByYears();
    getWinnersByStudio();
    getMoviesByYear(2018);
    getMaxMinIntervals();
    getPaginatedMovies(0);
  }

  Future<void> getWinnersByYears() async {
    final response = await getWinnersByYearsUseCase.call(NoParams());
    if (response.isErr) {
      print('Error: ${response.err.message}');
      return;
    }

    years.value = response.ok;
  }

  Future<void> getWinnersByStudio() async {
    final response = await getWinnersByStudioUseCase.call(NoParams());

    if (response.isErr) {
      print('Error: ${response.err.message}');
      return;
    }

    studios.value = response.ok;
    studios.sort((a, b) => b.winnerCount.compareTo(a.winnerCount));
  }

  Future<void> getMoviesByYear(int year) async {
    final response = await getMoviesByYearUseCase.call(MovieByYearRequest(year: year));

    if (response.isErr) {
      print('Error: ${response.err.message}');
      return;
    }

    movies.value = response.ok;
  }

  Future<void> getMaxMinIntervals() async {
    final response = await getMaxMinIntervalsUseCase.call(NoParams());

    if (response.isErr) {
      print('Error: ${response.err.message}');
      return;
    }

    maxMinIntervals.value = response.ok;
  }

  Future<void> getPaginatedMovies(int page) async {
    PaginatedMovieRequest request = PaginatedMovieRequest(
      pageRequest: pageRequest.value,
      winner: winnerFilter.value,
      year: selectedYear.value,
    );
    final response = await getPaginatedMoviesUseCase.call(request);

    if (response.isErr) {
      print('Error: ${response.err.message}');
      return;
    }

    paginatedMovies.value = response.ok;
  }
}
