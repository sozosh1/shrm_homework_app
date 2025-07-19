import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

import 'package:talker_flutter/talker_flutter.dart';
import 'package:shrm_homework_app/features/account/data/datasources/local_account_data_source.dart';
import 'package:shrm_homework_app/features/category/data/datasources/local_category_data_source.dart';

abstract class LocalTransactionDataSource {
  Future<TransactionResponse> getTransaction(int id);
  Future<TransactionResponse> createTransaction(TransactionRequest request);
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  );
  Future<void> deleteTransaction(int id);

  Future<void> saveTransactions(List<TransactionResponse> transactions);
  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  });
}

@LazySingleton(as: LocalTransactionDataSource)
class LocalTransactionDataSourceImpl implements LocalTransactionDataSource {
  final AppDatabase _database;
  final Talker _talker;
  final LocalAccountDataSource _accountDS;
  final LocalCategoryDataSource _categoryDS;

  LocalTransactionDataSourceImpl(
    this._database,
    this._talker,
    this._accountDS,
    this._categoryDS,
  );

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    try {
      final data =
          await (_database.select(_database.transactionsTable)
            ..where((t) => t.id.equals(id))).getSingle();
      final accountResponse = await _accountDS.getAccount(data.accountId);
      final account = AccountBrief(
        id: accountResponse.id,
        name: accountResponse.name,
        balance: accountResponse.balance,
        currency: accountResponse.currency,
      );
      final categories = await _categoryDS.getCategories();
      final category = categories.firstWhere(
        (c) => c.id == data.categoryId,
        orElse:
            () => Category(
              id: data.categoryId,
              name: 'Unknown',
              emoji: '',
              isIncome: false,
            ),
      );
      return TransactionResponse(
        id: data.id,
        account: account,
        category: category,
        amount: data.amount,
        transactionDate: data.transactionDate,
        comment: data.comment,
        createdAt: data.createdAt,
        updatedAt: data.updatedAt,
      );
    } catch (e, stackTrace) {
      _talker.error('Failed to get transaction from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> createTransaction(
    TransactionRequest request,
  ) async {
    try {
      final now = DateTime.now();
      final id = now.millisecondsSinceEpoch;
      await _database
          .into(_database.transactionsTable)
          .insert(
            TransactionsTableCompanion.insert(
              id: Value(id),
              accountId: request.accountId,
              categoryId: request.categoryId,
              amount: request.amount,
              transactionDate: request.transactionDate,
              comment: Value(request.comment),
              createdAt: now,
              updatedAt: now,
            ),
          );
      final accountResponse = await _accountDS.getAccount(request.accountId);
      final account = AccountBrief(
        id: accountResponse.id,
        name: accountResponse.name,
        balance: accountResponse.balance,
        currency: accountResponse.currency,
      );
      final categories = await _categoryDS.getCategories();
      final category = categories.firstWhere(
        (c) => c.id == request.categoryId,
        orElse:
            () => Category(
              id: request.categoryId,
              name: 'Unknown',
              emoji: '',
              isIncome: false,
            ),
      );
      return TransactionResponse(
        id: id,
        account: account,
        category: category,
        amount: request.amount,
        transactionDate: request.transactionDate,
        comment: request.comment,
        createdAt: now,
        updatedAt: now,
      );
    } catch (e, stackTrace) {
      _talker.error('Failed to create transaction in local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    try {
      final now = DateTime.now();
      await (_database.update(_database.transactionsTable)
        ..where((t) => t.id.equals(id))).write(
        TransactionsTableCompanion(
          accountId: Value(request.accountId),
          categoryId: Value(request.categoryId),
          amount: Value(request.amount),
          transactionDate: Value(request.transactionDate),
          comment: Value(request.comment),
          updatedAt: Value(now),
        ),
      );
      return getTransaction(id);
    } catch (e, stackTrace) {
      _talker.error('Failed to update transaction in local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      await (_database.delete(_database.transactionsTable)
        ..where((t) => t.id.equals(id))).go();
    } catch (e, stackTrace) {
      _talker.error(
        'Failed to delete transaction from local DB',
        e,
        stackTrace,
      );
      rethrow;
    }
  }

  @override
  Future<void> saveTransactions(List<TransactionResponse> transactions) async {
    await _database.transaction(() async {
      for (final t in transactions) {
        await _database
            .into(_database.transactionsTable)
            .insertOnConflictUpdate(
              TransactionsTableCompanion.insert(
                id: Value(t.id),
                accountId: t.account.id,
                categoryId: t.category.id,
                amount: t.amount,
                transactionDate: t.transactionDate,
                comment: Value(t.comment),
                createdAt: t.createdAt,
                updatedAt: t.updatedAt,
              ),
            );
      }
    });
  }

  @override
  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final query = _database.select(_database.transactionsTable)
        ..where((t) => t.accountId.equals(accountId));

      if (startDate != null) {
        query.where((t) => t.transactionDate.isBiggerOrEqualValue(startDate));
      }
      if (endDate != null) {
        query.where((t) => t.transactionDate.isSmallerOrEqualValue(endDate));
      }

      final data = await query.get();
      final categories = await _categoryDS.getCategories();
      final categoryMap = {for (var c in categories) c.id: c};
      final accountResponse = await _accountDS.getAccount(accountId);
      final account = AccountBrief(
        id: accountResponse.id,
        name: accountResponse.name,
        balance: accountResponse.balance,
        currency: accountResponse.currency,
      );

      return data
          .map(
            (d) => TransactionResponse(
              id: d.id,
              account: account,
              category:
                  categoryMap[d.categoryId] ??
                  Category(
                    id: d.categoryId,
                    name: 'Unknown',
                    emoji: '',
                    isIncome: false,
                  ),
              amount: d.amount,
              transactionDate: d.transactionDate,
              comment: d.comment,
              createdAt: d.createdAt,
              updatedAt: d.updatedAt,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      _talker.error(
        'Failed to get transactions by period from local DB',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
