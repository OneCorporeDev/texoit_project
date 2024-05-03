class Prize {
  final String producer;
  final int interval;
  final int? previousWin;
  final int? followingWin;

  Prize({
    required this.producer,
    required this.interval,
    this.previousWin,
    this.followingWin,
  });

  Prize.empty()
      : producer = '',
        interval = 0,
        previousWin = null,
        followingWin = null;
}
