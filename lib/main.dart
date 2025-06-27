import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:shrm_homework_app/app.dart';
import 'package:shrm_homework_app/core/di/di.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';

void main() {
  runZonedGuarded(
    () async {
      WidgetsFlutterBinding.ensureInitialized();
      await configureDependencies();
      final talker = GetIt.I<Talker>();
      talker.debug('Log debug');

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
