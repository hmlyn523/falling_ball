import 'package:fall_game/components/waiting_dialog.dart';
import 'package:fall_game/connectivity_provider.dart';
import 'package:fall_game/fallingItem_factory.dart';
import 'package:fall_game/multi_game.dart';
import 'package:fall_game/ui_manager.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:fall_game/components/game_over_screen.dart';
import 'package:fall_game/components/tap_area.dart';
import 'package:fall_game/base/base.dart';
import 'package:fall_game/components/background.dart';
import 'package:fall_game/components/wall.dart';
import 'package:fall_game/components/audio.dart';
import 'package:fall_game/config.dart';

class FallGameWorld extends Base
  with HasGameReference<Forge2DGame>,
       TapCallbacks,
       DragCallbacks
{
  final images = Flame.images;

  late final UIManager uiManager;

  late final PositionComponent _waitingDialog;
  late final List<SpriteComponent> _gameOverScreen;
  late final TapArea tapArea;

  late final MultiGame _multiGame;
  bool _isMulti = false;

  late final ConnectivityProvider _connectivityProvider;

  late FallingItemFactory fallingItemFactory;

  FallGameWorld()
  {
    Audio.bgmPlay(Audio.AUDIO_TITLE);
  }

  void chain() {
    if (_isMulti) {
      _multiGame.chain.addChain();
    }
  }

  // プレイ中かつ落下中のみアイテムをスポーンし、落下位置確認用ラインを消す。
  void spawn(position) {
    if (!_isPlaying()) return;
    if (fallingItemFactory.isFallingItem()) return;
    fallingItemFactory.spawn(position);
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

    // ビューファインダーの設定(左上の座標を0,0として扱う)
    await _initializeCamera();

    uiManager = UIManager();

    await uiManager.initializeLabels();
    uiManager.addLabelsToGame(this);

    // 画像やオーディオの読み込み
    await _loadAssets();

    // 必要なコンポーネントや依存関係の初期化
    _setupConnectivityListener();
    _setupMultiGame();
    _setupFactories();

    // 壁や背景などの描画要素を追加
    _setupUIComponents();

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
    uiManager.showTitle(this);
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

    var nextItemType = (fallingItemFactory.getNextFallingItemAttributes().type + 1);
    uiManager.updateNextItemLabel(nextItemType);

    uiManager.resetScores();

    // タイトル非表示
    uiManager.hideTitle(this);

    // 落下アイテム削除
    fallingItemFactory.deleteAllFallingItem(this.children);

    drawWaitingDialog(false);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_BGM);
    // Playステータスへ繊維
    moveToPlayingState();

    if (_isMulti) {
      uiManager.showOpponentScoreLabel();
    }

    _showLine();
  }

  @override
  void play() {
    super.play();

    if (_isMulti) {
      _multiGame.onPlayUpdate(uiManager.scoreLabel, _isGameOver());
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
    fallingItemFactory.deleteAllFallingItem(this.children);
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

  Future<void> _initializeCamera() async {
    game.camera.viewfinder.anchor = Anchor.topLeft;
  }

  Future<void> _loadAssets() async {
    await game.images.loadAllImages();
    await Audio.load();
  }

  void _setupFactories() {
    fallingItemFactory = FallingItemFactory();
    add(fallingItemFactory);
    fallingItemFactory.eventBus.subscribe(fallingItemFactory.ON_FALL_COMPLETE, (_) {
      // アイテムの落下が完了したら呼ばれ、次のアイテムの番号をNEXTに表示
      var item = fallingItemFactory.nextFallingItemIndex + 1;
      uiManager.updateNextItemLabel(item);
    });
    fallingItemFactory.eventBus.subscribe(fallingItemFactory.ON_MERGE_ITEM, (score) {
      // アイテムがマージされたら呼ばれ、アイテムのスコア更新
      uiManager.updateScore(score);
    });
  }

  void _setupUIComponents() {
    tapArea = TapArea(dragAndTapCallback: spawn );
    add(tapArea);

    createWall().forEach(add);
    _addForegroundAndBackground();
    _waitingDialog = Connect();
    _gameOverScreen = createGameOverScreen();
  }

  Future<void> _addForegroundAndBackground() async {
    final foregroundImage = await images.load(Config.IMAGE_FOREGROUND);
    createForegound(foregroundImage).forEach(add);
    final backgroundImage = await images.load(Config.IMAGE_BACKGROUND);
    createBackgound(backgroundImage).forEach(add);
  }

  void _setupConnectivityListener() {
    _connectivityProvider = ConnectivityProvider();
    _connectivityProvider.addListener(_onConnectivityChanged);
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
        fallingItemFactory.getNowFallingItemAttributes().image,
        fallingItemFactory.getNowFallingItemAttributes().size,
        fallingItemFactory.getNowFallingItemAttributes().radius);
  }

  bool _isGameOver() {
    return fallingItemFactory.onScreenFallingItems.any((item) =>
        item.body.position.y < Config.WORLD_HEIGHT * 0.2 && !item.falling);
  }

  void _setupMultiGame() {
    _multiGame = MultiGame();
    _multiGame.addGameStartCallback(_onMultiGameStart);
    _multiGame.addGameOverCallback(_onMultiGameOver);
    _multiGame.opponentScore.addListener(_updateOpponentScoreLabel);
    _multiGame.opponetBall.addListener(_updateOpponentBall);
    _multiGame.memberCount.addListener(_updateLobbyMemberCount);
  }

  void _onConnectivityChanged() {
    if (_connectivityProvider.isOnline) {
      _multiGame.onOnline();
    } else {
      _multiGame.onOffline();
    }
  }

  void _updateOpponentBall() {
    var chain = _multiGame.opponetBall.value;
    for (int i = 0; i < chain; i++) {
      fallingItemFactory.randomSpawn();
    }
    _multiGame.opponetBall.value = 0;
  }

  void  _updateLobbyMemberCount() {
    var count = _multiGame.memberCount.value;
    uiManager.updateLobbyNumber(count);
  }

  void _updateOpponentScoreLabel() {
    var score = _multiGame.opponentScore.value;
    uiManager.updateOpponentScore(score);
  }
}