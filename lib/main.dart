import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shrm_homework_app/app.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:shrm_homework_app/core/network/dio_client.dart';
import 'package:shrm_homework_app/core/network/connectivity_service.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:worker_manager/worker_manager.dart';
import 'package:shrm_homework_app/core/events/locale_cubit.dart';
import 'package:shrm_homework_app/core/events/theme_cubit.dart';
import 'package:shrm_homework_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shrm_homework_app/core/services/sync_worker.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await workerManager.init();

      await configureDependencies();

      final talker = GetIt.I<Talker>();
      talker.debug('Log debug');

      // Инициализация сервисов
      try {
        final dioClient = GetIt.I<DioClient>();
        final connectivityService = GetIt.I<ConnectivityService>();

        talker.info('✅ DioClient создан успешно');
        talker.info('✅ ConnectivityService создан успешно');
        talker.info(
          '✅ WorkerManager инициализирован для десериализации через изоляты',
        );

        final isConnected = await connectivityService.checkConnection();
        talker.info('🌐 Интернет подключен: $isConnected');
      } catch (e, stackTrace) {
        talker.error('❌ Ошибка инициализации сервисов', e, stackTrace);
      }

      Bloc.observer = TalkerBlocObserver(talker: talker);

      FlutterError.onError =
          (details) => talker.handle(details.exception, details.stack);

      final syncWorker = getIt<SyncWorker>();
      syncWorker.start();

      final themeCubit = await getIt.getAsync<ThemeCubit>();
      await themeCubit.init();

      final settingsCubit = getIt<SettingsCubit>();
      await settingsCubit.loadSettings();

      final localeCubit = LocaleCubit();
      await localeCubit.loadLocale();

      runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<ThemeCubit>(create: (_) => themeCubit),
            BlocProvider<SettingsCubit>(create: (_) => settingsCubit),
            BlocProvider<LocaleCubit>(create: (_) => localeCubit),
          ],
          child: MyApp(),
        ),
      );
    },
    (error, stack) {
      GetIt.I<Talker>().handle(error, stack);
    },
  );
}
