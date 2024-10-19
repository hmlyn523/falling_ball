import 'dart:math';

import 'package:fall_game/components/waiting_dialog.dart';
import 'package:fall_game/connectivity_provider.dart';
import 'package:fall_game/event_bus.dart';
import 'package:fall_game/fallItem_factory.dart';
import 'package:fall_game/multi_game.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:fall_game/components/game_over_screen.dart';
import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/components/tap_area.dart';
import 'package:fall_game/base/base.dart';
import 'package:fall_game/components/background.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/components/title_screen.dart';
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
          camera: CameraComponent.withFixedResolution(
            width: Config.WORLD_WIDTH,
            height: Config.WORLD_HEIGHT,
          ),
          zoom: 1,
        );
}

class FallGameWorld extends Base with HasGameReference<Forge2DGame> {
  late final List<SpriteComponent> _titleScreen;
  late final PositionComponent _waitingDialog;
  late final List<SpriteComponent> _gameOverScreen;
  late final ScoreLabel _scoreLabel;
  late final ScoreLabel _opponentScoreLabel;
  late final ScoreLabel _lobbyNumberLabel;
  // late final NextSprite _nextItemSprite;
  late TapArea _tapArea;

  // late int _nowItemIndex;
  // late int _nextItemIndex;

  late final MultiGame _multiGame;
  bool _isMulti = false;

  final img = Flame.images;

  late ConnectivityProvider _connectivityProvider;

  late EventBus eventBus;
  late FallItemFactory fallItemFactory;

  FallGameWorld() {
    Audio.bgmPlay(Audio.AUDIO_TITLE);
    eventBus = EventBus();
    fallItemFactory = FallItemFactory(eventBus);
    _tapArea = TapArea(fallItemFactory.spawn, eventBus);
    _multiGame = MultiGame(eventBus);
    eventBus.subscribe('scoreLabel', (score) {
      _scoreLabel.setTotal(score);
    });
    eventBus.subscribe('chain', (score) {
      if (_isMulti) {
        _multiGame.chain.addChain();
      }
    });
    eventBus.subscribe('addItemEvent', () {
      fallItemFactory.spawnRandomItem();
    });
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    add(fallItemFactory);

    _connectivityProvider = ConnectivityProvider();

    _setupListeners();

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

    add(_tapArea);

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
    _multiGame.onWaiting();
    moveToPreparationState();
  }

  // 接続中にCANCELボタンが押されたら呼ばれる
  void cancelWaiting() async {
    _multiGame.removeWaitingChannel();
    moveToTitleState();
  }

  void _onMultiGameStart() {
    moveToStartState();
  }

  void _onMultiGameOver() {
    moveToGameOverState();
  }

  void _showLine() {
    _tapArea.showLine(
        fallItemFactory.getNowItem().image,
        fallItemFactory.getNowItem().size,
        fallItemFactory.getNowItem().radius);
  }

  void _hideLine() {
    _tapArea.hideLine();
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
    _multiGame.onWaitingUpdate();
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
    fallItemFactory.deleteItem();

    drawWaitingDialog(false);
    // _multiGame.onWaitingUpdate();
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_BGM);
    // Playステータスへ繊維
    moveToPlayingState();

    if (_isMulti) {
      _opponentScoreLabel.isVisible = true;
    }

    _showLine();

    fallItemFactory.setNextItemVisibility(true);
  }

  @override
  void play() {
    super.play();

    if (_isMulti) {
      _multiGame.onPlayUpdate(_scoreLabel.score, fallItemFactory.isGameOver());
    }

    if (fallItemFactory.isGameOver()) {
      moveToGameOverState();
    }
  }

  @override
  void gameover() {
    super.gameover();

    // 連鎖
    if (_isMulti) {
      _multiGame.chain.stopChain();
    }

    // 落下アイテム消去
    fallItemFactory.deleteItem();
    drawGameOverScreen(true);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_TITLE);
    // supabase.removeChannel(_gameChannel!);
    // _multiGame.removeGameChannel(); aaa
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

  void _setupListeners() {
    _multiGame.addGameStartCallback(_onMultiGameStart);
    _multiGame.addGameOverCallback(_onMultiGameOver);
    _multiGame.opponentScore.addListener(_updateOpponentScore);
    _multiGame.memberCount.addListener(_updateLobbyMemberCount);
    _connectivityProvider.addListener(_onConnectivityChanged);
  }

  void _onConnectivityChanged() {
    if (_connectivityProvider.isOnline) {
      _multiGame.onOffline();
    } else {
      _multiGame.onOnline();
    }
  }

  void _spawnRandomItem() {
    var rand = Random().nextDouble() * (.8 - .2) + .2;
    var posWidth = Config.WORLD_WIDTH * rand;
    var pos = Vector2(posWidth, Config.WORLD_HEIGHT * .8);
    add(fallItemFactory.create(11, pos));
  }

  void _updateOpponentScore() {
    _multiGame.opponentScore.addListener(_updateOpponentScoreLabel);
  }

  void  _updateLobbyMemberCount() {
    _lobbyNumberLabel.text = _multiGame.memberCount.value.toString();
  }

  void _updateOpponentScoreLabel() {
    _opponentScoreLabel.text = _multiGame.opponentScore.value.toString();
  }
}
