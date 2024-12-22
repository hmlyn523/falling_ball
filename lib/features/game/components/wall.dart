import 'package:flame_forge2d/body_component.dart';
import 'package:forge2d/forge2d.dart';
import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/features/game/game.dart';

List<Wall> createWall() {

  // 右の壁
  final EdgeShape rightWallShape = EdgeShape()..set(WallPosition.topRight, WallPosition.bottomRight);
  final rightWallFixtureDef = FixtureDef(rightWallShape)
    ..density = 0.0
    ..friction = 0.0
    ..restitution = 0.0
    ..filter.categoryBits = Config.CATEGORY_RIGHT_WALL // ビットマスク
    ..filter.maskBits = Config.CATEGORY_BALL;  // ビットマスク

  // 地面
  final EdgeShape groundShape = EdgeShape()..set(WallPosition.bottomRight, WallPosition.bottomLeft);
  final groundFixtureDef = FixtureDef(groundShape)
    ..density = 0.9
    ..friction = 0.5
    ..restitution = 0.0
    ..filter.categoryBits = Config.CATEGORY_DOWN_WALL // ビットマスク
    ..filter.maskBits = Config.CATEGORY_BALL;  // ビットマスク

  // 左の壁
  final EdgeShape leftWallShape = EdgeShape()..set(WallPosition.bottomLeft, WallPosition.topLeft);
  final leftWallFixtureDef = FixtureDef(leftWallShape)
    ..density = 0.0
    ..friction = 0.0
    ..restitution = 0.0
    ..filter.categoryBits = Config.CATEGORY_LEFT_WALL // ビットマスク
    ..filter.maskBits = Config.CATEGORY_BALL;  // ビットマスク

  return [
    Wall(rightWallFixtureDef),
    Wall(groundFixtureDef),
    Wall(leftWallFixtureDef),
  ];
}

class Wall extends BodyComponent<FallGame> {
  final FixtureDef _fixtureDef;

  Wall(this._fixtureDef) {
    renderBody = false;
  }

  @override
  Body createBody() {
    final def  = BodyDef()
      ..type = BodyType.static
      ..position = Vector2.zero();
    final body = world.createBody(def)
      ..userData = this;
    body..createFixture(this._fixtureDef);
    return body;
  }
}