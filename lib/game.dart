import 'dart:math';

import 'package:fall_game/components/waiting_dialog.dart';
import 'package:fall_game/multi_game.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:fall_game/components/fall_item/next_sprite.dart';
import 'package:fall_game/components/game_over_screen.dart';
import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/components/tap_area.dart';
import 'package:fall_game/base/base.dart';
import 'package:fall_game/components/background.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/components/title_screen.dart';
import 'package:fall_game/components/fall_item/fall_item.dart';
import 'package:fall_game/components/audio.dart';
import 'package:fall_game/components/game_board.dart';
import 'package:fall_game/config.dart';
import 'package:flutter/material.dart';

class FallGame extends Forge2DGame {
  final context;

  FallGame({required this.context})
      : super(
          //zoom: 40,
          gravity: Vector2(0, 30.0),
          world: FallGameWorld(),
          cameraComponent: CameraComponent.withFixedResolution(
            width: Config.WORLD_WIDTH,
            height: Config.WORLD_HEIGHT,
          ),
          zoom: 1,
        );
}

class FallGameWorld extends Base with HasGameReference<Forge2DGame> {
  late final List<SpriteComponent> _titleScreen;
  // late final List<PositionComponent> _waitingDialog;
  late final PositionComponent _waitingDialog;
  late final List<SpriteComponent> _gameOverScreen;
  late final ScoreLabel _scoreLabel;
  late final ScoreLabel _opponentScoreLabel;
  late final ScoreLabel _lobbyNumberLabel;
  late final NextSprite _nextFallItemSprite;
  late TapArea _tapArea;

  final FallList _fallList = FallList(); // 玉の情報
  late int _nowFallItemIndex;
  late int _nextFallItemIndex;

  late final MultiGame multiGame;
  bool _isMulti = false;

  final img = Flame.images;

  FallGameWorld() {
    Audio.bgmPlay(Audio.AUDIO_TITLE);
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    multiGame = MultiGame(
      multiGameStartCallback,
      multiGameOverCallback,
    );
    multiGame.onGame();
    // 相手のスコア
    multiGame.opponentScore.addListener(() {
      _opponentScoreLabel.text = multiGame.opponentScore.value.toString();
    });
    // 連鎖
    multiGame.opponetBall.addListener(() {
      var chain = multiGame.opponetBall.value;
      for (int i = 0; i < chain; i++) {
        var rand = Random().nextDouble() * (.8 - .2) + .2;
        var posWidth = Config.WORLD_WIDTH * rand;
        var pos = Vector2(posWidth, Config.WORLD_HEIGHT * .8);
        this.add(_createFallItem(0, pos));
      }
      multiGame.opponetBall.value = 0;
    });
    // 参加人数
    multiGame.memberCount.addListener(() {
      _lobbyNumberLabel.text = multiGame.memberCount.value.toString();
    });

    // デバッグ用のFPT表示
    // game.camera.viewport.add(FpsTextComponent());

    // Set the viewfinder anchor to the top left and treat the top left coordinates as (0,0).
    // ビューファインダーのアンカーを左上に設定し、左上の座標を (0,0) として扱います。
    game.camera.viewfinder.anchor = Anchor.topLeft;

    await game.images.loadAllImages();
    await Audio.load();

    createWall().forEach(add);
    // final backgroundImage = game.images.fromCache(Config.IMAGE_BACKGROUND);
    final foregroundImage = await img.load(Config.IMAGE_FOREGROUND);
    createForegound(foregroundImage).forEach(add);
    final backgroundImage = await img.load(Config.IMAGE_BACKGROUND);
    createBackgound(backgroundImage).forEach(add);

    add(_scoreLabel = ScoreLabel(
        score: await GameBoard.getScore(),
        position: Vector2(Config.WORLD_WIDTH * .85, Config.WORLD_HEIGHT * .044),
        color: Color.fromRGBO(0, 0, 0, 1)));
    add(_opponentScoreLabel = ScoreLabel(
        position:
            Vector2(Config.WORLD_WIDTH * .953, Config.WORLD_HEIGHT * .974),
        color: Color.fromRGBO(0, 0, 0, 1)));
    _opponentScoreLabel.isVisible = false;

    add(_lobbyNumberLabel = ScoreLabel(
        position: Vector2(Config.WORLD_WIDTH * .47, Config.WORLD_HEIGHT * .974),
        color: Color.fromRGBO(0, 0, 0, 1)));

    _titleScreen = createTitleScreen();
    _waitingDialog = Connect();
    _gameOverScreen = createGameOverScreen();

    _nowFallItemIndex = _getFallItemIndex();
    _nextFallItemIndex = _getFallItemIndex();
    // final nextSpriteImage = game.images.fromCache(_fallList.value[_nextFallItemIndex].image);
    final nextSpriteImage =
        await img.load(_fallList.value[_nextFallItemIndex].image);
    _nextFallItemSprite = NextSprite(nextSpriteImage);
    add(_nextFallItemSprite);
    add(_tapArea = TapArea(spawn));

    // GameCenter
//    GameBoard.signedIn();
  }

