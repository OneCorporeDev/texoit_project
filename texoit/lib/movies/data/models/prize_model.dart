import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/movies/domain/entities/prize.dart';

class PrizeModel extends Serializable {
  final String producer;
  final int interval;
  final int? previousWin;
  final int? followingWin;

  PrizeModel({
    required this.producer,
    required this.interval,
    this.previousWin,
    this.followingWin,
  });

  factory PrizeModel.fromJson(Json json) {
    return PrizeModel(
      producer: json.readString('producer') ?? '',
      interval: json.readInt('interval') ?? 0,
      previousWin: json.readInt('previousWin'),
      followingWin: json.readInt('followingWin'),
    );
  }

  factory PrizeModel.empty() => PrizeModel(
        producer: '',
        interval: 0,
        previousWin: 0,
        followingWin: 0,
      );

  @override
  fromJson(Json json) => PrizeModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'producer': producer,
      'interval': interval,
      'previousWin': previousWin,
      'followingWin': followingWin,
    };
  }

  Prize toEntity() => Prize(
        producer: producer,
        interval: interval,
        previousWin: previousWin,
        followingWin: followingWin,
      );
}
