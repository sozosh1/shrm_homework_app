import 'package:flutter/material.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

import 'package:flutter_svg/flutter_svg.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FINANCE app',
      theme: ThemeData(
        colorScheme: ColorScheme.light(
          primary: AppColors.primaryGreen,
          onPrimary: Colors.white,
          primaryContainer: AppColors.lightGreenBackground,
          onPrimaryContainer: AppColors.textDark,
          secondary: AppColors.lightPurpleBackground,
          onSecondary: AppColors.textDark,
          surface: AppColors.whiteBackground,
          onSurface: AppColors.textDark,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryGreen,
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.whiteBackground,
          indicatorColor: AppColors.lightGreenBackground,
        ),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Ало бизнес, да да деньги')),
      body: Center(
        child: Image.asset('assets/images/meme.png', width: 200, height: 200),
      ),
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
