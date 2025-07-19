import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:worker_manager/worker_manager.dart';

class JsonParsingTransformer extends Transformer {
  final Talker talker;

  JsonParsingTransformer(this.talker);

  @override
  Future<String> transformRequest(RequestOptions options) async {
    // Для запросов используем стандартную сериализацию
    if (options.data != null) {
      return json.encode(options.data);
    }
    return '';
  }

  @override
  Future<dynamic> transformResponse(
    RequestOptions options,
    ResponseBody responseBody,
  ) async {
    // Читаем данные из потока
    final bytes = await responseBody.stream.fold<List<int>>(
      <int>[],
      (previous, element) => previous..addAll(element),
    );
    final jsonString = utf8.decode(bytes);

    if (jsonString.isNotEmpty) {
      talker.info('🔄 Starting JSON parsing using worker_manager isolate pool...');
      
      try {
        // Используем worker_manager для десериализации в изоляте
        final parsedJson = await workerManager.execute(() => _decodeJson(jsonString));
        talker.info('✅ JSON parsing in worker_manager isolate finished successfully.');
        return parsedJson;
      } catch (error) {
        talker.error('❌ JSON parsing in worker_manager isolate failed.', error);
        rethrow;
      }
    }
    
    return null;
  }
}

// Функция для декодирования JSON (должна быть глобальной для изолята)
dynamic _decodeJson(String jsonString) {
  return json.decode(jsonString);
}