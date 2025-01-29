import 'package:flame/events.dart';
import 'package:flame/components.dart';

/// タッチイベントをブロックする透明なレイヤー
class TouchBlocker extends PositionComponent
  with TapCallbacks, HasVisibility {
  TouchBlocker({
    required Vector2 size,
    required Vector2 position,
  }) : super(
          size: size,
          position: position,
        );

  @override
  bool onTapUp(TapUpEvent event) {
    // タッチイベントをここで止める
    return true;
  }
}