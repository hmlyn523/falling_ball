import 'dart:async';

class AutoFallingTimer {
  Timer? _timer;

  final Duration interval;
  final void Function() onTimeout;

  int? _remainingTicks; // 残り時間（秒単位）
  void Function(int)? onTick; // 各秒ごとの処理（任意）

  AutoFallingTimer({required this.interval, required this.onTimeout});

  // タイマーを開始
  void start({int? countdownSeconds, void Function(int)? onTick}) {
    stop(); // 念のため前回のタイマーを停止

    _remainingTicks = countdownSeconds; // 残り秒数を設定
    this.onTick = onTick;

    if (countdownSeconds != null && countdownSeconds > 0) {
      // カウントダウン用タイマー
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (_remainingTicks != null && _remainingTicks! > 0) {
          _remainingTicks = _remainingTicks! - 1;
          if (onTick != null) {
            onTick(_remainingTicks!); // 1秒ごとに処理を呼び出し
          }
        } else {
          timer.cancel();
          onTimeout(); // タイマー満了時の処理
        }
      });
    } else {
      // 通常の単発タイマー
      _timer = Timer(interval, onTimeout);
    }
  }

  // タイマーを停止
  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  // タイマーが実行中か確認
  bool isRunning() {
    return _timer?.isActive ?? false;
  }
}
