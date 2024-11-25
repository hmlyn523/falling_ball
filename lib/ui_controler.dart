import 'dart:ui';

import 'package:fall_game/components/game_board.dart';
import 'package:fall_game/components/score_label.dart';
import 'package:fall_game/components/title_screen.dart';
import 'package:fall_game/config.dart';
import 'package:flame/components.dart';

class UIControler {
  late final List<SpriteComponent> _titleScreen;
  late final ScoreLabel _nextItemLabel;
  late final ScoreLabel _opponentScoreLabel;
  late final ScoreLabel _lobbyNumberLabel;

  List<SpriteComponent> get titleScreen => _titleScreen;

  Future<void> initializeLabels() async {
    _titleScreen = await createTitleScreen();
    _nextItemLabel = await _createLabel(
      position: Vector2(Config.WORLD_WIDTH * .35, Config.WORLD_HEIGHT * .059),
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
    game.removeAll(_titleScreen);
    game.removeAll(_titleScreen);
  }

  // UIManager の内部で add を行う
  void addLabelsToGame(game) {
    game.add(_nextItemLabel);
    game.add(_opponentScoreLabel);
    game.add(_lobbyNumberLabel);
  }

  void updateNextItemLabel(int nextItemType) {
    _nextItemLabel.text = nextItemType.toString();
  }

  void resetScores() {
    _opponentScoreLabel.score = 0;
  }

  void updateOpponentScore(int score) {
    _opponentScoreLabel.text = score.toString();
  }

  void showOpponentScoreLabel() {
    _opponentScoreLabel.isVisible = true;
  }

  void updateLobbyNumber(int count) {
    _lobbyNumberLabel.text = count.toString();
  }
}