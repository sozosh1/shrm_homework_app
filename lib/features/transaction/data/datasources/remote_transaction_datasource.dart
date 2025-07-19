import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:intl/intl.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class RemoteTransactionDataSource {
  Future<TransactionResponse> getTransaction(int id);
  Future<TransactionResponse> createTransaction(TransactionRequest request);
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  );
  Future<void> deleteTransaction(int id);
  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId, {
    DateTime startDate,
    DateTime endDate,
  });
}

@LazySingleton(as: RemoteTransactionDataSource)
class RemoteTransactionDataSourceImpl implements RemoteTransactionDataSource {
  final DioClient _dioClient;
  final Talker _talker;

  RemoteTransactionDataSourceImpl(this._dioClient, this._talker);

  @override
  Future<TransactionResponse> getTransaction(int id) async {
    try {
      final response = await _dioClient.get('/transactions/$id');
      if (response.data == null) {
        throw Exception('API returned null data');
      }
      final json = response.data as Map<String, dynamic>;
      final modifiedJson = Map<String, dynamic>.from(json);

      // Проверяем обязательные поля
      if (modifiedJson['account'] == null) {
        throw Exception('API response missing required field: account');
      }
      if (modifiedJson['category'] == null) {
        throw Exception('API response missing required field: category');
      }

      if (modifiedJson['amount'] is String) {
        modifiedJson['amount'] =
            double.tryParse(modifiedJson['amount']) ?? 0.0;
      }

      if (modifiedJson['account'] is Map<String, dynamic>) {
        final account = Map<String, dynamic>.from(
          modifiedJson['account'],
        );
        if (account['id'] is String) {
          account['id'] = int.tryParse(account['id']) ?? 0;
        }
        if (account['balance'] is String) {
          account['balance'] = double.tryParse(account['balance']) ?? 0.0;
        }
        modifiedJson['account'] = account;
      } else {
        throw Exception('API response account field is not a valid object');
      }

      if (modifiedJson['category'] is! Map<String, dynamic>) {
        throw Exception('API response category field is not a valid object');
      }

      return TransactionResponse.fromJson(modifiedJson);
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка получения транзакции');
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> createTransaction(TransactionRequest request) async {
    try {
      final response = await _dioClient.post(
        '/transactions',
        data: request.toJson(),
      );
      if (response.data == null) {
        throw Exception('API returned null data');
      }
      
      // Проверяем, что response.data действительно Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception('API returned invalid data format: ${response.data.runtimeType}');
      }
      
      final json = response.data as Map<String, dynamic>;
      final modifiedJson = Map<String, dynamic>.from(json);

      if (modifiedJson['amount'] is String) {
        modifiedJson['amount'] =
            double.tryParse(modifiedJson['amount']) ?? 0.0;
      }

      if (modifiedJson['account'] is Map<String, dynamic>) {
        final account = Map<String, dynamic>.from(
          modifiedJson['account'],
        );
        if (account['id'] is String) {
          account['id'] = int.tryParse(account['id']) ?? 0;
        }
        if (account['balance'] is String) {
          account['balance'] = double.tryParse(account['balance']) ?? 0.0;
        }
        modifiedJson['account'] = account;
      }

      return TransactionResponse.fromJson(modifiedJson);
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка создания транзакции');
      rethrow;
    }
  }

  @override
  Future<TransactionResponse> updateTransaction(
    int id,
    TransactionRequest request,
  ) async {
    try {
      final response = await _dioClient.put(
        '/transactions/$id',
        data: request.toJson(),
      );
      if (response.data == null) {
        throw Exception('API returned null data');
      }
      
      // Проверяем, что response.data действительно Map
      if (response.data is! Map<String, dynamic>) {
        throw Exception('API returned invalid data format: ${response.data.runtimeType}');
      }
      
      final json = response.data as Map<String, dynamic>;
      final modifiedJson = Map<String, dynamic>.from(json);

      // Проверяем обязательные поля
      if (modifiedJson['account'] == null) {
        throw Exception('API response missing required field: account');
      }
      if (modifiedJson['category'] == null) {
        throw Exception('API response missing required field: category');
      }

      if (modifiedJson['amount'] is String) {
        modifiedJson['amount'] =
            double.tryParse(modifiedJson['amount']) ?? 0.0;
      }

      if (modifiedJson['account'] is Map<String, dynamic>) {
        final account = Map<String, dynamic>.from(
          modifiedJson['account'],
        );
        if (account['id'] is String) {
          account['id'] = int.tryParse(account['id']) ?? 0;
        }
        if (account['balance'] is String) {
          account['balance'] = double.tryParse(account['balance']) ?? 0.0;
        }
        modifiedJson['account'] = account;
      } else {
        throw Exception('API response account field is not a valid object');
      }

      if (modifiedJson['category'] is! Map<String, dynamic>) {
        throw Exception('API response category field is not a valid object');
      }

      return TransactionResponse.fromJson(modifiedJson);
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка обновления транзакции');
      rethrow;
    }
  }

  @override
  Future<void> deleteTransaction(int id) async {
    try {
      await _dioClient.delete('/transactions/$id');
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка удаления транзакции');
      rethrow;
    }
  }

  @override
  Future<List<TransactionResponse>> getTransactionsByPeriod(
    int accountId, {
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      final now = DateTime.now();
      final effectiveStartDate = startDate ?? DateTime(now.year, now.month, 1);
      final effectiveEndDate = endDate ?? DateTime(now.year, now.month + 1, 0);

      final dateFormat = DateFormat('yyyy-MM-dd');

      final queryParameters = {
        'startDate': dateFormat.format(effectiveStartDate),
        'endDate': dateFormat.format(effectiveEndDate),
      };
      _talker.debug(
        'Query Parameters for accountId $accountId: $queryParameters',
      );

      final response = await _dioClient.get(
        '/transactions/account/$accountId/period',
        queryParameters: queryParameters,
      );

      // Обрабатываем JSON-ответ, преобразуя строки в числа
      final transactions =
          (response.data as List<dynamic>).map((json) {
            // Копия JSON для модификации
            final modifiedJson = Map<String, dynamic>.from(json);

            // Преобразуем amount, если это строка
            if (modifiedJson['amount'] is String) {
              modifiedJson['amount'] =
                  double.tryParse(modifiedJson['amount']) ?? 0.0;
            }

            // Преобразуем поля в account, если они строки
            if (modifiedJson['account'] is Map<String, dynamic>) {
              final account = Map<String, dynamic>.from(
                modifiedJson['account'],
              );
              if (account['id'] is String) {
                account['id'] = int.tryParse(account['id']) ?? 0;
              }
              if (account['balance'] is String) {
                account['balance'] = double.tryParse(account['balance']) ?? 0.0;
              }
              modifiedJson['account'] = account;
            }

            return TransactionResponse.fromJson(modifiedJson);
          }).toList();

      return transactions;
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Error getting transactions by period');
      rethrow;
    }
  }
}
