import 'dart:ui';

import 'package:falling_ball/features/game/components/number_label.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';

class LobbyNumber {
  late final NumberLabel _label;

  int get score => _label.number;
  NumberLabel get label => _label;

  LobbyNumber._(this._label);

  static Future<LobbyNumber> create() async {
    final label = await NumberLabel(
      position: Vector2(Config.WORLD_WIDTH * .47, Config.WORLD_HEIGHT * .968),
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    label.isVisible = true;
    return LobbyNumber._(label);
  }

  void update(int count) {
    // _label.text = count.toString();
    _label.number = count;
  }
}