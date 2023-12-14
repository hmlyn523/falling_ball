import 'dart:async';

import 'package:fall_game/config.dart';

class Chain {
  Chain() {
    stopChain();
  }

  int _currentChains = 0;
  int _sendChains = 0;
  int get sendChains => _sendChains;
  Timer _chainTimer = Timer(Duration(), () => {});

  void addChain() {
    if (_currentChains == 0) {
      _chainTimer = Timer(const Duration(milliseconds: Config.CHAIN_INTERVAL), () {
        _sendChains = _currentChains >= Config.MIN_CHAIN
                             ? _currentChains
                             : 0;
        _currentChains = 0;
      });
    }
    _currentChains++;
  }

  void stopChain() {
    _currentChains = 0;
    _sendChains = 0;
    _chainTimer.cancel();
  }

  void clearSendChains() {
    _sendChains = 0;
  }
}