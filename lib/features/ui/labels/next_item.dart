import 'dart:ui';

import 'package:falling_ball/features/game/components/number_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class NextItem {
  late final NumberLabel _label;

  int get score => _label.number;
  NumberLabel get label => _label;

  NextItem._(this._label);

  static Future<NextItem> create() async {
    final label = await NumberLabel(
      position: Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .046),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    label.isVisible = true;
    return NextItem._(label);
  }

  void update(int nextItemType) {
    _label.text = nextItemType.toString();
  }
}