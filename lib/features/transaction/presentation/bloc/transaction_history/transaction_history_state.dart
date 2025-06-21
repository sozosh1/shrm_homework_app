import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
part 'transaction_history_state.freezed.dart';

@freezed
class TransactionHistoryState with _$TransactionHistoryState {
  const factory TransactionHistoryState.initial() = TransactionHistoryInitial;

  const factory TransactionHistoryState.loading() = TransactionHistoryLoading;

  const factory TransactionHistoryState.loaded({
    required List<TransactionResponse> transactions,
    required String totalAmount,
    required bool isIncome,
    required String currency,
    required DateTime startDate,
    required DateTime endDate,
    required String sortBy,
  }) = TransactionHistoryLoaded;

  const factory TransactionHistoryState.error({required String message}) =
      TransactionHistoryError;
}
