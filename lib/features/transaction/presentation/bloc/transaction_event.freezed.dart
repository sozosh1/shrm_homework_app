// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transaction_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransactionEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionEvent()';
}


}

/// @nodoc
class $TransactionEventCopyWith<$Res>  {
$TransactionEventCopyWith(TransactionEvent _, $Res Function(TransactionEvent) __);
}


/// @nodoc


class LoadTodayTransactions implements TransactionEvent {
  const LoadTodayTransactions({required this.isIncome});
  

 final  bool isIncome;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadTodayTransactionsCopyWith<LoadTodayTransactions> get copyWith => _$LoadTodayTransactionsCopyWithImpl<LoadTodayTransactions>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadTodayTransactions&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,isIncome);

@override
String toString() {
  return 'TransactionEvent.loadTodayTransactions(isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $LoadTodayTransactionsCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory $LoadTodayTransactionsCopyWith(LoadTodayTransactions value, $Res Function(LoadTodayTransactions) _then) = _$LoadTodayTransactionsCopyWithImpl;
@useResult
$Res call({
 bool isIncome
});




}
/// @nodoc
class _$LoadTodayTransactionsCopyWithImpl<$Res>
    implements $LoadTodayTransactionsCopyWith<$Res> {
  _$LoadTodayTransactionsCopyWithImpl(this._self, this._then);

  final LoadTodayTransactions _self;
  final $Res Function(LoadTodayTransactions) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isIncome = null,}) {
  return _then(LoadTodayTransactions(
isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class RefreshTransactions implements TransactionEvent {
  const RefreshTransactions();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RefreshTransactions);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionEvent.refreshTransactions()';
}


}




// dart format on
