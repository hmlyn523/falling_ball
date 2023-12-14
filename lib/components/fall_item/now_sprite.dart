import 'package:fall_game/config.dart';
import 'package:flame/components.dart';

class NowSprite extends SpriteComponent with HasVisibility {
  late var radius;

  NowSprite({Sprite? sprite, Vector2? size, Vector2? position, double? this.radius})
      : super(
          size: size,
          position: position,
          sprite: sprite,
        ){
          priority = Config.PRIORITY_FALL_ITEM_SPRITE;
          anchor = Anchor.center;
          isVisible = false;
          this.radius = 0.0;
        }
}