import 'dart:developer';

import 'package:falling_ball/core/modules/chain.dart';
import 'package:falling_ball/core/services/error_handler.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

class EnemyBallStatus {
  late String userid;
  late double height;
}

class MultiGame {
  final context;
  late RealtimeChannel _gameChannel;
  late RealtimeChannel _waitingChannel;
  late RealtimeChannel _matchChannel;
  bool _isGameChannelInitialized = false;

  List<String> _userids = [];
  final myUserId = const Uuid().v4();
  late var _sentScores = 0;
  late var _sentEnemyBallHeight= 0.0;
  final supabase;
  String opponent = "";
  // late double? enemyBallState = null;
  late List<EnemyBallStatus> enemyBallState = [];
  int _other_players = 0;

  // 通知
  final ValueNotifier<int> opponentScore = ValueNotifier<int>(0); // 相手のスコア
  final ValueNotifier<int> opponetBall = ValueNotifier<int>(0); // 連鎖数
  final ValueNotifier<int> memberCount = ValueNotifier<int>(0);   // 参加人数

  // スコアを更新する関数を作成
  void _updateOpponentScore(int score) {
    opponentScore.value = score;
  }

  void Function()? _multiGameStartCallback;
  void Function()? _multiGameOverCallback;
  void Function()? _multiComboCallback;

  final Chain chain = Chain();

  MultiGame(this.context, this.supabase) {
    onOnline();
  }

  get mergeItemPotision => null;

  void addGameStartCallback(callback) => _multiGameStartCallback = callback;
  void addGameOverCallback(callback) => _multiGameOverCallback = callback;
  void addComboCallback(callback) => _multiComboCallback = callback;

  void onOnline() {
    if (!_isGameChannelInitialized) {
      _gameChannel = supabase.channel(
        'game',
        opts: const RealtimeChannelConfig(self: true),
      );
    }
    _isGameChannelInitialized = true;
    _gameChannel.onPresenceSync((payload) {
      log('[onOnline] >>> onPresenceSync');
      final presenceState = _gameChannel.presenceState();
      // final onlineUsers = presenceState.map((element) => (element.presences.first).payload['online_user_id'] as String).toList();
      final onlineUsers = presenceState
        .map((element) => element.presences.isNotEmpty
          ? element.presences.first.payload['online_user_id'] as String?
          : null)
        .where((userId) => userId != null) // null を取り除く
        .cast<String>() // 型を String に確定
        .toList();
      memberCount.value = onlineUsers.length;
      log('[onOnline] >>> memberCount.value = ${memberCount.value}');
    }).onPresenceJoin((payload) {
      log('[onOnline] >>> onPresenceJoin');
    }).onPresenceLeave((payload) {
      log('[onOnline] >>> onPresenceLeave');
    }).subscribe((status, [_]) async {
      if (status == RealtimeSubscribeStatus.subscribed) {
        log('[onOnline] >>> onSubscrive');
        await _gameChannel.track({'online_user_id': myUserId});

        // track完了後にpresenceStateを取得
        final presenceState = _gameChannel.presenceState();
        final onlineUsers = presenceState.map((element) => 
          (element.presences.first).payload['online_user_id'] as String
        ).toList();
        memberCount.value = onlineUsers.length; // 自分自身を反映
        log('[onOnline] >>> memberCount.value = ${memberCount.value}');
      }
    });
  }

  void onOffline(){
    try{
      _waitingChannel.untrack();
      _waitingChannel.unsubscribe();
    } catch(e) {}
  }

  // MULTIを押したら呼ばれる
  void onWaiting(players) {
    _other_players = players;
    _waitingChannel = supabase.channel(
      'waiting',
      opts: const RealtimeChannelConfig(self: true),
    );
    _waitingChannel.onPresenceSync((payload) {
      log('[onWaiting] >>> onPresenceSync');
      log('  --> プレゼンス情報を受信しました。現在のプレゼンス情報: $payload');
      final presenceState = _waitingChannel.presenceState();
      _userids = presenceState.map((element) => (element.presences.first).payload['waiting_user_id'] as String).toList();
      log('  --> _userids : ${_userids}');
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
      log('[onWaiting] >>> onSubscrive');
      log('  --> myUserId : ${myUserId}');
      log('  --> status : ${status}');
      if (status == RealtimeSubscribeStatus.subscribed) {
        log('    --> クライアントがサーバーと接続し、リアルタイムデータを受信できる状態です。');
        log('    --> プレゼンス情報を送信します。 (trackの実行)');
        await _waitingChannel.track({'waiting_user_id': myUserId});
      }
      else if (status == RealtimeSubscribeStatus.channelError) {
        log('    --> チャンネルにエラーが発生しました。');
      }
      else if (status == RealtimeSubscribeStatus.closed) {
        log('    --> チャンネルが閉じられました。');
      }
      else if (status == RealtimeSubscribeStatus.timedOut) {
        log('    --> サーバーからの応答が一定時間内に受信できず、接続がタイムアウトしました。');
      }
    });
  }

