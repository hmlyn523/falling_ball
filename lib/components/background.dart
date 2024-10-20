import 'dart:ui';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:fall_game/config.dart';

List<Background> createBackgound(Image image) {
  return [
    Background(
      image: image,
      size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
      position: Vector2.all(0),
      priority: Config.PRIORITY_BACK_B),
  ];
}

List<Background> createForegound(Image image) {
  return [
    Background(
      image: image,
      size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
      position: Vector2.all(0),
      priority: Config.PRIORITY_BACK_F),
  ];
}

class Background extends SpriteComponent {
  Background({image, size, position, priority}) :
      super(
          sprite: Sprite(image),
          size: size,
          position: position,
          priority: priority);
}
