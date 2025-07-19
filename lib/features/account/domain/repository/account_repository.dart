import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/data/models/account/account.dart';

abstract class AccountRepository {
  Future<AccountResponse> getAccount(int id);
  Future<Account> updateAccount(int id, AccountUpdateRequest request);
}
