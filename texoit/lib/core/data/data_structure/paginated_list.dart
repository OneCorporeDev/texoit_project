import 'package:serialization/json.dart';
import 'package:serialization/serializable.dart';

class PaginatedList<T extends Serializable> implements Serializable {
  final List<T> items;
  final int total;
  final int page;
  final int pageSize;
  final int totalPages;

  const PaginatedList({
    required this.items,
    required this.total,
    required this.page,
    required this.pageSize,
    required this.totalPages,
  });

  factory PaginatedList.empty() => PaginatedList<T>(
        items: [],
        total: 0,
        page: 0,
        pageSize: 2,
        totalPages: 0,
      );

  factory PaginatedList.fromJson(Json json, T Function(Json) map) => PaginatedList<T>(
        items: json.readJsonList('items')!.map(map).toList(),
        total: json.readInt('total')!,
        page: json.readInt('page')!,
        pageSize: json.readInt('pageSize')!,
        totalPages: json.readInt('totalPages')!,
      );

  PaginatedList<T> fromJsonMap(Json json, T Function(Json) map) => PaginatedList.fromJson(json, map);

  // Converte do tipo PaginatedList<T> para PaginatedList<U>
  PaginatedList<U> copyWith<U extends Serializable>({
    List<U>? items,
    int? total,
    int? page,
    int? pageSize,
    int? totalPages,
  }) =>
      PaginatedList<U>(
        items: items ?? this.items.map((e) => e as U).toList(),
        total: total ?? this.total,
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        totalPages: totalPages ?? this.totalPages,
      );

  @override
  PaginatedList<T> fromJson(Json json) => throw UnimplementedError();

  @override
  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'total': total,
      'page': page,
      'pageSize': pageSize,
      'totalPages': totalPages,
    };
  }
}

class PageRequest implements Serializable {
  final int page;
  final int pageSize;

  const PageRequest({
    required this.page,
    required this.pageSize,
  });

  factory PageRequest.fromJson(Json json) => PageRequest(
        page: json.readInt('page')!,
        pageSize: json.readInt('pageSize')!,
      );

  factory PageRequest.firstPage() => const PageRequest(
        page: 0,
        pageSize: 2,
      );

  factory PageRequest.nextPage(PageRequest pageRequest) => PageRequest(
        page: pageRequest.page + 1,
        pageSize: pageRequest.pageSize,
      );

  factory PageRequest.previousPage(PageRequest pageRequest) => PageRequest(
        page: pageRequest.page - 1,
        pageSize: pageRequest.pageSize,
      );

  factory PageRequest.empty() => PageRequest.firstPage();

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'size': pageSize,
    };
  }

  @override
  PageRequest fromJson(Json json) => PageRequest.fromJson(json);

  PageRequest copyWith({
    int? page,
    int? pageSize,
  }) =>
      PageRequest(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
      );
}
