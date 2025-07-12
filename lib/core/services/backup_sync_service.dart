import 'dart:async';
import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

@singleton
class BackupSyncService {
  final AppDatabase _database;
  final DioClient _dioClient;
  final ConnectivityService _connectivity;
  final Talker _talker;

  BackupSyncService(
    this._database,
    this._dioClient,
    this._connectivity,
    this._talker,
  );

  /// Добавляет операцию в бэкап
  Future<void> addBackupOperation({
    required String operationType,
    required String entityType,
    int? entityId,
    required Map<String, dynamic> entityData,
  }) async {
    try {
      _talker.info('📝 Adding backup operation: $operationType $entityType (entityId: $entityId)');
      
      await _database
          .into(_database.backUpOperationsTable)
          .insert(
            BackUpOperationsTableCompanion.insert(
              operationType: operationType,
              entityType: entityType,
              entityId: Value(entityId),
              entityData: jsonEncode(entityData),
              createdAt: Value(DateTime.now()),
              retryCount: Value(0),
              isSynced: Value(false),
            ),
          );

      _talker.info('✅ Backup operation added successfully: $operationType $entityType');

      // Пытаемся синхронизировать сразу, если есть подключение
      if (await _connectivity.isConnected) {
        await _syncPendingOperations();
      }
    } catch (e, st) {
      _talker.error('❌ Failed to add backup operation', e, st);
      rethrow;
    }
  }

  /// Синхронизирует все несинхронизированные операции
  Future<bool> syncAllOperations() async {
    try {
      if (!await _connectivity.isConnected) {
        _talker.warning(' No internet connection, skipping sync');
        return false;
      }

      return await _syncPendingOperations();
    } catch (e) {
      _talker.error('❌ Sync failed', e);
      return false;
    }
  }

