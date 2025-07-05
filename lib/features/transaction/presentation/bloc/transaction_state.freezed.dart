// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState()';
}


}

/// @nodoc
class $TransactionStateCopyWith<$Res>  {
$TransactionStateCopyWith(TransactionState _, $Res Function(TransactionState) __);
}


/// @nodoc


class TransactionInitial implements TransactionState {
  const TransactionInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.initial()';
}


}




/// @nodoc


class TransactionLoading implements TransactionState {
  const TransactionLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.loading()';
}


}




/// @nodoc


class TransactionSaving implements TransactionState {
  const TransactionSaving();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSaving);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.saving()';
}


}




/// @nodoc


class TransactionLoaded implements TransactionState {
  const TransactionLoaded({required final  List<TransactionResponse> transactions, required this.totalAmount, required this.isIncome, required this.currency}): _transactions = transactions;
  

 final  List<TransactionResponse> _transactions;
 List<TransactionResponse> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}

 final  double totalAmount;
 final  bool isIncome;
 final  String currency;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionLoadedCopyWith<TransactionLoaded> get copyWith => _$TransactionLoadedCopyWithImpl<TransactionLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionLoaded&&const DeepCollectionEquality().equals(other._transactions, _transactions)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome)&&(identical(other.currency, currency) || other.currency == currency));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_transactions),totalAmount,isIncome,currency);

@override
String toString() {
  return 'TransactionState.loaded(transactions: $transactions, totalAmount: $totalAmount, isIncome: $isIncome, currency: $currency)';
}


}

/// @nodoc
abstract mixin class $TransactionLoadedCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory $TransactionLoadedCopyWith(TransactionLoaded value, $Res Function(TransactionLoaded) _then) = _$TransactionLoadedCopyWithImpl;
@useResult
$Res call({
 List<TransactionResponse> transactions, double totalAmount, bool isIncome, String currency
});




}
/// @nodoc
class _$TransactionLoadedCopyWithImpl<$Res>
    implements $TransactionLoadedCopyWith<$Res> {
  _$TransactionLoadedCopyWithImpl(this._self, this._then);

  final TransactionLoaded _self;
  final $Res Function(TransactionLoaded) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transactions = null,Object? totalAmount = null,Object? isIncome = null,Object? currency = null,}) {
  return _then(TransactionLoaded(
transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionResponse>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class TransactionSaved implements TransactionState {
  const TransactionSaved();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionSaved);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.saved()';
}


}




/// @nodoc


class TransactionDeleted implements TransactionState {
  const TransactionDeleted();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionDeleted);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionState.deleted()';
}


}




/// @nodoc


class TransactionError implements TransactionState {
  const TransactionError({required this.message});
  

 final  String message;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionErrorCopyWith<TransactionError> get copyWith => _$TransactionErrorCopyWithImpl<TransactionError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'TransactionState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $TransactionErrorCopyWith<$Res> implements $TransactionStateCopyWith<$Res> {
  factory $TransactionErrorCopyWith(TransactionError value, $Res Function(TransactionError) _then) = _$TransactionErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$TransactionErrorCopyWithImpl<$Res>
    implements $TransactionErrorCopyWith<$Res> {
  _$TransactionErrorCopyWithImpl(this._self, this._then);

  final TransactionError _self;
  final $Res Function(TransactionError) _then;

/// Create a copy of TransactionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(TransactionError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
