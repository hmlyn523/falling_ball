import 'package:fall_game/components/waiting_dialog.dart';
import 'package:fall_game/connectivity_provider.dart';
import 'package:fall_game/fallItem_factory.dart';
import 'package:fall_game/multi_game.dart';
import 'package:flame/events.dart';
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

class FallGameWorld extends Base
  with HasGameReference<Forge2DGame>,
       TapCallbacks,
       DragCallbacks
{
  final images = Flame.images;

  late final List<SpriteComponent> _titleScreen;
  late final PositionComponent _waitingDialog;
  late final List<SpriteComponent> _gameOverScreen;
  late final ScoreLabel _nextItemLabel;
  late final ScoreLabel _scoreLabel;
  late final ScoreLabel _opponentScoreLabel;
  late final ScoreLabel _lobbyNumberLabel;
  late final TapArea tapArea;

  late final MultiGame _multiGame;
  bool _isMulti = false;

  late final ConnectivityProvider _connectivityProvider;

  late FallItemFactory fallItemFactory;

  FallGameWorld()
  {
    Audio.bgmPlay(Audio.AUDIO_TITLE);
  }

  // void handleSpawnEvent(dynamic data) {
  //   add(data);
  // }

  // void handleSpawnRandomEvent(dynamic data) {
  //   add(data);
  // }
  
  void setNextItem(item) {
    _nextItemLabel.text = item.toString();
  }

  void setScore(score) {
    _scoreLabel.setTotal(score);
  }

  void chain() {
    if (_isMulti) {
      _multiGame.chain.addChain();
    }
  }

  // プレイ中かつ落下中のみアイテムをスポーンし、落下位置確認用ラインを消す。
  void spawn(position) {
    if (!_isPlaying()) return;
    if (fallItemFactory.isFalling()) return;
    fallItemFactory.spawn(position);
    Audio.play(Audio.AUDIO_SPAWN);
    tapArea.hideLine();
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

  void drawTitleScreen(bool draw) {
    if (draw) {
      addAll(_titleScreen);
    } else if (!draw) {
      removeTitleScreen(_titleScreen);
    }
  }

  void drawWaitingDialog(bool draw) {
    if (draw) {
      add(_waitingDialog);
    } else if (!draw) {
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
  Future<void> onLoad() async {
    await super.onLoad();

    // ビューファインダーのアンカーを左上に設定し、左上の座標を (0,0) として扱います。
    game.camera.viewfinder.anchor = Anchor.topLeft;

    await game.images.loadAllImages();
    await Audio.load();

    fallItemFactory = FallItemFactory();
    add(fallItemFactory);
    tapArea = TapArea(dragAndTapCallback: spawn );
    add(tapArea);

    _connectivityProvider = ConnectivityProvider();

    _multiGame = MultiGame();
    _lobbyNumberLabel = ScoreLabel(
        position: Vector2(Config.WORLD_WIDTH * .47, Config.WORLD_HEIGHT * .962),
        color: Color.fromRGBO(255, 255, 255, 1));

    _setupListeners();
 
    createWall().forEach(add);
    final foregroundImage = await images.load(Config.IMAGE_FOREGROUND);
    createForegound(foregroundImage).forEach(add);
    final backgroundImage = await images.load(Config.IMAGE_BACKGROUND);
    createBackgound(backgroundImage).forEach(add);

    add(_nextItemLabel = ScoreLabel(
        score: await GameBoard.getScore(),
        position: Vector2(Config.WORLD_WIDTH * .33, Config.WORLD_HEIGHT * .058),
        color: Color.fromRGBO(255, 255, 255, 1)));
    add(_scoreLabel = ScoreLabel(
        score: await GameBoard.getScore(),
        position: Vector2(Config.WORLD_WIDTH * .93, Config.WORLD_HEIGHT * .058),
        color: Color.fromRGBO(255, 255, 255, 1)));
    add(_opponentScoreLabel = ScoreLabel(
        position:
            Vector2(Config.WORLD_WIDTH * .953, Config.WORLD_HEIGHT * .962),
        color: Color.fromRGBO(255, 255, 255, 1)));
    _opponentScoreLabel.isVisible = false;

    add(_lobbyNumberLabel);

    _titleScreen = createTitleScreen();
    _waitingDialog = Connect();
    _gameOverScreen = createGameOverScreen();

    // GameBoard.signedIn();
    // _gameOverScreen = createGameOverScreen();
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

    _nextItemLabel.text = (fallItemFactory.getNextItem().type + 1).toString();

    _scoreLabel.score = 0;
    _opponentScoreLabel.score = 0;

    // タイトル非表示
    drawTitleScreen(false);

    // 落下アイテム削除
    fallItemFactory.deleteAllItem(this.children);

    drawWaitingDialog(false);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_BGM);
    // Playステータスへ繊維
    moveToPlayingState();

    if (_isMulti) {
      _opponentScoreLabel.isVisible = true;
    }

    _showLine();

    fallItemFactory.updateNextItemVisibility(isVisible: true);
  }

  @override
  void play() {
    super.play();

    if (_isMulti) {
      _multiGame.onPlayUpdate(_scoreLabel.score, _isGameOver());
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
      _multiGame.chain.stopChain();
    }

    // 落下アイテム消去
    fallItemFactory.deleteAllItem(this.children);
    drawGameOverScreen(true);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_TITLE);
  }

  @override
  void end() {
    super.end();

    // 得点（リーダーボード）
    // GameBoard.leaderboardScore(_scoreLabel.score);
    // プレイ回数と平均得点（リーダーボード）
    // GameBoard.playCountAndAverageScore(_scoreLabel.score);

    // 落下アイテム消去
    tapArea.hideLine();

    // Titleステータスへ遷移
    moveToTitleState();
  }

  bool _isPlaying() {
    return isPlayingState();
  }

  void _onMultiGameStart() {
    moveToStartState();
  }

  void _onMultiGameOver() {
    moveToGameOverState();
  }

  void _showLine() {
    tapArea.showLine(
        fallItemFactory.getNowItem().image,
        fallItemFactory.getNowItem().size,
        fallItemFactory.getNowItem().radius);
  }

  bool _isGameOver() {
    return fallItemFactory.onScreenItems.any((item) =>
        item.body.position.y < Config.WORLD_HEIGHT * 0.2 && !item.falling);
  }

  void _setupListeners() {
    _multiGame.addGameStartCallback(_onMultiGameStart);
    _multiGame.addGameOverCallback(_onMultiGameOver);
    _multiGame.opponentScore.addListener(_updateOpponentScore);
    _multiGame.opponetBall.addListener(_updateOpponentBall);
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

  void _updateOpponentScore() {
    _multiGame.opponentScore.addListener(_updateOpponentScoreLabel);
  }

  void _updateOpponentBall() {
    var chain = _multiGame.opponetBall.value;
    for (int i = 0; i < chain; i++) {
      fallItemFactory.spawnRandom();
    }
    _multiGame.opponetBall.value = 0;
  }

  void  _updateLobbyMemberCount() {
    _lobbyNumberLabel.text = _multiGame.memberCount.value.toString();
  }

  void _updateOpponentScoreLabel() {
    _opponentScoreLabel.text = _multiGame.opponentScore.value.toString();
  }
}