class StudioWinner {
  final String name;
  final int winnerCount;

  StudioWinner({required this.name, required this.winnerCount});

  StudioWinner.empty()
      : name = '',
        winnerCount = 0;
}
