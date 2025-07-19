// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [AccountScreen]
class AccountRoute extends PageRouteInfo<void> {
  const AccountRoute({List<PageRouteInfo>? children})
    : super(AccountRoute.name, initialChildren: children);

  static const String name = 'AccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const AccountScreen();
    },
  );
}

/// generated route for
/// [ArticlesPage]
class ArticlesRoute extends PageRouteInfo<void> {
  const ArticlesRoute({List<PageRouteInfo>? children})
    : super(ArticlesRoute.name, initialChildren: children);

  static const String name = 'ArticlesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ArticlesPage();
    },
  );
}

/// generated route for
/// [CategoryTransactionsScreen]
class CategoryTransactionsRoute
    extends PageRouteInfo<CategoryTransactionsRouteArgs> {
  CategoryTransactionsRoute({
    Key? key,
    required CategoryAnalysisItem item,
    List<PageRouteInfo>? children,
  }) : super(
         CategoryTransactionsRoute.name,
         args: CategoryTransactionsRouteArgs(key: key, item: item),
         initialChildren: children,
       );

  static const String name = 'CategoryTransactionsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CategoryTransactionsRouteArgs>();
      return CategoryTransactionsScreen(key: args.key, item: args.item);
    },
  );
}

class CategoryTransactionsRouteArgs {
  const CategoryTransactionsRouteArgs({this.key, required this.item});

  final Key? key;

  final CategoryAnalysisItem item;

  @override
  String toString() {
    return 'CategoryTransactionsRouteArgs{key: $key, item: $item}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CategoryTransactionsRouteArgs) return false;
    return key == other.key && item == other.item;
  }

  @override
  int get hashCode => key.hashCode ^ item.hashCode;
}

/// generated route for
/// [EditAccountScreen]
class EditAccountRoute extends PageRouteInfo<EditAccountRouteArgs> {
  EditAccountRoute({
    Key? key,
    required int accountId,
    required String initialName,
    List<PageRouteInfo>? children,
  }) : super(
         EditAccountRoute.name,
         args: EditAccountRouteArgs(
           key: key,
           accountId: accountId,
           initialName: initialName,
         ),
         initialChildren: children,
       );

  static const String name = 'EditAccountRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<EditAccountRouteArgs>();
      return EditAccountScreen(
        key: args.key,
        accountId: args.accountId,
        initialName: args.initialName,
      );
    },
  );
}

class EditAccountRouteArgs {
  const EditAccountRouteArgs({
    this.key,
    required this.accountId,
    required this.initialName,
  });

  final Key? key;

  final int accountId;

  final String initialName;

  @override
  String toString() {
    return 'EditAccountRouteArgs{key: $key, accountId: $accountId, initialName: $initialName}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! EditAccountRouteArgs) return false;
    return key == other.key &&
        accountId == other.accountId &&
        initialName == other.initialName;
  }

  @override
  int get hashCode => key.hashCode ^ accountId.hashCode ^ initialName.hashCode;
}

/// generated route for
/// [ExpensesPage]
class ExpensesRoute extends PageRouteInfo<void> {
  const ExpensesRoute({List<PageRouteInfo>? children})
    : super(ExpensesRoute.name, initialChildren: children);

  static const String name = 'ExpensesRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ExpensesPage();
    },
  );
}

/// generated route for
/// [HomeWrapperPage]
class HomeWrapperRoute extends PageRouteInfo<void> {
  const HomeWrapperRoute({List<PageRouteInfo>? children})
    : super(HomeWrapperRoute.name, initialChildren: children);

  static const String name = 'HomeWrapperRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const HomeWrapperPage();
    },
  );
}

/// generated route for
/// [IncomePage]
class IncomeRoute extends PageRouteInfo<void> {
  const IncomeRoute({List<PageRouteInfo>? children})
    : super(IncomeRoute.name, initialChildren: children);

  static const String name = 'IncomeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const IncomePage();
    },
  );
}

/// generated route for
/// [PinCodeScreen]
class PinCodeRoute extends PageRouteInfo<PinCodeRouteArgs> {
  PinCodeRoute({
    Key? key,
    required PinCodeMode mode,
    String? title,
    VoidCallback? onSuccess,
    List<PageRouteInfo>? children,
  }) : super(
         PinCodeRoute.name,
         args: PinCodeRouteArgs(
           key: key,
           mode: mode,
           title: title,
           onSuccess: onSuccess,
         ),
         initialChildren: children,
       );

  static const String name = 'PinCodeRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<PinCodeRouteArgs>();
      return PinCodeScreen(
        key: args.key,
        mode: args.mode,
        title: args.title,
        onSuccess: args.onSuccess,
      );
    },
  );
}

class PinCodeRouteArgs {
  const PinCodeRouteArgs({
    this.key,
    required this.mode,
    this.title,
    this.onSuccess,
  });

  final Key? key;

  final PinCodeMode mode;

  final String? title;

  final VoidCallback? onSuccess;

  @override
  String toString() {
    return 'PinCodeRouteArgs{key: $key, mode: $mode, title: $title, onSuccess: $onSuccess}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! PinCodeRouteArgs) return false;
    return key == other.key &&
        mode == other.mode &&
        title == other.title &&
        onSuccess == other.onSuccess;
  }

  @override
  int get hashCode =>
      key.hashCode ^ mode.hashCode ^ title.hashCode ^ onSuccess.hashCode;
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [TransactionAnalysScreen]
class TransactionAnalysRoute extends PageRouteInfo<TransactionAnalysRouteArgs> {
  TransactionAnalysRoute({
    Key? key,
    required bool isIncome,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionAnalysRoute.name,
         args: TransactionAnalysRouteArgs(key: key, isIncome: isIncome),
         initialChildren: children,
       );

  static const String name = 'TransactionAnalysRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionAnalysRouteArgs>();
      return TransactionAnalysScreen(key: args.key, isIncome: args.isIncome);
    },
  );
}

class TransactionAnalysRouteArgs {
  const TransactionAnalysRouteArgs({this.key, required this.isIncome});

  final Key? key;

  final bool isIncome;

  @override
  String toString() {
    return 'TransactionAnalysRouteArgs{key: $key, isIncome: $isIncome}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionAnalysRouteArgs) return false;
    return key == other.key && isIncome == other.isIncome;
  }

  @override
  int get hashCode => key.hashCode ^ isIncome.hashCode;
}

/// generated route for
/// [TransactionHistoryPage]
class TransactionHistoryRoute
    extends PageRouteInfo<TransactionHistoryRouteArgs> {
  TransactionHistoryRoute({
    Key? key,
    required bool isIncome,
    List<PageRouteInfo>? children,
  }) : super(
         TransactionHistoryRoute.name,
         args: TransactionHistoryRouteArgs(key: key, isIncome: isIncome),
         initialChildren: children,
       );

  static const String name = 'TransactionHistoryRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<TransactionHistoryRouteArgs>();
      return TransactionHistoryPage(key: args.key, isIncome: args.isIncome);
    },
  );
}

class TransactionHistoryRouteArgs {
  const TransactionHistoryRouteArgs({this.key, required this.isIncome});

  final Key? key;

  final bool isIncome;

  @override
  String toString() {
    return 'TransactionHistoryRouteArgs{key: $key, isIncome: $isIncome}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! TransactionHistoryRouteArgs) return false;
    return key == other.key && isIncome == other.isIncome;
  }

  @override
  int get hashCode => key.hashCode ^ isIncome.hashCode;
}
