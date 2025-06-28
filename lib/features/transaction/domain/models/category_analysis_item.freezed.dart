// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_analysis_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryAnalysisItem {

 Category get category; double get totalAmount; TransactionResponse get lastTransaction; double get percentage; List<TransactionResponse> get transactions;
/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryAnalysisItemCopyWith<CategoryAnalysisItem> get copyWith => _$CategoryAnalysisItemCopyWithImpl<CategoryAnalysisItem>(this as CategoryAnalysisItem, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryAnalysisItem&&(identical(other.category, category) || other.category == category)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.lastTransaction, lastTransaction) || other.lastTransaction == lastTransaction)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&const DeepCollectionEquality().equals(other.transactions, transactions));
}


@override
int get hashCode => Object.hash(runtimeType,category,totalAmount,lastTransaction,percentage,const DeepCollectionEquality().hash(transactions));

@override
String toString() {
  return 'CategoryAnalysisItem(category: $category, totalAmount: $totalAmount, lastTransaction: $lastTransaction, percentage: $percentage, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class $CategoryAnalysisItemCopyWith<$Res>  {
  factory $CategoryAnalysisItemCopyWith(CategoryAnalysisItem value, $Res Function(CategoryAnalysisItem) _then) = _$CategoryAnalysisItemCopyWithImpl;
@useResult
$Res call({
 Category category, double totalAmount, TransactionResponse lastTransaction, double percentage, List<TransactionResponse> transactions
});


$CategoryCopyWith<$Res> get category;$TransactionResponseCopyWith<$Res> get lastTransaction;

}
/// @nodoc
class _$CategoryAnalysisItemCopyWithImpl<$Res>
    implements $CategoryAnalysisItemCopyWith<$Res> {
  _$CategoryAnalysisItemCopyWithImpl(this._self, this._then);

  final CategoryAnalysisItem _self;
  final $Res Function(CategoryAnalysisItem) _then;

/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? totalAmount = null,Object? lastTransaction = null,Object? percentage = null,Object? transactions = null,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,lastTransaction: null == lastTransaction ? _self.lastTransaction : lastTransaction // ignore: cast_nullable_to_non_nullable
as TransactionResponse,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self.transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionResponse>,
  ));
}
/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<$Res> get lastTransaction {
  
  return $TransactionResponseCopyWith<$Res>(_self.lastTransaction, (value) {
    return _then(_self.copyWith(lastTransaction: value));
  });
}
}


/// @nodoc


class _CategoryAnalysisItem implements CategoryAnalysisItem {
  const _CategoryAnalysisItem({required this.category, required this.totalAmount, required this.lastTransaction, required this.percentage, required final  List<TransactionResponse> transactions}): _transactions = transactions;
  

@override final  Category category;
@override final  double totalAmount;
@override final  TransactionResponse lastTransaction;
@override final  double percentage;
 final  List<TransactionResponse> _transactions;
@override List<TransactionResponse> get transactions {
  if (_transactions is EqualUnmodifiableListView) return _transactions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_transactions);
}


/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryAnalysisItemCopyWith<_CategoryAnalysisItem> get copyWith => __$CategoryAnalysisItemCopyWithImpl<_CategoryAnalysisItem>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryAnalysisItem&&(identical(other.category, category) || other.category == category)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.lastTransaction, lastTransaction) || other.lastTransaction == lastTransaction)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&const DeepCollectionEquality().equals(other._transactions, _transactions));
}


@override
int get hashCode => Object.hash(runtimeType,category,totalAmount,lastTransaction,percentage,const DeepCollectionEquality().hash(_transactions));

@override
String toString() {
  return 'CategoryAnalysisItem(category: $category, totalAmount: $totalAmount, lastTransaction: $lastTransaction, percentage: $percentage, transactions: $transactions)';
}


}

/// @nodoc
abstract mixin class _$CategoryAnalysisItemCopyWith<$Res> implements $CategoryAnalysisItemCopyWith<$Res> {
  factory _$CategoryAnalysisItemCopyWith(_CategoryAnalysisItem value, $Res Function(_CategoryAnalysisItem) _then) = __$CategoryAnalysisItemCopyWithImpl;
@override @useResult
$Res call({
 Category category, double totalAmount, TransactionResponse lastTransaction, double percentage, List<TransactionResponse> transactions
});


@override $CategoryCopyWith<$Res> get category;@override $TransactionResponseCopyWith<$Res> get lastTransaction;

}
/// @nodoc
class __$CategoryAnalysisItemCopyWithImpl<$Res>
    implements _$CategoryAnalysisItemCopyWith<$Res> {
  __$CategoryAnalysisItemCopyWithImpl(this._self, this._then);

  final _CategoryAnalysisItem _self;
  final $Res Function(_CategoryAnalysisItem) _then;

/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? totalAmount = null,Object? lastTransaction = null,Object? percentage = null,Object? transactions = null,}) {
  return _then(_CategoryAnalysisItem(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,lastTransaction: null == lastTransaction ? _self.lastTransaction : lastTransaction // ignore: cast_nullable_to_non_nullable
as TransactionResponse,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,transactions: null == transactions ? _self._transactions : transactions // ignore: cast_nullable_to_non_nullable
as List<TransactionResponse>,
  ));
}

/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of CategoryAnalysisItem
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransactionResponseCopyWith<$Res> get lastTransaction {
  
  return $TransactionResponseCopyWith<$Res>(_self.lastTransaction, (value) {
    return _then(_self.copyWith(lastTransaction: value));
  });
}
}

// dart format on
