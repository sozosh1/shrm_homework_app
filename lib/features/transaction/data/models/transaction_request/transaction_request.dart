import 'package:freezed_annotation/freezed_annotation.dart';

part 'transaction_request.freezed.dart';
part 'transaction_request.g.dart';

@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required int accountId,
    required int categoryId,
    required double amount,
    required DateTime transactionDate,
    String? comment,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) => _$TransactionRequestFromJson(json);
}

/// Расширение для дополнительных методов
extension TransactionRequestExtension on TransactionRequest {
  /// Специальный метод для API, который исключает null значения
  Map<String, dynamic> toJsonForApi() {
    final json = <String, dynamic>{
      'accountId': accountId,
      'categoryId': categoryId,
      'amount': amount,
      'transactionDate': _dateToString(transactionDate),
    };
    
    // Добавляем comment только если он не null
    if (comment != null && comment!.isNotEmpty) {
      json['comment'] = comment;
    }
    
    return json;
  }
}

/// Преобразование даты в строку формата YYYY-MM-DD для API
String _dateToString(DateTime date) {
  return '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
}

/// Преобразование строки формата YYYY-MM-DD в DateTime
DateTime _dateFromString(String dateString) {
  return DateTime.parse(dateString);
}