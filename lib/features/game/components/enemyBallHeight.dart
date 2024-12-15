import 'package:fall_game/app/config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';

class EnemyBallHeight extends SpriteComponent
  with HasVisibility
{
  EnemyBallHeight(image)
    : super(
        size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT * .05),
        position: Vector2(Config.WORLD_WIDTH * .0, Config.WORLD_HEIGHT * .9),
        priority: Config.PRIORITY_ENEMY_BALL_HEIGHT,
      ){
        sprite = Sprite(image);
        isVisible = false;
      }

  void setVisibility(bool isVisible) => this.isVisible = isVisible;

  void setMark(double? height) {
    if (height == null || height <= 0) {
      setVisibility(false);
    } else {
      setVisibility(true);
      position.y = height;
    }
  }
}