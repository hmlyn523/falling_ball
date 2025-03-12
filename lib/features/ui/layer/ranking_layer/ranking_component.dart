import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flutter/material.dart';

class RankingListComponent extends PositionComponent with DragCallbacks {
  final List<String> rankings_no;
  final List<String> rankings_name;
  final List<String> rankings_score;
  late final TextPaint textPaint;
  
  double scrollOffset = 0; // 現在のスクロール位置
  double maxScrollOffset = 0; // 最大スクロール位置
  double scrollVelocity = 0; // スクロール速度
  double friction = 0.95; // 慣性スクロールの摩擦係数（0.95~0.98ぐらいが自然）

  Vector2? lastDragPosition; // 直前のタッチ位置
  double lastDragTime = 0; // 直前のドラッグ時間

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
        fontSize: 1.5,
        fontFamily: 'PixelFont',
      ),
    );
  }

  @override
  Future<void> onLoad() async {
    super.onLoad();
    maxScrollOffset = (rankings_no.length * 3 - size.y).clamp(0, double.infinity); // 最大スクロール量を計算
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // 慣性スクロール処理
    if (scrollVelocity.abs() > 0.1) {
      scrollOffset += scrollVelocity;
      scrollVelocity *= friction; // 徐々に減速
      
      // スクロール範囲を制限
      if (scrollOffset < 0) {
        scrollOffset = 0;
        scrollVelocity = 0;
      } else if (scrollOffset > maxScrollOffset) {
        scrollOffset = maxScrollOffset;
        scrollVelocity = 0;
      }
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    scrollOffset -= event.localDelta.y; // ドラッグ量に応じてスクロール
    lastDragPosition = event.localPosition;
    lastDragTime = event.timestamp.inMilliseconds.toDouble();

    // スクロール範囲を超えないように制限
    scrollOffset = scrollOffset.clamp(0, maxScrollOffset);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    if (lastDragPosition != null) {
      // 指の移動速度を計算
      double velocity = event.velocity.y * -0.005; // 速度を調整
      scrollVelocity = velocity;
    }
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
      renderRightAlignedText(canvas, no, textPaint, 7, y);
      y += 3; // 各行の間隔
    }
    y = 0;
    for (var name in rankings_name) {
      textPaint.render(canvas, name, Vector2(8, y)); // テキストを描画
      y += 3; // 各行の間隔
    }
    y = 0;
    for (var score in rankings_score) {
      renderRightAlignedText(canvas, score, textPaint, 31, y);
      y += 3; // 各行の間隔
    }

    canvas.restore();
  }

  void renderRightAlignedText(Canvas canvas, String text, TextPaint textPaint, double x, double y) {
    // final textWidth = textPaint.measureTextWidth(text);
    final textPainter = textPaint.toTextPainter(text);
    final textWidth = textPainter.width;
    textPaint.render(canvas, text, Vector2(x - textWidth, y));
  }
}
