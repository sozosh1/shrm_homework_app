import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/sync_event_service.dart';
import 'package:shrm_homework_app/features/category/data/datasources/local_category_data_source.dart';
import 'package:shrm_homework_app/features/category/data/datasources/remote_category_datasource.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:shrm_homework_app/features/category/domain/repository/category_repository.dart';

@Injectable(as: CategoryRepository)
class CategoryRepositoryImpl implements CategoryRepository {
  final LocalCategoryDataSource _localDataSource;
  final RemoteCategoryDataSource _remoteDataSource;
  final SyncEventService _syncEventService;

  CategoryRepositoryImpl(
    this._localDataSource,
    this._remoteDataSource,
    this._syncEventService,
  );

  @override
  Future<List<Category>> getCategories() async {
    await _processSyncEvents();
    final localCategories = await _localDataSource.getCategories();
    try {
      final remoteCategories = await _remoteDataSource.getCategories();
      await _localDataSource.saveCategories(remoteCategories);
      return remoteCategories;
    } catch (e) {
      return localCategories;
    }
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    await _processSyncEvents();
    final localCategories = await _localDataSource.getCategoriesByType(
      isIncome,
    );
    try {
      final remoteCategories = await _remoteDataSource.getCategoriesByType(
        isIncome,
      );
      await _localDataSource.saveCategories(remoteCategories);
      return remoteCategories;
    } catch (e) {
      return localCategories;
    }
  }

  Future<void> _processSyncEvents() async {
    final events = await _syncEventService.getEvents();
    for (final event in events) {
      try {
        if (event.entityType == EntityType.category) {
          // For categories, we typically only sync by fetching all and replacing.
          // So we might not need to process individual events.
          // This is a placeholder for potential future logic.
        }
        await _syncEventService.deleteEvent(event.id);
      } catch (e) {
        // TODO: Handle error
      }
    }
  }
}
