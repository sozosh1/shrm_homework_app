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
  const AccountLoaded({required this.account, required this.isBalanceVisible, this.isLoading = false});
  

 final  AccountResponse account;
 final  bool isBalanceVisible;
@JsonKey() final  bool isLoading;

/// Create a copy of AccountState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountLoadedCopyWith<AccountLoaded> get copyWith => _$AccountLoadedCopyWithImpl<AccountLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountLoaded&&(identical(other.account, account) || other.account == account)&&(identical(other.isBalanceVisible, isBalanceVisible) || other.isBalanceVisible == isBalanceVisible)&&(identical(other.isLoading, isLoading) || other.isLoading == isLoading));
}


@override
int get hashCode => Object.hash(runtimeType,account,isBalanceVisible,isLoading);

@override
String toString() {
  return 'AccountState.loaded(account: $account, isBalanceVisible: $isBalanceVisible, isLoading: $isLoading)';
}


}

/// @nodoc
abstract mixin class $AccountLoadedCopyWith<$Res> implements $AccountStateCopyWith<$Res> {
  factory $AccountLoadedCopyWith(AccountLoaded value, $Res Function(AccountLoaded) _then) = _$AccountLoadedCopyWithImpl;
@useResult
$Res call({
 AccountResponse account, bool isBalanceVisible, bool isLoading
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
@pragma('vm:prefer-inline') $Res call({Object? account = null,Object? isBalanceVisible = null,Object? isLoading = null,}) {
  return _then(AccountLoaded(
account: null == account ? _self.account : account // ignore: cast_nullable_to_non_nullable
as AccountResponse,isBalanceVisible: null == isBalanceVisible ? _self.isBalanceVisible : isBalanceVisible // ignore: cast_nullable_to_non_nullable
as bool,isLoading: null == isLoading ? _self.isLoading : isLoading // ignore: cast_nullable_to_non_nullable
as bool,
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
