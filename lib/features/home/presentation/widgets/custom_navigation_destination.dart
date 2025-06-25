import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shrm_homework_app/config/theme/app_colors.dart';

class CustomNavigationDestination extends StatelessWidget {
  final String iconPath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final VoidCallback onDoubleTap;

  const CustomNavigationDestination({
    super.key,
    required this.iconPath,
    required this.label,
    required this.isSelected,
    required this.onTap,
    required this.onDoubleTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      onDoubleTap: onDoubleTap,
      child: NavigationDestination(
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
      ),
    );
  }
}
