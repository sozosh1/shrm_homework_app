// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stat_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StatItem _$StatItemFromJson(Map<String, dynamic> json) => _StatItem(
  categoryId: (json['categoryId'] as num).toInt(),
  categoryName: json['categoryName'] as String,
  emoji: json['emoji'] as String,
  amount: json['amount'] as String,
);

Map<String, dynamic> _$StatItemToJson(_StatItem instance) => <String, dynamic>{
  'categoryId': instance.categoryId,
  'categoryName': instance.categoryName,
  'emoji': instance.emoji,
  'amount': instance.amount,
};
