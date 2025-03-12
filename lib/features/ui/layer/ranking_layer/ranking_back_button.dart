import 'package:falling_ball/features/ui/layer/ranking_layer/ranking_layer.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';

/// 戻るボタンクラス
class RankingBackButton extends SpriteComponent with HasGameReference, TapCallbacks {
  RankingBackButton({
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
