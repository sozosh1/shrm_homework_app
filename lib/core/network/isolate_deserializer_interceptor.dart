import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'isolate_deserializer.dart';

/// Интерсептор для автоматической десериализации JSON ответов через изоляты
class IsolateDeserializerInterceptor extends Interceptor {
  final Talker _talker;

  IsolateDeserializerInterceptor(this._talker);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      // Проверяем, что ответ содержит JSON данные
      if (response.data is String && _isJsonString(response.data)) {
        _talker.debug(
          '🔄 Десериализация JSON через изолят: ${response.requestOptions.path}',
        );

        // Сохраняем оригинальные данные
        final originalData = response.data;

        // Десериализуем через изолят
        final deserializedData = await IsolateDeserializer.deserializeSafe(
          originalData,
          (json) => json, // Простая десериализация в Map
        );

        if (deserializedData != null) {
          response.data = deserializedData;
          _talker.debug('✅ Десериализация завершена успешно');
        } else {
          _talker.warning(
            '⚠️ Не удалось десериализовать JSON через изолят, используем стандартную десериализацию',
          );
        }
      }
    } catch (e, st) {
      _talker.error('❌ Ошибка при десериализации через изолят', e, st);
      // В случае ошибки продолжаем с оригинальными данными
    }

    handler.next(response);
  }

  /// Проверяет, является ли строка JSON
  bool _isJsonString(String str) {
    try {
      final trimmed = str.trim();
      return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'));
    } catch (e) {
      return false;
    }
  }
}

/// Расширенный интерсептор с поддержкой типизированной десериализации
class TypedIsolateDeserializerInterceptor extends Interceptor {
  final Talker _talker;
  final Map<String, dynamic Function(Map<String, dynamic>)> _typeFactories;

  TypedIsolateDeserializerInterceptor(this._talker, this._typeFactories);

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {
    try {
      final path = response.requestOptions.path;
      final factory = _typeFactories[path];

      if (factory != null &&
          response.data is String &&
          _isJsonString(response.data)) {
        _talker.debug('🔄 Типизированная десериализация через изолят: $path');

        final originalData = response.data;

        // Десериализуем с использованием фабрики
        final deserializedData = await IsolateDeserializer.deserializeSafe(
          originalData,
          factory,
        );

        if (deserializedData != null) {
          response.data = deserializedData;
          _talker.debug('✅ Типизированная десериализация завершена успешно');
        } else {
          _talker.warning(
            '⚠️ Не удалось десериализовать с типизацией, используем стандартную десериализацию',
          );
        }
      }
    } catch (e, st) {
      _talker.error(
        '❌ Ошибка при типизированной десериализации через изолят',
        e,
        st,
      );
    }

    handler.next(response);
  }

  /// Проверяет, является ли строка JSON
  bool _isJsonString(String str) {
    try {
      final trimmed = str.trim();
      return (trimmed.startsWith('{') && trimmed.endsWith('}')) ||
          (trimmed.startsWith('[') && trimmed.endsWith(']'));
    } catch (e) {
      return false;
    }
  }
}
