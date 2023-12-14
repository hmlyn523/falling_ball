import 'package:flutter/material.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/forge2d_world.dart';
import 'package:flame/components.dart';

enum GameState {
  title,
  preparation,
  start,
  playing,
  gameover,
  end,
}

abstract class Base extends Forge2DWorld {
  Base({Vector2? gravity}) :
    super(
      gravity: gravity,
    );

  GameState _state = GameState.title;
  bool debugFps = false;

  @override
  Future<void> onLoad() async {
    await super.onLoad(); 
  }

  @override
  void update(double d){
    super.update(d);
    if (isTitleState()) {
      title();
    } else if (isPreparationState()) {
      preparation();
    } else if (isStartState()) {
      start();
    } else if (isPlayingState()) {
      play();
    } else if (isGameOverState()) {
      gameover();
    } else if (isEndState()) {
      end();
    }
  }

  @mustCallSuper
  void title() {}

  @mustCallSuper
  void preparation(){}

  @mustCallSuper
  void start(){}

  @mustCallSuper
  void play() {}

  @mustCallSuper
  void gameover() {}

  @mustCallSuper
  void end(){}

  bool isTitleState() => _state == GameState.title;
  bool isPreparationState() => _state == GameState.preparation;
  bool isStartState() => _state == GameState.start;
  bool isPlayingState() => _state == GameState.playing;
  bool isGameOverState() => _state == GameState.gameover;
  bool isEndState() => _state == GameState.end;

  void moveToTitleState() => _state = GameState.title;
  void moveToPreparationState() => _state = GameState.preparation;
  void moveToStartState() => _state = GameState.start;
  void moveToPlayingState() => _state = GameState.playing;
  void moveToGameOverState() => _state = GameState.gameover;
  void moveToEndState() => _state = GameState.end;
}
