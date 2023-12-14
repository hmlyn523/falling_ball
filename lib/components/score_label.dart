import 'package:fall_game/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class ScoreLabel extends TextComponent with HasVisibility {
  int _score = 0;
  int get score => _score;
  set score(int s) {
    _score = s >= 0 ? _score = s
                    : _score = 0;
    this.text = _score.toString();
  }

  ScoreLabel({int? score = 0, position, Color? color = Colors.black})
      : super(
        text: score!.toString(),
        textRenderer: TextPaint(
          style: TextStyle(
            fontSize: Config.WORLD_WIDTH * 0.18,
            fontFamily: 'Square-L',
            color: color,
            height: 0.1
          )
        )
      ) {
        anchor = Anchor.centerRight;
        x = position.x;
        y = position.y;
        _score = score;
      }

  void setTotal(int s) {
    // score += int.parse(this.text);
    _score += s;
    this.text = _score.toString();
  }
}