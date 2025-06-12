// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stat_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$StatItem implements DiagnosticableTreeMixin {

 int get categoryId; String get categoryName; String get emoji; String get amount;
/// Create a copy of StatItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StatItemCopyWith<StatItem> get copyWith => _$StatItemCopyWithImpl<StatItem>(this as StatItem, _$identity);

  /// Serializes this StatItem to a JSON map.
  Map<String, dynamic> toJson();

@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'StatItem'))
    ..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('categoryName', categoryName))..add(DiagnosticsProperty('emoji', emoji))..add(DiagnosticsProperty('amount', amount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StatItem&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,emoji,amount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'StatItem(categoryId: $categoryId, categoryName: $categoryName, emoji: $emoji, amount: $amount)';
}


}

/// @nodoc
abstract mixin class $StatItemCopyWith<$Res>  {
  factory $StatItemCopyWith(StatItem value, $Res Function(StatItem) _then) = _$StatItemCopyWithImpl;
@useResult
$Res call({
 int categoryId, String categoryName, String emoji, String amount
});




}
/// @nodoc
class _$StatItemCopyWithImpl<$Res>
    implements $StatItemCopyWith<$Res> {
  _$StatItemCopyWithImpl(this._self, this._then);

  final StatItem _self;
  final $Res Function(StatItem) _then;

/// Create a copy of StatItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? categoryName = null,Object? emoji = null,Object? amount = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// @nodoc
@JsonSerializable()

class _StatItem with DiagnosticableTreeMixin implements StatItem {
  const _StatItem({required this.categoryId, required this.categoryName, required this.emoji, required this.amount});
  factory _StatItem.fromJson(Map<String, dynamic> json) => _$StatItemFromJson(json);

@override final  int categoryId;
@override final  String categoryName;
@override final  String emoji;
@override final  String amount;

/// Create a copy of StatItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StatItemCopyWith<_StatItem> get copyWith => __$StatItemCopyWithImpl<_StatItem>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StatItemToJson(this, );
}
@override
void debugFillProperties(DiagnosticPropertiesBuilder properties) {
  properties
    ..add(DiagnosticsProperty('type', 'StatItem'))
    ..add(DiagnosticsProperty('categoryId', categoryId))..add(DiagnosticsProperty('categoryName', categoryName))..add(DiagnosticsProperty('emoji', emoji))..add(DiagnosticsProperty('amount', amount));
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StatItem&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.categoryName, categoryName) || other.categoryName == categoryName)&&(identical(other.emoji, emoji) || other.emoji == emoji)&&(identical(other.amount, amount) || other.amount == amount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,categoryId,categoryName,emoji,amount);

@override
String toString({ DiagnosticLevel minLevel = DiagnosticLevel.info }) {
  return 'StatItem(categoryId: $categoryId, categoryName: $categoryName, emoji: $emoji, amount: $amount)';
}


}

/// @nodoc
abstract mixin class _$StatItemCopyWith<$Res> implements $StatItemCopyWith<$Res> {
  factory _$StatItemCopyWith(_StatItem value, $Res Function(_StatItem) _then) = __$StatItemCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, String categoryName, String emoji, String amount
});




}
/// @nodoc
class __$StatItemCopyWithImpl<$Res>
    implements _$StatItemCopyWith<$Res> {
  __$StatItemCopyWithImpl(this._self, this._then);

  final _StatItem _self;
  final $Res Function(_StatItem) _then;

/// Create a copy of StatItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? categoryName = null,Object? emoji = null,Object? amount = null,}) {
  return _then(_StatItem(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,categoryName: null == categoryName ? _self.categoryName : categoryName // ignore: cast_nullable_to_non_nullable
as String,emoji: null == emoji ? _self.emoji : emoji // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
