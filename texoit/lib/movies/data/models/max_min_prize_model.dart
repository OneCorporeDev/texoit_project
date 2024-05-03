import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/movies/data/models/prize_model.dart';
import 'package:texoit/movies/domain/entities/max_min_prize.dart';

class MaxMinPrizesModel extends Serializable {
  final List<PrizeModel> max;
  final List<PrizeModel> min;

  MaxMinPrizesModel({required this.max, required this.min});

  factory MaxMinPrizesModel.fromJson(Json json) {
    return MaxMinPrizesModel(
      max: json.readJsonList('max')?.map<PrizeModel>((e) => PrizeModel.fromJson(e)).toList() ?? [PrizeModel.empty()],
      min: json.readJsonList('min')?.map<PrizeModel>((e) => PrizeModel.fromJson(e)).toList() ?? [PrizeModel.empty()],
    );
  }

  factory MaxMinPrizesModel.empty() => MaxMinPrizesModel(
        max: [PrizeModel.empty()],
        min: [PrizeModel.empty()],
      );

  @override
  fromJson(Json json) => MaxMinPrizesModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() {
    return {
      'max': max.map((e) => e.toJson()).toList(),
      'min': min.map((e) => e.toJson()).toList(),
    };
  }

  MaxMinPrizes toEntity() => MaxMinPrizes(
        max: max.map((e) => e.toEntity()).toList(),
        min: min.map((e) => e.toEntity()).toList(),
      );
}
