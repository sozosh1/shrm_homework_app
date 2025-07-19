import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@singleton
class ConnectivityService {
  final Connectivity _connectivity;
  final Talker _talker;
  final StreamController<bool> _connectionController =
      StreamController<bool>.broadcast();

  ConnectivityService(this._talker) : _connectivity = Connectivity() {
    _init();
  }

  Future<void> _init() async {
    
    final initialStatus = await checkConnection();
    _connectionController.add(initialStatus);

    
    _connectivity.onConnectivityChanged.listen((results) async {
      final isConnected = _isConnectedResults(results);
      _logConnectionChange(isConnected, results);
      _connectionController.add(isConnected);

     
      if (isConnected) {
        _talker.info('🌍 Internet connection restored - triggering sync');
      }
    });
  }


  Future<bool> checkConnection() async {
    try {
      final results = await _connectivity.checkConnectivity();
      return _isConnectedResults(results);
    } catch (e) {
      _talker.error('Connection check failed', e);
      return false;
    }
  }

  Stream<bool> get connectionStream => _connectionController.stream;

  
  Future<ConnectivityResult> get currentStatus async {
    return (await _connectivity.checkConnectivity()).first;
  }

  bool _isConnectedResults(List<ConnectivityResult> results) {
    return results.any(_isConnectedResult);
  }

  bool _isConnectedResult(ConnectivityResult result) {
    return result == ConnectivityResult.wifi ||
        result == ConnectivityResult.mobile ||
        result == ConnectivityResult.ethernet;
  }

  void _logConnectionChange(
    bool isConnected,
    List<ConnectivityResult> results,
  ) {
    _talker.info(
      '🌐 Connection changed to: ${isConnected ? 'ONLINE' : 'OFFLINE'} '
      '(Types: ${results.join(', ')})',
    );
  }

  Future<void> dispose() async {
    await _connectionController.close();
  }
}
