import 'dart:async';
import 'package:injectable/injectable.dart';
import 'package:shrm_homework_app/core/storage/preferences_service.dart';

@singleton
class CurrencyService {
  final PreferencesService _preferencesService;

  CurrencyService(this._preferencesService);

  static const String _currencyKey = 'app_currency';
  static const String _defaultCurrency = 'RUB';

  final StreamController<String> _currencyController =
      StreamController<String>.broadcast();
  Stream<String> get currencyStream => _currencyController.stream;

  String _currentCurrency = _defaultCurrency;
  String get currentCurrency => _currentCurrency;

  @PostConstruct()
  Future<void> init() async {
    _currentCurrency = _preferencesService.getAppCurrency() ?? _defaultCurrency;
    _currencyController.add(_currentCurrency);
  }

  Future<void> setCurrency(String currency) async {
    if (_currentCurrency != currency) {
      _currentCurrency = currency;
      await _preferencesService.setAppCurrency(currency);
      _currencyController.add(currency);
    }
  }

  void dispose() {
    _currencyController.close();
  }
}
