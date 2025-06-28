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
/// [TransactionAnalysPage]
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
      return TransactionAnalysPage(key: args.key, isIncome: args.isIncome);
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
