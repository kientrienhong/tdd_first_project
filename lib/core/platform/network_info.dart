import 'package:connectivity_plus/connectivity_plus.dart';

abstract class NetworkInfo {
  Future<bool> isConnected();
}

class NetworkInfoImpl implements NetworkInfo {
  late Connectivity _connectivity;
  late Future<bool> _isConnect;
  NetworkInfoImpl() {
    _connectivity = Connectivity();
    _isConnect = _connectivity
        .checkConnectivity()
        .then((value) => value == ConnectivityResult.wifi);
  }

  @override
  Future<bool> isConnected() async => _isConnect;
}
