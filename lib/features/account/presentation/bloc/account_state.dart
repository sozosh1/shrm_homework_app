import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';

part 'account_state.freezed.dart';

@freezed
abstract class AccountState with _$AccountState {
  const factory AccountState.initial() = AccountInitial;
  const factory AccountState.loading() = AccountLoading;
  const factory AccountState.loaded({
    required AccountResponse account,
    required bool isBalanceVisible,
    @Default(false) bool isLoading,
  }) = AccountLoaded;
  const factory AccountState.error(String message) = AccountError;
}
