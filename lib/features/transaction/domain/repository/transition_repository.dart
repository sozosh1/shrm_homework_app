import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart'
    as data_transaction;
import 'package:shrm_homework_app/features/transaction/domain/models/transaction/transaction.dart';

abstract class TransitionRepository {
  Future<Transaction> getTransition(int id);

  Future<Transaction> createTransaction(
    data_transaction.TransactionRequest request,
  );

  Future<Transaction> updateTransaction(
    int id,
    data_transaction.TransactionRequest request,
  );

  Future<void> deleteTransaction(int id);
}
