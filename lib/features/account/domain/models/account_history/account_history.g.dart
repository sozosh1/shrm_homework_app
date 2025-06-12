// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'account_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AccountHistory _$AccountHistoryFromJson(Map<String, dynamic> json) =>
    _AccountHistory(
      id: (json['id'] as num).toInt(),
      accountId: (json['accountId'] as num).toInt(),
      changeType: json['changeType'] as String,
      previousState: AccountState.fromJson(
        json['previousState'] as Map<String, dynamic>,
      ),
      newState: AccountState.fromJson(json['newState'] as Map<String, dynamic>),
      changeTimestamp: json['changeTimestamp'] as String,
      createdAt: json['createdAt'] as String,
    );

Map<String, dynamic> _$AccountHistoryToJson(_AccountHistory instance) =>
    <String, dynamic>{
      'id': instance.id,
      'accountId': instance.accountId,
      'changeType': instance.changeType,
      'previousState': instance.previousState,
      'newState': instance.newState,
      'changeTimestamp': instance.changeTimestamp,
      'createdAt': instance.createdAt,
    };
