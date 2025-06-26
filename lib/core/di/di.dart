import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/database/app_database.dart';
import 'package:shrm_homework_app/core/storage/preferences_service.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  final database = AppDatabase();
  getIt.registerSingleton<AppDatabase>(database);

  final prefsService = PreferencesService();
  await prefsService.init();
  getIt.registerSingleton<PreferencesService>(prefsService);

  getIt.init();
}
