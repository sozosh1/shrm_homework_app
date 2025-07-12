import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Сервис для инициализации данных приложения
@injectable
class InitializationService {
  final CategoryRepository _categoryRepository;
  final ConnectivityService _connectivityService;
  final AppDatabase _database;
  final Talker _talker;

  InitializationService(
    this._categoryRepository,
    this._connectivityService,
    this._database,
    this._talker,
  );

  /// Инициализирует категории из API при первом запуске
  Future<void> initializeCategories() async {
    try {
      _talker.info('🚀 InitializationService: Начинаем инициализацию категорий');
      
      // Проверяем, есть ли уже категории в базе
      final existingCategories = await _categoryRepository.getAllCategories();
      
      if (existingCategories.isEmpty) {
        _talker.info('📂 InitializationService: Категории отсутствуют, загружаем с API');
        
        if (await _connectivityService.isConnected) {
          try {
            // Пытаемся загрузить категории с API
            final apiCategories = await _categoryRepository.getAllCategories();
            if (apiCategories.isNotEmpty) {
              _talker.info('✅ InitializationService: Загружено ${apiCategories.length} категорий с API');
            } else {
              _talker.info('📂 InitializationService: API вернул пустой список, используем fallback');
              await _insertFallbackCategories();
            }
          } catch (e) {
            _talker.warning('⚠️ InitializationService: Не удалось загрузить категории с API', e);
            await _insertFallbackCategories();
          }
        } else {
          _talker.info('📱 InitializationService: Нет интернета, используем fallback категории');
          await _insertFallbackCategories();
        }
      } else {
        _talker.info('✅ InitializationService: Найдено ${existingCategories.length} существующих категорий');
      }
    } catch (e, st) {
      _talker.error('❌ InitializationService: Ошибка инициализации категорий', e, st);
      await _insertFallbackCategories();
    }
  }

  /// Вставляет резервные категории, если не удалось загрузить с API
  Future<void> _insertFallbackCategories() async {
    try {
      _talker.info('📝 InitializationService: Вставляем резервные категории');
      
      // Используем fallback метод из AppDatabase
      await _database.insertFallbackCategories();
      
      _talker.info('✅ InitializationService: Резервные категории вставлены');
    } catch (e, st) {
      _talker.error('❌ InitializationService: Ошибка вставки резервных категорий', e, st);
      rethrow;
    }
  }
}
