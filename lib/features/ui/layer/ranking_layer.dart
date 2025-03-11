import 'dart:developer';

import 'package:falling_ball/app/config.dart';
import 'package:falling_ball/core/components/touch_blocker.dart';
import 'package:falling_ball/core/services/leaderboard_service.dart';
import 'package:falling_ball/features/game/game.dart';
import 'package:falling_ball/features/game/world.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class RankingLayer extends PositionComponent
    with HasGameReference, HasVisibility {
  late final SpriteComponent _background;
  late final BackButton _backButton;
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

    // スクロール可能なテキストボックスを設定
    // Supabaseからランキングを取得
    // final leaderboardService = LeaderboardService();
    // try {
    //   final rankings = await leaderboardService.getLeaderboard();
    //   List<String> rankings_no = [];
    //   List<String> rankings_name = [];
    //   List<String> rankings_score = [];
    //   for (var i = 0; i < rankings.length; i++) {
    //     rankings_no.add('${i + 1}.');
    //     rankings_name.add('${rankings[i].playerId}');
    //     rankings_score.add('${rankings[i].score}');
      // }
      _scrollTextBox = RankingListComponent(
        rankings_no: [],
        rankings_name: [],
        rankings_score: [],
        size: Vector2(size.x * 0.89, size.y * 0.6), // テキストボックスのサイズ
        position: Vector2(size.x * 05, size.y * 0.15), // ランキングの配置位置
        anchor: Anchor.topLeft,
      );
      // add(_scrollTextBox);
    // } catch (e) {
    //   print('ランキングの取得に失敗しました: $e');
    // }

    // 戻るボタンの設定
    _backButton = BackButton(
      sprite: Sprite((game as FallGame).images.fromCache(Config.IMAGE_CANCEL)),
      position: Vector2(size.x * .5, size.y * .85),
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

class RankingListComponent extends PositionComponent with DragCallbacks {
  final List<String> rankings_no;
  final List<String> rankings_name;
  final List<String> rankings_score;
  late final TextPaint textPaint;
  double scrollOffset = 0; // 現在のスクロール位置
  double maxScrollOffset = 0; // 最大スクロール位置
  double scrollVelocity = 0; // スクロール速度
  // double friction = 0.98; // 慣性スクロールの摩擦係数
  double friction = 0.1; // 慣性スクロールの摩擦係数

  RankingListComponent({
    required this.rankings_no,
    required this.rankings_name,
    required this.rankings_score,
    required Vector2 position,
    required Vector2 size,
    required Anchor anchor,
  }) : super(position: position, size: size, anchor: anchor) {
    textPaint = TextPaint(
      style: const TextStyle(
        color: Colors.white,
        fontSize: 1.6,
        fontFamily: 'PixelFont'),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    maxScrollOffset = (rankings_no.length * 24 - size.y).clamp(0, double.infinity); // 最大スクロール量を計算
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // 背景を描画
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = Colors.black.withOpacity(0.2),
    );

    // テキストを描画
    canvas.save();
    canvas.clipRect(Rect.fromLTWH(0, 0, size.x, size.y)); // コンポーネントの範囲内にクリップ
    canvas.translate(0, -scrollOffset);

    double y = 0;
    for (var no in rankings_no) {
      renderRightAlignedText(canvas, no, textPaint, 33, y);
      // textPaint.render(canvas, no, Vector2(2, y)); // テキストを描画
      y += 3; // 各行の間隔
    }
    y = 0;
    for (var name in rankings_name) {
      textPaint.render(canvas, name, Vector2(8, y)); // テキストを描画
      y += 3; // 各行の間隔
    }
    y = 0;
    for (var score in rankings_score) {
      renderRightAlignedText(canvas, score, textPaint, 9, y);
      // textPaint.render(canvas, score, Vector2(24, y)); // テキストを描画
      y += 3; // 各行の間隔
    }

    canvas.restore();
  }

  void renderRightAlignedText(Canvas canvas, String score, TextPaint textPaint, double x, double y) {
    // TextPaintからTextStyleを取得
    final textStyle = TextStyle(
      fontSize: textPaint.style.fontSize,
      color: textPaint.style.color,
      fontFamily: textPaint.style.fontFamily,
    );

    // TextPainterを使ってテキストの幅を計算
    final textPainter = TextPainter(
      text: TextSpan(text: score, style: textStyle),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();

    // スコアテキストの幅を取得
    final textWidth = textPainter.width;

    // 右詰めにする位置（例: 画面幅 - 10px）
    final rightAlignX = Config.WORLD_WIDTH - textWidth; // 320は画面または表示エリアの右端のx座標

    // テキストの描画位置を設定
    textPainter.paint(canvas, Offset(rightAlignX-x, y));
    // textPaint.render(canvas, score, Vector2(rightAlignX, y)); // テキストを描画
  }

  // @override
  // void onDragUpdate(DragUpdateEvent event) {
  //   // スワイプによるスクロール
  //   scrollOffset -= event.localDelta.y; // スクロール方向を反転
  //   scrollOffset = scrollOffset.clamp(0, maxScrollOffset); // スクロール範囲を制限
  // }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    scrollOffset -= event.localDelta.y;
    scrollOffset = scrollOffset.clamp(0, maxScrollOffset);
    scrollVelocity = event.localDelta.y; // スクロール速度を記憶
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (scrollVelocity != 0) {
      scrollOffset -= scrollVelocity * dt;
      scrollOffset = scrollOffset.clamp(0, maxScrollOffset);
      scrollVelocity *= friction; // 摩擦を適用
      if (scrollVelocity.abs() < 1) {
        scrollVelocity = 0; // 停止判定
      }
    }
  }
}

/// 戻るボタンクラス
class BackButton extends SpriteComponent with HasGameReference, TapCallbacks {
  BackButton({
    required Sprite sprite,
    required Vector2 position,
    required Vector2 size,
  }) : super(sprite: sprite, position: position, size: size, anchor: Anchor.center);

  @override
  bool onTapUp(TapUpEvent event) {
    // ダイアログを閉じる
    (parent as RankingLayer).hideLayer();
    return false;
  }
}
