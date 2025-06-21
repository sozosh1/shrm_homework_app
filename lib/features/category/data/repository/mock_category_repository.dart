import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';

@Injectable(as: CategoryRepository)
class MockCategoryRepository implements CategoryRepository {
  @override
  Future<List<Category>> getAllCategories() async {
    return [
      Category(id: 1, name: 'Salary', emodji: '🤑', isIncome: true),
      Category(id: 2, name: 'Grocery list', emodji: '🥑', isIncome: false),
      Category(id: 3, name: 'Sport', emodji: '🤸🏽‍♀️', isIncome: false),
    ];
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    final allCategories = await getAllCategories();
    return allCategories
        .where((category) => category.isIncome == isIncome)
        .toList();
  }
}
