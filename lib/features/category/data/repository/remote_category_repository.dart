import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Удаленный источник данных для категорий (API)
@injectable
class RemoteCategoryRepository {
  final DioClient _dio;
  final Talker _talker;

  RemoteCategoryRepository(this._dio, this._talker);

  /// Получает все категории с сервера
  Future<List<Category>> getAllCategories() async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для получения всех категорий');
    
    try {
      final response = await _dio.get('/categories');
      _talker.info('✅ RemoteCategoryRepository: Получен ответ сервера для всех категорий');
      _talker.debug('📄 RemoteCategoryRepository: Response data: ${response.data}');
      
      final List<dynamic> categoriesJson = response.data as List<dynamic>;
      final categories = categoriesJson
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _talker.info('✅ RemoteCategoryRepository: Десериализовано ${categories.length} категорий');
      return categories;
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка получения всех категорий', e, st);
      rethrow;
    }
  }

  /// Получает конкретную категорию по ID
  Future<Category> getCategory(int id) async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для получения категории ID: $id');
    
    try {
      final response = await _dio.get('/categories/$id');
      _talker.info('✅ RemoteCategoryRepository: Получен ответ сервера для категории $id');
      _talker.debug('📄 RemoteCategoryRepository: Response data: ${response.data}');
      
      final category = Category.fromJson(response.data as Map<String, dynamic>);
      _talker.info('✅ RemoteCategoryRepository: Десериализована категория "${category.name}"');
      return category;
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка получения категории $id', e, st);
      rethrow;
    }
  }

  /// Создает новую категорию на сервере
  Future<Category> createCategory(Category category) async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для создания категории "${category.name}"');
    _talker.debug('📄 RemoteCategoryRepository: Request data: ${category.toJson()}');
    
    try {
      final response = await _dio.post(
        '/categories',
        data: category.toJson(),
      );
      _talker.info('✅ RemoteCategoryRepository: Получен ответ сервера для создания категории');
      _talker.debug('📄 RemoteCategoryRepository: Response data: ${response.data}');
      
      final createdCategory = Category.fromJson(response.data as Map<String, dynamic>);
      _talker.info('✅ RemoteCategoryRepository: Создана категория "${createdCategory.name}" с ID: ${createdCategory.id}');
      return createdCategory;
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка создания категории "${category.name}"', e, st);
      rethrow;
    }
  }

  /// Обновляет категорию на сервере
  Future<Category> updateCategory(int id, Category category) async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для обновления категории ID: $id');
    _talker.debug('📄 RemoteCategoryRepository: Request data: ${category.toJson()}');
    
    try {
      final response = await _dio.put(
        '/categories/$id',
        data: category.toJson(),
      );
      _talker.info('✅ RemoteCategoryRepository: Получен ответ сервера для обновления категории $id');
      _talker.debug('📄 RemoteCategoryRepository: Response data: ${response.data}');
      
      final updatedCategory = Category.fromJson(response.data as Map<String, dynamic>);
      _talker.info('✅ RemoteCategoryRepository: Обновлена категория "${updatedCategory.name}" с ID: ${updatedCategory.id}');
      return updatedCategory;
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка обновления категории $id', e, st);
      rethrow;
    }
  }

  /// Удаляет категорию на сервере
  Future<void> deleteCategory(int id) async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для удаления категории ID: $id');
    
    try {
      await _dio.delete('/categories/$id');
      _talker.info('✅ RemoteCategoryRepository: Категория $id успешно удалена на сервере');
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка удаления категории $id', e, st);
      rethrow;
    }
  }

  /// Получает категории по типу (доходы/расходы)
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    _talker.info('🌐 RemoteCategoryRepository: Отправляем запрос для получения категорий типа: ${isIncome ? "доходы" : "расходы"}');
    
    try {
      final response = await _dio.get('/categories', queryParameters: {
        'isIncome': isIncome,
      });
      _talker.info('✅ RemoteCategoryRepository: Получен ответ сервера для категорий типа ${isIncome ? "доходы" : "расходы"}');
      _talker.debug('📄 RemoteCategoryRepository: Response data: ${response.data}');
      
      final List<dynamic> categoriesJson = response.data as List<dynamic>;
      final categories = categoriesJson
          .map((json) => Category.fromJson(json as Map<String, dynamic>))
          .toList();
      
      _talker.info('✅ RemoteCategoryRepository: Десериализовано ${categories.length} категорий типа ${isIncome ? "доходы" : "расходы"}');
      return categories;
    } catch (e, st) {
      _talker.error('❌ RemoteCategoryRepository: Ошибка получения категорий типа ${isIncome ? "доходы" : "расходы"}', e, st);
      rethrow;
    }
  }
}
