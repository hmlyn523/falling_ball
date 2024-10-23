import 'package:fall_game/chain.dart';
import 'package:fall_game/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class MultiGame {
  late RealtimeChannel _gameChannel;
  late RealtimeChannel _waitingChannel;
  late RealtimeChannel? _matchChannel;

  List<String> _userids = [];
  final myUserId = const Uuid().v4();
  late var _sentScores = 0;
  final supabase = Supabase.instance.client;
  String opponent = "";

  final EventBus eventBus;

  // 通知
  final ValueNotifier<int> opponentScore = ValueNotifier<int>(0); // 相手のスコア
  final ValueNotifier<int> opponetBall = ValueNotifier<int>(0); // 連鎖数
  final ValueNotifier<int> memberCount = ValueNotifier<int>(0);   // 参加人数

  // スコアを更新する関数を作成
  void updateOpponentScore(int score) {
    opponentScore.value = score;
  }

  void Function()? _multiGameStartCallback;
  void Function()? _multiGameOverCallback;

  final Chain chain = Chain();

  MultiGame(this.eventBus) {
    onOnline();
  }

  void addGameStartCallback(callback) => _multiGameStartCallback = callback;
  void addGameOverCallback(callback) => _multiGameOverCallback = callback;

  void onOnline() {
    _gameChannel = supabase.channel(
      'game',
      opts: const RealtimeChannelConfig(self: true),
    );
    _gameChannel.onPresenceSync((payload) {
      print('[onGame] >>> onPresenceSync');
      final presenceState = _gameChannel.presenceState();
      _userids = presenceState.map((element) => (element.presences.first).payload['user_id'] as String).toList();
      memberCount.value = _userids.length;
    }).onPresenceJoin((payload) {
      print('[onGame] >>> onPresenceJoin');
    }).onPresenceLeave((payload) {
      print('[onGame] >>> onPresenceLeave');
    }).subscribe((status, [_]) async {
      print('[onGame] >>> onSubscrive');
      await _gameChannel.track({'user_id': myUserId});
    });
  }

  void onOffline(){
    try{
      _waitingChannel.untrack();
      _waitingChannel.unsubscribe();
    } catch(e) {}
  }

  void _onOpponentChainAttack(chain) {
    for (int i = 0; i < chain; i++) {
      eventBus.publish('spawnRandom', null);
    }
  }

  // MULTIを押したら呼ばれる
  void onWaiting() {
    _waitingChannel = supabase.channel(
      'waiting',
      opts: const RealtimeChannelConfig(self: true),
    );
    _waitingChannel.onPresenceSync((payload) {
      final presenceState = _waitingChannel.presenceState();
      _userids = presenceState.map((element) => (element.presences.first).payload['user_id'] as String).toList();
    }).onPresenceJoin((payload) {
    }).onPresenceLeave((payload) {
      _waitingChannel.untrack();
      _waitingChannel.unsubscribe();
    }).onBroadcast(event: 'game_start', callback: (payload) {
      if (payload.length == 0) return;
      if (payload['participants'] == null) return;
      final participantIds = List<String>.from(payload['participants']);
      if (participantIds.contains(myUserId)) {
        final gameId = payload['game_id'] as String;
        _onGameStarted(gameId);
      }
    }).subscribe((status, [_]) async {
      await _waitingChannel.track({'user_id': myUserId});
    });
  }

  // preのupdateで呼ばれる
  Future<void> onWaitingUpdate() async {
    await Future.delayed(Duration.zero);
    if (_userids.length < 2) {
      return;
    }

    final opponentId = _userids.firstWhere((userId) => userId != myUserId);
    var gameId = const Uuid().v4();
    print('[waiting] >>> send game_start');
    await _waitingChannel.sendBroadcastMessage(
      event: 'game_start',
      payload: {
        'participants': [
          opponentId,
          myUserId,
        ],
        'game_id': gameId,
      },
    );
  }

  // play状態中のupdate時に呼ばれる
  void onPlayUpdate(score, isGameover) async {
    if (isGameover) {
      _sentScores = 0;
      _sendGameOverMessage();
    }

    _sendChainMessage();

    if (_sentScores != score) {
      _sendScoreMessage(score);
      _sentScores = score;
    }
  }

  Future<void> _sendGameOverMessage() async {
    await _matchChannel!.sendBroadcastMessage(
      event: 'game_over',
      payload: {},
    );
  }

  Future<void> _sendChainMessage() async {
    if (chain.sendChains > 0) {
      await _matchChannel!.sendBroadcastMessage(
        event: 'game_chain',
        payload: {
          'chain' : chain.sendChains,
          'send_id' : myUserId,
        },
      );
      chain.clearSendChains();
    }
  }

  Future<void> _sendScoreMessage(score) async {
    await _matchChannel!.sendBroadcastMessage(
      event: 'game_score',
      payload: {
        'score': score,
        'send_id' : myUserId,
      },
    );
  }

  void removeWaitingChannel() async {
    print('[waiting] >>> remove _waitingChannel');
    await supabase.removeChannel(_waitingChannel);
  }

  void removeGameChannel() async {
    print('[match] >>> remove _matchChannel');
    await supabase.removeChannel(_matchChannel!);
  }

  void _onGameStarted(gameId) async {
    await Future.delayed(Duration.zero);
    
    _sentScores = 0;

    _matchChannel = supabase.channel(
      gameId,
      opts: const RealtimeChannelConfig(self: true)
    );
    _matchChannel!.onBroadcast(event: 'game_score', callback: (payload) {
      final score = payload['score'] as int;
      final sendId = payload['send_id'] as String;
      if (sendId != myUserId) {
        updateOpponentScore(score);
      }
    }).onBroadcast(event: 'game_chain', callback: (payload) {
      final sendId = payload['send_id'] as String;
      final chain = payload['chain'] as int;
      if (sendId != myUserId) {
        print('chain(1): $chain');
        _onOpponentChainAttack(chain);
      }
    }).onBroadcast(event: 'game_over', callback: (payload) {
      print('[game] >>> game_over');
      removeGameChannel();
      _multiGameOverCallback?.call();
    }).subscribe();

    removeWaitingChannel();

    _multiGameStartCallback?.call();
  }
}
