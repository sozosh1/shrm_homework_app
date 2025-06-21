// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_history_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionHistoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionHistoryEvent()';
}


}

/// @nodoc
class $TransactionHistoryEventCopyWith<$Res>  {
$TransactionHistoryEventCopyWith(TransactionHistoryEvent _, $Res Function(TransactionHistoryEvent) __);
}


/// @nodoc


class LoadTransactionHistoryInitial implements TransactionHistoryEvent {
  const LoadTransactionHistoryInitial({required this.isIncome});
  

 final  bool isIncome;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTransactionHistoryInitialCopyWith<LoadTransactionHistoryInitial> get copyWith => _$LoadTransactionHistoryInitialCopyWithImpl<LoadTransactionHistoryInitial>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionHistoryInitial&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,isIncome);

@override
String toString() {
  return 'TransactionHistoryEvent.loadTransactionInitialHistory(isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $LoadTransactionHistoryInitialCopyWith<$Res> implements $TransactionHistoryEventCopyWith<$Res> {
  factory $LoadTransactionHistoryInitialCopyWith(LoadTransactionHistoryInitial value, $Res Function(LoadTransactionHistoryInitial) _then) = _$LoadTransactionHistoryInitialCopyWithImpl;
@useResult
$Res call({
 bool isIncome
});




}
/// @nodoc
class _$LoadTransactionHistoryInitialCopyWithImpl<$Res>
    implements $LoadTransactionHistoryInitialCopyWith<$Res> {
  _$LoadTransactionHistoryInitialCopyWithImpl(this._self, this._then);

  final LoadTransactionHistoryInitial _self;
  final $Res Function(LoadTransactionHistoryInitial) _then;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isIncome = null,}) {
  return _then(LoadTransactionHistoryInitial(
isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LoadTransactionHistoryByPeriod implements TransactionHistoryEvent {
  const LoadTransactionHistoryByPeriod({required this.startDate, required this.endDate, required this.isIncome, this.sortBy});
  

 final  DateTime startDate;
 final  DateTime endDate;
 final  bool isIncome;
 final  String? sortBy;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTransactionHistoryByPeriodCopyWith<LoadTransactionHistoryByPeriod> get copyWith => _$LoadTransactionHistoryByPeriodCopyWithImpl<LoadTransactionHistoryByPeriod>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTransactionHistoryByPeriod&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,endDate,isIncome,sortBy);

@override
String toString() {
  return 'TransactionHistoryEvent.loadTransactionHistoryByPeriod(startDate: $startDate, endDate: $endDate, isIncome: $isIncome, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $LoadTransactionHistoryByPeriodCopyWith<$Res> implements $TransactionHistoryEventCopyWith<$Res> {
  factory $LoadTransactionHistoryByPeriodCopyWith(LoadTransactionHistoryByPeriod value, $Res Function(LoadTransactionHistoryByPeriod) _then) = _$LoadTransactionHistoryByPeriodCopyWithImpl;
@useResult
$Res call({
 DateTime startDate, DateTime endDate, bool isIncome, String? sortBy
});




}
/// @nodoc
class _$LoadTransactionHistoryByPeriodCopyWithImpl<$Res>
    implements $LoadTransactionHistoryByPeriodCopyWith<$Res> {
  _$LoadTransactionHistoryByPeriodCopyWithImpl(this._self, this._then);

  final LoadTransactionHistoryByPeriod _self;
  final $Res Function(LoadTransactionHistoryByPeriod) _then;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? endDate = null,Object? isIncome = null,Object? sortBy = freezed,}) {
  return _then(LoadTransactionHistoryByPeriod(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,sortBy: freezed == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class UpdateStartDate implements TransactionHistoryEvent {
  const UpdateStartDate({required this.startDate});
  

 final  DateTime startDate;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateStartDateCopyWith<UpdateStartDate> get copyWith => _$UpdateStartDateCopyWithImpl<UpdateStartDate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateStartDate&&(identical(other.startDate, startDate) || other.startDate == startDate));
}


@override
int get hashCode => Object.hash(runtimeType,startDate);

@override
String toString() {
  return 'TransactionHistoryEvent.updateStartDate(startDate: $startDate)';
}


}

/// @nodoc
abstract mixin class $UpdateStartDateCopyWith<$Res> implements $TransactionHistoryEventCopyWith<$Res> {
  factory $UpdateStartDateCopyWith(UpdateStartDate value, $Res Function(UpdateStartDate) _then) = _$UpdateStartDateCopyWithImpl;
@useResult
$Res call({
 DateTime startDate
});




}
/// @nodoc
class _$UpdateStartDateCopyWithImpl<$Res>
    implements $UpdateStartDateCopyWith<$Res> {
  _$UpdateStartDateCopyWithImpl(this._self, this._then);

  final UpdateStartDate _self;
  final $Res Function(UpdateStartDate) _then;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? startDate = null,}) {
  return _then(UpdateStartDate(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class UpdateEndDate implements TransactionHistoryEvent {
  const UpdateEndDate({required this.endDate});
  

 final  DateTime endDate;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateEndDateCopyWith<UpdateEndDate> get copyWith => _$UpdateEndDateCopyWithImpl<UpdateEndDate>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateEndDate&&(identical(other.endDate, endDate) || other.endDate == endDate));
}


@override
int get hashCode => Object.hash(runtimeType,endDate);

@override
String toString() {
  return 'TransactionHistoryEvent.updateEndDate(endDate: $endDate)';
}


}

/// @nodoc
abstract mixin class $UpdateEndDateCopyWith<$Res> implements $TransactionHistoryEventCopyWith<$Res> {
  factory $UpdateEndDateCopyWith(UpdateEndDate value, $Res Function(UpdateEndDate) _then) = _$UpdateEndDateCopyWithImpl;
@useResult
$Res call({
 DateTime endDate
});




}
/// @nodoc
class _$UpdateEndDateCopyWithImpl<$Res>
    implements $UpdateEndDateCopyWith<$Res> {
  _$UpdateEndDateCopyWithImpl(this._self, this._then);

  final UpdateEndDate _self;
  final $Res Function(UpdateEndDate) _then;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? endDate = null,}) {
  return _then(UpdateEndDate(
endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

/// @nodoc


class ChangeSorting implements TransactionHistoryEvent {
  const ChangeSorting({required this.sortBy});
  

 final  String sortBy;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChangeSortingCopyWith<ChangeSorting> get copyWith => _$ChangeSortingCopyWithImpl<ChangeSorting>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChangeSorting&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,sortBy);

@override
String toString() {
  return 'TransactionHistoryEvent.changeSorting(sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $ChangeSortingCopyWith<$Res> implements $TransactionHistoryEventCopyWith<$Res> {
  factory $ChangeSortingCopyWith(ChangeSorting value, $Res Function(ChangeSorting) _then) = _$ChangeSortingCopyWithImpl;
@useResult
$Res call({
 String sortBy
});




}
/// @nodoc
class _$ChangeSortingCopyWithImpl<$Res>
    implements $ChangeSortingCopyWith<$Res> {
  _$ChangeSortingCopyWithImpl(this._self, this._then);

  final ChangeSorting _self;
  final $Res Function(ChangeSorting) _then;

/// Create a copy of TransactionHistoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? sortBy = null,}) {
  return _then(ChangeSorting(
sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class RefreshHistory implements TransactionHistoryEvent {
  const RefreshHistory();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshHistory);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionHistoryEvent.refreshHistory()';
}


}




// dart format on
