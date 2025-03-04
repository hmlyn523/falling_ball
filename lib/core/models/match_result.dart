// 対戦結果のデータモデル
class MatchResult {
  final String matchId;
  final String winnerId;
  final String loserId;

  MatchResult({required this.matchId, required this.winnerId, required this.loserId});
}