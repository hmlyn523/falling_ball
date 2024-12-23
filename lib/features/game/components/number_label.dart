import 'package:falling_ball/app/config.dart';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

class NumberLabel extends TextComponent with HasVisibility {
  int _number = 0;
  int get number => _number;
  set number(int s) {
    _number = s >= 0 ? _number = s
                    : _number = 0;
    this.text = _number.toString();
  }

  NumberLabel({int? score = 0, position, Color? color = Colors.black})
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
        _number = number;
      }

  void setTotal(int s) {
    // score += int.parse(this.text);
    _number += s;
    this.text = _number.toString();
  }
}