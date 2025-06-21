// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_history_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionHistoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionHistoryState()';
}


}

/// @nodoc
class $TransactionHistoryStateCopyWith<$Res>  {
$TransactionHistoryStateCopyWith(TransactionHistoryState _, $Res Function(TransactionHistoryState) __);
}


/// @nodoc


class TransactionHistoryInitial implements TransactionHistoryState {
  const TransactionHistoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionHistoryState.initial()';
}


}




/// @nodoc


class TransactionHistoryLoading implements TransactionHistoryState {
  const TransactionHistoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionHistoryState.loading()';
}


}




/// @nodoc


class TransactionHistoryLoaded implements TransactionHistoryState {
  const TransactionHistoryLoaded({required final  List<TransactionResponse> transactions, required this.totalAmount, required this.isIncome, required this.currency, required this.startDate, required this.endDate, required this.sortBy}): _transactions = transactions;
  

 final  List<TransactionResponse> _transactions;
 List<TransactionResponse> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  String totalAmount;
 final  bool isIncome;
 final  String currency;
 final  DateTime startDate;
 final  DateTime endDate;
 final  String sortBy;

/// Create a copy of TransactionHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionHistoryLoadedCopyWith<TransactionHistoryLoaded> get copyWith => _$TransactionHistoryLoadedCopyWithImpl<TransactionHistoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryLoaded&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.endDate, endDate) || other.endDate == endDate)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),totalAmount,isIncome,currency,startDate,endDate,sortBy);

@override
String toString() {
  return 'TransactionHistoryState.loaded(transactions: $transactions, totalAmount: $totalAmount, isIncome: $isIncome, currency: $currency, startDate: $startDate, endDate: $endDate, sortBy: $sortBy)';
}


}

/// @nodoc
abstract mixin class $TransactionHistoryLoadedCopyWith<$Res> implements $TransactionHistoryStateCopyWith<$Res> {
  factory $TransactionHistoryLoadedCopyWith(TransactionHistoryLoaded value, $Res Function(TransactionHistoryLoaded) _then) = _$TransactionHistoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<TransactionResponse> transactions, String totalAmount, bool isIncome, String currency, DateTime startDate, DateTime endDate, String sortBy
});




}
/// @nodoc
class _$TransactionHistoryLoadedCopyWithImpl<$Res>
    implements $TransactionHistoryLoadedCopyWith<$Res> {
  _$TransactionHistoryLoadedCopyWithImpl(this._self, this._then);

  final TransactionHistoryLoaded _self;
  final $Res Function(TransactionHistoryLoaded) _then;

/// Create a copy of TransactionHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? totalAmount = null,Object? isIncome = null,Object? currency = null,Object? startDate = null,Object? endDate = null,Object? sortBy = null,}) {
  return _then(TransactionHistoryLoaded(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionResponse>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as String,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as DateTime,endDate: null == endDate ? _self.endDate : endDate // ignore: cast_nullable_to_non_nullable
as DateTime,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TransactionHistoryError implements TransactionHistoryState {
  const TransactionHistoryError({required this.message});
  

 final  String message;

/// Create a copy of TransactionHistoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionHistoryErrorCopyWith<TransactionHistoryError> get copyWith => _$TransactionHistoryErrorCopyWithImpl<TransactionHistoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionHistoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TransactionHistoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TransactionHistoryErrorCopyWith<$Res> implements $TransactionHistoryStateCopyWith<$Res> {
  factory $TransactionHistoryErrorCopyWith(TransactionHistoryError value, $Res Function(TransactionHistoryError) _then) = _$TransactionHistoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TransactionHistoryErrorCopyWithImpl<$Res>
    implements $TransactionHistoryErrorCopyWith<$Res> {
  _$TransactionHistoryErrorCopyWithImpl(this._self, this._then);

  final TransactionHistoryError _self;
  final $Res Function(TransactionHistoryError) _then;

/// Create a copy of TransactionHistoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TransactionHistoryError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
