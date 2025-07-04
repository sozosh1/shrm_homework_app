import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';
import 'package:shrm_homework_app/features/account/presentation/screens/account_screen.dart';
import 'package:shrm_homework_app/features/account/presentation/screens/edit_account_screen.dart';
import 'package:shrm_homework_app/features/category/presentation/screens/category_screen.dart';
import 'package:shrm_homework_app/features/home/presentation/widgets/custom_navigation_destination.dart';

import 'package:shrm_homework_app/features/transaction/domain/models/category_analysis_item.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/category_transactions.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/transaction_analys_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/transactions_screen.dart';
import 'package:shrm_homework_app/features/transaction/presentation/screens/transaction_history_screen.dart';
import 'package:shrm_homework_app/placeholder_screens/placeholder_screens.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(
      path: '/',
      page: HomeWrapperRoute.page,
      initial: true,
      children: [
        AutoRoute(page: ExpensesRoute.page, path: 'expenses', initial: true),
        AutoRoute(page: IncomeRoute.page, path: 'income'),
        AutoRoute(page: AccountRoute.page, path: 'account'),
        AutoRoute(page: ArticlesRoute.page, path: 'articles'),
        AutoRoute(page: SettingsRoute.page, path: 'settings'),
      ],
    ),
    AutoRoute(
      page: TransactionHistoryRoute.page,
      path: '/transaction-history',
      fullscreenDialog: true,
    ),
    AutoRoute(page: TransactionAnalysRoute.page),
    AutoRoute(page: CategoryTransactionsRoute.page),
    AutoRoute(page: EditAccountRoute.page),
  ];
}

@RoutePage()
class HomeWrapperPage extends StatelessWidget {
  const HomeWrapperPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        ExpensesRoute(),
        IncomeRoute(),
        AccountRoute(),
        ArticlesRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);

        return Scaffold(
          body: child,
          bottomNavigationBar: NavigationBar(
            backgroundColor: AppColors.lightBackground,
            selectedIndex: tabsRouter.activeIndex,
            onDestinationSelected: tabsRouter.setActiveIndex,
            destinations: [
              CustomNavigationDestination(
                iconPath: 'assets/icons/expense.svg',
                label: 'Расходы',
                isSelected: tabsRouter.activeIndex == 0,
              ),
              CustomNavigationDestination(
                iconPath: 'assets/icons/income.svg',
                label: 'Доходы',
                isSelected: tabsRouter.activeIndex == 1,
              ),
              CustomNavigationDestination(
                iconPath: 'assets/icons/account.svg',
                label: 'Счет',
                isSelected: tabsRouter.activeIndex == 2,
              ),
              CustomNavigationDestination(
                iconPath: 'assets/icons/article.svg',
                label: 'Статьи',
                isSelected: tabsRouter.activeIndex == 3,
              ),
              CustomNavigationDestination(
                iconPath: 'assets/icons/settings.svg',
                label: 'Настройки',
                isSelected: tabsRouter.activeIndex == 4,
              ),
            ],
          ),
        );
      },
    );
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
    return CategoriesScreen();
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
