import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/data/models/account/account.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:shrm_homework_app/features/account/data/models/stat_item/stat_item.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class LocalAccountDataSource {
  Future<AccountResponse> getAccount(int id);
  Future<Account> updateAccount(int id, AccountUpdateRequest request);
  Future<void> saveAccountResponse(AccountResponse response);
}

@LazySingleton(as: LocalAccountDataSource)
class LocalAccountDataSourceImpl extends LocalAccountDataSource {
  final AppDatabase _database;
  final Talker _talker;

  LocalAccountDataSourceImpl(this._database, this._talker);

  @override
  Future<AccountResponse> getAccount(int id) async {
    try {
      final account = await _getAccountFromDb(id);
      final stats = await _calculateStats(id);

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
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to get account from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveAccountResponse(AccountResponse response) async {
    await _database.transaction(() async {
      await _database
          .into(_database.accountsTable)
          .insertOnConflictUpdate(
            AccountsTableCompanion.insert(
              id: Value(response.id),
              name: response.name,
              balance: response.balance,
              currency: Value(response.currency),
              createdAt: response.createdAt,
              updatedAt: response.updatedAt,
            ),
          );
    });

    for (final stat in response.incomeStats) {
      await _saveCategory(stat, true);
    }
    for (final stat in response.expenseStats) {
      await _saveCategory(stat, false);
    }
  }

  @override
  Future<Account> updateAccount(int id, AccountUpdateRequest request) async {
    try {
      await (_database.update(_database.accountsTable)
        ..where((t) => t.id.equals(id))).write(
        AccountsTableCompanion(
          name: Value(request.name),
          balance: Value(request.balance),
          currency: Value(request.currency),
          updatedAt: Value(DateTime.now()),
        ),
      );

      return _getAccountFromDb(id);
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to update account in local DB', e, stackTrace);
      rethrow;
    }
  }

  Future<void> _saveCategory(StatItem stat, bool isIncome) async {
    await _database
        .into(_database.categoriesTable)
        .insertOnConflictUpdate(
          CategoriesTableCompanion.insert(
            id: Value(stat.categoryId),
            name: stat.categoryName,
            emoji: stat.emoji,
            isIncome: isIncome,
          ),
        );
  }

  Future<Account> _getAccountFromDb(int id) async {
    try {
      final data =
          await (_database.select(_database.accountsTable)
            ..where((t) => t.id.equals(id))).getSingle();
      return Account(
        id: data.id,
        userId: 1,
        name: data.name,
        balance: data.balance,
        currency: data.currency,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    } catch (e) {
      // If no account is found, create a default one.
      final defaultAccount = AccountsTableCompanion.insert(
        id: Value(id),
        name: 'Default Account',
        balance: 0.0,
        currency: Value('USD'),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await _database.into(_database.accountsTable).insert(defaultAccount);
      final data =
          await (_database.select(_database.accountsTable)
            ..where((t) => t.id.equals(id))).getSingle();
      return Account(
        id: data.id,
        userId: 1,
        name: data.name,
        balance: data.balance,
        currency: data.currency,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    }
  }

  Future<({List<StatItem> incomeStats, List<StatItem> expenseStats})>
  _calculateStats(int accountId) async {
    final transactions =
        await (_database.select(_database.transactionsTable)
          ..where((t) => t.accountId.equals(accountId))).get();

    final categories = await _database.select(_database.categoriesTable).get();
    final categoryMap = {for (var c in categories) c.id: c};

    final incomeStats = <StatItem>[];
    final expenseStats = <StatItem>[];

    final statsMap = <int, double>{};

    for (final t in transactions) {
      final category = categoryMap[t.categoryId];
      if (category == null) continue;

      statsMap.update(
        t.categoryId,
        (sum) => sum + t.amount,
        ifAbsent: () => t.amount,
      );
    }

    for (final entry in statsMap.entries) {
      final category = categoryMap[entry.key]!;
      final stat = StatItem(
        categoryId: category.id,
        categoryName: category.name,
        emoji: category.emoji,
        amount: entry.value,
      );

      if (category.isIncome) {
        incomeStats.add(stat);
      } else {
        expenseStats.add(stat);
      }
    }

    incomeStats.sort((a, b) => b.amount.compareTo(a.amount));
    expenseStats.sort((a, b) => b.amount.compareTo(a.amount));

    return (incomeStats: incomeStats, expenseStats: expenseStats);
  }
}
