class EventBus {
  final Map<String, List<Function>> _listeners = {};

  // イベントのリスナーを追加
  void subscribe(String eventName, Function callback) {
    if (!_listeners.containsKey(eventName)) {
      _listeners[eventName] = [];
    }
    _listeners[eventName]?.add(callback);
  }

  // イベントの発行
  void publish(String eventName, dynamic data) {
    if (_listeners.containsKey(eventName)) {
      for (var callback in _listeners[eventName]!) {
        callback(data);
      }
    }
  }
}
