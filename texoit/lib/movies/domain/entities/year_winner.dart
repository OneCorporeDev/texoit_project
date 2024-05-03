class YearWinner {
  final int year;
  final int winnerCount;

  YearWinner({required this.year, required this.winnerCount});

  YearWinner.empty()
      : year = 0,
        winnerCount = 0;
}
