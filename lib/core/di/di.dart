import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/config/env.dart';

import 'di.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  getIt.registerFactory<String>(
    () => Env.bearerToken, 
    instanceName: 'bearerToken',
  );
  getIt.init();
}
