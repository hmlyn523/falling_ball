import 'dart:ui';

import 'package:falling_ball/features/game/components/score_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class NextItem {
  late final ScoreLabel _label;

  int get score => _label.score;
  ScoreLabel get label => _label;

  NextItem._(this._label);

  static Future<NextItem> create() async {
    final label = await ScoreLabel(
      position: Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .059),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    label.isVisible = true;
    return NextItem._(label);
  }

  void update(int nextItemType) {
    _label.text = nextItemType.toString();
  }
}