  // Singleボタンが押されたら呼ばれる
  void singleStart() {
    _isMulti = false;
    moveToStartState();
  }

  // Multiボタンが押されたら呼ばれる
  void multiStart() async {
    _isMulti = true;
    multiGame.onWaiting();
    moveToPreparationState();
  }

  // 接続中にCANCELボタンが押されたら呼ばれる
  void cancelWaiting() async {
    multiGame.removeWaitingChannel();
    moveToTitleState();
  }

  void multiGameStartCallback() {
    moveToStartState();
  }

  void multiGameOverCallback() {
    moveToGameOverState();
  }

  //////////////////////////////////////
  int _getFallItemIndex() {
    final List<int> _randomList = [20, 20, 20, 20, 20];
    // final List<int> _randomList = [22, 18, 20, 21, 19];
    // final List<int> randList = [25, 15, 22, 23, 15];
    // final List<int> randList = [20, 20, 20, 20, 20];
    _randomList.sort((a, b) => a.compareTo(a));
    var rand = Random().nextInt(100);
    var rate = 0;
    for (int index = 0; index < _randomList.length; index++) {
      rate += _randomList[index];
      if (rand <= rate) {
        return index;
      }
    }
    return 0;
  }

  void spawn(position) {
    // 落下中のアイテムがなければ新しく落下させる
    if (!_isFalling()) {
      // 落下開始位置調整
      position = _adjustFallStartPosition(position);
      // 落下アイテム生成
      this.add(_createFallItem(_nowFallItemIndex, position));
      Audio.play(Audio.AUDIO_SPAWN);

      _nowFallItemIndex = _nextFallItemIndex;
      _nextFallItemIndex = _getFallItemIndex();
    }
  }

  bool _isFalling() {
    var falling = false;
    this.children.where((element) => element is FallItem).forEach((element) {
      if ((element as FallItem).falling) {
        falling = true;
        return;
      }
    });
    return falling;
  }

  // 落下アイテム生成
  FallItem _createFallItem(index, position,
      {bump = 0.0, fadeInDuration = 0.0}) {
    return FallItem(
      image: game.images.fromCache(_fallList.value[index].image),
      radius: _fallList.value[index].radius,
      size: _fallList.value[index].size,
      positionex: position,
      type: _fallList.value[index].type,
      density: _fallList.value[index].density,
      bump: bump,
      fadeInDuration: fadeInDuration,
      contactCallback: _collision,
    );
  }

  // ボールが他のボールや壁に衝突した場合に呼び出される。
  void _collision(FallItem item, Object other, Contact contact) {
    final selfObject = contact.bodyA.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;
    final otherObject = contact.bodyB.userData == item
        ? contact.bodyA.userData
        : contact.bodyB.userData;

    // ボールの落下が完了した場合[isFalling=false]、ボールとラインを表示する。
    // ボールの表示は本クラスで行うが、ラインの表示はTapAreaクラスで行うため、
    // whereTypeのfirstを利用してTapAreaコンポーネントの取得を行う。
    if (!_isFalling()) {
      _showNextFallItem();
      _showLine();
    }

    // ボールがぶつかった相手が、壁の場合は何も処理をせずに終了する。
    if (other is Wall) {
      return;
    }

    // 同じ番号のボールが衝突した場合、次の番号のボールをぶつかったボールの中間点に表示する。
    // ただし、すでにボールが削除のタイミングに入っている[deleted=true]、次の番号が最大ボール番号より大きい場合は、
    // ボールを削除するだけ。あとぶつかったボールそれぞれで衝突コールバックが呼ばれるので、contactのbodyAの場合のみ
    // 衝突処理を行い、BodyBの場合はボールの削除のみを行う。
    // [_adjustmentFallItem]
    // 違う番号のボールがぶつかった場合、同じX座標だとボールが重なってしまうので左右どちらかに移動させる。
    if ((selfObject as FallItem).type == (otherObject as FallItem).type) {
      if (selfObject == contact.bodyA.userData &&
          !selfObject.deleted &&
          !otherObject.deleted) {
        var mergeFallItemIndex = selfObject.type + 1;
        if (mergeFallItemIndex < _fallList.value.length) {
          Vector2 _nextFallItemPosition = Vector2.zero();
          _nextFallItemPosition.x =
              ((otherObject.body.position.x + selfObject.body.position.x) / 2);
          _nextFallItemPosition.y =
              ((otherObject.body.position.y + selfObject.body.position.y) / 2);
          _scoreLabel.setTotal(_fallList.value[mergeFallItemIndex].score);

          // 連鎖
          if (_isMulti) {
            multiGame.chain.addChain();
          }

          // 新しいアイテム表示
          Future.delayed(Duration(milliseconds: 50), () {
            var fallItem = _createFallItem(mergeFallItemIndex, _nextFallItemPosition,
                fadeInDuration: 0.1);
            fallItem.priority = 0;
            add(fallItem);
          });

          // 爆発
          add(SpriteAnimationComponent.fromFrameData(
            game.images.fromCache("explosion.png"),
            SpriteAnimationData.sequenced(
              textureSize: Vector2.all(32),
              amount: 6,
              stepTime: 0.1,
              loop: false,
            ),
            position: Vector2(_nextFallItemPosition.x, _nextFallItemPosition.y),
            size: Vector2(8,8),
            anchor: Anchor.center,
            priority: 1
          ));
        }
        selfObject.removeItem();
        otherObject.removeItem();
        Audio.play(Audio.AUDIO_COLLISION);
        return;
      }
    } else {
      if (selfObject == contact.bodyA.userData) {
        _adjustmentFallItem(selfObject, otherObject);
      }
    }
  }

