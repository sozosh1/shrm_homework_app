import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';

part 'account_event.freezed.dart';

@freezed
abstract class AccountEvent with _$AccountEvent {
  const factory AccountEvent.loadAccount(int accountId) = LoadAccount;
  const factory AccountEvent.updateAccount(
    int accountId,
    AccountUpdateRequest request,
  ) = UpdateAccount;
  const factory AccountEvent.toggleBalanceVisibility() =
      ToggleBalanceVisibility;
}
