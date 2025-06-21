import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shrm_homework_app/features/home/presentation/screens/home_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/transactions_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:shrm_homework_app/placeholder_screens/placeholder_screens.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    // Главный экран с навигацией
    AutoRoute(
      page: HomeWrapperRoute.page,
      path: '/',
      initial: true,
      children: [
        AutoRoute(page: ExpensesRoute.page, path: 'expenses'),
        AutoRoute(page: IncomeRoute.page, path: 'income'),
        AutoRoute(page: AccountRoute.page, path: 'account'),
        AutoRoute(page: ArticlesRoute.page, path: 'articles'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
    // Экран истории транзакций
    AutoRoute(page: TransactionHistoryRoute.page, path: '/transaction-history'),
  ];
}

// Обертка для главного экрана с навигацией
@RoutePage()
class HomeWrapperPage extends StatelessWidget {
  const HomeWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const MyHomePage();
  }
}

// Страницы для каждой вкладки
@RoutePage()
class ExpensesPage extends StatelessWidget {
  const ExpensesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsScreen(isIncome: false);
  }
}

@RoutePage()
class IncomePage extends StatelessWidget {
  const IncomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const TransactionsScreen(isIncome: true);
  }
}

@RoutePage()
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const AccountScreen();
  }
}

@RoutePage()
class ArticlesPage extends StatelessWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ArticlesScreen();
  }
}

@RoutePage()
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SettingsScreen();
  }
}

@RoutePage()
class TransactionHistoryPage extends StatelessWidget {
  final bool isIncome;

  const TransactionHistoryPage({super.key, required this.isIncome});

  @override
  Widget build(BuildContext context) {
    return TransactionHistoryScreen(isIncome: isIncome);
  }
}
