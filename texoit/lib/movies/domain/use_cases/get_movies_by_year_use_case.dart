import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/requests/movie_by_year_request.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';

// UsecaseName: GetMoviesByYaerUseCase
// Repository: MovieR
class GetMoviesByYearUseCase extends UseCase<List<Movie>, MovieByYearRequest> {
  final MovieRepo _repo;

  GetMoviesByYearUseCase({MovieRepo? repo}) : _repo = repo ?? di.get<MovieRepo>()!;

  @override
  Future<Result<Failure, List<Movie>>> call(MovieByYearRequest params) async {
    final response = await _repo.getMoviesByYear(params);
    return response;
  }
}
