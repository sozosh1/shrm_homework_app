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
    // 1. Получаем все записи из таблицы категорий.
    final categories =
        await (_database.select(_database.categoriesTable)).get();

    // 2. Преобразуем (мапим) каждую запись из формата таблицы (Drift)
    //    в формат доменной модели Category.
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
    // 1. Создаем запрос к таблице категорий с фильтром по полю isIncome.
    final query = _database.select(_database.categoriesTable)
      ..where((t) => t.isIncome.equals(isIncome));
    
    // 2. Выполняем запрос.
    final categories = await query.get();

    // 3. Так же, как и в первом методе, мапим результат в список доменных моделей.
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
