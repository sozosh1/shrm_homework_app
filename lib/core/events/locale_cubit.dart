import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleState {
  final Locale locale;

  const LocaleState(this.locale);
}

class LocaleCubit extends Cubit<LocaleState> {
  LocaleCubit() : super(const LocaleState(Locale('ru')));

  Future<void> loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('languageCode') ?? 'ru';
    emit(LocaleState(Locale(languageCode)));
  }

  Future<void> setLocale(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
    emit(LocaleState(locale));
  }
}