import 'dart:developer';

import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/core/components/touch_blocker.dart';
import 'package:falling_ball/core/services/leaderboard_service.dart';
import 'package:falling_ball/features/game/game.dart';
import 'package:falling_ball/features/game/world.dart';
import 'package:falling_ball/features/ui/layer/ranking_layer/ranking_component.dart';
import 'package:flame/components.dart';
import 'package:falling_ball/features/ui/layer/ranking_layer/ranking_back_button.dart';

class RankingLayer extends PositionComponent
    with HasGameReference, HasVisibility {
  late final SpriteComponent _background;
  late final RankingBackButton _backButton;
  late final TouchBlocker _touchBlocker;
  late RankingListComponent _scrollTextBox;
  late final String backgournd_image;

  RankingLayer(this.backgournd_image, layerType)
      : super(
          key: ComponentKey.named(layerType),
          position: Vector2(Config.WORLD_WIDTH * .5, Config.WORLD_HEIGHT * .5),
          size: Vector2(Config.WORLD_WIDTH * .88, Config.WORLD_HEIGHT * .66),
          anchor: Anchor.center,
        ) {
    isVisible = false; // 初期状態は非表示
    priority = Config.PRIORITY_MIN;
  }

  @override
  Future<void> onLoad() async {
    // タッチキャプチャ用の透明な背景を追加
    _touchBlocker = TouchBlocker(
      size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT), // 画面全体を覆う
      position: Vector2.zero(), // 画面左上からスタート
    );
    _touchBlocker.isVisible = false;

    // 背景スプライトの設定
    _background = SpriteComponent(
      sprite: Sprite((game as FallGame).images.fromCache(this.backgournd_image)),
      position: Vector2.zero(),
      size: size,
      anchor: Anchor.topLeft,
    );

    _scrollTextBox = RankingListComponent(
      rankings_no: [],
      rankings_name: [],
      rankings_score: [],
      size: Vector2(size.x * 0.89, size.y * 0.6), // テキストボックスのサイズ
      position: Vector2(size.x * 05, size.y * 0.15), // ランキングの配置位置
      anchor: Anchor.topLeft,
    );

    // 戻るボタンの設定
    _backButton = RankingBackButton(
      sprite: Sprite((game as FallGame).images.fromCache(Config.IMAGE_CANCEL)),
      position: Vector2(size.x * .5, size.y * .875),
      size: Vector2(Config.WORLD_WIDTH * .18, Config.WORLD_HEIGHT * .115),
    );

    add(_touchBlocker);
    add(_background);
    add(_scrollTextBox);
    add(_backButton);
  }

  /// ランキング情報を更新
  Future<void> updateRanking() async {
    // Supabaseからランキングを取得
    final leaderboardService = LeaderboardService((game as FallGame).supabase);
    try {
      final rankings = await leaderboardService.getRankingList();
      List<String> rankings_no = [];
      List<String> rankings_name = [];
      List<String> rankings_score = [];
      for (var i = 0; i < rankings.length; i++) {
        rankings_no.add('${i + 1}.');
        rankings_name.add('${rankings[i].playerName}');
        rankings_score.add('${rankings[i].score}');
      }
      // スクロールテキストボックの再作成
      _scrollTextBox.removeFromParent();
      _scrollTextBox = RankingListComponent(
        rankings_no: rankings_no,
        rankings_name: rankings_name,
        rankings_score: rankings_score,
        size: Vector2(size.x * 0.89, size.y * 0.6), // テキストボックスのサイズ
        position: Vector2(size.x * 0.05, size.y * 0.15), // ランキングの配置位置
        anchor: Anchor.topLeft,
      );
      _scrollTextBox.priority = 150;
      add(_scrollTextBox);

    } catch (e) {
      log('ランキングの取得に失敗しました: $e');
    }
  }

  /// スコア履歴情報を更新
  Future<void> updateScoreHistory() async {
    // Supabaseからランキングを取得
    final leaderboardService = LeaderboardService((game as FallGame).supabase);
    try {
      // final rankings = await leaderboardService.getLeaderboard();
      final _gameWorld = (game.world as FallGameWorld);
      final _userid = await _gameWorld.playerService.getLoginUser();
      final _rankings = await leaderboardService.getScoreHistoryList(_userid);
      List<String> rankings_no = [];
      List<String> rankings_name = [];
      List<String> rankings_score = [];
      for (var i = 0; i < _rankings.length; i++) {
        rankings_no.add('${i + 1}.');
        rankings_name.add('${_rankings[i].playerName}');
        rankings_score.add('${_rankings[i].score}');
      }
      // スクロールテキストボックの再作成
      _scrollTextBox.removeFromParent();
      _scrollTextBox = RankingListComponent(
        rankings_no: rankings_no,
        rankings_name: rankings_name,
        rankings_score: rankings_score,
        size: Vector2(size.x * 0.89, size.y * 0.6), // テキストボックスのサイズ
        position: Vector2(size.x * 0.05, size.y * 0.15), // ランキングの配置位置
        anchor: Anchor.topLeft,
      );
      _scrollTextBox.priority = 150;
      add(_scrollTextBox);
    } catch (e) {
      log('ランキングの取得に失敗しました: $e');
    }
  }

  /// 表示/非表示を切り替える
  void setVisibility(bool isVisible) {
    if (this.isVisible == isVisible) return;

    this.isVisible = isVisible;
    priority = isVisible ? Config.PRIORITY_RANKING_DIALOG : Config.PRIORITY_MIN;

    // 背景とボタン、スクロールコンポーネントの表示/非表示を切り替え
    _background.priority = priority;
    _backButton.priority = priority;
    _touchBlocker.priority = priority; // タッチブロッカーも優先度を切り替え
    _scrollTextBox.priority = priority;
  }

  void showRanking() async {
    // 再表示時にもランキングデータを更新
    updateRanking();
    setVisibility(true);
  }

  void showScoreHistory() async {
    // 再表示時にもランキングデータを更新
    updateScoreHistory();
    setVisibility(true);
  }

  // ランキングが閉じられたらインスタンスを破棄し初期化する。
  void hideLayer() {
    // if (rankingLayer == null) return;
    setVisibility(false);
    // removeFromParent();
  }
}
