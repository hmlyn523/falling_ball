import 'dart:developer';
import 'dart:math' as math;

import 'package:falling_ball/core/services/player_service.dart';
import 'package:falling_ball/features/game/components/enemyBallHeight.dart';
import 'package:falling_ball/features/game/helpers/auto_falling_timer.dart';
import 'package:falling_ball/core/services/leaderboard_service.dart';
import 'package:falling_ball/features/ui/layer/gameover_layer.dart';
import 'package:falling_ball/features/ui/layer/ranking_layer/ranking_layer.dart';
import 'package:falling_ball/features/ui/layer/title_layer.dart';
import 'package:falling_ball/features/ui/layer/waiting_layer.dart';
import 'package:falling_ball/core/services/connectivity_provider.dart';
import 'package:falling_ball/features/game/factories/fallingItem_factory.dart';
import 'package:falling_ball/features/game/multi_game.dart';
import 'package:falling_ball/features/ui/layer/win_and_lose_layer.dart';
import 'package:falling_ball/features/ui/labels/auto_falling_time.dart';
import 'package:falling_ball/features/ui/labels/lobby_number.dart';
import 'package:falling_ball/features/ui/labels/next_item.dart';
import 'package:falling_ball/features/ui/labels/opponent_score.dart';
import 'package:falling_ball/features/ui/labels/player_score.dart';
import 'package:flame/effects.dart';
import 'package:flame/events.dart';
import 'package:flame/flame.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flame/components.dart';

