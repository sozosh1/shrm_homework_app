import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/data/models/stat_item/stat_item.dart';
import 'package:shrm_homework_app/features/account/domain/models/account/account.dart';
import 'package:shrm_homework_app/features/account/domain/repository/account_repository.dart';

@Injectable(as: AccountRepository)
class LocalAccountRepository implements AccountRepository {
  // Использование константы для единственного аккаунта, согласно требованию.
  static const _accountId = 1;
  final AppDatabase _database;

  LocalAccountRepository(this._database);

  @override
  Future<AccountResponse> getAccount(int id) async {
    // Примечание: параметр 'id' игнорируется, всегда используется _accountId.
    final account = await _getAccountInternal();
    final stats = await _getAccountStats();
    
    return AccountResponse(
      id: account.id,
      name: account.name,
      balance: account.balance,
      currency: account.currency,
      incomeStats: stats.incomeStats,
      expenseStats: stats.expenseStats,
      createdAt: account.createdAt,
      updatedAt: account.updatedAt,
    );
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    // Примечание: параметр 'id' игнорируется, всегда используется _accountId.
    await (_database.update(_database.accountsTable)
      ..where((t) => t.id.equals(_accountId))).write(
      AccountsTableCompanion(
        name: Value(request.name),
        balance: Value(request.balance),
        currency: Value(request.currency),
        updatedAt: Value(DateTime.now()),
      ),
    );

    return _getAccountInternal();
  }

  Future<Account> _getAccountInternal() async {
    final data =
        await (_database.select(_database.accountsTable)
          ..where((t) => t.id.equals(_accountId))).getSingle();
    return Account(
      id: data.id,
      userId: 1,
      name: data.name,
      balance: data.balance,
      currency: data.currency,
      createdAt: data.createdAt,
      updatedAt: data.updatedAt, // ИСПРАВЛЕНО: было data.createdAt
    );
  }

  Future<({List<StatItem> incomeStats, List<StatItem> expenseStats})>
  _getAccountStats() async {
    final transactions =
        await (_database.select(_database.transactionsTable)
          ..where((t) => t.accountId.equals(_accountId))).get();

    final categories = await _database.select(_database.categoriesTable).get();
    // Для быстрого доступа к категориям по их ID без поиска в списке
    final categoriesMap = {for (var c in categories) c.id: c};

    final incomeStats = <StatItem>[];
    final expenseStats = <StatItem>[];

    final statsMap = <int, double>{};

    for (final t in transactions) {
      final category = categoriesMap[t.categoryId];
      if (category == null) continue;

      statsMap.update(
        category.id,
        (value) => value + t.amount,
        ifAbsent: () => t.amount,
      );
    }

    for (final e in statsMap.entries) {
      final category = categoriesMap[e.key]!;
      final stat = StatItem(
        categoryId: category.id,
        categoryName: category.name,
        emoji: category.emodji,
        amount: e.value,
      );

      if (category.isIncome) {
        incomeStats.add(stat);
      } else {
        expenseStats.add(stat);
      }
    }
    return (incomeStats: incomeStats, expenseStats: expenseStats);
  }
}
