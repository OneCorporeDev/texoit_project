import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';
import 'package:texoit/core/data/data_structure/pagination.dart';

class ApiResponseList<T extends Serializable> implements Serializable {
  final List<T> result;
  final Pagination? pagination;

  const ApiResponseList({
    required this.result,
    this.pagination,
  });

  factory ApiResponseList.fromJson(Json json, T Function(Json) map) => ApiResponseList<T>(
        result: json.readJsonList('result')?.map((e) => map(e)).toList() ?? [],
        pagination: Pagination.fromJson(json.readJson('pagination')),
      );

  @override
  Map<String, dynamic> toJson() => {
        'result': result.map((e) => e.toJson()).toList(),
        'pagination': pagination?.toJson(),
      };

  @override
  ApiResponseList<T> fromJson(Json json) => ApiResponseList.fromJson(json, (e) => throw Exception('Not implemented'));
}
