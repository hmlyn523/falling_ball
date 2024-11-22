import 'dart:async';
import 'dart:math';

import 'package:fall_game/components/audio.dart';
import 'package:fall_game/components/fall_item/falling_item.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/event_bus.dart';
import 'package:fall_game/world.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

class FallingItemFactory extends Component
  with HasWorldReference<FallGameWorld>
{
  final images = Flame.images;

  EventBus eventBus = EventBus();
  final ON_FALL_COMPLETE = "onFallComplete";
  final ON_MERGE_ITEM = "onMergeItem";

  // 落下アイテムリスト
  final FallingItemAttributesCollection _fallCollection = FallingItemAttributesCollection();

  // 現在の落下アイテム
  late int _nowFallingItemIndex;

  // 次の落下アイテム
  late int _nextFallingItemIndex;
  int get nextFallingItemIndex => _nextFallingItemIndex; // ooo

  // 画面に表示されている落下アイテム
  late List<FallingItem> _onScreenFallingItems = [];
  List<FallingItem> get onScreenFallingItems => _onScreenFallingItems;

  // コンストラクタ
  FallingItemFactory() {
    _initialize();
  }

  // 落下アイテムのスポーン
  void spawn(position) {
    position = _adjustedPosition(position);
    _addFallingItemToWorld(_nowFallingItemIndex, position);
    _updateSpawnIndices();
    Audio.play(Audio.AUDIO_SPAWN);
  }

  // ランダムにアイテムをスポーンする。
  void randomSpawn([Vector2? position]) {
    position = position ?? _generateRandomPosition();
    _addFallingItemToWorld(11, position);
    Audio.play(Audio.AUDIO_SPAWN);
  }

  // 落下アイテムの属性情報を取得
  FallingItemAttributes getFallingItemAttributes(index) {
    return _fallCollection.value[index];
  }

  // 現在の落下アイテムの属性情報を取得
  FallingItemAttributes getNowFallingItemAttributes() {
    return _fallCollection.value[_nowFallingItemIndex];
  }

  // 次に落下するアイテムの属性情報を取得
  FallingItemAttributes getNextFallingItemAttributes() {
    return _fallCollection.value[_nextFallingItemIndex];
  }

  //void updateNextItemVisibility({required bool isVisible}) {
    // _nextItemSprite.isVisible = isVisible;
  //}

  // 落下アイテムの種類の数取得
  int getFallingItemAttributesCount() {
    return _fallCollection.value.length;
  }
  
  // 落下中のアイテムが存在するか
  bool isFallingItem() {
    return _onScreenFallingItems.any((element) => element.falling);
  }

  // 全ての落下アイテムを削除
  void deleteAllFallingItem(children) {
    children
        .where((element) => element is FallingItem)
        .forEach((element) {
          element.removeFromParent();
        });
    _onScreenFallingItems.clear();
  }

  // 初期化
  void _initialize() {
    _nowFallingItemIndex = _getSpawnItemRandomIndex();
    _nextFallingItemIndex = _getSpawnItemRandomIndex();
  }

  // 落下アイテム作成
  FallingItem _generateItem(index, position, {double bump = 0.0, double fadeInDuration = 0.0}) {
    var item = FallingItem(
      image: images.fromCache(_fallCollection.value[index].image),
      radius: _fallCollection.value[index].radius,
      size: _fallCollection.value[index].size,
      position: position,
      type: _fallCollection.value[index].type,
      density: _fallCollection.value[index].density,
      bump: bump,
      fadeInDuration: fadeInDuration,
      contactCallback: _collision,
    );
    _onScreenFallingItems.add(item);
    // var num = _onScreenItems.length;
    return item;
  }

  // 落下アイテムを生成してworldに追加
  void _addFallingItemToWorld(int itemIndex, Vector2 position) {
    FallingItem item = _generateItem(itemIndex, position);
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
    _nowFallingItemIndex = _nextFallingItemIndex;
    _nextFallingItemIndex = _getSpawnItemRandomIndex();
  }

  // 落下開始位置の調整
  Vector2 _adjustedPosition(Vector2 position) {
    var adjustedPosition = Vector2(position.x, position.y);
    var r = getFallingItemAttributes(_nowFallingItemIndex).radius;
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

 // ボールが他のボールや壁に衝突した場合に呼び出される。
  void _collision(FallingItem item, Object other, Contact contact) {
    final selfObject = _getSelfObject(item, contact);
    final otherObject = _getOtherObject(item, contact);

    // ボールの落下が完了した場合[isFallingItem=false]、ボールとラインを表示する。
    // ボールの表示は本クラスで行うが、ラインの表示はTapAreaクラスで行うため、
    // whereTypeのfirstを利用してTapAreaコンポーネントの取得を行う。
    if (!isFallingItem()) {
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
    if ((selfObject as FallingItem).type == (otherObject as FallingItem).type) {
      if (_shouldMergeItems(selfObject, contact)) {
        _handleMerge(selfObject, otherObject);
        // world.setNextItem(_nextFallingItemIndex + 1); // ooo
      }
    } else {
      if (selfObject == contact.bodyA.userData) {
        _adjustmentItem(selfObject, otherObject);
      }
    }
  }

  Object? _getSelfObject(FallingItem item, Contact contact) {
    return contact.bodyA.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
  }

  Object? _getOtherObject(FallingItem item, Contact contact) {
    return contact.bodyB.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
  }

  void _handleNonFallingState() {
    // world.setNextItem(_nextFallingItemIndex + 1); // ooo
    eventBus.publish(ON_FALL_COMPLETE, null);
    world.tapArea.line.showLine(
      getNowFallingItemAttributes().image,
      getNowFallingItemAttributes().size,
      getNowFallingItemAttributes().radius,
    );
  }

  bool _shouldMergeItems(FallingItem selfObject, Contact contact) {
    return selfObject == contact.bodyA.userData && !selfObject.deleted;
  }

  void _handleMerge(FallingItem selfObject, FallingItem otherObject) {
    var mergeItemIndex = selfObject.type + 1;
    if (mergeItemIndex < this.getFallingItemAttributesCount() - 1) {
      Vector2 nextItemPosition = _getNextItemPosition(selfObject, otherObject);
      eventBus.publish(ON_MERGE_ITEM, getFallingItemAttributes(mergeItemIndex).score);
      _createAndDisplayNextItem(mergeItemIndex, nextItemPosition);
      _showScore(mergeItemIndex, nextItemPosition);
      _showExplosion(nextItemPosition);

      if (mergeItemIndex < 12) {
        _removeItems(selfObject, otherObject);
      }
    }
  }

  // 新しいアイテムの位置取得
  Vector2 _getNextItemPosition(FallingItem selfObject, FallingItem otherObject) {
    return Vector2(
      (otherObject.body.position.x + selfObject.body.position.x) / 2,
      (otherObject.body.position.y + selfObject.body.position.y) / 2,
    );
  }

  // 新しいアイテム表示
  void _createAndDisplayNextItem(int mergeItemIndex, Vector2 position) {
    // world.setScore(getFallingItemAttributes(mergeItemIndex).score);
    world.chain();
    
    Future.delayed(Duration(milliseconds: 50), () {
      var FallingItem = _generateItem(mergeItemIndex, position, fadeInDuration: 0.1);
      FallingItem.priority = 0;
      world.add(FallingItem);
    });
  }

  // 得点表示
  void _showScore(int mergeItemIndex, Vector2 position) {
    final scoreText = TextComponent(
      text: getFallingItemAttributes(mergeItemIndex).score.toString(),
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
  void _removeItems(FallingItem selfObject, FallingItem otherObject) {
    selfObject.removeItem();
    otherObject.removeItem();
    _onScreenFallingItems.remove(selfObject);
    _onScreenFallingItems.remove(otherObject);
    Audio.play(Audio.AUDIO_COLLISION);
  }

  void _adjustmentItem(FallingItem selfObject, FallingItem otherObject) {
    if ((selfObject.body.position.x == otherObject.body.position.x)) {
      var rand = Random().nextInt(2);
      var move = (rand * 2 - 1).toDouble();
      selfObject.body.linearVelocity = Vector2(move, 0);
    }
  }

  // bool isGameOver() {
  //   bool ret = false;
  //   _onScreenItems.forEach((element) {
  //     FallingItem item = element;
  //     if (item.body.position.y < Config.WORLD_HEIGHT * .8 && !item.falling) { // ⭐️.8 -> .2に戻すこと
  //       ret = true;
  //     }
  //   });
  //   return ret;
  // }

}