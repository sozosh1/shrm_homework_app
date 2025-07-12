import 'dart:convert';
import 'package:worker_manager/worker_manager.dart';

/// Класс для десериализации JSON через изоляты
/// Использует worker_manager для выполнения десериализации в отдельном изоляте
class IsolateDeserializer {
  /// Десериализация одного объекта через изолят
  static Future<T> deserialize<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cancelable = workerManager.execute<T>(() async {
      final map = jsonDecode(json) as Map<String, dynamic>;
      return fromJson(map);
    });
    return await cancelable;
  }

  /// Десериализация списка объектов через изолят
  static Future<List<T>> deserializeList<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    final cancelable = workerManager.execute<List<T>>(() async {
      final list = jsonDecode(json) as List;
      return list.map((e) => fromJson(e as Map<String, dynamic>)).toList();
    });
    return await cancelable;
  }

  /// Десериализация с проверкой типа данных
  static Future<T?> deserializeSafe<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final cancelable = workerManager.execute<T?>(() async {
        final data = jsonDecode(json);
        if (data is Map<String, dynamic>) {
          return fromJson(data);
        }
        return null;
      });
      return await cancelable;
    } catch (e) {
      return null;
    }
  }

  /// Десериализация списка с проверкой типа данных
  static Future<List<T>> deserializeListSafe<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    try {
      final cancelable = workerManager.execute<List<T>>(() async {
        final data = jsonDecode(json);
        if (data is List) {
          return data
              .whereType<Map<String, dynamic>>()
              .map((e) => fromJson(e))
              .toList();
        }
        return <T>[];
      });
      return await cancelable;
    } catch (e) {
      return <T>[];
    }
  }
} 