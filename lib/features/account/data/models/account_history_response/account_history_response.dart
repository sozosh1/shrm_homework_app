import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_history/account_history.dart';

part 'account_history_response.freezed.dart';
part 'account_history_response.g.dart';

@freezed
abstract class AccountHistoryResponse with _$AccountHistoryResponse {
  const factory AccountHistoryResponse({
    required int accountId,
    required String accountName,
    required String currency,
    required String currentBalance,
    required AccountHistory history,
  }) = _AccountHistoryResponse;

  factory AccountHistoryResponse.fromJson(Map<String, Object?> json) =>
      _$AccountHistoryResponseFromJson(json);
}
