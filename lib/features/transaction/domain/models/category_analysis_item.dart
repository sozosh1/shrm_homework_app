import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

class CategoryAnalysisItem {
  final Category category;
  final double totalAmount;
  final TransactionResponse? lastTransaction;
  final int transactionCount;

  CategoryAnalysisItem({
    required this.category,
    required this.totalAmount,
    required this.lastTransaction,
    required this.transactionCount,
  });
}
