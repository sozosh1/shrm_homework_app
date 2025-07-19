import 'package:shrm_homework_app/features/category/data/models/category/category.dart';

abstract class CategoryRepository {
  Future<List<Category>> getCategories();
  Future<List<Category>> getCategoriesByType(bool isIncome);
}
