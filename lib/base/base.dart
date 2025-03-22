import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:flutter/material.dart';

enum GameState {
  title,
  preparation,
  start,
  playing,
  finalizing,
  gameover,
  end,
}

abstract class Base extends Forge2DWorld {

  GameState _state = GameState.title;
  bool debugFps = false;

  @override
  void update(double d){
    super.update(d);
    if (isTitleState()) {
      title(d);
    } else if (isPreparationState()) {
      preparation(d);
    } else if (isStartState()) {
      start(d);
    } else if (isPlayingState()) {
      play(d);
    } else if (isFinalizingState()) {
      finalizing(d);
    } else if (isGameOverState()) {
      gameover(d);
    } else if (isEndState()) {
      end(d);
    }
  }

  @mustCallSuper
  void title(d) {}

  @mustCallSuper
  void preparation(d){}

  @mustCallSuper
  void start(d){}

  @mustCallSuper
  void play(d) {}

  @mustCallSuper
  void finalizing(d) {}

  @mustCallSuper
  void gameover(d) {}

  @mustCallSuper
  void end(d){}

  bool isTitleState() => _state == GameState.title;
  bool isPreparationState() => _state == GameState.preparation;
  bool isStartState() => _state == GameState.start;
  bool isPlayingState() => _state == GameState.playing;
  bool isFinalizingState() => _state == GameState.finalizing;
  bool isGameOverState() => _state == GameState.gameover;
  bool isEndState() => _state == GameState.end;

  void moveToTitleState() => _state = GameState.title;
  void moveToPreparationState() => _state = GameState.preparation;
  void moveToStartState() => _state = GameState.start;
  void moveToPlayingState() => _state = GameState.playing;
  void moveToFinalizingState() => _state = GameState.finalizing;
  void moveToGameOverState() => _state = GameState.gameover;
  void moveToEndState() => _state = GameState.end;
}
