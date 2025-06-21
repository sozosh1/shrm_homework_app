import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

@Injectable(as: TransactionRepository)
class MockTransitionRepository implements TransactionRepository {
  @override
  Future<List<TransactionResponse>> getAllTransactions() async {
    return [
      TransactionResponse(
        id: 1,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(id: 1, name: 'Salary', emodji: '💰', isIncome: true),
        amount: '500.00',
        transactionDate: '2025-06-16T21:59:14.677Z',
        createdAt: '2025-06-16T21:59:14.677Z',
        updatedAt: '2025-06-16T21:59:14.677Z',
        comment: 'Monthly salary',
      ),
      TransactionResponse(
        id: 2,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 2,
          name: 'Groceries',
          emodji: '🛒',
          isIncome: false,
        ),
        amount: '75.50',
        transactionDate: '2025-06-17T10:30:00.000Z',
        createdAt: '2025-06-17T10:30:00.000Z',
        updatedAt: '2025-06-17T10:30:00.000Z',
        comment: 'Weekly groceries',
      ),
      TransactionResponse(
        id: 3,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 3,
          name: 'Freelance',
          emodji: '💻',
          isIncome: true,
        ),
        amount: '1200.00',
        transactionDate: '2025-06-18T15:45:00.000Z',
        createdAt: '2025-06-18T15:45:00.000Z',
        updatedAt: '2025-06-18T15:45:00.000Z',
        comment: 'Freelance project payment',
      ),
      TransactionResponse(
        id: 4,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 4,
          name: 'Utilities',
          emodji: '💡',
          isIncome: false,
        ),
        amount: '150.00',
        transactionDate: '2025-06-15T09:00:00.000Z',
        createdAt: '2025-06-15T09:00:00.000Z',
        updatedAt: '2025-06-15T09:00:00.000Z',
        comment: 'Electricity bill',
      ),
      TransactionResponse(
        id: 5,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(id: 5, name: 'Bonus', emodji: '🎁', isIncome: true),
        amount: '300.00',
        transactionDate: '2025-06-18T08:00:00.000Z',
        createdAt: '2025-06-18T08:00:00.000Z',
        updatedAt: '2025-06-18T08:00:00.000Z',
        comment: 'Yearly bonus',
      ),
      TransactionResponse(
        id: 6,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 2,
          name: 'Groceries',
          emodji: '🛒',
          isIncome: false,
        ),
        amount: '45.20',
        transactionDate: '2025-06-21T15:47:00.000Z',
        createdAt: '2025-06-20T15:47:00.000Z',
        updatedAt: '2025-06-20T15:47:00.000Z',
        comment: 'Morning groceries',
      ),
      TransactionResponse(
        id: 7,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 4,
          name: 'Utilities',
          emodji: '💡',
          isIncome: false,
        ),
        amount: '30.00',
        transactionDate: '2025-06-21T15:47:00.000Z',
        createdAt: '2025-06-20T15:47:00.000Z',
        updatedAt: '2025-06-20T15:47:00.000Z',
        comment: 'Internet payment',
      ),
      TransactionResponse(
        id: 8,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(id: 1, name: 'Salary', emodji: '💰', isIncome: true),
        amount: '200.00',
        transactionDate: '2025-06-21T15:47:00.000Z',
        createdAt: '2025-06-20T15:47:00.000Z',
        updatedAt: '2025-06-20T15:47:00.000Z',
        comment: 'Bonus payment',
      ),
      TransactionResponse(
        id: 9,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(
          id: 3,
          name: 'Freelance',
          emodji: '💻',
          isIncome: true,
        ),
        amount: '150.00',
        transactionDate: '2025-06-21T15:47:00.000Z',
        createdAt: '2025-06-20T15:47:00.000Z',
        updatedAt: '2025-06-20T15:47:00.000Z',
        comment: 'Quick freelance task',
      ),
      TransactionResponse(
        id: 10,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: '1000.00',
          currency: 'RUB',
        ),
        category: Category(id: 5, name: 'Bonus', emodji: '🎁', isIncome: true),
        amount: '100.00',
        transactionDate: '2025-06-21T15:47:00.000Z',
        createdAt: '2025-06-2T15:47:00.000Z',
        updatedAt: '2025-06-20T15:47:00.000Z',
        comment: 'Small reward',
      ),
    ];
  }

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    final transactions = await getAllTransactions();
    final transaction = transactions.firstWhere(
      (t) => t.id == id,
      orElse: () => throw Exception('Transaction with id $id not found'),
    );
    return transaction;
  }

  @override
  Future<Transaction> createTransaction(TransactionRequest request) async {
    return Transaction(
      id: (await getAllTransactions()).length + 1,
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
      id: id,
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
  Future<void> deleteTransaction(int id) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == id);
  }
}
