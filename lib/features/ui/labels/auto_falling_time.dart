import 'dart:ui';

import 'package:falling_ball/features/game/components/number_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class AutoFallingTime {
  late final NumberLabel _scoreLabel;

  int get score => _scoreLabel.number;
  NumberLabel get label => _scoreLabel;

  AutoFallingTime._(this._scoreLabel);

  static Future<AutoFallingTime> create() async {
    final label = await NumberLabel(
      position: Vector2(Config.WORLD_WIDTH * .1, Config.WORLD_HEIGHT * .15),
      color: const Color.fromRGBO(255, 0, 0, 1),
      fontsize: Config.WORLD_WIDTH * 0.2, 
    );
    label.isVisible = false;
    label.priority = Config.PRIORITY_AUTO_FALLING_TIME;
    return AutoFallingTime._(label);
  }

  void update(int score) {
    _scoreLabel.text = score.toString();
  }

  void show() {
    _scoreLabel.isVisible = true;
  }

  void hide() {
    _scoreLabel.isVisible = false;
  }
}