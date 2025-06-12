// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$AccountResponse {

 int get id; String get name; String get balance; String get currency; StatItem get incomeStats; StatItem get expenseStats; String get createdAt; String get updatedAt;
/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountResponseCopyWith<AccountResponse> get copyWith => _$AccountResponseCopyWithImpl<AccountResponse>(this as AccountResponse, _$identity);

  /// Serializes this AccountResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.incomeStats, incomeStats) || other.incomeStats == incomeStats)&&(identical(other.expenseStats, expenseStats) || other.expenseStats == expenseStats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,incomeStats,expenseStats,createdAt,updatedAt);

@override
String toString() {
  return 'AccountResponse(id: $id, name: $name, balance: $balance, currency: $currency, incomeStats: $incomeStats, expenseStats: $expenseStats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AccountResponseCopyWith<$Res>  {
  factory $AccountResponseCopyWith(AccountResponse value, $Res Function(AccountResponse) _then) = _$AccountResponseCopyWithImpl;
@useResult
$Res call({
 int id, String name, String balance, String currency, StatItem incomeStats, StatItem expenseStats, String createdAt, String updatedAt
});


$StatItemCopyWith<$Res> get incomeStats;$StatItemCopyWith<$Res> get expenseStats;

}
/// @nodoc
class _$AccountResponseCopyWithImpl<$Res>
    implements $AccountResponseCopyWith<$Res> {
  _$AccountResponseCopyWithImpl(this._self, this._then);

  final AccountResponse _self;
  final $Res Function(AccountResponse) _then;

/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? incomeStats = null,Object? expenseStats = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,incomeStats: null == incomeStats ? _self.incomeStats : incomeStats // ignore: cast_nullable_to_non_nullable
as StatItem,expenseStats: null == expenseStats ? _self.expenseStats : expenseStats // ignore: cast_nullable_to_non_nullable
as StatItem,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatItemCopyWith<$Res> get incomeStats {
  
  return $StatItemCopyWith<$Res>(_self.incomeStats, (value) {
    return _then(_self.copyWith(incomeStats: value));
  });
}/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatItemCopyWith<$Res> get expenseStats {
  
  return $StatItemCopyWith<$Res>(_self.expenseStats, (value) {
    return _then(_self.copyWith(expenseStats: value));
  });
}
}


/// @nodoc
@JsonSerializable()

class _AccountResponse implements AccountResponse {
  const _AccountResponse({required this.id, required this.name, required this.balance, required this.currency, required this.incomeStats, required this.expenseStats, required this.createdAt, required this.updatedAt});
  factory _AccountResponse.fromJson(Map<String, dynamic> json) => _$AccountResponseFromJson(json);

@override final  int id;
@override final  String name;
@override final  String balance;
@override final  String currency;
@override final  StatItem incomeStats;
@override final  StatItem expenseStats;
@override final  String createdAt;
@override final  String updatedAt;

/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountResponseCopyWith<_AccountResponse> get copyWith => __$AccountResponseCopyWithImpl<_AccountResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AccountResponse&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.incomeStats, incomeStats) || other.incomeStats == incomeStats)&&(identical(other.expenseStats, expenseStats) || other.expenseStats == expenseStats)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,balance,currency,incomeStats,expenseStats,createdAt,updatedAt);

@override
String toString() {
  return 'AccountResponse(id: $id, name: $name, balance: $balance, currency: $currency, incomeStats: $incomeStats, expenseStats: $expenseStats, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AccountResponseCopyWith<$Res> implements $AccountResponseCopyWith<$Res> {
  factory _$AccountResponseCopyWith(_AccountResponse value, $Res Function(_AccountResponse) _then) = __$AccountResponseCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String balance, String currency, StatItem incomeStats, StatItem expenseStats, String createdAt, String updatedAt
});


@override $StatItemCopyWith<$Res> get incomeStats;@override $StatItemCopyWith<$Res> get expenseStats;

}
/// @nodoc
class __$AccountResponseCopyWithImpl<$Res>
    implements _$AccountResponseCopyWith<$Res> {
  __$AccountResponseCopyWithImpl(this._self, this._then);

  final _AccountResponse _self;
  final $Res Function(_AccountResponse) _then;

/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? balance = null,Object? currency = null,Object? incomeStats = null,Object? expenseStats = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AccountResponse(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as String,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,incomeStats: null == incomeStats ? _self.incomeStats : incomeStats // ignore: cast_nullable_to_non_nullable
as StatItem,expenseStats: null == expenseStats ? _self.expenseStats : expenseStats // ignore: cast_nullable_to_non_nullable
as StatItem,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as String,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatItemCopyWith<$Res> get incomeStats {
  
  return $StatItemCopyWith<$Res>(_self.incomeStats, (value) {
    return _then(_self.copyWith(incomeStats: value));
  });
}/// Create a copy of AccountResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$StatItemCopyWith<$Res> get expenseStats {
  
  return $StatItemCopyWith<$Res>(_self.expenseStats, (value) {
    return _then(_self.copyWith(expenseStats: value));
  });
}
}

// dart format on
