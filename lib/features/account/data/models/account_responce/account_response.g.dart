// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountResponse _$AccountResponseFromJson(
  Map<String, dynamic> json,
) => _AccountResponse(
  id: (json['id'] as num).toInt(),
  name: json['name'] as String,
  balance: json['balance'] as String,
  currency: json['currency'] as String,
  incomeStats: StatItem.fromJson(json['incomeStats'] as Map<String, dynamic>),
  expenseStats: StatItem.fromJson(json['expenseStats'] as Map<String, dynamic>),
  createdAt: json['createdAt'] as String,
  updatedAt: json['updatedAt'] as String,
);

Map<String, dynamic> _$AccountResponseToJson(_AccountResponse instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'balance': instance.balance,
      'currency': instance.currency,
      'incomeStats': instance.incomeStats,
      'expenseStats': instance.expenseStats,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
