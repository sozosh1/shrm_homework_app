import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';

part 'transaction_response.freezed.dart';
part 'transaction_response.g.dart';

@freezed
abstract class TransactionResponse with _$TransactionResponse {
  const factory TransactionResponse({
    required int id,
    required AccountBrief account,
    required Category category,
    required double amount,
    required DateTime transactionDate,
    String? comment,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _TransactionResponse;

  factory TransactionResponse.fromJson(Map<String, dynamic> json) =>
      _$TransactionResponseFromJson(_preprocessTransactionJson(json));
}

/// Предобработка JSON для корректного парсинга amount
Map<String, dynamic> _preprocessTransactionJson(Map<String, dynamic> json) {
  final processed = Map<String, dynamic>.from(json);
  
  // Обрабатываем amount - может приходить как строка или число
  if (processed['amount'] != null) {
    final amount = processed['amount'];
    if (amount is String) {
      processed['amount'] = double.tryParse(amount) ?? 0.0;
    } else if (amount is num) {
      processed['amount'] = amount.toDouble();
    }
  }
  
  return processed;
}
