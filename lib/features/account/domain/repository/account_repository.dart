import 'package:shrm_homework_app/features/account/data/models/account_create_request/account_create_request.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/data/models/account_history_response/account_history_response.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';

abstract class AccountRepository {
  Future<Account> createAccount(data_account.AccountCreateRequest request);
  Future<Account> updateAccount(int id,data_account.AccountUpdateRequest request);
  Future<Account> getAccount(int id);
  Future<void> deleteAccount(int id);
  Future<data_account.AccountHistoryResponse> getAccountHistory(int id);
}
