import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

@Injectable(as: TransactionRepository)
class LocalTransactionRepository implements TransactionRepository {
  final AppDatabase _database;

  LocalTransactionRepository(this._database);

  @override
  Future<Transaction> createTransaction(TransactionRequest request) async {
    final now = DateTime.now();

    final id = await _database
        .into(_database.transactionsTable)
        .insert(
          TransactionsTableCompanion.insert(
            accountId: request.accountId,
            amount: request.amount,
            categoryId: request.categoryId,
            comment: request.comment ?? '',
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

  @override
  Future<void> deleteTransaction(int id) async {
    await (_database.delete(_database.transactionsTable)
      ..where((t) => t.id.equals(id))).go();
  }

  @override
  Future<List<TransactionResponse>> getAllTransactions() async {
    final transactions =
        await _database.select(_database.transactionsTable).get();
    final List<TransactionResponse> result = [];

    for (final transaction in transactions) {
      final account =
          await (_database.select(_database.accountsTable)
            ..where((t) => t.id.equals(transaction.accountId))).getSingle();
      final category =
          await (_database.select(_database.categoriesTable)
            ..where((t) => t.id.equals(transaction.categoryId))).getSingle();

      result.add(
        TransactionResponse(
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
            emodji: category.emodji,
            isIncome: category.isIncome,
          ),
          amount: transaction.amount,
          transactionDate: transaction.transactionDate,
          createdAt: transaction.createdAt,
          updatedAt: transaction.createdAt,
        ),
      );
    }
    return result;
  }

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    final transaction =
        await (_database.select(_database.transactionsTable)
          ..where((t) => t.id.equals(id))).getSingle();

    final account =
        await (_database.select(_database.accountsTable)
          ..where((t) => t.id.equals(transaction.accountId))).getSingle();

    final category =
        await (_database.select(_database.categoriesTable)
          ..where((t) => t.id.equals(transaction.categoryId))).getSingle();

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
        emodji: category.emodji,
        isIncome: category.isIncome,
      ),
      amount: transaction.amount,
      transactionDate: transaction.transactionDate,
      createdAt: transaction.createdAt,
      updatedAt: transaction.createdAt,
    );
  }

  @override
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
        createdAt: Value(now),
        updatedAt: Value(now),
      ),
    );

    return await getTransaction(id);
  }
}
