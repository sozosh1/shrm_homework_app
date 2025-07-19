import 'dart:math';

import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';

import 'package:shrm_homework_app/core/network/connectivity_service.dart';
import 'package:shrm_homework_app/core/network/json_parsing_transformer.dart';
import 'package:talker_flutter/talker_flutter.dart';

@singleton
class DioClient {
  final Dio _dio;
  final Talker _talker;
  final ConnectivityService _connectivity;

  static const String _baseUrl = 'https://shmr-finance.ru/api/v1';
  final String _bearerToken;

  DioClient(
    this._talker,
    @Named('bearerToken') this._bearerToken,
    this._connectivity,
  ) : _dio = Dio() {
    _setupInterceptors();
  }

  void _setupInterceptors() {
    // Базовые настройки
    _dio.options.baseUrl = _baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 10);
    _dio.options.receiveTimeout = const Duration(seconds: 10);
    _dio.options.sendTimeout = const Duration(seconds: 10);

    // Interceptor для авторизации и логирования
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          // Добавляем авторизацию ко всем запросам
          options.headers['Authorization'] = 'Bearer $_bearerToken';
          options.headers['Content-Type'] = 'application/json';
          options.headers['Accept'] = 'application/json';

          _talker.debug('🌐 ${options.method} ${options.path}');
          if (options.data != null) {
            _talker.debug('📤 Request data: ${options.data}');
          }

          handler.next(options);
        },
        onResponse: (response, handler) {
          _talker.info(
            '✅ ${response.statusCode} ${response.requestOptions.path}',
          );
          _talker.debug('📥 Response data: ${response.data}');
          handler.next(response);
        },
        onError: (error, handler) {
          _talker.error(
            '❌ ${error.response?.statusCode} ${error.requestOptions.path}',
            error,
          );
          handler.next(error);
        },
      ),
    );

    // Transformer для десериализации через изоляты
    _dio.transformer = JsonParsingTransformer(_talker);

    // Interceptor для ретраев с exponential backoff
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        talker: _talker,
        retries: 3,
        baseDelay: const Duration(seconds: 1),
      ),
    );
    // Removed general pending add, handled in repositories
  }

  Future<Response<T>> get<T>(
    String path, {
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.get<T>(
        path,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      _talker.error('GET request failed: $path', e);
      rethrow;
    }
  }

  Future<Response<T>> post<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.post<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      _talker.error('POST request failed: $path', e);
      rethrow;
    }
  }

  Future<Response<T>> put<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.put<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      _talker.error('PUT request failed: $path', e);
      rethrow;
    }
  }

  Future<Response<T>> delete<T>(
    String path, {
    dynamic data,
    Map<String, dynamic>? queryParameters,
    Options? options,
  }) async {
    try {
      final response = await _dio.delete<T>(
        path,
        data: data,
        queryParameters: queryParameters,
        options: options,
      );
      return response;
    } on DioException catch (e) {
      _talker.error('DELETE request failed: $path', e);
      rethrow;
    }
  }
}

// Кастомный интерсептор для ретраев с exponential backoff
class RetryInterceptor extends Interceptor {
  final Dio dio;
  final Talker talker;
  final int retries;
  final Duration baseDelay;

  RetryInterceptor({
    required this.dio,
    required this.talker,
    this.retries = 3,
    this.baseDelay = const Duration(seconds: 1),
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    final statusCode = err.response?.statusCode;
    if (statusCode != null && _shouldRetry(statusCode)) {
      err.requestOptions.extra ??= {};
      int retryCount = (err.requestOptions.extra['retryCount'] as int? ?? 0);
      if (retryCount < retries) {
        retryCount++;
        err.requestOptions.extra['retryCount'] = retryCount;

        final delay = baseDelay * pow(2, retryCount - 1);
        talker.info(
          '🔄 Retry $retryCount/$retries for $statusCode after ${delay.inSeconds}s',
        );

        await Future.delayed(delay);
        try {
          final response = await dio.fetch(err.requestOptions);
          return handler.resolve(response);
        } catch (e) {
          return handler.next(err);
        }
      }
    }
    return handler.next(err);
  }

  bool _shouldRetry(int? statusCode) {
    return [500, 502, 503, 504, 408, 429].contains(statusCode);
  }
}
