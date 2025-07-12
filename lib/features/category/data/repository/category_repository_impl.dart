import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/backup_sync_service.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:shrm_homework_app/features/category/data/repository/local_category_repository.dart';
import 'package:shrm_homework_app/features/category/data/repository/remote_category_repository.dart';
import 'package:shrm_homework_app/features/category/domain/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Основная реализация CategoryRepository с offline-first подходом
@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final LocalCategoryRepository _localRepository;
  final RemoteCategoryRepository _remoteRepository;
  final ConnectivityService _connectivityService;
  final BackupSyncService _backupSyncService;
  final Talker _talker;

  CategoryRepositoryImpl(
    this._localRepository,
    this._remoteRepository,
    this._connectivityService,
    this._backupSyncService,
    this._talker,
  );

  @override
  Future<List<Category>> getAllCategories() async {
    _talker.info('🎯 CategoryRepositoryImpl: Получение всех категорий (offline-first)');
    
    try {
      // 1. Пытаемся синхронизировать несинхронизированные операции
      await _trySync();
      
      // 2. Если есть интернет, получаем данные с сервера
      if (await _connectivityService.isConnected) {
        _talker.info('🌐 CategoryRepositoryImpl: Интернет доступен, получаем данные с сервера');
        try {
          final remoteCategories = await _remoteRepository.getAllCategories();
          _talker.info('✅ CategoryRepositoryImpl: Получено ${remoteCategories.length} категорий с сервера');
          
          // Обновляем локальные данные после успешного получения с сервера
          await _updateLocalFromRemote(remoteCategories);
          
          return remoteCategories;
        } catch (e) {
          _talker.warning('⚠️ CategoryRepositoryImpl: Ошибка получения с сервера, используем локальные данные', e);
          return await _localRepository.getAllCategories();
        }
      } else {
        _talker.info('📱 CategoryRepositoryImpl: Нет интернета, используем локальные данные');
        return await _localRepository.getAllCategories();
      }
    } catch (e, st) {
      _talker.error('❌ CategoryRepositoryImpl: Критическая ошибка получения категорий', e, st);
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    _talker.info('🎯 CategoryRepositoryImpl: Получение категорий типа ${isIncome ? "доходы" : "расходы"} (offline-first)');
    
    try {
      await _trySync();
      
      if (await _connectivityService.isConnected) {
        _talker.info('🌐 CategoryRepositoryImpl: Интернет доступен, получаем категории с сервера');
        try {
          final remoteCategories = await _remoteRepository.getCategoriesByType(isIncome);
          _talker.info('✅ CategoryRepositoryImpl: Получено ${remoteCategories.length} категорий типа ${isIncome ? "доходы" : "расходы"} с сервера');
          return remoteCategories;
        } catch (e) {
          _talker.warning('⚠️ CategoryRepositoryImpl: Ошибка получения с сервера, используем локальные', e);
          return await _localRepository.getCategoriesByType(isIncome);
        }
      } else {
        return await _localRepository.getCategoriesByType(isIncome);
      }
    } catch (e, st) {
      _talker.error('❌ CategoryRepositoryImpl: Критическая ошибка получения категорий по типу', e, st);
      rethrow;
    }
  }

  /// Пытается синхронизировать все несинхронизированные операции
  Future<void> _trySync() async {
    try {
      if (await _connectivityService.isConnected) {
        _talker.info('🔄 CategoryRepositoryImpl: Начинаем синхронизацию');
        
        final pendingCount = await _backupSyncService.getPendingOperationsCount();
        if (pendingCount > 0) {
          _talker.info('📋 CategoryRepositoryImpl: Найдено $pendingCount несинхронизированных операций');
          
          final success = await _backupSyncService.syncAllOperations();
          if (success) {
            _talker.info('✅ CategoryRepositoryImpl: Синхронизация завершена успешно');
          } else {
            _talker.warning('⚠️ CategoryRepositoryImpl: Синхронизация завершена с ошибками');
          }
        }
      }
    } catch (e, st) {
      _talker.warning('⚠️ CategoryRepositoryImpl: Ошибка при попытке синхронизации', e, st);
    }
  }

  /// Обновляет локальные данные на основе данных с сервера
  Future<void> _updateLocalFromRemote(List<Category> remoteCategories) async {
    try {
      _talker.info('🔄 CategoryRepositoryImpl: Обновляем локальные данные на основе серверных');
      
      if (remoteCategories.isNotEmpty) {
        // Очищаем все локальные категории
        await _localRepository.clearAllCategories();
        
        // Вставляем новые категории с сервера
        for (final category in remoteCategories) {
          await _localRepository.createCategory(category.name, category.emoji, category.isIncome);
        }
        
        _talker.info('✅ CategoryRepositoryImpl: Обновлено ${remoteCategories.length} категорий в локальной базе');
      }
      
    } catch (e, st) {
      _talker.warning('⚠️ CategoryRepositoryImpl: Ошибка обновления локальных данных', e, st);
    }
  }

  /// Принудительная синхронизация
  Future<bool> forceSync() async {
    _talker.info('🔄 CategoryRepositoryImpl: Принудительная синхронизация');
    try {
      return await _backupSyncService.syncAllOperations();
    } catch (e, st) {
      _talker.error('❌ CategoryRepositoryImpl: Ошибка принудительной синхронизации', e, st);
      return false;
    }
  }

  /// Получает количество несинхронизированных операций
  Future<int> getPendingOperationsCount() async {
    try {
      return await _backupSyncService.getPendingOperationsCount();
    } catch (e, st) {
      _talker.warning('⚠️ CategoryRepositoryImpl: Ошибка получения количества операций', e, st);
      return 0;
    }
  }
}
