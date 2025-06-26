import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/data/models/account_create_request/account_create_request.dart';
import 'package:shrm_homework_app/features/account/data/models/account_history_response/account_history_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/data/models/stat_item/stat_item.dart';
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_history/account_history.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_state/account_state.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';

@Injectable(as: AccountRepository)
class MockAccountRepository implements AccountRepository {


  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    return Account(
      id: id,
      userId: 1,
      name: request.name,
      balance: request.balance,
      currency: request.currency,
      createdAt: DateTime.parse('2025-06-16T21:58:48.372Z'),
      updatedAt: DateTime.parse('2025-06-16T21:58:48.372Z'),
    );
  }

  @override
  Future<AccountResponse> getAccount(int id) async {
    return AccountResponse(
      id: id,
      name: 'Main account',
      balance: 1000.00,
      currency: 'RUB',
      incomeStats: [
        StatItem(
          categoryId: 1,
          categoryName: 'salary',
          emoji: '💰',
          amount: 5000.00,
        ),
      ],
      expenseStats: [
        StatItem(
          categoryId: 1,
          categoryName: 'salary',
          emoji: '💰',
          amount: 5000.00,
        ),
      ],
      createdAt: DateTime.parse('2025-06-16T21:52:33.724Z'),
      updatedAt: DateTime.parse('2025-06-16T21:52:33.724Z'),
    );
  }

 
}
