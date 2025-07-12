import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shrm_homework_app/app.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/core/services/connectivity_service.dart';
import 'package:shrm_homework_app/core/services/backup_sync_service.dart';
import 'package:shrm_homework_app/core/services/initialization_service.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:worker_manager/worker_manager.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      // Инициализация worker_manager для изолятов
      await workerManager.init();

      await configureDependencies();

      final talker = GetIt.I<Talker>();
      talker.debug('Log debug');

      // Инициализация сервисов
      try {
        GetIt.I<DioClient>(); // Просто инициализируем DioClient
        final connectivityService = GetIt.I<ConnectivityService>();

        talker.info('✅ DioClient создан успешно');
        talker.info('✅ ConnectivityService создан успешно');
        talker.info(
          '✅ WorkerManager инициализирован для десериализации через изоляты',
        );

        final isConnected = await connectivityService.isConnected;
        talker.info('🌐 Интернет подключен: $isConnected');
        
        // Инициализируем категории из API
        await _initializeCategories(talker);
      } catch (e, stackTrace) {
        talker.error('❌ Ошибка инициализации сервисов', e, stackTrace);
      }

      Bloc.observer = TalkerBlocObserver(talker: talker);

      FlutterError.onError =
          (details) => talker.handle(details.exception, details.stack);

      runApp(MyApp());
    },
    (error, stack) {
      GetIt.I<Talker>().handle(error, stack);
    },
  );
}



/// Инициализирует категории из API
Future<void> _initializeCategories(Talker talker) async {
  try {
    final initializationService = GetIt.I<InitializationService>();
    await initializationService.initializeCategories();
    talker.info('✅ Категории инициализированы успешно');
  } catch (e, st) {
    talker.error('❌ Ошибка инициализации категорий', e, st);
  }
}
