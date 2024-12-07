import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityProvider with ChangeNotifier {
  bool _isOnline = true;
  late StreamSubscription _subscription;

  bool get isOnline => _isOnline;

  ConnectivityProvider() {
    _initConnectivity();
  }

  Future<void> _initConnectivity() async {
    _subscription = Connectivity().onConnectivityChanged.listen(_updateStatus);
  }

  Future<void> _updateStatus(List<ConnectivityResult> result) async {
    bool previousStatus = _isOnline;
    if (result[0] == ConnectivityResult.none) {
      _isOnline = false;
    } else {
      _isOnline = true;
    }

    if (previousStatus != _isOnline) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}