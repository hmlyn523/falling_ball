import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// 戻るボタンクラス
class RankingBackButton extends SpriteComponent
  with HasGameReference, TapCallbacks
{
  final VoidCallback onPressed;

  RankingBackButton({
    required Sprite sprite,
    required Vector2 position,
    required Vector2 size,
    required this.onPressed,
  }) : super(sprite: sprite, position: position, size: size, anchor: Anchor.center);

  @override
  bool onTapUp(TapUpEvent event) {
    onPressed();
    return false;
  }
}
