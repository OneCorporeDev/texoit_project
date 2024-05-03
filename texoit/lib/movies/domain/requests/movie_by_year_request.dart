class MovieByYearRequest {
  final int year;
  final bool winner;

  const MovieByYearRequest({
    required this.year,
    this.winner = false,
  });

  factory MovieByYearRequest.empty() => const MovieByYearRequest(
        year: 2000,
      );

  Map<String, dynamic> toJson() {
    return {
      'year': year,
      'winner': winner,
    };
  }
}
