import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/services/theme_service.dart';

@injectable
class ThemeState {
  final Color primaryColor;
  final bool useSystemTheme;

  ThemeState(this.primaryColor, this.useSystemTheme);
}

@injectable
class ThemeCubit extends Cubit<ThemeState> {
  final ThemeService _themeService;

  ThemeCubit(this._themeService) : super(ThemeState(Colors.green, false));

  Future<void> init() async {
    final color = await _themeService.getPrimaryColor();
    final useSystem = await _themeService.getUseSystemTheme();
    emit(ThemeState(color, useSystem));
    _themeService.primaryColorStream.listen((color) {
      emit(ThemeState(color, state.useSystemTheme));
    });
    _themeService.useSystemThemeStream.listen((useSystem) {
      emit(ThemeState(state.primaryColor, useSystem));
    });
  }

  Future<void> setPrimaryColor(Color color) async {
    await _themeService.setPrimaryColor(color);
  }

  Future<void> setUseSystemTheme(bool useSystem) async {
    await _themeService.setUseSystemTheme(useSystem);
  }
}