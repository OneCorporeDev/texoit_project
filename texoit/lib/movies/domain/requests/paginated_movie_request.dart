import 'package:texoit/core/data/data_structure/paginated_list.dart';

class PaginatedMovieRequest {
  final PageRequest pageRequest;
  final bool winner;
  final int year;

  const PaginatedMovieRequest({
    required this.pageRequest,
    required this.winner,
    required this.year,
  });

  factory PaginatedMovieRequest.empty() => PaginatedMovieRequest(
        pageRequest: PageRequest.empty(),
        winner: false,
        year: 0,
      );

  Map<String, dynamic> toJson() {
    return {
      'page': pageRequest.page,
      'size': pageRequest.pageSize,
      'winner': winner,
      'year': year,
    };
  }
}
