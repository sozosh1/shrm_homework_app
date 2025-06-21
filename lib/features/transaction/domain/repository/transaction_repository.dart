import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';

abstract class TransactionRepository {
  Future<TransactionResponse> getTransaction(int id);

  Future<Transaction> createTransaction(TransactionRequest request);

  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  );

  Future<void> deleteTransaction(int id);

  Future<List<TransactionResponse>> getAllTransactions();
}
