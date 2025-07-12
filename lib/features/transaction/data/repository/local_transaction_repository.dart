import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

@injectable
class LocalTransactionRepository {
  final AppDatabase _database;

  LocalTransactionRepository(this._database);

  Future<Transaction> createTransaction(TransactionRequest request) async {
    final now = DateTime.now();

    final id = await _database
        .into(_database.transactionsTable)
        .insert(
          TransactionsTableCompanion.insert(
            accountId: request.accountId,
            amount: request.amount,
            categoryId: request.categoryId,
            comment: Value(request.comment),
            transactionDate: request.transactionDate,
            createdAt: now,
            updatedAt: now,
          ),
        );
    return Transaction(
      id: id,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment ?? '',
      createdAt: now,
      updatedAt: now,
    );
  }

  Future<void> deleteTransaction(int id) async {
    await (_database.delete(_database.transactionsTable)
      ..where((t) => t.id.equals(id))).go();
  }

  Future<List<TransactionResponse>> getAllTransactions() async {
    final query = _database.select(_database.transactionsTable).join([
      innerJoin(
        _database.accountsTable,
        _database.accountsTable.id.equalsExp(
          _database.transactionsTable.accountId,
        ),
      ),
      innerJoin(
        _database.categoriesTable,
        _database.categoriesTable.id.equalsExp(
          _database.transactionsTable.categoryId,
        ),
      ),
    ]);

    final results = await query.get();

    return results.map((row) {
      final transaction = row.readTable(_database.transactionsTable);
      final account = row.readTable(_database.accountsTable);
      final category = row.readTable(_database.categoriesTable);

      return TransactionResponse(
        id: transaction.id,
        account: AccountBrief(
          id: account.id,
          name: account.name,
          balance: account.balance,
          currency: account.currency,
        ),
        category: Category(
          id: category.id,
          name: category.name,
          emoji: category.emoji,
          isIncome: category.isIncome,
        ),
        amount: transaction.amount,
        transactionDate: transaction.transactionDate,
        createdAt: transaction.createdAt,
        updatedAt: transaction.updatedAt,
        comment: transaction.comment,
      );
    }).toList();
  }

  Future<TransactionResponse> getTransaction(int id) async {
    final query = _database.select(_database.transactionsTable).join([
      innerJoin(
        _database.accountsTable,
        _database.accountsTable.id.equalsExp(
          _database.transactionsTable.accountId,
        ),
      ),
      innerJoin(
        _database.categoriesTable,
        _database.categoriesTable.id.equalsExp(
          _database.transactionsTable.categoryId,
        ),
      ),
    ])..where(_database.transactionsTable.id.equals(id));

    final rows = await query.get();
    
    if (rows.isEmpty) {
      throw Exception('Транзакция с ID $id не найдена');
    }
    
    final row = rows.first;

    final transaction = row.readTable(_database.transactionsTable);
    final account = row.readTable(_database.accountsTable);
    final category = row.readTable(_database.categoriesTable);

    return TransactionResponse(
      id: transaction.id,
      account: AccountBrief(
        id: account.id,
        name: account.name,
        balance: account.balance,
        currency: account.currency,
      ),
      category: Category(
        id: category.id,
        name: category.name,
        emoji: category.emoji,
        isIncome: category.isIncome,
      ),
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.updatedAt,
    );
  }

  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    final now = DateTime.now();

    await (_database.update(_database.transactionsTable)
      ..where((t) => t.id.equals(id))).write(
      TransactionsTableCompanion(
        accountId: Value(request.accountId),
        amount: Value(request.amount),
        categoryId: Value(request.categoryId),
        comment: Value(request.comment ?? ''),
        transactionDate: Value(request.transactionDate),
        updatedAt: Value(now), 
      ),
    );

    return await getTransaction(id);
  }
}
