import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/sync_event_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:shrm_homework_app/features/transaction/data/datasources/local_transaction_data_source.dart';
import 'package:shrm_homework_app/features/transaction/data/datasources/remote_transaction_datasource.dart';

import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

@Injectable(as: TransactionRepository)
class TransactionRepositoryImpl implements TransactionRepository {
  final LocalTransactionDataSource _localDataSource;
  final RemoteTransactionDataSource _remoteDataSource;
  final SyncEventService _syncEventService;
  final Talker _talker;

  TransactionRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncEventService,
    this._talker,
  );
  @override
  Future<TransactionResponse> createTransaction(
    TransactionRequest request,
  ) async {
    final transaction = await _localDataSource.createTransaction(request);
    await _syncEventService.addEvent(
      EntityType.transaction,
      transaction.id,
      Operation.create,
    );
    return transaction;
  }

  @override
  Future<void> deleteTransaction(int id) async {
    final transaction = await _localDataSource.getTransaction(id);
    await _localDataSource.deleteTransaction(id);
    await _syncEventService.addEvent(
      EntityType.transaction,
      transaction.id,
      Operation.delete,
    );
  }

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    try {
      await processSyncEvents();
      final remoteTransaction = await _remoteDataSource.getTransaction(id);
      await _localDataSource.saveTransactions([remoteTransaction]);
    } catch (e, st) {
      _talker.handle(e, st, 'Failed to sync getTransaction');
    }
    return _localDataSource.getTransaction(id);
  }

  @override
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    final transaction = await _localDataSource.updateTransaction(id, request);
    await _syncEventService.addEvent(
      EntityType.transaction,
      transaction.id,
      Operation.update,
    );
    return transaction;
  }

  @override
  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      await processSyncEvents();
      final remoteTransactions = await _remoteDataSource
          .getTransactionsByPeriod(
            accountId,
            startDate:
                startDate ?? DateTime.now().subtract(const Duration(days: 30)),
            endDate: endDate ?? DateTime.now(),
          );
      await _localDataSource.saveTransactions(remoteTransactions);
    } catch (e, st) {
      _talker.handle(e, st, 'Failed to sync getTransactionsByPeriod');
    }
    return _localDataSource.getTransactionsByPeriod(
      accountId,
      startDate: startDate,
      endDate: endDate,
    );
  }

  Future<void> processSyncEvents() async {
    final events = await _syncEventService.getEvents();
    for (final event in events) {
      try {
        if (event.entityType == EntityType.transaction) {
          final transaction = await _localDataSource.getTransaction(
            event.entityId,
          );
          switch (event.operation) {
            case Operation.create:
              final remoteTransaction = await _remoteDataSource
                  .createTransaction(transaction.toRequest());
              await _localDataSource.saveTransactions([remoteTransaction]);
              break;
            case Operation.update:
              await _remoteDataSource.updateTransaction(
                transaction.id,
                transaction.toRequest(),
              );
              break;
            case Operation.delete:
              await _remoteDataSource.deleteTransaction(transaction.id);
              break;
          }
        }
        await _syncEventService.deleteEvent(event.id);
      } catch (e, st) {
        _talker.handle(e, st, 'Failed to process sync event');
      }
    }
  }
}
