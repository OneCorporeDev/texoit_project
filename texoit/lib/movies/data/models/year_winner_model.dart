import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/movies/domain/entities/year_winner.dart';

class YearWinnerModel extends Serializable {
  final int year;
  final int winnerCount;

  YearWinnerModel({required this.year, required this.winnerCount});

  factory YearWinnerModel.fromJson(Json json) {
    return YearWinnerModel(
      year: json.readInt('year') ?? 0,
      winnerCount: json.readInt('winnerCount') ?? 0,
    );
  }

  @override
  fromJson(Json json) => YearWinnerModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'winnerCount': winnerCount,
    };
  }

  factory YearWinnerModel.empty() => YearWinnerModel(year: 0, winnerCount: 0);

  YearWinner toEntity() => YearWinner(year: year, winnerCount: winnerCount);
}
