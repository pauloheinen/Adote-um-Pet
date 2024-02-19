import 'dart:async';

import 'package:connectivity/connectivity.dart';

class ConnectivityService {
  late Connectivity _connectivity;
  late StreamController<ConnectivityResult> _connectivityController;

  ConnectivityService() {
    _connectivity = Connectivity();
    _connectivityController = StreamController<ConnectivityResult>.broadcast();

    _initConnectivity();

    _connectivity.onConnectivityChanged.listen((result) {
      _connectivityController.add(result);
    });
  }

  Future<void> _initConnectivity() async {
    var connectivityResult = await _connectivity.checkConnectivity();
    _connectivityController.add(connectivityResult);
  }

  Stream<ConnectivityResult> get connectivityStream =>
      _connectivityController.stream;

  Future<ConnectivityResult> getConnectivityStatus() async {
    return await _connectivity.checkConnectivity();
  }

  void dispose() {
    _connectivityController.close();
  }
}
