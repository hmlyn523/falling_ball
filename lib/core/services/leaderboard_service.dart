import 'dart:developer';

import 'package:falling_ball/core/models/match_result.dart';
import 'package:falling_ball/core/models/player_data.dart';
import 'package:falling_ball/core/models/ranking_entry.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class LeaderboardService {
  final SupabaseClient supabase;

  LeaderboardService(this.supabase);

  // 得点をアップロード
  // Future<void> uploadScore(supabase, PlayerData playerData) async {
    // // Supabaseや他のバックエンドに得点を送信
    // try {
    //   // 現在保存されている最高スコアを取得
    //   final currentScoreResponse = await supabase
    //       .from('scores')
    //       .select('score')
    //       .eq('player_name', playerData.username)
    //       // .eq('player_uuid', playerData.uuid)
    //       .maybeSingle();
    //   final currentScore = currentScoreResponse?['score'] as int? ?? 0;

    //   // 最高スコアを更新
    //   if (playerData.score > currentScore) {
    //     final response = await supabase.from('scores').upsert({
    //       'player_name': playerData.userName,
    //       'player_uuid': playerData.uuid,
    //       'score': playerData.score,
    //     }, onConflict: 'player_name');

    //     print('新しいスコアで更新しました！');
    //     print('レスポンス: $response');
    //   } else {
    //     print('スコアが既存のものより低いため更新されませんでした。');
    //   }
    // } catch (e) {
    //   print('スコアの保存/更新に失敗しました: $e');
    // }

    // try {
    //   // 得点履歴を追加（score_historyテーブル）
    //   await supabase.from('score_history').insert({
    //     'player_name': playerData.userName,
    //     'player_uuid': playerData.uuid,
    //     'score': playerData.score,
    //   });
    // } catch (e) {
    //   print('得点履歴の追加に失敗: $e');
    // }
  // }

  // // ランキングを取得
  // Future<List<RankingEntry>> getLeaderboard() async {
  //   // Supabaseや他のバックエンドからランキングを取得
  //   return [];
  // }
  // ランキングを取得
  Future<List<RankingEntry>> getLeaderboard() async {
    try {
      // スコアを降順に取得（上位10人）
      final response = await supabase
          .from('scores')
          .select('score, players(username)')
          .order('score', ascending: false)
          .limit(10);

      // レスポンスを RankingEntry のリストに変換
      final leaderboard = (response as List)
          .map((entry) => RankingEntry(
                playerName: entry['players']['username'] as String,
                score: entry['score'] as int,
              ))
          .toList();

      return leaderboard;
    } catch (e) {
      log('ランキングの取得に失敗しました: $e');
      return [];
    }
  }

  // 歴代スコアを取得
  Future<List<RankingEntry>> getScoreHistory(user_id) async {
    try {
      // スコアを降順に取得（上位10人）
      final response = await supabase
          .from('score_history')
          .select('score')
          .eq('user_id', user_id.id)
          .order('score', ascending: false)
          .limit(30);

      // レスポンスを RankingEntry のリストに変換
      final leaderboard = (response as List)
          .map((entry) => RankingEntry(
                playerName: "",
                score: entry['score'] as int,
              ))
          .toList();

      return leaderboard;
    } catch (e) {
      log('ランキングの取得に失敗しました: $e');
      return [];
    }
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
