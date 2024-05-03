import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/movies/domain/entities/studio_winner.dart';

class StudioWinnerModel extends Serializable {
  final String name;
  final int winnerCount;

  StudioWinnerModel({required this.name, required this.winnerCount});
  factory StudioWinnerModel.fromJson(Json json) {
    return StudioWinnerModel(
      name: json.readString('name') ?? '',
      winnerCount: json.readInt('winCount') ?? 0,
    );
  }

  factory StudioWinnerModel.empty() => StudioWinnerModel(name: '', winnerCount: 0);

  @override
  fromJson(Json json) => StudioWinnerModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'winCount': winnerCount,
    };
  }

  StudioWinner toEntity() => StudioWinner(name: name, winnerCount: winnerCount);
}
