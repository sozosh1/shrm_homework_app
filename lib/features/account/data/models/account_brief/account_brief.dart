import 'package:freezed_annotation/freezed_annotation.dart';

part 'account_brief.freezed.dart';
part 'account_brief.g.dart';

@freezed
abstract class AccountBrief with _$AccountBrief {
  const factory AccountBrief({
    required int id,
    required String name,
    required double balance,
    required String currency,
  }) = _AccountBrief;

  factory AccountBrief.fromJson(Map<String, Object?> json) =>
      _$AccountBriefFromJson(_preprocessJson(json));
}

/// Предобработка JSON для корректного парсинга balance
Map<String, dynamic> _preprocessJson(Map<String, Object?> json) {
  final processed = Map<String, dynamic>.from(json);
  
  // Обрабатываем balance - может приходить как строка или число
  if (processed['balance'] != null) {
    final balance = processed['balance'];
    if (balance is String) {
      processed['balance'] = double.tryParse(balance) ?? 0.0;
    } else if (balance is num) {
      processed['balance'] = balance.toDouble();
    }
  }
  
  return processed;
}
