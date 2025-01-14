import 'package:falling_ball/features/game/components/fall_item/now_sprite.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class Line extends RectangleComponent
  with HasVisibility
{
  final images = Flame.images;
  late NowSprite _nowFallingItemSprite;

  Line()
    : super(
        size: Vector2(Config.WORLD_WIDTH * .01, Config.WORLD_HEIGHT * .759),
        paint: Paint()..color = Colors.white30
      ){
        priority = Config.PRIORITY_LINE;
        isVisible = false;
      }

  @override
  Future<void> onLoad() async {
    final _sprite = Sprite(images.fromCache(Config.IMAGE_EMPTY));
    _nowFallingItemSprite = NowSprite(sprite:_sprite);
    await addAll([
      _nowFallingItemSprite,
    ]);
  }

  void show(image, size, radius) {
    this.isVisible = true;
    _nowFallingItemSprite.isVisible = true;

    _nowFallingItemSprite.sprite = Sprite(images.fromCache(image));
    _nowFallingItemSprite.size = size;
    _nowFallingItemSprite.radius = radius;
    _nowFallingItemSprite.position = Vector2.zero();
  }

  void hide() {
    this.isVisible = false;
    _nowFallingItemSprite.isVisible = false;
  }

  bool updateLine(Vector2 position) {
    if (position.x.isNaN || position.y.isNaN) {
      return false;
    }
    if (this.isVisible) {
      this.position.x = _xDirectionAdjustment(position.x);
    }
    return true;
  }

  double _xDirectionAdjustment(x) {
    final r = _nowFallingItemSprite.radius;
    var adjustment = Config.WORLD_WIDTH * .001;
    if (x <= WallPosition.topLeft.x + r) {
      x = (WallPosition.topLeft.x + r);
      x += adjustment; // 誤差調整
    }
    if (x >= WallPosition.topRight.x - r) {
      x = (WallPosition.topRight.x - r);
      x -= adjustment; // 誤差調整
    }
    return x;
  }
}