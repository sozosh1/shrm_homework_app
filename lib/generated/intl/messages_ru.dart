// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ru locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'ru';

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "account": MessageLookupByLibrary.simpleMessage("Счет"),
    "amount": MessageLookupByLibrary.simpleMessage("Сумма"),
    "balance": MessageLookupByLibrary.simpleMessage("Баланс"),
    "byAmount": MessageLookupByLibrary.simpleMessage("По сумме"),
    "byDate": MessageLookupByLibrary.simpleMessage("По дате"),
    "cancel": MessageLookupByLibrary.simpleMessage("Отмена"),
    "categoryName": MessageLookupByLibrary.simpleMessage(
      "{transaction.category.name}",
    ),
    "chartWillBeImplementedLater": MessageLookupByLibrary.simpleMessage(
      "График будет реализован позже",
    ),
    "chooseSort": MessageLookupByLibrary.simpleMessage("Выберите сортировку"),
    "currency": MessageLookupByLibrary.simpleMessage("Валюта"),
    "end": MessageLookupByLibrary.simpleMessage("Конец"),
    "euro": MessageLookupByLibrary.simpleMessage("Евро"),
    "expenseToday": MessageLookupByLibrary.simpleMessage("Расходы сегодня"),
    "incomeToday": MessageLookupByLibrary.simpleMessage("Доходы сегодня"),
    "myHistory": MessageLookupByLibrary.simpleMessage("Моя история"),
    "noExpensesForSelectedPeriod": MessageLookupByLibrary.simpleMessage(
      "Нет расходов за выбранный период",
    ),
    "noIncomeForSelectedPeriod": MessageLookupByLibrary.simpleMessage(
      "Нет доходов за выбранный период",
    ),
    "russianRuble": MessageLookupByLibrary.simpleMessage("Российский рубль"),
    "sort": MessageLookupByLibrary.simpleMessage("Сортировка"),
    "start": MessageLookupByLibrary.simpleMessage("Начало"),
    "total": MessageLookupByLibrary.simpleMessage("Всего"),
    "usDollar": MessageLookupByLibrary.simpleMessage("Американский доллар"),
  };
}
