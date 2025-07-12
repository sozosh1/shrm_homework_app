import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/backup_sync_service.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/data/repository/local_account_repository.dart';
import 'package:shrm_homework_app/features/account/data/repository/remote_account_repository.dart';
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Основная реализация AccountRepository с offline-first подходом
/// Сначала работает с локальными данными, затем синхронизируется с сервером
@Injectable(as: AccountRepository)
class AccountRepositoryImpl implements AccountRepository {
  final LocalAccountRepository _localRepository;
  final RemoteAccountRepository _remoteRepository;
  final ConnectivityService _connectivityService;
  final BackupSyncService _backupSyncService;
  final Talker _talker;

  AccountRepositoryImpl(
    this._localRepository,
    this._remoteRepository,
    this._connectivityService,
    this._backupSyncService,
    this._talker,
  );

  @override
  Future<AccountResponse> getAccount(int id) async {
    _talker.info('🎯 AccountRepositoryImpl: Получение аккаунта ID: $id (offline-first)');
    
    try {
      // 1. Сначала пытаемся синхронизировать несинхронизированные операции
      await _trySync();
      
      // 2. Если есть интернет, получаем данные с сервера
      if (await _connectivityService.isConnected) {
        _talker.info('🌐 AccountRepositoryImpl: Интернет доступен, получаем данные с сервера');
        try {
          final remoteAccount = await _remoteRepository.getAccount(id);
          _talker.info('✅ AccountRepositoryImpl: Получены данные с сервера, обновляем локальные');
          
          // Обновляем локальные данные после успешного получения с сервера
          await _updateLocalFromRemote(remoteAccount);
          
          return remoteAccount;
        } catch (e) {
          _talker.warning('⚠️ AccountRepositoryImpl: Ошибка получения с сервера, используем локальные данные', e);
          // Если ошибка сервера, используем локальные данные
          return await _localRepository.getAccount(id);
        }
      } else {
        _talker.info('📱 AccountRepositoryImpl: Нет интернета, используем локальные данные');
        return await _localRepository.getAccount(id);
      }
    } catch (e, st) {
      _talker.error('❌ AccountRepositoryImpl: Критическая ошибка получения аккаунта $id', e, st);
      rethrow;
    }
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    _talker.info('🎯 AccountRepositoryImpl: Обновление аккаунта ID: $id (offline-first)');
    
    try {
      // 1. Сначала обновляем локально (offline-first)
      _talker.info('💾 AccountRepositoryImpl: Сохраняем изменения локально');
      final localAccount = await _localRepository.updateAccount(id, request);
      
      // 2. Добавляем операцию в бэкап для синхронизации
      await _backupSyncService.addBackupOperation(
        operationType: 'update',
        entityType: 'account',
        entityId: id,
        entityData: {
          'name': request.name,
          'balance': request.balance,
          'currency': request.currency,
        },
      );
      _talker.info('📝 AccountRepositoryImpl: Операция обновления добавлена в очередь синхронизации');
      
      // 3. Пытаемся сразу синхронизировать, если есть интернет
      await _trySync();
      
      return localAccount;
    } catch (e, st) {
      _talker.error('❌ AccountRepositoryImpl: Критическая ошибка обновления аккаунта $id', e, st);
      rethrow;
    }
  }

  @override
  Stream<List<Map<String, dynamic>>> getTransactionHistoryStream() {
    _talker.info('🎯 AccountRepositoryImpl: Получение стрима истории транзакций');
    return _localRepository.getTransactionHistoryStream();
  }

  /// Пытается синхронизировать все несинхронизированные операции
  Future<void> _trySync() async {
    try {
      if (await _connectivityService.isConnected) {
        _talker.info('🔄 AccountRepositoryImpl: Начинаем синхронизацию');
        
        final pendingCount = await _backupSyncService.getPendingOperationsCount();
        if (pendingCount > 0) {
          _talker.info('📋 AccountRepositoryImpl: Найдено $pendingCount несинхронизированных операций');
          
          final success = await _backupSyncService.syncAllOperations();
          if (success) {
            _talker.info('✅ AccountRepositoryImpl: Синхронизация завершена успешно');
          } else {
            _talker.warning('⚠️ AccountRepositoryImpl: Синхронизация завершена с ошибками');
          }
        } else {
          _talker.debug('📋 AccountRepositoryImpl: Нет несинхронизированных операций');
        }
      } else {
        _talker.debug('📱 AccountRepositoryImpl: Нет интернета, синхронизация пропущена');
      }
    } catch (e, st) {
      _talker.warning('⚠️ AccountRepositoryImpl: Ошибка при попытке синхронизации', e, st);
    }
  }

  /// Обновляет локальные данные на основе данных с сервера
  Future<void> _updateLocalFromRemote(AccountResponse remoteAccount) async {
    try {
      _talker.info('🔄 AccountRepositoryImpl: Обновляем локальные данные на основе серверных');
      
      // Обновляем основные данные аккаунта
      final updateRequest = AccountUpdateRequest(
        name: remoteAccount.name,
        balance: remoteAccount.balance,
        currency: remoteAccount.currency,
      );
      
      await _localRepository.updateAccount(remoteAccount.id, updateRequest);
      _talker.info('✅ AccountRepositoryImpl: Локальные данные обновлены');
    } catch (e, st) {
      _talker.warning('⚠️ AccountRepositoryImpl: Ошибка обновления локальных данных', e, st);
    }
  }

  /// Возвращает статус синхронизации
  Future<bool> isSynced() async {
    try {
      return await _backupSyncService.isFullySynced;
    } catch (e, st) {
      _talker.warning('⚠️ AccountRepositoryImpl: Ошибка проверки статуса синхронизации', e, st);
      return false;
    }
  }

  /// Принудительная синхронизация
  Future<bool> forceSync() async {
    _talker.info('🔄 AccountRepositoryImpl: Принудительная синхронизация');
    try {
      return await _backupSyncService.syncAllOperations();
    } catch (e, st) {
      _talker.error('❌ AccountRepositoryImpl: Ошибка принудительной синхронизации', e, st);
      return false;
    }
  }

  /// Получает количество несинхронизированных операций
  Future<int> getPendingOperationsCount() async {
    try {
      return await _backupSyncService.getPendingOperationsCount();
    } catch (e, st) {
      _talker.warning('⚠️ AccountRepositoryImpl: Ошибка получения количества операций', e, st);
      return 0;
    }
  }
}
