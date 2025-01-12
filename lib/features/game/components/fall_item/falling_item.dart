import 'package:falling_ball/features/game/components/wall.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:falling_ball/app/config.dart';

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
    final shape = PolygonShape();
    shape.setAsBox(size.x / 2, size.y / 2, Vector2.zero(), 0.0); // 四角形の幅と高さを設定
    position.y += bump; // 位置調整

    final fixtureDef = FixtureDef(shape)
      ..density = density
      ..friction = 0.5
      ..restitution = 0.0
      ..filter.categoryBits = Config.CATEGORY_BALL
      ..filter.maskBits = Config.CATEGORY_BALL | Config.CATEGORY_DOWN_WALL | Config.CATEGORY_LEFT_WALL | Config.CATEGORY_RIGHT_WALL;

    final bodyDef = BodyDef()
      ..userData = this
      ..position = this.position
      ..angle = (this.position.x + this.position.y) / 2 * 3.14
      ..angularDamping = 0.6
      ..type = BodyType.dynamic;

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    if (other is Wall) {
      // FixtureA と FixtureB のカテゴリビットを取得
      final fixtureA = contact.fixtureA;
      final fixtureB = contact.fixtureB;

      // 接触した Fixture が Wall に該当する場合、そのカテゴリビットを取得
      final wallCategory = (fixtureA.body.userData == other)
          ? fixtureA.filterData.categoryBits
          : fixtureB.filterData.categoryBits;

      // left または right の壁の場合は return
      if (wallCategory == Config.CATEGORY_LEFT_WALL || wallCategory == Config.CATEGORY_RIGHT_WALL) {
        return;
      }
    }
    _falling = false;
    contactCallback(this, other, contact);
  }

  void removeItem() async {
    _deleted = true;
    this.removeFromParent();
  }
}