import 'package:falling_ball/features/game/components/tap_area.dart';
import 'package:falling_ball/base/base.dart';
import 'package:falling_ball/features/game/components/background.dart';
import 'package:falling_ball/features/game/components/wall.dart';
import 'package:falling_ball/features/game/components/audio.dart';
import 'package:falling_ball/app/config.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class FallGameWorld extends Base
  with HasGameReference<Forge2DGame>,
       TapCallbacks,
       DragCallbacks
{
  final context;
  final supabase;
  final images = Flame.images;

  late final LeaderboardService leaderboardService;

  Background? foreground;
  Background? background;
  Background? background_game;

  late final PlayerScore playerScore;
  late final OpponentScore opponentScore;
  late final NextItem nextItem;
  late final LobbyNumber lobbyNumber;
  late final AutoFallingTime autoFallingTime;

  late final TitleDialog titleDialog;
  late final GameoverDialog gameoverDialog;
  late final WaitingDialog waitingDialog;
  late final WinAndLoseDialog winAndLoseDialog;
  RankingLayer? rankingLayer = null;

  late final TapArea tapArea;
  late List<EnemyBallHeightImage> enemyBallHeight = [];

  late final MultiGame _multiGame;
  bool _isMulti = false;
  bool _isWin = true;

  late final ConnectivityProvider _connectivityProvider;

  late FallingItemFactory fallingItemFactory;
  late final autoFallingTimer;

  late final PlayerService playerService;

  // コンストラクタ

  FallGameWorld(this.context, this.supabase)
  {
    Audio.bgmPlay(Audio.AUDIO_TITLE);
  }

  // パブリックメソッド

  void chain(position) {
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
    tapArea.line.hide();
  }

  // Singleボタンが押されたら呼ばれる
  void singleStart() {
    _isMulti = false;
    moveToStartState();
  }

  // Multiボタンが押されたら呼ばれる
  void multiStart({other_players}) async {
    _isMulti = true;
    _multiGame.onWaiting(other_players);
    moveToPreparationState();
  }

  // 接続中にCANCELボタンが押されたら呼ばれる
  void cancelWaiting() async {
    _multiGame.removeWaitingChannel();
    moveToTitleState();
  }

  final List<String> backgroundImages = [
    Config.IMAGE_BACKGROUND1,
    Config.IMAGE_BACKGROUND2,
    Config.IMAGE_BACKGROUND3,
    Config.IMAGE_BACKGROUND4,
    Config.IMAGE_BACKGROUND5,
  ];

  String getRandomImageName() {
    return backgroundImages[math.Random().nextInt(backgroundImages.length)];
  }

  // オーバーライドメソッド

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // ビューファインダーの設定(左上の座標を0,0として扱う)
    await _initializeCamera();

    // 画像やオーディオの読み込み
    await _loadAssets();

    // 必要なコンポーネントや依存関係の初期化
    _setupConnectivityListener();
    _setupMultiGame();
    _setupFactories();
    _setupHelpers();

    // 壁や背景などの描画要素を追加
    _setupUIComponents();

    leaderboardService = LeaderboardService(this.supabase);

    playerService = PlayerService(Supabase.instance.client);
  }

  // 状態遷移ループ

  @override
  void title(d) async {
    super.title(d);

    // 接続中画面非表示
    waitingDialog.setVisibility(false);

    // ゲームオーバ非表示
    gameoverDialog.setVisibility(false);

    // 勝敗非表示
    winAndLoseDialog.setVisibility(false);

    // タイトル表示
    titleDialog.setVisibility(true);
  }

  @override
  void preparation(d) {
    super.preparation(d);

    waitingDialog.setVisibility(true);
    _multiGame.onWaitingUpdate();
  }

  @override
  void start(d) async {
    super.start(d);

    var nextItemType = (fallingItemFactory.getNextFallingItemAttributes().type + 1);
    nextItem.update(nextItemType);

    opponentScore.reset();
    playerScore.reset();

    // ゲームオーバーラインの表示
    foreground?.setVisibility(true);

    // タイトル非表示
    titleDialog.setVisibility(false);

    // 落下アイテム削除
    fallingItemFactory.deleteAllFallingItem(this.children);

    waitingDialog.setVisibility(false);
    Audio.bgmStop();
    Audio.bgmPlay(Audio.AUDIO_BGM);
    // Playステータスへ繊維
    moveToPlayingState();

    if (_isMulti) {
      opponentScore.show();
      _multiGame.sendEnemyBallHeight(0.0);
    }

    _showLine();

    _startAutoFallingTimer();

    background?.setVisibility(false);
    background_game?.setVisibility(true);
  }

  double elapsedTime = 0.0;
  @override
  void play(d) {
    super.play(d);

    if (_isMulti) {
      // フレーム単位で処理
      if (_isGameOver()) {
        _isWin = false;
        _multiGame.resetAndSendGameOver();
      }
      _multiGame.sendScore(playerScore.score);
      _multiGame.sendChain();

      // 指定時間間隔で実行
      elapsedTime += d;
      if (elapsedTime >= Config.ENEMY_BALL_HEIGHT_INTERVAL) {
        elapsedTime = 0.0;
        var height = double.parse(fallingItemFactory.getFallingItemHeight().toStringAsFixed(1));
        _multiGame.sendEnemyBallHeight(height);
        for (var i = 0; i < _multiGame.enemyBallState.length; i++) {
          enemyBallHeight[i].setMark(_multiGame.enemyBallState[i].height);
        }
      }
    } else {
      if (_isGameOver()) {
        moveToFinalizingState();
      }
    }
  }

  @override
  void finalizing(d) async {
    super.finalizing(d);
    
    playerService.addScoreHistory(playerScore.score);
    playerService.updateScoreIfHigher(playerScore.score);

    // アイテムの自動落下タイマー停止
    _stopAutoFallingTimer();

     // ゲームオーバーラインの非表示
    foreground?.setVisibility(false);

    // 連鎖
    if (_isMulti) {
      _multiGame.chain.stopChain();
    }

    // 落下アイテム消去
    fallingItemFactory.deleteAllFallingItem(this.children);

    // ゲーム用BGM停止
    Audio.bgmStop();

    // タイトル用BGM再生
    Audio.bgmPlay(Audio.AUDIO_TITLE);

    moveToGameOverState();
  }

  @override
  void gameover(d) {
    super.gameover(d);

    gameoverDialog.setVisibility(true);

    if (_isMulti) {
      winAndLoseDialog.setWinVisibility(_isWin);
    }
  }

  @override
  void end(d) {
    super.end(d);

    // 落下アイテム消去
    tapArea.line.hide();

    if (_isMulti) {
      for(int i=0; i< enemyBallHeight.length; i++) {
        enemyBallHeight[i].setMark(null);
      }
    }

    _isWin = true;

    background?.setVisibility(true);
    background_game?.setVisibility(false);

    _setupBackground();

    // Titleステータスへ遷移
    moveToTitleState();
  }

  // プライベートメソッド

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
      nextItem.update(item);
      // タイマーが停止中かつ画面をタップしていなければタイマー開始
      if (!autoFallingTimer.isRunning() && !tapArea.isDragged) {
        _startAutoFallingTimer();
      }
      tapArea.line.show(
        fallingItemFactory.getNowFallingItemAttributes().image,
        fallingItemFactory.getNowFallingItemAttributes().size,
        fallingItemFactory.getNowFallingItemAttributes().radius);
    });
    fallingItemFactory.eventBus.subscribe(fallingItemFactory.ON_MERGE_ITEM, (score) {
      // アイテムがマージされたら呼ばれ、アイテムのスコア更新
      playerScore.update(score);
    });
  }

  void _setupHelpers() {
    autoFallingTimer = AutoFallingTimer(
      interval: Duration(seconds: Config.AUTO_FALLING_INTERVAL),
      onTimeout: _onAutoFallingTimeout,
    );
  }

  Future<void> _setupUIComponents() async {
    // UI
    playerScore = await PlayerScore.create();
    opponentScore = await OpponentScore.create();
    nextItem = await NextItem.create();
    lobbyNumber = await LobbyNumber.create();
    autoFallingTime = await AutoFallingTime.create();

    add(playerScore.label);
    add(opponentScore.label);
    add(nextItem.label);
    add(lobbyNumber.label);
    add(autoFallingTime.label);

    // final random = math.Random();
    // double value = 0.1 + math.Random().nextDouble() * (0.3 - 0.1);
    tapArea = TapArea(
      tapDown: ((_) => {
        // タップしてもタイマーを停止せずに、指定時間間隔で落下させるようにすためにコメントアウト
        // ゲーム実行中に画面をタップしたら自動落下タイマーを停止
        // if (isPlayingState()) _stopAutoFallingTimer()
      }),
      tapUp: ((position) => {
        if (isPlayingState()) {
          _stopAutoFallingTimer(),
          add(SpriteAnimationComponent.fromFrameData(
            images.fromCache("hanabi.png"),
            SpriteAnimationData.sequenced(
              textureSize: Vector2.all(32),
              amount: 12,
              stepTime: 0.1,
              loop: false,
            ),
            position: Vector2(position.x, position.y + Config.WORLD_HEIGHT * (0.1 + math.Random().nextDouble() * (0.3 - 0.1))),
            size: Vector2(12, 12),
            anchor: Anchor.center,
            priority: Config.PRIORITY_HANABI,
          )),
          spawn(position),
        }
      }));
    add(tapArea);

    titleDialog = TitleDialog();
    add(titleDialog);

    waitingDialog = WaitingDialog();
    add(waitingDialog);

    gameoverDialog = GameoverDialog();
    add(gameoverDialog);

    winAndLoseDialog = WinAndLoseDialog();
    add(winAndLoseDialog);

    createWall().forEach(add);
    _setupBackground();

    // 対戦相手の最大数分の情報を用意しておく
    // 例えば対戦相手が1人だったとしても、2人分用意しておく。
    // なぜならばこのonLoadの時点では対戦相手はわかっていないので
    List<int> values = List.generate(Config.MAX_OTHER_PLAYER_COUNT, (index) => index);
    values.shuffle(math.Random());

    for(int i = 0; i < values.length; i++) {
      final imageName = Config.ENEMY_BALL_HEIGHT_IMAGES[values[i]];
      final loadImage = await images.fromCache(imageName);
      var height = EnemyBallHeightImage(loadImage);
      enemyBallHeight.add(height);
    }
    addAll(enemyBallHeight);
  }

  Future<void> _setupBackground() async {
    foreground?.removeFromParent();
    background?.removeFromParent();
    background_game?.removeFromParent();

    final foregroundImage = await images.fromCache(Config.IMAGE_FOREGROUND);
    // final backgroundImage = await images.load(Config.IMAGE_BACKGROUND);
    // final backgroundGameImage = await images.load(Config.IMAGE_BACKGROUND_GAME);
    final backgroundImage = await images.fromCache(getRandomImageName());
    final backgroundGameImage = await images.fromCache(getRandomImageName());
    foreground = Background(image: foregroundImage, priority: Config.PRIORITY_BACK_F);
    background = Background(image: backgroundImage, priority: Config.PRIORITY_BACK_B);
    background_game = Background(image: backgroundGameImage, priority: Config.PRIORITY_BACK_GAME_B);
    add(foreground as Component);
    add(background as Component);
    add(background_game as Component);
    background?.setVisibility(true);
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
    moveToFinalizingState();
  }

  void _onMultiCombo() {
     final scoreText = TextComponent(
      text: 'Combo!',
      position: fallingItemFactory.mergeItemPotision,
      anchor: Anchor.center,
      textRenderer: TextPaint(
        style: const TextStyle(
          fontFamily: 'Square-L',
          color: Colors.yellowAccent,
          fontSize: 10,
        ),
      ),
      priority: 2,
    );
    add(scoreText);

    scoreText.add(MoveEffect.by(Vector2(0, -5), EffectController(duration: .8)));
    scoreText.add(RemoveEffect(delay: .8, onComplete: () => scoreText.removeFromParent()));
  }

  void _showLine() {
    tapArea.line.show(
        fallingItemFactory.getNowFallingItemAttributes().image,
        fallingItemFactory.getNowFallingItemAttributes().size,
        fallingItemFactory.getNowFallingItemAttributes().radius);
  }

  bool _isGameOver() {
    return fallingItemFactory.onScreenFallingItems.any((item) =>
        item.body.position.y < Config.WORLD_HEIGHT * 0.2 && (item.falling == false));
  }

  void _setupMultiGame() {
    _multiGame = MultiGame(context, supabase);
    _multiGame.addGameStartCallback(_onMultiGameStart);
    _multiGame.addGameOverCallback(_onMultiGameOver);
    _multiGame.addComboCallback(_onMultiCombo);
    _multiGame.opponentScore.addListener(_updateOpponentScoreLabel);
    _multiGame.opponetBall.addListener(_updateOpponentBall);
    _multiGame.memberCount.addListener(_updateLobbyMemberCount);
  }

  void _onConnectivityChanged() {
    if (_connectivityProvider.isOnline) {
      // _multiGame.onOnline();
      log('Connectivity change -------------------------------------------> online');
    } else {
      // _multiGame.onOffline();
      log('Connectivity change -------------------------------------------> offline');
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
    lobbyNumber.update(count);
  }

  void _updateOpponentScoreLabel() {
    var score = _multiGame.opponentScore.value;
    opponentScore.update(score);
  }

  void _startAutoFallingTimer() {
    if (!_isMulti) return;
    autoFallingTime.show();
    autoFallingTime.update(Config.AUTO_FALLING_INTERVAL);
    autoFallingTimer.start(
      countdownSeconds: Config.AUTO_FALLING_INTERVAL, // カウントダウン5秒
      onTick: (remainingTime) => _onAutoFallingTick(remainingTime)
    );
  }

  void _stopAutoFallingTimer() {
    if (!_isMulti) return;
    autoFallingTime.hide();
    autoFallingTimer.stop();
  }

  void _onAutoFallingTimeout() {
    if (!_isMulti) return;
    autoFallingTime.hide();
    tapArea.onDragOrTapEnd();
  }

  void _onAutoFallingTick(remainingTime) {
    if (!_isMulti) return;
    autoFallingTime.update(remainingTime);
  }

  // endregion
}