import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';

part 'account_update_request.freezed.dart';
part 'account_update_request.g.dart';

@freezed
abstract class AccountUpdateRequest with _$AccountUpdateRequest {
  const factory AccountUpdateRequest({
    required String name,
    required double balance,
    required String currency,
  }) = _AccountUpdateRequest;

  factory AccountUpdateRequest.fromJson(Map<String, Object?> json) =>
      _$AccountUpdateRequestFromJson(json);

  factory AccountUpdateRequest.fromAccountResponse(AccountResponse response) {
    return AccountUpdateRequest(
      name: response.name,
      balance: response.balance,
      currency: response.currency,
    );
  }
}
