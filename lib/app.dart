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
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.primaryGreen),
        useMaterial3: true,
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
  final PageController _pageController = PageController(initialPage: 1);

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primaryGreen,
        title: const Text(
          'Ало бизнес, да да деньги',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Placeholder(),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/expense.svg',
              width: 24,
              height: 24,

              colorFilter: ColorFilter.mode(
                _selectedIndex == 0
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),

            label: 'Расходы',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/income.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 1
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            label: 'Доходы',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/account.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 2
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            label: 'Счет',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/article.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 3
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            label: 'Статьи',
          ),
          BottomNavigationBarItem(
            icon: SvgPicture.asset(
              'assets/icons/settings.svg',
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(
                _selectedIndex == 4
                    ? AppColors.primaryGreen
                    : AppColors.textDark,
                BlendMode.srcIn,
              ),
            ),
            label: 'Настройки',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primaryGreen,
        unselectedItemColor: AppColors.textDark,
        backgroundColor: AppColors.whiteBackground,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
      ),
      backgroundColor: AppColors.lightBackground,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
