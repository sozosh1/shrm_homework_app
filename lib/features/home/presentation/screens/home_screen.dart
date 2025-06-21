import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shrm_homework_app/config/router/app_router.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1; // Начинаем с доходов

  final List<PageRouteInfo> _routes = [
    const ExpensesRoute(),
    const IncomeRoute(),
    const AccountRoute(),
    const ArticlesRoute(),
    const SettingsRoute(),
  ];

  void _onItemTapped(int index) {
    if (_selectedIndex != index) {
      setState(() {
        _selectedIndex = index;
      });
      // Навигация к выбранному экрану
      context.router.replace(_routes[index]);
    }
  }

  @override
  void initState() {
    super.initState();
    // Навигация к начальному экрану (доходы)
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.router.replace(_routes[_selectedIndex]);
    });
  }

  void didChangeTabRoute(TabPageRoute route, TabPageRoute? previousRoute) {
    // Обновляем выбранный индекс при изменении роута
    final routeName = route.name;
    switch (routeName) {
      case 'ExpensesRoute':
        _selectedIndex = 0;
        break;
      case 'IncomeRoute':
        _selectedIndex = 1;
        break;
      case 'AccountRoute':
        _selectedIndex = 2;
        break;
      case 'ArticlesRoute':
        _selectedIndex = 3;
        break;
      case 'SettingsRoute':
        _selectedIndex = 4;
        break;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const AutoRouter(), // Здесь будут отображаться дочерние роуты
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _onItemTapped,
        destinations: [
          CustomNavigationDestination(
            iconPath: 'assets/icons/expense.svg',
            label: 'Расходы',
            isSelected: _selectedIndex == 0,
          ),
          CustomNavigationDestination(
            iconPath: 'assets/icons/income.svg',
            label: 'Доходы',
            isSelected: _selectedIndex == 1,
          ),
          CustomNavigationDestination(
            iconPath: 'assets/icons/account.svg',
            label: 'Счет',
            isSelected: _selectedIndex == 2,
          ),
          CustomNavigationDestination(
            iconPath: 'assets/icons/article.svg',
            label: 'Статьи',
            isSelected: _selectedIndex == 3,
          ),
          CustomNavigationDestination(
            iconPath: 'assets/icons/settings.svg',
            label: 'Настройки',
            isSelected: _selectedIndex == 4,
          ),
        ],
      ),
    );
  }
}

class CustomNavigationDestination extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;

  const CustomNavigationDestination({
    super.key,
    required this.iconPath,
    required this.label,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return NavigationDestination(
      icon: SvgPicture.asset(
        iconPath,
        width: 24,
        height: 24,
        colorFilter: ColorFilter.mode(
          isSelected
              ? AppColors.primaryGreen
              : Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
