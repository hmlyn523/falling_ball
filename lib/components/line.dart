import 'dart:ui';

import 'package:fall_game/components/fall_item/now_sprite.dart';
import 'package:fall_game/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class Line extends RectangleComponent with HasVisibility, HasGameReference {
  late NowSprite _nowFallItemSprite;

  Line()
    : super(
        size: Vector2(Config.WORLD_WIDTH * .01, Config.WORLD_HEIGHT * .759),
        paint: Paint()..color = Colors.white38,
      ){
        priority = Config.PRIORITY_LINE;
        isVisible = false;
      }

  @override
  Future<void> onLoad() async {
    final _sprite = Sprite(game.images.fromCache(Config.IMAGE_EMPTY));
    _nowFallItemSprite = NowSprite(sprite:_sprite);
    await addAll([
      _nowFallItemSprite,
    ]);
  }

  void showLine(image, size, radius) {
    this.isVisible = true;
    _nowFallItemSprite.isVisible = true;

    _nowFallItemSprite.sprite = Sprite(game.images.fromCache(image));
    _nowFallItemSprite.size = size;
    _nowFallItemSprite.radius = radius;
    _nowFallItemSprite.position = Vector2.zero();
  }

  void hideLine() {
    this.isVisible = false;
    _nowFallItemSprite.isVisible = false;
    // remove(_nowFallItemSprite);
  }

  bool updateLine(Vector2 position) {
    // _dragging = true;
    if (position.x.isNaN || position.y.isNaN) {
      return false;
    }
    if (this.isVisible) {
      this.position.x = _xDirectionAdjustment(position.x);
    }
    return true;
  }

  double _xDirectionAdjustment(x) {
    final r = _nowFallItemSprite.radius;
    var adjustment = Config.WORLD_WIDTH * .01;
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