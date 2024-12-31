import 'package:falling_ball/features/game/world.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flame/flame.dart';

class WaitingDialog {
  late final List<Component> _waitingDialog;
  bool _isShown = false;

  List<Component> get waitingDialog => _waitingDialog;

  Future<void> initialize() async {
    _waitingDialog = [
      WaitingPanel(),
      CancelButton(),
    ];
  }

  void show(game) {
    if (_isShown) return;
    game.addAll(_waitingDialog);
    _isShown = true;
  }

  void hide(game) {
    if (!_isShown) return;
    _waitingDialog.forEach((element) {element.removeFromParent();});
    _isShown = false;
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
    priority = Config.PRIORITY_CONNECT;
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
    priority = Config.PRIORITY_CANCEL;
    anchor = Anchor.center;
  }

  @override
  bool onTapDown(TapDownEvent info) {
    world.cancelWaiting();
    return false;
  }
}
