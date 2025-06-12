import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/domain/models/account_state/account_state.dart';

part 'account_history.freezed.dart';
part 'account_history.g.dart';

@freezed
abstract class AccountHistory with _$AccountHistory {
  const factory AccountHistory({
    required int id,
    required int accountId,
    required String changeType,
    //! сделать необязательным?  
    //? AccountState? previousState,
    required AccountState previousState,
    required AccountState newState,
    required String changeTimestamp,
    required String createdAt,
  }) = _AccountHistory;

  factory AccountHistory.fromJson(Map<String, Object?> json) =>
      _$AccountHistoryFromJson(json);
}


