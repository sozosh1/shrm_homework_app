import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.onSurface,
          BlendMode.srcIn,
        ),
      ),
      label: label,
    );
  }
}
