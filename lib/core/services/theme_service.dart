import 'dart:async';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/storage/preferences_service.dart';

@singleton
class ThemeService {
  final PreferencesService _preferencesService;

  ThemeService(this._preferencesService);

  final StreamController<Color> _primaryColorController =
      StreamController<Color>.broadcast();

  Stream<Color> get primaryColorStream => _primaryColorController.stream;

  final StreamController<bool> _useSystemThemeController =
      StreamController<bool>.broadcast();

  Stream<bool> get useSystemThemeStream => _useSystemThemeController.stream;

  Future<Color> getPrimaryColor() async {
    final colorValue = _preferencesService.getPrimaryColor();
    return Color(colorValue);
  }

  Future<bool> getUseSystemTheme() async {
    return _preferencesService.getUseSystemTheme();
  }

  Future<void> setPrimaryColor(Color color) async {
    await _preferencesService.setPrimaryColor(color.value);
    _primaryColorController.add(color);
  }

  Future<void> setUseSystemTheme(bool useSystem) async {
    await _preferencesService.setUseSystemTheme(useSystem);
    _useSystemThemeController.add(useSystem);
  }

  Future<void> init() async {
    final color = await getPrimaryColor();
    _primaryColorController.add(color);
    final useSystem = await getUseSystemTheme();
    _useSystemThemeController.add(useSystem);
  }
}