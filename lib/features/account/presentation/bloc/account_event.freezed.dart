// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AccountEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AccountEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent()';
}


}

/// @nodoc
class $AccountEventCopyWith<$Res>  {
$AccountEventCopyWith(AccountEvent _, $Res Function(AccountEvent) __);
}


/// @nodoc


class LoadAccount implements AccountEvent {
  const LoadAccount(this.accountId);
  

 final  int accountId;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadAccountCopyWith<LoadAccount> get copyWith => _$LoadAccountCopyWithImpl<LoadAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAccount&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,accountId);

@override
String toString() {
  return 'AccountEvent.loadAccount(accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $LoadAccountCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $LoadAccountCopyWith(LoadAccount value, $Res Function(LoadAccount) _then) = _$LoadAccountCopyWithImpl;
@useResult
$Res call({
 int accountId
});




}
/// @nodoc
class _$LoadAccountCopyWithImpl<$Res>
    implements $LoadAccountCopyWith<$Res> {
  _$LoadAccountCopyWithImpl(this._self, this._then);

  final LoadAccount _self;
  final $Res Function(LoadAccount) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountId = null,}) {
  return _then(LoadAccount(
null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class UpdateAccount implements AccountEvent {
  const UpdateAccount(this.accountId, this.request);
  

 final  int accountId;
 final  AccountUpdateRequest request;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateAccountCopyWith<UpdateAccount> get copyWith => _$UpdateAccountCopyWithImpl<UpdateAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateAccount&&(identical(other.accountId, accountId) || other.accountId == accountId)&&(identical(other.request, request) || other.request == request));
}


@override
int get hashCode => Object.hash(runtimeType,accountId,request);

@override
String toString() {
  return 'AccountEvent.updateAccount(accountId: $accountId, request: $request)';
}


}

/// @nodoc
abstract mixin class $UpdateAccountCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $UpdateAccountCopyWith(UpdateAccount value, $Res Function(UpdateAccount) _then) = _$UpdateAccountCopyWithImpl;
@useResult
$Res call({
 int accountId, AccountUpdateRequest request
});


$AccountUpdateRequestCopyWith<$Res> get request;

}
/// @nodoc
class _$UpdateAccountCopyWithImpl<$Res>
    implements $UpdateAccountCopyWith<$Res> {
  _$UpdateAccountCopyWithImpl(this._self, this._then);

  final UpdateAccount _self;
  final $Res Function(UpdateAccount) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountId = null,Object? request = null,}) {
  return _then(UpdateAccount(
null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as AccountUpdateRequest,
  ));
}

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AccountUpdateRequestCopyWith<$Res> get request {
  
  return $AccountUpdateRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class ToggleBalanceVisibility implements AccountEvent {
  const ToggleBalanceVisibility();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ToggleBalanceVisibility);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'AccountEvent.toggleBalanceVisibility()';
}


}




/// @nodoc


class RefreshAccount implements AccountEvent {
  const RefreshAccount(this.accountId);
  

 final  int accountId;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RefreshAccountCopyWith<RefreshAccount> get copyWith => _$RefreshAccountCopyWithImpl<RefreshAccount>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshAccount&&(identical(other.accountId, accountId) || other.accountId == accountId));
}


@override
int get hashCode => Object.hash(runtimeType,accountId);

@override
String toString() {
  return 'AccountEvent.refreshAccount(accountId: $accountId)';
}


}

/// @nodoc
abstract mixin class $RefreshAccountCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $RefreshAccountCopyWith(RefreshAccount value, $Res Function(RefreshAccount) _then) = _$RefreshAccountCopyWithImpl;
@useResult
$Res call({
 int accountId
});




}
/// @nodoc
class _$RefreshAccountCopyWithImpl<$Res>
    implements $RefreshAccountCopyWith<$Res> {
  _$RefreshAccountCopyWithImpl(this._self, this._then);

  final RefreshAccount _self;
  final $Res Function(RefreshAccount) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? accountId = null,}) {
  return _then(RefreshAccount(
null == accountId ? _self.accountId : accountId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

/// @nodoc


class SwitchPeriod implements AccountEvent {
  const SwitchPeriod(this.period);
  

 final  String period;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SwitchPeriodCopyWith<SwitchPeriod> get copyWith => _$SwitchPeriodCopyWithImpl<SwitchPeriod>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SwitchPeriod&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,period);

@override
String toString() {
  return 'AccountEvent.switchPeriod(period: $period)';
}


}

/// @nodoc
abstract mixin class $SwitchPeriodCopyWith<$Res> implements $AccountEventCopyWith<$Res> {
  factory $SwitchPeriodCopyWith(SwitchPeriod value, $Res Function(SwitchPeriod) _then) = _$SwitchPeriodCopyWithImpl;
@useResult
$Res call({
 String period
});




}
/// @nodoc
class _$SwitchPeriodCopyWithImpl<$Res>
    implements $SwitchPeriodCopyWith<$Res> {
  _$SwitchPeriodCopyWithImpl(this._self, this._then);

  final SwitchPeriod _self;
  final $Res Function(SwitchPeriod) _then;

/// Create a copy of AccountEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? period = null,}) {
  return _then(SwitchPeriod(
null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
