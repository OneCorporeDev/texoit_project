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
        pageSize: 10,
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

  PaginatedList<T> copyWith({
    List<T>? items,
    int? total,
    int? page,
    int? pageSize,
    int? totalPages,
  }) =>
      PaginatedList<T>(
        items: items ?? this.items,
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
  final String search;

  const PageRequest({
    required this.page,
    required this.pageSize,
    this.search = '',
  });

  factory PageRequest.fromJson(Json json) => PageRequest(
        page: json.readInt('page')!,
        pageSize: json.readInt('pageSize')!,
        search: json.readString('search') ?? '',
      );

  factory PageRequest.firstPage(String search) => PageRequest(
        page: 1,
        pageSize: 10,
        search: search,
      );

  factory PageRequest.nextPage(PageRequest pageRequest) => PageRequest(
        page: pageRequest.page + 1,
        pageSize: pageRequest.pageSize,
        search: pageRequest.search,
      );

  factory PageRequest.previousPage(PageRequest pageRequest) => PageRequest(
        page: pageRequest.page - 1,
        pageSize: pageRequest.pageSize,
        search: pageRequest.search,
      );

  factory PageRequest.empty() => PageRequest.firstPage('');

  @override
  Map<String, dynamic> toJson() {
    return {
      'page': page,
      'pageSize': pageSize,
      'search': search,
    };
  }

  @override
  PageRequest fromJson(Json json) => PageRequest.fromJson(json);

  PageRequest copyWith({
    int? page,
    int? pageSize,
    String? search,
  }) =>
      PageRequest(
        page: page ?? this.page,
        pageSize: pageSize ?? this.pageSize,
        search: search ?? this.search,
      );
}
