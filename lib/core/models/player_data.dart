class PlayerData {
  final String userName;
  final String uuid;
  final int score;
  final String? gameMode;
  final DateTime? playTime;

  PlayerData({
    required this.userName,
    required this.uuid,
    required this.score,
    this.gameMode,
    this.playTime,
  });
}