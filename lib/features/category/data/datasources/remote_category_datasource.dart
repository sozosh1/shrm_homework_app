import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/category/data/models/category/category.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class RemoteCategoryDataSource {
  Future<List<Category>> getCategories();
  Future<List<Category>> getCategoriesByType(bool isIncome);
}

@LazySingleton(as: RemoteCategoryDataSource)
class RemoteCategoryDataSourceImpl implements RemoteCategoryDataSource {
  final DioClient _dioClient;
  final Talker _talker;

  RemoteCategoryDataSourceImpl(this._dioClient, this._talker);

  @override
  Future<List<Category>> getCategories() async {
    try {
      final response = await _dioClient.get('/categories');
      return (response.data as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка получения категорий');
      rethrow;
    }
  }

  @override
  Future<List<Category>> getCategoriesByType(bool isIncome) async {
    try {
      final response = await _dioClient.get('/categories/type/$isIncome');
      return (response.data as List)
          .map((json) => Category.fromJson(json))
          .toList();
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка получения категорий по типу');
      rethrow;
    }
  }
}
