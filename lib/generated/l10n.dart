// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `My history`
  String get myHistory {
    return Intl.message('My history', name: 'myHistory', desc: '', args: []);
  }

  /// `Start`
  String get start {
    return Intl.message('Start', name: 'start', desc: '', args: []);
  }

  /// `End`
  String get end {
    return Intl.message('End', name: 'end', desc: '', args: []);
  }

  /// `Sort`
  String get sort {
    return Intl.message('Sort', name: 'sort', desc: '', args: []);
  }

  /// `by date`
  String get byDate {
    return Intl.message('by date', name: 'byDate', desc: '', args: []);
  }

  /// `by amount`
  String get byAmount {
    return Intl.message('by amount', name: 'byAmount', desc: '', args: []);
  }

  /// `Amount`
  String get amount {
    return Intl.message('Amount', name: 'amount', desc: '', args: []);
  }

  /// `Select sorting`
  String get chooseSort {
    return Intl.message(
      'Select sorting',
      name: 'chooseSort',
      desc: '',
      args: [],
    );
  }

  /// `No income for the selected period`
  String get noIncomeForSelectedPeriod {
    return Intl.message(
      'No income for the selected period',
      name: 'noIncomeForSelectedPeriod',
      desc: '',
      args: [],
    );
  }

  /// `No expenses for the selected period`
  String get noExpensesForSelectedPeriod {
    return Intl.message(
      'No expenses for the selected period',
      name: 'noExpensesForSelectedPeriod',
      desc: '',
      args: [],
    );
  }

  /// `Incomes today`
  String get incomeToday {
    return Intl.message(
      'Incomes today',
      name: 'incomeToday',
      desc: '',
      args: [],
    );
  }

  /// `Expenses today `
  String get expenseToday {
    return Intl.message(
      'Expenses today ',
      name: 'expenseToday',
      desc: '',
      args: [],
    );
  }

  /// `Total`
  String get total {
    return Intl.message('Total', name: 'total', desc: '', args: []);
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Balance`
  String get balance {
    return Intl.message('Balance', name: 'balance', desc: '', args: []);
  }

  /// `Currency`
  String get currency {
    return Intl.message('Currency', name: 'currency', desc: '', args: []);
  }

  /// `Russian Ruble`
  String get russianRuble {
    return Intl.message(
      'Russian Ruble',
      name: 'russianRuble',
      desc: '',
      args: [],
    );
  }

  /// `US Dollar`
  String get usDollar {
    return Intl.message('US Dollar', name: 'usDollar', desc: '', args: []);
  }

  /// `Euro`
  String get euro {
    return Intl.message('Euro', name: 'euro', desc: '', args: []);
  }

  /// `Cancel`
  String get cancel {
    return Intl.message('Cancel', name: 'cancel', desc: '', args: []);
  }

  /// `Chart will be implemented later`
  String get chartWillBeImplementedLater {
    return Intl.message(
      'Chart will be implemented later',
      name: 'chartWillBeImplementedLater',
      desc: '',
      args: [],
    );
  }

  /// `{transaction.category.name}`
  String get categoryName {
    return Intl.message(
      '{transaction.category.name}',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ru'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
