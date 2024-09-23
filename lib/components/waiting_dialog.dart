import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/game.dart';

class Connect extends SpriteAnimationComponent {
  @override
  Future<void> onLoad() async {
    final sprites = [0, 1, 2].map((i) => Sprite.load('connect_$i.png'));
    this.animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: .5,
    );
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .61);
    size = Vector2(Config.WORLD_WIDTH * .7, Config.WORLD_HEIGHT * .3);
    priority = Config.PRIORITY_CONNECT;
    anchor = Anchor.center;

    add(CancelButton());
  }
}

class CancelButton extends SpriteComponent
    with
        TapCallbacks,
        HasGameReference<FallGame>,
        HasWorldReference<FallGameWorld> {
  @override
  Future<void> onLoad() async {
    sprite = Sprite(game.images.fromCache(Config.IMAGE_CANCEL));
    final parentSize = (parent as Connect).size;
    position = Vector2(parentSize.x * .5, parentSize.y * .65);
    size = Vector2(Config.WORLD_WIDTH * .50, Config.WORLD_HEIGHT * .085);
    priority = Config.PRIORITY_CANCEL;
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    world.cancelWaiting();
    return false;
  }
}
