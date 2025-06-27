// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState()';
}


}

/// @nodoc
class $CategoryStateCopyWith<$Res>  {
$CategoryStateCopyWith(CategoryState _, $Res Function(CategoryState) __);
}


/// @nodoc


class CategoryInitial implements CategoryState {
  const CategoryInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState.initial()';
}


}




/// @nodoc


class CategoryLoading implements CategoryState {
  const CategoryLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryState.loading()';
}


}




/// @nodoc


class CategoryLoaded implements CategoryState {
  const CategoryLoaded({required final  List<Category> allCategories, required final  List<Category> filteredCategories, required this.searchQuery, required this.isSearching}): _allCategories = allCategories,_filteredCategories = filteredCategories;
  

 final  List<Category> _allCategories;
 List<Category> get allCategories {
  if (_allCategories is EqualUnmodifiableListView) return _allCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_allCategories);
}

 final  List<Category> _filteredCategories;
 List<Category> get filteredCategories {
  if (_filteredCategories is EqualUnmodifiableListView) return _filteredCategories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredCategories);
}

 final  String searchQuery;
 final  bool isSearching;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryLoadedCopyWith<CategoryLoaded> get copyWith => _$CategoryLoadedCopyWithImpl<CategoryLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryLoaded&&const DeepCollectionEquality().equals(other._allCategories, _allCategories)&&const DeepCollectionEquality().equals(other._filteredCategories, _filteredCategories)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.isSearching, isSearching) || other.isSearching == isSearching));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_allCategories),const DeepCollectionEquality().hash(_filteredCategories),searchQuery,isSearching);

@override
String toString() {
  return 'CategoryState.loaded(allCategories: $allCategories, filteredCategories: $filteredCategories, searchQuery: $searchQuery, isSearching: $isSearching)';
}


}

/// @nodoc
abstract mixin class $CategoryLoadedCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory $CategoryLoadedCopyWith(CategoryLoaded value, $Res Function(CategoryLoaded) _then) = _$CategoryLoadedCopyWithImpl;
@useResult
$Res call({
 List<Category> allCategories, List<Category> filteredCategories, String searchQuery, bool isSearching
});




}
/// @nodoc
class _$CategoryLoadedCopyWithImpl<$Res>
    implements $CategoryLoadedCopyWith<$Res> {
  _$CategoryLoadedCopyWithImpl(this._self, this._then);

  final CategoryLoaded _self;
  final $Res Function(CategoryLoaded) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? allCategories = null,Object? filteredCategories = null,Object? searchQuery = null,Object? isSearching = null,}) {
  return _then(CategoryLoaded(
allCategories: null == allCategories ? _self._allCategories : allCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,filteredCategories: null == filteredCategories ? _self._filteredCategories : filteredCategories // ignore: cast_nullable_to_non_nullable
as List<Category>,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,isSearching: null == isSearching ? _self.isSearching : isSearching // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class CategoryError implements CategoryState {
  const CategoryError({required this.message});
  

 final  String message;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryErrorCopyWith<CategoryError> get copyWith => _$CategoryErrorCopyWithImpl<CategoryError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'CategoryState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $CategoryErrorCopyWith<$Res> implements $CategoryStateCopyWith<$Res> {
  factory $CategoryErrorCopyWith(CategoryError value, $Res Function(CategoryError) _then) = _$CategoryErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$CategoryErrorCopyWithImpl<$Res>
    implements $CategoryErrorCopyWith<$Res> {
  _$CategoryErrorCopyWithImpl(this._self, this._then);

  final CategoryError _self;
  final $Res Function(CategoryError) _then;

/// Create a copy of CategoryState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(CategoryError(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
