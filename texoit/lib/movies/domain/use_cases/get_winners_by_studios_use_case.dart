import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';

// UsecaseName: GetWinnersByStudioUseCase
// Repository: MovieRepo
class GetWinnersByStudioUseCase extends UseCase<List<StudioWinner>, NoParams> {
  final MovieRepo _repo;

  GetWinnersByStudioUseCase({MovieRepo? repo}) : _repo = repo ?? di.get<MovieRepo>()!;

  @override
  Future<Result<Failure, List<StudioWinner>>> call(NoParams params) async {
    final response = await _repo.getWinnersByStudios();
    return response;
  }
}
