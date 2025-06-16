import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';

import 'package:shrm_homework_app/features/transaction/domain/models/transaction/transaction.dart';

abstract class TransitionRepository {
  Future<Transaction> getTransition(int id);

  Future<Transaction> createTransaction(TransactionRequest request);

  Future<Transaction> updateTransaction(int id, TransactionRequest request);

  Future<void> deleteTransaction(int id);

  Future<List<Transaction>> getAllTransactions();
}
