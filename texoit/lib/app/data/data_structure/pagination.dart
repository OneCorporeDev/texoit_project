import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';

class Pagination implements Serializable {
  final int? currentPage;
  final int? pageSize;
  final int? totalSize;
  final int? totalPages;

  const Pagination({
    this.currentPage,
    this.pageSize,
    this.totalSize,
    this.totalPages,
  });

  factory Pagination.fromJson(Json json) => Pagination(
        currentPage: json.readInt('currentPage'),
        pageSize: json.readInt('pageSize'),
        totalSize: json.readInt('totalSize'),
        totalPages: json.readInt('totalPages'),
      );

  @override
  Map<String, dynamic> toJson() => {
        'currentPage': currentPage,
        'pageSize': pageSize,
        'totalSize': totalSize,
        'totalPages': totalPages,
      };

  @override
  Pagination fromJson(Json json) => Pagination.fromJson(json);
}
