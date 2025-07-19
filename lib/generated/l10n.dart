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

  /// `Category Name`
  String get categoryName {
    return Intl.message(
      'Category Name',
      name: 'categoryName',
      desc: '',
      args: [],
    );
  }

  /// `OK`
  String get ok {
    return Intl.message('OK', name: 'ok', desc: '', args: []);
  }

  /// `Error`
  String get error {
    return Intl.message('Error', name: 'error', desc: '', args: []);
  }

  /// `Please fill all fields`
  String get fillAllFields {
    return Intl.message(
      'Please fill all fields',
      name: 'fillAllFields',
      desc: '',
      args: [],
    );
  }

  /// `Select`
  String get select {
    return Intl.message('Select', name: 'select', desc: '', args: []);
  }

  /// `Category`
  String get category {
    return Intl.message('Category', name: 'category', desc: '', args: []);
  }

  /// `Date`
  String get date {
    return Intl.message('Date', name: 'date', desc: '', args: []);
  }

  /// `Time`
  String get time {
    return Intl.message('Time', name: 'time', desc: '', args: []);
  }

  /// `Comment`
  String get comment {
    return Intl.message('Comment', name: 'comment', desc: '', args: []);
  }

  /// `Delete expense`
  String get deleteExpense {
    return Intl.message(
      'Delete expense',
      name: 'deleteExpense',
      desc: '',
      args: [],
    );
  }

  /// `My Incomes`
  String get myIncomes {
    return Intl.message('My Incomes', name: 'myIncomes', desc: '', args: []);
  }

  /// `My expenses`
  String get myExpenses {
    return Intl.message('My expenses', name: 'myExpenses', desc: '', args: []);
  }

  /// `Delete`
  String get delete {
    return Intl.message('Delete', name: 'delete', desc: '', args: []);
  }

  /// `Are you sure?`
  String get areYouSure {
    return Intl.message(
      'Are you sure?',
      name: 'areYouSure',
      desc: '',
      args: [],
    );
  }

  /// `None`
  String get none {
    return Intl.message('None', name: 'none', desc: '', args: []);
  }

  /// `Edit`
  String get edit {
    return Intl.message('Edit', name: 'edit', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `Use system theme`
  String get useSystemTheme {
    return Intl.message(
      'Use system theme',
      name: 'useSystemTheme',
      desc: '',
      args: [],
    );
  }

  /// `Primary color`
  String get primaryColor {
    return Intl.message(
      'Primary color',
      name: 'primaryColor',
      desc: '',
      args: [],
    );
  }

  /// `Haptic feedback`
  String get hapticFeedback {
    return Intl.message(
      'Haptic feedback',
      name: 'hapticFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get language {
    return Intl.message('Language', name: 'language', desc: '', args: []);
  }

  /// `Select color`
  String get selectColor {
    return Intl.message(
      'Select color',
      name: 'selectColor',
      desc: '',
      args: [],
    );
  }

  /// `Select language`
  String get selectLanguage {
    return Intl.message(
      'Select language',
      name: 'selectLanguage',
      desc: '',
      args: [],
    );
  }

  /// `Russian`
  String get russian {
    return Intl.message('Russian', name: 'russian', desc: '', args: []);
  }

  /// `English`
  String get english {
    return Intl.message('English', name: 'english', desc: '', args: []);
  }

  /// `Expenses`
  String get expenses {
    return Intl.message('Expenses', name: 'expenses', desc: '', args: []);
  }

  /// `Income`
  String get income {
    return Intl.message('Income', name: 'income', desc: '', args: []);
  }

  /// `Articles`
  String get articles {
    return Intl.message('Articles', name: 'articles', desc: '', args: []);
  }

  /// `No income today`
  String get noIncomeToday {
    return Intl.message(
      'No income today',
      name: 'noIncomeToday',
      desc: '',
      args: [],
    );
  }

  /// `No expenses today`
  String get noExpensesToday {
    return Intl.message(
      'No expenses today',
      name: 'noExpensesToday',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get accountName {
    return Intl.message('Account', name: 'accountName', desc: '', args: []);
  }

  /// `My articles`
  String get myArticles {
    return Intl.message('My articles', name: 'myArticles', desc: '', args: []);
  }

  /// `Found: {found} of {total}`
  String foundOf(Object found, Object total) {
    return Intl.message(
      'Found: $found of $total',
      name: 'foundOf',
      desc: '',
      args: [found, total],
    );
  }

  /// `Nothing found for "{query}"`
  String nothingFoundForQuery(Object query) {
    return Intl.message(
      'Nothing found for "$query"',
      name: 'nothingFoundForQuery',
      desc: '',
      args: [query],
    );
  }

  /// `Categories not found`
  String get categoriesNotFound {
    return Intl.message(
      'Categories not found',
      name: 'categoriesNotFound',
      desc: '',
      args: [],
    );
  }

  /// `Try changing your search query`
  String get tryChangingSearchQuery {
    return Intl.message(
      'Try changing your search query',
      name: 'tryChangingSearchQuery',
      desc: '',
      args: [],
    );
  }

  /// `Unknown state`
  String get unknownState {
    return Intl.message(
      'Unknown state',
      name: 'unknownState',
      desc: '',
      args: [],
    );
  }

  /// `January`
  String get monthJanuary {
    return Intl.message('January', name: 'monthJanuary', desc: '', args: []);
  }

  /// `February`
  String get monthFebruary {
    return Intl.message('February', name: 'monthFebruary', desc: '', args: []);
  }

  /// `March`
  String get monthMarch {
    return Intl.message('March', name: 'monthMarch', desc: '', args: []);
  }

  /// `April`
  String get monthApril {
    return Intl.message('April', name: 'monthApril', desc: '', args: []);
  }

  /// `May`
  String get monthMay {
    return Intl.message('May', name: 'monthMay', desc: '', args: []);
  }

  /// `June`
  String get monthJune {
    return Intl.message('June', name: 'monthJune', desc: '', args: []);
  }

  /// `July`
  String get monthJuly {
    return Intl.message('July', name: 'monthJuly', desc: '', args: []);
  }

  /// `August`
  String get monthAugust {
    return Intl.message('August', name: 'monthAugust', desc: '', args: []);
  }

  /// `September`
  String get monthSeptember {
    return Intl.message(
      'September',
      name: 'monthSeptember',
      desc: '',
      args: [],
    );
  }

  /// `October`
  String get monthOctober {
    return Intl.message('October', name: 'monthOctober', desc: '', args: []);
  }

  /// `November`
  String get monthNovember {
    return Intl.message('November', name: 'monthNovember', desc: '', args: []);
  }

  /// `December`
  String get monthDecember {
    return Intl.message('December', name: 'monthDecember', desc: '', args: []);
  }

  /// `Edit`
  String get editAccount {
    return Intl.message('Edit', name: 'editAccount', desc: '', args: []);
  }

  /// `Account Name`
  String get accountNameLabel {
    return Intl.message(
      'Account Name',
      name: 'accountNameLabel',
      desc: '',
      args: [],
    );
  }

  /// `Delete Account`
  String get deleteAccount {
    return Intl.message(
      'Delete Account',
      name: 'deleteAccount',
      desc: '',
      args: [],
    );
  }

  /// `Account deletion feature is under development`
  String get deleteAccountInDevelopment {
    return Intl.message(
      'Account deletion feature is under development',
      name: 'deleteAccountInDevelopment',
      desc: '',
      args: [],
    );
  }

  /// `Analysis`
  String get analysis {
    return Intl.message('Analysis', name: 'analysis', desc: '', args: []);
  }

  /// `No data for analysis in the selected period`
  String get noDataForAnalysis {
    return Intl.message(
      'No data for analysis in the selected period',
      name: 'noDataForAnalysis',
      desc: '',
      args: [],
    );
  }

  /// `No comment`
  String get noComment {
    return Intl.message('No comment', name: 'noComment', desc: '', args: []);
  }

  /// `Setup PIN Code`
  String get setupPinCode {
    return Intl.message(
      'Setup PIN Code',
      name: 'setupPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm PIN Code`
  String get confirmPinCode {
    return Intl.message(
      'Confirm PIN Code',
      name: 'confirmPinCode',
      desc: '',
      args: [],
    );
  }

  /// `New PIN Code`
  String get enterNewPinCode {
    return Intl.message(
      'New PIN Code',
      name: 'enterNewPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm New PIN Code`
  String get confirmNewPinCode {
    return Intl.message(
      'Confirm New PIN Code',
      name: 'confirmNewPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter PIN Code`
  String get enterPinCode {
    return Intl.message(
      'Enter PIN Code',
      name: 'enterPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Create a 4-digit PIN code`
  String get createFourDigitPinCode {
    return Intl.message(
      'Create a 4-digit PIN code',
      name: 'createFourDigitPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your PIN code`
  String get confirmYourPinCode {
    return Intl.message(
      'Confirm your PIN code',
      name: 'confirmYourPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your new PIN code`
  String get enterYourNewPinCode {
    return Intl.message(
      'Enter your new PIN code',
      name: 'enterYourNewPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Confirm your new PIN code`
  String get confirmYourNewPinCode {
    return Intl.message(
      'Confirm your new PIN code',
      name: 'confirmYourNewPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Enter your PIN code`
  String get enterYourPinCode {
    return Intl.message(
      'Enter your PIN code',
      name: 'enterYourPinCode',
      desc: '',
      args: [],
    );
  }

  /// `PIN codes do not match`
  String get pinCodesDoNotMatch {
    return Intl.message(
      'PIN codes do not match',
      name: 'pinCodesDoNotMatch',
      desc: '',
      args: [],
    );
  }

  /// `Incorrect PIN code`
  String get incorrectPinCode {
    return Intl.message(
      'Incorrect PIN code',
      name: 'incorrectPinCode',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `PIN Code`
  String get pinCodeSecurity {
    return Intl.message(
      'PIN Code',
      name: 'pinCodeSecurity',
      desc: '',
      args: [],
    );
  }

  /// `Change PIN Code`
  String get changePinCode {
    return Intl.message(
      'Change PIN Code',
      name: 'changePinCode',
      desc: '',
      args: [],
    );
  }

  /// `Set PIN Code`
  String get setPinCode {
    return Intl.message('Set PIN Code', name: 'setPinCode', desc: '', args: []);
  }

  /// `PIN code set successfully`
  String get pinCodeSet {
    return Intl.message(
      'PIN code set successfully',
      name: 'pinCodeSet',
      desc: '',
      args: [],
    );
  }

  /// `PIN code changed successfully`
  String get pinCodeChanged {
    return Intl.message(
      'PIN code changed successfully',
      name: 'pinCodeChanged',
      desc: '',
      args: [],
    );
  }

  /// `Biometric Authentication`
  String get biometricAuthentication {
    return Intl.message(
      'Biometric Authentication',
      name: 'biometricAuthentication',
      desc: '',
      args: [],
    );
  }

  /// `Use Face ID / Touch ID`
  String get useFaceIdTouchId {
    return Intl.message(
      'Use Face ID / Touch ID',
      name: 'useFaceIdTouchId',
      desc: '',
      args: [],
    );
  }

  /// `Authenticate to enable biometric unlock`
  String get authenticateToEnableBiometric {
    return Intl.message(
      'Authenticate to enable biometric unlock',
      name: 'authenticateToEnableBiometric',
      desc: '',
      args: [],
    );
  }

  /// `Biometric authentication failed`
  String get biometricAuthenticationFailed {
    return Intl.message(
      'Biometric authentication failed',
      name: 'biometricAuthenticationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Please set up a PIN code first`
  String get setPinCodeFirst {
    return Intl.message(
      'Please set up a PIN code first',
      name: 'setPinCodeFirst',
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
