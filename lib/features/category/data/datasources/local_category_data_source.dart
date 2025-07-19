import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class LocalCategoryDataSource {
  Future<List<Category>> getCategories();
  Future<List<Category>> getCategoriesByType(bool isIncome);
  Future<void> saveCategories(List<Category> categories);
}

@LazySingleton(as: LocalCategoryDataSource)
class LocalCategoryDataSourceImpl implements LocalCategoryDataSource {
  final AppDatabase _database;
  final Talker _talker;

  LocalCategoryDataSourceImpl(this._database, this._talker);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final dbCategories =
          await _database.select(_database.categoriesTable).get();
      return dbCategories
          .map(
            (db) => Category(
              id: db.id,
              name: db.name,
              emoji: db.emoji,
              isIncome: db.isIncome,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      _talker.error('Failed to get categories from local DB', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> saveCategories(List<Category> categories) async {
    await _database.transaction(() async {
      for (final cat in categories) {
        await _database
            .into(_database.categoriesTable)
            .insertOnConflictUpdate(
              CategoriesTableCompanion.insert(
                id: Value(cat.id),
                name: cat.name,
                emoji: cat.emoji,
                isIncome: cat.isIncome,
              ),
            );
      }
    });
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    try {
      final query = _database.select(_database.categoriesTable)
        ..where((tbl) => tbl.isIncome.equals(isIncome));
      final dbCategories = await query.get();
      return dbCategories
          .map(
            (db) => Category(
              id: db.id,
              name: db.name,
              emoji: db.emoji,
              isIncome: db.isIncome,
            ),
          )
          .toList();
    } catch (e, stackTrace) {
      _talker.error(
        'Failed to get categories by type from local DB',
        e,
        stackTrace,
      );
      rethrow;
    }
  }
}
