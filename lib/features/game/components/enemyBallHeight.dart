import 'dart:math';
import 'dart:ui';

import 'package:fall_game/app/config.dart';
import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flutter/material.dart';

class EnemyBallHeight extends PositionComponent 
  with HasVisibility {
  late double height = 0.0;
  late Paint paint;  // 線の描画スタイル

  // コンストラクタ
  EnemyBallHeight()
  {
    isVisible = false;
    paint = Paint()..color = _getRandomBrightColor();
  }

  @override
  void render(Canvas canvas) {
    super.render(canvas);
    // Canvasに線を描画
    canvas.drawLine(
      Offset(0, height),
      Offset(Config.WORLD_WIDTH, height),
      paint..strokeWidth = .6,
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // 線の更新が必要な場合はここにロジックを書く
  }

  void setVisibility(bool isVisible) => this.isVisible = isVisible;

  void setMark(double? h) {
    if (h == null || h <= 0) {
      setVisibility(false);
    }else{
       setVisibility(true);
       height = h!;
    }
  }

  // ランダムなはっきりした色を生成する関数
  Color _getRandomBrightColor() {
    final random = Random();
    // RGBそれぞれをランダムで生成（高めの値を使用して鮮やかさを確保）
    int red = 150 + random.nextInt(106); // 100〜255
    int green = 150 + random.nextInt(106);
    int blue = 150 + random.nextInt(106);

    return Color.fromARGB(255, red, green, blue); // 不透明な色を返す
  }
}

// class EnemyBallHeight extends SpriteComponent
//   with HasVisibility
// {
//   EnemyBallHeight(image)
//     : super(
//         size: Vector2(Config.WORLD_WIDTH, Config.WORLD_HEIGHT * .05),
//         position: Vector2(Config.WORLD_WIDTH * .0, Config.WORLD_HEIGHT * .9),
//         priority: Config.PRIORITY_ENEMY_BALL_HEIGHT,
//       ){
//         sprite = Sprite(image);
//         isVisible = false;
//       }

//   void setVisibility(bool isVisible) => this.isVisible = isVisible;

//   void setMark(double? height) {
//     if (height == null || height <= 0) {
//       setVisibility(false);
//     } else {
//       setVisibility(true);
//       position.y = height;
//     }
//   }
// }