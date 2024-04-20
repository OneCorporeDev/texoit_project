import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';

class ApiResponse<T extends Serializable> {
  final T result;

  const ApiResponse({
    required this.result,
  });

  factory ApiResponse.fromJson(Json json, T Function(Json) map) => ApiResponse<T>(
        result: map(json.readJson('result')),
      );

  Map<String, dynamic> toJson() {
    return {
      'result': result.toJson(),
    };
  }
}

class ApiListResponse<T extends Serializable> implements Serializable {
  final List<T> result;
  final int? itemCount;
  final int? pageCount;

  const ApiListResponse({
    required this.result,
    this.itemCount,
    this.pageCount,
  });

  factory ApiListResponse.fromJson(Json json, T Function(Json) map) => ApiListResponse<T>(
        result: json.readJsonList('result')!.map(map).toList(),
        itemCount: json.readInt('item_count'),
        pageCount: json.readInt('page_count'),
      );

  ApiListResponse<T> fromJsonMap(Json json, T Function(Json) map) => ApiListResponse.fromJson(json, map);

  @override
  ApiListResponse<T> fromJson(Json json) => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    return {
      'result': result.map((e) => e.toJson()).toList(),
      'item_count': itemCount,
      'page_count': pageCount,
    };
  }
}
