import 'package:freezed_annotation/freezed_annotation.dart';

part 'category_event.freezed.dart';

@freezed
abstract class CategoryEvent with _$CategoryEvent {
  const factory CategoryEvent.loadCategories() = LoadCategories;
  const factory CategoryEvent.searchCategories({required String query}) = SearchCategories;
  const factory CategoryEvent.clearSearch() = ClearSearch;
}