import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';

part 'category_state.freezed.dart';

@freezed
abstract class CategoryState with _$CategoryState {
  const factory CategoryState.initial() = CategoryInitial;
  const factory CategoryState.loading() = CategoryLoading;
  const factory CategoryState.loaded({
    required List<Category> allCategories,
    required List<Category> filteredCategories,
    required String searchQuery,
    required bool isSearching,
  }) = CategoryLoaded;
  const factory CategoryState.error({required String message}) = CategoryError;
}