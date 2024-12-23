import 'dart:ui';

import 'package:falling_ball/features/game/components/number_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class PlayerScore {
  late final NumberLabel _scoreLabel;

  int get score => _scoreLabel.number;
  NumberLabel get label => _scoreLabel;

  PlayerScore._(this._scoreLabel);

  static Future<PlayerScore> create() async {
    final scoreLabel = await NumberLabel(
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
    _scoreLabel.number = 0;
  }

  void update(int score) {
    _scoreLabel.setTotal(score);
  }
}