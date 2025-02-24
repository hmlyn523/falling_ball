import 'package:flame/components.dart';

import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';

class WinAndLoseDialog extends PositionComponent
  with HasVisibility {

  late final WinLogo _winLogoComponent;
  late final LoseLogo _loseLogoComponent;

  WinAndLoseDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    _winLogoComponent = WinLogo();
    _loseLogoComponent = LoseLogo();
    isVisible = false;
    priority = Config.PRIORITY_MIN;
  }

  @override
  Future<void> onLoad() async {
    add(_winLogoComponent);
    add(_loseLogoComponent);
  }

  void setVisibility(visible) {
    if (visible == this.isVisible) return;
    priority = visible ? Config.PRIORITY_WIN_AND_LOSE : Config.PRIORITY_MIN;
    this.isVisible = visible;
  }

  void setWinVisibility(visible) {
    setVisibility(true);
    _winLogoComponent.setVisibility(visible);
    _loseLogoComponent.setVisibility(!visible);
  }
}

class WinLogo extends SpriteComponent with HasGameReference, HasVisibility {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_WIN));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .33);
    size = Vector2(Config.WORLD_WIDTH * .55, Config.WORLD_HEIGHT * .17);
    anchor = Anchor.center;
    isVisible = false;
    priority = Config.PRIORITY_MIN;
  }

  void setVisibility(bool isVisible) {
     if (isVisible == this.isVisible) return;
    priority = isVisible ? Config.PRIORITY_WIN_AND_LOSE : Config.PRIORITY_MIN;
    this.isVisible = isVisible;
  }
}

class LoseLogo extends SpriteComponent with HasGameReference, HasVisibility {
  @override
  Future<void> onLoad() async {
    sprite = Sprite((game as FallGame).images.fromCache(Config.IMAGE_LOSE));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .33);
    size = Vector2(Config.WORLD_WIDTH * .55, Config.WORLD_HEIGHT * .17);
    anchor = Anchor.center;
    isVisible = false;
    priority = Config.PRIORITY_MIN;
  }

  void setVisibility(bool isVisible) {
     if (isVisible == this.isVisible) return;
    priority = isVisible ? Config.PRIORITY_WIN_AND_LOSE : Config.PRIORITY_MIN;
    this.isVisible = isVisible;
  }
}