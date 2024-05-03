import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';

// UsecaseName: GetWinnersByYearsUseCase
// Repository: MovieRepo
class GetYearsWithMultipleWinners extends UseCase<List<YearWinner>, NoParams> {
  final MovieRepo _repo;

  GetYearsWithMultipleWinners({MovieRepo? repo}) : _repo = repo ?? di.get<MovieRepo>()!;

  @override
  Future<Result<Failure, List<YearWinner>>> call(NoParams params) async {
    final response = await _repo.getYearsWithMultipleWinners();
    return response;
  }
}
