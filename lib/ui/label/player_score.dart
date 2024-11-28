import 'dart:ui';

import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/config.dart';
import 'package:flame/components.dart';

class PlayerScore {
  late final ScoreLabel _scoreLabel;

  int get score => _scoreLabel.score;
  ScoreLabel get label => _scoreLabel;

  PlayerScore._(this._scoreLabel);

  static Future<PlayerScore> create() async {
    final scoreLabel = await ScoreLabel(
      position: Vector2(Config.WORLD_WIDTH * .93, Config.WORLD_HEIGHT * .058),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    scoreLabel.isVisible = true;
    return PlayerScore._(scoreLabel);
  }

  // void addToGame(game) {
  //   game.add(_scoreLabel);
  // }

  void reset() {
    _scoreLabel.score = 0;
  }

  void update(int score) {
    _scoreLabel.setTotal(score);
  }
}