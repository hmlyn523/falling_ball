import 'package:shared_preferences/shared_preferences.dart';
import 'package:games_services/games_services.dart';

class GameBoard {

  // スコア
  static const SCORE = 'score';
  static const IOS_SCORE_ID = 'tapjump.ranking';
  static const ANDROID_SCORE_ID = '';

  static void leaderboardScore(score) {
    _setValue(SCORE, score);
    GamesServices.submitScore(score: Score(
    androidLeaderboardID: ANDROID_SCORE_ID,
    iOSLeaderboardID: IOS_SCORE_ID,
    value: score));
  }

  static Future<int> getScore() async {
    return _getValue(SCORE);
  }

  // プレイ回数と平均値
  static const PLAY_COUNT = 'play_count';
  static const TOTAL_SCORE = 'total_score';
  static const IOS_PLAY_COUNT_ID = 'tapjump.playcount';
  static const ANDROID_PLAY_COUNT_ID = '';
  static const IOS_AVERAGE_SCORE_ID = 'tapjump.averagescore';
  static const ANDROID_AVERAGE_SCORE_ID = '';

  static void signedIn() async {
        GamesServices.signIn();
//    if (Platform.isAndroid || Platform.isIOS) {
//      if (!(await GamesServices.isSignedIn)) {
//        GamesServices.signIn();
//      }
//    }
  }

  static void playCountAndAverageScore(score) async {
//    if (await GamesServices.isSignedIn) {
    int totalScore = await _getValue(TOTAL_SCORE);
    int playCount = await _getValue(PLAY_COUNT);
//      _getValue(TOTAL_SCORE).then((totalScore) =>
//      {
//        _getValue(PLAY_COUNT).then((playCount) =>
//        {
          GamesServices.submitScore(score:
            Score(
              iOSLeaderboardID: IOS_AVERAGE_SCORE_ID,
              androidLeaderboardID: ANDROID_AVERAGE_SCORE_ID,
              value: (totalScore + score) ~/ playCount + 1,
            )
          );
          GamesServices.submitScore(score:
            Score(
              iOSLeaderboardID: IOS_PLAY_COUNT_ID,
              androidLeaderboardID: ANDROID_PLAY_COUNT_ID,
              value: playCount + 1
            )
          );
          _setValue(PLAY_COUNT, playCount + 1);
          _setValue(TOTAL_SCORE, totalScore + score);
//        })
//      });
//    }
  }

  // ローカルデータ設定
  static Future _setValue(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(key, value);
  }

  // ローカルデータ取得
  static Future<int> _getValue(key) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var value = prefs.getInt(key) ?? 0;
    return value;
  }
}
