import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get_it/get_it.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:local_auth/local_auth.dart';

import 'package:shrm_homework_app/core/events/locale_cubit.dart';
import 'package:shrm_homework_app/core/events/theme_cubit.dart';
import 'package:shrm_homework_app/config/theme/app_theme.dart';
import 'package:shrm_homework_app/generated/l10n.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:secure_application/secure_application.dart';
import 'package:shrm_homework_app/features/settings/presentation/pin_code_screen.dart';

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  bool _isPinSet = false;
  bool _isCheckingPin = true;
  bool _isPinVerified = false;
  bool _isBiometricEnabled = false;
  SecureApplicationController? secureController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _checkPin();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (secureController != null) {
      if (state == AppLifecycleState.paused || state == AppLifecycleState.inactive) {
        secureController!.lock();
        _onAppPaused();
      } else if (state == AppLifecycleState.resumed) {
        secureController!.unlock();
      }
    }
  }

  Future<void> _checkPin() async {
    final pin = await _storage.read(key: 'pin');
    final biometricSetting = await _storage.read(key: 'biometric_enabled');
    setState(() {
      _isPinSet = pin != null;
      _isBiometricEnabled = biometricSetting == 'true';
      _isPinVerified = pin == null; // Если пин не установлен, считаем что верификация пройдена
      _isCheckingPin = false;
    });
  }

  Future<void> _tryBiometricAuth() async {
    if (!_isBiometricEnabled) return;
    
    try {
      final isAuthenticated = await _localAuth.authenticate(
        localizedReason: 'Authenticate to unlock the app',
        options: const AuthenticationOptions(
          biometricOnly: true,
          stickyAuth: true,
        ),
      );
      
      if (isAuthenticated) {
        _onPinVerified();
      }
    } catch (e) {
      // Биометрическая аутентификация не удалась, показываем PIN экран
    }
  }

  void _onPinVerified() {
    setState(() {
      _isPinVerified = true;
    });
  }

  void _onAppPaused() {
    if (_isPinSet) {
      setState(() {
        _isPinVerified = false;
      });
    }
  }

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    if (_isCheckingPin) {
      return const MaterialApp(
        home: Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // Если пин установлен, но пользователь не прошел аутентификацию
    if (_isPinSet && !_isPinVerified) {
      return MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: S.delegate.supportedLocales,
        home: PinCodeScreen(
          mode: PinCodeMode.verify,
          onSuccess: _onPinVerified,
          onBiometricAuth: _isBiometricEnabled ? _tryBiometricAuth : null,
        ),
      );
    }

    return SecureApplication(
      child: BlocBuilder<LocaleCubit, LocaleState>(
        builder: (context, localeState) {
          return BlocBuilder<ThemeCubit, ThemeState>(
            builder: (context, themeState) {
              // Получаем контроллер после создания SecureApplication
              secureController ??= SecureApplicationProvider.of(context);
              
              return MaterialApp.router(
                locale: localeState.locale,
                debugShowCheckedModeBanner: false,
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: S.delegate.supportedLocales,
                title: 'FINANCE app',
                theme: AppTheme.lightTheme(themeState.primaryColor),
                darkTheme: AppTheme.darkTheme(themeState.primaryColor),
                themeMode: themeState.useSystemTheme ? ThemeMode.system : ThemeMode.light,
                routerConfig: _appRouter.config(
                  navigatorObservers: () => [TalkerRouteObserver(GetIt.I<Talker>())],
                ),
                builder: (context, child) => SecureGate(
                  blurr: 20,
                  opacity: 0.6,
                  child: child!,
                ),
              );
            },
          );
        },
      ),
    );
  }
}
