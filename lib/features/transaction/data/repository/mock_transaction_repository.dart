import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';
@Named('mock')
//@Injectable(as: TransactionRepository)
class MockTransitionRepository implements TransactionRepository {
  @override
  Future<List<TransactionResponse>> getAllTransactions() async {
    return [
      TransactionResponse(
        id: 1,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(id: 1, name: 'Salary', emoji: '💰', isIncome: true),
        amount: 500.00,
        transactionDate: DateTime.parse('2025-06-16T21:59:14.677Z'),
        createdAt: DateTime.parse('2025-06-16T21:59:14.677Z'),
        updatedAt: DateTime.parse('2025-06-16T21:59:14.677Z'),
        comment: 'Monthly salary',
      ),
      TransactionResponse(
        id: 2,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 2,
          name: 'Groceries',
          emoji: '🛒',
          isIncome: false,
        ),
        amount: 75.50,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Weekly groceries',
      ),
      TransactionResponse(
        id: 3,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 3,
          name: 'Freelance',
          emoji: '💻',
          isIncome: true,
        ),
        amount: 1200.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Freelance project payment',
      ),
      TransactionResponse(
        id: 4,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 4,
          name: 'Utilities',
          emoji: '💡',
          isIncome: false,
        ),
        amount: 150.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Electricity bill',
      ),
      TransactionResponse(
        id: 5,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(id: 5, name: 'Bonus', emoji: '🎁', isIncome: true),
        amount: 300.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Yearly bonus',
      ),
      TransactionResponse(
        id: 6,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 2,
          name: 'Groceries',
          emoji: '🛒',
          isIncome: false,
        ),
        amount: 45.20,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Morning groceries',
      ),
      TransactionResponse(
        id: 7,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 4,
          name: 'Utilities',
          emoji: '💡',
          isIncome: false,
        ),
        amount: 30.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Internet payment',
      ),
      TransactionResponse(
        id: 8,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(id: 1, name: 'Salary', emoji: '💰', isIncome: true),
        amount: 200.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Bonus payment',
      ),
      TransactionResponse(
        id: 9,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(
          id: 3,
          name: 'Freelance',
          emoji: '💻',
          isIncome: true,
        ),
        amount: 150.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Quick freelance task',
      ),
      TransactionResponse(
        id: 10,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(id: 5, name: 'Bonus', emoji: '🎁', isIncome: true),
        amount: 100.00,
        transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
        createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
        comment: 'Small reward',
      ),
      TransactionResponse(
        id: 11,
        account: AccountBrief(
          id: 1,
          name: 'Main Account',
          balance: 1000.00,
          currency: 'RUB',
        ),
        category: Category(id: 5, name: 'Bonus', emoji: '🎁', isIncome: true),
        amount: 100.00,
        transactionDate: DateTime.now(),
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
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
  Future<TransactionResponse> createTransaction(TransactionRequest request) async {
    return TransactionResponse(
      id: (await getAllTransactions()).length + 1,
      account: AccountBrief(
        id: request.accountId,
        name: 'main account',
        balance: 1000.00,
        currency: 'RUB',
      ),
      category: Category(
        id: request.categoryId,
        name: 'salary',
        emoji: '💰',
        isIncome: true,
      ),
      amount: request.amount,
      transactionDate: request.transactionDate,
      comment: request.comment ?? '',
      createdAt: DateTime.parse("2025-04-12T11:35:00Z"),
      updatedAt: DateTime.parse("2025-06-12T11:35:00Z"),
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
        balance: 1000.00,
        currency: 'RUB',
      ),
      category: Category(
        id: request.categoryId,
        name: 'salary',
        emoji: '💰',
        isIncome: true,
      ),
      amount: 500.00,
      transactionDate: DateTime.parse('2025-06-18T15:45:00.000Z'),
      createdAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
      updatedAt: DateTime.parse('2025-06-18T15:45:00.000Z'),
      comment: 'month salary',
    );
  }

  @override
  Future<void> deleteTransaction(int id) async {
    final transactions = await getAllTransactions();
    transactions.removeWhere((t) => t.id == id);
  }
  
  @override
  Future<List<TransactionResponse>> getTransactionsByPeriod(int accountId, {DateTime? startDate, DateTime? endDate}) {
    // TODO: implement getTransactionsByPeriod
    throw UnimplementedError();
  }
}
