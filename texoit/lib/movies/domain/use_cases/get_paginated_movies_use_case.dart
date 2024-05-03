import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/data_structure/paginated_list.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/movie.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';
import 'package:texoit/movies/domain/requests/paginated_movie_request.dart';

// UsecaseName: GetPaginatedMoviesUseCase
// Repository: MovieRepo
class GetPaginatedMoviesUseCase extends UseCase<PaginatedList<Movie>, PaginatedMovieRequest> {
  final MovieRepo _repo;

  GetPaginatedMoviesUseCase({MovieRepo? repo}) : _repo = repo ?? di.get<MovieRepo>()!;

  @override
  Future<Result<Failure, PaginatedList<Movie>>> call(PaginatedMovieRequest params) async {
    final response = await _repo.getPaginatedMovies(params);
    return response;
  }
}
