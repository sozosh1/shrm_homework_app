import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';


@Injectable(as: CategoryRepository)
class LocalCategoryRepository implements CategoryRepository {
  final AppDatabase _database;

  LocalCategoryRepository(this._database);

  @override
  Future<List<Category>> getAllCategories() async {
   
    final categories =
        await (_database.select(_database.categoriesTable)).get();

   
    return categories.map((category) {
      return Category(
        id: category.id,
        name: category.name,
        emodji: category.emodji,
        isIncome: category.isIncome,
      );
    }).toList();
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    
    final query = _database.select(_database.categoriesTable)
      ..where((t) => t.isIncome.equals(isIncome));
    
    
    final categories = await query.get();

    
    return categories.map((category) {
      return Category(
        id: category.id,
        name: category.name,
        emodji: category.emodji,
        isIncome: category.isIncome,
      );
    }).toList();
  }
}
