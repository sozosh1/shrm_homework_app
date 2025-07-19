import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/features/account/data/models/account_responce/account_response.dart';
import 'package:shrm_homework_app/features/account/data/models/account_update_request/account_update_request.dart';
import 'package:talker_flutter/talker_flutter.dart';

abstract class RemoteAccountDataSource {
  Future<AccountResponse> getAccount(int id);
  Future<void> updateAccount(int id, AccountUpdateRequest request);
}

@LazySingleton(as: RemoteAccountDataSource)
class RemoteAccountDataSourceImpl implements RemoteAccountDataSource {
  final DioClient _dioClient;
  final Talker _talker;

  RemoteAccountDataSourceImpl(this._dioClient, this._talker);

  @override
  Future<AccountResponse> getAccount(int id) async {
    try {
      final response = await _dioClient.get(
        '/accounts/$id',
        queryParameters: {'withStats': true},
      );

      final data = response.data;
      _talker.debug("Raw API response: $data"); // Логируем сырой ответ

      // Преобразуем balance в double, если он String
      if (data['balance'] is String) {
        data['balance'] = double.tryParse(data['balance']) ?? 0.0;
      }

      final incomeStats =
          (data['incomeStats'] as List<dynamic>?)?.map((stat) {
            if (stat['amount'] is String) {
              stat['amount'] = double.tryParse(stat['amount']) ?? 0.0;
            }
            return stat;
          }).toList() ??
          [];

      final expenseStats =
          (data['expenseStats'] as List<dynamic>?)?.map((stat) {
            if (stat['amount'] is String) {
              stat['amount'] = double.tryParse(stat['amount']) ?? 0.0;
            }
            return stat;
          }).toList() ??
          [];

      return AccountResponse.fromJson({
        ...data,
        'incomeStats': incomeStats,
        'expenseStats': expenseStats,
      });
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка получения аккаунта');
      rethrow;
    }
  }

  @override
  Future<void> updateAccount(int id, AccountUpdateRequest request) async {
    try {
      await _dioClient.put(
        '/accounts/$id',
        data: {
          'name': request.name,
          'balance': request.balance,
          'currency': request.currency,
        },
      );
    } on DioException catch (e, stackTrace) {
      _talker.handle(e, stackTrace, 'Ошибка обновления аккаунта');
      rethrow;
    }
  }
}
