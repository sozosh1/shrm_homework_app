import 'package:shrm_homework_app/features/account/data/models/account_create_request/account_create_request.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/data/models/account_history_response/account_history_response.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart'
    as data_account;
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_history/account_history.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_state/account_state.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';

class MockAccountRepository implements AccountRepository {
  @override
  Future<Account> createAccount(
    data_account.AccountCreateRequest request,
  ) async {
    return Account(
      id: 1,
      userId: 2,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      //! как правильно указывать время?
      createdAt: DateTime.now().toIso8601String(),
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<Account> updateAccount(
    int id,
    data_account.AccountUpdateRequest request,
  ) async {
    return Account(
      id: id,
      userId: 1,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      createdAt: "2025-06-12T11:35:00Z",
      updatedAt: DateTime.now().toIso8601String(),
    );
  }

  @override
  Future<Account> getAccount(int id) async {
    return Account(
      id: id,
      userId: 1,
      name: "Main account",
      balance: '2100.00',
      currency: 'RUB',
      createdAt: '2025-04-12T11:35:00Z',
      updatedAt: '2025-06-12T11:35:00Z',
    );
  }

  @override
  Future<void> deleteAccount(int id) async {
    //! тут же пока никак не реализуешь?
  }

  @override
  Future<data_account.AccountHistoryResponse> getAccountHistory(int id) async {
    return data_account.AccountHistoryResponse(
      accountId: id,
      accountName: 'Main account',
      currency: 'RUB',
      currentBalance: '2100.00',
      history:
      // todo нужно возвращать список истории 
      AccountHistory(
        id: 1,
        accountId: id,
        changeType: 'deposit',
        previousState: AccountState(
          id: id,
          name: "Основной счёт",
          balance: "500.00",
          currency: "RUB",
        ),
        newState: AccountState(
          id: id,
          name: "Основной счёт",
          balance: "2100.00",
          currency: "RUB",
        ),
        changeTimestamp: "2025-06-11T12:00:00Z",
        createdAt: "2025-04-11T12:00:00Z",
      ),
    );
  }
}
