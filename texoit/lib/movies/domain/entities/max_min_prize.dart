import 'package:texoit/movies/domain/entities/prize.dart';

class MaxMinPrizes {
  final List<Prize> max;
  final List<Prize> min;

  MaxMinPrizes({required this.max, required this.min});

  MaxMinPrizes.empty()
      : max = [],
        min = [];
}
