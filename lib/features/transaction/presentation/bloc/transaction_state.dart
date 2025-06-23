import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = TransactionInitial;
  const factory TransactionState.loading() = TransactionLoading;
  const factory TransactionState.loaded({
    required List<TransactionResponse> transactions,
    required double totalAmount,
    required bool isIncome,
    required String currency,
  }) = TransactionLoaded;

  const factory TransactionState.error({required String message}) =
      TransactionError;
}
