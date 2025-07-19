import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'transaction_request.freezed.dart';
part 'transaction_request.g.dart';

class IsoDateTimeConverter implements JsonConverter<DateTime, String> {
  const IsoDateTimeConverter();

  @override
  DateTime fromJson(String json) => DateTime.parse(json);

  @override
  String toJson(DateTime object) => DateFormat("yyyy-MM-ddTHH:mm:ss.SSS'Z'").format(object.toUtc());
}

@freezed
abstract class TransactionRequest with _$TransactionRequest {
  const factory TransactionRequest({
    required int accountId,
    required int categoryId,
    required double amount,
    @IsoDateTimeConverter() required DateTime transactionDate,
    String? comment,
  }) = _TransactionRequest;

  factory TransactionRequest.fromJson(Map<String, dynamic> json) =>
      _$TransactionRequestFromJson(json);
}
