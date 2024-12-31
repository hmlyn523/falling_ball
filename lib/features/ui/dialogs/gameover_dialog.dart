import 'package:falling_ball/features/game/world.dart';
import 'package:flame/components.dart';

import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';
import 'package:flame/events.dart';

class GameoverDialog extends PositionComponent
  with HasVisibility {

  late final List<SpriteComponent> _gameOverDialog;

  GameoverDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    priority = Config.PRIORITY_GAME_OVER;
    _gameOverDialog = [
      GameOverLogo(),
      TapTitleButton(),
    ];
    isVisible = false;
  }

  @override
  Future<void> onLoad() async {
    addAll(_gameOverDialog);
  }

  void setVisibility(bool isVisible) {
    priority = isVisible ? Config.PRIORITY_GAME_OVER : Config.PRIORITY_MIN;
    this.isVisible = isVisible;
  }
}

class GameOverLogo extends SpriteComponent with HasGameReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_GAME_OVER));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .45);
    size = Vector2(Config.WORLD_WIDTH * .54, Config.WORLD_HEIGHT * .084);
    anchor = Anchor.center;
  }
}

class TapTitleButton extends SpriteComponent with TapCallbacks, HasGameReference, HasWorldReference {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_TAP_TITLE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .6);
    size = Vector2(Config.WORLD_WIDTH * .68, Config.WORLD_HEIGHT * .095);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    (world as FallGameWorld).moveToEndState();
    return false;
  }
}