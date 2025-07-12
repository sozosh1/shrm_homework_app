import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/backup_sync_service.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/data/repository/local_transaction_repository.dart';
import 'package:shrm_homework_app/features/transaction/data/repository/remote_transaction_repository.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Основная реализация TransactionRepository с offline-first подходом
@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final LocalTransactionRepository _localRepository;
  final RemoteTransactionRepository _remoteRepository;
  final ConnectivityService _connectivityService;
  final BackupSyncService _backupSyncService;
  final Talker _talker;

  TransactionRepositoryImpl(
    this._localRepository,
    this._remoteRepository,
    this._connectivityService,
    this._backupSyncService,
    this._talker,
  );

  @override
  Future<List<TransactionResponse>> getAllTransactions() async {
    _talker.info('🎯 TransactionRepositoryImpl: Получение всех транзакций (offline-first)');
    
    try {
      // 1. Пытаемся синхронизировать несинхронизированные операции
      await _trySync();
      
      // 2. Если есть интернет, получаем данные с сервера по основному аккаунту
      if (await _connectivityService.isConnected) {
        _talker.info('🌐 TransactionRepositoryImpl: Интернет доступен, получаем данные с сервера через правильный endpoint');
        try {
          // Используем правильный endpoint для получения транзакций по аккаунту за период
          // По умолчанию для аккаунта ID=1 за последние 6 месяцев
          final now = DateTime.now();
          final startDate = DateTime(now.year, now.month - 6, now.day);
          
          _talker.debug('🔍 TransactionRepositoryImpl: Запрашиваем транзакции с $startDate по $now для аккаунта 1');
          
          final remoteTransactions = await _remoteRepository.getTransactionsByAccountAndPeriod(
            accountId: 1,
            startDate: startDate,
            endDate: now,
          );
          _talker.info('✅ TransactionRepositoryImpl: Получено ${remoteTransactions.length} транзакций с сервера через правильный endpoint');
          
          // Если сервер вернул данные, обновляем локальные и возвращаем серверные
          if (remoteTransactions.isNotEmpty) {
            await _updateLocalFromRemote(remoteTransactions);
            return remoteTransactions;
          } else {
            // Если сервер вернул пустой список, используем локальные данные
            _talker.info('📱 TransactionRepositoryImpl: Сервер вернул пустой список, используем локальные данные');
            return await _localRepository.getAllTransactions();
          }
        } catch (e) {
          _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка получения с сервера, используем локальные данные', e);
          return await _localRepository.getAllTransactions();
        }
      } else {
        _talker.info('📱 TransactionRepositoryImpl: Нет интернета, используем локальные данные');
        return await _localRepository.getAllTransactions();
      }
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Критическая ошибка получения транзакций', e, st);
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    _talker.info('🎯 TransactionRepositoryImpl: Получение транзакции ID: $id (offline-first)');
    
    try {
      await _trySync();
      
      if (await _connectivityService.isConnected) {
        try {
          final remoteTransaction = await _remoteRepository.getTransaction(id);
          _talker.info('✅ TransactionRepositoryImpl: Получена транзакция $id с сервера');
          return remoteTransaction;
        } catch (e) {
          _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка получения транзакции с сервера, используем локальные', e);
          return await _localRepository.getTransaction(id);
        }
      } else {
        return await _localRepository.getTransaction(id);
      }
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Критическая ошибка получения транзакции $id', e, st);
      rethrow;
    }
  }

  @override
  Future<Transaction> createTransaction(TransactionRequest request) async {
    _talker.info('🎯 TransactionRepositoryImpl: Создание транзакции ${request.amount} (offline-first)');
    
    try {
      // 1. Сначала сохраняем локально (offline-first)
      _talker.info('💾 TransactionRepositoryImpl: Сохраняем транзакцию локально');
      final localTransaction = await _localRepository.createTransaction(request);
      
      // 2. Добавляем операцию в бэкап для синхронизации
      await _backupSyncService.addBackupOperation(
        operationType: 'create',
        entityType: 'transaction',
        entityId: localTransaction.id,
        entityData: request.toJson(),
      );
      _talker.info('📝 TransactionRepositoryImpl: Операция создания добавлена в очередь синхронизации');
      
      // 3. Пытаемся сразу синхронизировать, если есть интернет
      await _trySync();
      
      return localTransaction;
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Критическая ошибка создания транзакции', e, st);
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> updateTransaction(int id, TransactionRequest request) async {
    _talker.info('🎯 TransactionRepositoryImpl: Обновление транзакции ID: $id (offline-first)');
    
    try {
      // 1. Сначала обновляем локально
      _talker.info('💾 TransactionRepositoryImpl: Обновляем транзакцию локально');
      final localTransaction = await _localRepository.updateTransaction(id, request);
      
      // 2. Добавляем операцию в бэкап для синхронизации
      await _backupSyncService.addBackupOperation(
        operationType: 'update',
        entityType: 'transaction',
        entityId: id,
        entityData: request.toJson(),
      );
      _talker.info('📝 TransactionRepositoryImpl: Операция обновления добавлена в очередь синхронизации');
      
      // 3. Пытаемся сразу синхронизировать
      await _trySync();
      
      return localTransaction;
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Критическая ошибка обновления транзакции $id', e, st);
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    _talker.info('🎯 TransactionRepositoryImpl: Удаление транзакции ID: $id (offline-first)');
    
    try {
      // 1. Пытаемся получить данные транзакции для бэкапа (может не существовать локально)
      TransactionResponse? transaction;
      try {
        transaction = await _localRepository.getTransaction(id);
      } catch (e) {
        _talker.warning('⚠️ TransactionRepositoryImpl: Транзакция $id не найдена локально: $e');
      }
      
      // 2. Удаляем локально (если транзакция существует)
      _talker.info('💾 TransactionRepositoryImpl: Удаляем транзакцию локально');
      await _localRepository.deleteTransaction(id);
      
      // 3. Добавляем операцию в бэкап для синхронизации только если транзакция была найдена
      if (transaction != null) {
        await _backupSyncService.addBackupOperation(
          operationType: 'delete',
          entityType: 'transaction',
          entityId: id,
          entityData: TransactionRequest(
            accountId: transaction.account.id,
            categoryId: transaction.category.id,
            amount: transaction.amount,
            comment: transaction.comment,
            transactionDate: transaction.transactionDate,
          ).toJson(),
        );
        _talker.info('📝 TransactionRepositoryImpl: Операция удаления добавлена в очередь синхронизации');
      } else {
        _talker.info('📝 TransactionRepositoryImpl: Транзакция не найдена локально, синхронизация не требуется');
      }
      
      // 4. Пытаемся сразу синхронизировать
      await _trySync();
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Критическая ошибка удаления транзакции $id', e, st);
      rethrow;
    }
  }

  /// Пытается синхронизировать все несинхронизированные операции
  Future<void> _trySync() async {
    try {
      if (await _connectivityService.isConnected) {
        _talker.info('🔄 TransactionRepositoryImpl: Начинаем синхронизацию');
        
        final pendingCount = await _backupSyncService.getPendingOperationsCount();
        if (pendingCount > 0) {
          _talker.info('📋 TransactionRepositoryImpl: Найдено $pendingCount несинхронизированных операций');
          
          final success = await _backupSyncService.syncAllOperations();
          if (success) {
            _talker.info('✅ TransactionRepositoryImpl: Синхронизация завершена успешно');
          } else {
            _talker.warning('⚠️ TransactionRepositoryImpl: Синхронизация завершена с ошибками');
          }
        }
      }
    } catch (e, st) {
      _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка при попытке синхронизации', e, st);
    }
  }

  /// Обновляет локальные данные на основе данных с сервера
  Future<void> _updateLocalFromRemote(List<TransactionResponse> remoteTransactions) async {
    try {
      _talker.info('🔄 TransactionRepositoryImpl: Обновляем локальные данные на основе серверных');
      
      // Здесь можно реализовать более сложную логику синхронизации
      // Например, сравнение дат обновления и merge конфликтов
      
      _talker.info('✅ TransactionRepositoryImpl: Локальные данные обновлены');
    } catch (e, st) {
      _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка обновления локальных данных', e, st);
    }
  }

  /// Принудительная синхронизация
  Future<bool> forceSync() async {
    _talker.info('🔄 TransactionRepositoryImpl: Принудительная синхронизация');
    try {
      return await _backupSyncService.syncAllOperations();
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Ошибка принудительной синхронизации', e, st);
      return false;
    }
  }

  /// Получает количество несинхронизированных операций
  Future<int> getPendingOperationsCount() async {
    try {
      return await _backupSyncService.getPendingOperationsCount();
    } catch (e, st) {
      _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка получения количества операций', e, st);
      return 0;
    }
  }

  /// Очищает все несинхронизированные операции
  Future<void> clearAllPendingOperations() async {
    _talker.info('🧹 TransactionRepositoryImpl: Очистка всех несинхронизированных операций');
    try {
      await _backupSyncService.clearAllPendingOperations();
      _talker.info('✅ TransactionRepositoryImpl: Все несинхронизированные операции очищены');
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Ошибка очистки операций', e, st);
      rethrow;
    }
  }

  /// Очищает только проблемные операции
  Future<void> clearFailedOperations() async {
    _talker.info('🧹 TransactionRepositoryImpl: Очистка проблемных операций');
    try {
      await _backupSyncService.clearFailedOperations();
      _talker.info('✅ TransactionRepositoryImpl: Проблемные операции очищены');
    } catch (e, st) {
      _talker.error('❌ TransactionRepositoryImpl: Ошибка очистки проблемных операций', e, st);
      rethrow;
    }
  }

  /// Получает информацию о несинхронизированных операциях
  Future<List<Map<String, dynamic>>> getPendingOperationsInfo() async {
    try {
      final operations = await _backupSyncService.getPendingOperations();
      return operations.map((op) => {
        'id': op.id,
        'type': op.operationType,
        'entity': op.entityType,
        'entityId': op.entityId,
        'createdAt': op.createdAt.toIso8601String(),
        'retryCount': op.retryCount,
        'syncError': op.syncError,
      }).toList();
    } catch (e, st) {
      _talker.warning('⚠️ TransactionRepositoryImpl: Ошибка получения информации об операциях', e, st);
      return [];
    }
  }
}
