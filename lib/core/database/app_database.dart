import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';
import 'package:sqlite3/sqlite3.dart';
import 'package:talker_flutter/talker_flutter.dart';

import 'tables/accounts_table.dart';
import 'tables/categories_table.dart';
import 'tables/sync_events_table.dart';
import 'tables/transactions_table.dart';


part 'app_database.g.dart';

@DriftDatabase(tables: [AccountsTable, CategoriesTable, TransactionsTable, SyncEventsTable, ])
@singleton
class AppDatabase extends _$AppDatabase with ChangeNotifier {
  final Talker _talker;

  AppDatabase(this._talker) : super(_openConnection(_talker));

  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        await m.createAll();
      },
    );
  }

  // Категории
  Future<List<CategoriesTableData>> getAllCategories() async {
    try {
      return await select(categoriesTable).get();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch categories', e, stackTrace);
      rethrow;
    }
  }

  Future<List<CategoriesTableData>> getCategoriesByType(bool isIncome) async {
    try {
      final query = select(categoriesTable)
        ..where((t) => t.isIncome.equals(isIncome));
      return await query.get();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch categories by type', e, stackTrace);
      rethrow;
    }
  }

  // Счета (только получение информации и обновление)
  Future<AccountsTableData> getAccountById(int id) async {
    try {
      final query = select(accountsTable)..where((t) => t.id.equals(id));
      return await query.getSingle();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch account by id', e, stackTrace);
      rethrow;
    }
  }

  Future<AccountsTableData> updateAccount({
    required int id,
    required String name,
    required double balance,
    required String currency,
  }) async {
    try {
      final companion = AccountsTableCompanion(
        name: Value(name),
        balance: Value(balance),
        currency: Value(currency),
        updatedAt: Value(DateTime.now()),
      );

      await (update(accountsTable)
        ..where((t) => t.id.equals(id))).write(companion);
      return await getAccountById(id);
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to update account', e, stackTrace);
      rethrow;
    }
  }

  // Транзакции
  Future<TransactionsTableData> createTransaction({
    required int accountId,
    required int categoryId,
    required double amount,
    required String comment,
    DateTime? transactionDate,
  }) async {
    try {
      final transaction = await into(transactionsTable).insertReturning(
        TransactionsTableCompanion.insert(
          accountId: accountId,
          categoryId: categoryId,
          amount: amount,
          comment: Value(comment),
          transactionDate: transactionDate ?? DateTime.now(),
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      notifyListeners();
      return transaction;
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to create transaction', e, stackTrace);
      rethrow;
    }
  }

  Future<List<TransactionsTableData>> getAllTransactions() async {
    try {
      return await select(transactionsTable).get();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch transactions', e, stackTrace);
      rethrow;
    }
  }

  Future<TransactionsTableData> getTransactionById(int id) async {
    try {
      final query = select(transactionsTable)..where((t) => t.id.equals(id));
      return await query.getSingle();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to fetch transaction by id', e, stackTrace);
      rethrow;
    }
  }

  Future<TransactionsTableData> updateTransaction({
    required int id,
    required int accountId,
    required int categoryId,
    required double amount,
    required DateTime transactionDate,
    required String comment,
  }) async {
    try {
      final companion = TransactionsTableCompanion(
        accountId: Value(accountId),
        categoryId: Value(categoryId),
        amount: Value(amount),
        transactionDate: Value(transactionDate),
        comment: Value(comment),
        updatedAt: Value(DateTime.now()),
      );

      await (update(transactionsTable)
        ..where((t) => t.id.equals(id))).write(companion);
      return await getTransactionById(id);
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to update transaction', e, stackTrace);
      rethrow;
    }
  }

  Future<void> deleteTransaction(int id) async {
    try {
      await (delete(transactionsTable)..where((t) => t.id.equals(id))).go();
      notifyListeners();
    } catch (e, stackTrace) {
      _talker.error('❌ Failed to delete transaction', e, stackTrace);
      rethrow;
    }
  }

  Future<List<TransactionsTableData>> getTransactionsByAccountAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      var query = select(transactionsTable)
        ..where((t) => t.accountId.equals(accountId));

      if (startDate != null) {
        query =
            query
              ..where((t) => t.transactionDate.isBiggerOrEqualValue(startDate));
      }

      if (endDate != null) {
        query =
            query
              ..where((t) => t.transactionDate.isSmallerOrEqualValue(endDate));
      }

      return await query.get();
    } catch (e, stackTrace) {
      _talker.error(
        '❌ Failed to fetch transactions by account and period',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  static LazyDatabase _openConnection(Talker talker) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'app_database.db'));

      if (Platform.isAndroid) {
        await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
      }
      final cachebase = (await getTemporaryDirectory()).path;
      sqlite3.tempDirectory = cachebase;

      return NativeDatabase.createInBackground(file);
    });
  }
}
