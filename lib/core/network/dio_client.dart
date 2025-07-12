import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'isolate_deserializer_interceptor.dart';

@singleton
class DioClient {
  final Dio _dio;
  final Talker _talker;
  static const String _baseUrl = 'https://shmr-finance.ru/api/v1';
  final String _bearerToken;

  DioClient(this._talker, @Named('bearerToken') this._bearerToken)
    : _dio = Dio() {
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

    // Interceptor для десериализации через изоляты
    _dio.interceptors.add(
      IsolateDeserializerInterceptor(_talker),
    );

    // Interceptor для ретраев с exponential backoff
    _dio.interceptors.add(
      RetryInterceptor(
        dio: _dio,
        talker: _talker,
        retries: 3,
        baseDelay: const Duration(seconds: 1), 
      ),
    );
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
    this.baseDelay = const Duration(seconds: 1), // Базовая задержка
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    var extra = err.requestOptions.extra;
    var attempt = extra['retry_attempt'] ?? 0;

    // Проверяем, нужно ли делать retry
    if (attempt < retries && _shouldRetry(err)) {
      attempt++;
      extra['retry_attempt'] = attempt;
      err.requestOptions.extra = extra;

      
      // Формула: baseDelay * (2^attempt) + jitter
      final exponentialDelay =
          baseDelay.inMilliseconds * (1 << attempt); // 2^attempt
      final jitter =
          (exponentialDelay * 0.1 * (DateTime.now().millisecond % 100) / 100)
              .round();
      final totalDelay = Duration(milliseconds: exponentialDelay + jitter);

      talker.warning(
        '🔄 Retry attempt $attempt/$retries after ${totalDelay.inMilliseconds}ms for ${err.requestOptions.path}',
      );

      await Future.delayed(totalDelay);

      try {
        // Повторяем запрос
        final response = await dio.fetch(err.requestOptions);
        handler.resolve(response);
        return;
      } on DioException catch (e) {
        // Если retry тоже не удался, продолжаем обработку ошибки
        super.onError(e, handler);
        return;
      }
    }

    // Если retries исчерпаны или не нужны
    super.onError(err, handler);
  }

  // Определяем, нужно ли делать retry для данной ошибки
  bool _shouldRetry(DioException error) {
 
    if (error.type == DioExceptionType.connectionTimeout ||
        error.type == DioExceptionType.receiveTimeout ||
        error.type == DioExceptionType.sendTimeout ||
        error.type == DioExceptionType.connectionError) {
      return true;
    }

    
    if (error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;

      return [500, 502, 503, 504, 408, 429].contains(statusCode);
    }

    return false;
  }
}
