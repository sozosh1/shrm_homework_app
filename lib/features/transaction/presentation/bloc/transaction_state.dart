import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
part 'transaction_state.freezed.dart';

@freezed
class TransactionState with _$TransactionState {
  const factory TransactionState.initial() = TransactionInitial;
  const factory TransactionState.loading() = TransactionLoading;
  const factory TransactionState.saving() = TransactionSaving;
  const factory TransactionState.categoriesLoaded({
    required List<Category> categories,
    required bool isIncome,
  }) = CategoriesLoaded;

  const factory TransactionState.accountsLoaded({
    required List<AccountResponse> accounts,
  }) = AccountsLoaded;

  const factory TransactionState.loaded({
    required List<TransactionResponse> transactions,
    required double totalAmount,
    required bool isIncome,
    required String currency,
  }) = TransactionLoaded;

  const factory TransactionState.saved() = TransactionSaved;
  const factory TransactionState.deleted() = TransactionDeleted;

  const factory TransactionState.error({required String message}) =
      TransactionError;
}
