import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shrm_homework_app/core/router/app_router.dart';
import 'package:shrm_homework_app/generated/l10n.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shrm_homework_app/core/events/locale_cubit.dart';
import 'package:shrm_homework_app/core/events/theme_cubit.dart';
import 'package:shrm_homework_app/features/settings/presentation/cubit/settings_cubit.dart';
import 'package:shrm_homework_app/features/settings/presentation/pin_code_screen.dart';

@RoutePage()
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _storage = const FlutterSecureStorage();
  final _localAuth = LocalAuthentication();
  String? _pin;
  bool _isBiometricEnabled = false;
  bool _isBiometricAvailable = false;

  @override
  void initState() {
    super.initState();
    _checkPin();
    _checkBiometric();
  }

  Future<void> _checkPin() async {
    _pin = await _storage.read(key: 'pin');
    setState(() {});
  }

  Future<void> _checkBiometric() async {
    try {
      _isBiometricAvailable = await _localAuth.canCheckBiometrics;
      final biometricSetting = await _storage.read(key: 'biometric_enabled');
      _isBiometricEnabled = biometricSetting == 'true';
      setState(() {});
    } catch (e) {
      _isBiometricAvailable = false;
      setState(() {});
    }
  }

  Future<void> _toggleBiometric(bool value) async {
    if (value && _pin == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).setPinCodeFirst),
        ),
      );
      return;
    }

    if (value) {
      try {
        final isAuthenticated = await _localAuth.authenticate(
          localizedReason: S.of(context).authenticateToEnableBiometric,
          options: const AuthenticationOptions(
            biometricOnly: true,
            stickyAuth: true,
          ),
        );
        
        if (isAuthenticated) {
          await _storage.write(key: 'biometric_enabled', value: 'true');
          setState(() {
            _isBiometricEnabled = true;
          });
        }
        // Если аутентификация не прошла, просто не включаем биометрию
      } catch (e) {
        // Показываем ошибку только при реальных проблемах с биометрией
        if (e.toString().contains('NotAvailable') || e.toString().contains('NotEnrolled')) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(S.of(context).biometricAuthenticationFailed),
            ),
          );
        }
        // Для отмены пользователем не показываем ошибку
      }
    } else {
      await _storage.write(key: 'biometric_enabled', value: 'false');
      setState(() {
        _isBiometricEnabled = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(S.of(context).settings)),
      body: MultiBlocListener(
        listeners: [
          BlocListener<ThemeCubit, ThemeState>(listener: (context, state) {}),
          BlocListener<SettingsCubit, SettingsState>(
            listener: (context, state) {},
          ),
        ],
        child: BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, themeState) {
            return BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingsState) {
                return ListView(
                  children: [
                    SwitchListTile(
                      title: Text(S.of(context).useSystemTheme),
                      value: themeState.useSystemTheme,
                      onChanged: (value) {
                        context.read<ThemeCubit>().setUseSystemTheme(value);
                      },
                    ),
                    ListTile(
                      title: Text(S.of(context).primaryColor),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(S.of(context).selectColor),
                              content: MaterialPicker(
                                pickerColor: themeState.primaryColor,
                                onColorChanged: (color) {
                                  context.read<ThemeCubit>().setPrimaryColor(
                                    color,
                                  );
                                },
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text(S.of(context).ok),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
                    SwitchListTile(
                      title: Text(S.of(context).hapticFeedback),
                      value: settingsState.hapticFeedbackEnabled,
                      onChanged: (value) {
                        context.read<SettingsCubit>().setHapticFeedbackEnabled(
                          value,
                        );
                      },
                    ),
                    ListTile(
                      title: Text(S.of(context).language),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(S.of(context).selectLanguage),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  ListTile(
                                    title: Text(S.of(context).russian),
                                    onTap: () {
                                      context.read<LocaleCubit>().setLocale(
                                        const Locale('ru'),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                  ListTile(
                                    title: Text(S.of(context).english),
                                    onTap: () {
                                      context.read<LocaleCubit>().setLocale(
                                        const Locale('en'),
                                      );
                                      Navigator.pop(context);
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                    ListTile(
                      title: Text(S.of(context).pinCodeSecurity),
                      subtitle: Text(
                        _pin != null
                            ? S.of(context).changePinCode
                            : S.of(context).setPinCode,
                      ),
                      trailing: Icon(Icons.arrow_right),
                      onTap: () async {
                        final result = await context.router.push(
                          PinCodeRoute(
                            mode:
                                _pin != null
                                    ? PinCodeMode.edit
                                    : PinCodeMode.setup,
                          ),
                        );
                        if (result == true) {
                          await _checkPin();
                          await _checkBiometric();
                        }
                      },
                    ),
                    if (_isBiometricAvailable && _pin != null)
                      SwitchListTile(
                        title: Text(S.of(context).biometricAuthentication),
                        subtitle: Text(S.of(context).useFaceIdTouchId),
                        value: _isBiometricEnabled,
                        onChanged: _toggleBiometric,
                        secondary: Icon(Icons.fingerprint),
                      ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
