import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_theme.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MyApp extends StatelessWidget {
  MyApp({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'FINANCE app',
      theme: AppTheme.lightTheme,
      routerConfig: _appRouter.config(
        navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>())],
      ),
    );
  }
}
