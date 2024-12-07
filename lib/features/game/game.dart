import 'package:fall_game/features/game/world.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';
import 'package:fall_game/app/config.dart';

class FallGame extends Forge2DGame {
  final context;

  FallGame({required this.context})
      : super(
          gravity: Vector2(0, 30.0),
          world: FallGameWorld(),
          camera: CameraComponent.withFixedResolution(
            width: Config.WORLD_WIDTH,
            height: Config.WORLD_HEIGHT,
          ),
          zoom: 1,
        );
}