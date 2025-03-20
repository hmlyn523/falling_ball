// ランキングエントリのデータモデル
class RankingEntry {
  // final String playerId;
  final String? playerName;
  final int score;
  final String? datetime;

  RankingEntry({required this.playerName, required this.score, required this.datetime});
}