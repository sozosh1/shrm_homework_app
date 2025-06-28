import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/stat_item/stat_item.dart';

part 'account_response.freezed.dart';
part 'account_response.g.dart';

@freezed
abstract class AccountResponse with _$AccountResponse {
  const factory AccountResponse({
    required int id,
    required String name,
    required double balance,
    required String currency,
    required List<StatItem> incomeStats,
    required List<StatItem> expenseStats,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _AccountResponse;

  factory AccountResponse.fromJson(Map<String, Object?> json) =>
      _$AccountResponseFromJson(json);
}