  // preparationで呼ばれ続ける
  Future<void> onWaitingUpdate() async {
    await Future.delayed(Duration.zero);
    if (_userids.length <= _other_players/*Config.OTHER_PLAYER_COUNT*/) {
      return;
    }

    var playUserId = _userids.where((userId) => userId != myUserId).take(2).toList();
    playUserId.add(myUserId);
    var gameId = const Uuid().v4();
    log('[waiting] >>> send game_start');
    log('  --> ゲームID(gameId) : ${gameId} ');
    // print('  --> 全プレーヤーID(_userids) : ${_userids}');
    log('  --> 対戦参加者ID(playUserId) : ${playUserId}');
    _userids.clear();
    await _waitingChannel.sendBroadcastMessage(
      event: 'game_start',
      payload: {
        'participants': playUserId,
        'game_id': gameId,
      },
    );
  }

  // play状態中のupdate時に呼ばれる
  void sendScore(score) async {
    if (_sentScores != score) {
      _sendScoreMessage(score);
      _sentScores = score;
    }
  }

  // play状態中のupdate時に呼ばれる
  void sendEnemyBallHeight(height) {
    if (_sentEnemyBallHeight != height) {
      _sendEnemyBallHeight(height);
      _sentEnemyBallHeight = height;
    }
  }

  // play状態中のupdate時に呼ばれる
  void resetAndSendGameOver() async {
    _sentScores = 0;
    _sentEnemyBallHeight = 0.0;
    _sendGameOverMessage();
  }

  // play状態中のupdate時に呼ばれる
  void sendChain() async {
    _sendChainMessage();
  }

  // // play状態中のupdate時に呼ばれる
  // void onPlayUpdate(score, height, isGameover) async {
    // if (isGameover) {
    //   _sentScores = 0;
    //   _sentEnemyBallHeight = 0.0;
    //   _sendGameOverMessage();
    // }

    // _sendChainMessage();

    // if (_sentEnemyBallHeight != height) {
    //   _sendEnemyBallHeight(height);
    //   _sentEnemyBallHeight = height;
    // }

    // if (_sentScores != score) {
    //   _sendScoreMessage(score);
    //   _sentScores = score;
    // }
  // }

  Future<void> _sendGameOverMessage() async {
    await _matchChannel.sendBroadcastMessage(
      event: 'game_over',
      payload: {},
    );
  }

  Future<void> _sendChainMessage() async {
    if (chain.sendChains > 0) {
      _multiComboCallback?.call();
      await _matchChannel.sendBroadcastMessage(
        event: 'game_chain',
        payload: {
          'chain' : chain.sendChains,
          'send_id' : myUserId,
        },
      );
      chain.clearSendChains();
    }
  }

  // Future<void> _sendEnemyBallHeight(height) async {
  //   if (height > 0.0) {
  //     final response = await _matchChannel.sendBroadcastMessage(
  //       event: 'game_enemy_ball_height',
  //       payload: {
  //         'enemy_ball_height': height.toDouble(),
  //         'send_id' : myUserId,
  //       },
  //     );
  //   }
  // }
  // Future<void> sendBroadcastMessageWithRetry() async {
  Future<void> _sendEnemyBallHeight(height) async {
    if (height <= 0.0) return;

    const int maxRetries = 3; // 最大リトライ回数
    int retryCount = 0;
    bool success = false;

    while (!success && retryCount < maxRetries) {
      try {
        final response = await _matchChannel.sendBroadcastMessage(
          event: 'game_enemy_ball_height',
          payload: {
            'enemy_ball_height': height.toDouble(),
            'send_id': myUserId,
          },
        );

        // // 成功したか確認
        // if (response == null) {
        //   // 送信成功時、`response` が `null` になる場合もあるためチェック。
        //   success = true;
        //   print("メッセージ送信成功！");
        // } else {
        //   // 必要に応じてレスポンス内容をデバッグ
        //   print("レスポンス内容: $response");
        //   success = true;
        // }
        if (response == ChannelResponse.ok) {
          log('送信に成功!');
          success = true;
        } else {
          log('送信に失敗 : ${response}');
          ErrorHandler.showErrorDialog(context, '対戦相手のアイテムの高さの送信に失敗');
          throw ();
        }
      } catch (e) {
        retryCount++;
        log("メッセージ送信失敗。リトライ中... (${retryCount}/${maxRetries})");
        if (retryCount >= maxRetries) {
          log("リトライ上限に達しました: $e");
          // 必要に応じてエラーハンドリング
        }
      }
    }
  }

