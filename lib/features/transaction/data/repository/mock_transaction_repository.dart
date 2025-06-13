import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart'
    as data_transaction;
import 'package:shrm_homework_app/features/transaction/domain/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transition_repository.dart';

class MockTransitionRepository implements TransitionRepository {
  @override
  Future<Transaction> getTransition(int id) async {
    return Transaction(
      id: id,
      accountId: 1,
      categoryId: 1,
      amount: '500.00',
      transactionDate: "2025-06-12T11:35:00Z",
      comment: 'salary alo business dada dengi',
     
      createdAt: "2025-04-12T11:35:00Z",
      updatedAt: "2025-06-12T11:35:00Z",
    );
  }

  @override
  Future<Transaction> createTransaction(
    data_transaction.TransactionRequest request,
  ) async {
    return Transaction(
      id: 1,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment ?? '',
      createdAt: "2025-04-12T11:35:00Z",
      updatedAt: "2025-06-12T11:35:00Z",
    );
  }

  @override
  Future<Transaction> updateTransaction(
    int id,
    data_transaction.TransactionRequest request,
  ) async {
    return Transaction(
      id: id,
      accountId: request.accountId,
      categoryId: request.categoryId,
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment ?? '',
      createdAt: "2025-04-12T11:35:00Z",
      updatedAt: "2025-06-12T11:35:00Z",
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {}
}
