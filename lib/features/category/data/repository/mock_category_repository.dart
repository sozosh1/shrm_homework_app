import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';

@Named('mock')
//@Injectable(as: CategoryRepository)
class MockCategoryRepository implements CategoryRepository {
  @override
  Future<List<Category>> getCategories() async {
    return [
      Category(id: 1, name: 'Salary', emoji: '🤑', isIncome: true),
      Category(id: 2, name: 'Grocery list', emoji: '🥑', isIncome: false),
      Category(id: 3, name: 'Sport', emoji: '🤸🏽‍♀️', isIncome: false),
    ];
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    final allCategories = await getCategories();
    return allCategories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }
}
