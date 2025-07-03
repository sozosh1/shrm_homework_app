import 'package:flutter/material.dart';

/// Configuration class for the transaction pie chart
class TransactionChartConfig {
  /// Chart dimensions
  final double radius;
  final double centerSpaceRadius;
  
  /// Animation settings
  final Duration animationDuration;
  final Curve animationCurve;
  
  /// Visual appearance
  final bool showLegend;
  final bool showTooltips;
  final bool showCenterText;
  final TextStyle? centerTextStyle;
  final EdgeInsets legendPadding;
  final double sectionGap;
  
  /// Text overflow handling
  final int maxCategoryNameLength;
  final TextOverflow legendTextOverflow;
  
  /// Colors
  final List<Color> colorPalette;
  final Color backgroundColor;
  final Color tooltipBackgroundColor;
  final TextStyle? tooltipTextStyle;

  const TransactionChartConfig({
    this.radius = 100.0,
    this.centerSpaceRadius = 40.0,
    this.animationDuration = const Duration(milliseconds: 1000),
    this.animationCurve = Curves.easeInOut,
    this.showLegend = true,
    this.showTooltips = true,
    this.showCenterText = false,
    this.centerTextStyle,
    this.legendPadding = const EdgeInsets.all(8.0),
    this.sectionGap = 2.0,
    this.maxCategoryNameLength = 20,
    this.legendTextOverflow = TextOverflow.ellipsis,
    this.colorPalette = const [
      Color(0xFF6C63FF), // Purple
      Color(0xFF50C878), // Emerald
      Color(0xFFFF6B6B), // Coral
      Color(0xFFFFD93D), // Golden
      Color(0xFF6BCF7F), // Mint
      Color(0xFFFF8C42), // Orange
      Color(0xFF9B59B6), // Amethyst
      Color(0xFF3498DB), // Sky Blue
      Color(0xFFE74C3C), // Red
      Color(0xFFF39C12), // Orange Yellow
      Color(0xFF2ECC71), // Green
      Color(0xFFE67E22), // Carrot
      Color(0xFF8E44AD), // Wisteria
      Color(0xFF1ABC9C), // Turquoise
      Color(0xFFF1C40F), // Sun Flower
    ],
    this.backgroundColor = Colors.transparent,
    this.tooltipBackgroundColor = const Color(0xFF37474F),
    this.tooltipTextStyle,
  });

  /// Creates a copy of this config with the given parameters overridden
  TransactionChartConfig copyWith({
    double? radius,
    double? centerSpaceRadius,
    Duration? animationDuration,
    Curve? animationCurve,
    bool? showLegend,
    bool? showTooltips,
    bool? showCenterText,
    TextStyle? centerTextStyle,
    EdgeInsets? legendPadding,
    double? sectionGap,
    int? maxCategoryNameLength,
    TextOverflow? legendTextOverflow,
    List<Color>? colorPalette,
    Color? backgroundColor,
    Color? tooltipBackgroundColor,
    TextStyle? tooltipTextStyle,
  }) {
    return TransactionChartConfig(
      radius: radius ?? this.radius,
      centerSpaceRadius: centerSpaceRadius ?? this.centerSpaceRadius,
      animationDuration: animationDuration ?? this.animationDuration,
      animationCurve: animationCurve ?? this.animationCurve,
      showLegend: showLegend ?? this.showLegend,
      showTooltips: showTooltips ?? this.showTooltips,
      showCenterText: showCenterText ?? this.showCenterText,
      centerTextStyle: centerTextStyle ?? this.centerTextStyle,
      legendPadding: legendPadding ?? this.legendPadding,
      sectionGap: sectionGap ?? this.sectionGap,
      maxCategoryNameLength: maxCategoryNameLength ?? this.maxCategoryNameLength,
      legendTextOverflow: legendTextOverflow ?? this.legendTextOverflow,
      colorPalette: colorPalette ?? this.colorPalette,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      tooltipBackgroundColor: tooltipBackgroundColor ?? this.tooltipBackgroundColor,
      tooltipTextStyle: tooltipTextStyle ?? this.tooltipTextStyle,
    );
  }
}

/// Data model for a single chart section
class ChartSectionData {
  final String categoryName;
  final double value;
  final double percentage;
  final String? categoryIcon;
  final Color? customColor;

  const ChartSectionData({
    required this.categoryName,
    required this.value,
    required this.percentage,
    this.categoryIcon,
    this.customColor,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ChartSectionData &&
          runtimeType == other.runtimeType &&
          categoryName == other.categoryName &&
          value == other.value &&
          percentage == other.percentage &&
          categoryIcon == other.categoryIcon &&
          customColor == other.customColor;

  @override
  int get hashCode =>
      categoryName.hashCode ^
      value.hashCode ^
      percentage.hashCode ^
      categoryIcon.hashCode ^
      customColor.hashCode;
}