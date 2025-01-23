import 'package:supabase_flutter/supabase_flutter.dart';

class LeaderboardService {
  // late final dynamic currentScoreResponse;

  // 得点をアップロード
  Future<void> uploadScore(String playerName, int newScore) async {
    // Supabaseや他のバックエンドに得点を送信
    final supabase = Supabase.instance.client;

    try {
      // 現在保存されている最高スコアを取得
      final currentScoreResponse = await supabase
          .from('scores')
          .select('score')
          .eq('player_name', playerName)
          .maybeSingle();
      final currentScore = currentScoreResponse?['score'] as int? ?? 0;

      // 最高スコアを更新
      if (newScore > currentScore) {
        final response = await supabase.from('scores').upsert({
          'player_name': playerName,
          'score': newScore,
        }, onConflict: 'player_name');

        print('新しいスコアで更新しました！');
        print('レスポンス: $response');
      } else {
        print('スコアが既存のものより低いため更新されませんでした。');
      }
    } catch (e) {
      print('スコアの保存/更新に失敗しました: $e');
    }

    try {
      // 得点履歴を追加（score_historyテーブル）
      await supabase.from('score_history').insert({
        'player_name': playerName,
        'score': newScore,
      });
    } catch (e) {
      print('得点履歴の追加に失敗: $e');
    }
  }

  // ランキングを取得
  Future<List<RankingEntry>> getLeaderboard() async {
    // Supabaseや他のバックエンドからランキングを取得
    return [];
  }

  // 対戦の勝敗をアップロード
  Future<void> uploadMatchResult(String matchId, String winnerId, String loserId) async {
    // 勝敗データをバックエンドに送信
  }

  // 対戦成績を取得
  Future<List<MatchResult>> getMatchHistory(String playerId) async {
    // 対戦履歴を取得
    return [];
  }
}

// ランキングエントリのデータモデル
class RankingEntry {
  final String playerId;
  final int score;

  RankingEntry({required this.playerId, required this.score});
}

// 対戦結果のデータモデル
class MatchResult {
  final String matchId;
  final String winnerId;
  final String loserId;

  MatchResult({required this.matchId, required this.winnerId, required this.loserId});
}
