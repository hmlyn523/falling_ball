import 'dart:ui';

import 'package:falling_ball/features/game/components/number_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class OpponentScore {
  late final NumberLabel _scoreLabel;

  int get score => _scoreLabel.number;
  NumberLabel get label => _scoreLabel;

  OpponentScore._(this._scoreLabel);

  static Future<OpponentScore> create() async {
    final scoreLabel = await NumberLabel(
      position: Vector2(Config.WORLD_WIDTH * .953, Config.WORLD_HEIGHT * .962),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    scoreLabel.isVisible = false;
    return OpponentScore._(scoreLabel);
  }

  void reset() {
    _scoreLabel.number = 0;
  }

  void update(int score) {
    _scoreLabel.text = score.toString();
  }

  void show() {
    _scoreLabel.isVisible = false;
  }

  void hide() {
    _scoreLabel.isVisible = false;
  }
}