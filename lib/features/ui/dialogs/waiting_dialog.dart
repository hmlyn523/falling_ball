import 'package:falling_ball/features/game/world.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/flame.dart';

class WaitingDialog extends PositionComponent
  with HasVisibility {

  late final List<Component> _waitingDialog;

  List<Component> get waitingDialog => _waitingDialog;

  WaitingDialog(): super(
    position: Vector2.all(0),
    size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT),
  ){
    _waitingDialog = [
      WaitingPanel(),
      CancelButton(),
    ];
    isVisible = false;
    priority = Config.PRIORITY_MIN;
  }

  @override
  Future<void> onLoad() async {
    addAll(_waitingDialog);
  }

  void setVisibility(bool isVisible) {
    if (isVisible == this.isVisible) return;
    // 非表示時にイベントを無効化するため、TapTitleButtonのpriorityを変更
    priority = isVisible ? Config.PRIORITY_CONNECT : Config.PRIORITY_MIN;
    for (var component in _waitingDialog) {
      component.priority = isVisible ? Config.PRIORITY_CONNECT : Config.PRIORITY_MIN;
    }
    this.isVisible = isVisible;
  }
}

class WaitingPanel extends SpriteAnimationComponent {
  @override
  Future<void> onLoad() async {
    final sprites = [0, 1, 2, 3, 4].map((i) => Sprite.load('connect_$i.png'));
    this.animation = SpriteAnimation.spriteList(
      await Future.wait(sprites),
      stepTime: .5,
    );
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .61);
    size = Vector2(Config.WORLD_WIDTH * .7, Config.WORLD_HEIGHT * .3);
    anchor = Anchor.center;
  }
}

class CancelButton extends SpriteComponent
    with
        TapCallbacks,
        HasWorldReference<FallGameWorld> {
  final images = Flame.images;

  @override
  Future<void> onLoad() async {
    sprite = Sprite(images.fromCache(Config.IMAGE_CANCEL));
    position = Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .65);
    size = Vector2(Config.WORLD_WIDTH * .53, Config.WORLD_HEIGHT * .1);
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    world.cancelWaiting();
    return false;
  }
}
