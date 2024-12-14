import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:fall_game/app/config.dart';

class FallingItem extends BodyComponent with ContactCallbacks {

  final image;
  final size;
  final radius;
  final position;
  final type;
  final density;
  final bump;
  final fadeInDuration;
  final void Function(FallingItem, Object, Contact) contactCallback;

  // 落下情報
  bool? _falling;
  bool? get falling => _falling;

  // 削除状態
  var _deleted;
  bool get deleted => _deleted;
  set deleted(bool b) {
    _deleted = b;
  }

  FallingItem({
    required this.image,
    required this.size,
    required this.radius,
    required this.position,
    required this.type,
    required this.density,
    required this.bump,
    required this.fadeInDuration,
    required void this.contactCallback(FallingItem item, Object other, Contact contact),
  }){
    _falling = null;
    _deleted = false;
    priority = Config.PRIORITY_FALL_ITEM;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    renderBody = false;
    _falling = true; // 読み込みが完了したら落下中とする
    this.add(
      SpriteComponent(
        sprite: Sprite(image),
        size: size,
        anchor: Anchor.center,
      )
      ..add(OpacityEffect.fadeOut( EffectController( duration: 0.0)))
      ..add(OpacityEffect.fadeIn(EffectController(duration: this.fadeInDuration)))
    );
  }

  @override
  Body createBody() {
    final shape = CircleShape();
    shape.radius = radius;
    position.y += bump; // 位置調整

    final fixtureDef = FixtureDef(shape)
      ..density = density // 密度
      ..friction = 0.5 // 摩擦
      ..restitution = 0.0 // 反発
      ..filter.categoryBits = Config.CATEGORY_BALL
      ..filter.maskBits = Config.CATEGORY_BALL | Config.CATEGORY_DOWN_WALL | Config.CATEGORY_LEFT_WALL | Config.CATEGORY_RIGHT_WALL;

    final bodyDef = BodyDef()
      ..userData = this // To be able to determine object in collision
      ..position = this.position
      ..angle = (this.position.x + this.position.y) / 2 * 3.14
      ..angularDamping = 0.6
      ..type = BodyType.dynamic;
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    _falling = false;
    contactCallback(this, other, contact);
  }

  void removeItem() async {
    _deleted = true;
    this.removeFromParent();
  }
}