  void _showLine() {
    _tapArea.showLine(
        _fallList.value[_nowFallItemIndex].image,
        _fallList.value[_nowFallItemIndex].size,
        _fallList.value[_nowFallItemIndex].radius);
  }

  void _hideLine() {
    _tapArea.hideLine();
  }

  //////////////////////////////////////
  void _adjustmentFallItem(FallItem selfObject, FallItem otherObject) {
    if ((selfObject.body.position.x == otherObject.body.position.x)) {
      var rand = Random().nextInt(2);
      var move = (rand * 2 - 1).toDouble();
      selfObject.body.linearVelocity = Vector2(move, 0);
    }
  }

  void _showNextFallItem() {
    _nextFallItemSprite.setImage(
        game.images.fromCache(_fallList.value[_nextFallItemIndex].image));
  }

  bool _isGameOver() {
    bool ret = false;
    // _world.children.where((element) => element is FallItem).forEach((element) {
    this.children.where((element) => element is FallItem).forEach((element) {
      FallItem item = element as FallItem;
      if (item.body.position.y < Config.WORLD_HEIGHT * .2 && !item.falling) {
        ret = true;
      }
    });
    return ret;
  }

  //////////////////////////////////////
  // 落下開始位置の調整
  Vector2 _adjustFallStartPosition(position) {
    var r = _fallList.value[_nowFallItemIndex].radius;
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

  void drawTitleScreen(bool draw) {
    if (draw) {
      addAll(_titleScreen);
    } else if (!draw) {
      removeTitleScreen(_titleScreen);
    }
  }

  void drawWaitingDialog(bool draw) {
    if (draw) {
      // addAll(_waitingDialog);
      add(_waitingDialog);
    } else if (!draw) {
      // removeWaitingDialog(_waitingDialog);
      _waitingDialog.removeFromParent();
    }
  }

  void drawGameOverScreen(bool draw) {
    if (draw) {
      addAll(_gameOverScreen);
    } else if (!draw) {
      removeGameOverScreen(_gameOverScreen);
    }
  }

  void deleteFallItem() {
    children
        .where((element) => element is FallItem)
        .forEach((element) => element.removeFromParent());
  }

  @override
  void title() {
    super.title();

    // 接続中画面非表示
    drawWaitingDialog(false);

    // ゲームオーバ非表示
    drawGameOverScreen(false);

    // タイトル表示
    drawTitleScreen(true);
  }

  @override
  void preparation() {
    super.preparation();

    drawWaitingDialog(true);
    multiGame.onWaitingUpdate();
  }

  @override
  void start() {
    super.start();

    // スコア初期化
    _scoreLabel.score = 0;
    _opponentScoreLabel.score = 0;

    // タイトル非表示
    drawTitleScreen(false);

    // 落下アイテム削除
    deleteFallItem();

    drawWaitingDialog(false);
    // multiGame.onWaitingUpdate();
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_BGM);
    // Playステータスへ繊維
    moveToPlayingState();

    if (_isMulti) {
      _opponentScoreLabel.isVisible = true;
    }

    _showLine();

    _nextFallItemSprite.isVisible = true;
  }

  @override
  void play() {
    super.play();

    if (_isMulti) {
      multiGame.onPlayUpdate(_scoreLabel.score, _isGameOver());
    }

    if (_isGameOver()) {
      moveToGameOverState();
    }
  }

  @override
  void gameover() {
    super.gameover();

    // 連鎖
    if (_isMulti) {
      multiGame.chain.stopChain();
    }

    // 落下アイテム消去
    deleteFallItem();
    drawGameOverScreen(true);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_TITLE);
    // supabase.removeChannel(_gameChannel!);
    // multiGame.removeGameChannel(); aaa
  }

  @override
  void end() {
    super.end();

    // 得点（リーダーボード）
    // GameBoard.leaderboardScore(_scoreLabel.score);
    // プレイ回数と平均得点（リーダーボード）
    // GameBoard.playCountAndAverageScore(_scoreLabel.score);

    // 落下アイテム消去
    _hideLine();

    // Titleステータスへ遷移
    moveToTitleState();
  }
}
