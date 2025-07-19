import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/sync_event_service.dart';
import 'package:shrm_homework_app/features/account/data/datasources/local_account_data_source.dart';
import 'package:shrm_homework_app/features/account/data/datasources/remote_account_datasource.dart';
import 'package:shrm_homework_app/features/account/data/models/account/account.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

@Injectable(as: AccountRepository)
class AccountRepositoryImpl extends AccountRepository {
  final LocalAccountDataSource _localDataSource;
  final RemoteAccountDataSource _remoteDataSource;
  final SyncEventService _syncEventService;
  final Talker _talker;

  AccountRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncEventService,
    this._talker,
  );

  @override
  Future<AccountResponse> getAccount(int id) async {
    await processSyncEvents();
    final localData = await _localDataSource.getAccount(id);
    try {
      final remoteData = await _remoteDataSource.getAccount(id);
      await _localDataSource.saveAccountResponse(remoteData);
      return remoteData;
    } catch (e, st) {
      _talker.handle(e, st, 'Failed to fetch remote account, returning local data');
      return localData;
    }
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    final account = await _localDataSource.updateAccount(id, request);
    await _syncEventService.addEvent(EntityType.account, account.id, Operation.update);
    return account;
  }

  Future<void> processSyncEvents() async {
    final events = await _syncEventService.getEvents();
    for (final event in events) {
      try {
        if (event.entityType == EntityType.account) {
          final account = await _localDataSource.getAccount(event.entityId);
          switch (event.operation) {
            case Operation.update:
              await _remoteDataSource.updateAccount(
                account.id,
                AccountUpdateRequest.fromAccountResponse(account),
              );
              break;
            case Operation.create:
            case Operation.delete:
              // Not applicable for accounts in this implementation
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