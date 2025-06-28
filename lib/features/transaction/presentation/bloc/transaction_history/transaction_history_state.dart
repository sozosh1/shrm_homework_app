import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';
part 'transaction_history_state.freezed.dart';

@freezed
class TransactionHistoryState with _$TransactionHistoryState {
  const factory TransactionHistoryState.initial() = TransactionHistoryInitial;

  const factory TransactionHistoryState.loading() = TransactionHistoryLoading;

  const factory TransactionHistoryState.loaded({
    required List<TransactionResponse> transactions,
    required double totalAmount,
    required bool isIncome,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
    required String sortBy,
  }) = TransactionHistoryLoaded;

  const factory TransactionHistoryState.analysisLoaded({
    required List<CategoryAnalysisItem> analysisItems,
    required double totalAmount,
    required bool isIncome,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
  }) = TransactionAnalysisLoaded;

  const factory TransactionHistoryState.error({required String message}) =
      TransactionHistoryError;
}