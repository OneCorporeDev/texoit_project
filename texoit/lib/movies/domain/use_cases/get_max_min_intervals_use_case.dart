import 'package:client/result.dart';
import 'package:dependency_injection/dependency_injection.dart';
import 'package:texoit/core/data/helpers/failures.dart';
import 'package:texoit/core/data/helpers/use_case.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';
import 'package:texoit/movies/domain/repositories/movie_repo.dart';

// UsecaseName: GetMaxMinIntervalsUseCase
// Repository: MovieRepo
class GetMaxMinIntervalsUseCase extends UseCase<MaxMinPrizes, NoParams> {
  final MovieRepo _repo;

  GetMaxMinIntervalsUseCase({MovieRepo? repo}) : _repo = repo ?? di.get<MovieRepo>()!;

  @override
  Future<Result<Failure, MaxMinPrizes>> call(NoParams params) async {
    final response = await _repo.getMaxMinWin();
    return response;
  }
}
