// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState()';
}


}

/// @nodoc
class $AccountStateCopyWith<$Res>  {
$AccountStateCopyWith(AccountState _, $Res Function(AccountState) __);
}


/// @nodoc


class AccountInitial implements AccountState {
  const AccountInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.initial()';
}


}




/// @nodoc


class AccountLoading implements AccountState {
  const AccountLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountState.loading()';
}


}




/// @nodoc


class AccountLoaded implements AccountState {
  const AccountLoaded({required this.account, required this.isBalanceVisible, this.isLoading = false, final  List<Map<String, dynamic>> dailyData = const [], final  List<Map<String, dynamic>> monthlyData = const [], this.currentPeriod = 'daily'}): _dailyData = dailyData,_monthlyData = monthlyData;
  

 final  AccountResponse account;
 final  bool isBalanceVisible;
@JsonKey() final  bool isLoading;
 final  List<Map<String, dynamic>> _dailyData;
@JsonKey() List<Map<String, dynamic>> get dailyData {
  if (_dailyData is EqualUnmodifiableListView) return _dailyData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_dailyData);
}

// Добавлены для графика
 final  List<Map<String, dynamic>> _monthlyData;
// Добавлены для графика
@JsonKey() List<Map<String, dynamic>> get monthlyData {
  if (_monthlyData is EqualUnmodifiableListView) return _monthlyData;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_monthlyData);
}

// Добавлены для графика
@JsonKey() final  String currentPeriod;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountLoadedCopyWith<AccountLoaded> get copyWith => _$AccountLoadedCopyWithImpl<AccountLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLoaded&&(identical(other.account, account) || other.account == account)&&(identical(other.isBalanceVisible, isBalanceVisible) || other.isBalanceVisible == isBalanceVisible)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading)&&const DeepCollectionEquality().equals(other._dailyData, _dailyData)&&const DeepCollectionEquality().equals(other._monthlyData, _monthlyData)&&(identical(other.currentPeriod, currentPeriod) || other.currentPeriod == currentPeriod));
}


@override
int get hashCode => Object.hash(runtimeType,account,isBalanceVisible,isLoading,const DeepCollectionEquality().hash(_dailyData),const DeepCollectionEquality().hash(_monthlyData),currentPeriod);

@override
String toString() {
  return 'AccountState.loaded(account: $account, isBalanceVisible: $isBalanceVisible, isLoading: $isLoading, dailyData: $dailyData, monthlyData: $monthlyData, currentPeriod: $currentPeriod)';
}


}

/// @nodoc
abstract mixin class $AccountLoadedCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountLoadedCopyWith(AccountLoaded value, $Res Function(AccountLoaded) _then) = _$AccountLoadedCopyWithImpl;
@useResult
$Res call({
 AccountResponse account, bool isBalanceVisible, bool isLoading, List<Map<String, dynamic>> dailyData, List<Map<String, dynamic>> monthlyData, String currentPeriod
});


$AccountResponseCopyWith<$Res> get account;

}
/// @nodoc
class _$AccountLoadedCopyWithImpl<$Res>
    implements $AccountLoadedCopyWith<$Res> {
  _$AccountLoadedCopyWithImpl(this._self, this._then);

  final AccountLoaded _self;
  final $Res Function(AccountLoaded) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? account = null,Object? isBalanceVisible = null,Object? isLoading = null,Object? dailyData = null,Object? monthlyData = null,Object? currentPeriod = null,}) {
  return _then(AccountLoaded(
account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountResponse,isBalanceVisible: null == isBalanceVisible ? _self.isBalanceVisible : isBalanceVisible // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,dailyData: null == dailyData ? _self._dailyData : dailyData // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,monthlyData: null == monthlyData ? _self._monthlyData : monthlyData // ignore: cast_nullable_to_non_nullable
as List<Map<String, dynamic>>,currentPeriod: null == currentPeriod ? _self.currentPeriod : currentPeriod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountResponseCopyWith<$Res> get account {
  
  return $AccountResponseCopyWith<$Res>(_self.account, (value) {
    return _then(_self.copyWith(account: value));
  });
}
}

/// @nodoc


class AccountError implements AccountState {
  const AccountError(this.message);
  

 final  String message;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountErrorCopyWith<AccountError> get copyWith => _$AccountErrorCopyWithImpl<AccountError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'AccountState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $AccountErrorCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountErrorCopyWith(AccountError value, $Res Function(AccountError) _then) = _$AccountErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$AccountErrorCopyWithImpl<$Res>
    implements $AccountErrorCopyWith<$Res> {
  _$AccountErrorCopyWithImpl(this._self, this._then);

  final AccountError _self;
  final $Res Function(AccountError) _then;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(AccountError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
