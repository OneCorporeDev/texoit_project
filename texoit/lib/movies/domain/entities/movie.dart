import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';

class Movie implements Serializable {
  final int id;
  final String title;
  final int year;
  final List<String> studios;
  final List<String> producers;
  final bool winner;

  Movie(
      {required this.id,
      required this.title,
      required this.year,
      required this.studios,
      required this.producers,
      required this.winner});

  @override
  fromJson(Json json) {
    return Movie(
      id: json.readInt('id') ?? 0,
      title: json.readString('title') ?? '',
      year: json.readInt('year') ?? 0,
      studios: json.readStringList('studios') ?? [],
      producers: json.readStringList('producers') ?? [],
      winner: json.readBool('winner') ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'year': year,
      'studios': studios,
      'producers': producers,
      'winner': winner,
    };
  }

  static Movie empty() => Movie(
        id: 0,
        title: '',
        year: 0,
        studios: [],
        producers: [],
        winner: false,
      );
}
