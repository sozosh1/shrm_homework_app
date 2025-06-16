import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/repository/transaction_repository.dart';

class GetTransactionsByPeriodUseCase {
  final TransitionRepository repository;

  GetTransactionsByPeriodUseCase(this.repository);

  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId,
    String? startDate,
    String? endDate,
  ) async {
    final now = DateTime.now();
    final start =
        startDate != null
            ? DateTime.parse(startDate)
            : DateTime(now.year, now.month - 1, now.day);
    final startOfPeriod = DateTime(start.year, start.month, start.day);

    final end = endDate != null ? DateTime.parse(endDate) : now;

    final endOfPeriod = DateTime(end.year, end.month, end.day, 23, 59, 59, 999);

    final testTransactionDate = DateTime.parse('2025-06-16T21:59:14.677Z');

    if (testTransactionDate.isAfter(startOfPeriod) &&
        testTransactionDate.isBefore(endOfPeriod)) {
      return [
        TransactionResponse(
          id: 1,
          account: AccountBrief(
            id: 1,
            name: 'main account',
            balance: '1000.00',
            currency: 'RUB',
          ),
          category: Category(
            id: 1,
            name: 'salary',
            emodji: '💰',
            isIncome: true,
          ),
          amount: '500',
          transactionDate: '2025-06-16T21:59:14.677Z',
          createdAt: '2025-06-16T21:59:14.677Z',
          updatedAt: '2025-06-16T21:59:14.677Z',
          comment: 'month salary',
        ),
      ];
    }
    return [];
  }
}
