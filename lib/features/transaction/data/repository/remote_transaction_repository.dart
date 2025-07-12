import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction/transaction.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_request/transaction_request.dart';
import 'package:shrm_homework_app/features/transaction/data/models/transaction_response/transaction_response.dart';
import 'package:talker_flutter/talker_flutter.dart';

/// Remote data source для работы с API транзакций
@injectable
class RemoteTransactionRepository {
  final DioClient _dioClient;
  final Talker _talker;

  RemoteTransactionRepository(this._dioClient, this._talker);

  /// Получить все транзакции 
  /// ВАЖНО: API не поддерживает этот endpoint
  /// Используйте getTransactionsByAccountAndPeriod() вместо него
  @Deprecated('API не поддерживает getAllTransactions. Используйте getTransactionsByAccountAndPeriod()')
  Future<List<TransactionResponse>> getAllTransactions() async {
    _talker.warning('⚠️ RemoteTransactionRepository: getAllTransactions DEPRECATED - API не поддерживает этот endpoint');
    _talker.info('💡 RemoteTransactionRepository: Используйте getTransactionsByAccountAndPeriod() для получения транзакций');
    
    // API не поддерживает этот endpoint, возвращаем пустой список
    // Это заставит приложение использовать локальные данные или правильный endpoint
    return [];
  }

  /// Получить транзакцию по ID
  Future<TransactionResponse> getTransaction(int id) async {
    _talker.info('🌐 RemoteTransactionRepository: Получение транзакции ID: $id');
    try {
      final response = await _dioClient.get('/transactions/$id');
      _talker.debug('📥 RemoteTransactionRepository: Получен ответ для транзакции $id');
      
      final transaction = TransactionResponse.fromJson(response.data);
      _talker.info('✅ RemoteTransactionRepository: Успешно получена транзакция ID: ${transaction.id}');
      return transaction;
    } catch (e, st) {
      _talker.error('❌ RemoteTransactionRepository: Ошибка получения транзакции $id', e, st);
      rethrow;
    }
  }

  /// Создать новую транзакцию
  Future<Transaction> createTransaction(TransactionRequest request) async {
    _talker.info('🌐 RemoteTransactionRepository: Создание транзакции ${request.amount}');
    
    // Создаем JSON вручную, исключая null значения
    final requestData = <String, dynamic>{
      'accountId': request.accountId,
      'categoryId': request.categoryId,
      'amount': request.amount,
      'transactionDate': '${request.transactionDate.year}-${request.transactionDate.month.toString().padLeft(2, '0')}-${request.transactionDate.day.toString().padLeft(2, '0')}',
    };
    
    // Добавляем comment только если он не null и не пустой
    if (request.comment != null && request.comment!.isNotEmpty) {
      requestData['comment'] = request.comment;
    }
    
    _talker.debug('📤 RemoteTransactionRepository: Request data: $requestData');
    
    try {
      final response = await _dioClient.post(
        '/transactions',
        data: requestData,
      );
      _talker.debug('📥 RemoteTransactionRepository: Получен ответ на создание транзакции');
      
      final transaction = Transaction.fromJson(response.data);
      _talker.info('✅ RemoteTransactionRepository: Успешно создана транзакция ID: ${transaction.id}');
      return transaction;
    } catch (e, st) {
      _talker.error('❌ RemoteTransactionRepository: Ошибка создания транзакции ${request.amount}', e, st);
      rethrow;
    }
  }

  /// Обновить существующую транзакцию
  Future<TransactionResponse> updateTransaction(int id, TransactionRequest request) async {
    _talker.info('🌐 RemoteTransactionRepository: Обновление транзакции ID: $id');
    
    // Создаем JSON вручную, исключая null значения
    final requestData = <String, dynamic>{
      'accountId': request.accountId,
      'categoryId': request.categoryId,
      'amount': request.amount,
      'transactionDate': '${request.transactionDate.year}-${request.transactionDate.month.toString().padLeft(2, '0')}-${request.transactionDate.day.toString().padLeft(2, '0')}',
    };
    
    // Добавляем comment только если он не null и не пустой
    if (request.comment != null && request.comment!.isNotEmpty) {
      requestData['comment'] = request.comment;
    }
    
    _talker.debug('📤 RemoteTransactionRepository: Update data: $requestData');
    
    try {
      final response = await _dioClient.put(
        '/transactions/$id',
        data: requestData,
      );
      _talker.debug('📥 RemoteTransactionRepository: Получен ответ на обновление транзакции $id');
      
      final transaction = TransactionResponse.fromJson(response.data);
      _talker.info('✅ RemoteTransactionRepository: Успешно обновлена транзакция ID: ${transaction.id}');
      return transaction;
    } catch (e, st) {
      _talker.error('❌ RemoteTransactionRepository: Ошибка обновления транзакции $id', e, st);
      rethrow;
    }
  }

  /// Удалить транзакцию
  Future<void> deleteTransaction(int id) async {
    _talker.info('🌐 RemoteTransactionRepository: Удаление транзакции ID: $id');
    try {
      await _dioClient.delete('/transactions/$id');
      _talker.info('✅ RemoteTransactionRepository: Успешно удалена транзакция ID: $id');
    } catch (e, st) {
      _talker.error('❌ RemoteTransactionRepository: Ошибка удаления транзакции $id', e, st);
      rethrow;
    }
  }

  /// Получить транзакции по аккаунту за период
  Future<List<TransactionResponse>> getTransactionsByAccountAndPeriod({
    required int accountId,
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    _talker.info('🌐 RemoteTransactionRepository: Получение транзакций аккаунта $accountId за период');
    try {
      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        // API ожидает формат YYYY-MM-DD
        queryParams['startDate'] = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      }
      if (endDate != null) {
        // API ожидает формат YYYY-MM-DD
        queryParams['endDate'] = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';
      }
      
      final response = await _dioClient.get(
        '/transactions/account/$accountId/period',
        queryParameters: queryParams,
      );
      _talker.debug('📥 RemoteTransactionRepository: Получен ответ транзакций за период');
      
      final transactions = (response.data as List)
          .map((json) => TransactionResponse.fromJson(json))
          .toList();
      
      _talker.info('✅ RemoteTransactionRepository: Получено ${transactions.length} транзакций за период');
      return transactions;
    } catch (e, st) {
      _talker.error('❌ RemoteTransactionRepository: Ошибка получения транзакций за период', e, st);
      rethrow;
    }
  }
}
