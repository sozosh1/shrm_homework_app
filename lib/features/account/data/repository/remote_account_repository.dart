import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/account/data/models/account_create_request/account_create_request.dart';
import 'package:shrm_homework_app/features/account/data/models/account_history_response/account_history_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Remote data source для работы с API аккаунтов
@injectable
class RemoteAccountRepository {
  final DioClient _dioClient;
  final Talker _talker;

  RemoteAccountRepository(this._dioClient, this._talker);

  /// Получить все аккаунты пользователя
  Future<List<Account>> getAllAccounts() async {
    _talker.info('🌐 RemoteAccountRepository: Получение всех аккаунтов');
    try {
      final response = await _dioClient.get('/accounts');
      _talker.debug('📥 RemoteAccountRepository: Получен ответ для всех аккаунтов');
      
      final accounts = (response.data as List)
          .map((json) => Account.fromJson(json))
          .toList();
      
      _talker.info('✅ RemoteAccountRepository: Успешно получено ${accounts.length} аккаунтов');
      return accounts;
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка получения всех аккаунтов', e, st);
      rethrow;
    }
  }

  /// Получить аккаунт по ID с детальной статистикой
  Future<AccountResponse> getAccount(int id) async {
    _talker.info('🌐 RemoteAccountRepository: Получение аккаунта ID: $id');
    try {
      final response = await _dioClient.get('/accounts/$id');
      _talker.debug('📥 RemoteAccountRepository: Получен ответ для аккаунта $id');
      
      final account = AccountResponse.fromJson(response.data);
      _talker.info('✅ RemoteAccountRepository: Успешно получен аккаунт ${account.name}');
      return account;
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка получения аккаунта $id', e, st);
      rethrow;
    }
  }

  /// Создать новый аккаунт
  Future<Account> createAccount(AccountCreateRequest request) async {
    _talker.info('🌐 RemoteAccountRepository: Создание аккаунта ${request.name}');
    try {
      final response = await _dioClient.post(
        '/accounts',
        data: request.toJson(),
      );
      _talker.debug('📥 RemoteAccountRepository: Получен ответ на создание аккаунта');
      
      final account = Account.fromJson(response.data);
      _talker.info('✅ RemoteAccountRepository: Успешно создан аккаунт ID: ${account.id}');
      return account;
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка создания аккаунта ${request.name}', e, st);
      rethrow;
    }
  }

  /// Обновить существующий аккаунт
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    _talker.info('🌐 RemoteAccountRepository: Обновление аккаунта ID: $id');
    try {
      final response = await _dioClient.put(
        '/accounts/$id',
        data: request.toJson(),
      );
      _talker.debug('📥 RemoteAccountRepository: Получен ответ на обновление аккаунта $id');
      
      final account = Account.fromJson(response.data);
      _talker.info('✅ RemoteAccountRepository: Успешно обновлен аккаунт ${account.name}');
      return account;
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка обновления аккаунта $id', e, st);
      rethrow;
    }
  }

  /// Удалить аккаунт
  Future<void> deleteAccount(int id) async {
    _talker.info('🌐 RemoteAccountRepository: Удаление аккаунта ID: $id');
    try {
      await _dioClient.delete('/accounts/$id');
      _talker.info('✅ RemoteAccountRepository: Успешно удален аккаунт ID: $id');
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка удаления аккаунта $id', e, st);
      rethrow;
    }
  }

  /// Получить историю изменений аккаунта
  Future<AccountHistoryResponse> getAccountHistory(int id) async {
    _talker.info('🌐 RemoteAccountRepository: Получение истории аккаунта ID: $id');
    try {
      final response = await _dioClient.get('/accounts/$id/history');
      _talker.debug('📥 RemoteAccountRepository: Получен ответ истории аккаунта $id');
      
      final history = AccountHistoryResponse.fromJson(response.data);
      _talker.info('✅ RemoteAccountRepository: Успешно получена история с ${history.history.length} записями');
      return history;
    } catch (e, st) {
      _talker.error('❌ RemoteAccountRepository: Ошибка получения истории аккаунта $id', e, st);
      rethrow;
    }
  }
}
