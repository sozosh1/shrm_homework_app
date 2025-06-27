// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryEvent {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryEvent);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryEvent()';
}


}

/// @nodoc
class $CategoryEventCopyWith<$Res>  {
$CategoryEventCopyWith(CategoryEvent _, $Res Function(CategoryEvent) __);
}


/// @nodoc


class LoadCategories implements CategoryEvent {
  const LoadCategories();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LoadCategories);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryEvent.loadCategories()';
}


}




/// @nodoc


class SearchCategories implements CategoryEvent {
  const SearchCategories({required this.query});
  

 final  String query;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SearchCategoriesCopyWith<SearchCategories> get copyWith => _$SearchCategoriesCopyWithImpl<SearchCategories>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SearchCategories&&(identical(other.query, query) || other.query == query));
}


@override
int get hashCode => Object.hash(runtimeType,query);

@override
String toString() {
  return 'CategoryEvent.searchCategories(query: $query)';
}


}

/// @nodoc
abstract mixin class $SearchCategoriesCopyWith<$Res> implements $CategoryEventCopyWith<$Res> {
  factory $SearchCategoriesCopyWith(SearchCategories value, $Res Function(SearchCategories) _then) = _$SearchCategoriesCopyWithImpl;
@useResult
$Res call({
 String query
});




}
/// @nodoc
class _$SearchCategoriesCopyWithImpl<$Res>
    implements $SearchCategoriesCopyWith<$Res> {
  _$SearchCategoriesCopyWithImpl(this._self, this._then);

  final SearchCategories _self;
  final $Res Function(SearchCategories) _then;

/// Create a copy of CategoryEvent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? query = null,}) {
  return _then(SearchCategories(
query: null == query ? _self.query : query // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ClearSearch implements CategoryEvent {
  const ClearSearch();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ClearSearch);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'CategoryEvent.clearSearch()';
}


}




// dart format on
