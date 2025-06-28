import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_history_event.freezed.dart';

@freezed
class TransactionHistoryEvent with _$TransactionHistoryEvent {
  const factory TransactionHistoryEvent.loadTransactionInitialHistory({
    required bool isIncome,
  }) = LoadTransactionHistoryInitial;

  const factory TransactionHistoryEvent.loadTransactionHistoryByPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required bool isIncome,
    String? sortBy,
  }) = LoadTransactionHistoryByPeriod;

  const factory TransactionHistoryEvent.updateStartDate({
    required DateTime startDate,
  }) = UpdateStartDate;

  const factory TransactionHistoryEvent.updateEndDate({
    required DateTime endDate,
  }) = UpdateEndDate;

  const factory TransactionHistoryEvent.changeSorting({
    required String sortBy,
  }) = ChangeSorting;

  const factory TransactionHistoryEvent.refreshHistory() = RefreshHistory;

  const factory TransactionHistoryEvent.loadTransactionAnalysisByPeriod({
    required DateTime startDate,
    required DateTime endDate,
    required bool isIncome,
  }) = LoadTransactionAnalysisByPeriod;
}