  Future<void> _sendScoreMessage(score) async {
    await _matchChannel.sendBroadcastMessage(
      event: 'game_score',
      payload: {
        'score': score,
        'send_id' : myUserId,
      },
    );
  }

  Future<void> removeWaitingChannel() async {
    log('[waiting] >>> remove _waitingChannel');
    await supabase.removeChannel(_waitingChannel);
  }

  void removeGameChannel() async {
    log('[match] >>> remove _matchChannel');
    await supabase.removeChannel(_matchChannel);
  }

  void _onGameStarted(gameId) async {
    await Future.delayed(Duration.zero);
    
    _sentScores = 0;
    _sentEnemyBallHeight = 0.0;
    enemyBallState.clear();

    _matchChannel = supabase.channel(
      gameId,
      opts: const RealtimeChannelConfig(self: true)
    );
    _matchChannel.onPresenceLeave((payload) {
      log('[_onGameStarted] >>> onPresenceSync');
      log('  --> プレゼンス情報を受信しました。現在のプレゼンス情報: $payload');
      _matchChannel.untrack();
      _matchChannel.unsubscribe();
    }).onBroadcast(event: 'game_score', callback: (payload) {
      log('[_onGameStarted] >>> game_score');
      if (payload['score'] == null || payload['send_id'] == null) return;
      final score = payload['score'] as int;
      final sendId = payload['send_id'] as String;
      if (sendId != myUserId) {
        _updateOpponentScore(score);
      }
    }).onBroadcast(event: 'game_enemy_ball_height', callback: (payload) {
      log('[_onGameStarted] >>> game_enemy_ball_height');
      if (payload['enemy_ball_height'] == null) {
        ErrorHandler.showErrorDialog(context, '対戦相手のアイテムの高さの受信に失敗');
        return;
      }
      final enemy_ball_height = (payload['enemy_ball_height'] as num).toDouble();
      final sendId = payload['send_id'] as String;
      if (sendId != myUserId) {
        // print('enemy_ball_height: $enemy_ball_height');
        // enemyBallState = enemy_ball_height;
        ///////////////////////////////////////////////////
        // print('----- BEFORE --------------------');
        // for (var status in enemyBallState) {
        //   print('UserID: ${status.userid}, Height: ${status.height}');
        // }
        // 既存のユーザーIDを持つ状態を探す
        var existingStatus = enemyBallState.firstWhere(
          (e) => e.userid == sendId,
          orElse: () => EnemyBallStatus()..userid = '',
        );

        if (existingStatus.userid == sendId) {
          // 見つかった場合は高さを更新
          existingStatus.height = enemy_ball_height;
        } else {
          // 見つからない場合は新しい状態を追加
          enemyBallState.add(EnemyBallStatus()
            ..userid = sendId
            ..height = enemy_ball_height);
        }
        // print('----- AFTER --------------------');
        // for (var status in enemyBallState) {
        //   print('UserID: ${status.userid}, Height: ${status.height}');
        // }
        ///////////////////////////////////////////////////
        log('[受信] 対戦相手の高さ設定');
      }
    }).onBroadcast(event: 'game_chain', callback: (payload) {
      log('[_onGameStarted] >>> game_chain');
      if (payload['send_id'] == null || payload['chain'] == null) {
        ErrorHandler.showErrorDialog(context, '対戦相手からの[おじゃまむし]の受信に失敗');
        return;
      }
      final sendId = payload['send_id'] as String;
      final chain = payload['chain'] as int;
      if (sendId != myUserId) {
        log('chain(1): $chain');
        opponetBall.value = chain;
        // _onOpponentChainAttack(chain);
      }
    }).onBroadcast(event: 'game_over', callback: (payload) {
      log('[_onGameStarted] >>> game_over');
      removeGameChannel();
      _multiGameOverCallback?.call();
    }).subscribe((status, [_]) async {
      log('[_onGameStarted] >>> onSubscrive');
      log('  --> status : ${status}');
      if (status == RealtimeSubscribeStatus.subscribed) {
        log('    --> クライアントがサーバーと接続し、リアルタイムデータを受信できる状態です。');
      }
      else if (status == RealtimeSubscribeStatus.channelError) {
        ErrorHandler.showErrorDialog(context, 'チャンネルにエラーが発生');
      }
      else if (status == RealtimeSubscribeStatus.closed) {
        log('    --> チャンネルが閉じられました。');
      }
      else if (status == RealtimeSubscribeStatus.timedOut) {
        ErrorHandler.showErrorDialog(context, 'サーバーからの応答が一定時間内に受信できず、接続がタイムアウト');
      }
    });

    await removeWaitingChannel();

    _multiGameStartCallback?.call();
  }
}
