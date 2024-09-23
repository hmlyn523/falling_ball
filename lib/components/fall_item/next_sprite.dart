import 'package:fall_game/config.dart';
import 'package:flame/components.dart';

class NextSprite extends SpriteComponent with HasVisibility {
  NextSprite(_image)
      : super(
          sprite: Sprite(_image),
        ) {
    size = Vector2(Config.WORLD_HEIGHT * .05, Config.WORLD_HEIGHT * .05);
    position = Vector2(Config.WORLD_WIDTH * .315, Config.WORLD_HEIGHT * .033);
    priority = Config.PRIORITY_FALL_ITEM_SPRITE;
    anchor = Anchor.center;
    isVisible = false;
  }

  void setImage(image) {
    this.sprite = Sprite(image);
  }
}
