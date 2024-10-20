import 'package:fall_game/event_bus.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:fall_game/components/line.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class TapArea extends PositionComponent with TapCallbacks,
                                      //  HasGameReference,
                                       HasWorldReference<FallGameWorld>,
                                       DragCallbacks {
  final EventBus eventBus;

  var _dragging = true;
  late var _line;
  final void Function(Vector2) spawn;

  TapArea(void this.spawn(Vector2 position), this.eventBus):
    super(
      position: Vector2.all(0),
      size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT * 1.1),
    ){
      priority = Config.PRIORITY_GAME_COMPONENT;
      eventBus.subscribe('showLine', (ball) {
        showLine(ball.image, ball.size, ball.radius);
      });
    }

  @override
  Future<void> onLoad() async {
    final Line line = Line();
    line
      ..position.x = Config.WORLD_WIDTH * .5
      ..position.y = Config.WORLD_HEIGHT * .14;

    await addAll([
      _line = line,
    ]);
  }

  // 指定された画像を指定されたサイズのボールをラインと一緒に表示する。
  void showLine(_nowBallImage, _nowBallSize, _nowBallRadius) {
    _line.showLine(_nowBallImage, _nowBallSize, _nowBallRadius);
  }

  void hideLine() {
    _line.hideLine();
  }

  // タップすると呼ばれる
  @override
  bool containsLocalPoint(Vector2 point) {
    _dragging = true;
    _line.updateLine(point);
    return true;
  }

  // ドラッグ中に呼ばれる
  @override
  void onDragUpdate(DragUpdateEvent event) {
    _dragging = true;
    if (!_line.updateLine(event.localPosition)) {
      _dragging = false;
    }
  }

  // ドラッグをやめる（タップを離す）と呼ばれる
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _spawn();
  }

  // タップを話すと呼ばれる
  @override
  void onTapUp(TapUpEvent event) {
    _spawn();
  }

  void _spawn() {
    if (!_dragging) return;
    if (_isPlaying()) {
      // spawn(Vector2(_line.position.x, Config.WORLD_HEIGHT * .14));
      world.fallItemFactory.spawn(Vector2(_line.position.x, Config.WORLD_HEIGHT * .14));
      hideLine();
    }
  }

  bool _isPlaying() {
    return world.isPlayingState();
  }
}
