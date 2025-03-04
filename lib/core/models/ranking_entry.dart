// ランキングエントリのデータモデル
class RankingEntry {
  // final String playerId;
  final String? playerName;
  final int score;

  RankingEntry({required this.playerName, required this.score});
}