  /// Синхронизирует все несинхронизированные операции
  Future<bool> _syncPendingOperations() async {
    // Сначала очищаем операции с неправильным форматом даты
    await cleanupLegacyOperations();
    
    final operations =
        await (_database.select(_database.backUpOperationsTable)
              ..where((t) => t.isSynced.equals(false))
              ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
            .get();

    if (operations.isEmpty) {
      return true;
    }

    _talker.info('🔄 Syncing ${operations.length} pending operations');

    for (final operation in operations) {
      final success = await _syncSingleOperation(operation);
      if (!success) {
        return false;
      }
    }

    return true;
  }

  /// Синхронизирует одну операцию
  Future<bool> _syncSingleOperation(BackUpOperationsTableData operation) async {
    try {
      final entityData =
          jsonDecode(operation.entityData) as Map<String, dynamic>;

      switch (operation.entityType) {
        case 'account':
          return await _syncAccountOperation(operation, entityData);
        case 'transaction':
          return await _syncTransactionOperation(operation, entityData);
        case 'category':
          return await _syncCategoryOperation(operation, entityData);
        default:
          _talker.warning(' Unknown entity type: ');
          await _markOperationAsSynced(operation.id);
          return true;
      }
    } catch (e) {
      _talker.error('❌ Failed to sync operation ${operation.id}', e);
      await _markOperationAsFailed(operation.id, e.toString());
      return false;
    }
  }

  /// Синхронизирует операцию со счетом
  Future<bool> _syncAccountOperation(
    BackUpOperationsTableData operation,
    Map<String, dynamic> data,
  ) async {
    try {
      switch (operation.operationType) {
        case 'create':
          final response = await _dioClient.post('/accounts', data: data);
          _talker.info('✅ Account created on server: ${response.data}');
          break;
        case 'update':
          final response = await _dioClient.put(
            '/accounts/${operation.entityId}',
            data: data,
          );
          _talker.info('✅ Account updated on server: ${response.data}');
          break;
        case 'delete':
          await _dioClient.delete('/accounts/${operation.entityId}');
          _talker.info('✅ Account deleted on server');
          break;
      }

      await _markOperationAsSynced(operation.id);
      return true;
    } catch (e) {
      _talker.error('❌ Failed to sync account operation', e);
      await _markOperationAsFailed(operation.id, e.toString());
      return false;
    }
  }

  /// Синхронизирует операцию с транзакцией
  Future<bool> _syncTransactionOperation(
    BackUpOperationsTableData operation,
    Map<String, dynamic> data,
  ) async {
    try {
      _talker.info('🔄 Syncing transaction operation: ${operation.operationType}');
      _talker.debug('📋 Transaction data to sync: $data');
      
      // Очищаем данные от null значений для API
      final cleanData = _cleanDataForApi(data);
      _talker.debug('📤 Cleaned transaction data: $cleanData');
      
      switch (operation.operationType) {
        case 'create':
          final response = await _dioClient.post('/transactions', data: cleanData);
          _talker.info('✅ Transaction created on server: ${response.data}');
          break;
        case 'update':
          final response = await _dioClient.put(
            '/transactions/${operation.entityId}',
            data: cleanData,
          );
          _talker.info('✅ Transaction updated on server: ${response.data}');
          break;
        case 'delete':
          await _dioClient.delete('/transactions/${operation.entityId}');
          _talker.info('✅ Transaction deleted on server');
          break;
      }

      await _markOperationAsSynced(operation.id);
      return true;
    } catch (e) {
      _talker.error('❌ Failed to sync transaction operation', e);
      await _markOperationAsFailed(operation.id, e.toString());
      return false;
    }
  }

  /// Синхронизирует операцию с категорией
  Future<bool> _syncCategoryOperation(
    BackUpOperationsTableData operation,
    Map<String, dynamic> data,
  ) async {
    // Категории обычно только читаются, поэтому просто отмечаем как синхронизированные
    await _markOperationAsSynced(operation.id);
    return true;
  }

  /// Отмечает операцию как синхронизированную
  Future<void> _markOperationAsSynced(int operationId) async {
    await (_database.update(_database.backUpOperationsTable)
      ..where((t) => t.id.equals(operationId))).write(
      BackUpOperationsTableCompanion(
        isSynced: Value(true),
        syncedAt: Value(DateTime.now()),
        syncError: Value(null),
      ),
    );
  }

  /// Отмечает операцию как неудачную
  Future<void> _markOperationAsFailed(int operationId, String error) async {
    final operation =
        await (_database.select(_database.backUpOperationsTable)
          ..where((t) => t.id.equals(operationId))).getSingle();

    await (_database.update(_database.backUpOperationsTable)
      ..where((t) => t.id.equals(operationId))).write(
      BackUpOperationsTableCompanion(
        syncError: Value(error),
        retryCount: Value(operation.retryCount + 1),
      ),
    );
  }

  /// Получает количество несинхронизированных операций
  Future<int> getPendingOperationsCount() async {
    final count =
        await (_database.selectOnly(_database.backUpOperationsTable)
              ..where(_database.backUpOperationsTable.isSynced.equals(false))
              ..addColumns([_database.backUpOperationsTable.id.count()]))
            .getSingle();

    return count.read(_database.backUpOperationsTable.id.count()) ?? 0;
  }

  /// Получает статус синхронизации
  Future<bool> get isFullySynced async {
    return await getPendingOperationsCount() == 0;
  }

  /// Очищает старые синхронизированные операции
  Future<void> cleanupOldOperations({int keepDays = 30}) async {
    final cutoffDate = DateTime.now().subtract(Duration(days: keepDays));

    await (_database.delete(_database.backUpOperationsTable)..where(
      (t) =>
          t.isSynced.equals(true) & t.syncedAt.isSmallerThanValue(cutoffDate),
    )).go();

    _talker.info('🧹 Cleaned up old backup operations');
  }

  /// Очищает все неудачные операции синхронизации
  Future<void> clearFailedOperations() async {
    final deletedCount = await (_database.delete(_database.backUpOperationsTable)
          ..where((t) => t.isSynced.equals(false)))
        .go();
    
    _talker.info('🧹 Cleared $deletedCount failed backup operations');
  }

  /// Получает список всех несинхронизированных операций (для отладки)
  Future<List<BackUpOperationsTableData>> getPendingOperations() async {
    return await (_database.select(_database.backUpOperationsTable)
          ..where((t) => t.isSynced.equals(false))
          ..orderBy([(t) => OrderingTerm(expression: t.createdAt)]))
        .get();
  }

  /// Очищает операции с неправильным форматом даты (для миграции)
  Future<void> cleanupLegacyOperations() async {
    try {
      final operations = await getPendingOperations();
      int cleanedCount = 0;
      
      for (final operation in operations) {
        if (operation.entityType == 'transaction') {
          try {
            final data = jsonDecode(operation.entityData) as Map<String, dynamic>;
            final dateString = data['transactionDate'] as String?;
            
            // Если дата в ISO формате (содержит 'T'), то удаляем операцию
            if (dateString != null && dateString.contains('T')) {
              await (_database.delete(_database.backUpOperationsTable)
                    ..where((t) => t.id.equals(operation.id)))
                  .go();
              cleanedCount++;
            }
          } catch (e) {
            // Если не можем парсить данные, тоже удаляем
            await (_database.delete(_database.backUpOperationsTable)
                  ..where((t) => t.id.equals(operation.id)))
                .go();
            cleanedCount++;
          }
        }
      }
      
      if (cleanedCount > 0) {
        _talker.info('🧹 Cleaned up $cleanedCount legacy operations with incorrect date format');
      }
    } catch (e) {
      _talker.warning('⚠️ Error cleaning legacy operations', e);
    }
  }

  /// Очищает данные от null значений для отправки в API
  Map<String, dynamic> _cleanDataForApi(Map<String, dynamic> data) {
    final cleanData = <String, dynamic>{};
    
    for (final entry in data.entries) {
      if (entry.value != null) {
        // Дополнительная проверка для строк - исключаем пустые строки
        if (entry.value is String && (entry.value as String).isEmpty) {
          continue;
        }
        cleanData[entry.key] = entry.value;
      }
    }
    
    return cleanData;
  }

  /// Очищает все несинхронизированные операции
  Future<void> clearAllPendingOperations() async {
    try {
      final deleted = await (_database.delete(_database.backUpOperationsTable)
            ..where((t) => t.isSynced.equals(false)))
          .go();
      
      _talker.info('🧹 Cleared $deleted pending operations');
    } catch (e) {
      _talker.error('❌ Failed to clear pending operations', e);
      rethrow;
    }
  }

  /// Очищает операции старше определенного времени
  Future<void> clearOldOperations({int daysOld = 7}) async {
    try {
      final cutoffDate = DateTime.now().subtract(Duration(days: daysOld));
      final deleted = await (_database.delete(_database.backUpOperationsTable)
            ..where((t) => t.createdAt.isSmallerThanValue(cutoffDate)))
          .go();
      
      _talker.info('🧹 Cleared $deleted operations older than $daysOld days');
    } catch (e) {
      _talker.error('❌ Failed to clear old operations', e);
      rethrow;
    }
  }

  /// Получает все операции для отладки
  Future<List<BackUpOperationsTableData>> getAllOperations() async {
    try {
      return await _database.select(_database.backUpOperationsTable).get();
    } catch (e) {
      _talker.error('❌ Failed to get all operations', e);
      rethrow;
    }
  }

  /// Получает только проблемные операции
  Future<List<BackUpOperationsTableData>> getFailedOperations() async {
    try {
      return await (_database.select(_database.backUpOperationsTable)
            ..where((t) => t.syncError.isNotNull()))
          .get();
    } catch (e) {
      _talker.error('❌ Failed to get failed operations', e);
      rethrow;
    }
  }
}
