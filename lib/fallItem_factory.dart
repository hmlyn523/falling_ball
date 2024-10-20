import 'dart:math';

import 'package:fall_game/components/audio.dart';
import 'package:fall_game/components/fall_item/fall_item.dart';
import 'package:fall_game/components/fall_item/next_sprite.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/event_bus.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class FallItemFactory
{
  static FallItemFactory? _instance;
  final EventBus eventBus;

  final FallList _fallList = FallList();
  final img = Flame.images;

  late final NextSprite _nextItemSprite;

  late int _nowItemIndex;
  late int _nextItemIndex;

  late List<FallItem> _onScreenItems = [];

  FallItemFactory._(this.eventBus) {
    _nowItemIndex = _getItemIndex();
    _nextItemIndex = _getItemIndex();
    final image = img.fromCache(get(_nextItemIndex).image);
    _nextItemSprite = NextSprite(image);
    eventBus.publish('addItem', _nextItemSprite);
  }

  factory FallItemFactory(EventBus eventBus) {
    _instance ??= FallItemFactory._(eventBus);
    return _instance!;
  }

  FallItem create(index, position, {double bump = 0.0, double fadeInDuration = 0.0}) {
    var item = FallItem(
      image: img.fromCache(_fallList.value[index].image),
      radius: _fallList.value[index].radius,
      size: _fallList.value[index].size,
      position: position,
      type: _fallList.value[index].type,
      density: _fallList.value[index].density,
      bump: bump,
      fadeInDuration: fadeInDuration,
      contactCallback: collision,
    );
    _onScreenItems.add(item);
    return item;
  }

  void spawn(position) {
    // 落下中のアイテムがなければ新しく落下させる
    if (!isFalling()) {
      // 落下開始位置調整
      position = _adjustFallStartPosition(position);
      // 落下アイテム生成
      eventBus.publish("addItem", create(_nowItemIndex, position));
      Audio.play(Audio.AUDIO_SPAWN);

      _nowItemIndex = _nextItemIndex;
      _nextItemIndex = _getItemIndex();
    }
  }

  void spawnRandomItem() {
    var rand = Random().nextDouble() * (.8 - .2) + .2;
    var posWidth = Config.WORLD_WIDTH * rand;
    var pos = Vector2(posWidth, Config.WORLD_HEIGHT * .8);
    eventBus.publish("addItem", create(11, pos));
  }

  //////////////////////////////////////
  // 落下開始位置の調整
  Vector2 _adjustFallStartPosition(position) {
    var r = get(_nowItemIndex).radius;
    var x = position.x;
    var adjustment = Config.WORLD_WIDTH * .01;
    if (x <= WallPosition.topLeft.x + r) {
      position.x = (WallPosition.topLeft.x + r);
      position.x += adjustment; // 誤差調整
    }
    if (x >= WallPosition.topRight.x - r) {
      position.x = (WallPosition.topRight.x - r);
      position.x -= adjustment; // 誤差調整
    }
    return position;
  }

  int _getItemIndex() {
    // final List<int> _itemDischargeProbability = [20, 20, 20, 20, 20];
    final List<int> _itemDischargeProbability = [22, 18, 20, 21, 19];
    // final List<int> _itemDischargeProbability = [25, 15, 22, 23, 15];
    // final List<int> _itemDischargeProbability = [20, 20, 20, 20, 20];
    // final List<int> _itemDischargeProbability = [0, 0, 0, 0, 0, 10, 10, 20, 30, 30];
    _itemDischargeProbability.sort((a, b) => a.compareTo(a));
    var rand = Random().nextInt(100);
    var rate = 0;
    for (int index = 0; index < _itemDischargeProbability.length; index++) {
      rate += _itemDischargeProbability[index];
      if (rand <= rate) {
        return index;
      }
    }
    return 0;
  }

  FallInfo get(index) {
    return _fallList.value[index];
  }

  FallInfo getNowItem() {
    return _fallList.value[_nowItemIndex];
  }

  void setNextItemVisibility(b) {
    _nextItemSprite.isVisible = b;
  }

  int length() {
    return _fallList.value.length;
  }
  
  bool isFalling() {
    var falling = false;
    _onScreenItems.forEach((element) {
      if (element.falling) {
        falling = true;
        return;
      }
    });
    return falling;
  }

  // ボールが他のボールや壁に衝突した場合に呼び出される。
  void collision(FallItem item, Object other, Contact contact) {
    final selfObject = contact.bodyA.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
    final otherObject = contact.bodyB.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;

    // ボールの落下が完了した場合[isFalling=false]、ボールとラインを表示する。
    // ボールの表示は本クラスで行うが、ラインの表示はTapAreaクラスで行うため、
    // whereTypeのfirstを利用してTapAreaコンポーネントの取得を行う。
    if (!isFalling()) {
      _showNextItem();
      eventBus.publish('showLine', getNowItem());
    }

    // ボールがぶつかった相手が、壁の場合は何も処理をせずに終了する。
    if (other is Wall) {
      return;
    }

    // 同じ番号のボールが衝突した場合、次の番号のボールをぶつかったボールの中間点に表示する。
    // ただし、すでにボールが削除のタイミングに入っている[deleted=true]、次の番号が最大ボール番号より大きい場合は、
    // ボールを削除するだけ。あとぶつかったボールそれぞれで衝突コールバックが呼ばれるので、contactのbodyAの場合のみ
    // 衝突処理を行い、BodyBの場合はボールの削除のみを行う。
    // [_adjustmentItem]
    // 違う番号のボールがぶつかった場合、同じX座標だとボールが重なってしまうので左右どちらかに移動させる。
    if ((selfObject as FallItem).type == (otherObject as FallItem).type) {
      if (selfObject == contact.bodyA.userData &&
          !selfObject.deleted &&
          !otherObject.deleted) {
        var mergeItemIndex = selfObject.type + 1;
        if (mergeItemIndex < length() - 1) {
          Vector2 _nextItemPosition = Vector2.zero();
          _nextItemPosition.x =
              ((otherObject.body.position.x + selfObject.body.position.x) / 2);
          _nextItemPosition.y =
              ((otherObject.body.position.y + selfObject.body.position.y) / 2);
          eventBus.publish('scoreLabel', get(mergeItemIndex).score);
          eventBus.publish('chain', null);

          // 新しいアイテム表示
          Future.delayed(Duration(milliseconds: 50), () {
            var fallItem = create(mergeItemIndex, _nextItemPosition,
                fadeInDuration: 0.1);
            fallItem.priority = 0;
            eventBus.publish("addItem", fallItem);
          });

          // 得点表示
          final scoreText = TextComponent(
            text: get(mergeItemIndex).score.toString(),
            position: Vector2(_nextItemPosition.x, _nextItemPosition.y),
            anchor: Anchor.center,
            textRenderer: TextPaint(
              style: const TextStyle(
                fontFamily: 'Square-L',
                color: Colors.black54,
                fontSize: 12,
              ),
            ),
            priority: 2,
          );
          eventBus.publish("addItem", scoreText);

          scoreText.add(
            MoveEffect.by(
              Vector2(0, -10),  // 50ピクセル上に移動
              EffectController(duration: .8, curve: Curves.easeOut),
            ),
          );

          scoreText.add(
            RemoveEffect(
              delay: .8,
              onComplete: () {
                scoreText.removeFromParent(); // コンポーネントを削除
              },
            ),
          );

          // 爆発
          eventBus.publish("addItem", SpriteAnimationComponent.fromFrameData(
            img.fromCache("explosion.png"),
            SpriteAnimationData.sequenced(
              textureSize: Vector2.all(32),
              amount: 6,
              stepTime: 0.1,
              loop: false,
            ),
            position: Vector2(_nextItemPosition.x, _nextItemPosition.y),
            size: Vector2(8,8),
            anchor: Anchor.center,
            priority: 1
          ));
        }
        
        if (mergeItemIndex < 12) {
          // アイテム削除
          selfObject.removeItem();
          otherObject.removeItem();
          Audio.play(Audio.AUDIO_COLLISION);
        }
        return;
      }
    } else {
      if (selfObject == contact.bodyA.userData) {
        _adjustmentItem(selfObject, otherObject);
      }
    }
  }

  void _adjustmentItem(FallItem selfObject, FallItem otherObject) {
    if ((selfObject.body.position.x == otherObject.body.position.x)) {
      var rand = Random().nextInt(2);
      var move = (rand * 2 - 1).toDouble();
      selfObject.body.linearVelocity = Vector2(move, 0);
    }
  }

  bool isGameOver() {
    bool ret = false;
    _onScreenItems.forEach((element) {
      FallItem item = element;
      if (item.body.position.y < Config.WORLD_HEIGHT * .2 && !item.falling) {
        ret = true;
      }
    });
    return ret;
  }

  void deleteAllItem(children) {
    children
        .where((element) => element is FallItem)
        .forEach((element) {
          element.removeFromParent();
          _onScreenItems.clear();
        });
  }

  void _showNextItem() {
    _nextItemSprite.setImage(
        img.fromCache(get(_nextItemIndex).image));
  }
}