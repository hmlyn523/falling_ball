import 'package:flame/components.dart';
import 'package:flame/events.dart';

import 'package:falling_ball/features/game/components/line.dart';
import 'package:falling_ball/app/config.dart';

class TapArea extends PositionComponent with TapCallbacks,
                                       DragCallbacks {
  var _dragging = true;
  late Line line;
  final void Function(Vector2) dragAndTapCallback;
  final void Function(Vector2) dragAndTapEndCallback;

  TapArea({
    required this.dragAndTapCallback,
    required this.dragAndTapEndCallback,
  }): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT * 1.1),
  ){
    priority = Config.PRIORITY_GAME_COMPONENT;
  }

  @override
  Future<void> onLoad() async {
    line = Line();
    line
      ..position.x = Config.WORLD_WIDTH * .5
      ..position.y = Config.WORLD_HEIGHT * .14;

    add(line);
  }

  // 指定された画像を指定されたサイズのボールをラインと一緒に表示する。
  void showLine(_nowBallImage, _nowBallSize, _nowBallRadius) {
    line.showLine(_nowBallImage, _nowBallSize, _nowBallRadius);
  }

  void hideLine() {
    line.hideLine();
  }

  void onDragOrTapEnd() => _onDragOrTapEnd();

  // タップすると呼ばれる
  @override
  bool containsLocalPoint(Vector2 point) {
    _dragging = true;
    line.updateLine(point);
    dragAndTapCallback(Vector2(line.position.x, Config.WORLD_HEIGHT * .14));
    return true;
  }

  // ドラッグ中に呼ばれる
  @override
  void onDragUpdate(DragUpdateEvent event) {
    _dragging = true;
    if (!line.updateLine(event.localStartPosition)) {
      _dragging = false;
    }
  }

  // ドラッグをやめる（タップを離す）と呼ばれる
  @override
  void onDragEnd(DragEndEvent event) {
    super.onDragEnd(event);
    _onDragOrTapEnd();
  }

  // タップを離すと呼ばれる
  @override
  void onTapUp(TapUpEvent event) {
    super.onTapUp(event);
    _onDragOrTapEnd();
  }

  void _onDragOrTapEnd() {
    if (!_dragging) return;
    dragAndTapEndCallback(Vector2(line.position.x, Config.WORLD_HEIGHT * .14));
  }
}
