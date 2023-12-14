import 'package:flame/components.dart';

import 'package:fall_game/config.dart';
import 'package:fall_game/game.dart';
import 'package:flame/events.dart';

List<SpriteComponent> createGameOverScreen() {
  return [
    GameOverLogo(),
    TapTitleButton(),
  ];
}

void removeGameOverScreen(List<SpriteComponent> gameOver) {
  gameOver.forEach((element) {element.removeFromParent();});
}

class GameOverLogo extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_GAME_OVER));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .50);
    size = Vector2(Config.WORLD_WIDTH * .54, Config.WORLD_HEIGHT * .084);
    priority = Config.PRIORITY_GAME_OVER_LOGO;
    anchor = Anchor.center;
  }
}

class TapTitleButton extends SpriteComponent with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_TAP_TITLE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .65);
    size = Vector2(Config.WORLD_WIDTH * .54, Config.WORLD_HEIGHT * .084);
    priority = Config.PRIORITY_TAP_TITLE;
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).moveToEndState();
    return false;
  }
}