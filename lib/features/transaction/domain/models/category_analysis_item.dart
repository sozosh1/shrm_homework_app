import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';

import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';

part 'category_analysis_item.freezed.dart';

@freezed
abstract class CategoryAnalysisItem with _$CategoryAnalysisItem {
  const factory CategoryAnalysisItem({
    required Category category,
    required double totalAmount,
    required TransactionResponse lastTransaction,
    required double percentage,
    required List<TransactionResponse> transactions,
  }) = _CategoryAnalysisItem;
}