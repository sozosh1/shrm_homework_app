import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
part 'transaction_event.freezed.dart';

@freezed
class TransactionEvent with _$TransactionEvent {
  const factory TransactionEvent.loadTodayTransactions({
    required bool isIncome,
  }) = LoadTodayTransactions;
  const factory TransactionEvent.refreshTransactions() = RefreshTransactions;

  const factory TransactionEvent.createTransaction({
    required TransactionRequest request,
    required bool isIncome,
  }) = CreateTransaction;

  const factory TransactionEvent.updateTransaction({
    required int id,
    required TransactionRequest request,
    required bool isIncome,
  }) = UpdateTransaction;

  const factory TransactionEvent.deleteTransaction({
    required int id,
    required bool isIncome,
  }) = DeleteTransaction;
}
