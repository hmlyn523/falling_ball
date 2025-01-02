import 'package:flame/components.dart';

import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';

class WinAndLoseDialog extends PositionComponent
  with HasVisibility {

  late final List<SpriteComponent> _winAndLoseDialog;

  WinAndLoseDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    priority = Config.PRIORITY_GAME_OVER;
    _winAndLoseDialog = [
      WinLogo(),
      LoseLogo(),
    ];
    isVisible = false;
  }

  @override
  Future<void> onLoad() async {
    addAll(_winAndLoseDialog);
  }

  void setVisibility(bool isVisible, bool winAndLose) {
    priority = isVisible ? Config.PRIORITY_WIN_AND_LOSE : Config.PRIORITY_MIN;
    this.isVisible = isVisible;
    if (winAndLose) {
      (_winAndLoseDialog[0] as WinLogo).setVisibility(true);
      (_winAndLoseDialog[1] as LoseLogo).setVisibility(false);
    } else {
      (_winAndLoseDialog[0] as WinLogo).setVisibility(false);
      (_winAndLoseDialog[1] as LoseLogo).setVisibility(true);
    }
  }
}

class WinLogo extends SpriteComponent with HasGameReference, HasVisibility {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_WIN));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .3);
    size = Vector2(Config.WORLD_WIDTH * .46, Config.WORLD_HEIGHT * .13);
    anchor = Anchor.center;
    isVisible = false;
  }
  void setVisibility(bool isVisible) => this.isVisible = isVisible;
}

class LoseLogo extends SpriteComponent with HasGameReference, HasVisibility {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_LOSE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .3);
    size = Vector2(Config.WORLD_WIDTH * .56, Config.WORLD_HEIGHT * .13);
    anchor = Anchor.center;
    isVisible = false;
  }
  void setVisibility(bool isVisible) => this.isVisible = isVisible;
}