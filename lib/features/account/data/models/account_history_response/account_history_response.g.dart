// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_history_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountHistoryResponse _$AccountHistoryResponseFromJson(
  Map<String, dynamic> json,
) => _AccountHistoryResponse(
  accountId: (json['accountId'] as num).toInt(),
  accountName: json['accountName'] as String,
  currency: json['currency'] as String,
  currentBalance: json['currentBalance'] as String,
  history: AccountHistory.fromJson(json['history'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AccountHistoryResponseToJson(
  _AccountHistoryResponse instance,
) => <String, dynamic>{
  'accountId': instance.accountId,
  'accountName': instance.accountName,
  'currency': instance.currency,
  'currentBalance': instance.currentBalance,
  'history': instance.history,
};
