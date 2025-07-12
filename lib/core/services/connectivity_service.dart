import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@singleton
class ConnectivityService {
  final Connectivity _connectivity = Connectivity();
  final Talker _talker;

  ConnectivityService(this._talker);

  /// Проверяет текущее состояние подключения к интернету
  Future<bool> get isConnected async {
    try {
      final results = await _connectivity.checkConnectivity();
      final connected = _isConnectedResults(results);
      
      _talker.debug('🌐 Connection status: ${connected ? 'ONLINE' : 'OFFLINE'}');
      _talker.debug('🔍 Connection types: $results');
      return connected;
    } catch (e) {
      _talker.error('❌ Error checking connectivity', e);
      return false;
    }
  }

  /// Стрим изменений состояния подключения
  Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map((results) {
      final connected = _isConnectedResults(results);
      _talker.info('🔄 Connection changed: ${connected ? 'ONLINE' : 'OFFLINE'}');
      _talker.debug('🔍 New connection types: $results');
      return connected;
    }).handleError((error) {
      _talker.error('❌ Error in connectivity stream', error);
      return false;
    });
  }

  /// Проверяет, означают ли результаты подключения наличие интернета
  bool _isConnectedResults(List<ConnectivityResult> results) {
    // Если хотя бы одно подключение активно, считаем что есть интернет
    return results.any((result) => _isConnectedResult(result));
  }

  /// Проверяет, означает ли результат подключения наличие интернета
  bool _isConnectedResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
      case ConnectivityResult.mobile:
      case ConnectivityResult.ethernet:
        return true;
      case ConnectivityResult.none:
      case ConnectivityResult.bluetooth:
      case ConnectivityResult.vpn:
      case ConnectivityResult.other:
        return false;
    }
  }

  /// Ожидает появления подключения к интернету
  Future<void> waitForConnection({Duration timeout = const Duration(seconds: 30)}) async {
    if (await isConnected) {
      _talker.debug('✅ Already connected, no need to wait');
      return;
    }

    _talker.info('⏳ Waiting for internet connection...');
    
    try {
      await connectivityStream
          .where((connected) => connected)
          .timeout(timeout)
          .first;
      
      _talker.info('✅ Internet connection restored');
    } on TimeoutException {
      _talker.warning('⏰ Timeout waiting for connection after ${timeout.inSeconds}s');
      rethrow;
    }
  }

  /// Получает список текущих типов подключения (для отладки)
  Future<List<ConnectivityResult>> getCurrentConnectivityTypes() async {
    try {
      final results = await _connectivity.checkConnectivity();
      _talker.debug('📱 Current connectivity types: $results');
      return results;
    } catch (e) {
      _talker.error('❌ Error getting connectivity types', e);
      return [ConnectivityResult.none];
    }
  }

  /// Проверяет, доступен ли конкретный тип подключения
  Future<bool> isConnectedVia(ConnectivityResult type) async {
    try {
      final results = await _connectivity.checkConnectivity();
      final hasType = results.contains(type);
      _talker.debug('🔍 Connection via $type: $hasType');
      return hasType;
    } catch (e) {
      _talker.error('❌ Error checking specific connectivity type', e);
      return false;
    }
  }
}