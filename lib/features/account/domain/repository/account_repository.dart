import 'package:shrm_homework_app/features/account/data/models/account_create_request/account_create_request.dart';
import 'package:shrm_homework_app/features/account/data/models/account_history_response/account_history_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';

abstract class AccountRepository {
  Future<Account> createAccount(AccountCreateRequest request);
  Future<Account> updateAccount(int id, AccountUpdateRequest request);
  Future<AccountResponse> getAccount(int id);
  Future<AccountHistoryResponse> getAccountHistory(int id);
}
