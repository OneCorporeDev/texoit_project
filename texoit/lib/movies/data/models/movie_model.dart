import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/movies/domain/entities/movie.dart';

class MovieModel implements Serializable {
  final int id;
  final int year;
  final String title;
  final List<String> studios;
  final List<String> producers;
  final bool winner;

  MovieModel({
    required this.id,
    required this.year,
    required this.title,
    required this.studios,
    required this.producers,
    required this.winner,
  });

  factory MovieModel.fromMap(Map<String, dynamic> map) => MovieModel(
        id: map['id'] ?? 0,
        year: map['year'] ?? 0,
        title: map['title'] ?? '',
        studios: map['studios']?.cast<String>() ?? [],
        producers: map['producers']?.cast<String>() ?? [],
        winner: map['winner'] ?? false,
      );

  factory MovieModel.fromJson(Json json) {
    return MovieModel(
      id: json.readInt('id') ?? 0,
      year: json.readInt('year') ?? 0,
      title: json.readString('title') ?? '',
      studios: json.readStringList('studios') ?? [],
      producers: json.readStringList('producers') ?? [],
      winner: json.readBool('winner') ?? false,
    );
  }

  @override
  fromJson(Json json) => MovieModel.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'year': year,
        'title': title,
        'studios': studios,
        'producers': producers,
        'winner': winner,
      };

  Movie toEntity() => Movie(
        id: id,
        year: year,
        title: title,
        studios: studios,
        producers: producers,
        winner: winner,
      );
}
