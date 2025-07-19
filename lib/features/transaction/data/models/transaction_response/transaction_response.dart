import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/account/data/models/account_brief/account_brief.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';

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
      _$TransactionResponseFromJson(json);
}

extension TransactionResponseX on TransactionResponse {
  Transaction toTransaction() {
    return Transaction(
      id: id,
      accountId: account.id,
      categoryId: category.id,
      amount: amount,
      transactionDate: transactionDate,
      comment: comment ?? '',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }

  TransactionRequest toRequest() {
    return TransactionRequest(
      accountId: account.id,
      categoryId: category.id,
      amount: amount,
      transactionDate: transactionDate,
      comment: comment,
    );
  }
}
