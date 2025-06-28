import 'package:injectable/injectable.dart';
import 'package:talker_flutter/talker_flutter.dart';

@module
abstract class TalkerModule {
  @singleton
  @factoryMethod
  Talker get talker => TalkerFlutter.init(
    settings: TalkerSettings(useConsoleLogs: true, maxHistoryItems: 1000),
    logger: TalkerLogger(
      settings: TalkerLoggerSettings(
        enableColors: true,
        level: LogLevel.verbose,
      ),
    ),
  );
}
