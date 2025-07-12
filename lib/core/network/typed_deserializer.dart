import 'isolate_deserializer.dart';

/// Утилитарный класс для типизированной десериализации через изоляты
/// Предоставляет удобные методы для работы с различными типами данных
class TypedDeserializer {
  /// Десериализация транзакций
  static Future<List<T>> deserializeTransactions<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeListSafe(json, fromJson);
  }

  /// Десериализация одной транзакции
  static Future<T?> deserializeTransaction<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeSafe(json, fromJson);
  }

  /// Десериализация счетов
  static Future<List<T>> deserializeAccounts<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeListSafe(json, fromJson);
  }

  /// Десериализация одного счета
  static Future<T?> deserializeAccount<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeSafe(json, fromJson);
  }

  /// Десериализация категорий
  static Future<List<T>> deserializeCategories<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeListSafe(json, fromJson);
  }

  /// Десериализация одной категории
  static Future<T?> deserializeCategory<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeSafe(json, fromJson);
  }

  /// Универсальная десериализация списка
  static Future<List<T>> deserializeList<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeListSafe(json, fromJson);
  }

  /// Универсальная десериализация объекта
  static Future<T?> deserializeObject<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    return await IsolateDeserializer.deserializeSafe(json, fromJson);
  }

  /// Десериализация с обработкой ошибок
  static Future<T?> deserializeWithErrorHandling<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
    Function(String) onError,
  ) async {
    try {
      return await IsolateDeserializer.deserializeSafe(json, fromJson);
    } catch (e) {
      onError('Ошибка десериализации: $e');
      return null;
    }
  }

  /// Десериализация списка с обработкой ошибок
  static Future<List<T>> deserializeListWithErrorHandling<T>(
    String json,
    T Function(Map<String, dynamic>) fromJson,
    Function(String) onError,
  ) async {
    try {
      return await IsolateDeserializer.deserializeListSafe(json, fromJson);
    } catch (e) {
      onError('Ошибка десериализации списка: $e');
      return <T>[];
    }
  }
} 