import 'dart:ui';

import 'package:fall_game/components/game_board.dart';
import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/config.dart';
import 'package:fall_game/world.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class UIManager {
  late final ScoreLabel _nextItemLabel;
  late final ScoreLabel _scoreLabel;
  late final ScoreLabel _opponentScoreLabel;
  late final ScoreLabel _lobbyNumberLabel;

  int get nextItemLabelScore => _nextItemLabel.score;

  Future<void> initializeLabels() async {
    _nextItemLabel = await _createLabel(
      position: Vector2(Config.WORLD_WIDTH * .33, Config.WORLD_HEIGHT * .058),
    );
    _scoreLabel = await _createLabel(
      position: Vector2(Config.WORLD_WIDTH * .93, Config.WORLD_HEIGHT * .058),
    );
    _opponentScoreLabel = await _createLabel(
      position: Vector2(Config.WORLD_WIDTH * .953, Config.WORLD_HEIGHT * .962),
      isVisible: false,
    );
    _lobbyNumberLabel = await _createLabel(
      position: Vector2(Config.WORLD_WIDTH * .47, Config.WORLD_HEIGHT * .962),
    );
  }

  Future<ScoreLabel> _createLabel({
    required Vector2 position,
    bool isVisible = true,
  }) async {
    final label = ScoreLabel(
      score: await GameBoard.getScore(),
      position: position,
      color: const Color.fromRGBO(255, 255, 255, 1),
    );
    label.isVisible = isVisible;
    return label;
  }

  // UIManager の内部で add を行う
  void addLabelsToGame(game) {
    game.add(_nextItemLabel);
    game.add(_scoreLabel);
    game.add(_opponentScoreLabel);
    game.add(_lobbyNumberLabel);
  }

  void updateNextItemLabel(int nextItemType) {
    _nextItemLabel.text = nextItemType.toString();
  }

  void resetScores() {
    _scoreLabel.score = 0;
    _opponentScoreLabel.score = 0;
  }

  void updateScore(int score) {
    _scoreLabel.setTotal(score);
  }

  void updateOpponentScore(int score) {
    _opponentScoreLabel.setTotal(score);
  }

  void showOpponentScoreLabel() {
    _opponentScoreLabel.isVisible = true;
  }

  void updateLobbyNumber(int count) {
    _lobbyNumberLabel.text = count.toString();
  }
}