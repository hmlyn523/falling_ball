import 'dart:developer';

// import 'package:falling_ball/core/models/player_data.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerService {
  final SupabaseClient supabase;

  PlayerService(this.supabase);

  Future<User?> getLoginUser() async {
    return await supabase.auth.currentUser;
  } 

  // // プレイヤー情報を取得
  // Future<PlayerData?> getPlayerData() async {
  //   final user = await getLoginUser();
  //   if (user == null) {
  //     log("❌ ユーザがログインしていません");
  //     return null;
  //   }

  //   try {
  //     final response = await supabase
  //         .from('players')
  //         .select('*')
  //         .eq('id', user.id)
  //         .single();
  //     return PlayerData.fromJson(response);
  //   } catch (error) {
  //     log("❌ プレイヤーデータ取得失敗: $error");
  //     return null;
  //   }
  // }

  // プレイヤーデータを更新
  // idが一致するusernameを更新する
  // Future<bool> updatePlayerData(PlayerData playerData) async {
  //   final user = await getLoginUser();
  //   if (user == null) {
  //     log("❌ ユーザがログインしていません");
  //     return false;
  //   }
  //   try {
  //     await supabase.from('players').update({
  //       'username': playerData.username,
  //     }).eq('id', playerData.id);
  //     log("✅ プレイヤーデータ更新成功");
  //     return true;
  //   } catch (error) {
  //     log("❌ プレイヤーデータ更新失敗: $error");
  //     return false;
  //   }
  // }

  // スコア履歴を追加
  Future<bool> addScoreHistory(int score) async {
    final user = await getLoginUser();
    if (user == null) {
      log("❌ ユーザがログインしていません");
      return false;
    }

    try {
      await supabase.from('score_history').insert({
        'user_id': user.id, // auth.users の ID を外部キーとして使用
        'score': score,
      });

      log("✅ スコア追加成功: $score");
      return true;
    } catch (error) {
      log("❌ スコア追加失敗: $error");
      return false;
    }
  }

  // スコアを更新 (現在のスコアより高い場合のみ)
  Future<bool> updateScoreIfHigher(int newScore) async {
    final user = await getLoginUser();
    if (user == null) {
      log("❌ ユーザがログインしていません");
      return false;
    }

    try {
      // 現在のスコアを取得
      final response = await supabase
          .from('scores')
          .select('score')
          .eq('id', user.id)
          .maybeSingle();

      int? currentScore = response?['score'];

      // 現在のスコアより高い場合のみ更新
      if (currentScore == null || newScore > currentScore) {
        await supabase.from('scores').upsert({
          'id': user.id, // ユーザーID (外部キー)
          'score': newScore,
        });

        log("✅ スコア更新成功: $newScore");
        return true;
      } else {
        log("✅ 現在のスコア ($currentScore) より低いため更新なし");
        return true;
      }
    } catch (error) {
      log("❌ スコア更新失敗: $error");
      return false;
    }
  }
}
