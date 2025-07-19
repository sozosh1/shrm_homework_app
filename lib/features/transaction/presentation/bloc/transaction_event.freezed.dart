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


class LoadCategories implements TransactionEvent {
  const LoadCategories({required this.isIncome});
  

 final  bool isIncome;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LoadCategoriesCopyWith<LoadCategories> get copyWith => _$LoadCategoriesCopyWithImpl<LoadCategories>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCategories&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,isIncome);

@override
String toString() {
  return 'TransactionEvent.loadCategories(isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $LoadCategoriesCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory $LoadCategoriesCopyWith(LoadCategories value, $Res Function(LoadCategories) _then) = _$LoadCategoriesCopyWithImpl;
@useResult
$Res call({
 bool isIncome
});




}
/// @nodoc
class _$LoadCategoriesCopyWithImpl<$Res>
    implements $LoadCategoriesCopyWith<$Res> {
  _$LoadCategoriesCopyWithImpl(this._self, this._then);

  final LoadCategories _self;
  final $Res Function(LoadCategories) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? isIncome = null,}) {
  return _then(LoadCategories(
isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class LoadAccounts implements TransactionEvent {
  const LoadAccounts();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadAccounts);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'TransactionEvent.loadAccounts()';
}


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




/// @nodoc


class CreateTransaction implements TransactionEvent {
  const CreateTransaction({required this.request, required this.isIncome});
  

 final  TransactionRequest request;
 final  bool isIncome;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CreateTransactionCopyWith<CreateTransaction> get copyWith => _$CreateTransactionCopyWithImpl<CreateTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CreateTransaction&&(identical(other.request, request) || other.request == request)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,request,isIncome);

@override
String toString() {
  return 'TransactionEvent.createTransaction(request: $request, isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $CreateTransactionCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory $CreateTransactionCopyWith(CreateTransaction value, $Res Function(CreateTransaction) _then) = _$CreateTransactionCopyWithImpl;
@useResult
$Res call({
 TransactionRequest request, bool isIncome
});


$TransactionRequestCopyWith<$Res> get request;

}
/// @nodoc
class _$CreateTransactionCopyWithImpl<$Res>
    implements $CreateTransactionCopyWith<$Res> {
  _$CreateTransactionCopyWithImpl(this._self, this._then);

  final CreateTransaction _self;
  final $Res Function(CreateTransaction) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? request = null,Object? isIncome = null,}) {
  return _then(CreateTransaction(
request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as TransactionRequest,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<$Res> get request {
  
  return $TransactionRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class UpdateTransaction implements TransactionEvent {
  const UpdateTransaction({required this.id, required this.request, required this.isIncome});
  

 final  int id;
 final  TransactionRequest request;
 final  bool isIncome;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UpdateTransactionCopyWith<UpdateTransaction> get copyWith => _$UpdateTransactionCopyWithImpl<UpdateTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UpdateTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.request, request) || other.request == request)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,id,request,isIncome);

@override
String toString() {
  return 'TransactionEvent.updateTransaction(id: $id, request: $request, isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $UpdateTransactionCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory $UpdateTransactionCopyWith(UpdateTransaction value, $Res Function(UpdateTransaction) _then) = _$UpdateTransactionCopyWithImpl;
@useResult
$Res call({
 int id, TransactionRequest request, bool isIncome
});


$TransactionRequestCopyWith<$Res> get request;

}
/// @nodoc
class _$UpdateTransactionCopyWithImpl<$Res>
    implements $UpdateTransactionCopyWith<$Res> {
  _$UpdateTransactionCopyWithImpl(this._self, this._then);

  final UpdateTransaction _self;
  final $Res Function(UpdateTransaction) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? request = null,Object? isIncome = null,}) {
  return _then(UpdateTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,request: null == request ? _self.request : request // ignore: cast_nullable_to_non_nullable
as TransactionRequest,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionRequestCopyWith<$Res> get request {
  
  return $TransactionRequestCopyWith<$Res>(_self.request, (value) {
    return _then(_self.copyWith(request: value));
  });
}
}

/// @nodoc


class DeleteTransaction implements TransactionEvent {
  const DeleteTransaction({required this.id, required this.isIncome});
  

 final  int id;
 final  bool isIncome;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DeleteTransactionCopyWith<DeleteTransaction> get copyWith => _$DeleteTransactionCopyWithImpl<DeleteTransaction>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DeleteTransaction&&(identical(other.id, id) || other.id == id)&&(identical(other.isIncome, isIncome) || other.isIncome == isIncome));
}


@override
int get hashCode => Object.hash(runtimeType,id,isIncome);

@override
String toString() {
  return 'TransactionEvent.deleteTransaction(id: $id, isIncome: $isIncome)';
}


}

/// @nodoc
abstract mixin class $DeleteTransactionCopyWith<$Res> implements $TransactionEventCopyWith<$Res> {
  factory $DeleteTransactionCopyWith(DeleteTransaction value, $Res Function(DeleteTransaction) _then) = _$DeleteTransactionCopyWithImpl;
@useResult
$Res call({
 int id, bool isIncome
});




}
/// @nodoc
class _$DeleteTransactionCopyWithImpl<$Res>
    implements $DeleteTransactionCopyWith<$Res> {
  _$DeleteTransactionCopyWithImpl(this._self, this._then);

  final DeleteTransaction _self;
  final $Res Function(DeleteTransaction) _then;

/// Create a copy of TransactionEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? id = null,Object? isIncome = null,}) {
  return _then(DeleteTransaction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,isIncome: null == isIncome ? _self.isIncome : isIncome // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
