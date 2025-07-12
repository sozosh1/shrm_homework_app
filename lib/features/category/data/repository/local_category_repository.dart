import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';

@injectable
class LocalCategoryRepository {
  final AppDatabase _database;

  LocalCategoryRepository(this._database);

  Future<List<Category>> getAllCategories() async {
    final categories =
        await (_database.select(_database.categoriesTable)).get();

    return categories.map((category) {
      return Category(
        id: category.id,
        name: category.name,
        emoji: category.emoji,
        isIncome: category.isIncome,
      );
    }).toList();
  }

  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    final query = _database.select(_database.categoriesTable)
      ..where((t) => t.isIncome.equals(isIncome));

    final categories = await query.get();

    return categories.map((category) {
      return Category(
        id: category.id,
        name: category.name,
        emoji: category.emoji,
        isIncome: category.isIncome,
      );
    }).toList();
  }

  /// Очищает все категории из локальной базы данных
  Future<void> clearAllCategories() async {
    await _database.delete(_database.categoriesTable).go();
  }

  /// Создает новую категорию в локальной базе данных
  Future<Category> createCategory(
      String name, String emoji, bool isIncome) async {
    final categoryData = await _database.into(_database.categoriesTable).insertReturning(
      CategoriesTableCompanion.insert(
        name: name,
        emoji: emoji,
        isIncome: isIncome,
      ),
    );

    return Category(
      id: categoryData.id,
      name: categoryData.name,
      emoji: categoryData.emoji,
      isIncome: categoryData.isIncome,
    );
  }

  /// Получает категорию по ID
  Future<Category?> getCategoryById(int id) async {
    final query = _database.select(_database.categoriesTable)
      ..where((t) => t.id.equals(id));

    final category = await query.getSingleOrNull();

    if (category == null) return null;

    return Category(
      id: category.id,
      name: category.name,
      emoji: category.emoji,
      isIncome: category.isIncome,
    );
  }
}
