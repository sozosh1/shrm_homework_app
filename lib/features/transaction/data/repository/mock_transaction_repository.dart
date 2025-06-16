import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

class MockTransitionRepository implements TransitionRepository {
  @override
  Future<TransactionResponse> getTransition(int id) async {
    return TransactionResponse(
      id: id,
      account: AccountBrief(
        id: 1,
        name: 'main account',
        balance: '1000.00',
        currency: 'RUB',
      ),
      category: Category(id: 1, name: 'salary', emodji: '💰', isIncome: true),
      amount: '500',
      transactionDate: '2025-06-16T21:59:14.677Z',
      createdAt: '2025-06-16T21:59:14.677Z',
      updatedAt: '2025-06-16T21:59:14.677Z',
      comment: 'month salary',
    );
  }

  @override
  Future<Transaction> createTransaction(TransactionRequest request) async {
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
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    return TransactionResponse(
      id: 1,
      account: AccountBrief(
        id: request.accountId,
        name: 'main account',
        balance: '1000.00',
        currency: 'RUB',
      ),
      category: Category(
        id: request.categoryId,
        name: 'salary',
        emodji: '💰',
        isIncome: true,
      ),
      amount: '500.00',
      transactionDate: '2025-06-16T21:59:14.677Z',
      createdAt: '2025-06-16T21:59:14.677Z',
      updatedAt: '2025-06-16T21:59:14.677Z',
      comment: 'month salary',
    );
  }

  @override
  Future<List<TransactionResponse>> getAllTransactions() async {
    return [
      TransactionResponse(
        id: 1,
        account: AccountBrief(
          id: 1,
          name: 'main account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(id: 1, name: 'salary', emodji: '💰', isIncome: true),
        amount: '500',
        transactionDate: '2025-06-16T21:59:14.677Z',
        createdAt: '2025-06-16T21:59:14.677Z',
        updatedAt: '2025-06-16T21:59:14.677Z',
        comment: 'month salary',
      ),
    ];
  }

  @override
  Future<void> deleteTransaction(int id) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == id);
  }

 
  }

