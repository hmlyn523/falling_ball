import 'dart:ui';

import 'package:fall_game/components/game_board.dart';
import 'package:fall_game/components/game_over_screen.dart';
import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/components/title_screen.dart';
import 'package:fall_game/config.dart';
import 'package:flame/components.dart';

class UIControler {
  late final List<SpriteComponent> _titleScreen;
  late final List<SpriteComponent> _gameOverScreen;

  List<SpriteComponent> get titleScreen => _titleScreen;
  List<SpriteComponent> get gameOverScreen => _gameOverScreen;

  Future<void> initializeLabels() async {
    _titleScreen = await createTitleScreen();
    _gameOverScreen = await createGameOverScreen();
  }

  Future<ScoreLabel> _createLabel({
    required Vector2 position,
    bool isVisible = true,
  }) async {
    final label = ScoreLabel(
      // score: await GameBoard.getScore(),
      position: position,
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    label.isVisible = isVisible;
    return label;
  }

  void showTitle(game) {
    game.addAll(_titleScreen);
  }

  void hideTitle(game) {
    _titleScreen.forEach((element) {element.removeFromParent();});
  }

  void showGameOver(game){
    game.addAll(_gameOverScreen);
  }

  void hideGameOver(game) {
  _gameOverScreen.forEach((element) {element.removeFromParent();});
  }
}