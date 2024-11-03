import 'dart:async';
import 'dart:math';

import 'package:fall_game/components/audio.dart';
import 'package:fall_game/components/fall_item/fall_item.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/world.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class FallItemFactory extends Component
  with HasWorldReference<FallGameWorld>
{
  final images = Flame.images;

  // 落下アイテムリスト
  final FallList _fallList = FallList();

  // 現在の落下アイテム
  late int _nowItemIndex;

  // 次の落下アイテム
  late int _nextItemIndex;

  // 画面に表示されている落下アイテム
  late List<FallItem> _onScreenItems = [];
  List<FallItem> get onScreenItems => _onScreenItems;

  // コンストラクタ
  FallItemFactory() {
    _initialize();
  }

  // 初期化処理
  void _initialize() {
    _nowItemIndex = _getSpawnItemRandomIndex();
    _nextItemIndex = _getSpawnItemRandomIndex();
  }

  FallItem _generateItem(index, position, {double bump = 0.0, double fadeInDuration = 0.0}) {
    var item = FallItem(
      image: images.fromCache(_fallList.value[index].image),
      radius: _fallList.value[index].radius,
      size: _fallList.value[index].size,
      position: position,
      type: _fallList.value[index].type,
      density: _fallList.value[index].density,
      bump: bump,
      fadeInDuration: fadeInDuration,
      contactCallback: _collision,
    );
    _onScreenItems.add(item);
    var num = _onScreenItems.length;
    print("---------------> $num");
    return item;
  }

  // 落下アイテムのスポーン
  void spawn(position) {
      position = _adjustedPosition(position);
      _addItemToWorld(_nowItemIndex, position);
      _updateSpawnIndices();
  }

  // 下から1/5の位置にランダムにアイテムをスポーンする。
  void spawnRandom() {
    var position = _generateRandomPosition();
    _addItemToWorld(11, position);
    Audio.play(Audio.AUDIO_SPAWN);
  }

  // アイテムを生成してworldに追加する共通メソッド
  void _addItemToWorld(int itemIndex, Vector2 position) {
    FallItem item = _generateItem(itemIndex, position);
    world.add(item);
  }

  // ランダムに発生させる落下アイテムの位置の生成
  Vector2 _generateRandomPosition() {
    var rand = Random().nextDouble() * (.8 - .2) + .2;
    var posWidth = Config.WORLD_WIDTH * rand;
    var posHeight = Config.WORLD_HEIGHT * .8;
    return Vector2(posWidth, posHeight);
  }

  // 次に生成されるアイテムのインデックス更新
  void _updateSpawnIndices() {
    _nowItemIndex = _nextItemIndex;
    _nextItemIndex = _getSpawnItemRandomIndex();
  }

  // 落下開始位置の調整
  Vector2 _adjustedPosition(Vector2 position) {
    var adjustedPosition = Vector2(position.x, position.y);
    var r = getItem(_nowItemIndex).radius;
    var adjustment = Config.WORLD_WIDTH * .01;

    // 左右の壁との当たり判定の調整
    if (adjustedPosition.x <= WallPosition.topLeft.x + r) {
      adjustedPosition.x = WallPosition.topLeft.x + r + adjustment;
    } else if (adjustedPosition.x >= WallPosition.topRight.x - r) {
      adjustedPosition.x = WallPosition.topRight.x - r - adjustment;
    }

    return adjustedPosition;
  }

  // ランダムに次の落下アイテムを選択する
  int _getSpawnItemRandomIndex() {
    final int sum = Config.itemDischargeProbability.reduce((a, b) => a + b);
    final int rand = Random().nextInt(sum);
    
    int rate = 0;
    return Config.itemDischargeProbability.indexWhere((probability) {
      rate += probability;
      return rand < rate;
    });
  }

  FallInfo getItem(index) {
    return _fallList.value[index];
  }

  FallInfo getNowItem() {
    return _fallList.value[_nowItemIndex];
  }

  FallInfo getNextItem() {
    return _fallList.value[_nextItemIndex];
  }

  void updateNextItemVisibility({required bool isVisible}) {
    // _nextItemSprite.isVisible = isVisible;
  }

  int getCount() {
    return _fallList.value.length;
  }
  
  bool isFalling() {
    return _onScreenItems.any((element) => element.falling);
  }

  // ボールが他のボールや壁に衝突した場合に呼び出される。
  void _collision(FallItem item, Object other, Contact contact) {
    final selfObject = _getSelfObject(item, contact);
    final otherObject = _getOtherObject(item, contact);

    // ボールの落下が完了した場合[isFalling=false]、ボールとラインを表示する。
    // ボールの表示は本クラスで行うが、ラインの表示はTapAreaクラスで行うため、
    // whereTypeのfirstを利用してTapAreaコンポーネントの取得を行う。
    if (!isFalling()) {
      _handleNonFallingState();
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
      if (_shouldMergeItems(selfObject, contact)) {
        _handleMerge(selfObject, otherObject);
        world.setNextItem(_nextItemIndex + 1);
      }
    } else {
      if (selfObject == contact.bodyA.userData) {
        _adjustmentItem(selfObject, otherObject);
      }
    }
  }

  Object? _getSelfObject(FallItem item, Contact contact) {
    return contact.bodyA.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
  }

  Object? _getOtherObject(FallItem item, Contact contact) {
    return contact.bodyB.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
  }
  void _handleNonFallingState() {
    world.setNextItem(_nextItemIndex + 1);
    world.tapArea.line.showLine(
      getNowItem().image,
      getNowItem().size,
      getNowItem().radius,
    );
  }

  bool _shouldMergeItems(FallItem selfObject, Contact contact) {
    return selfObject == contact.bodyA.userData && !selfObject.deleted;
  }

  void _handleMerge(FallItem selfObject, FallItem otherObject) {
    var mergeItemIndex = selfObject.type + 1;
    if (mergeItemIndex < this.getCount() - 1) {
      Vector2 nextItemPosition = _getNextItemPosition(selfObject, otherObject);
      _createAndDisplayNextItem(mergeItemIndex, nextItemPosition);
      _showScore(mergeItemIndex, nextItemPosition);
      _showExplosion(nextItemPosition);

      if (mergeItemIndex < 12) {
        _removeItems(selfObject, otherObject);
      }
    }
  }

  // 新しいアイテムの位置取得
  Vector2 _getNextItemPosition(FallItem selfObject, FallItem otherObject) {
    return Vector2(
      (otherObject.body.position.x + selfObject.body.position.x) / 2,
      (otherObject.body.position.y + selfObject.body.position.y) / 2,
    );
  }

  // 新しいアイテム表示
  void _createAndDisplayNextItem(int mergeItemIndex, Vector2 position) {
    world.setScore(getItem(mergeItemIndex).score);
    world.chain();
    
    Future.delayed(Duration(milliseconds: 50), () {
      var fallItem = _generateItem(mergeItemIndex, position, fadeInDuration: 0.1);
      fallItem.priority = 0;
      world.add(fallItem);
    });
  }

  // 得点表示
  void _showScore(int mergeItemIndex, Vector2 position) {
    final scoreText = TextComponent(
      text: getItem(mergeItemIndex).score.toString(),
      position: position,
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
    world.add(scoreText);

    scoreText.add(MoveEffect.by(Vector2(0, -10), EffectController(duration: .8)));
    scoreText.add(RemoveEffect(delay: .8, onComplete: () => scoreText.removeFromParent()));
  }

  // 爆発
  void _showExplosion(Vector2 position) {
    world.add(SpriteAnimationComponent.fromFrameData(
      images.fromCache("explosion.png"),
      SpriteAnimationData.sequenced(
        textureSize: Vector2.all(32),
        amount: 6,
        stepTime: 0.1,
        loop: false,
      ),
      position: position,
      size: Vector2(8, 8),
      anchor: Anchor.center,
      priority: 1,
    ));
  }

  // アイテム削除
  void _removeItems(FallItem selfObject, FallItem otherObject) {
    selfObject.removeItem();
    otherObject.removeItem();
    _onScreenItems.remove(selfObject);
    _onScreenItems.remove(otherObject);
    Audio.play(Audio.AUDIO_COLLISION);
  }

  void _adjustmentItem(FallItem selfObject, FallItem otherObject) {
    if ((selfObject.body.position.x == otherObject.body.position.x)) {
      var rand = Random().nextInt(2);
      var move = (rand * 2 - 1).toDouble();
      selfObject.body.linearVelocity = Vector2(move, 0);
    }
  }

  // bool isGameOver() {
  //   bool ret = false;
  //   _onScreenItems.forEach((element) {
  //     FallItem item = element;
  //     if (item.body.position.y < Config.WORLD_HEIGHT * .8 && !item.falling) { // ⭐️.8 -> .2に戻すこと
  //       ret = true;
  //     }
  //   });
  //   return ret;
  // }

  void deleteAllItem(children) {
    children
        .where((element) => element is FallItem)
        .forEach((element) {
          element.removeFromParent();
        });
    _onScreenItems.clear();
  }
}